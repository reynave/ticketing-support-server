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

    // Optional: only show projects whose product is registered to the current user
    // (project.productId matches user_product.productId for the logged-in user).
    const matchUserProduct =
        filters.matchUserProduct === '1' ||
        filters.matchUserProduct === 1 ||
        filters.matchUserProduct === true;

    if (matchUserProduct) {
        conditions.push(
            `EXISTS (
                SELECT 1
                FROM user_product up
                WHERE up.productId = p.productId AND up.userId = ? AND up.presence = 1
            )`
        );
        params.push(filters.userId || '');
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
        pt.ticketBased,
        '' as users,
        '' as modules,
        (  select sum(ticketIn - ticketOut) as ticketBalance from ticket_balance where projectId = p.id and presence = 1 ) as ticketBalance
        
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

    // jika filter.contactUserId ada, hanya tampilkan project di mana user tersebut terdaftar sebagai contact
    if (filters.contactUserId) {
        const [contacts] = await pool.execute(
            `
            SELECT projectId
            FROM project_contact
            WHERE presence = 1 AND userId = ?
            `,
            [String(filters.contactUserId)]
        );
        const allowedProjectIds = new Set(contacts.map((contact) => String(contact.projectId)));

        for (let i = rows.length - 1; i >= 0; i--) {
            if (!allowedProjectIds.has(String(rows[i].id))) {
                rows.splice(i, 1);
            }
        }
    }

    return rows;
}

