const { pool } = require('../../config/db');

async function listProjectsForClient(filters = {}) {
  const conditions = ['p.presence = 1'];
  const params = [String(filters.userId || '')];

  if (filters.status !== undefined && String(filters.status).trim() !== '') {
    conditions.push('p.status = ?');
    params.push(Number(filters.status));
  }

  if (filters.keyword) {
    conditions.push('(p.id LIKE ? OR p.name LIKE ? OR c.name LIKE ?)');
    params.push(`%${filters.keyword}%`, `%${filters.keyword}%`, `%${filters.keyword}%`);
  }

  const q = `
    SELECT
      p.*,
      c.name AS clientName,
      pt.name AS projectTypeName,
      pb.name AS projectBilleableName,
      pr.name AS productName,
      pt.ticketBased,
      (SELECT IFNULL(SUM(ticketIn - ticketOut), 0) FROM ticket_balance WHERE projectId = p.id AND presence = 1) AS ticketBalance
    FROM project p
    INNER JOIN project_contact pc ON pc.projectId = p.id AND pc.userId = ? AND pc.presence = 1
    LEFT JOIN client c ON c.id = p.clientId
    LEFT JOIN project_type pt ON pt.id = p.projectTypeId
    LEFT JOIN project_billeable pb ON pb.id = p.projectBilleableId
    LEFT JOIN product pr ON pr.id = p.productId
    WHERE ${conditions.join(' AND ')}
    ORDER BY p.inputDate DESC
  `;

  const [rows] = await pool.execute(q, params);

  // Lampirkan member internal projek (untuk referensi assign)
  const [users] = await pool.execute(
    `
      SELECT p.projectId, p.userId, CONCAT(c.firstName, ' ', c.lastName) AS name, p.asManager
      FROM project_users p
      LEFT JOIN user c ON c.id = p.userId
      WHERE p.presence = 1
    `
  );
  const projectUsersMap = {};
  for (const user of users) {
    if (!projectUsersMap[user.projectId]) {
      projectUsersMap[user.projectId] = [];
    }
    projectUsersMap[user.projectId].push({
      id: user.userId,
      name: user.name,
      asManager: user.asManager === 1,
    });
  }

  // Lampirkan module product (child product) yang cocok dengan product projek
  const [products] = await pool.execute(
    `
      SELECT p.parentId AS productId, p.id, p.name
      FROM product AS p
      WHERE p.presence = 1 AND p.status = 1 AND p.parentId > 0
    `
  );

  for (const project of rows) {
    project.users = projectUsersMap[project.id] || [];
    project.modules = products.filter(
      (product) => product.productId === project.productId
    );
  }

  return rows;
}

async function getProjectDetail(id) {
  const [rows] = await pool.execute(
    `
      SELECT
        p.*,
        c.name AS clientName,
        pt.name AS projectTypeName,
        pb.name AS projectBilleableName,
        pr.name AS productName,
        pt.ticketBased
      FROM project p
      LEFT JOIN client c ON c.id = p.clientId
      LEFT JOIN project_type pt ON pt.id = p.projectTypeId
      LEFT JOIN project_billeable pb ON pb.id = p.projectBilleableId
      LEFT JOIN product pr ON pr.id = p.productId
      WHERE p.id = ? AND p.presence = 1
      LIMIT 1
    `,
    [id]
  );

  const row = rows[0];

  if (!row) {
    const error = new Error('Project not found');
    error.statusCode = 404;
    throw error;
  }

  const [contacts] = await pool.execute(
    `
      SELECT p.id, p.userId, CONCAT(u.firstName, ' ', u.lastName) AS name,
        u.phone, u.email, p.projectId, u.division, u.position
      FROM project_contact AS p
      LEFT JOIN user AS u ON u.id = p.userId
      WHERE p.presence = 1 AND p.projectId = ?
    `,
    [id]
  );
  row.contacts = contacts;

  return row;
}

async function canClientAccessProject(projectId, userId) {
  const [rows] = await pool.execute(
    `
      SELECT 1
      FROM project_contact
      WHERE presence = 1 AND projectId = ? AND userId = ?
      LIMIT 1
    `,
    [String(projectId), String(userId)]
  );

  return rows.length > 0;
}

module.exports = {
  listProjectsForClient,
  getProjectDetail,
  canClientAccessProject,
};