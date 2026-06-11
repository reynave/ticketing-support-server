const { randomUUID } = require('crypto');
const bcrypt = require('bcryptjs');
const { pool } = require('../../config/db');

const INTERNAL_USER_TYPE_ID = 1;
const EXTERNAL_USER_TYPE_ID = 2;

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

function parseUserTypeId(value) {
  const userTypeId = Number(value);

  if (![INTERNAL_USER_TYPE_ID, EXTERNAL_USER_TYPE_ID].includes(userTypeId)) {
    const error = new Error('userTypeId must be 1 (Internal) or 2 (External)');
    error.statusCode = 400;
    throw error;
  }

  return userTypeId;
}

function parseClientId(value) {
  const clientId = Number(value);

  if (!Number.isInteger(clientId) || clientId < 0) {
    const error = new Error('clientId must be an integer greater than or equal to 0');
    error.statusCode = 400;
    throw error;
  }

  return clientId;
}

function buildDeletedEmail(email, userId) {
  const randomPart = `${Date.now()}${Math.floor(Math.random() * 1000000)}`;
  const source = String(email || '').trim() || `${userId || 'user'}@deleted.local`;
  return `delete.${randomPart}.${source}`;
}

async function assertClientExists(clientId) {
  const [rows] = await pool.execute(
    'SELECT id FROM client WHERE id = ? AND presence = 1 LIMIT 1',
    [clientId]
  );

  if (!rows[0]) {
    const error = new Error('Client not found or inactive');
    error.statusCode = 404;
    throw error;
  }
}

function normalizeClientIdInput(clientIdInput) {
  if (clientIdInput === undefined || clientIdInput === null || clientIdInput === '') {
    return null;
  }

  return parseClientId(clientIdInput);
}

async function resolveClientIdByUserType(userTypeId, clientIdInput, currentClientId = null) {
  const parsedInput = normalizeClientIdInput(clientIdInput);

  if (userTypeId === INTERNAL_USER_TYPE_ID) {
    if (parsedInput !== null && parsedInput !== 0) {
      const error = new Error('Internal user must use clientId = 0');
      error.statusCode = 400;
      throw error;
    }

    return 0;
  }

  const candidateClientId = parsedInput === null ? currentClientId : parsedInput;

  if (!Number.isInteger(candidateClientId) || candidateClientId <= 0) {
    const error = new Error('External user must provide a valid clientId > 0');
    error.statusCode = 400;
    throw error;
  }

  await assertClientExists(candidateClientId);
  return candidateClientId;
}

async function getUserForUpdate(id) {
  const [rows] = await pool.execute(
    `
      SELECT id, email, clientId, userTypeId
      FROM user
      WHERE id = ? AND presence = 1
      LIMIT 1
    `,
    [id]
  );

  const user = rows[0];

  if (!user) {
    const error = new Error('User not found');
    error.statusCode = 404;
    throw error;
  }

  return user;
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

  if (filters.userTypeId !== undefined) {
    conditions.push('userTypeId = ?');
    params.push(Number(filters.userTypeId));
  }

  if (filters.keyword) {
    conditions.push('(id LIKE ? OR email LIKE ? OR firstName LIKE ? OR lastName LIKE ?)');
    params.push(`%${filters.keyword}%`, `%${filters.keyword}%`, `%${filters.keyword}%`, `%${filters.keyword}%`);
  }

  const whereClause = `WHERE ${conditions.join(' AND ')}`;
  const [rows] = await pool.execute(
    `
      SELECT
        id, email, clientId, userTypeId, authlevelId, firstName, lastName, phone, mobile,
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
        id, email, clientId, userTypeId, authlevelId, firstName, lastName, phone, mobile,
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
  const required = ['email', 'password', 'authlevelId', 'firstName', 'userTypeId'];
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
  const userTypeId = parseUserTypeId(payload.userTypeId);
  const clientId = await resolveClientIdByUserType(userTypeId, payload.clientId, null);

  await pool.execute(
    `
      INSERT INTO user (
        id, email, clientId, userTypeId, password, authlevelId, firstName, lastName,
        phone, mobile, birthday, status, presence, inputDate, inputBy, updateDate, updateBy
      )
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 1, NOW(), 1, NOW(), 1)
    `,
    [
      id,
      payload.email,
      clientId,
      userTypeId,
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
  const currentUser = await getUserForUpdate(id);
  const fields = [];
  const params = [];

  if (payload.email !== undefined) {
    await assertEmailUnique(payload.email, id);
    fields.push('email = ?');
    params.push(payload.email);
  }

  if (payload.clientId !== undefined) {
    // clientId will be validated and set after userTypeId evaluation.
  }

  let nextUserTypeId = currentUser.userTypeId;

  if (payload.userTypeId !== undefined) {
    nextUserTypeId = parseUserTypeId(payload.userTypeId);
    fields.push('userTypeId = ?');
    params.push(nextUserTypeId);
  }

  if (nextUserTypeId === null || nextUserTypeId === undefined) {
    const error = new Error('userTypeId is required for existing user data');
    error.statusCode = 400;
    throw error;
  }

  if (payload.clientId !== undefined || payload.userTypeId !== undefined) {
    const resolvedClientId = await resolveClientIdByUserType(
      nextUserTypeId,
      payload.clientId,
      currentUser.clientId
    );
    fields.push('clientId = ?');
    params.push(resolvedClientId);
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
  const user = await getUserForUpdate(id);
  const deletedEmail = buildDeletedEmail(user.email, user.id);

  const [result] = await pool.execute(
    `
      UPDATE user
      SET email = ?, status = 0, presence = 0, updateDate = NOW(), updateBy = 1
      WHERE id = ? AND presence = 1
    `,
    [deletedEmail, id]
  );

  if (!result.affectedRows) {
    const error = new Error('User not found');
    error.statusCode = 404;
    throw error;
  }

  return { id, email: deletedEmail };
}

async function listExternalUsersByClient(clientId) {
  await assertClientExists(clientId);

  const [rows] = await pool.execute(
    `
      SELECT
        id, email, clientId, userTypeId, authlevelId, firstName, lastName, phone, mobile,
        birthday, status, presence, inputDate, inputBy, updateDate, updateBy
      FROM user
      WHERE presence = 1 AND userTypeId = ? AND clientId = ?
      ORDER BY inputDate DESC
    `,
    [EXTERNAL_USER_TYPE_ID, clientId]
  );

  return rows;
}

async function createExternalUserForClient(clientId, payload = {}) {
  const normalizedClientId = parseClientId(clientId);

  return createUser({
    ...payload,
    clientId: normalizedClientId,
    userTypeId: EXTERNAL_USER_TYPE_ID,
  });
}

module.exports = {
  INTERNAL_USER_TYPE_ID,
  EXTERNAL_USER_TYPE_ID,
  listUsers,
  getUserDetail,
  createUser,
  updateUser,
  deleteUser,
  listExternalUsersByClient,
  createExternalUserForClient,
};
