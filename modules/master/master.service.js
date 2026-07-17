const { pool } = require('../../config/db');

const tableMap = {
  industry: {
    tableName: 'industry',
    hasStatus: false,
    hasPresence: true,
    requiredFields: ['name'],
    editableFields: ['name'],
    numericFields: [],
    allowCreate: true,
    allowUpdate: true,
    allowDelete: true,
  },
  product: {
    tableName: 'product',
    hasStatus: true,
    hasPresence: true,
    requiredFields: ['name'],
    editableFields: ['name', 'status'],
    numericFields: ['status'],
    allowCreate: true,
    allowUpdate: true,
    allowDelete: true,
  },
  'project-type': {
    tableName: 'project_type',
    hasStatus: true,
    hasPresence: true,
    requiredFields: ['name'],
    editableFields: ['name', 'ticketBased', 'status'],
    numericFields: ['ticketBased', 'status'],
    allowCreate: true,
    allowUpdate: true,
    allowDelete: true,
  },
  project_type: {
    tableName: 'project_type',
    hasStatus: true,
    hasPresence: true,
    requiredFields: ['name'],
    editableFields: ['name', 'ticketBased', 'status'],
    numericFields: ['ticketBased', 'status'],
    allowCreate: true,
    allowUpdate: true,
    allowDelete: true,
  },
  'project-billeable': {
    tableName: 'project_billeable',
    hasStatus: true,
    hasPresence: true,
    requiredFields: ['name'],
    editableFields: ['name', 'status'],
    numericFields: ['status'],
    allowCreate: true,
    allowUpdate: true,
    allowDelete: true,
  },
  project_billeable: {
    tableName: 'project_billeable',
    hasStatus: true,
    hasPresence: true,
    requiredFields: ['name'],
    editableFields: ['name', 'status'],
    numericFields: ['status'],
    allowCreate: true,
    allowUpdate: true,
    allowDelete: true,
  },
  'project-categories': {
    tableName: 'project_categories',
    hasStatus: true,
    hasPresence: true,
    requiredFields: ['name'],
    editableFields: ['name', 'status'],
    numericFields: ['status'],
    allowCreate: true,
    allowUpdate: true,
    allowDelete: true,
  },
  project_categories: {
    tableName: 'project_categories',
    hasStatus: true,
    hasPresence: true,
    requiredFields: ['name'],
    editableFields: ['name', 'status'],
    numericFields: ['status'],
    allowCreate: true,
    allowUpdate: true,
    allowDelete: true,
  },
  'user-auth-level': {
    tableName: 'user_auth_level',
    hasStatus: false,
    hasPresence: true,
    requiredFields: ['name'],
    editableFields: ['name'],
    numericFields: [],
    allowCreate: true,
    allowUpdate: true,
    allowDelete: true,
  },
  'user-type': {
    tableName: 'user_type',
    hasStatus: false,
    hasPresence: true,
    requiredFields: ['name'],
    editableFields: ['name'],
    numericFields: [],
    allowCreate: true,
    allowUpdate: true,
    allowDelete: true,
  },
  'user-access-right': {
    tableName: 'user_access_right',
    hasStatus: false,
    hasPresence: true,
    requiredFields: ['authLevelId', 'moduleId'],
    editableFields: ['authLevelId', 'moduleId', 'c', 'r', 'u', 'd'],
    numericFields: ['authLevelId', 'moduleId', 'c', 'r', 'u', 'd'],
    allowCreate: true,
    allowUpdate: true,
    allowDelete: true,
  },
  user_access_right: {
    tableName: 'user_access_right',
    hasStatus: false,
    hasPresence: true,
    requiredFields: ['authLevelId', 'moduleId'],
    editableFields: ['authLevelId', 'moduleId', 'c', 'r', 'u', 'd'],
    numericFields: ['authLevelId', 'moduleId', 'c', 'r', 'u', 'd'],
    allowCreate: true,
    allowUpdate: true,
    allowDelete: true,
  },
  module: {
    tableName: 'module',
    hasStatus: false,
    hasPresence: false,
    requiredFields: ['name'],
    editableFields: ['name'],
    numericFields: [],
    allowCreate: false,
    allowUpdate: false,
    allowDelete: false,
  },
  'global-setting': {
    tableName: 'global_setting',
    hasStatus: false,
    hasPresence: false,
    requiredFields: ['name', 'value'],
    editableFields: ['name', 'value', 'note'],
    numericFields: [],
    allowCreate: false,
    allowUpdate: true,
    allowDelete: false,
  },
  global_setting: {
    tableName: 'global_setting',
    hasStatus: false,
    hasPresence: false,
    requiredFields: ['name', 'value'],
    editableFields: ['name', 'value', 'note'],
    numericFields: [],
    allowCreate: false,
    allowUpdate: true,
    allowDelete: false,
  },
   ticketStatus: {
    tableName: 'ticket_status',
    hasStatus: false,
    hasPresence: false,
    requiredFields: ['name', 'id'],
    editableFields: ['name', 'id'],
    numericFields: [],
    allowCreate: false,
    allowUpdate: true,
    allowDelete: false,
  },
  'ticket-severities': {
    tableName: 'ticket_severity',
    orderBy: 'id ASC',
    hasStatus: false,
    hasPresence: true,
    requiredFields: ['name', 'duration'],
    editableFields: ['name', 'duration'],
    numericFields: ['duration'],
    allowCreate: true,
    allowUpdate: true,
    allowDelete: true,
  },
  ticket_severities: {
    tableName: 'ticket_severity',
    orderBy: 'id ASC',
    hasStatus: false,
    hasPresence: true,
    requiredFields: ['name', 'duration'],
    editableFields: ['name', 'duration'],
    numericFields: ['duration'],
    allowCreate: true,
    allowUpdate: true,
    allowDelete: true,
  },
  'ticket-severity': {
    tableName: 'ticket_severity',
    orderBy: 'id ASC',
    hasStatus: false,
    hasPresence: true,
    requiredFields: ['name', 'duration'],
    editableFields: ['name', 'duration'],
    numericFields: ['duration'],
    allowCreate: true,
    allowUpdate: true,
    allowDelete: true,
  },
  ticket_severity: {
    tableName: 'ticket_severity',
    orderBy: 'id ASC',
    hasStatus: false,
    hasPresence: true,
    requiredFields: ['name', 'duration'],
    editableFields: ['name', 'duration'],
    numericFields: ['duration'],
    allowCreate: true,
    allowUpdate: true,
    allowDelete: true,
  },
  ticketSeverity: {
    tableName: 'ticket_severity',
    orderBy: 'id ASC',
    hasStatus: false,
    hasPresence: true,
    requiredFields: ['name', 'duration'],
    editableFields: ['name', 'duration'],
    numericFields: ['duration'],
    allowCreate: true,
    allowUpdate: true,
    allowDelete: true,
  },
  rating: {
    tableName: 'rating',
    hasStatus: true,
    hasPresence: true,
    requiredFields: ['name'],
    editableFields: ['name', 'status'],
    numericFields: ['status'],
    allowCreate: true,
    allowUpdate: true,
    allowDelete: true,
  },
};

