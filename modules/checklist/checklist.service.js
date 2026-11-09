const { pool } = require('../../config/db');

let checklistTableReady = false;

async function ensureChecklistTable() {
  if (checklistTableReady) {
    return;
  }

  await pool.execute(`
    CREATE TABLE IF NOT EXISTS ticket_checklist (
      id INT(11) NOT NULL AUTO_INCREMENT,
      ticketId VARCHAR(50) NOT NULL DEFAULT '',
      ticketChecklistId INT(11) NOT NULL DEFAULT 0,
      status TINYINT(4) NOT NULL DEFAULT 0,
      description TEXT NOT NULL,
      sorting MEDIUMINT(9) NOT NULL DEFAULT 999,
      presence TINYINT(2) NOT NULL DEFAULT 1,
      inputDate DATETIME NOT NULL DEFAULT '2025-01-01 00:00:00',
      inputBy VARCHAR(50) NOT NULL DEFAULT '',
      updateDate DATETIME NOT NULL DEFAULT '2025-01-01 00:00:00',
      updateBy VARCHAR(50) NOT NULL DEFAULT '',
      PRIMARY KEY (id) USING BTREE,
      KEY ticketId (ticketId)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC
  `);

  checklistTableReady = true;
}

function parseItemId(id) {
  const parsed = Number(id);

  if (!Number.isInteger(parsed) || parsed < 1) {
    const error = new Error('Invalid checklist item id');
    error.statusCode = 400;
    throw error;
  }

  return parsed;
}

async function assertTicketExists(ticketId) {
  const [rows] = await pool.execute(
    'SELECT id FROM ticket WHERE id = ? AND presence = 1 LIMIT 1',
    [ticketId]
  );

  if (!rows[0]) {
    const error = new Error('Ticket not found');
    error.statusCode = 404;
    throw error;
  }
}

async function getChecklistItem(id) {
  const [rows] = await pool.execute(
    'SELECT * FROM ticket_checklist WHERE id = ? AND presence = 1 LIMIT 1',
    [id]
  );

  return rows[0] || null;
}

async function listChecklist(ticketId) {
  await ensureChecklistTable();

  const [rows] = await pool.execute(
    `
    SELECT *
    FROM ticket_checklist
    WHERE ticketId = ? AND presence = 1
    ORDER BY ticketChecklistId ASC, sorting ASC, id ASC
    `,
    [ticketId]
  );

  return rows;
}

async function createChecklistItem(payload, actorId) {
  await ensureChecklistTable();

  const ticketId = String(payload.ticketId || '').trim();
  const description = String(payload.description || '').trim();
  const ticketChecklistId = Number(payload.ticketChecklistId || 0);

  if (!ticketId) {
    const error = new Error('ticketId is required');
    error.statusCode = 400;
    throw error;
  }

  if (!description) {
    const error = new Error('description is required');
    error.statusCode = 400;
    throw error;
  }

  if (!Number.isInteger(ticketChecklistId) || ticketChecklistId < 0) {
    const error = new Error('ticketChecklistId must be a non-negative integer');
    error.statusCode = 400;
    throw error;
  }

  await assertTicketExists(ticketId);

  if (ticketChecklistId > 0) {
    const parent = await getChecklistItem(ticketChecklistId);

    if (!parent || String(parent.ticketId) !== ticketId || Number(parent.ticketChecklistId) !== 0) {
      const error = new Error('ticketChecklistId is invalid');
      error.statusCode = 400;
      throw error;
    }
  }

  const [sortRows] = await pool.execute(
    `
    SELECT COALESCE(MAX(sorting), 0) + 1 AS nextSorting
    FROM ticket_checklist
    WHERE ticketId = ? AND ticketChecklistId = ? AND presence = 1
    `,
    [ticketId, ticketChecklistId]
  );

  const sorting = Number(sortRows[0]?.nextSorting ?? 1);

  const [result] = await pool.execute(
    `
    INSERT INTO ticket_checklist (
      ticketId, ticketChecklistId, description, status, sorting,
      presence, inputDate, inputBy, updateDate, updateBy
    )
    VALUES (?, ?, ?, 0, ?, 1, NOW(), ?, NOW(), ?)
    `,
    [ticketId, ticketChecklistId, description, sorting, actorId, actorId]
  );

  return getChecklistItem(result.insertId);
}

async function updateChecklistItem(id, payload, actorId) {
  await ensureChecklistTable();

  const item = await getChecklistItem(parseItemId(id));

  if (!item) {
    const error = new Error('Checklist item not found');
    error.statusCode = 404;
    throw error;
  }

  const fields = [];
  const params = [];

  if (payload.description !== undefined) {
    const description = String(payload.description || '').trim();

    if (!description) {
      const error = new Error('description cannot be empty');
      error.statusCode = 400;
      throw error;
    }

    fields.push('description = ?');
    params.push(description);
  }

  if (payload.status !== undefined) {
    fields.push('status = ?');
    params.push(Number(payload.status) ? 1 : 0);
  }

  if (payload.sorting !== undefined) {
    const sorting = Number(payload.sorting);

    if (!Number.isInteger(sorting) || sorting < 0) {
      const error = new Error('sorting must be a non-negative integer');
      error.statusCode = 400;
      throw error;
    }

    fields.push('sorting = ?');
    params.push(sorting);
  }

  if (!fields.length) {
    return item;
  }

  fields.push('updateDate = NOW()');
  fields.push('updateBy = ?');
  params.push(actorId);

  await pool.execute(
    `UPDATE ticket_checklist SET ${fields.join(', ')} WHERE id = ? AND presence = 1`,
    [...params, parseItemId(id)]
  );

  return getChecklistItem(parseItemId(id));
}

async function deleteChecklistItem(id, actorId) {
  await ensureChecklistTable();

  const item = await getChecklistItem(parseItemId(id));

  if (!item) {
    const error = new Error('Checklist item not found');
    error.statusCode = 404;
    throw error;
  }

  await pool.execute(
    `
    UPDATE ticket_checklist
    SET presence = 0, updateDate = NOW(), updateBy = ?
    WHERE (id = ? OR ticketChecklistId = ?) AND ticketId = ? AND presence = 1
    `,
    [actorId, parseItemId(id), parseItemId(id), item.ticketId]
  );

  return { id: parseItemId(id) };
}

async function reorderChecklist(items, actorId) {
  await ensureChecklistTable();

  if (!Array.isArray(items) || items.length === 0) {
    const error = new Error('items is required');
    error.statusCode = 400;
    throw error;
  }

  const conn = await pool.getConnection();

  try {
    await conn.beginTransaction();

    for (const entry of items) {
      const id = parseItemId(entry.id);
      const sorting = Number(entry.sorting);

      if (!Number.isInteger(sorting) || sorting < 0) {
        const error = new Error('sorting must be a non-negative integer');
        error.statusCode = 400;
        throw error;
      }

      await conn.execute(
        'UPDATE ticket_checklist SET sorting = ?, updateDate = NOW(), updateBy = ? WHERE id = ? AND presence = 1',
        [sorting, actorId, id]
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

module.exports = {
  listChecklist,
  createChecklistItem,
  updateChecklistItem,
  deleteChecklistItem,
  reorderChecklist,
};