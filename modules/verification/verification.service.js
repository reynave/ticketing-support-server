const { pool } = require('../../config/db');

// Status "Verified" = antrean yang menunggu konfirmasi client.
const VERIFICATION_STATUS_ID = 400;
const CASE_TYPE_ID = 2;
const TASK_TYPE_ID = 1;

function optionalText(value) {
  if (value === undefined || value === null) {
    return '';
  }

  return String(value).trim();
}

/**
 * Daftar case yang menunggu verifikasi client.
 * Sumber data: tabel `ticket` dengan ticketStatusId = 400 dan ticketTypeId = 2.
 *
 * Filter yang didukung:
 * - keyword   : id / title / issueNo / crNoRef (LIKE)
 * - clientId  : id client (milik project)
 * - startDate : submitDate >= startDate
 * - endDate   : submitDate <= endDate 23:59:59
 */
async function listVerification(filters = {}) {
  const conditions = [
    't.presence = 1',
    't.ticketTypeId = ?',
    't.ticketStatusId = ?',
  ];
  const params = [CASE_TYPE_ID, VERIFICATION_STATUS_ID];

  const clientId = optionalText(filters.clientId);
  if (clientId) {
    conditions.push('c.id = ?');
    params.push(clientId);
  }

  const keyword = optionalText(filters.keyword);
  if (keyword) {
    const likeKeyword = `%${keyword}%`;
    conditions.push('(t.id LIKE ? OR t.title LIKE ? OR t.issueNo LIKE ? OR t.crNoRef LIKE ?)');
    params.push(likeKeyword, likeKeyword, likeKeyword, likeKeyword);
  }

  const startDate = optionalText(filters.startDate);
  if (startDate) {
    conditions.push('t.submitDate >= ?');
    params.push(startDate);
  }

  const endDate = optionalText(filters.endDate);
  if (endDate) {
    conditions.push('t.submitDate <= ?');
    params.push(`${endDate} 23:59:59`);
  }

  const whereClause = conditions.join(' AND ');

  const q = `
    SELECT t.id, t.title, t.projectId, t.ticketStatusId, t.ticketTypeId, t.ticketCategoryId,
      t.submitDate, t.targetCompletionDate, t.actualCompletionDate,
      t.verificationDateTime, t.actualWorkingDateTime,
      t.actualWorkingHour, t.hours, t.ticketEstimationCost,
      tt.name AS ticketTypeName,
      ts.name AS ticketStatusName,
      sv.name AS ticketSeverityName,
      sv.color AS severityColor,
      p.name AS projectName,
      c.name AS clientName,
      tc.name AS ticketCategoryName,
      tc2.name AS parentCategoryName,
      t.assignTo,
      CONCAT(u.firstName, ' ', u.lastName) AS assignToName,
      t.submitBy,
      CONCAT(us.firstName, ' ', us.lastName) AS submitByName,
      DATEDIFF(NOW(), t.verificationDateTime) as  gracePeriod,
      false as checkbox
     
    FROM ticket t
    LEFT JOIN ticket_type tt ON tt.id = t.ticketTypeId
    LEFT JOIN ticket_status ts ON ts.id = t.ticketStatusId
    LEFT JOIN ticket_severity sv ON sv.id = t.ticketSeverityId
    LEFT JOIN project p ON p.id = t.projectId
    LEFT JOIN client c ON c.id = p.clientId
    LEFT JOIN ticket_categories tc ON tc.id = t.ticketCategoryId
    LEFT JOIN ticket_categories tc2 ON tc2.id = p.ticketCategoriesParentId
    LEFT JOIN user u ON u.id = t.assignTo
    LEFT JOIN user us ON us.id = t.submitBy
    WHERE ${whereClause}
    ORDER BY t.submitDate DESC, t.id DESC
  `;

  const [rows] = await pool.execute(q, params);

  return rows;
}
/**
 * Detail satu case untuk modal verifikasi.
 * Mengembalikan shape yang sama dengan endpoint detail pada modul admin-report
 * supaya frontend bisa memakai UI modal yang konsisten.
 */
