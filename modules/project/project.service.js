const { randomUUID } = require('crypto');
const { pool } = require('../../config/db');

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

function buildProjectId(inputId) {
  if (inputId && String(inputId).trim()) {
    return String(inputId).trim();
  }

  return `PRJ-${randomUUID().split('-')[0].toUpperCase()}`;
}

function validateRequiredCreateFields(payload) {
  const requiredFields = [
    'projectTypeId',
    'projectBilleableId',
    'projectCategoryId',
    'productId',
    'clientId',
    'startDate',
    'endDate',
  ];

  const missing = requiredFields.filter((field) => payload[field] === undefined || payload[field] === null || payload[field] === '');

  if (missing.length) {
    const error = new Error(`Missing required fields: ${missing.join(', ')}`);
    error.statusCode = 400;
    throw error;
  }
}

async function listProjects(filters = {}) {
  const conditions = ['p.presence = 1'];
  const params = [];

  if (filters.status !== undefined) {
    conditions.push('p.status = ?');
    params.push(Number(filters.status));
  }

  if (filters.clientId !== undefined) {
    conditions.push('p.clientId = ?');
    params.push(String(filters.clientId));
  }

  if (filters.projectTypeId !== undefined) {
    conditions.push('p.projectTypeId = ?');
    params.push(Number(filters.projectTypeId));
  }

  if (filters.keyword) {
    conditions.push('(p.id LIKE ? OR c.name LIKE ?)');
    params.push(`%${filters.keyword}%`, `%${filters.keyword}%`);
  }

  const whereClause = `WHERE ${conditions.join(' AND ')}`;

  const [rows] = await pool.execute(
    `
      SELECT
        p.*,
        c.name AS clientName,
        pt.name AS projectTypeName,
        pb.name AS projectBilleableName,
        pc.name AS projectCategoryName,
        pr.name AS productName
      FROM project p
      LEFT JOIN client c ON c.id = p.clientId
      LEFT JOIN project_type pt ON pt.id = p.projectTypeId
      LEFT JOIN project_billeable pb ON pb.id = p.projectBilleableId
      LEFT JOIN project_categories pc ON pc.id = p.projectCategoryId
      LEFT JOIN product pr ON pr.id = p.productId
      ${whereClause}
      ORDER BY p.inputDate DESC
    `,
    params
  );

  return rows;
}

async function getProjectDetail(id) {
  const [rows] = await pool.execute(
    `
      SELECT
        p.*,
        c.name AS clientName,
        pt.name AS projectTypeName,
        pb.name AS projectBilleableName,
        pc.name AS projectCategoryName,
        pr.name AS productName
      FROM project p
      LEFT JOIN client c ON c.id = p.clientId
      LEFT JOIN project_type pt ON pt.id = p.projectTypeId
      LEFT JOIN project_billeable pb ON pb.id = p.projectBilleableId
      LEFT JOIN project_categories pc ON pc.id = p.projectCategoryId
      LEFT JOIN product pr ON pr.id = p.productId
      WHERE p.id = ? AND p.presence = 1
      LIMIT 1
    `,
    [id]
  );

  const row = rows[0];

  if (!row) {
    const error = new Error('Project not found');
    error.statusCode = 404;
    throw error;
  }

  return row;
}

async function createProject(payload) {
  validateRequiredCreateFields(payload);

  const id = buildProjectId(payload.id);
  const projectTypeId = parseNumeric(payload.projectTypeId, 'projectTypeId');
  const projectBilleableId = parseNumeric(payload.projectBilleableId, 'projectBilleableId');
  const projectCategoryId = parseNumeric(payload.projectCategoryId, 'projectCategoryId');
  const productId = parseNumeric(payload.productId, 'productId');
  const clientId = String(payload.clientId);
  const status = payload.status === undefined ? 1 : parseStatus(payload.status);
  const templateMaster = payload.templateMaster === undefined ? '0' : String(payload.templateMaster);

  await pool.execute(
    `
      INSERT INTO project (
        id, projectTypeId, projectBilleableId, projectCategoryId, productId, clientId,
        startDate, endDate, status, templateMaster, presence, inputDate, inputBy, updateDate, updateBy
      )
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 1, NOW(), 1, NOW(), 1)
    `,
    [
      id,
      projectTypeId,
      projectBilleableId,
      projectCategoryId,
      productId,
      clientId,
      payload.startDate,
      payload.endDate,
      status,
      templateMaster,
    ]
  );

  return getProjectDetail(id);
}

async function updateProject(id, payload) {
  const fields = [];
  const params = [];

  if (payload.projectTypeId !== undefined) {
    fields.push('projectTypeId = ?');
    params.push(parseNumeric(payload.projectTypeId, 'projectTypeId'));
  }

  if (payload.projectBilleableId !== undefined) {
    fields.push('projectBilleableId = ?');
    params.push(parseNumeric(payload.projectBilleableId, 'projectBilleableId'));
  }

  if (payload.projectCategoryId !== undefined) {
    fields.push('projectCategoryId = ?');
    params.push(parseNumeric(payload.projectCategoryId, 'projectCategoryId'));
  }

  if (payload.productId !== undefined) {
    fields.push('productId = ?');
    params.push(parseNumeric(payload.productId, 'productId'));
  }

  if (payload.clientId !== undefined) {
    fields.push('clientId = ?');
    params.push(String(payload.clientId));
  }

  if (payload.startDate !== undefined) {
    fields.push('startDate = ?');
    params.push(payload.startDate);
  }

  if (payload.endDate !== undefined) {
    fields.push('endDate = ?');
    params.push(payload.endDate);
  }

  if (payload.status !== undefined) {
    fields.push('status = ?');
    params.push(parseStatus(payload.status));
  }

  if (payload.templateMaster !== undefined) {
    fields.push('templateMaster = ?');
    params.push(String(payload.templateMaster));
  }

  if (!fields.length) {
    const error = new Error('No valid fields provided');
    error.statusCode = 400;
    throw error;
  }

  const [result] = await pool.execute(
    `
      UPDATE project
      SET ${fields.join(', ')}, updateDate = NOW(), updateBy = 1
      WHERE id = ? AND presence = 1
    `,
    [...params, id]
  );

  if (!result.affectedRows) {
    const error = new Error('Project not found');
    error.statusCode = 404;
    throw error;
  }

  return getProjectDetail(id);
}

async function deleteProject(id) {
  const [result] = await pool.execute(
    `
      UPDATE project
      SET presence = 0, updateDate = NOW(), updateBy = 1
      WHERE id = ? AND presence = 1
    `,
    [id]
  );

  if (!result.affectedRows) {
    const error = new Error('Project not found');
    error.statusCode = 404;
    throw error;
  }

  return { id };
}

module.exports = {
  listProjects,
  getProjectDetail,
  createProject,
  updateProject,
  deleteProject,
};
