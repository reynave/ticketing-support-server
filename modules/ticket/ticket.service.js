const { pool } = require('../../config/db');
const { runningNumber } = require('../../helpers/autoNumber');

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

  return runningNumber('task');
}

function validateRequiredCreateFields(payload) {
  const requiredFields = [
    'ticketTypeId',
    'title',
    'description',
    'projectId',
    'submitBy',
    'submitDate',
    'targetCompletionDate',
    'assignTo',
    'ticketStatusId',
  ];

  const missing = requiredFields.filter((field) => payload[field] === undefined || payload[field] === null || payload[field] === '');

  if (missing.length) {
    const error = new Error(`Missing required fields: ${missing.join(', ')}`);
    error.statusCode = 400;
    throw error;
  }
}

function normalizeCreatePayload(payload) {
 
 
  return {
    ticketTypeId: parseNonNegativeNumber(payload.ticketTypeId, 'ticketTypeId'),
   
    title: String(payload.title || '').trim(),
    description: String(payload.description || '').trim(),
    projectId: String(payload.projectId).trim(),
    submitBy: payload.submitBy,
    submitDate: payload.submitDate,
    targetCompletionDate: payload.targetCompletionDate,
    assignTo: payload.assignTo, 
    actualCompletionDate: payload.actualCompletionDate || payload.targetCompletionDate,
    ticketStatusId: parseNonNegativeNumber(payload.ticketStatusId, 'ticketStatusId'),  
  };
}

async function listTickets(filters = {}) {
  const conditions = ['t.presence = 1'];
  const params = [];

  if (filters.projectId !== undefined) {
    conditions.push('t.projectId = ?');
    params.push(String(filters.projectId));
  }

  if (filters.ticketTypeId !== undefined) {
    conditions.push('t.ticketTypeId = ?');
    params.push(Number(filters.ticketTypeId));
  }

  if (filters.ticketStatusId !== undefined) {
    conditions.push('t.ticketStatusId = ?');
    params.push(Number(filters.ticketStatusId));
  }

  if (filters.assignTo !== undefined) {
    conditions.push('t.assignTo = ?');
    params.push(Number(filters.assignTo));
  }

  if (filters.keyword) {
    conditions.push('(t.id LIKE ? OR t.title LIKE ? OR t.crNoRef LIKE ? OR t.issueNo LIKE ?)');
    params.push(`%${filters.keyword}%`, `%${filters.keyword}%`, `%${filters.keyword}%`, `%${filters.keyword}%`);
  }

  const whereClause = `WHERE ${conditions.join(' AND ')}`;

  const [rows] = await pool.execute(
    `
      SELECT t.*,
        tt.name AS ticketTypeName,
        ts.name AS ticketStatusName
      FROM ticket t
      LEFT JOIN ticket_type tt ON tt.id = t.ticketTypeId
      LEFT JOIN ticket_status ts ON ts.id = t.ticketStatusId
      ${whereClause}
      ORDER BY t.inputDate DESC
    `,
    params
  );

  return rows;
}

async function getTicketDetail(id) {
  const [rows] = await pool.execute(
    `
      SELECT t.*,
        tt.name AS ticketTypeName,
        ts.name AS ticketStatusName,
        d.name AS productName, c.name AS clientName, pt.name AS projectType,
        CONCAT(u.firstName, ' ',u.lastName) AS 'submitByName'
        
FROM ticket t
LEFT JOIN ticket_type tt ON tt.id = t.ticketTypeId
LEFT JOIN ticket_status ts ON ts.id = t.ticketStatusId
LEFT JOIN project AS p ON p.id = t.projectId
LEFT JOIN product AS d ON d.id = p.productId
LEFT JOIN client AS c ON c.id = p.clientId
LEFT JOIN project_type AS pt ON pt.id = p.projectTypeId
LEFT JOIN user AS u ON u.id = t.submitBy
      WHERE t.id = ? AND t.presence = 1
      LIMIT 1
    `,
    [id]
  );

  const row = rows[0];

  if (!row) {
    const error = new Error('Ticket not found');
    error.statusCode = 404;
    throw error;
  }

  return row;
}
async function getTicketLogs(id) {
  const [rows] = await pool.execute(
    `
   SELECT t.* , 
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

  const row = rows;

  if (!row) {
    const error = new Error('Ticket not found');
    error.statusCode = 404;
    throw error;
  }

  return row;
}

async function createTicket(payload) {
  const data = normalizeCreatePayload(payload);
  const generatedId = await buildTicketId(payload.id);
  console.log('createTicket payload', data, 'generatedId:', generatedId);
  await pool.execute(
    `
      INSERT INTO ticket (
        id, ticketTypeId,  title, description, projectId,
        submitBy, submitDate, targetCompletionDate, assignTo, 
        actualCompletionDate, ticketStatusId, 
        presence, inputDate, inputBy, updateDate, updateBy
      )
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 
      1, NOW(), '1', NOW(), '1')
    `,
    [
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
      data.ticketStatusId,
    ]
  );

  return getTicketDetail(generatedId);
}

async function createTicketLog(payload) {
  console.log('createTicketLog payload', payload);
  const data = payload;
  const q =  `
      INSERT INTO ticket_logs (
        ticketId,   description, parentId,
        presence, inputDate, inputBy, updateDate, updateBy
      )
      VALUES (
        ?, ?, ?,
        1, NOW(),  '${data.submitBy}', NOW(),  '${data.submitBy}'
      )
    `;
  await pool.execute(q,
    [ 
      data.ticketId,
      data.description,
      data.parentId,  
    ]);

  return data.ticketId;
}

async function updateTicket(id, payload) {
  const fields = []; 
   
const q = `
  UPDATE ticket
  SET   
    assignTo = ?, 
    targetCompletionDate = ?,
    ticketStatusId = ?,
    actualCompletionDate = ?,
    description = ?,
    taskSolution = ?,
    title = ?,
    updateDate = NOW(),
    updateBy = '1'
  WHERE id = ? AND presence = 1
`;

const params = [
  String(payload.assignTo || '').trim(), 
  payload.targetCompletionDate || null,
  parseNonNegativeNumber(payload.ticketStatusId, 'ticketStatusId'),
  payload.actualCompletionDate || null,
  String(payload.description || '').trim(),
  String(payload.taskSolution || '').trim(),
  String(payload.title || '').trim(),
  id
];
console.log('updateTicket query:', q, 'params:', params);
const [result] = await pool.execute(q, params);

  if (!result.affectedRows) {
    const error = new Error('Ticket not found');
    error.statusCode = 404;
    throw error;
  }

  return getTicketDetail(id);
}

async function deleteTicket(id) {
  const [result] = await pool.execute(
    `
      UPDATE ticket
      SET presence = 0, updateDate = NOW(), updateBy = 1
      WHERE id = ? AND presence = 1
    `,
    [id]
  );

  if (!result.affectedRows) {
    const error = new Error('Ticket not found');
    error.statusCode = 404;
    throw error;
  }

  return { id };
}

module.exports = {
  listTickets,
  getTicketDetail,
  createTicket,
  createTicketLog,
  updateTicket,
  deleteTicket,
  getTicketLogs,
};