async function getVerificationDetail(id) {
  const [rows] = await pool.execute(
    `
      SELECT t.*,
        tt.name AS ticketTypeName,
        ts.name AS ticketStatusName,
        d.name AS productName,
        p.name AS projectName,
        pt.name AS projectType,
        pt.ticketBased,
        c.name AS clientName,
        CONCAT(us.firstName, ' ', us.lastName) AS submitByName,
        CONCAT(ua.firstName, ' ', ua.lastName) AS assignToName,
        tc.name AS ticketCategory,
        tc2.name AS parentCategoryName,
        p2.name AS productChildName,
        sv.name AS ticketSeverityName,
        sv.color AS severityColor, 
        (
          SELECT COUNT(1)
          FROM ticket tk
          WHERE tk.presence = 1
            AND tk.ticketTypeId = ?
            AND tk.issueNo = t.id
        ) AS taskCount
      FROM ticket t
      LEFT JOIN ticket_type tt ON tt.id = t.ticketTypeId
      LEFT JOIN ticket_status ts ON ts.id = t.ticketStatusId
      LEFT JOIN ticket_severity sv ON sv.id = t.ticketSeverityId
      LEFT JOIN project p ON p.id = t.projectId
      LEFT JOIN project_type pt ON pt.id = p.projectTypeId
      LEFT JOIN product d ON d.id = p.productId
      LEFT JOIN client c ON c.id = p.clientId
      LEFT JOIN user us ON us.id = t.submitBy
      LEFT JOIN user ua ON ua.id = t.assignTo
      LEFT JOIN ticket_categories tc ON tc.id = t.ticketCategoryId
      LEFT JOIN ticket_categories tc2 ON tc2.id = p.ticketCategoriesParentId
      LEFT JOIN product p2 ON p2.id = t.productChildId
      WHERE t.id = ?
        AND t.presence = 1
        AND t.ticketTypeId = ?
      LIMIT 1
    `,
    [TASK_TYPE_ID, id, CASE_TYPE_ID]
  );

  const detail = rows[0];

  if (!detail) {
    const error = new Error('Verification data not found');
    error.statusCode = 404;
    throw error;
  }

  const [ratingRows] = await pool.execute(
    `
      SELECT tr.id, tr.value, tr.ratingId, r.name AS ratingName
      FROM ticket_rating tr
      LEFT JOIN rating r ON r.id = tr.ratingId
      WHERE tr.ticketId = ?
      ORDER BY tr.id ASC
    `,
    [id]
  );

  const [activityRows] = await pool.execute(
    `
      SELECT *
      FROM ticket_logs
      WHERE ticketId = ? AND presence = 1
      ORDER BY inputDate DESC
    `,
    [id]
  );

  const [attachmentRows] = await pool.execute(
    `
      SELECT *
      FROM ticket_logs_attachments
      WHERE ticketId = ?
      ORDER BY inputDate DESC
    `,
    [id]
  );

  // Kelompokkan lampiran per log (ticketLogId), bukan per ticket.
  const attachmentsByLogId = {};
  attachmentRows.forEach((attachment) => {
    const key = String(attachment.ticketLogId);
    if (!attachmentsByLogId[key]) {
      attachmentsByLogId[key] = [];
    }
    attachmentsByLogId[key].push(attachment);
  });

  const activities = activityRows.map((activity) => ({
    ...activity,
    attachment: attachmentsByLogId[String(activity.id)] || [],
  }));

  const [taskRows] = await pool.execute(
    `
      SELECT t.id, t.title, t.ticketStatusId, t.hours,
        ts.name AS ticketStatusName,
        CONCAT(u.firstName, ' ', u.lastName) AS assignToName
      FROM ticket t
      LEFT JOIN ticket_status ts ON ts.id = t.ticketStatusId
      LEFT JOIN user u ON u.id = t.assignTo
      WHERE t.presence = 1
        AND t.ticketTypeId = ?
        AND t.issueNo = ?
      ORDER BY t.id DESC
    `,
    [TASK_TYPE_ID, id]
  );

  return {
    detail,
    rating: ratingRows,
    activities,
    tasks: taskRows,
  };
}

const CLOSED_STATUS_ID = 900;
const CANCELLED_STATUS_ID = 990;
const MAX_BULK_IDS = 200;

/** Status yang boleh dipilih untuk aksi verifikasi (close / cancel). */
const ALLOWED_TARGET_STATUS_IDS = [CLOSED_STATUS_ID, CANCELLED_STATUS_ID];

