const { pool } = require('../../config/db');

const CLOSED_STATUS_ID = 900;

 

async function listClosedTasks(filters = {}) { 
  
    const conditions = ['t.presence = 1', 't.ticketTypeId = ?', 't.ticketStatusId >= ?'];
  const params = [1, CLOSED_STATUS_ID];

  if (filters.projectId) {
    conditions.push('t.projectId = ?');
    params.push(String(filters.projectId));
  }

 

  if (filters.keyword) {
    conditions.push('(t.id LIKE ? OR t.title LIKE ?)');
    params.push(`%${filters.keyword}%`, `%${filters.keyword}%`);
  }

  if (filters.startDate) {
    conditions.push('t.submitDate >= ?');
    params.push(String(filters.startDate));
  }

  if (filters.endDate) {
    conditions.push('t.submitDate <= ? ');
    params.push(String(filters.endDate) + ' 23:59:59');
  }

  const whereClause = conditions.join(' AND ');

  const q = `
    
    SELECT t.id, t.title, t.projectId, t.submitDate, t.targetCompletionDate,
      t.actualCompletionDate, t.ticketStatusId, t.ticketCategoryId,
      ts.name AS ticketStatusName,
      p.name AS projectName,
      c.name AS clientName, t.rating,
      CONCAT(tc2.name, ' - ', tc.name) AS ticketCategoryName, 
     t.assignTo,
		CONCAT(u.firstName, ' ', u.lastName) AS assignToName
    FROM ticket t
    LEFT JOIN ticket_status ts ON ts.id = t.ticketStatusId
    LEFT JOIN project p ON p.id = t.projectId
    LEFT JOIN client c ON c.id = p.clientId
    LEFT JOIN ticket_categories tc ON tc.id = t.ticketCategoryId
    LEFT JOIN ticket_categories tc2 ON tc2.id = p.ticketCategoriesParentId
    LEFT JOIN user u ON u.id = t.assignTo
  WHERE ${whereClause}
    ORDER BY t.actualCompletionDate DESC
  `;

  console.log(q, params);
  const [rows] = await pool.execute(q, params);
  return rows;
}

async function listClosedCR(filters = {}) { 

    const conditions = ['t.presence = 1', 't.ticketTypeId = ?', 't.ticketStatusId >= ?'];
  const params = [3, CLOSED_STATUS_ID];

  if (filters.projectId) {
    conditions.push('t.projectId = ?');
    params.push(String(filters.projectId));
  }

 

  if (filters.keyword) {
    conditions.push('(t.id LIKE ? OR t.title LIKE ?)');
    params.push(`%${filters.keyword}%`, `%${filters.keyword}%`);
  }

  if (filters.startDate) {
    conditions.push('t.submitDate >= ?');
    params.push(String(filters.startDate));
  }

  if (filters.endDate) {
    conditions.push('t.submitDate <= ? ');
    params.push(String(filters.endDate) + ' 23:59:59');
  }

  const whereClause = conditions.join(' AND ');

  const q = `
    
    SELECT t.id, t.title, t.projectId, t.submitDate, t.targetCompletionDate,
      t.actualCompletionDate, t.ticketStatusId, t.ticketCategoryId,
      ts.name AS ticketStatusName,
      p.name AS projectName,
      c.name AS clientName, t.rating,
      CONCAT(tc2.name, ' - ', tc.name) AS ticketCategoryName,
      t.ticketEstimationCost, t.hours
    --  t.assignTo 
		-- CONCAT(u.firstName, ' ', u.lastName) AS assignToName
    FROM ticket t
    LEFT JOIN ticket_status ts ON ts.id = t.ticketStatusId
    LEFT JOIN project p ON p.id = t.projectId
    LEFT JOIN client c ON c.id = p.clientId
    LEFT JOIN ticket_categories tc ON tc.id = t.ticketCategoryId
    LEFT JOIN ticket_categories tc2 ON tc2.id = p.ticketCategoriesParentId
  --  LEFT JOIN user u ON u.id = t.assignTo
  WHERE ${whereClause}
    ORDER BY t.actualCompletionDate DESC
  `;

  console.log(q, params);
  const [rows] = await pool.execute(q, params);
  return rows;
}


