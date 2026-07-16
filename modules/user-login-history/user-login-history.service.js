const { pool } = require('../../config/db');

async function listUserLoginHistory(filters = {}) {
  const conditions = ['h.presence = 1'];
  const params = [];

  if (filters.userId !== undefined && String(filters.userId).trim() !== '') {
    conditions.push('h.userId = ?');
    params.push(String(filters.userId).trim());
  }

  if (filters.keyword) {
    conditions.push('(h.userId LIKE ? OR CONCAT(u.firstName, " ", u.lastName) LIKE ? OR h.ipAddress LIKE ? OR h.userAgent LIKE ?)');
    params.push(
      `%${filters.keyword}%`,
      `%${filters.keyword}%`,
      `%${filters.keyword}%`,
      `%${filters.keyword}%`
    );
  }

  const whereClause = conditions.length ? `WHERE ${conditions.join(' AND ')}` : '';

  const [rows] = await pool.execute(
    `
      SELECT
        h.id,
        h.userId,
        CONCAT(u.firstName, ' ', u.lastName) AS userName,
        h.loginTime,
        h.ipAddress,
        h.userAgent,
        h.inputDate,
        h.inputBy,
        h.updateDate,
        h.updateBy
      FROM user_login_history h
      LEFT JOIN user u ON u.id = h.userId
      ${whereClause}
      ORDER BY h.loginTime DESC, h.id DESC
    `,
    params
  );

  return rows;
}

module.exports = {
  listUserLoginHistory,
};