function parseTargetStatusId(action) {
  // Menerima dua bentuk input: string action ('close'/'cancel')
  // atau langsung id status (900 / 990).
  if (action === CLOSED_STATUS_ID || action === CANCELLED_STATUS_ID) {
    return action;
  }

  const normalized = String(action === undefined || action === null ? '' : action)
    .trim()
    .toLowerCase();

  if (normalized === String(CLOSED_STATUS_ID) || normalized === 'closed' || normalized === 'close') {
    return CLOSED_STATUS_ID;
  }

  if (normalized === String(CANCELLED_STATUS_ID) || normalized === 'cancelled' || normalized === 'cancel') {
    return CANCELLED_STATUS_ID;
  }

  const error = new Error("action must be 'close' (900) or 'cancel' (990)");
  error.statusCode = 400;
  throw error;
}

function normalizeIdList(ids) {
  if (!Array.isArray(ids)) {
    const error = new Error('ids must be an array of ticket ids');
    error.statusCode = 400;
    throw error;
  }

  const cleaned = ids
    .map((id) => optionalText(id))
    .filter((id) => id !== '');

  const unique = Array.from(new Set(cleaned));

  if (!unique.length) {
    const error = new Error('ids must contain at least one ticket id');
    error.statusCode = 400;
    throw error;
  }

  if (unique.length > MAX_BULK_IDS) {
    const error = new Error(`ids must not exceed ${MAX_BULK_IDS} items`);
    error.statusCode = 400;
    throw error;
  }

  return unique;
}

/**
 * Terapkan perubahan status ke satu case yang sudah terkunci (`FOR UPDATE`).
 * Dipakai oleh update satuan maupun bulk agar perilakunya identik.
 */
async function applyStatusToLockedTicket(conn, ticket, targetStatusId, actor) {
  // 1. Update status. `actualCompletionDate` hanya diisi saat Close.
  await conn.execute(
    `
      UPDATE ticket
      SET ticketStatusId = ?,
          actualCompletionDate = IF(? = ?, NOW(), actualCompletionDate),
          updateDate = NOW(),
          updateBy = ?
      WHERE id = ?
        AND presence = 1
        AND ticketTypeId = ?
    `,
    [targetStatusId, targetStatusId, CLOSED_STATUS_ID, actor, ticket.id, CASE_TYPE_ID]
  );

  // 2. Catat ke ticket_logs. `inputBySystem = 1` menandai log dari aksi sistem.
  const verb = targetStatusId === CLOSED_STATUS_ID ? 'Closed' : 'Cancelled';
  const description =
    'Verification: case <strong>' + ticket.id + '</strong> ' + verb +
    ' by <strong>' + actor + '</strong> (from <strong>' +
    (ticket.currentStatusName || VERIFICATION_STATUS_ID) + '</strong>)';

  await conn.execute(
    `
      INSERT INTO ticket_logs (
        ticketId, description, starDateTime, closeDateTime,
        presence, inputBySystem, inputDate, inputBy, updateDate, updateBy
      )
      VALUES (?, ?, IFNULL(?, NOW()), IFNULL(?, NOW()), 1, 1, NOW(), ?, NOW(), ?)
    `,
    [ticket.id, description, null, null, actor, actor]
  );

  // 3. Potong saldo ticket hanya saat Close (mengikuti alur updateCaseStatusByClient).
  //    ⚠️ Tabel `ticket_status_logs` hanya ada di dokumen, belum dibuat di database.
  if (targetStatusId === CLOSED_STATUS_ID) {
    await conn.execute(
      `
        INSERT INTO ticket_balance (
          projectId, ticketId, ticketOut, date, inputDate, inputBy
        )
        VALUES (?, ?, ?, NOW(), NOW(), ?)
      `,
      [ticket.projectId, ticket.id, ticket.ticketEstimationCost || 0, actor]
    );
  }
}

/**
 * Tutup atau batalkan satu case dari halaman Verification.
 *
 * - `action = 'close'`   -> ticketStatusId = 900 (Closed)
 * - `action = 'cancel'`  -> ticketStatusId = 990 (Cancelled)
 *
 * Hanya case (`ticketTypeId = 2`) yang masih berstatus 400 (Verified) yang boleh
 * diproses, supaya tidak menimpa case yang sudah closed/cancelled atau belum
 * masuk antrean verifikasi.
 */
