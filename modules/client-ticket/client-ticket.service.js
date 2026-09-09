const { pool } = require('../../config/db');

const CASE_TYPE_ID = 2;
const CHANGE_REQUEST_TYPE_ID = 3;

async function listByType(ticketTypeId, filters = {}) {
  const conditions = ['t.ticketTypeId = ?', 't.presence = 1'];
  const params = [String(filters.userId || ''), ticketTypeId];

  if (filters.keyword) {
    conditions.push('(t.id LIKE ? OR t.title LIKE ? OR t.crNoRef LIKE ? OR t.issueNo LIKE ?)');
    params.push(`%${filters.keyword}%`, `%${filters.keyword}%`, `%${filters.keyword}%`, `%${filters.keyword}%`);
  }

  const whereClause = conditions.join(' AND ');

  const q = `
    SELECT t.id, t.projectId, t.title, t.submitDate, t.targetCompletionDate,
      t.ticketStatusId, ts.name AS ticketStatusName,
      t.assignTo, CONCAT(u.firstName, ' ', u.lastName) AS assignToName,
      a.name AS projectName
    FROM ticket AS t
    INNER JOIN (
      SELECT c.userId, c.projectId, p.name AS name
      FROM project_contact AS c
      LEFT JOIN project AS p ON p.id = c.projectId
      WHERE c.userId = ? AND p.presence = 1 AND c.presence = 1
    ) AS a ON a.projectId = t.projectId
    LEFT JOIN ticket_status AS ts ON ts.id = t.ticketStatusId
    LEFT JOIN user AS u ON u.id = t.assignTo
    WHERE ${whereClause}
    ORDER BY t.submitDate DESC
  `;

  const [rows] = await pool.execute(q, params);

  return rows;
}

async function listCases(filters = {}) {
  return listByType(CASE_TYPE_ID, filters);
}

async function listChangeRequests(filters = {}) {
  return listByType(CHANGE_REQUEST_TYPE_ID, filters);
}

async function getClientBalance({ projectId, userId }) {
  const q = `
    SELECT sum(ticketIn - ticketOut) AS balance
    FROM ticket_balance
    WHERE projectId = '${projectId}'  and  presence = 1
  `; 
  console.log('Query:', q);
  const [rows] = await pool.execute(q);
   
  const data = {
    balance: rows.length > 0 ? rows[0].balance : 0,
    note: rows.length > 0 && rows[0].balance < 0 ? 'Your Balance is not enough' : '',
  }
  return data;
}

module.exports = {
  listCases,
  listChangeRequests,
  getClientBalance,
};
