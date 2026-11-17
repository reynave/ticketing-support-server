const { pool } = require('../../config/db');

async function listTicketCategories(filters = {}) {
  const hasStatus = filters.status !== undefined && String(filters.status) !== '';
  const statusCondition = hasStatus ? 'AND tc.status = ?' : '';
  const statusParam = hasStatus ? [Number(filters.status)] : [];

  const [rows] = await pool.execute(
    `
      SELECT tc.id, tc.name, tc.parentId, tc.weight, tc.status, tc.sorting
      FROM ticket_categories tc
      WHERE tc.presence = 1 AND tc.parentId = 0 ${statusCondition}
      ORDER BY tc.sorting ASC
    `,
    statusParam
  );

  const [rows2] = await pool.execute(
    `
      SELECT tc.id, tc.name, tc.parentId, tc.weight, tc.status, tc.sorting
      FROM ticket_categories tc
      WHERE tc.presence = 1 AND tc.parentId > 0 ${statusCondition}
      ORDER BY tc.sorting ASC
    `,
    statusParam
  );

  for (const parent of rows) {
    parent.children = rows2.filter((child) => child.parentId === parent.id);
  }

  return rows;
}

module.exports = {
  listTicketCategories,
};