async function listClosedCases(filters = {}) { 

    const conditions = ['t.presence = 1', 't.ticketTypeId = ?', 't.ticketStatusId >= ?'];
  const params = [2, CLOSED_STATUS_ID];

  if (filters.projectId) {
    conditions.push('t.projectId = ?');
    params.push(String(filters.projectId));
  }

 

  if (filters.keyword) {
    conditions.push('(t.id LIKE ? OR t.title LIKE ?)');
    params.push(`%${filters.keyword}%`, `%${filters.keyword}%`);
  }

  if (filters.startDate) {
    conditions.push('t.submitDate >= ?');
    params.push(String(filters.startDate));
  }

  if (filters.endDate) {
    conditions.push('t.submitDate <= ? ');
    params.push(String(filters.endDate) + ' 23:59:59');
  }

  const whereClause = conditions.join(' AND ');

  const q = `
    
    SELECT t.id, t.title, t.projectId, t.submitDate, t.targetCompletionDate,
      t.actualCompletionDate, t.ticketStatusId, t.ticketCategoryId,
      ts.name AS ticketStatusName,
      p.name AS projectName,
      c.name AS clientName, t.rating,
      CONCAT(tc2.name, ' - ', tc.name) AS ticketCategoryName,
      t.ticketEstimationCost, t.hours
    --  t.assignTo 
		-- CONCAT(u.firstName, ' ', u.lastName) AS assignToName
    FROM ticket t
    LEFT JOIN ticket_status ts ON ts.id = t.ticketStatusId
    LEFT JOIN project p ON p.id = t.projectId
    LEFT JOIN client c ON c.id = p.clientId
    LEFT JOIN ticket_categories tc ON tc.id = t.ticketCategoryId
    LEFT JOIN ticket_categories tc2 ON tc2.id = p.ticketCategoriesParentId
  --  LEFT JOIN user u ON u.id = t.assignTo
  WHERE ${whereClause}
    ORDER BY t.actualCompletionDate DESC
  `;

  console.log(q, params);
  const [rows] = await pool.execute(q, params);
  return rows;
}


async function ticketDetail(ticketId) {
  const q = `
    SELECT t.*,
      ts.name AS ticketStatusName,
      p.name AS projectName,
      c.name AS clientName, t.rating,
      CONCAT(tc2.name, ' - ', tc.name) AS ticketCategoryName,
      t.assignTo, CONCAT(u.firstName, ' ', u.lastName) AS assignToName
    FROM ticket t
    LEFT JOIN ticket_status ts ON ts.id = t.ticketStatusId
    LEFT JOIN project p ON p.id = t.projectId
    LEFT JOIN client c ON c.id = p.clientId
    LEFT JOIN ticket_categories tc ON tc.id = t.ticketCategoryId
    LEFT JOIN ticket_categories tc2 ON tc2.id = p.ticketCategoriesParentId
    LEFT JOIN user u ON u.id = t.assignTo
    WHERE t.id = ?
  `; 
  const [rows] = await pool.execute(q, [ticketId]);

   const q2 = `
    SELECT tr.*, r.name AS ratingName
    FROM ticket_rating tr
    LEFT JOIN rating r ON r.id = tr.ratingId
    WHERE tr.ticketId = ?
  `; 
  const [ratingRows] = await pool.execute(q2, [ticketId]);

  const q3 = `
    SELECT ta.*, '' as  'attachment'
    FROM ticket_logs ta
    WHERE ta.ticketId = ?
    ORDER BY ta.inputDate DESC
  `;
  const [activitiesRows] = await pool.execute(q3, [ticketId]);


  for (const activity of activitiesRows) {

     const q3 = `
      SELECT t.*
      FROM ticket_logs_attachments t
      WHERE t.ticketId = ?
      ORDER BY t.inputDate DESC
    `;
    const [attachmentsRows] = await pool.execute(q3, [ticketId]); 
    activity.attachment = attachmentsRows.filter(att => att.ticketId === activity.ticketId);
  }
 
  const data = { 
    detail : rows[0],
    rating : ratingRows,
    activities : activitiesRows,
  };
  
  return data;
}

module.exports = {
  listClosedTasks,
  listClosedCases,
  ticketDetail,
  listClosedCR
};
