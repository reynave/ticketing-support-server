const { pool } = require('../../config/db');

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

module.exports = {
  listRatings,
};