async function listProjectDrafts(filters = {}) {
    const conditions = ['p.presence = 4'];
    const params = [];

    if (filters.userId) {
        conditions.push('p.inputBy = ?');
        params.push(String(filters.userId));
    }

    const whereClause = `WHERE ${conditions.join(' AND ')}`;

    const q = `
      SELECT
        p.*,
        c.name AS clientName,
        pt.name AS projectTypeName,
        pb.name AS projectBilleableName,
        pr.name AS productName
      FROM project p
      LEFT JOIN client c ON c.id = p.clientId
      LEFT JOIN project_type pt ON pt.id = p.projectTypeId
      LEFT JOIN project_billeable pb ON pb.id = p.projectBilleableId
      LEFT JOIN product pr ON pr.id = p.productId
      ${whereClause}
      ORDER BY p.inputDate DESC
    `;

    const [rows] = await pool.execute(q, params);

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
      WHERE p.id = ? AND p.presence IN (1, 4)
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
        SELECT id, name, sorting, weight
        FROM ticket_categories      
        WHERE presence = 1 and parentId = ? and status = 1 
        order by sorting asc, name asc
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
    console.log(payload);
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
    const ticketBaseHours = payload.ticketBaseHours; 
    try {
        await connection.beginTransaction();

        await connection.execute(
            `
            INSERT INTO project (
                id, name, projectTypeId, projectBilleableId, productId, clientId,
                startDate, endDate, status, templateMaster,
                presence, 
                inputDate, inputBy, updateDate, updateBy,
                ticketCategoriesParentId, ticketBaseHours
            )
            VALUES (
                '${id}', '${name}', '${projectTypeId}', '${projectBilleableId}', '${productId}', '${clientId}', 
                '${startDate}', '${endDate}', '${status}', '${templateMaster}', 
                 1, 
                 NOW(), '${String(actorId)}', NOW(), '${String(actorId)}',
                 '${ticketCategoriesParentId}', '${ticketBaseHours}')
            `,
           // Removed parameter array as values are directly embedded in the query
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

    return id;
}

async function createProjectDraft(actorId = '1') {
    const id = buildProjectId('');
    const safeActor = String(actorId || '');

    await pool.execute(
        `
        INSERT INTO project (
            id, name, projectTypeId, projectBilleableId, productId, clientId,
            startDate, endDate, status, templateMaster,
            presence, inputDate, inputBy, updateDate, updateBy,
            ticketCategoriesParentId, ticketBaseHours
        )
        VALUES (?, '', 0, 0, 0, '0', CURDATE(), CURDATE(), 1, '0',
            4, NOW(), ?, NOW(), ?, 0, 0)
        `,
        [id, safeActor, safeActor]
    );

    return { id };
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

    if (payload.ticketCategoriesParentId !== undefined) {
        fields.push('ticketCategoriesParentId = ?');
        params.push(Number(payload.ticketCategoriesParentId));
    }

    if (payload.ticketBaseHours !== undefined) {
        fields.push('ticketBaseHours = ?');
        params.push(parseNumeric(payload.ticketBaseHours, 'ticketBaseHours'));
    }

    if (payload.presence !== undefined) {
        const presence = Number(payload.presence);

        if (![1, 4].includes(presence)) {
            const error = new Error('presence must be 1 or 4');
            error.statusCode = 400;
            throw error;
        }

        fields.push('presence = ?');
        params.push(presence);
    }

    const projectUsers = Array.isArray(payload.users)
        ? payload.users
        : Array.isArray(payload.projectUsers)
            ? payload.projectUsers
            : [];
    const hasUsersPayload = Array.isArray(payload.users) || Array.isArray(payload.projectUsers);
    const shouldPublish = payload.presence !== undefined && Number(payload.presence) === 1;

    if (!fields.length && !hasUsersPayload && !payload.template) {
        const error = new Error('No valid fields provided');
        error.statusCode = 400;
        throw error;
    }

    const connection = await pool.getConnection();

    try {
        await connection.beginTransaction();

        // Verify the target project exists (and is not soft-deleted).
        const [projectRows] = await connection.execute(
            'SELECT id FROM project WHERE id = ? AND presence IN (1, 4) LIMIT 1',
            [id]
        );

        if (!projectRows.length) {
            const error = new Error('Project not found');
            error.statusCode = 404;
            throw error;
        }

        await connection.execute(
            `
            UPDATE project
            SET ${fields.join(', ')}, updateDate = NOW(), updateBy = ?
            WHERE id = ? AND presence IN (1, 4)
            `,
            [...params, String(actorId), id]
        );

        if (hasUsersPayload) {
            await connection.execute('DELETE FROM project_users WHERE projectId = ?', [id]);

            for (const pu of projectUsers) {
                if (Array.isArray(payload.projectUsers) && pu?.checked !== true) {
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
                        String(pu.id ?? pu.userId ?? ''),
                        pu.asManager === true ? 1 : 0,
                        String(actorId),
                        String(actorId),
                    ]
                );
            }
        }

        if (payload.template) {
            const [projectRows] = await connection.execute(
                'SELECT clientId FROM project WHERE id = ? AND presence IN (1, 4) LIMIT 1',
                [id]
            );
            const clientId = payload.clientId !== undefined
                ? String(payload.clientId)
                : String(projectRows?.[0]?.clientId || '0');

            await insertTemplateTickets(connection, payload.template, id, actorId);
            await insertTemplateContacts(connection, payload.template, id, clientId, actorId);
        }

        if (shouldPublish) {
            await connection.execute(
                'UPDATE project SET status = 1 WHERE id = ?',
                [String(id)]
            );

            const [drafts] = await connection.execute(
                'SELECT * FROM project_ticket_draft WHERE projectId = ? AND presence = 1 ORDER BY projectSorting ASC, inputDate ASC',
                [String(id)]
            );

            for (const draft of drafts) {
                const ticketId = await runningNumber('task');

                await connection.execute(
                    `
                    INSERT INTO ticket (
                        id, ticketTypeId, ticketCategoryId, ticketSeverityId, productChildId,
                        crNoRef, issueNo, title, description,
                        targetCompletionDate, projectId, submitBy, submitDate,
                        assignTo, actualCompletionDate, ticketStatusId,
                        sorting, projectSorting, presence, inputDate, inputBy, updateDate, updateBy
                    )
                    VALUES (?, 1, ?, 0, ?, '', '', ?, ?, ?, ?, ?, NOW(), ?, ?, 1, ?, ?, 1, NOW(), ?, NOW(), ?)
                    `,
                    [
                        ticketId,
                        Number(draft.ticketCategoryId || 0),
                        String(draft.productChildId || ''),
                        String(draft.title || ''),
                        String(draft.description || ''),
                        draft.targetCompletionDate,
                        String(id),
                        String(actorId),
                        String(draft.assignTo || ''),
                        draft.actualCompletionDate,
                        Number(draft.sorting ?? 999),
                        Number(draft.projectSorting ?? 999),
                        String(actorId),
                        String(actorId),
                    ]
                );

                await connection.execute(
                    'UPDATE project_ticket_draft SET presence = 0, updateDate = NOW(), updateBy = ? WHERE id = ?',
                    [String(actorId), String(draft.id)]
                );
            }
        }

        await connection.commit();
    } catch (error) {
        await connection.rollback();
        throw error;
    } finally {
        connection.release();
    }

    return getProjectDetail(id);
}

async function deleteProject(id, actorId = '1') {
    const actor = String(actorId || '');
    const conn = await pool.getConnection();

    try {
        await conn.beginTransaction();

        const [projects] = await conn.execute(
            'SELECT id FROM project WHERE id = ? AND presence IN (1, 4) LIMIT 1',
            [String(id)]
        );

        if (!projects.length) {
            const error = new Error('Project not found');
            error.statusCode = 404;
            throw error;
        }

        await conn.execute(
            `UPDATE project SET presence = 0, updateDate = NOW(), updateBy = ? WHERE id = ? AND presence IN (1, 4)`,
            [actor, String(id)]
        );

        await conn.execute(
            `UPDATE project_ticket_draft SET presence = 0, updateDate = NOW(), updateBy = ? WHERE projectId = ? AND presence = 1`,
            [actor, String(id)]
        );

        await conn.commit();
    } catch (error) {
        await conn.rollback();
        throw error;
    } finally {
        conn.release();
    }

    return { id: String(id) };
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


async function ticketList(filters = {}) {
  const conditions = [];
  const params = [];
 

 
 if (filters.ticketTypeId !== undefined) {
    conditions.push(' t.ticketTypeId = ? ');
    params.push(String(filters.ticketTypeId));
  } 

  

   if (filters.projectId !== undefined) {
    conditions.push('t.projectId = ?');
    params.push(String(filters.projectId));
  } 
  

  if (filters.keyword) {
    conditions.push('(t.id LIKE ? OR t.title LIKE ? OR t.crNoRef LIKE ? OR t.issueNo LIKE ?)');
    params.push(`%${filters.keyword}%`, `%${filters.keyword}%`, `%${filters.keyword}%`, `%${filters.keyword}%`);
  }

  const whereClause = conditions.join(' AND ');

  
  const q = `
      SELECT t.id, t.title, t.projectId, t.submitDate, t.targetCompletionDate, t.ticketStatusId, t.ticketCategoryId,
        tt.name AS ticketTypeName,
        ts.name AS ticketStatusName,
        tc2.sorting as sorting,
        p.name AS projectName,
        tc.name as ticketCategoryNameParent,
        tc.id AS ticketCategoryIdParent,
       CONCAT(tc2.name, ' - ', tc.name) AS ticketCategoryName,
        c.name AS clientName, tc2.name AS parentCategoryName,
        t.assignTo, CONCAT(u.firstName, ' ', u.lastName) AS assignToName,
        t.productChildId, 
        pr.name AS productChildName,
        t.projectSorting
      FROM ticket t
      LEFT JOIN ticket_type tt ON tt.id = t.ticketTypeId
      LEFT JOIN ticket_status ts ON ts.id = t.ticketStatusId 
      left join project AS p ON p.id = t.projectId
      left join product AS pr ON pr.id = t.productChildId
      left join ticket_categories AS tc ON tc.id = t.ticketCategoryId
      left join ticket_categories AS tc2 ON tc2.id = p.ticketCategoriesParentId
      left join client AS c ON c.id = p.clientId
      left join user AS u ON u.id = t.assignTo
      WHERE t.presence = 1 AND   (
      ${whereClause}
      )  AND t.ticketStatusId < 900
      ORDER BY t.projectSorting ASC, t.inputDate DESC
    `;
 console.log(q,params)
  const [rows] = await pool.execute(
    q,
    params
  );

  // Buatkan array grouping berdasarkan ticketCategoryIdParent
  const groupedMap = new Map();

  for (const row of rows) {
    const parentId = row.ticketCategoryIdParent;
    const key =
      parentId === null || parentId === undefined
        ? '__ungrouped__'
        : String(parentId);

    if (!groupedMap.has(key)) {
      groupedMap.set(key, {
        id: parentId,
        name: row.ticketCategoryNameParent || row.ticketCategoryName || 'Ungrouped',
        sorting: Number(row.sorting ?? 0),
        data: [],
      });
    }

    groupedMap.get(key).data.push(row);
  }

  const grouped = Array.from(groupedMap.values()).sort(
    (a, b) => a.sorting - b.sorting || String(a.name).localeCompare(String(b.name))
  );

  return grouped;
}

async function draftTaskList(filters = {}) {
    const conditions = ['d.presence = 1', 'd.ticketTypeId = ?'];
    const params = [String(filters.ticketTypeId ?? '1')];

    if (filters.projectId !== undefined && String(filters.projectId).trim()) {
        conditions.push('d.projectId = ?');
        params.push(String(filters.projectId));
    }

    const whereClause = conditions.join(' AND ');

    const q = `
      SELECT d.id, d.title, d.projectId, d.submitDate, d.targetCompletionDate,
        d.ticketStatusId, d.ticketCategoryId, d.rating, d.projectSorting,
        tt.name AS ticketTypeName,
        ts.name AS ticketStatusName,
        tc.name AS ticketCategoryName,
        tc.id AS ticketCategoryId,
        tc.sorting AS sorting,
        d.assignTo, CONCAT(u.firstName, ' ', u.lastName) AS assignToName,
        d.productChildId, pr.name AS productChildName
      FROM project_ticket_draft d
      LEFT JOIN ticket_type tt ON tt.id = d.ticketTypeId
      LEFT JOIN ticket_status ts ON ts.id = d.ticketStatusId
      LEFT JOIN ticket_categories AS tc ON tc.id = d.ticketCategoryId
      LEFT JOIN product AS pr ON pr.id = d.productChildId
      LEFT JOIN user AS u ON u.id = d.assignTo
      WHERE ${whereClause}
      ORDER BY d.projectSorting ASC, d.inputDate DESC
    `;

    const [rows] = await pool.execute(q, params);

    const groupedMap = new Map();

    for (const row of rows) {
        const key = row.ticketCategoryId === null || row.ticketCategoryId === undefined
            ? '__ungrouped__'
            : String(row.ticketCategoryId);

        if (!groupedMap.has(key)) {
            groupedMap.set(key, {
                id: row.ticketCategoryId,
                name: row.ticketCategoryName || 'Ungrouped',
                sorting: Number(row.sorting ?? 0),
                data: [],
            });
        }

        groupedMap.get(key).data.push(row);
    }

    const grouped = Array.from(groupedMap.values()).sort(
        (a, b) => a.sorting - b.sorting || String(a.name).localeCompare(String(b.name))
    );

    return grouped;
}


async function createProjectDraftTask(projectId, payload, actorId) {
    const [projects] = await pool.execute(
        'SELECT id FROM project WHERE id = ? AND presence IN (1, 4) LIMIT 1',
        [String(projectId)]
    );

    if (!projects.length) {
        const error = new Error('Project not found');
        error.statusCode = 404;
        throw error;
    }

    const title = String(payload.title || '').trim();

    if (!title) {
        const error = new Error('title is required');
        error.statusCode = 400;
        throw error;
    }

    const assignTo = String(payload.assignTo || '').trim();

    if (!assignTo) {
        const error = new Error('assignTo is required');
        error.statusCode = 400;
        throw error;
    }

    const ticketCategoryId = Number(payload.ticketCategoryId || 0);

    if (!Number.isInteger(ticketCategoryId) || ticketCategoryId < 1) {
        const error = new Error('ticketCategoryId is required');
        error.statusCode = 400;
        throw error;
    }

    const description = String(payload.description || '').trim();
    const targetCompletionDate = normalizeDateTime(payload.targetCompletionDate || new Date());
    const actualCompletionDate = payload.actualCompletionDate
        ? normalizeDateTime(payload.actualCompletionDate)
        : targetCompletionDate;

    const id = `DRFT-${randomUUID().split('-')[0].toUpperCase()}`;

    await pool.execute(
        `
        INSERT INTO project_ticket_draft (
            id, ticketTypeId, issueNo, title, description, projectId,
            submitBy, submitDate, targetCompletionDate, assignTo,
            actualCompletionDate, ticketStatusId, ticketCategoryId,
            presence, inputDate, inputBy, updateDate, updateBy,
            productChildId
        )
        VALUES (?, ?, '', ?, ?, ?, ?, NOW(), ?, ?, ?, 0, ?, 1, NOW(), ?, NOW(), ?, ?)
        `,
        [
            id,
            1,
            title,
            description,
            String(projectId),
            String(actorId || ''),
            targetCompletionDate,
            assignTo,
            actualCompletionDate,
            ticketCategoryId,
            String(actorId || ''),
            String(actorId || ''),
            String(payload.productChildId || ''),
        ]
    );

    return { id };
}

async function updateProjectDraftTask(id, payload, actorId) {
    const fields = [];
    const params = [];

    if (payload.title !== undefined) {
        const title = String(payload.title).trim();

        if (!title) {
            const error = new Error('title cannot be empty');
            error.statusCode = 400;
            throw error;
        }

        fields.push('title = ?');
        params.push(title);
    }

    if (payload.assignTo !== undefined) {
        const assignTo = String(payload.assignTo).trim();

        if (!assignTo) {
            const error = new Error('assignTo is required');
            error.statusCode = 400;
            throw error;
        }

        fields.push('assignTo = ?');
        params.push(assignTo);
    }

    if (payload.productChildId !== undefined) {
        fields.push('productChildId = ?');
        params.push(String(payload.productChildId));
    }

    if (payload.description !== undefined) {
        fields.push('description = ?');
        params.push(String(payload.description));
    }

    if (payload.ticketCategoryId !== undefined) {
        const ticketCategoryId = Number(payload.ticketCategoryId || 0);

        if (!Number.isInteger(ticketCategoryId) || ticketCategoryId < 1) {
            const error = new Error('ticketCategoryId is required');
            error.statusCode = 400;
            throw error;
        }

        fields.push('ticketCategoryId = ?');
        params.push(ticketCategoryId);
    }

    if (payload.targetCompletionDate) {
        const targetCompletionDate = normalizeDateTime(payload.targetCompletionDate);

        if (targetCompletionDate) {
            fields.push('targetCompletionDate = ?');
            params.push(targetCompletionDate);
        }
    }

    if (!fields.length) {
        const error = new Error('No valid fields provided');
        error.statusCode = 400;
        throw error;
    }

    const [rows] = await pool.execute(
        'SELECT id FROM project_ticket_draft WHERE id = ? AND presence = 1 LIMIT 1',
        [String(id)]
    );

    if (!rows.length) {
        const error = new Error('Draft task not found');
        error.statusCode = 404;
        throw error;
    }

    await pool.execute(
        `UPDATE project_ticket_draft SET ${fields.join(', ')}, updateDate = NOW(), updateBy = ? WHERE id = ? AND presence = 1`,
        [...params, String(actorId || ''), String(id)]
    );

    return { id: String(id) };
}

async function deleteProjectDraftTask(id, actorId) {
    const [rows] = await pool.execute(
        'SELECT id FROM project_ticket_draft WHERE id = ? AND presence = 1 LIMIT 1',
        [String(id)]
    );

    if (!rows.length) {
        const error = new Error('Draft task not found');
        error.statusCode = 404;
        throw error;
    }

    await pool.execute(
        `UPDATE project_ticket_draft SET presence = 0, updateDate = NOW(), updateBy = ? WHERE id = ? AND presence = 1`,
        [String(actorId || ''), String(id)]
    );

    return { id: String(id) };
}

async function reorderProjectDraftTasks(items, actorId) {
    if (!Array.isArray(items) || items.length === 0) {
        const error = new Error('items is required');
        error.statusCode = 400;
        throw error;
    }

    const conn = await pool.getConnection();

    try {
        await conn.beginTransaction();

        for (const entry of items) {
            const id = String(entry.id || '').trim();
            const projectSorting = Number(entry.projectSorting);

            if (!id) {
                const error = new Error('id is required');
                error.statusCode = 400;
                throw error;
            }

            if (!Number.isInteger(projectSorting) || projectSorting < 0) {
                const error = new Error('projectSorting must be a non-negative integer');
                error.statusCode = 400;
                throw error;
            }

            await conn.execute(
                'UPDATE project_ticket_draft SET projectSorting = ?, updateDate = NOW(), updateBy = ? WHERE id = ? AND presence = 1',
                [projectSorting, String(actorId || ''), id]
            );
        }

        await conn.commit();
    } catch (error) {
        await conn.rollback();
        throw error;
    } finally {
        conn.release();
    }

    return { reordered: items.length };
}

async function createProjectTask(projectId, payload, actorId) {
  const [projects] = await pool.execute(
    'SELECT id, productId FROM project WHERE id = ? AND presence = 1 LIMIT 1',
    [String(projectId)]
  );

  const project = projects[0];

  if (!project) {
    const error = new Error('Project not found');
    error.statusCode = 404;
    throw error;
  }

  const title = String(payload.title || '').trim();

  if (!title) {
    const error = new Error('title is required');
    error.statusCode = 400;
    throw error;
  }

  const assignTo = String(payload.assignTo || '').trim();

  if (!assignTo) {
    const error = new Error('assignTo is required');
    error.statusCode = 400;
    throw error;
  }

  const ticketCategoryId = Number(payload.ticketCategoryId || 0);

  if (!Number.isInteger(ticketCategoryId) || ticketCategoryId < 1) {
    const error = new Error('ticketCategoryId is required');
    error.statusCode = 400;
    throw error;
  }

  const description = String(payload.description || '').trim();
  const targetCompletionDate = normalizeDateTime(payload.targetCompletionDate || new Date());
  const actualCompletionDate = payload.actualCompletionDate
    ? normalizeDateTime(payload.actualCompletionDate)
    : targetCompletionDate;

  const ticketId = await runningNumber('task');

  await pool.execute(
    `
    INSERT INTO ticket (
      id, ticketTypeId, issueNo, title, description, projectId,
      submitBy, submitDate, targetCompletionDate, assignTo,
      actualCompletionDate, ticketStatusId, ticketCategoryId,
      presence, inputDate, inputBy, updateDate, updateBy,
      productChildId
    )
    VALUES (?, ?, ?, ?, ?, ?, ?, NOW(), ?, ?, ?, 1, ?, 1, NOW(), ?, NOW(), ?, ?)
    `,
    [
      ticketId,
      1,
      '',
      title,
      description,
      String(projectId),
      String(actorId),
      targetCompletionDate,
      assignTo,
      actualCompletionDate,
      ticketCategoryId,
      String(actorId),
      String(actorId),
      String(payload.productChildId || ''),
    ]
  );

  return { id: ticketId };
}

async function reorderProjectTasks(items, actorId) {
  if (!Array.isArray(items) || items.length === 0) {
    const error = new Error('items is required');
    error.statusCode = 400;
    throw error;
  }

  const conn = await pool.getConnection();

  try {
    await conn.beginTransaction();

    for (const entry of items) {
      const id = String(entry.id || '').trim();
      const projectSorting = Number(entry.projectSorting);

      if (!id) {
        const error = new Error('id is required');
        error.statusCode = 400;
        throw error;
      }

      if (!Number.isInteger(projectSorting) || projectSorting < 0) {
        const error = new Error('projectSorting must be a non-negative integer');
        error.statusCode = 400;
        throw error;
      }

      await conn.execute(
        'UPDATE ticket SET projectSorting = ?, updateDate = NOW(), updateBy = ? WHERE id = ? AND presence = 1',
        [projectSorting, String(actorId), id]
      );
    }

    await conn.commit();
  } catch (error) {
    await conn.rollback();
    throw error;
  } finally {
    conn.release();
  }

  return { reordered: items.length };
}

async function listProjectTemplates(filters = {}) {
    const conditions = ['t.presence = 1'];
    const params = [];

    if (filters.keyword) {
        conditions.push('(t.name LIKE ? OR t.description LIKE ? OR t.version LIKE ? OR tp.id LIKE ?)');
        params.push(`%${filters.keyword}%`, `%${filters.keyword}%`, `%${filters.keyword}%`, `%${filters.keyword}%`);
    }

    const whereClause = `WHERE ${conditions.join(' AND ')}`;

    const q = `
      SELECT
        t.id,
        t.name,
        t.description,
        t.version,
        tp.id AS projectId,
        tp.projectTypeId,
        tp.projectBilleableId,
        tp.productId,
        tp.clientId,
        tp.ticketCategoriesParentId,
        tp.ticketBaseHours,
        tp.startDate,
        tp.endDate,
        tp.status,
        t.inputDate,
        c.name AS clientName,
        pt.name AS projectTypeName,
        pb.name AS projectBilleableName,
        pr.name AS productName
      FROM template t
      JOIN template_project tp ON tp.templateId = t.id AND tp.presence = 1
      LEFT JOIN client c ON c.id = tp.clientId
      LEFT JOIN project_type pt ON pt.id = tp.projectTypeId
      LEFT JOIN project_billeable pb ON pb.id = tp.projectBilleableId
      LEFT JOIN product pr ON pr.id = tp.productId
      ${whereClause}
      ORDER BY t.inputDate DESC, t.id DESC
    `;

    const [rows] = await pool.execute(q, params);

    return rows;
}

const CLONE_TABLES = new Set([
    'project_users',
    'template_project_users',
    'project_contact',
    'template_project_contact',
    'project_ticket_draft',
    'template_project_ticket_draft',
]);

function cloneTable(name) {
    if (!CLONE_TABLES.has(name)) {
        throw new Error(`Invalid clone table: ${name}`);
    }

    return name;
}

async function cloneTemplateUsers(connection, sourceTable, targetTable, sourceId, targetId, actor) {
    const [users] = await connection.execute(
        `SELECT userId, asManager FROM ${cloneTable(sourceTable)} WHERE projectId = ? AND presence = 1`,
        [String(sourceId)]
    );

    for (const u of users) {
        await connection.execute(
            `INSERT INTO ${cloneTable(targetTable)} (projectId, userId, asManager, presence, inputDate, inputBy, updateDate, updateBy)
             VALUES (?, ?, ?, 1, NOW(), ?, NOW(), ?)`,
            [String(targetId), String(u.userId), u.asManager === 1 ? 1 : 0, String(actor), String(actor)]
        );
    }
}

async function cloneTemplateContacts(connection, sourceTable, targetTable, sourceId, targetId, actor) {
    const [contacts] = await connection.execute(
        `SELECT clientId, userId FROM ${cloneTable(sourceTable)} WHERE projectId = ? AND presence = 1`,
        [String(sourceId)]
    );

    for (const c of contacts) {
        await connection.execute(
            `INSERT INTO ${cloneTable(targetTable)} (clientId, projectId, userId, presence, inputDate, inputBy, updateDate, updateBy)
             VALUES (?, ?, ?, 1, NOW(), ?, NOW(), ?)`,
            [String(c.clientId || ''), String(targetId), String(c.userId), String(actor), String(actor)]
        );
    }
}

async function insertTemplateDraftTask(connection, targetTable, sourceTask, targetProjectId, actor) {
    const newId = `DRFT-${randomUUID().split('-')[0].toUpperCase()}`;

    await connection.execute(
        `
        INSERT INTO ${cloneTable(targetTable)} (
            id, ticketTypeId, issueNo, title, description, projectId,
            submitBy, submitDate, targetCompletionDate, assignTo,
            actualCompletionDate, ticketStatusId, ticketCategoryId,
            presence, inputDate, inputBy, updateDate, updateBy,
            productChildId, sorting, projectSorting
        )
        VALUES (?, ?, ?, ?, ?, ?, ?, NOW(), ?, ?, ?, 0, ?, 1, NOW(), ?, NOW(), ?, ?, ?, ?)
        `,
        [
            newId,
            Number(sourceTask.ticketTypeId || 1),
            String(sourceTask.issueNo || ''),
            String(sourceTask.title || ''),
            String(sourceTask.description || ''),
            String(targetProjectId),
            String(sourceTask.submitBy || actor),
            sourceTask.targetCompletionDate,
            String(sourceTask.assignTo || ''),
            sourceTask.actualCompletionDate,
            Number(sourceTask.ticketCategoryId || 0),
            String(actor),
            String(actor),
            String(sourceTask.productChildId || ''),
            Number(sourceTask.sorting ?? 999),
            Number(sourceTask.projectSorting ?? 999),
        ]
    );
}

async function saveProjectAsTemplate(projectId, payload, actorId = '1') {
    const actor = String(actorId || '');
    const name = String(payload.name || '').trim();
    const description = String(payload.description || '').trim();
    const version = String(payload.version || '').trim();

    if (!name) {
        const error = new Error('name is required');
        error.statusCode = 400;
        throw error;
    }

    const conn = await pool.getConnection();

    try {
        await conn.beginTransaction();

        const [projects] = await conn.execute(
            'SELECT * FROM project WHERE id = ? AND presence IN (1, 4) LIMIT 1',
            [String(projectId)]
        );

        if (!projects.length) {
            const error = new Error('Project not found');
            error.statusCode = 404;
            throw error;
        }

        const source = projects[0];

        // 1) metadata (name/description/version) → table template
        const [templateResult] = await conn.execute(
            `INSERT INTO template (name, clientId, description, version, tempateType, json, presence, status, inputDate, inputBy, updateDate, updateBy)
             VALUES (?, ?, ?, ?, 'project', '', 1, 1, NOW(), ?, NOW(), ?)`,
            [name, String(source.clientId || ''), description, version, actor, actor]
        );

        const templateId = templateResult.insertId;

        // 2) header project → template_project
        const templateProjectId = buildProjectId('');

        await conn.execute(
            `INSERT INTO template_project (
                id, templateId, name, projectTypeId, projectBilleableId, productId,
                ticketCategoriesParentId, ticketBaseHours, clientId,
                startDate, endDate, status, templateMaster,
                presence, inputDate, inputBy, updateDate, updateBy
            )
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 1, ?, 1, NOW(), ?, NOW(), ?)`,
            [
                templateProjectId,
                templateId,
                name,
                Number(source.projectTypeId || 0),
                Number(source.projectBilleableId || 0),
                Number(source.productId || 0),
                Number(source.ticketCategoriesParentId || 0),
                Number(source.ticketBaseHours || 0),
                String(source.clientId || '0'),
                source.startDate,
                source.endDate,
                String(source.templateMaster || '0'),
                actor,
                actor,
            ]
        );

        // 3) team & contact → template_project_users / template_project_contact
        await cloneTemplateUsers(conn, 'project_users', 'template_project_users', projectId, templateProjectId, actor);
        await cloneTemplateContacts(conn, 'project_contact', 'template_project_contact', projectId, templateProjectId, actor);

        // 4) blueprint draft task (project_ticket_draft) → template_project_ticket_draft
        const [drafts] = await conn.execute(
            'SELECT * FROM project_ticket_draft WHERE projectId = ? AND presence = 1 ORDER BY projectSorting ASC, inputDate ASC',
            [String(projectId)]
        );

        for (const d of drafts) {
            await insertTemplateDraftTask(conn, 'template_project_ticket_draft', d, templateProjectId, actor);
        }

        // 5) fallback: project published → task blueprint dari ticket (ticketTypeId = 1)
        const [tickets] = await conn.execute(
            'SELECT * FROM ticket WHERE projectId = ? AND presence = 1 AND ticketTypeId = 1 ORDER BY projectSorting ASC, inputDate ASC',
            [String(projectId)]
        );

        for (const t of tickets) {
            await insertTemplateDraftTask(conn, 'template_project_ticket_draft', t, templateProjectId, actor);
        }

        await conn.commit();

        return { id: templateId, projectId: templateProjectId };
    } catch (error) {
        await conn.rollback();
        throw error;
    } finally {
        conn.release();
    }
}

async function instantiateTemplate(templateId, payload, actorId = '1') {
    const actor = String(actorId || '');
    const safeTemplateId = Number(templateId);

    if (!Number.isInteger(safeTemplateId) || safeTemplateId < 1) {
        const error = new Error('Invalid template id');
        error.statusCode = 400;
        throw error;
    }

    const conn = await pool.getConnection();

    try {
        await conn.beginTransaction();

        const [templates] = await conn.execute(
            'SELECT * FROM template WHERE id = ? AND presence = 1 LIMIT 1',
            [safeTemplateId]
        );

        if (!templates.length) {
            const error = new Error('Template not found');
            error.statusCode = 404;
            throw error;
        }

        const metadata = templates[0];

        const [projectRows] = await conn.execute(
            'SELECT * FROM template_project WHERE templateId = ? AND presence = 1 ORDER BY inputDate ASC LIMIT 1',
            [safeTemplateId]
        );

        if (!projectRows.length) {
            const error = new Error('Template project not found');
            error.statusCode = 404;
            throw error;
        }

        const source = projectRows[0];
        const draftId = buildProjectId('');
        const name = String(payload.name || '').trim() || String(source.name || metadata.name || '');

        await conn.execute(
            `INSERT INTO project (
                id, name, projectTypeId, projectBilleableId, productId,
                ticketCategoriesParentId, ticketBaseHours, clientId,
                startDate, endDate, status, templateMaster,
                presence, inputDate, inputBy, updateDate, updateBy
            )
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 1, ?, 4, NOW(), ?, NOW(), ?)`,
            [
                draftId,
                name,
                Number(source.projectTypeId || 0),
                Number(source.projectBilleableId || 0),
                Number(source.productId || 0),
                Number(source.ticketCategoriesParentId || 0),
                Number(source.ticketBaseHours || 0),
                String(source.clientId || '0'),
                source.startDate,
                source.endDate,
                String(source.templateMaster || '0'),
                actor,
                actor,
            ]
        );

        await cloneTemplateUsers(conn, 'template_project_users', 'project_users', source.id, draftId, actor);
        await cloneTemplateContacts(conn, 'template_project_contact', 'project_contact', source.id, draftId, actor);

        const [drafts] = await conn.execute(
            'SELECT * FROM template_project_ticket_draft WHERE projectId = ? AND presence = 1 ORDER BY projectSorting ASC, inputDate ASC',
            [String(source.id)]
        );

        for (const d of drafts) {
            await insertTemplateDraftTask(conn, 'project_ticket_draft', d, draftId, actor);
        }

        await conn.commit();

        return { id: draftId };
    } catch (error) {
        await conn.rollback();
        throw error;
    } finally {
        conn.release();
    }
}

async function applyTemplateToProject(projectId, templateId, actorId = '1') {
    const actor = String(actorId || '');
    const safeTemplateId = Number(templateId);

    if (!Number.isInteger(safeTemplateId) || safeTemplateId < 1) {
        const error = new Error('Invalid template id');
        error.statusCode = 400;
        throw error;
    }

    const conn = await pool.getConnection();

    try {
        await conn.beginTransaction();

        const [projects] = await conn.execute(
            'SELECT id FROM project WHERE id = ? AND presence IN (1, 4) LIMIT 1',
            [String(projectId)]
        );

        if (!projects.length) {
            const error = new Error('Project not found');
            error.statusCode = 404;
            throw error;
        }

        const [templates] = await conn.execute(
            'SELECT * FROM template WHERE id = ? AND presence = 1 LIMIT 1',
            [safeTemplateId]
        );

        if (!templates.length) {
            const error = new Error('Template not found');
            error.statusCode = 404;
            throw error;
        }

        const [projectRows] = await conn.execute(
            'SELECT * FROM template_project WHERE templateId = ? AND presence = 1 ORDER BY inputDate ASC LIMIT 1',
            [safeTemplateId]
        );

        if (!projectRows.length) {
            const error = new Error('Template project not found');
            error.statusCode = 404;
            throw error;
        }

        const source = projectRows[0];

        // 1) header project
        await conn.execute(
            `UPDATE project
             SET name = ?, projectTypeId = ?, projectBilleableId = ?, productId = ?,
                 ticketCategoriesParentId = ?, ticketBaseHours = ?, clientId = ?,
                 startDate = ?, endDate = ?, templateMaster = ?,
                 updateDate = NOW(), updateBy = ?
             WHERE id = ? AND presence IN (1, 4)`,
            [
                String(source.name || ''),
                Number(source.projectTypeId || 0),
                Number(source.projectBilleableId || 0),
                Number(source.productId || 0),
                Number(source.ticketCategoriesParentId || 0),
                Number(source.ticketBaseHours || 0),
                String(source.clientId || '0'),
                source.startDate,
                source.endDate,
                String(safeTemplateId),
                actor,
                String(projectId),
            ]
        );

        // 2) replace team
        await conn.execute(
            'UPDATE project_users SET presence = 0, updateDate = NOW(), updateBy = ? WHERE projectId = ? AND presence = 1',
            [actor, String(projectId)]
        );
        await cloneTemplateUsers(conn, 'template_project_users', 'project_users', source.id, projectId, actor);

        // 3) replace contacts
        await conn.execute(
            'UPDATE project_contact SET presence = 0, updateDate = NOW(), updateBy = ? WHERE projectId = ? AND presence = 1',
            [actor, String(projectId)]
        );
        await cloneTemplateContacts(conn, 'template_project_contact', 'project_contact', source.id, projectId, actor);

        // 4) replace draft task blueprint
        await conn.execute(
            'UPDATE project_ticket_draft SET presence = 0, updateDate = NOW(), updateBy = ? WHERE projectId = ? AND presence = 1',
            [actor, String(projectId)]
        );

        const [drafts] = await conn.execute(
            'SELECT * FROM template_project_ticket_draft WHERE projectId = ? AND presence = 1 ORDER BY projectSorting ASC, inputDate ASC',
            [String(source.id)]
        );

        for (const d of drafts) {
            await insertTemplateDraftTask(conn, 'project_ticket_draft', d, String(projectId), actor);
        }

        await conn.commit();
    } catch (error) {
        await conn.rollback();
        throw error;
    } finally {
        conn.release();
    }

    return getProjectDetail(String(projectId));
}

async function deleteTemplate(templateId, actorId = '1') {
    const actor = String(actorId || '');
    const safeTemplateId = Number(templateId);

    if (!Number.isInteger(safeTemplateId) || safeTemplateId < 1) {
        const error = new Error('Invalid template id');
        error.statusCode = 400;
        throw error;
    }

    const conn = await pool.getConnection();

    try {
        await conn.beginTransaction();

        const [templates] = await conn.execute(
            'SELECT id FROM template WHERE id = ? AND presence = 1 LIMIT 1',
            [safeTemplateId]
        );

        if (!templates.length) {
            const error = new Error('Template not found');
            error.statusCode = 404;
            throw error;
        }

        await conn.execute(
            'UPDATE template SET presence = 0, updateDate = NOW(), updateBy = ? WHERE id = ? AND presence = 1',
            [actor, safeTemplateId]
        );

        const [projects] = await conn.execute(
            'SELECT id FROM template_project WHERE templateId = ? AND presence = 1',
            [safeTemplateId]
        );

        for (const project of projects) {
            const pid = String(project.id);

            await conn.execute(
                'UPDATE template_project SET presence = 0, updateDate = NOW(), updateBy = ? WHERE id = ? AND presence = 1',
                [actor, pid]
            );
            await conn.execute(
                'UPDATE template_project_users SET presence = 0, updateDate = NOW(), updateBy = ? WHERE projectId = ? AND presence = 1',
                [actor, pid]
            );
            await conn.execute(
                'UPDATE template_project_ticket_draft SET presence = 0, updateDate = NOW(), updateBy = ? WHERE projectId = ? AND presence = 1',
                [actor, pid]
            );
            await conn.execute(
                'UPDATE template_project_contact SET presence = 0, updateDate = NOW(), updateBy = ? WHERE projectId = ? AND presence = 1',
                [actor, pid]
            );
        }

        await conn.commit();
    } catch (error) {
        await conn.rollback();
        throw error;
    } finally {
        conn.release();
    }

    return { id: safeTemplateId };
}

module.exports = {
    listProjects,
    listProjectDrafts,
    getProjectDetail,
    createProject,
    createProjectDraft,
    updateProject,
    deleteProject,
    addContactToProject,
    removeContactFromProject,
    ticketList,
    draftTaskList,
    createProjectDraftTask,
    updateProjectDraftTask,
    deleteProjectDraftTask,
    reorderProjectDraftTasks,
    createProjectTask,
    reorderProjectTasks,
    listProjectTemplates,
    saveProjectAsTemplate,
    applyTemplateToProject,
    instantiateTemplate,
    deleteTemplate
};
