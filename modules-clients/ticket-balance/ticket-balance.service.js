const { pool } = require('../../config/db');

function assertProjectId(projectId) {
  if (!projectId || !String(projectId).trim()) {
    const error = new Error('projectId is required');
    error.statusCode = 400;
    throw error;
  }

  return String(projectId).trim();
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

async function listByProject(projectId) {
  const normalizedProjectId = assertProjectId(projectId);

  const [rows] = await pool.execute(
    `
      SELECT tb.id, tb.projectId, tb.date, tb.ticketIn, tb.ticketOut, 0 as balance, t.title, tb.note, tb.ticketId, tb.ticketId AS caseId, t.ticketTypeId
      FROM ticket_balance as tb
      LEFT JOIN ticket as t on tb.ticketId = t.id
      WHERE tb.projectId = ? AND tb.presence = 1
      ORDER BY tb.date ASC
      LIMIT 100
    `,
    [normalizedProjectId]
  );

  let balance = 0;
  for (const row of rows) {
    balance += row.ticketIn - row.ticketOut;
    row.balance = balance;
  }

  rows.reverse();

  return rows;
}

module.exports = {
  canClientAccessProject,
  listByProject,
};