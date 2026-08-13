const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { pool } = require('../../config/db');

function buildUserPayload(user) {
  return {
    id: user.id,
    name: [user.firstName, user.lastName].filter(Boolean).join(' ').trim(),
    email: user.email,
    userAuthLevelId: user.userAuthLevelId,
    clientId: user.clientId,
    userTypeId: user.userTypeId,
  };
}

async function login(email, password, ipAddress, userAgent) {
  const [rows] = await pool.execute(
    `
      SELECT id, email, clientId, userTypeId, password, userAuthLevelId, firstName, lastName
      FROM user
      WHERE email = ? AND status = 1 AND presence = 1 AND userTypeId = 2
      LIMIT 1
    `,
    [email]
  );

  const user = rows[0];

  if (!user) {
    const error = new Error('Email or password is invalid');
    error.statusCode = 401;
    throw error;
  }

  const passwordMatch = await bcrypt.compare(password, user.password || '');

  if (!passwordMatch) {
    const error = new Error('Email or password is invalid');
    error.statusCode = 401;
    throw error;
  }

  const loginTime = new Date();

  await pool.execute(
    `
      INSERT INTO user_login_history (userId, loginTime, ipAddress, userAgent)
      VALUES (?, ?, ?, ?)
    `,
    [user.id, loginTime, ipAddress, userAgent]
  );

  const payload = buildUserPayload(user);
  const token = jwt.sign(payload, process.env.JWT_SECRET || 'change-this-secret', {
    expiresIn: process.env.JWT_EXPIRES_IN || '8h',
  });

  return {
    token,
    user: payload,
  };
}

async function getMe(userId) {
  const [rows] = await pool.execute(
    `
      SELECT id, email, clientId, userTypeId, userAuthLevelId, firstName, lastName
      FROM user
      WHERE id = ? AND status = 1 AND presence = 1 AND userTypeId = 2
      LIMIT 1
    `,
    [userId]
  );

  const user = rows[0];

  if (!user) {
    const error = new Error('User not found');
    error.statusCode = 404;
    throw error;
  }

  return buildUserPayload(user);
}

async function assertEmailUnique(email, exceptUserId) {
  const [rows] = await pool.execute('SELECT id FROM user WHERE email = ? LIMIT 1', [email]);
  const existing = rows[0];

  if (existing && existing.id !== exceptUserId) {
    const error = new Error('Email already exists');
    error.statusCode = 409;
    throw error;
  }
}

async function getProfile(userId) {
  const [rows] = await pool.execute(
    `
      SELECT id, email, clientId, userTypeId, firstName, lastName, phone, mobile, birthday, division, position
      FROM user
      WHERE id = ? AND status = 1 AND presence = 1 AND userTypeId = 2
      LIMIT 1
    `,
    [userId]
  );

  const user = rows[0];

  if (!user) {
    const error = new Error('User not found');
    error.statusCode = 404;
    throw error;
  }

  return user;
}

async function updateProfile(userId, payload) {
  await getProfile(userId);

  const fields = [];
  const params = [];

  if (payload.email !== undefined) {
    const email = String(payload.email).trim();

    if (!email) {
      const error = new Error('Email is required');
      error.statusCode = 400;
      throw error;
    }

    await assertEmailUnique(email, userId);
    fields.push('email = ?');
    params.push(email);
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

  if (payload.division !== undefined) {
    fields.push('division = ?');
    params.push(payload.division);
  }

  if (payload.position !== undefined) {
    fields.push('position = ?');
    params.push(payload.position);
  }

  if (payload.password) {
    const passwordHash = await bcrypt.hash(String(payload.password), 4);
    fields.push('password = ?');
    params.push(passwordHash);
  }

  if (!fields.length) {
    return getProfile(userId);
  }

  fields.push('updateDate = NOW()');
  params.push(userId);

  await pool.execute(
    `UPDATE user SET ${fields.join(', ')} WHERE id = ?`,
    params
  );

  return getProfile(userId);
}

module.exports = {
  login,
  getMe,
  getProfile,
  updateProfile,
};
