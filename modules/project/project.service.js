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

function normalizeDate(value, fieldName) {
    if (!value) {
        const error = new Error(`${fieldName} is required`);
        error.statusCode = 400;
        throw error;
    }

    if (typeof value === 'string') {
        const raw = value.trim();

        if (!raw) {
            const error = new Error(`${fieldName} is required`);
            error.statusCode = 400;
            throw error;
        }

        if (/^\d{4}-\d{2}-\d{2}$/.test(raw)) {
            return raw;
        }

        const parsed = new Date(raw);

        if (!Number.isNaN(parsed.getTime())) {
            const yyyy = parsed.getFullYear();
            const mm = String(parsed.getMonth() + 1).padStart(2, '0');
            const dd = String(parsed.getDate()).padStart(2, '0');
            return `${yyyy}-${mm}-${dd}`;
        }

        const error = new Error(`${fieldName} must be a valid date`);
        error.statusCode = 400;
        throw error;
    }

    if (typeof value === 'object') {
        const year = Number(value.year);
        const month = Number(value.month);
        const day = Number(value.day);

        if (!Number.isInteger(year) || !Number.isInteger(month) || !Number.isInteger(day)) {
            const error = new Error(`${fieldName} must be a valid date`);
            error.statusCode = 400;
            throw error;
        }

        const yyyy = String(year).padStart(4, '0');
        const mm = String(month).padStart(2, '0');
        const dd = String(day).padStart(2, '0');
        return `${yyyy}-${mm}-${dd}`;
    }

    const error = new Error(`${fieldName} must be a valid date`);
    error.statusCode = 400;
    throw error;
}

function buildProjectId(inputId) {
    if (inputId && String(inputId).trim()) {
        return String(inputId).trim();
    }

    return `PRJ-${randomUUID().split('-')[0].toUpperCase()}`;
}

