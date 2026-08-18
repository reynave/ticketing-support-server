const { pool } = require('../../config/db');

function parseId(id) {
  const parsed = Number(id);

  if (!Number.isInteger(parsed) || parsed < 1) {
    const error = new Error('Invalid ticket category id');
    error.statusCode = 400;
    throw error;
  }

  return parsed;
}

function parseNumeric(value, fieldName) {
  const parsed = Number(value);

  if (!Number.isFinite(parsed)) {
    const error = new Error(`${fieldName} must be a valid number`);
    error.statusCode = 400;
    throw error;
  }

  return parsed;
}

function parseStatus(value) {
  const status = Number(value);

  if (![0, 1].includes(status)) {
    const error = new Error('status must be 0 or 1');
    error.statusCode = 400;
    throw error;
  }

  return status;
}

 
function normalizeUpdatePayload(payload) {
  const data = {};

  if (payload.name !== undefined) {
    const value = String(payload.name).trim();

    if (!value) {
      const error = new Error('name cannot be empty');
      error.statusCode = 400;
      throw error;
    }

    data.name = value;
  }

  if (payload.parentId !== undefined) {
    data.parentId = parseNumeric(payload.parentId, 'parentId');
  }

  if (payload.weight !== undefined) {
    data.weight = parseNumeric(payload.weight, 'weight');
  }
  if (payload.sorting !== undefined) {
    data.sorting = parseNumeric(payload.sorting, 'sorting');
  }
    

  if (payload.status !== undefined) {
    data.status = parseStatus(payload.status);
  }

  return data;
}

async function listTicketChildCategories() {

  const [rows] = await pool.execute(
    `
      SELECT
        tc.id, tc.name, tc.parentId, tc.weight, tc.status
      FROM ticket_categories  tc
      WHERE tc.presence = 1 and tc.parentId > 0
      ORDER BY tc.parentId ASC, tc.weight ASC, tc.id ASC
    `
  );  
  return rows;
}
  

async function listTicketCategories(filters = {}) {
  console.log(filters);
  let whereParents = ' AND tc.parentId = 0'; 
   if(filters?.parentId){
      whereParents =  ' AND  tc.parentId = '+filters?.parentId;
   } 

  if(filters?.status){
      whereParents +=  ' AND tc.status = '+filters?.status;
  } 
  const q =  `
      SELECT
        tc.id, tc.name, tc.parentId, tc.weight, tc.status, tc.sorting
      FROM ticket_categories  tc
      WHERE tc.presence = 1  ${whereParents}
      ORDER BY tc.sorting ASC
    `;
 
  const [rows] = await pool.execute(
    q, 
  ); 
 
  let whereChild = ' AND tc.parentId > 0'; 
  if(filters?.parentId){
    whereChild =  ' AND  tc.parentId = '+filters?.parentId;
  } 

  if(filters?.status){
      whereChild +=  '  AND  tc.status = '+filters?.status;
  } 
  const [rows2] = await pool.execute(
    `
      SELECT
        tc.id, tc.name, tc.parentId, tc.weight, tc.status ,tc.sorting
      FROM ticket_categories  tc
      WHERE tc.presence = 1 ${whereChild}  
      ORDER BY tc.sorting ASC 
    `, 
  );

  for (const parent of rows) {
    parent.children = rows2.filter(child => child.parentId === parent.id);
  }
  

  return rows;
}

async function getTicketCategoryDetail(id) {
  const safeId = parseId(id);

  const [rows] = await pool.execute(
    `
      SELECT
        tc.*, true as 'locked',
        parent.name AS parentName
      FROM ticket_categories tc
      LEFT JOIN ticket_categories parent ON parent.id = tc.parentId AND parent.presence = 1
      WHERE tc.id = ? AND tc.presence = 1
      LIMIT 1
    `,
    [safeId]
  );

  const [total] = await pool.execute(
    `
      SELECT SUM(t.total) AS 'total' FROM ( 
        SELECT COUNT(id) AS 'total' FROM ticket
        WHERE presence = 1 and ticketStatusId < 900 AND ticketCategoryId = ?
        UNION 
        SELECT COUNT(id) AS 'total'  FROM project 
        WHERE presence = 1 AND ticketCategoriesParentId = ?
      ) t
    `,
    [safeId, safeId]
  );

  rows[0].total = Number(total[0].total) || 0;

  const row = rows[0];

  

  if (!row) {
    const error = new Error('Ticket category not found');
    error.statusCode = 404;
    throw error;
  }

  return row;
}

async function createTicketCategory(payload, actorId = 1) {
 
  console.log('payload:', payload, 'actorId:', actorId);
  const [result] = await pool.execute(
    `
      INSERT INTO ticket_categories (
        name, parentId, weight, status, sorting,
        presence, inputDate, inputBy, updateDate, updateBy
      )
      VALUES (?, ?, ?, ?, ?, 1, NOW(), ?, NOW(), ?)
    `,
    [
      payload.name,
      payload.parentId,
      payload.weight,
      payload.status,
      payload.sorting,
      Number(actorId) || 1,
      Number(actorId) || 1,
    ]
  );

  return getTicketCategoryDetail(result.insertId);
}

async function updateTicketCategory(id, payload, actorId = 1) {
  const safeId = parseId(id);
  const data = normalizeUpdatePayload(payload || {});
  const fields = Object.keys(data);

  if (!fields.length) {
    const error = new Error('No valid fields provided');
    error.statusCode = 400;
    throw error;
  }

  const setClause = fields.map((field) => `${field} = ?`).join(', ');
  const values = fields.map((field) => data[field]);

  const [result] = await pool.execute(
    `
      UPDATE ticket_categories
      SET ${setClause}, updateDate = NOW(), updateBy = ?
      WHERE id = ? AND presence = 1
    `,
    [...values, Number(actorId) || 1, safeId]
  );

  if (!result.affectedRows) {
    const error = new Error('Ticket category not found');
    error.statusCode = 404;
    throw error;
  }

  return getTicketCategoryDetail(safeId);
}

async function deleteTicketCategory(id, actorId = 1) {
  const safeId = parseId(id);

  const [result] = await pool.execute(
    `
      UPDATE ticket_categories
      SET presence = 0, updateDate = NOW(), updateBy = ?
      WHERE id = ? AND presence = 1
    `,
    [Number(actorId) || 1, safeId]
  );

  if (!result.affectedRows) {
    const error = new Error('Ticket category not found');
    error.statusCode = 404;
    throw error;
  }

  return { id: safeId };
}

module.exports = {
  listTicketCategories,
  getTicketCategoryDetail,
  createTicketCategory,
  updateTicketCategory,
  deleteTicketCategory,
  listTicketChildCategories
};
