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
    ticketCategoryId: payload.ticketCategoryId,
    issueNo: String(payload.issueNo || '').trim(),
  };
}

async function listTickets(filters = {}) {
  const conditions = ['t.presence = 1'];
  const params = [];

  let ticketTypeId = 1;
  if (
    filters.ticketTypeId !== undefined &&
    filters.ticketTypeId !== null &&
    String(filters.ticketTypeId).trim() !== ''
  ) {
    ticketTypeId = Number(filters.ticketTypeId);

    if (!Number.isFinite(ticketTypeId)) {
      const error = new Error('ticketTypeId must be a valid number');
      error.statusCode = 400;
      throw error;
    }
  }

  conditions.push('t.ticketTypeId = ?');
  params.push(ticketTypeId);

  if (filters.projectId !== undefined) {
    conditions.push('t.projectId = ?');
    params.push(String(filters.projectId));
  }

  if (filters.assignTo !== undefined) {
    conditions.push('t.assignTo = ?');
    params.push(Number(filters.assignTo));
  }

  if (filters.issueNo !== undefined && String(filters.issueNo).trim() !== '') {
    conditions.push('t.issueNo = ?');
    params.push(String(filters.issueNo).trim());
  }

  if (filters.keyword) {
    conditions.push('(t.id LIKE ? OR t.title LIKE ? OR t.crNoRef LIKE ? OR t.issueNo LIKE ?)');
    params.push(`%${filters.keyword}%`, `%${filters.keyword}%`, `%${filters.keyword}%`, `%${filters.keyword}%`);
  }

  const whereClause = conditions.join(' AND ');

  let whereTicketStatus = '';
  const isClosedFilter = String(filters.closed || '').trim().toLowerCase() === 'true';
  if (
    filters.ticketStatusId !== undefined &&
    filters.ticketStatusId !== null &&
    String(filters.ticketStatusId).trim() !== ''
  ) {
    const ticketStatusId = Number(filters.ticketStatusId);

    if (!Number.isFinite(ticketStatusId)) {
      const error = new Error('ticketStatusId must be a valid number');
      error.statusCode = 400;
      throw error;
    }

    if (isClosedFilter || ticketStatusId === 1) {
      whereTicketStatus = ' AND t.ticketStatusId < ? ';
      params.push(900);
    } else {
      whereTicketStatus = ' AND t.ticketStatusId = ? ';
      params.push(ticketStatusId);
    }
  } else if (isClosedFilter) {
    whereTicketStatus = ' AND t.ticketStatusId < ? ';
    params.push(900);
  }
  const q = `
      SELECT t.id, t.title, t.projectId, t.submitDate, t.targetCompletionDate, t.ticketStatusId, t.ticketCategoryId,
        tt.name AS ticketTypeName,
        ts.name AS ticketStatusName,
        p.name AS projectName,
        tc.name AS ticketCategoryName
      FROM ticket t
      LEFT JOIN ticket_type tt ON tt.id = t.ticketTypeId
      LEFT JOIN ticket_status ts ON ts.id = t.ticketStatusId 
      left join project AS p ON p.id = t.projectId
      left join ticket_categories AS tc ON tc.id = t.ticketCategoryId
      WHERE t.presence = 1  AND (
      ${whereClause}
      ${whereTicketStatus} ) 
      ORDER BY t.inputDate DESC
    `;
  console.log(q, params)
  const [rows] = await pool.execute(
    q,
    params
  );


  return rows;
}

