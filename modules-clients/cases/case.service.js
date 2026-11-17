const { pool } = require('../../config/db');
const { runningNumber } = require('../../helpers/autoNumber');

const CASE_TYPE_ID = 2;

function parseNonNegativeNumber(value, fieldName) {
  const parsed = Number(value);

  if (!Number.isFinite(parsed) || parsed < 0) {
    const error = new Error(`${fieldName} must be a non-negative number`);
    error.statusCode = 400;
    throw error;
  }

  return parsed;
}

function parseOptionalNumber(value, fieldName) {
  if (value === undefined || value === null || value === '') {
    return null;
  }

  return parseNonNegativeNumber(value, fieldName);
}

async function buildTicketId(inputId) {
  if (inputId && String(inputId).trim()) {
    return String(inputId).trim();
  }

  return runningNumber('issue');
}

function normalizeCreatePayload(payload) {
  return {
    ticketTypeId: CASE_TYPE_ID,
    title: String(payload.title || '').trim(),
    description: String(payload.description || '').trim(),
    projectId: String(payload.projectId).trim(),
    submitBy: payload.submitBy,
    submitDate: payload.submitDate,
    targetCompletionDate: payload.targetCompletionDate,
    assignTo: payload.assignTo,
    actualCompletionDate: payload.actualCompletionDate || payload.targetCompletionDate,
    ticketStatusId: parseNonNegativeNumber(payload.ticketStatusId, 'ticketStatusId'),
    ticketCategoryId: payload.ticketCategoryId !== undefined
      ? parseOptionalNumber(payload.ticketCategoryId, 'ticketCategoryId')
      : null,
    severityId: payload.severityId !== undefined ? parseOptionalNumber(payload.severityId, 'severityId') : null,
  };
}

async function listTicketsForClient(filters = {}) {
  const conditions = ['t.ticketTypeId = 2', 't.ticketStatusId <= 900', 't.presence = 1'];
  const params = [String(filters.userId || '')];

  if (filters.keyword) {
    conditions.push('(t.id LIKE ? OR t.title LIKE ? OR t.crNoRef LIKE ? OR t.issueNo LIKE ?)');
    params.push(`%${filters.keyword}%`, `%${filters.keyword}%`, `%${filters.keyword}%`, `%${filters.keyword}%`);
  }

  const whereClause = conditions.join(' AND ');

  const q = `
    SELECT t.id, t.projectId, a.userId, t.title, t.assignTo, CONCAT(u.firstName,' ',u.lastName) AS assignToName,
    a.name AS projectName, t.ticketSeverityId,
    s.name AS ticketSeverityName, t.ticketStatusId, ts.name AS ticketStatusName, t.submitDate
    FROM ticket AS t
    INNER JOIN (
      SELECT c.id, c.userId, c.projectId, p.name AS name
      FROM project_contact AS c
      LEFT JOIN project AS p ON p.id = c.projectId
      WHERE c.userId = ? AND p.presence = 1 AND c.presence = 1
    ) AS a ON a.projectId = t.projectId
    LEFT JOIN ticket_severity AS s ON s.id = t.ticketSeverityId
    LEFT JOIN user AS u ON u.id = t.assignTo
    LEFT JOIN ticket_status AS ts ON ts.id = t.ticketStatusId
    WHERE ${whereClause} and t.ticketStatusId < 900
    ORDER BY t.inputDate DESC
  `;

  const [rows] = await pool.execute(q, params);

  return rows;
}

async function listTicketsForClientClosed(filters = {}) {
  const conditions = ['t.ticketTypeId = 2', 't.presence = 1'];
  const params = [String(filters.userId || '')];

  if (filters.keyword) {
    conditions.push('(t.id LIKE ? OR t.title LIKE ? OR t.crNoRef LIKE ? OR t.issueNo LIKE ?)');
    params.push(`%${filters.keyword}%`, `%${filters.keyword}%`, `%${filters.keyword}%`, `%${filters.keyword}%`);
  }

  const whereClause = conditions.join(' AND ');

  const q = `
    SELECT
      t.id, t.projectId, a.userId, t.title, t.assignTo, CONCAT(u.firstName,' ',u.lastName) AS assignToName,
      a.name AS projectName, t.ticketSeverityId,
      s.name AS ticketSeverityName, t.ticketStatusId, ts.name AS ticketStatusName,
      t.submitDate, t.rating, t.ratesBy
    FROM ticket AS t
    INNER JOIN (
      SELECT c.id, c.userId, c.projectId, p.name AS name
      FROM project_contact AS c
      LEFT JOIN project AS p ON p.id = c.projectId
      WHERE c.userId = ? AND p.presence = 1 AND c.presence = 1
    ) AS a ON a.projectId = t.projectId
    LEFT JOIN ticket_severity AS s ON s.id = t.ticketSeverityId
    LEFT JOIN user AS u ON u.id = t.assignTo
    LEFT JOIN ticket_status AS ts ON ts.id = t.ticketStatusId
    WHERE ${whereClause} and t.ticketStatusId >= 900
    ORDER BY t.inputDate DESC
  `;

  const [rows] = await pool.execute(q, params);

  return rows;
}

