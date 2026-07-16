const { pool } = require('../../config/db');

function parseNonNegativeNumber(value, fieldName) {
  const parsed = Number(value);

  if (!Number.isFinite(parsed) || parsed < 0) {
    const error = new Error(`${fieldName} must be a non-negative number`);
    error.statusCode = 400;
    throw error;
  }

  return parsed;
}

function assertProjectId(projectId) {
  if (!projectId || !String(projectId).trim()) {
    const error = new Error('projectId is required');
    error.statusCode = 400;
    throw error;
  }

  return String(projectId).trim();
}

async function assertProjectExists(projectId) {
  const [rows] = await pool.execute('SELECT id FROM project WHERE id = ? AND presence = 1 LIMIT 1', [projectId]);

  if (!rows[0]) {
    const error = new Error('Project not found');
    error.statusCode = 404;
    throw error;
  }
}

async function listByProject(projectId) {
  const normalizedProjectId = assertProjectId(projectId);

  const [rows] = await pool.execute(
    `
      SELECT tb.id, tb.projectId, tb.date, tb.ticketIn, tb.ticketOut, 0 as balance, t.title , tb.note
      FROM ticket_balance as tb
      left join ticket as t on tb.ticketId = t.id
      WHERE tb.projectId = ? AND tb.presence = 1
      ORDER BY tb.date ASC
      limit 100 
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

async function listHistory(filters = {}) {
  const conditions = ['tb.presence = 1'];
  const params = [];

  if (filters.projectId !== undefined && String(filters.projectId).trim() !== '') {
    conditions.push('tb.projectId = ?');
    params.push(String(filters.projectId).trim());
  }

  if (filters.keyword) {
    conditions.push('(tb.projectId LIKE ? OR tb.ticketId LIKE ? OR tb.note LIKE ? OR t.title LIKE ? OR p.name LIKE ?)');
    params.push(
      `%${filters.keyword}%`,
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
        tb.id,
        tb.projectId,
        p.name AS projectName,
        tb.ticketId,
        t.title AS ticketTitle,
        tb.date,
        tb.ticketIn,
        tb.ticketOut,
        (tb.ticketIn - tb.ticketOut) AS balanceChange,
        tb.note,
        tb.inputDate,
        tb.inputBy,
        tb.updateDate,
        tb.updateBy
      FROM ticket_balance tb
      LEFT JOIN project p ON p.id = tb.projectId
      LEFT JOIN ticket t ON t.id = tb.ticketId
      ${whereClause}
      ORDER BY tb.date DESC, tb.id DESC
      LIMIT 500
    `,
    params
  );

  return rows;
}

async function getSummaryByProject(projectId) {
  const normalizedProjectId = assertProjectId(projectId);

  const [rows] = await pool.execute(
    `
      SELECT
        IFNULL(SUM(ticketIn), 0) AS totalTicketIn,
        IFNULL(SUM(ticketOut), 0) AS totalTicketOut,
        IFNULL(SUM(ticketIn), 0) - IFNULL(SUM(ticketOut), 0) AS balance
      FROM ticket_balance
      WHERE projectId = ? AND presence = 1
    `,
    [normalizedProjectId]
  );

  return {
    projectId: normalizedProjectId,
    totalTicketIn: Number(rows[0].totalTicketIn || 0),
    totalTicketOut: Number(rows[0].totalTicketOut || 0),
    balance: Number(rows[0].balance || 0),
  };
}

async function createTransaction(payload) {
  const projectId = assertProjectId(payload.projectId);
  await assertProjectExists(projectId);

  const ticketIn = payload.ticketIn === undefined ? 0 : parseNonNegativeNumber(payload.ticketIn, 'ticketIn');
  const ticketOut = payload.ticketOut === undefined ? 0 : parseNonNegativeNumber(payload.ticketOut, 'ticketOut');

  if (ticketIn === 0 && ticketOut === 0) {
    const error = new Error('ticketIn or ticketOut must be greater than 0');
    error.statusCode = 400;
    throw error;
  }

  const [result] = await pool.execute(
    `
      INSERT INTO ticket_balance (projectId, date, ticketIn, ticketOut, presence, inputDate, inputBy, updateDate, updateBy)
      VALUES (?, ?, ?, ?, 1, NOW(), 1, NOW(), 1)
    `,
    [projectId, payload.date || new Date(), ticketIn, ticketOut]
  );

  const [rows] = await pool.execute(
    `
      SELECT id, projectId, date, ticketIn, ticketOut, presence, inputDate, inputBy, updateDate, updateBy
      FROM ticket_balance
      WHERE id = ?
      LIMIT 1
    `,
    [result.insertId]
  );

  return rows[0];
}

module.exports = {
  listByProject,
  listHistory,
  getSummaryByProject,
  createTransaction,
};