async function getTicketDetail(id) {
  const [rows] = await pool.execute(
    `
      SELECT t.*,
        tt.name AS ticketTypeName,
        ts.name AS ticketStatusName,  p.name AS projectName,
        d.name AS productName, c.name AS clientName, pt.name AS projectType,
        CONCAT(u.firstName, ' ',u.lastName) AS 'submitByName',
        tc.name as 'ticketCategory',
        p2.name as 'productChildName'
        FROM ticket t
        LEFT JOIN ticket_type tt ON tt.id = t.ticketTypeId
        LEFT JOIN ticket_status ts ON ts.id = t.ticketStatusId
        LEFT JOIN project AS p ON p.id = t.projectId
        LEFT JOIN product AS d ON d.id = p.productId
        LEFT JOIN client AS c ON c.id = p.clientId
        LEFT JOIN project_type AS pt ON pt.id = p.projectTypeId
        LEFT JOIN user AS u ON u.id = t.submitBy
        left join ticket_categories as tc on t.ticketCategoryId = tc.id
        left join product as p2 on p2.id = t.productChildId
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

  const [rowsImgs] = await pool.execute(
    `
    SELECT  *
    FROM ticket_logs_attachments 
    WHERE  ticketId = ?
    ORDER BY id ASC
    `,
    [id]
  );

  const row = rows;
  const data = {
    logs: rows,
    img: rowsImgs
  }


  // Merge img ke dalam setiap log berdasarkan ticketLogId
  const logs = rows.map((log) => ({
    ...log,
    attachments: rowsImgs.filter((img) => img.ticketLogId === log.id),
  }));

  if (!row) {
    const error = new Error('Ticket not found');
    error.statusCode = 404;
    throw error;
  }

  return logs;
}

async function createTicket(payload) {
  const data = normalizeCreatePayload(payload);
  const generatedId = await buildTicketId(payload.id);
  console.log('createTicket payload', data, 'generatedId:', generatedId);
  await pool.execute(
    `
      INSERT INTO ticket (
        id, ticketTypeId, issueNo, title, description, projectId,
        submitBy, submitDate, targetCompletionDate, assignTo, 
        actualCompletionDate, ticketStatusId, ticketCategoryId,
        presence, inputDate, inputBy, updateDate, updateBy,
        productChildId
      )
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,
      1, NOW(), '1', NOW(), '1',?)
    `,
    [
      generatedId,
      data.ticketTypeId,
      data.issueNo,
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
      payload.productChildId
    ]
  );

  return getTicketDetail(generatedId);
}

async function createTicketLog_VER1(payload) {
  console.log('createTicketLog payload', payload);
  const data = payload;
  const q = `
      INSERT INTO ticket_logs (
        ticketId, description, parentId, starDateTime, closeDateTime,
        presence, inputDate, inputBy, updateDate, updateBy
      )
      VALUES (
        ?, ?, ?, IFNULL(?, NOW()), IFNULL(?, NOW()),
        1, NOW(),  '${data.submitBy}', NOW(),  '${data.submitBy}'
      )
    `;
  const obj = [
    data.ticketId,
    data.description,
    data.parentId == null ? '' : data.parentId,
    data.starDateTime || null,
    data.clsoeDateTime || null,
  ];
  console.log(q, obj)

  await pool.execute(q, obj);

  return data.ticketId;
}

async function createTicketLog(payload, files = [], req) {
  console.log('createTicketLog payload', payload);
  const data = payload;

  if (!String(data.starDateTime || '').trim() || !String(data.closeDateTime || '').trim()) {
    const error = new Error('starDateTime and closeDateTime are required');
    error.statusCode = 400;
    throw error;
  }

  const conn = await pool.getConnection();

  try {
    await conn.beginTransaction();

    // 1. Insert ticket_logs
    const logQuery = `
      INSERT INTO ticket_logs (
        ticketId, description, parentId, starDateTime, closeDateTime,
        presence, inputDate, inputBy, updateDate, updateBy
      )
      VALUES (
        ?, ?, ?, IFNULL(?, NOW()), IFNULL(?, NOW()),
        1, NOW(), ?, NOW(), ?
      )
    `;

    const logParams = [
      data.ticketId,
      data.description,
      data.parentId || '',
      data.starDateTime,
      data.closeDateTime,
      data.submitBy,
      data.submitBy,
    ];

    const [logResult] = await conn.execute(logQuery, logParams);
    const ticketLogId = logResult.insertId;

    // 2. Insert attachments kalau ada file
    if (files.length > 0) {
      const attachmentQuery = `
        INSERT INTO ticket_logs_attachments (
          ticketId,
           ticketLogId, originalName, filename,
          mimetype, size, url,
          inputDate, inputBy
        )
        VALUES (?, ?, ?, ?, ?, ?, ?, NOW(), ?)
      `;

      for (const file of files) {
        const fileUrl = `${req.protocol}://${req.get('host')}/uploads/${file.filename}`;

        await conn.execute(attachmentQuery, [
          data.ticketId,
          ticketLogId,
          file.originalname,
          file.filename,
          file.mimetype,
          file.size,
          fileUrl,
          data.submitBy,
        ]);
      }
    }

    await conn.commit();

    return {
      ticketLogId,
      ticketId: data.ticketId,
      totalAttachments: files.length,
    };

  } catch (error) {
    await conn.rollback();
    throw error;
  } finally {
    conn.release();
  }
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
    updateBy = ?
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
    payload.submitBy,
    id,
  ];



  console.log('updateTicket query:', q, 'params:', params);
  const [result] = await pool.execute(q, params);

  if (payload.wasAssignTo !== payload.assignTo) {
     const [history] = await pool.execute(
      `
      SELECT id, concat(firstName, ' ', lastName) AS name FROM user WHERE id = ?
      UNION 
       SELECT id, concat(firstName, ' ', lastName) AS name FROM user WHERE id = ?
    `,
      [payload.wasAssignTo, payload.assignTo]
    );

    const description = 'Update Assignee from <strong>' + history[0]['name'] + '</strong> To  <strong>' + history[1]['name'] + '</strong> ';

    const q = `
      INSERT INTO ticket_logs (
        ticketId, description, starDateTime, closeDateTime,
        presence, inputDate, inputBy, updateDate, updateBy
      )
      VALUES (
        ?, ?, IFNULL(?, NOW()), IFNULL(?, NOW()),
        1, NOW(),  '${payload.submitBy}', NOW(),  '${payload.submitBy}'
      )
    `;
    const obj = [
      id,
      description
      , null
      , null
    ];


    console.log(q, obj)

    await pool.execute(q, obj);
  }

  if (payload.wasTicketStatusId != payload.ticketStatusId) {
    const [history] = await pool.execute(
      `
      SELECT id, name FROM ticket_status WHERE id = ?
      UNION 
      SELECT id,name FROM ticket_status WHERE id = ?
    `,
      [payload.wasTicketStatusId, payload.ticketStatusId]
    );

    const description = 'Update Status from <strong>' + history[0]['name'] + '</strong> To  <strong>' + history[1]['name'] + '</strong> ';

    const q = `
      INSERT INTO ticket_logs (
        ticketId, description, starDateTime, closeDateTime,
        presence, inputDate, inputBy, updateDate, updateBy
      )
      VALUES (
        ?, ?, IFNULL(?, NOW()), IFNULL(?, NOW()),
        1, NOW(),  '${payload.submitBy}', NOW(),  '${payload.submitBy}'
      )
    `;
    const obj = [
      id,
      description
      , null
      , null
    ];


    console.log(q, obj)

    await pool.execute(q, obj);
  }

  if (!result.affectedRows) {
    const error = new Error('Ticket not found');
    error.statusCode = 404;
    throw error;
  }

  return true;
}

async function submitRateService(id, payload) {
  const fields = [];

  const q = `
  UPDATE ticket
  SET    
    taskSolution = ?,
    rating = ?,
    ratesBy = ?,
    updateDate = NOW(),
    updateBy = ?
  WHERE id = ? AND presence = 1
`;

  const params = [
    String(payload.taskSolution || '').trim(),
    String(payload.rating || '').trim(),
    payload.updateBy,
    payload.updateBy,
    id,
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
  submitRateService,
};
