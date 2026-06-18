const { pool } = require('../../config/db');
const userService = require('../user/user.service');

function parseNumeric(value, fallback = null) {
  if (value === undefined || value === null || value === '') {
    return fallback;
  }

  return Number(value);
}

function validateStatus(value) {
  if (![0, 1].includes(value)) {
    const error = new Error('status must be 0 or 1');
    error.statusCode = 400;
    throw error;
  }
}

function buildDeletedEmail(email, userId) {
  const randomPart = `${Date.now()}${Math.floor(Math.random() * 1000000)}`;
  const source = String(email || '').trim() || `${userId || 'user'}@deleted.local`;
  return `delete.${randomPart}.${source}`;
}

async function listClients(filters = {}) {
  const conditions = ['c.presence = 1'];
  const params = [];

  if (filters.status !== undefined) {
    conditions.push('c.status = ?');
    params.push(Number(filters.status));
  }

  if (filters.industryId !== undefined) {
    conditions.push('c.industryId = ?');
    params.push(Number(filters.industryId));
  }

  if (filters.keyword) {
    conditions.push('(c.code LIKE ? OR c.name LIKE ?)');
    params.push(`%${filters.keyword}%`, `%${filters.keyword}%`);
  }

  const whereClause = `WHERE ${conditions.join(' AND ')}`;
  const [rows] = await pool.execute(
    `
      SELECT 
        c.*, 
        i.name as industryName
      FROM client c
      LEFT JOIN industry i ON c.industryId = i.id
      ${whereClause}
      ORDER BY c.id ASC
    `,
    params
  );

  return rows;
}

async function listClientProjects(clientId) {
  const [rows] = await pool.execute(
    `
      SELECT
        p.*, 
        pt.name AS projectTypeName,
        pb.name AS projectBilleableName,
        pc.name AS projectCategoryName,
        pr.name AS productName
      FROM project p 
      LEFT JOIN project_type pt ON pt.id = p.projectTypeId
      LEFT JOIN project_billeable pb ON pb.id = p.projectBilleableId
      LEFT JOIN project_categories pc ON pc.id = p.projectCategoryId
      LEFT JOIN product pr ON pr.id = p.productId
      WHERE p.clientId = ? AND p.presence = 1
      ORDER BY p.id ASC
    `,
    [clientId]
  );

  return rows;
}
     
async function getClientDetail(id) {
  const [rows] = await pool.execute(
    `
      SELECT 
        c.*, 
        i.name as industryName
      FROM client c
      LEFT JOIN industry i ON c.industryId = i.id
      WHERE c.id = ? AND c.presence = 1
      LIMIT 1
    `,
    [id]
  );

  const row = rows[0];

  if (!row) {
    const error = new Error('Client not found');
    error.statusCode = 404;
    throw error;
  }

  return row;
}

async function createClient(payload) {
  if (!payload.code || !payload.name || !payload.address) {
    const error = new Error('Missing required fields: code, name, address');
    error.statusCode = 400;
    throw error;
  }

  const industryId = parseNumeric(payload.IndustryId, 0);
  const status = parseNumeric(payload.status, 1);

  validateStatus(status);

  const [result] = await pool.execute(
    `
      INSERT INTO client (code, name, address, IndustryId, status, presence, inputDate, inputBy, updateDate, updateBy)
      VALUES (?, ?, ?, ?, ?, 1, NOW(), 1, NOW(), 1)
    `,
    [payload.code, payload.name, payload.address, industryId, status]
  );

  return getClientDetail(result.insertId);
}

async function updateClient(id, payload) {
  const fields = [];
  const params = [];

  if (payload.code !== undefined) {
    fields.push('code = ?');
    params.push(payload.code);
  }

  if (payload.name !== undefined) {
    fields.push('name = ?');
    params.push(payload.name);
  }

  if (payload.address !== undefined) {
    fields.push('address = ?');
    params.push(payload.address);
  }

  if (payload.IndustryId !== undefined) {
    const industryId = Number(payload.IndustryId);
    fields.push('IndustryId = ?');
    params.push(industryId);
  }

  if (payload.status !== undefined) {
    const status = Number(payload.status);
    validateStatus(status);
    fields.push('status = ?');
    params.push(status);
  }

  if (!fields.length) {
    const error = new Error('No valid fields provided');
    error.statusCode = 400;
    throw error;
  }

  const [result] = await pool.execute(
    `
      UPDATE client
      SET ${fields.join(', ')}, updateDate = NOW(), updateBy = 1
      WHERE id = ? AND presence = 1
    `,
    [...params, id]
  );

  if (!result.affectedRows) {
    const error = new Error('Client not found');
    error.statusCode = 404;
    throw error;
  }

  return getClientDetail(id);
}

async function deleteClient(id) {
  const connection = await pool.getConnection();

  try {
    await connection.beginTransaction();

    const [clientRows] = await connection.execute(
      'SELECT id FROM client WHERE id = ? AND presence = 1 LIMIT 1',
      [id]
    );

    if (!clientRows[0]) {
      const error = new Error('Client not found');
      error.statusCode = 404;
      throw error;
    }

    const [users] = await connection.execute(
      `
        SELECT id, email
        FROM user
        WHERE clientId = ? AND presence = 1
      `,
      [id]
    );

    for (const user of users) {
      const deletedEmail = buildDeletedEmail(user.email, user.id);
      await connection.execute(
        `
          UPDATE user
          SET email = ?, status = 0, presence = 0, updateDate = NOW(), updateBy = 1
          WHERE id = ? AND presence = 1
        `,
        [deletedEmail, user.id]
      );
    }

    await connection.execute(
      `
        UPDATE client
        SET status = 0, presence = 0, updateDate = NOW(), updateBy = 1
        WHERE id = ? AND presence = 1
      `,
      [id]
    );

    await connection.commit();

    return {
      id: Number(id),
      deletedExternalUserCount: users.length,
    };
  } catch (error) {
    await connection.rollback();
    throw error;
  } finally {
    connection.release();
  }
}

async function listClientUsers(clientId) {
  return userService.listExternalUsersByClient(Number(clientId));
}

async function createClientUser(clientId, payload) {
  return userService.createExternalUserForClient(Number(clientId), payload);
}
async function removeClientProject(id, payload) {
  const fields = []; 
  const updateBy = payload.updateBy; // This should ideally come from the authenticated user context
  const params = [updateBy];
  const [result] = await pool.execute(
    `
      UPDATE project
      SET clientId = '', updateDate = NOW(), updateBy = ?, status = 0
      WHERE id = ? AND presence = 1
    `,
    [...params, payload.id]
  );

  if (!result.affectedRows) {
    const error = new Error('Project not found');
    error.statusCode = 404;
    throw error;
  }

  return getClientDetail(id);
}

module.exports = {
  listClients,
  getClientDetail,
  createClient,
  updateClient,
  deleteClient,
  listClientUsers,
  createClientUser,
  listClientProjects,
  removeClientProject
};
