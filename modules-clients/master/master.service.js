const { pool } = require('../../config/db');

async function listStatusCases() {
  const [rows] = await pool.execute(
    'SELECT id, name FROM ticket_status WHERE issues = 1 AND presence = 1 ORDER BY id ASC'
  );

  return rows;
}

async function listTicketSeverities() {
  const [rows] = await pool.execute(
    'SELECT * FROM ticket_severity WHERE presence = 1 ORDER BY id ASC'
  );

  return rows;
}

module.exports = {
  listStatusCases,
  listTicketSeverities,
};