const { randomUUID } = require('crypto');
const { pool } = require('../../config/db');
const { runningNumber } = require('../../helpers/autoNumber');

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

function normalizeDateTime(value) {
    if (!value) {
        return null;
    }

    if (typeof value === 'object' && value !== null) {
        if ('year' in value && 'month' in value && 'day' in value) {
            const yyyy = String(Number(value.year)).padStart(4, '0');
            const mm = String(Number(value.month)).padStart(2, '0');
            const dd = String(Number(value.day)).padStart(2, '0');
            return `${yyyy}-${mm}-${dd} 00:00:00`;
        }
    }

    const parsed = new Date(value);
    if (Number.isNaN(parsed.getTime())) {
        return null;
    }

    const yyyy = parsed.getFullYear();
    const mm = String(parsed.getMonth() + 1).padStart(2, '0');
    const dd = String(parsed.getDate()).padStart(2, '0');
    const hh = String(parsed.getHours()).padStart(2, '0');
    const mi = String(parsed.getMinutes()).padStart(2, '0');
    const ss = String(parsed.getSeconds()).padStart(2, '0');

    return `${yyyy}-${mm}-${dd} ${hh}:${mi}:${ss}`;
}

function toNumberOrDefault(value, fallback = 0) {
    const parsed = Number(value);
    return Number.isFinite(parsed) ? parsed : fallback;
}

function flattenTemplateItems(collection) {
    if (!Array.isArray(collection)) {
        return [];
    }

    const items = [];

    for (const group of collection) {
        if (Array.isArray(group?.data)) {
            for (const item of group.data) {
                items.push({ item, group });
            }
            continue;
        }

        if (group && typeof group === 'object') {
            items.push({ item: group, group: null });
        }
    }

    return items;
}

async function buildTemplateTicketId(ticketTypeId) {
    if (ticketTypeId === 2) {
        return runningNumber('issue');
    }

    if (ticketTypeId === 3) {
        return runningNumber('changeRequest');
    }

    return runningNumber('task');
}

async function insertTemplateTickets(connection, template, projectId, actorId) {
    if (!template || typeof template !== 'object') {
        return;
    }

    const ticketSources = [
        { list: template.task, ticketTypeId: 1 },
        { list: template.tasks, ticketTypeId: 1 },
        { list: template.cases, ticketTypeId: 2 },
        { list: template.cr, ticketTypeId: 3 },
    ];

    for (const source of ticketSources) {
        const entries = flattenTemplateItems(source.list);

        for (const entry of entries) {
            const item = entry.item || {};
            const group = entry.group || {};
            const title = String(item.title || '').trim();

            if (!title) {
                continue;
            }

            const submitDateTime =  normalizeDateTime(new Date());
            const targetCompletionDate = normalizeDate(item.targetCompletionDate || item.actualCompletionDate || item.submitDate || new Date(), 'targetCompletionDate');
            const actualCompletionDate = normalizeDate(item.actualCompletionDate || item.targetCompletionDate || item.submitDate || new Date(), 'actualCompletionDate');
            const ticketId = await buildTemplateTicketId(source.ticketTypeId);

            await connection.execute(
                `
                INSERT INTO ticket (
                    id, ticketTypeId, ticketCategoryId, ticketSeverityId, productChildId,
                    crNoRef, issueNo, title, description, projectId, submitBy,
                    submitDate, deadlineDateTime, targetCompletionDate, assignTo,
                    taskSolution, actualCompletionDate, ticketStatusId, rating, ratesBy,
                    ticketEstimationCost, presence, inputDate, inputBy, updateDate, updateBy
                )
                VALUES (
                    ?, ?, ?, ?, ?,
                    ?, ?, ?, ?, ?, ?,
                    ?, ?, ?, ?,
                    ?, ?, ?, ?, ?,
                    ?, 1, NOW(), ?, NOW(), ?
                )
                `,
                [
                    ticketId,
                    source.ticketTypeId,
                    toNumberOrDefault(item.ticketCategoryId ?? group.id, 0),
                    toNumberOrDefault(item.ticketSeverityId, 0),
                    String(item.productChildId || ''),
                    String(item.crNoRef || ''),
                    String(item.issueNo || ''),
                    title,
                    String(item.description || ''),
                    String(projectId),
                    String(item.submitBy || actorId),
                    submitDateTime,
                    submitDateTime,
                    targetCompletionDate,
                    String(item.assignTo || ''),
                    String(item.taskSolution || ''),
                    actualCompletionDate,
                    toNumberOrDefault(item.ticketStatusId, 1),
                    toNumberOrDefault(item.rating, 0),
                    String(item.ratesBy || ''),
                    toNumberOrDefault(item.ticketEstimationCost, 0),
                    String(actorId),
                    String(actorId),
                ]
            );
        }
    }
}

