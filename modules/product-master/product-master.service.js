const { pool } = require('../../config/db');

function parseId(id) {
  const parsed = Number(id);

  if (!Number.isInteger(parsed) || parsed < 1) {
    const error = new Error('Invalid product id');
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

  if (payload.status !== undefined) {
    data.status = parseStatus(payload.status);
  }

  return data;
}

async function listProducts(filters = {}) {
  const conditions = ['p.presence = 1'];
  const params = [];

  if (filters.status !== undefined && filters.status !== '') {
    conditions.push('p.status = ?');
    params.push(parseStatus(filters.status));
  }

  if (filters.parentId !== undefined && filters.parentId !== '') {
    conditions.push('p.parentId = ?');
    params.push(parseNumeric(filters.parentId, 'parentId'));
  }

  if (filters.keyword) {
    const keyword = String(filters.keyword).trim();

    if (keyword) {
      conditions.push('(p.name LIKE ? OR parent.name LIKE ?)');
      params.push(`%${keyword}%`, `%${keyword}%`);
    }
  }

  const whereClause = conditions.length ? `WHERE ${conditions.join(' AND ')}` : '';

  const [rows] = await pool.execute(
    `
      SELECT
        p.*,
        parent.name AS parentName
      FROM product p
      LEFT JOIN product parent ON parent.id = p.parentId AND parent.presence = 1
      ${whereClause}
      ORDER BY p.parentId ASC, p.name ASC, p.id ASC
    `,
    params
  );

  return rows;
}

async function getProductDetail(id) {
  const safeId = parseId(id);

  const [rows] = await pool.execute(
    `
      SELECT
        p.*,
        parent.name AS parentName
      FROM product p
      LEFT JOIN product parent ON parent.id = p.parentId AND parent.presence = 1
      WHERE p.id = ? AND p.presence = 1
      LIMIT 1
    `,
    [safeId]
  );

  const row = rows[0];

  if (!row) {
    const error = new Error('Product not found');
    error.statusCode = 404;
    throw error;
  }

  return row;
}

async function createProduct(payload, actorId = 1) {
  const data = normalizeCreatePayload(payload || {});

  const [result] = await pool.execute(
    `
      INSERT INTO product (
        parentId, name, status,
        presence, inputDate, inputBy, updateDate, updateBy
      )
      VALUES (?, ?, ?, 1, NOW(), ?, NOW(), ?)
    `,
    [
      data.parentId,
      data.name,
      data.status,
      Number(actorId) || 1,
      Number(actorId) || 1,
    ]
  );

  return getProductDetail(result.insertId);
}

async function updateProduct(id, payload, actorId = 1) {
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
      UPDATE product
      SET ${setClause}, updateDate = NOW(), updateBy = ?
      WHERE id = ? AND presence = 1
    `,
    [...values, Number(actorId) || 1, safeId]
  );

  if (!result.affectedRows) {
    const error = new Error('Product not found');
    error.statusCode = 404;
    throw error;
  }

  return getProductDetail(safeId);
}

async function deleteProduct(id, actorId = 1) {
  const safeId = parseId(id);

  const [result] = await pool.execute(
    `
      UPDATE product
      SET presence = 0, updateDate = NOW(), updateBy = ?
      WHERE id = ? AND presence = 1
    `,
    [Number(actorId) || 1, safeId]
  );

  if (!result.affectedRows) {
    const error = new Error('Product not found');
    error.statusCode = 404;
    throw error;
  }

  return { id: safeId };
}

module.exports = {
  listProducts,
  getProductDetail,
  createProduct,
  updateProduct,
  deleteProduct,
};
