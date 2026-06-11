const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { pool } = require('../../config/db');

function buildUserPayload(user) {
  return {
    id: user.id,
    name: [user.firstName, user.lastName].filter(Boolean).join(' ').trim(),
    email: user.email,
    authlevelId: user.authlevelId,
    clientId: user.clientId,
    userTypeId: user.userTypeId,
  };
}

async function login(email, password) {
  const [rows] = await pool.execute(
    `
      SELECT id, email, clientId, userTypeId, password, authlevelId, firstName, lastName
      FROM user
      WHERE email = ? AND status = 1 AND presence = 1 AND clientId = 0
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
      SELECT id, email, clientId, userTypeId, authlevelId, firstName, lastName
      FROM user
      WHERE id = ? AND status = 1 AND presence = 1 AND clientId = 0
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

module.exports = {
  login,
  getMe,
};