async function insertTemplateContacts(connection, template, projectId, clientId, actorId) {
    if (!template || typeof template !== 'object' || !Array.isArray(template.contacts)) {
        return;
    }

    const userIds = new Set();

    for (const contact of template.contacts) {
        const userId = String(contact?.userId || contact?.id || '').trim();

        if (!userId || /^\d+$/.test(userId) || userIds.has(userId)) {
            continue;
        }

        userIds.add(userId);

        await connection.execute(
            `
            INSERT INTO project_contact (
                projectId, clientId, userId,
                presence, inputDate, inputBy, updateDate, updateBy
            )
            VALUES (?, ?, ?, 1, NOW(), ?, NOW(), ?)
            `,
            [
                String(projectId),
                String(clientId),
                userId,
                String(actorId),
                String(actorId),
            ]
        );
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
    const q = `
      SELECT
        p.*,
        c.name AS clientName,
        pt.name AS projectTypeName,
        pb.name AS projectBilleableName,
        pr.name AS productName,
        '' as users,
        '' as modules
        
      FROM project p
      LEFT JOIN client c ON c.id = p.clientId
      LEFT JOIN project_type pt ON pt.id = p.projectTypeId
      LEFT JOIN project_billeable pb ON pb.id = p.projectBilleableId
      LEFT JOIN product pr ON pr.id = p.productId
      ${whereClause}
      ORDER BY p.inputDate DESC
    `; 
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


    const [products] = await pool.execute(
        `
        SELECT p.parentId AS 'productId', p.id, p.name 
        FROM product AS p
        WHERE p.presence = 1 AND p.status = 1 AND p.parentId > 0
    `
    );

    for (const project of rows) {
        project.modules = products.filter(product => product.productId === project.productId);
    }

    // jika filter.userId tidak ada di dalam array users, maka hapus project tersebut dari rows
    if (filters.userId) {
        for (let i = rows.length - 1; i >= 0; i--) {
            const project = rows[i];
            const userExists = project.users.some(user => user.id === filters.userId);
            if (!userExists) {
                rows.splice(i, 1);
            }
        }
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
        pt.ticketBased,
        '' as users,
        '' as ticketCategories,
        '' as ticketBalance,
        '' as contacts,
        '' as modules,
        t.name as templateName
      FROM project p
      LEFT JOIN client c ON c.id = p.clientId
      LEFT JOIN project_type pt ON pt.id = p.projectTypeId
      LEFT JOIN project_billeable pb ON pb.id = p.projectBilleableId
      LEFT JOIN product pr ON pr.id = p.productId
      left join template as t on t.id = p.templateMaster
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

    const [users] = await pool.execute(
        ` 
         SELECT u.id, CONCAT(u.firstName, ' ',u.lastName) AS 'name', u.email,
        l.name AS 'userAuthLevel', u.division, u.position, u.userAuthLevelId, u.userTypeId,
        IFNULL(t.asManager,0) AS 'asManager', IFNULL(t.checked, 0) AS 'checked'
        FROM user u
        LEFT JOIN (
            SELECT p.userId AS id, p.asManager, 1 AS 'checked'
            FROM project_users p
            WHERE p.presence = 1 AND p.projectId = ?
        ) AS t ON t.id = u.id
        LEFT JOIN user_auth_level AS l ON l.id = u.userAuthLevelId
        WHERE u.presence = 1 AND u.userTypeId = 1
    `,
        [id]
    ); 
    if (!users || users.length === 0) {
        row.users = [];
    } else {
        row.users = users;
    }

    const [contacts] = await pool.execute(
        `
     SELECT p.id, p.userId, CONCAT(u.firstName, ' ',u.lastName) AS name ,
    u.phone, u.email, p.projectId, u.division, u.position
    FROM project_contact AS p
    LEFT JOIN user AS u ON u.id = p.userId
    where p.presence = 1 AND p.projectId = ?
    `,
        [id]
    );
    row.contacts = contacts;

    const [ticketCategories] = await pool.execute(
        `
        SELECT id, name
        FROM ticket_categories      
        WHERE presence = 1 and parentId = ? and status = 1 
        order by name asc
        `,
        [row.ticketCategoriesParentId]
    );
    row.ticketCategories = ticketCategories;



    const [ticketBalance] = await pool.execute(
        `
       SELECT 
           IFNULL(SUM(ticketIn), 0) AS 'ticketIn' , 
            IFNULL(SUM(ticketOut), 0) AS 'ticketOut' ,  
            IFNULL(SUM(ticketIn - ticketOut), 0)  AS 'balance'
        FROM ticket_balance WHERE projectId =  ? AND presence = 1
        `,
        [id]
    );
    row.ticketBalance = ticketBalance[0];


    const [products] = await pool.execute(
        `
        SELECT p.parentId AS 'productId', p.id, p.name 
        FROM product AS p
        WHERE p.presence = 1 AND p.status = 1 AND p.parentId > 0
    `
    );

    for (const project of rows) {
        row.modules = products.filter(product => product.productId === row.productId);
    }


    if (!row) {
        const error = new Error('Project not found');
        error.statusCode = 404;
        throw error;
    }

    return row;
}

async function createProject(payload, actorId = '1') {
    validateCreatePayload(payload || {});
    const id = buildProjectId(payload.id);

    const name = String(payload.name || '').trim();
    if (!name) {
        const error = new Error('name is required');
        error.statusCode = 400;
        throw error;
    }

    const status = payload.status === undefined ? 1 : parseStatus(payload.status);
    const templateMaster = payload.templateMaster === undefined ? '0' : String(payload.templateMaster);
    const projectTypeId = parseNumeric(payload.projectTypeId, 'projectTypeId');
    const projectBilleableId = parseNumeric(payload.projectBilleableId, 'projectBilleableId');
    const productId = parseNumeric(payload.productId, 'productId');
    const clientId = String(payload.clientId);
    const startDate = normalizeDate(payload.startDate, 'startDate');
    const endDate = normalizeDate(payload.endDate, 'endDate');
    const ticketCategoriesParentId = parseNumeric(payload.ticketCategoriesParentId, 'ticketCategoriesParentId');

    const connection = await pool.getConnection();

    try {
        await connection.beginTransaction();

        await connection.execute(
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
                projectTypeId,
                projectBilleableId,
                productId,
                clientId,
                startDate,
                endDate,
                status,
                templateMaster,
                String(actorId),
                String(actorId),
                ticketCategoriesParentId,
            ]
        );

        const projectUsers = Array.isArray(payload.projectUsers) ? payload.projectUsers : [];
        for (const pu of projectUsers) {
            if (pu?.checked !== true) {
                continue;
            }

            await connection.execute(
                `
                INSERT INTO project_users (
                    projectId, userId, asManager,
                    presence, inputDate, inputBy, updateDate, updateBy
                )
                VALUES (?, ?, ?, 1, NOW(), ?, NOW(), ?)
                `,
                [
                    String(id),
                    String(pu.id),
                    pu.asManager === true ? 1 : 0,
                    String(actorId),
                    String(actorId),
                ]
            );
        }

        await insertTemplateTickets(connection, payload.template, id, actorId);
        await insertTemplateContacts(connection, payload.template, id, clientId, actorId);

        await connection.commit();
    } catch (error) {
        await connection.rollback();
        throw error;
    } finally {
        connection.release();
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

    const q = `
    DELETE FROM project_users
    WHERE projectId = '${id}'`;

    await pool.execute(q);
    for (const pu of payload.users) {

        const q = `
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

async function addContactToProject(payload) {
   
    for (const a of payload.contacts) { 
        const q = `
        INSERT INTO project_contact (
            projectId, clientId, userId,  
            presence, inputDate, inputBy, updateDate, updateBy
        )
        VALUES (
            '${String(payload.projectId)}', '${String(payload.clientId)}', '${String(a.id)}',
            1, NOW(), '${String(payload.actorId)}', NOW(), '${String(payload.actorId)}')
        `; 
         await pool.execute(q);
    }
    return true;
}
async function removeContactFromProject(payload) {
    console.log('removeContactFromProject payload:', payload);
    for (const a of payload) { 
        const q = `
        UPDATE project_contact
        SET presence = 0, updateDate = NOW(), updateBy = '${String(payload.actorId)}'
        WHERE  id = '${String(a.id)}' `;
        await pool.execute(q);
    }
    return true;
}

module.exports = {
    listProjects,
    getProjectDetail,
    createProject,
    updateProject,
    deleteProject,
    addContactToProject,
    removeContactFromProject,
};