function validateCreatePayload(payload) {
    const requiredFields = [
        'name',
        'projectTypeId',
        'projectBilleableId',
        'productId',
        'clientId',
        'startDate',
        'endDate',
    ];

    const missing = requiredFields.filter((field) => {
        const value = payload[field];
        return value === undefined || value === null || value === '';
    });

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

    if (filters.id !== undefined) {
        conditions.push('p.id = ?');
        params.push(String(filters.id));
    }

    if (filters.keyword) {
        conditions.push('(p.id LIKE ? OR p.name LIKE ? OR c.name LIKE ?)');
        params.push(`%${filters.keyword}%`, `%${filters.keyword}%`, `%${filters.keyword}%`);
    }

    const whereClause = `WHERE ${conditions.join(' AND ')}`;
const q =   `
      SELECT
        p.*,
        c.name AS clientName,
        pt.name AS projectTypeName,
        pb.name AS projectBilleableName,
        pr.name AS productName,
        '' as users
        
      FROM project p
      LEFT JOIN client c ON c.id = p.clientId
      LEFT JOIN project_type pt ON pt.id = p.projectTypeId
      LEFT JOIN project_billeable pb ON pb.id = p.projectBilleableId
      LEFT JOIN product pr ON pr.id = p.productId
      ${whereClause}
      ORDER BY p.inputDate DESC
    `;
    console.log('Executing query:', q, 'with params:', params);
    const [rows] = await pool.execute(
      q,
        params
    );


    const queryUser = `
        SELECT
        p.projectId,  p.userId, CONCAT( c.firstName, ' ',c.lastName) AS 'name', p.asManager 
        FROM project_users p
        LEFT JOIN user c ON c.id = p.userId
        WHERE p.presence = 1
    `; 
    const [users] = await pool.execute(queryUser);


    // Map users to their respective projects
    const projectUsersMap = {};
    for (const user of users) {
        if (!projectUsersMap[user.projectId]) {
            projectUsersMap[user.projectId] = [];
        }
        projectUsersMap[user.projectId].push({
            id: user.userId,
            name: user.name,
            asManager: user.asManager === 1,
        });
    }

    // Attach users to their respective projects
    for (const project of rows) {
        project.users = projectUsersMap[project.id] || [];
    }

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
        pr.name AS productName,
        '' as users
      FROM project p
      LEFT JOIN client c ON c.id = p.clientId
      LEFT JOIN project_type pt ON pt.id = p.projectTypeId
      LEFT JOIN project_billeable pb ON pb.id = p.projectBilleableId
      LEFT JOIN product pr ON pr.id = p.productId
      WHERE p.id = ? AND p.presence = 1
      LIMIT 1
    `,
        [id]
    );

    const row = rows[0];
    
    
 const [users] = await pool.execute(
        `
      SELECT
        p.userId, p.asManager , true as checkbox 
      FROM project_users p
      LEFT JOIN user c ON c.id = p.userId 
      WHERE   p.presence = 1 and projectId = ?
    `,
        [id]
    );

    row.users = users;

    if (!row) {
        const error = new Error('Project not found');
        error.statusCode = 404;
        throw error;
    }

    return row;
}

async function createProject(payload, actorId = '1') {
 

    const id = buildProjectId(payload.id);

    const name = String(payload.name || '').trim();
    if (!name) {
        const error = new Error('name is required');
        error.statusCode = 400;
        throw error;
    }

    const status = payload.status === undefined ? 1 : parseStatus(payload.status);
    const templateMaster = payload.templateMaster === undefined ? '0' : String(payload.templateMaster);

    await pool.execute(
        `
      INSERT INTO project (
        id, name, projectTypeId, projectBilleableId, productId, clientId,
        startDate, endDate, status, templateMaster,
        presence, inputDate, inputBy, updateDate, updateBy,
        ticketCategoriesParentId
      )
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 1, NOW(), ?, NOW(), ?, ?)
    `,
        [
            id,
            name,
            parseNumeric(payload.projectTypeId, 'projectTypeId'),
            parseNumeric(payload.projectBilleableId, 'projectBilleableId'),
            parseNumeric(payload.productId, 'productId'),
            String(payload.clientId),
            normalizeDate(payload.startDate, 'startDate'),
            normalizeDate(payload.endDate, 'endDate'),
            status,
            templateMaster,
            String(actorId),
            String(actorId),
            parseNumeric(payload.ticketCategoriesParentId, 'ticketCategoriesParentId'),
        ]
    );

    console.log('payload.projectUsers:', payload.projectUsers);
    for (const pu of payload.projectUsers) {
       
        if(pu.checkbox == true){
            const q =  `
            INSERT INTO project_users (
                projectId, userId, asManager,
                presence, inputDate, inputBy, updateDate, updateBy
            )
            VALUES ( '${id}', '${pu.id}', ${pu.asManager === true ? 1 : 0}, 
            1, NOW(), '${String(actorId)}', NOW(), '${String(actorId)}')
            `;
            console.log('Executing query:', q);
            await pool.execute(q);
        }
       
    }
  



    return getProjectDetail(id);
}

async function updateProject(id, payload, actorId = '1') {
    const fields = [];
    const params = [];

    if (payload.name !== undefined) {
        const value = String(payload.name).trim();

        if (!value) {
            const error = new Error('name cannot be empty');
            error.statusCode = 400;
            throw error;
        }

        fields.push('name = ?');
        params.push(value);
    }

    if (payload.projectTypeId !== undefined) {
        fields.push('projectTypeId = ?');
        params.push(parseNumeric(payload.projectTypeId, 'projectTypeId'));
    }

    if (payload.projectBilleableId !== undefined) {
        fields.push('projectBilleableId = ?');
        params.push(parseNumeric(payload.projectBilleableId, 'projectBilleableId'));
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
        params.push(normalizeDate(payload.startDate, 'startDate'));
    }

    if (payload.endDate !== undefined) {
        fields.push('endDate = ?');
        params.push(normalizeDate(payload.endDate, 'endDate'));
    }

    if (payload.status !== undefined) {
        fields.push('status = ?');
        params.push(parseStatus(payload.status));
    }

    if (payload.templateMaster !== undefined) {
        fields.push('templateMaster = ?');
        params.push(String(payload.templateMaster));
    }
 if (payload.ticketCategoriesId !== undefined) {
        fields.push('ticketCategoriesParentId = ?');
        params.push(Number(payload.ticketCategoriesId));
    }
    if (!fields.length) {
        const error = new Error('No valid fields provided');
        error.statusCode = 400;
        throw error;
    }

    const [result] = await pool.execute(
        `
      UPDATE project
      SET ${fields.join(', ')}, updateDate = NOW(), updateBy = ?
      WHERE id = ? AND presence = 1
    `,
        [...params, String(actorId), id]
    );

    const q =  `
    DELETE FROM project_users
    WHERE projectId = '${id}'`;
  
    await pool.execute(q); 
    for (const pu of payload.users) {
       
        const q =  `
        INSERT INTO project_users (
            projectId, userId, asManager,
            presence, inputDate, inputBy, updateDate, updateBy
        )
        VALUES ( 
            '${id}', '${pu.id}', ${pu.asManager === true ? 1 : 0}, 
            1, NOW(), '${String(actorId)}', NOW(), '${String(actorId)}')
        `;
 
        await pool.execute(q); 
    }


    if (!result.affectedRows) {
        const error = new Error('Project not found');
        error.statusCode = 404;
        throw error;
    }

    return getProjectDetail(id);
}

async function deleteProject(id, actorId = '1') {
    const [result] = await pool.execute(
        `
      UPDATE project
      SET presence = 0, updateDate = NOW(), updateBy = ?
      WHERE id = ? AND presence = 1
    `,
        [String(actorId), id]
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
