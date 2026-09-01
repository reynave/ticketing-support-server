const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { pool } = require('../../config/db');

async function getAccessRights(authLevelId) {
  const q =  `
      SELECT uar.moduleId, uar.c, uar.r, uar.u, uar.d, m.name as moduleName
      FROM user_access_right as uar
      left join module as m on uar.moduleId = m.id
      WHERE uar.authLevelId = ?  AND uar.presence = 1 AND uar.moduleId > 0
      ORDER BY m.name ASC
    `;
  const [rows] = await pool.execute(
   q,
    [Number(authLevelId) || 0]
  );

 
  return rows.map((row) => ({
    name: String(row.moduleName || ''),
    moduleId: Number(row.moduleId),
    c: Number(row.c),
    r: Number(row.r),
    u: Number(row.u),
    d: Number(row.d),
  }));
}

async function buildUserPayload(user) {
  return {
    id: user.id,
    name: [user.firstName, user.lastName].filter(Boolean).join(' ').trim(),
    email: user.email,
    userAuthLevelId: user.userAuthLevelId,
    clientId: user.clientId,
    userTypeId: user.userTypeId,
    accessRights: await getAccessRights(user.userAuthLevelId),
  };
}

async function login(email, password, ipAddress, userAgent) {
  const [rows] = await pool.execute(
    `
      SELECT id, email, clientId, userTypeId, password, userAuthLevelId, firstName, lastName
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

  const loginTime = new Date();

  await pool.execute(
    `
      INSERT INTO user_login_history (userId, loginTime, ipAddress, userAgent)
      VALUES (?, ?, ?, ?)
    `,
    [user.id, loginTime, ipAddress, userAgent]
  );

  const payload = await buildUserPayload(user);
  console.log('User payload:', payload);
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
