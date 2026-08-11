const { pool } = require('../../config/db');

let templateTableReady = false;

async function ensureTemplateTable() {
  if (templateTableReady) {
    return;
  }

  await pool.execute(`
    CREATE TABLE IF NOT EXISTS template (
      id INT AUTO_INCREMENT PRIMARY KEY,
      name VARCHAR(255) NOT NULL,
      description TEXT NULL,
      version VARCHAR(100) NOT NULL,
      tempateType VARCHAR(100) NOT NULL,
      json TEXT NULL,
      presence TINYINT(1) NOT NULL DEFAULT 1,
      inputDate DATETIME NULL,
      inputBy VARCHAR(100) NULL,
      updateDate DATETIME NULL,
      updateBy VARCHAR(100) NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  `);

  templateTableReady = true;
}

function parseId(id) {
  const parsed = Number(id);

  if (!Number.isInteger(parsed) || parsed < 1) {
    const error = new Error('Invalid template id');
    error.statusCode = 400;
    throw error;
  }

  return parsed;
}

function parseStatus(value) {
  const status = Number(value);

  if (![0, 1].includes(status)) {
    const error = new Error('presence must be 0 or 1');
    error.statusCode = 400;
    throw error;
  }

  return status;
}

function normalizeCreatePayload(payload) {
  const name = String(payload.name || '').trim();
  const description = String(payload.description || '').trim();
  const version = String(payload.version || '').trim();
  const tempateType = String(payload.tempateType || payload.templateType || '').trim();
  const json = payload.json === undefined ? '' : String(payload.json);

  if (!name) {
    const error = new Error('name is required');
    error.statusCode = 400;
    throw error;
  }

  if (!version) {
    const error = new Error('version is required');
    error.statusCode = 400;
    throw error;
  }

  if (!tempateType) {
    const error = new Error('tempateType is required');
    error.statusCode = 400;
    throw error;
  }

  return {
    name,
    description,
    version,
    tempateType,
    json,
    presence: payload.presence === undefined ? 1 : parseStatus(payload.presence),
  };
}

async function listTemplates(filters = {}) {
  await ensureTemplateTable();

  const conditions = ['presence = 1'];
  const params = [];

  if (filters.status !== undefined && filters.status !== '') {
    conditions.push('presence = ?');
    params.push(parseStatus(filters.status));
  }

  const whereClause = conditions.length ? `WHERE ${conditions.join(' AND ')}` : '';

  const [rows] = await pool.execute(
    `
      SELECT id, name, description, version 
      FROM template
      ${whereClause}
      ORDER BY name ASC, version ASC
    `,
    params
  );

  return rows;
}

async function getTemplateDetail(id) {
  await ensureTemplateTable();

  const safeId = parseId(id);

  const [rows] = await pool.execute(
    `
      SELECT *
      FROM template
      WHERE id = ? AND presence = 1
      LIMIT 1
    `,
    [safeId]
  );

  const row = rows[0];

  if (!row) {
    const error = new Error('Template not found');
    error.statusCode = 404;
    throw error;
  }

  return row;
}

async function createTemplate(payload, actorId = 1) {
  await ensureTemplateTable();

  const data = normalizeCreatePayload(payload || {});

  const [result] = await pool.execute(
    `
      INSERT INTO template (
        name, description, version, tempateType, json,
        presence, inputDate, inputBy, updateDate, updateBy
      )
      VALUES (?, ?, ?, ?, ?, ?, NOW(), ?, NOW(), ?)
    `,
    [
      data.name,
      data.description,
      data.version,
      data.tempateType,
      data.json,
      data.presence,
      String(actorId || 1),
      String(actorId || 1),
    ]
  );

  return getTemplateDetail(result.insertId);
}

async function updateTemplate(id, payload, actorId = 1) {
  await ensureTemplateTable();

  const safeId = parseId(id);
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

  if (payload.description !== undefined) {
    data.description = String(payload.description).trim();
  }

  if (payload.version !== undefined) {
    const value = String(payload.version).trim();
    if (!value) {
      const error = new Error('version cannot be empty');
      error.statusCode = 400;
      throw error;
    }
    data.version = value;
  }

  if (payload.tempateType !== undefined) {
    data.tempateType = String(payload.tempateType).trim();
  }

  if (payload.json !== undefined) {
    data.json = String(payload.json);
  }

  if (payload.presence !== undefined) {
    data.presence = parseStatus(payload.presence);
  }

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
      UPDATE template
      SET ${setClause}, updateDate = NOW(), updateBy = ?
      WHERE id = ? AND presence = 1
    `,
    [...values, String(actorId || 1), safeId]
  );

  if (!result.affectedRows) {
    const error = new Error('Template not found');
    error.statusCode = 404;
    throw error;
  }

  return getTemplateDetail(safeId);
}

async function deleteTemplate(id, actorId = 1) {
  await ensureTemplateTable();

  const safeId = parseId(id);

  const [result] = await pool.execute(
    `
      UPDATE template
      SET presence = 0, updateDate = NOW(), updateBy = ?, json = ''
      WHERE id = ? AND presence = 1
    `,
    [String(actorId || 1), safeId]
  );

  if (!result.affectedRows) {
    const error = new Error('Template not found');
    error.statusCode = 404;
    throw error;
  }

  return { id: safeId };
}

module.exports = {
  listTemplates,
  getTemplateDetail,
  createTemplate,
  updateTemplate,
  deleteTemplate,
};
