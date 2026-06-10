const { randomUUID } = require('crypto');
const bcrypt = require('bcryptjs');
const { pool } = require('../../config/db');

function buildUserId(inputId) {
  if (inputId && String(inputId).trim()) {
    return String(inputId).trim();
  }

  return `USR-${randomUUID().split('-')[0].toUpperCase()}`;
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

async function assertEmailUnique(email, exceptUserId = null) {
  if (!email) {
    return;
  }

  const [rows] = await pool.execute('SELECT id FROM user WHERE email = ? LIMIT 1', [email]);
  const user = rows[0];

  if (!user) {
    return;
  }

  if (exceptUserId && user.id === exceptUserId) {
    return;
  }

  const error = new Error('Email already exists');
  error.statusCode = 409;
  throw error;
}

async function listUsers(filters = {}) {
  const conditions = ['presence = 1'];
  const params = [];

  if (filters.status !== undefined) {
    conditions.push('status = ?');
    params.push(Number(filters.status));
  }

  if (filters.authlevelId !== undefined) {
    conditions.push('authlevelId = ?');
    params.push(Number(filters.authlevelId));
  }

  if (filters.clientId !== undefined) {
    conditions.push('clientId = ?');
    params.push(Number(filters.clientId));
  }

  if (filters.keyword) {
    conditions.push('(id LIKE ? OR email LIKE ? OR firstName LIKE ? OR lastName LIKE ?)');
    params.push(`%${filters.keyword}%`, `%${filters.keyword}%`, `%${filters.keyword}%`, `%${filters.keyword}%`);
  }

  const whereClause = `WHERE ${conditions.join(' AND ')}`;
  const [rows] = await pool.execute(
    `
      SELECT
        id, email, clientId, authlevelId, firstName, lastName, phone, mobile,
        birthday, status, presence, inputDate, inputBy, updateDate, updateBy
      FROM user
      ${whereClause}
      ORDER BY inputDate DESC
    `,
    params
  );

  return rows;
}

async function getUserDetail(id) {
  const [rows] = await pool.execute(
    `
      SELECT
        id, email, clientId, authlevelId, firstName, lastName, phone, mobile,
        birthday, status, presence, inputDate, inputBy, updateDate, updateBy
      FROM user
      WHERE id = ? AND presence = 1
      LIMIT 1
    `,
    [id]
  );

  const row = rows[0];

  if (!row) {
    const error = new Error('User not found');
    error.statusCode = 404;
    throw error;
  }

  return row;
}

async function createUser(payload) {
  const required = ['email', 'password', 'authlevelId', 'firstName'];
  const missing = required.filter((field) => payload[field] === undefined || payload[field] === null || payload[field] === '');

  if (missing.length) {
    const error = new Error(`Missing required fields: ${missing.join(', ')}`);
    error.statusCode = 400;
    throw error;
  }

  await assertEmailUnique(payload.email);

  const id = buildUserId(payload.id);
  const passwordHash = await bcrypt.hash(String(payload.password), 4);
  const status = payload.status === undefined ? 1 : parseStatus(payload.status);
  const birthday = payload.birthday || '2000-01-01';

  await pool.execute(
    `
      INSERT INTO user (
        id, email, clientId, password, authlevelId, firstName, lastName,
        phone, mobile, birthday, status, presence, inputDate, inputBy, updateDate, updateBy
      )
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 1, NOW(), 1, NOW(), 1)
    `,
    [
      id,
      payload.email,
      payload.clientId === undefined ? null : Number(payload.clientId),
      passwordHash,
      Number(payload.authlevelId),
      payload.firstName,
      payload.lastName || null,
      payload.phone || null,
      payload.mobile || null,
      birthday,
      status,
    ]
  );

  return getUserDetail(id);
}

async function updateUser(id, payload) {
  const fields = [];
  const params = [];

  if (payload.email !== undefined) {
    await assertEmailUnique(payload.email, id);
    fields.push('email = ?');
    params.push(payload.email);
  }

  if (payload.clientId !== undefined) {
    fields.push('clientId = ?');
    params.push(payload.clientId === null ? null : Number(payload.clientId));
  }

  if (payload.authlevelId !== undefined) {
    fields.push('authlevelId = ?');
    params.push(Number(payload.authlevelId));
  }

  if (payload.firstName !== undefined) {
    fields.push('firstName = ?');
    params.push(payload.firstName);
  }

  if (payload.lastName !== undefined) {
    fields.push('lastName = ?');
    params.push(payload.lastName);
  }

  if (payload.phone !== undefined) {
    fields.push('phone = ?');
    params.push(payload.phone);
  }

  if (payload.mobile !== undefined) {
    fields.push('mobile = ?');
    params.push(payload.mobile);
  }

  if (payload.birthday !== undefined) {
    fields.push('birthday = ?');
    params.push(payload.birthday);
  }

  if (payload.status !== undefined) {
    fields.push('status = ?');
    params.push(parseStatus(payload.status));
  }

  if (payload.password !== undefined) {
    const passwordHash = await bcrypt.hash(String(payload.password), 4);
    fields.push('password = ?');
    params.push(passwordHash);
  }

  if (!fields.length) {
    const error = new Error('No valid fields provided');
    error.statusCode = 400;
    throw error;
  }

  const [result] = await pool.execute(
    `
      UPDATE user
      SET ${fields.join(', ')}, updateDate = NOW(), updateBy = 1
      WHERE id = ? AND presence = 1
    `,
    [...params, id]
  );

  if (!result.affectedRows) {
    const error = new Error('User not found');
    error.statusCode = 404;
    throw error;
  }

  return getUserDetail(id);
}

async function deleteUser(id) {
  const [result] = await pool.execute(
    `
      UPDATE user
      SET presence = 0, updateDate = NOW(), updateBy = 1
      WHERE id = ? AND presence = 1
    `,
    [id]
  );

  if (!result.affectedRows) {
    const error = new Error('User not found');
    error.statusCode = 404;
    throw error;
  }

  return { id };
}

module.exports = {
  listUsers,
  getUserDetail,
  createUser,
  updateUser,
  deleteUser,
};
