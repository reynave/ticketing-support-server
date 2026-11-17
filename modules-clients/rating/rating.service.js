const { pool } = require('../../config/db');

async function listRatingMaster(filters = {}) {
  const conditions = ['presence = 1'];
  const params = [];

  if (filters.status !== undefined && filters.status !== null && String(filters.status) !== '') {
    conditions.push('status = ?');
    params.push(Number(filters.status));
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

async function createRating(body, actorId) {
  const ticketId = String(body.ticketId || '').trim();

  if (!ticketId) {
    const error = new Error('ticketId is required');
    error.statusCode = 400;
    throw error;
  }

  const averageRating = body.averageRating;
  const ratings = Array.isArray(body.ratings) ? body.ratings : [];

  const [result] = await pool.execute(
    `
      UPDATE ticket
      SET rating = ?, ratesBy = ?, updateDate = NOW(), updateBy = ?
      WHERE id = ?
    `,
    [averageRating, String(actorId), String(actorId), ticketId]
  );

  if (!result.affectedRows) {
    const error = new Error('Ticket not found');
    error.statusCode = 404;
    throw error;
  }

  for (const rating of ratings) {
    await pool.execute(
      `
        INSERT INTO ticket_rating (ticketId, ratingId, value, inputDate, inputBy, updateDate, updateBy)
        VALUES (?, ?, ?, NOW(), ?, NOW(), ?)
      `,
      [ticketId, rating.questionId, rating.rating, String(actorId), String(actorId)]
    );
  }

  return { id: ticketId };
}

module.exports = {
  listRatingMaster,
  createRating,
};