async function listTicketsForClientUser(caseId, userId) {
  const [rows] = await pool.execute(
    `
      SELECT t.id, t.projectId, a.userId
      FROM ticket AS t
      INNER JOIN (
        SELECT c.id, c.userId, c.projectId, p.name AS name
        FROM project_contact AS c
        LEFT JOIN project AS p ON p.id = c.projectId
        WHERE c.userId = ? AND p.presence = 1 AND c.presence = 1
      ) AS a ON a.projectId = t.projectId
      LEFT JOIN user AS u ON u.id = t.assignTo
      WHERE t.ticketTypeId = 2 AND t.presence = 1 AND t.id = ?
      LIMIT 1
    `,
    [String(userId || ''), String(caseId || '')]
  );

  return rows;
}

async function getTicketDetail(id) {
  const [rows] = await pool.execute(
    `
      SELECT t.*,
        tt.name AS ticketTypeName,
        ts.name AS ticketStatusName,
        d.name AS productName, c.name AS clientName, pt.name AS projectType, pt.ticketBased, p.name as projectName,
        CONCAT(u.firstName, ' ',u.lastName) AS 'submitByName',
        tc.name as 'ticketCategory', p2.name as 'productChildName',
        0 as taskCount,
        ts2.name AS ticketSeverityName, ts2.color AS color,
        concat(u2.firstName, ' ', u2.lastName) AS 'assignToName',
        '' AS 'ratesDetail',

        CASE t.lockTime
           WHEN 1 THEN t.responseHour
           ELSE (SELECT duration
          FROM ticket_solution_time
          order by duration ASC
          LIMIT 1)
        END AS 'addHour',

        0 as 'allowVerification',
        '' as 'ticketSolutionTime'

        FROM ticket t
        LEFT JOIN ticket_type tt ON tt.id = t.ticketTypeId
        LEFT JOIN ticket_status ts ON ts.id = t.ticketStatusId
        LEFT JOIN project AS p ON p.id = t.projectId
        LEFT JOIN product AS d ON d.id = p.productId
        LEFT JOIN client AS c ON c.id = p.clientId
        LEFT JOIN project_type AS pt ON pt.id = p.projectTypeId
        LEFT JOIN user AS u ON u.id = t.submitBy
        left join user as u2 on u2.id = t.assignTo
        left join ticket_categories as tc on t.ticketCategoryId = tc.id
        left join product as p2 on p2.id = t.productChildId
        left join ticket_severity as ts2 on ts2.id = t.ticketSeverityId
      WHERE t.id = ? AND t.presence = 1 AND t.ticketTypeId = ?
      LIMIT 1
    `,
    [id, CASE_TYPE_ID]
  );

  const row = rows[0];

  if (!row) {
    const error = new Error('Ticket not found');
    error.statusCode = 404;
    throw error;
  }

  const [taskCountRows] = await pool.execute(
    `
      SELECT COUNT(1) AS taskCount
      FROM ticket
      WHERE presence = 1 AND ticketTypeId = 1 AND issueNo = ? and ticketStatusId < 900
    `,
    [id]
  );
  row.taskCount = taskCountRows[0].taskCount;

  const [allowVerificationRows] = await pool.execute(
    `
      SELECT COUNT(id) AS taskCount
      FROM ticket
      WHERE presence = 1 AND ticketTypeId = 1 AND issueNo = ? and ticketStatusId < 900
    `,
    [id]
  );
  row.allowVerification = allowVerificationRows[0].taskCount > 0 ? 0 : 1;

  const [ratesDetail] = await pool.execute(
    `
      SELECT tr.value, tr.id, r.name
      FROM ticket_rating AS tr
      LEFT JOIN rating AS r ON r.id = tr.ratingId
      WHERE tr.ticketId = ?
    `,
    [id]
  );
  row.ratesDetail = ratesDetail;

  const [categoryRows] = await pool.execute(
    `
      SELECT p.ticketCategoriesParentId, c.name
      FROM project AS p
      LEFT JOIN ticket_categories AS c ON c.id = p.ticketCategoriesParentId
      WHERE p.id = ?
    `,
    [rows[0]?.projectId]
  );

  if (categoryRows.length > 0) {
    rows[0].ParentCategoryName = categoryRows[0].name;
    rows[0].ticketCategoriesParentId = categoryRows[0].ticketCategoriesParentId;
  }

  const [ticketSolutionTime] = await pool.execute(
    `
      SELECT *
      FROM ticket_solution_time
      order by duration ASC
    `,
    [id]
  );
  row.ticketSolutionTime = ticketSolutionTime;

  return row;
}