function getMasterConfig(masterKey) {
  const config = tableMap[masterKey];

  if (!config) {
    const error = new Error('Master data endpoint not found');
    error.statusCode = 404;
    throw error;
  }

  return config;
}

function assertRequiredFields(config, payload) {
  const missingFields = config.requiredFields.filter((field) => {
    const value = payload[field];
    return value === undefined || value === null || value === '';
  });

  if (missingFields.length) {
    const error = new Error(`Missing required fields: ${missingFields.join(', ')}`);
    error.statusCode = 400;
    throw error;
  }
}

function assertOperationAllowed(config, action) {
  const permissionMap = {
    create: config.allowCreate,
    update: config.allowUpdate,
    delete: config.allowDelete,
  };

  if (permissionMap[action]) {
    return;
  }

  const error = new Error(`Operation not allowed for this master key: ${action}`);
  error.statusCode = 405;
  throw error;
}

function buildEditablePayload(config, payload) {
  const normalizedPayload = {};

  for (const field of config.editableFields) {
    if (payload[field] === undefined) {
      continue;
    }

    if (config.numericFields.includes(field)) {
      normalizedPayload[field] = Number(payload[field]);
    } else {
      normalizedPayload[field] = payload[field];
    }
  }

  return normalizedPayload;
}

async function getMasterData(masterKey, filters = {}) {
  const config = getMasterConfig(masterKey);
  const orderBy = config.orderBy || 'id ASC';

  const conditions = [];
  const params = [];

  if (config.hasPresence !== false) {
    conditions.push('presence = 1');
  }

  if (config.hasStatus && filters.status !== undefined) {
    conditions.push('status = ?');
    params.push(Number(filters.status));
  }

  if (config.tableName === 'user_access_right' && filters.authLevelId !== undefined) {
    conditions.push('authLevelId = ?');
    params.push(Number(filters.authLevelId));
  }

  const whereClause = conditions.length ? `WHERE ${conditions.join(' AND ')}` : '';
  const [rows] = await pool.execute(
    `SELECT * FROM ${config.tableName} ${whereClause} ORDER BY ${orderBy}`,
    params
  );
  console.log('Executed SQL:', `SELECT * FROM ${config.tableName} ${whereClause} ORDER BY ${orderBy}`, 'with params:', params);
  
  return rows;
}

