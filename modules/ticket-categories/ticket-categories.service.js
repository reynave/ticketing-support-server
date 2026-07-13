const { pool } = require('../../config/db');

function parseId(id) {
  const parsed = Number(id);

  if (!Number.isInteger(parsed) || parsed < 1) {
    const error = new Error('Invalid ticket category id');
    error.statusCode = 400;
    throw error;
  }

  return parsed;
}

function parseNumeric(value, fieldName) {
  const parsed = Number(value);

  if (!Number.isFinite(parsed)) {
    const error = new Error(`${fieldName} must be a valid number`);
    error.statusCode = 400;
    throw error;
  }

  return parsed;
}

function parseStatus(value) {
  const status = Number(value);

  if (![0, 1].includes(status)) {
    const error = new Error('status must be 0 or 1');
    error.statusCode = 400;
    throw error;
  }

  return status;
}

function normalizeCreatePayload(payload) {
  const name = String(payload.name || '').trim();

  if (!name) {
    const error = new Error('name is required');
    error.statusCode = 400;
    throw error;
  }

  return {
    name,
    parentId: payload.parentId === undefined ? 0 : parseNumeric(payload.parentId, 'parentId'),
    weight: payload.weight === undefined ? 0 : parseNumeric(payload.weight, 'weight'),
    status: payload.status === undefined ? 1 : parseStatus(payload.status),
  };
}

function normalizeUpdatePayload(payload) {
  const data = {};

  if (payload.name !== undefined) {
    const value = String(payload.name).trim();

    if (!value) {
      const error = new Error('name cannot be empty');
      error.statusCode = 400;
      throw error;
    }

    data.name = value;
  }

  if (payload.parentId !== undefined) {
    data.parentId = parseNumeric(payload.parentId, 'parentId');
  }

  if (payload.weight !== undefined) {
    data.weight = parseNumeric(payload.weight, 'weight');
  }

  if (payload.status !== undefined) {
    data.status = parseStatus(payload.status);
  }

  return data;
}

async function listTicketCategories(filters = {}) {
  const conditions = ['tc.presence = 1'];
  const params = [];

  if (filters.status !== undefined && filters.status !== '') {
    conditions.push('tc.status = ?');
    params.push(parseStatus(filters.status));
  }

  if (filters.parentId !== undefined && filters.parentId !== '') {
    conditions.push('tc.parentId = ?');
    params.push(parseNumeric(filters.parentId, 'parentId'));
  }

  if (filters.keyword) {
    const keyword = String(filters.keyword).trim();

    if (keyword) {
      conditions.push('(tc.name LIKE ? OR parent.name LIKE ?)');
      params.push(`%${keyword}%`, `%${keyword}%`);
    }
  }

  const whereClause = conditions.length ? `WHERE ${conditions.join(' AND ')}` : '';

  const [rows] = await pool.execute(
    `
      SELECT
        tc.id, tc.name, tc.parentId, tc.weight, tc.status
      FROM ticket_categories  tc
      ${whereClause} and tc.parentId = 0
      ORDER BY tc.parentId ASC, tc.weight ASC, tc.id ASC
    `,
    params
  );


  const [rows2] = await pool.execute(
    `
      SELECT
        tc.id, tc.name, tc.parentId, tc.weight, tc.status
      FROM ticket_categories  tc
      ${whereClause} and tc.parentId > 0
      ORDER BY tc.parentId ASC, tc.weight ASC, tc.id ASC
    `,
    params
  );

  for (const parent of rows) {
    parent.children = rows2.filter(child => child.parentId === parent.id);
  }
  

  return rows;
}

async function getTicketCategoryDetail(id) {
  const safeId = parseId(id);

  const [rows] = await pool.execute(
    `
      SELECT
        tc.*,
        parent.name AS parentName
      FROM ticket_categories tc
      LEFT JOIN ticket_categories parent ON parent.id = tc.parentId AND parent.presence = 1
      WHERE tc.id = ? AND tc.presence = 1
      LIMIT 1
    `,
    [safeId]
  );

  const row = rows[0];

  if (!row) {
    const error = new Error('Ticket category not found');
    error.statusCode = 404;
    throw error;
  }

  return row;
}

async function createTicketCategory(payload, actorId = 1) {
  const data = normalizeCreatePayload(payload || {});

  const [result] = await pool.execute(
    `
      INSERT INTO ticket_categories (
        name, parentId, weight, status,
        presence, inputDate, inputBy, updateDate, updateBy
      )
      VALUES (?, ?, ?, ?, 1, NOW(), ?, NOW(), ?)
    `,
    [
      data.name,
      data.parentId,
      data.weight,
      data.status,
      Number(actorId) || 1,
      Number(actorId) || 1,
    ]
  );

  return getTicketCategoryDetail(result.insertId);
}

async function updateTicketCategory(id, payload, actorId = 1) {
  const safeId = parseId(id);
  const data = normalizeUpdatePayload(payload || {});
  const fields = Object.keys(data);

  if (!fields.length) {
    const error = new Error('No valid fields provided');
    error.statusCode = 400;
    throw error;
  }

  const setClause = fields.map((field) => `${field} = ?`).join(', ');
  const values = fields.map((field) => data[field]);

  const [result] = await pool.execute(
    `
      UPDATE ticket_categories
      SET ${setClause}, updateDate = NOW(), updateBy = ?
      WHERE id = ? AND presence = 1
    `,
    [...values, Number(actorId) || 1, safeId]
  );

  if (!result.affectedRows) {
    const error = new Error('Ticket category not found');
    error.statusCode = 404;
    throw error;
  }

  return getTicketCategoryDetail(safeId);
}

async function deleteTicketCategory(id, actorId = 1) {
  const safeId = parseId(id);

  const [result] = await pool.execute(
    `
      UPDATE ticket_categories
      SET presence = 0, updateDate = NOW(), updateBy = ?
      WHERE id = ? AND presence = 1
    `,
    [Number(actorId) || 1, safeId]
  );

  if (!result.affectedRows) {
    const error = new Error('Ticket category not found');
    error.statusCode = 404;
    throw error;
  }

  return { id: safeId };
}

module.exports = {
  listTicketCategories,
  getTicketCategoryDetail,
  createTicketCategory,
  updateTicketCategory,
  deleteTicketCategory,
};