async function getTicketLogs(id) {
  const [rows] = await pool.execute(
    `
      SELECT t.*,
        CONCAT(u.firstName, ' ', u.lastName) AS 'inputName',
        CONCAT(u2.firstName, ' ', u2.lastName) AS 'updateName',
        t.parentId, t2.description as 'replyFrom'
      FROM ticket_logs AS t
      LEFT JOIN user AS u ON u.id = t.inputBy
      LEFT JOIN user AS u2 ON u2.id = t.updateBy
      left join ticket_logs as t2 on t2.id = t.parentId
      WHERE t.presence = 1 AND t.ticketId = ?
      ORDER BY t.inputDate DESC
    `,
    [id]
  );

  const [rowsImgs] = await pool.execute(
    `
      SELECT *
      FROM ticket_logs_attachments
      WHERE ticketId = ?
      ORDER BY id ASC
    `,
    [id]
  );

  const logs = rows.map((log) => ({
    ...log,
    attachments: rowsImgs.filter((img) => img.ticketLogId === log.id),
  }));

  return logs;
}
async function createTicket(payload) {
  const data = normalizeCreatePayload(payload);
  const generatedId = await buildTicketId(payload.id);

  const q = `
    INSERT INTO ticket (
      id, ticketTypeId, title, description, projectId,
      submitBy, submitDate, targetCompletionDate, assignTo,
      actualCompletionDate, ticketStatusId, ticketCategoryId,
      ticketSeverityId,
      presence, inputDate, inputBy, updateDate, updateBy,
      deadlineDateTime,
      productChildId
    )
    VALUES (
      ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?,
      1, NOW(), '1', NOW(), '1',
      ?, ?
    )
  `;

  const params = [
    generatedId,
    data.ticketTypeId,
    data.title,
    data.description,
    data.projectId,
    data.submitBy,
    data.submitDate,
    data.targetCompletionDate,
    data.assignTo,
    data.actualCompletionDate,
    1,
    data.ticketCategoryId,
    data.severityId,
    payload.deadlineDateTime,
    payload.productChildId,
  ];

  await pool.execute(q, params);

  return getTicketDetail(generatedId);
}

async function updateCaseStatusByClient(id, ticketStatusId, submitBy) {
  const parsedStatusId = parseNonNegativeNumber(ticketStatusId, 'ticketStatusId');

  const [rows] = await pool.execute(
    `
      SELECT id, ticketStatusId, projectId, assignTo, ticketEstimationCost
      FROM ticket
      WHERE id = ? AND presence = 1 AND ticketTypeId = ?
      LIMIT 1
    `,
    [id, CASE_TYPE_ID]
  );

  const ticket = rows[0];

  if (!ticket) {
    const error = new Error('Case not found');
    error.statusCode = 404;
    throw error;
  }

  const [result] = await pool.execute(
    `
      UPDATE ticket
      SET ticketStatusId = ?, actualCompletionDate = NOW(), updateDate = NOW(), updateBy = ?
      WHERE id = ? AND presence = 1 AND ticketTypeId = ?
    `,
    [parsedStatusId, submitBy, id, CASE_TYPE_ID]
  );

  if (!result.affectedRows) {
    const error = new Error('Case not found');
    error.statusCode = 404;
    throw error;
  }

  if (ticket.ticketStatusId !== parsedStatusId) {
    const [statusNames] = await pool.execute(
      `
      SELECT id, name FROM ticket_status WHERE id = ?
      UNION
      SELECT id, name FROM ticket_status WHERE id = ?
    `,
      [ticket.ticketStatusId, parsedStatusId]
    );

    const description =
      'Update Status from <strong>' + statusNames[0]?.name + '</strong> To <strong>' + statusNames[1]?.name + '</strong>';

    await pool.execute(
      `
        INSERT INTO ticket_logs (
          ticketId, description, starDateTime, closeDateTime,
          presence, inputDate, inputBy, updateDate, updateBy
        )
        VALUES (?, ?, IFNULL(?, NOW()), IFNULL(?, NOW()), 1, NOW(), ?, NOW(), ?)
      `,
      [id, description, null, null, submitBy, submitBy]
    );

    if (parsedStatusId >= 900 && parsedStatusId < 990) {
      await pool.execute(
        `
          INSERT INTO ticket_balance (
            projectId, ticketId, ticketOut, date, inputDate, inputBy
          )
          VALUES (?, ?, ?, NOW(), NOW(), ?)
        `,
        [ticket.projectId, id, ticket.ticketEstimationCost || 0, submitBy]
      );
    }
  }

  return getTicketDetail(id);
}

module.exports = {
  listTicketsForClient,
  listTicketsForClientClosed,
  listTicketsForClientUser,
  getTicketDetail,
  getTicketLogs,
  createTicket,
  updateCaseStatusByClient,
};