const { pool } = require('../../config/db');

function parseNumeric(value, fallback = null) {
  if (value === undefined || value === null || value === '') {
    return fallback;
  }

  return Number(value);
}

function validateTinyInt(fieldName, value) {
  if (!Number.isInteger(value) || value < 0 || value > 127) {
    const error = new Error(`${fieldName} must be an integer between 0 and 127`);
    error.statusCode = 400;
    throw error;
  }
}

function validateStatus(value) {
  if (![0, 1].includes(value)) {
    const error = new Error('status must be 0 or 1');
    error.statusCode = 400;
    throw error;
  }
}

async function listClients(filters = {}) {
  const conditions = ['presence = 1'];
  const params = [];

  if (filters.status !== undefined) {
    conditions.push('status = ?');
    params.push(Number(filters.status));
  }

  if (filters.industryId !== undefined) {
    conditions.push('IndustryId = ?');
    params.push(Number(filters.industryId));
  }

  if (filters.keyword) {
    conditions.push('(code LIKE ? OR name LIKE ?)');
    params.push(`%${filters.keyword}%`, `%${filters.keyword}%`);
  }

  const whereClause = `WHERE ${conditions.join(' AND ')}`;
  const [rows] = await pool.execute(
    `SELECT * FROM client ${whereClause} ORDER BY id ASC`,
    params
  );

  return rows;
}

async function getClientDetail(id) {
  const [rows] = await pool.execute(
    'SELECT * FROM client WHERE id = ? AND presence = 1 LIMIT 1',
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

  validateTinyInt('IndustryId', industryId);
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
    validateTinyInt('IndustryId', industryId);
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
  const [result] = await pool.execute(
    `
      UPDATE client
      SET presence = 0, updateDate = NOW(), updateBy = 1
      WHERE id = ? AND presence = 1
    `,
    [id]
  );

  if (!result.affectedRows) {
    const error = new Error('Client not found');
    error.statusCode = 404;
    throw error;
  }

  return { id: Number(id) };
}

module.exports = {
  listClients,
  getClientDetail,
  createClient,
  updateClient,
  deleteClient,
};
