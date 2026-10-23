const { pool } = require('../../config/db');

const TASK_TYPE_ID = 1;
const CASE_TYPE_ID = 2;
const CHANGE_REQUEST_TYPE_ID = 3;

/**
 * Tasks (ticketTypeId = 1) are always scoped to the assignee,
 * mirroring the `/ticket` list behavior.
 */
async function listTasks(userId) {
  const query = `
      SELECT
        t.id,
        t.title,
        t.ticketStatusId,
        t.sorting,
        ts.name AS ticketStatusName,
        p.name AS projectName,
        (SELECT pu.userId FROM project_users pu WHERE
          pu.userId = ? AND pu.projectId = t.projectId LIMIT 1) 'userId',
        (SELECT pu.asManager FROM project_users pu WHERE
          pu.userId = ? AND pu.projectId = t.projectId LIMIT 1) 'asManager',
        t.assignTo,
        CONCAT(u.firstName, ' ', u.lastName) AS 'assignToName'
      FROM ticket t
      LEFT JOIN ticket_status ts ON ts.id = t.ticketStatusId
      LEFT JOIN project p ON p.id = t.projectId
      LEFT JOIN user AS u ON u.id = t.assignTo
      WHERE
        t.presence = 1 AND t.ticketTypeId = ? AND t.ticketStatusId < 900
        AND (SELECT pu.userId FROM project_users pu WHERE
          pu.userId = ? AND pu.projectId = t.projectId LIMIT 1) = ?
      ORDER BY t.sorting ASC, t.inputDate DESC
    `;

  const [rows] = await pool.execute(query, [
    userId,
    userId,
    TASK_TYPE_ID,
    userId,
    userId,
  ]);

  return rows;
}

/**
 * Cases (ticketTypeId = 2) and Change Requests (ticketTypeId = 3).
 *
 * Admin users see every open record; client users only see records for
 * projects they are a contact of (mirrors `/cases` and `/change-requests`).
 */
async function listCasesAndChangeRequests(ticketTypeId, { userId }) {
  const query = `
      SELECT
        t.id,
        t.title,
        t.ticketStatusId,
        t.sorting,
        ts.name AS ticketStatusName,
        p.name AS projectName,
        (SELECT pu.userId FROM project_users pu WHERE
          pu.userId = ? AND pu.projectId = t.projectId LIMIT 1) 'userId',
        (SELECT pu.asManager FROM project_users pu WHERE
          pu.userId = ? AND pu.projectId = t.projectId LIMIT 1) 'asManager',
        t.assignTo,
        CONCAT(u.firstName, ' ', u.lastName) AS 'assignToName'
      FROM ticket t
      LEFT JOIN ticket_status ts ON ts.id = t.ticketStatusId
      LEFT JOIN project p ON p.id = t.projectId
      LEFT JOIN user AS u ON u.id = t.assignTo
      WHERE
        t.presence = 1 AND t.ticketTypeId = ? AND t.ticketStatusId < 900
        AND (SELECT pu.userId FROM project_users pu WHERE
          pu.userId = ? AND pu.projectId = t.projectId LIMIT 1) = ?
      ORDER BY t.sorting ASC, t.inputDate DESC
    `;

  const [rows] = await pool.execute(query, [
    userId,
    userId,
    ticketTypeId,
    userId,
    userId,
  ]);

  return rows;
}

async function listProjectUsers() {
  const query = `
      SELECT DISTINCT u.id, CONCAT(u.firstName, ' ', u.lastName) AS name
      FROM project_users pu
      INNER JOIN user u ON u.id = pu.userId
      WHERE pu.presence = 1 AND u.presence = 1
      ORDER BY name ASC
    `;

  const [rows] = await pool.execute(query);

  return rows;
}

async function getDashboard({ userId = '' } = {}) {
  const [tasks, cases, changeRequests] = await Promise.all([
    listTasks(userId),
    listCasesAndChangeRequests(CASE_TYPE_ID, { userId }),
    listCasesAndChangeRequests(CHANGE_REQUEST_TYPE_ID, { userId }),
  ]);

  return {
    totalOpenTasks: tasks.length,
    totalOpenCases: cases.length,
    totalOpenChangeRequests: changeRequests.length,
    tasks,
    cases,
    changeRequests,
  };
}

async function updateSorting(ticketTypeId, ids) {
  await Promise.all(
    ids.map((id, index) =>
      pool.execute(
        `UPDATE ticket
         SET sorting = ?, updateDate = NOW()
         WHERE id = ? AND ticketTypeId = ? AND presence = 1`,
        [index + 1, String(id), ticketTypeId],
      ),
    ),
  );

  return { updated: ids.length };
}

module.exports = {
  getDashboard,
  updateSorting,
  listProjectUsers,
};
