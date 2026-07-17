const { pool } = require('../../config/db');

function parseId(id) {
  const parsed = Number(id);

  if (!Number.isInteger(parsed) || parsed < 1) {
    const error = new Error('Invalid id parameter');
    error.statusCode = 400;
    throw error;
  }

  return parsed;
}

async function listRatings(filters = {}) {
  const conditions = ['t.presence = 1', 't.ticketStatusId >= 900'];
  const params = [];

  if (filters.keyword && String(filters.keyword).trim() !== '') {
    conditions.push('(t.id LIKE ? OR t.title LIKE ? OR t.crNoRef LIKE ? OR t.issueNo LIKE ?)');
    const keyword = `%${String(filters.keyword).trim()}%`;
    params.push(keyword, keyword, keyword, keyword);
  }

  const [rows] = await pool.execute(
    `
      SELECT t.*,
        tt.name AS ticketTypeName,
        ts.name AS ticketStatusName,
        CONCAT(submitter.firstName, ' ', submitter.lastName) AS submitByName,
        CONCAT(rater.firstName, ' ', rater.lastName) AS ratesByName,
        p.name AS projectName
      FROM ticket t
      LEFT JOIN ticket_type tt ON tt.id = t.ticketTypeId
      left JOIN project p ON p.id = t.projectId
      LEFT JOIN ticket_status ts ON ts.id = t.ticketStatusId
      LEFT JOIN user submitter ON submitter.id = t.submitBy
      LEFT JOIN user rater ON rater.id = t.ratesBy
      WHERE ${conditions.join(' AND ')} 
      AND t.ratesBy = '' and t.presence = 1
      ORDER BY COALESCE(t.actualCompletionDate, t.updateDate, t.inputDate) DESC, t.inputDate DESC
    `,
    params
  );

  return rows;
}

async function listRatingMaster(filters = {}) {
  const conditions = ['presence = 1'];
  const params = [];

  if (filters.status !== undefined && filters.status !== null && filters.status !== '') {
    conditions.push('status = ?');
    params.push(Number(filters.status));
  }

  if (filters.keyword && String(filters.keyword).trim() !== '') {
    conditions.push('name LIKE ?');
    params.push(`%${String(filters.keyword).trim()}%`);
  }

  const [rows] = await pool.execute(
    `
      SELECT *
      FROM rating
      WHERE ${conditions.join(' AND ')}
      ORDER BY id ASC
    `,
    params
  );

  return rows;
}

async function getRatingMasterDetail(id) {
  const parsedId = parseId(id);
  const [rows] = await pool.execute(
    `
      SELECT *
      FROM rating
      WHERE id = ? AND presence = 1
      LIMIT 1
    `,
    [parsedId]
  );

  const row = rows[0];

  if (!row) {
    const error = new Error('Rating master data not found');
    error.statusCode = 404;
    throw error;
  }

  return row;
}

async function createRatingMaster(payload = {}) {
  const name = String(payload.name || '').trim();

  if (!name) {
    const error = new Error('Missing required field: name');
    error.statusCode = 400;
    throw error;
  }

  const status = payload.status === undefined ? 1 : Number(payload.status);

  const [result] = await pool.execute(
    `
      INSERT INTO rating (name, status, presence, inputDate, inputBy, updateDate, updateBy)
      VALUES (?, ?, 1, NOW(), 1, NOW(), 1)
    `,
    [name, status]
  );

  return getRatingMasterDetail(result.insertId);
}

async function updateRatingMaster(id, payload = {}) {
  const parsedId = parseId(id);
  const setParts = [];
  const params = [];

  if (payload.name !== undefined) {
    const name = String(payload.name || '').trim();

    if (!name) {
      const error = new Error('Field name cannot be empty');
      error.statusCode = 400;
      throw error;
    }

    setParts.push('name = ?');
    params.push(name);
  }

  if (payload.status !== undefined) {
    setParts.push('status = ?');
    params.push(Number(payload.status));
  }

  if (!setParts.length) {
    const error = new Error('No valid fields provided');
    error.statusCode = 400;
    throw error;
  }

  params.push(parsedId);

  const [result] = await pool.execute(
    `
      UPDATE rating
      SET ${setParts.join(', ')}, updateDate = NOW(), updateBy = 1
      WHERE id = ? AND presence = 1
    `,
    params
  );

  if (!result.affectedRows) {
    const error = new Error('Rating master data not found');
    error.statusCode = 404;
    throw error;
  }

  return getRatingMasterDetail(parsedId);
}

async function deleteRatingMaster(id) {
  const parsedId = parseId(id);
  const [result] = await pool.execute(
    `
      UPDATE rating
      SET presence = 0, updateDate = NOW(), updateBy = 1
      WHERE id = ? AND presence = 1
    `,
    [parsedId]
  );

  if (!result.affectedRows) {
    const error = new Error('Rating master data not found');
    error.statusCode = 404;
    throw error;
  }

  return { id: parsedId };
}

module.exports = {
  listRatings,
  listRatingMaster,
  getRatingMasterDetail,
  createRatingMaster,
  updateRatingMaster,
  deleteRatingMaster,
};