async function updateVerificationStatus(id, action, actorId = '1') {
  const targetStatusId = parseTargetStatusId(action);
  const actor = String(actorId || '').trim() || '1';

  const conn = await pool.getConnection();

  try {
    await conn.beginTransaction();

    // Pastikan record ini memang case yang masih menunggu verifikasi.
    const [rows] = await conn.execute(
      `
        SELECT t.id, t.ticketStatusId, t.projectId, t.ticketEstimationCost,
          ts.name AS currentStatusName,
          ts2.name AS targetStatusName
        FROM ticket t
        LEFT JOIN ticket_status ts ON ts.id = t.ticketStatusId
        LEFT JOIN ticket_status ts2 ON ts2.id = ?
        WHERE t.id = ?
          AND t.presence = 1
          AND t.ticketTypeId = ?
          AND t.ticketStatusId = ?
        LIMIT 1
        FOR UPDATE
      `,
      [targetStatusId, id, CASE_TYPE_ID, VERIFICATION_STATUS_ID]
    );

    const ticket = rows[0];

    if (!ticket) {
      const error = new Error(
        'Case is not available for verification action. It may already be processed.'
      );
      error.statusCode = 404;
      throw error;
    }

    await applyStatusToLockedTicket(conn, ticket, targetStatusId, actor);

    await conn.commit();

    return {
      id: ticket.id,
      previousStatusId: VERIFICATION_STATUS_ID,
      previousStatusName: ticket.currentStatusName || null,
      ticketStatusId: targetStatusId,
      ticketStatusName: ticket.targetStatusName || null,
      actualCompletionDate: targetStatusId === CLOSED_STATUS_ID ? new Date() : null,
    };
  } catch (error) {
    await conn.rollback();
    throw error;
  } finally {
    conn.release();
  }
}

/**
 * Update status banyak case sekaligus ("Update All Selected").
 *
 * Semua case diproses dalam SATU transaction: bila ada satu yang gagal,
 * semuanya di-rollback (tidak ada update setengah jalan).
 *
 * Case yang tidak lagi berstatus 400 (mis. sudah diproses user lain)
 * dilewati dan dikembalikan di `skippedIds` — bukan dianggap error.
 */
async function bulkUpdateVerificationStatus(ids, action, actorId = '1') {
  const targetStatusId = parseTargetStatusId(action);
  const uniqueIds = normalizeIdList(ids);
  const actor = String(actorId || '').trim() || '1';

  const conn = await pool.getConnection();

  try {
    await conn.beginTransaction();

    const placeholders = uniqueIds.map(() => '?').join(', ');

    // Kunci semua baris terpilih sekaligus supaya tidak ada race condition.
    const [rows] = await conn.execute(
      `
        SELECT t.id, t.ticketStatusId, t.projectId, t.ticketEstimationCost,
          ts.name AS currentStatusName,
          ts2.name AS targetStatusName
        FROM ticket t
        LEFT JOIN ticket_status ts ON ts.id = t.ticketStatusId
        LEFT JOIN ticket_status ts2 ON ts2.id = ?
        WHERE t.id IN (${placeholders})
          AND t.presence = 1
          AND t.ticketTypeId = ?
          AND t.ticketStatusId = ?
        FOR UPDATE
      `,
      [targetStatusId, ...uniqueIds, CASE_TYPE_ID, VERIFICATION_STATUS_ID]
    );

    const lockedIds = new Set(rows.map((row) => String(row.id)));
    const skippedIds = uniqueIds.filter((id) => !lockedIds.has(id));

    for (const ticket of rows) {
      await applyStatusToLockedTicket(conn, ticket, targetStatusId, actor);
    }

    await conn.commit();

    return {
      ticketStatusId: targetStatusId,
      ticketStatusName: rows[0]?.targetStatusName || null,
      total: uniqueIds.length,
      updated: rows.length,
      updatedIds: rows.map((row) => row.id),
      skippedIds,
    };
  } catch (error) {
    await conn.rollback();
    throw error;
  } finally {
    conn.release();
  }
}

module.exports = {
  VERIFICATION_STATUS_ID,
  CLOSED_STATUS_ID,
  CANCELLED_STATUS_ID,
  ALLOWED_TARGET_STATUS_IDS,
  listVerification,
  getVerificationDetail,
  updateVerificationStatus,
  bulkUpdateVerificationStatus,
};