async function getMasterDetail(masterKey, id) {
  const config = getMasterConfig(masterKey);
  const wherePresence = config.hasPresence === false ? '' : ' AND presence = 1';
  const [rows] = await pool.execute(
    `SELECT * FROM ${config.tableName} WHERE id = ?${wherePresence} LIMIT 1`,
    [id]
  );

  const row = rows[0];

  if (!row) {
    const error = new Error('Master data not found');
    error.statusCode = 404;
    throw error;
  }

  return row;
}

async function createMasterData(masterKey, payload) {
  const config = getMasterConfig(masterKey);
  assertOperationAllowed(config, 'create');
  assertRequiredFields(config, payload);

  const data = buildEditablePayload(config, payload);
  const columns = Object.keys(data);
  const values = Object.values(data);

  if (!columns.length) {
    const error = new Error('No valid fields provided');
    error.statusCode = 400;
    throw error;
  }

  const sql = `
    INSERT INTO ${config.tableName}
      (${columns.join(', ')}, presence, inputDate, inputBy, updateDate, updateBy)
    VALUES
      (${columns.map(() => '?').join(', ')}, 1, NOW(), 1, NOW(), 1)
  `;

  const [result] = await pool.execute(sql, values);
  return getMasterDetail(masterKey, result.insertId);
}

async function updateMasterData(masterKey, id, payload) {
  const config = getMasterConfig(masterKey);
  assertOperationAllowed(config, 'update');
  const data = buildEditablePayload(config, payload);
  const columns = Object.keys(data);

  if (!columns.length) {
    const error = new Error('No valid fields provided');
    error.statusCode = 400;
    throw error;
  }

  const setClause = columns.map((field) => `${field} = ?`).join(', ');
  const values = columns.map((field) => data[field]);

  const wherePresence = config.hasPresence === false ? '' : ' AND presence = 1';
  const [result] = await pool.execute(
    `
      UPDATE ${config.tableName}
      SET ${setClause}, updateDate = NOW(), updateBy = 1
      WHERE id = ?${wherePresence}
    `,
    [...values, id]
  );

  if (!result.affectedRows) {
    const error = new Error('Master data not found');
    error.statusCode = 404;
    throw error;
  }

  return getMasterDetail(masterKey, id);
}

async function deleteMasterData(masterKey, id) {
  const config = getMasterConfig(masterKey);
  assertOperationAllowed(config, 'delete');

  if (config.hasPresence === false) {
    const error = new Error('Soft delete is not supported for this master key');
    error.statusCode = 405;
    throw error;
  }

  const [result] = await pool.execute(
    `
      UPDATE ${config.tableName}
      SET presence = 0, updateDate = NOW(), updateBy = 1
      WHERE id = ? AND presence = 1
    `,
    [id]
  );

  if (!result.affectedRows) {
    const error = new Error('Master data not found');
    error.statusCode = 404;
    throw error;
  }

  return { id: Number(id) };
}

async function loadbBadge() {
  const q = `SELECT 'task' AS name, COUNT(id) AS 'total'  FROM ticket 
where presence = 1 and ticketStatusId  < 900 AND ticketTypeId = 1

UNION ALL

SELECT 'issue' AS name, COUNT(id) AS 'total'  FROM ticket 
where presence = 1 and ticketStatusId  < 900 AND ticketTypeId = 2
UNION ALL

SELECT 'cr' AS name, COUNT(id) AS 'total'  FROM ticket 
where presence = 1 and ticketStatusId  < 900 AND   ticketTypeId = 3

`;
  const [rows] = await pool.execute(q);
  return rows;
}

module.exports = {
  getMasterData,
  getMasterDetail,
  createMasterData,
  updateMasterData,
  deleteMasterData,
  loadbBadge,
};
