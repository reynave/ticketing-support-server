const { pool } = require('../../config/db');

const LATE_THRESHOLD = '08:15:00';
const END_HOURS = '17:00:00';

function pad2(n) {
  return String(n).padStart(2, '0');
}

function ymd(d) {
  return `${d.getFullYear()}-${pad2(d.getMonth() + 1)}-${pad2(d.getDate())}`;
}

function fmtDateTime(d) {
  return `${ymd(d)} ${pad2(d.getHours())}:${pad2(d.getMinutes())}:${pad2(d.getSeconds())}`;
}

function timePart(datetime) {
  return datetime && String(datetime).length >= 19 ? String(datetime).slice(11, 19) : '';
}

function toDate(datetime) {
  if (!datetime) return null;
  const d = new Date(String(datetime).replace(' ', 'T'));
  return isNaN(d.getTime()) ? null : d;
}

function diffMinutes(start, end) {
  const a = toDate(start);
  const b = toDate(end);
  if (!a || !b) return 0;
  const m = Math.round((b.getTime() - a.getTime()) / 60000);
  return m > 0 ? m : 0;
}

function fmtDuration(mins) {
  const h = Math.floor(mins / 60);
  const m = mins % 60;
  return `${h}h ${m}m`;
}

function shortLoc(address) {
  if (!address) return 'Unknown';
  if (address.includes(' - ')) return address.split(' - ')[0];
  if (address.includes(',')) return address.split(',')[0];
  return address;
}

function lastWorkingDays(count, from) {
  const days = [];
  const d = new Date(from);
  while (days.length < count) {
    const dow = d.getDay();
    if (dow !== 0 && dow !== 6) {
      days.push(new Date(d));
    }
    d.setDate(d.getDate() - 1);
  }
  return days.reverse();
}

function dayLabel(d) {
  const mon = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  return `${d.getDate()} ${mon[d.getMonth()]}`;
}

function buildTodayRow(emp, rec, nowStr) {
  const checkedIn = !!(rec && Number(rec.checkIn) === 1);
  const checkedOut = !!(rec && Number(rec.checkOut) === 1);
  const inTime = timePart(rec ? rec.checkInDateTime : '');
  const outTime = timePart(rec ? rec.checkOutDateTime : '');
  const isLate = !!inTime && inTime > LATE_THRESHOLD;

  let status;
  if (!checkedIn) {
    status = 'Not checked in';
  } else if (checkedOut) {
    status = outTime && outTime < END_HOURS ? 'Checked out (early)' : 'Checked out';
  } else if (isLate) {
    status = 'Late';
  } else {
    status = 'Working';
  }

  const durationMins = checkedOut
    ? diffMinutes(rec.checkInDateTime, rec.checkOutDateTime)
    : (checkedIn ? diffMinutes(rec.checkInDateTime, nowStr) : 0);

  const name = `${emp.firstName || ''} ${emp.lastName || ''}`.trim();

  return {
    userId: emp.id,
    name,
    location: checkedIn ? shortLoc(rec.checkInAddress) : '',
    checkIn: inTime.slice(0, 5),
    checkOut: outTime.slice(0, 5),
    duration: fmtDuration(durationMins),
    status,
    isLate,
    checkedIn,
    checkedOut,
  };
}

async function listAttendance(filters = {}) {
  const conditions = ['a.presence = 1'];
  const params = [];

  if (filters.userId !== undefined && String(filters.userId).trim() !== '') {
    conditions.push('a.userId = ?');
    params.push(String(filters.userId).trim());
  }

  if (filters.workDateFrom !== undefined && String(filters.workDateFrom).trim() !== '') {
    conditions.push('a.workDate >= ?');
    params.push(String(filters.workDateFrom).trim());
  }

  if (filters.workDateTo !== undefined && String(filters.workDateTo).trim() !== '') {
    conditions.push('a.workDate <= ?');
    params.push(String(filters.workDateTo).trim());
  }

  if (filters.checkIn !== undefined && String(filters.checkIn).trim() !== '') {
    conditions.push('a.checkIn = ?');
    params.push(Number(filters.checkIn));
  }

  if (filters.checkOut !== undefined && String(filters.checkOut).trim() !== '') {
    conditions.push('a.checkOut = ?');
    params.push(Number(filters.checkOut));
  }

  if (filters.keyword) {
    conditions.push(
      '(a.userId LIKE ? OR CONCAT(u.firstName, " ", u.lastName) LIKE ? OR a.checkInAddress LIKE ? OR a.checkOutAddress LIKE ? OR a.checkInIp LIKE ? OR a.checkOutIp LIKE ?)'
    );
    const like = `%${filters.keyword}%`;
    params.push(like, like, like, like, like, like);
  }

  const whereClause = conditions.length ? `WHERE ${conditions.join(' AND ')}` : '';

  const [rows] = await pool.execute(
    `
      SELECT
        a.id,
        a.userId,
        CONCAT(u.firstName, ' ', u.lastName) AS userName,
        a.workDate,
        a.checkIn,
        a.checkInDateTime,
        a.checkInLng,
        a.checkInLat,
        a.checkInIp,
        a.checkInUserAgent,
        a.checkInAddress,
        a.checkOut,
        a.checkOutDateTime,
        a.checkOutLng,
        a.checkOutLat,
        a.checkOutIp,
        a.checkOutUserAgent,
        a.checkOutAddress,
        a.presence,
        a.status,
        a.inputDate,
        a.inputBy,
        a.updateDate,
        a.updateBy
      FROM attendance a
      LEFT JOIN user u ON u.id = a.userId
      ${whereClause}
      ORDER BY a.workDate DESC, a.checkInDateTime DESC
      LIMIT 1000
    `,
    params
  );

  return rows;
}

async function getAttendanceSummary(filters = {}) {
  const now = new Date();
  const nowStr = fmtDateTime(now);
  const todayStr = ymd(now);

  const [empRows] = await pool.execute(
    `SELECT id, firstName, lastName
     FROM user
     WHERE userTypeId = 1 AND status = 1 AND presence = 1
     ORDER BY firstName ASC, lastName ASC`
  );
  const totalEmployees = empRows.length;

  const [todayAttendance] = await pool.execute(
    `SELECT a.userId, a.checkIn, a.checkOut, a.checkInDateTime, a.checkOutDateTime,
            a.checkInAddress, a.checkOutAddress
     FROM attendance a
     INNER JOIN user u ON u.id = a.userId AND u.userTypeId = 1
     WHERE a.workDate = ? AND a.presence = 1`,
    [todayStr]
  );
  const todayByUser = new Map(todayAttendance.map((r) => [r.userId, r]));

  let checkedInToday = 0;
  let lateArrivals = 0;
  const today = empRows.map((emp) => {
    const rec = todayByUser.get(emp.id);
    const row = buildTodayRow(emp, rec, nowStr);
    if (row.checkedIn) checkedInToday += 1;
    if (row.isLate) lateArrivals += 1;
    return row;
  });

  const notCheckedInToday = Math.max(totalEmployees - checkedInToday, 0);

  const [mcoCount] = await pool.execute(
    `SELECT COUNT(*) AS c
     FROM attendance a
     INNER JOIN user u ON u.id = a.userId AND u.userTypeId = 1
     WHERE a.workDate >= DATE_SUB(?, INTERVAL 7 DAY) AND a.workDate <= ?
       AND a.presence = 1 AND a.checkIn = 1 AND a.checkOut = 0`,
    [todayStr, todayStr]
  );
  const missingCheckOut = Number(mcoCount[0].c || 0);

  const monthStart = `${todayStr.slice(0, 7)}-01`;
  const [monthRows] = await pool.execute(
    `SELECT a.checkInDateTime, a.checkOutDateTime
     FROM attendance a
     INNER JOIN user u ON u.id = a.userId AND u.userTypeId = 1
     WHERE a.workDate >= ? AND a.workDate <= ?
       AND a.presence = 1 AND a.checkIn = 1 AND a.checkOut = 1`,
    [monthStart, todayStr]
  );
  let totalMins = 0;
  for (const r of monthRows) totalMins += diffMinutes(r.checkInDateTime, r.checkOutDateTime);
  const avgWorkHoursPerDay = monthRows.length ? fmtDuration(Math.round(totalMins / monthRows.length)) : '0h 0m';

  return buildSummaryDashboards({
    filters,
    todayStr,
    nowStr,
    now,
    totalEmployees,
    checkedInToday,
    lateArrivals,
    notCheckedInToday,
    missingCheckOut,
    avgWorkHoursPerDay,
    today,
  });
}

async function buildSummaryDashboards(ctx) {
  const workingDays = lastWorkingDays(10, ctx.now);
  const firstDay = ymd(workingDays[0]);
  const lastDay = ymd(workingDays[workingDays.length - 1]);
  const [trendRows] = await pool.execute(
    `SELECT a.workDate, a.checkInDateTime
     FROM attendance a
     INNER JOIN user u ON u.id = a.userId AND u.userTypeId = 1
     WHERE a.workDate >= ? AND a.workDate <= ?
       AND a.presence = 1 AND a.checkIn = 1`,
    [firstDay, lastDay]
  );
  const trendByDay = {};
  for (const r of trendRows) {
    (trendByDay[r.workDate] = trendByDay[r.workDate] || []).push(r.checkInDateTime);
  }
  const trend = workingDays.map((d) => {
    const ds = ymd(d);
    const times = trendByDay[ds] || [];
    let onTime = 0;
    let late = 0;
    for (const t of times) {
      if (timePart(t) > LATE_THRESHOLD) late += 1;
      else onTime += 1;
    }
    return {
      label: dayLabel(d),
      onTime,
      late,
      absent: Math.max(ctx.totalEmployees - (onTime + late), 0),
      isToday: ds === ctx.todayStr,
    };
  });

  const [locRows] = await pool.execute(
    `SELECT COALESCE(NULLIF(a.checkInAddress, ''), 'Unknown') AS name, COUNT(*) AS cnt
     FROM attendance a
     INNER JOIN user u ON u.id = a.userId AND u.userTypeId = 1
     WHERE a.workDate = ? AND a.presence = 1 AND a.checkIn = 1
     GROUP BY name
     ORDER BY cnt DESC`,
    [ctx.todayStr]
  );
  const locations = locRows.map((r) => ({
    name: r.name,
    shortName: shortLoc(r.name),
    count: Number(r.cnt),
  }));

  const attention = [];

  const [mcoItems] = await pool.execute(
    `SELECT a.userId, CONCAT(u.firstName, ' ', u.lastName) AS name, a.workDate, a.checkInDateTime, a.checkInAddress
     FROM attendance a
     INNER JOIN user u ON u.id = a.userId AND u.userTypeId = 1
     WHERE a.workDate >= DATE_SUB(?, INTERVAL 7 DAY) AND a.workDate <= ?
       AND a.presence = 1 AND a.checkIn = 1 AND a.checkOut = 0
     ORDER BY a.workDate DESC
     LIMIT 6`,
    [ctx.todayStr, ctx.todayStr]
  );
  for (const r of mcoItems) {
    attention.push({
      severity: 'danger',
      type: 'Missing check-out',
      date: r.workDate,
      name: r.name,
      location: shortLoc(r.checkInAddress),
      note: `Checked in ${timePart(r.checkInDateTime)}, no check-out recorded`,
    });
  }

  const notCheckedInNames = ctx.today.filter((t) => !t.checkedIn).map((t) => t.name);
  if (notCheckedInNames.length) {
    attention.push({
      severity: 'warning',
      type: 'Not checked in',
      date: ctx.todayStr,
      name: notCheckedInNames.join(', '),
      location: '',
      note: `No attendance record as of ${timePart(ctx.nowStr)}`,
    });
  }

  const [diffLoc] = await pool.execute(
    `SELECT a.userId, CONCAT(u.firstName, ' ', u.lastName) AS name, a.workDate, a.checkInAddress, a.checkOutAddress
     FROM attendance a
     INNER JOIN user u ON u.id = a.userId AND u.userTypeId = 1
     WHERE a.workDate >= DATE_SUB(?, INTERVAL 7 DAY) AND a.workDate <= ?
       AND a.presence = 1 AND a.checkIn = 1 AND a.checkOut = 1
       AND a.checkInAddress IS NOT NULL AND a.checkOutAddress IS NOT NULL
       AND a.checkInAddress <> a.checkOutAddress
     ORDER BY a.workDate DESC
     LIMIT 4`,
    [ctx.todayStr, ctx.todayStr]
  );
  for (const r of diffLoc) {
    attention.push({
      severity: 'warning',
      type: 'Different check-out location',
      date: r.workDate,
      name: r.name,
      location: '',
      note: `In: ${shortLoc(r.checkInAddress)} -> Out: ${shortLoc(r.checkOutAddress)}`,
    });
  }

  const [dup] = await pool.execute(
    `SELECT a.userId, CONCAT(u.firstName, ' ', u.lastName) AS name, a.workDate, COUNT(*) AS cnt
     FROM attendance a
     INNER JOIN user u ON u.id = a.userId AND u.userTypeId = 1
     WHERE a.workDate >= DATE_SUB(?, INTERVAL 30 DAY) AND a.workDate <= ?
       AND a.presence = 1
     GROUP BY a.userId, a.workDate
     HAVING cnt > 1
     ORDER BY a.workDate DESC
     LIMIT 4`,
    [ctx.todayStr, ctx.todayStr]
  );
  for (const r of dup) {
    attention.push({
      severity: 'secondary',
      type: 'Duplicate records',
      date: r.workDate,
      name: r.name,
      location: '',
      note: `${r.cnt} rows for the same date, please review`,
    });
  }

  return {
    filters: { ...ctx.filters },
    kpi: {
      totalEmployees: ctx.totalEmployees,
      checkedInToday: ctx.checkedInToday,
      lateArrivals: ctx.lateArrivals,
      notCheckedInToday: ctx.notCheckedInToday,
      missingCheckOut: ctx.missingCheckOut,
      avgWorkHoursPerDay: ctx.avgWorkHoursPerDay,
    },
    trend,
    locations,
    needsAttention: attention,
    today: ctx.today,
    todayLabel: ctx.todayStr,
  };
}

function monthLabel(month) {
  const [y, m] = month.split('-').map(Number);
  const mon = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
  return `${mon[m - 1]} ${y}`;
}

function recentMonths(count) {
  const out = [];
  const now = new Date();
  for (let i = 0; i < count; i++) {
    const d = new Date(now.getFullYear(), now.getMonth() - i, 1);
    const value = `${d.getFullYear()}-${pad2(d.getMonth() + 1)}`;
    out.push({ value, label: monthLabel(value) });
  }
  return out;
}

function workingDaysInRange(startDate, endDate) {
  const days = [];
  const d = new Date(startDate);
  const end = new Date(endDate);
  while (d <= end) {
    const dow = d.getDay();
    if (dow !== 0 && dow !== 6) {
      days.push(ymd(d));
    }
    d.setDate(d.getDate() + 1);
  }
  return days;
}

async function getAttendanceDashboard(filters = {}) {
  const defaultMonth = ymd(new Date()).slice(0, 7);
  const month =
    filters.month && /^\d{4}-\d{2}$/.test(String(filters.month))
      ? String(filters.month)
      : defaultMonth;

  const [y, m] = month.split('-').map(Number);
  const start = new Date(y, m - 1, 1);
  const last = new Date(y, m, 0);
  const today = new Date();
  today.setHours(0, 0, 0, 0);
  const end = last.getTime() < today.getTime() ? last : today;

  const workingDays = workingDaysInRange(start, end);

  const [empRows] = await pool.execute(
    `SELECT id, firstName, lastName
     FROM user
     WHERE userTypeId = 1 AND status = 1 AND presence = 1
     ORDER BY firstName ASC, lastName ASC`
  );

  const monthStart = `${month}-01`;
  const monthEnd = ymd(last);

  const [attRows] = await pool.execute(
    `SELECT a.userId, a.workDate, a.checkIn, a.checkOut, a.checkInDateTime, a.checkOutDateTime
     FROM attendance a
     INNER JOIN user u ON u.id = a.userId AND u.userTypeId = 1
     WHERE a.workDate >= ? AND a.workDate <= ? AND a.presence = 1`,
    [monthStart, monthEnd]
  );

  const byUser = new Map();
  for (const r of attRows) {
    if (!byUser.has(r.userId)) {
      byUser.set(r.userId, []);
    }
    byUser.get(r.userId).push(r);
  }

  const employees = empRows.map((emp) => {
    const rows = byUser.get(emp.id) || [];
    const presentDates = new Set();
    let late = 0;
    let missingOut = 0;
    let totalMins = 0;

    for (const r of rows) {
      if (Number(r.checkIn) === 1) {
        presentDates.add(r.workDate);
        if (timePart(r.checkInDateTime) > LATE_THRESHOLD) late += 1;
        if (Number(r.checkOut) === 1) {
          totalMins += diffMinutes(r.checkInDateTime, r.checkOutDateTime);
        } else {
          missingOut += 1;
        }
      }
    }

    const present = presentDates.size;
    const absent = workingDays.filter((d) => !presentDates.has(d)).length;
    const rate = workingDays.length ? Math.round((present / workingDays.length) * 100) : 0;

    return {
      userId: emp.id,
      name: `${emp.firstName || ''} ${emp.lastName || ''}`.trim(),
      present,
      late,
      absent,
      missingOut,
      totalMins,
      totalHours: fmtDuration(totalMins),
      avgPerDay: present ? fmtDuration(Math.round(totalMins / present)) : '0h 0m',
      rate,
    };
  });

  const totals = {
    present: employees.reduce((s, e) => s + e.present, 0),
    late: employees.reduce((s, e) => s + e.late, 0),
    absent: employees.reduce((s, e) => s + e.absent, 0),
    missingOut: employees.reduce((s, e) => s + e.missingOut, 0),
    totalMins: employees.reduce((s, e) => s + e.totalMins, 0),
  };
  totals.totalHours = fmtDuration(totals.totalMins);
  totals.avgPerDay = totals.present
    ? fmtDuration(Math.round(totals.totalMins / totals.present))
    : '0h 0m';
  const denominator = workingDays.length * employees.length;
  totals.rate = denominator ? Math.round((totals.present / denominator) * 100) : 0;

  return {
    filters: { ...filters },
    month,
    monthOptions: recentMonths(3),
    periodLabel: `${start.getDate()}–${end.getDate()} ${monthLabel(month)} · ${workingDays.length} working days`,
    workingDays: workingDays.length,
    employees,
    totals,
  };
}

function clean(value) {
  if (value === undefined || value === null) {
    return null;
  }
  if (typeof value === 'string') {
    const trimmed = value.trim();
    return trimmed === '' ? null : trimmed;
  }
  return value;
}

async function checkIn(userId, data = {}) {
  const now = new Date();
  const nowStr = fmtDateTime(now);
  const today = ymd(now);

  const [openRows] = await pool.execute(
    `SELECT id
       FROM attendance
      WHERE userId = ? AND checkIn = 1 AND checkOut = 0 AND presence = 1
      ORDER BY id DESC
      LIMIT 1`,
    [userId]
  );

  if (openRows.length) {
    const error = new Error('You are already checked in. Please check out first.');
    error.statusCode = 400;
    throw error;
  }

  const [result] = await pool.execute(
    `INSERT INTO attendance
       (userId, workDate, checkIn, checkInDateTime, checkInLng, checkInLat, checkInIp, checkInUserAgent, checkInAddress, checkOut, presence, status, inputDate, inputBy, updateDate, updateBy)
     VALUES (?, ?, 1, ?, ?, ?, ?, ?, ?, 0, 1, 1, ?, ?, ?, ?)`,
    [
      userId,
      today,
      nowStr,
      clean(data.checkInLng),
      clean(data.checkInLat),
      clean(data.checkInIp),
      clean(data.checkInUserAgent),
      clean(data.checkInAddress),
      nowStr,
      userId,
      nowStr,
      userId,
    ]
  );

  return {
    id: result.insertId,
    userId,
    workDate: today,
    checkIn: 1,
    checkInDateTime: nowStr,
    checkInLng: clean(data.checkInLng),
    checkInLat: clean(data.checkInLat),
    checkInAddress: clean(data.checkInAddress),
  };
}

async function checkOut(userId, data = {}) {
  const now = new Date();
  const nowStr = fmtDateTime(now);

  const [openRows] = await pool.execute(
    `SELECT id, workDate, checkInDateTime
       FROM attendance
      WHERE userId = ? AND checkIn = 1 AND checkOut = 0 AND presence = 1
      ORDER BY id DESC
      LIMIT 1`,
    [userId]
  );

  const row = openRows[0];

  if (!row) {
    const error = new Error('You have not checked in yet.');
    error.statusCode = 400;
    throw error;
  }

  await pool.execute(
    `UPDATE attendance
        SET checkOut = 1,
            checkOutDateTime = ?,
            checkOutLng = ?,
            checkOutLat = ?,
            checkOutIp = ?,
            checkOutUserAgent = ?,
            checkOutAddress = ?,
            updateDate = ?,
            updateBy = ?
      WHERE id = ?`,
    [
      nowStr,
      clean(data.checkOutLng),
      clean(data.checkOutLat),
      clean(data.checkOutIp),
      clean(data.checkOutUserAgent),
      clean(data.checkOutAddress),
      nowStr,
      userId,
      row.id,
    ]
  );

  return {
    id: row.id,
    userId,
    workDate: row.workDate,
    checkInDateTime: row.checkInDateTime,
    checkOut: 1,
    checkOutDateTime: nowStr,
    checkOutLng: clean(data.checkOutLng),
    checkOutLat: clean(data.checkOutLat),
    checkOutAddress: clean(data.checkOutAddress),
  };
}
async function getCurrentStatus(userId) {
  const selectColumns = `id, userId, workDate, checkIn, checkInDateTime, checkInLng, checkInLat, checkInIp, checkInUserAgent, checkInAddress,
       checkOut, checkOutDateTime, checkOutLng, checkOutLat, checkOutIp, checkOutUserAgent, checkOutAddress`;

  const [openRows] = await pool.execute(
    `SELECT ${selectColumns}
       FROM attendance
      WHERE userId = ? AND checkIn = 1 AND checkOut = 0 AND presence = 1
      ORDER BY id DESC
      LIMIT 1`,
    [userId]
  );

  const record = openRows[0] || null;

  let lastRecord = null;
  if (!record) {
    const [lastRows] = await pool.execute(
      `SELECT ${selectColumns}
         FROM attendance
        WHERE userId = ? AND presence = 1
        ORDER BY id DESC
        LIMIT 1`,
      [userId]
    );
    lastRecord = lastRows[0] || null;
  }

  return {
    checkedIn: !!record,
    record,
    lastRecord,
  };
}
async function getMyHistory(userId) {
  const [rows] = await pool.execute(
    `SELECT id, userId, workDate, checkIn, checkInDateTime, checkOut, checkOutDateTime,
            checkInLng, checkInLat, checkInAddress, checkOutLng, checkOutLat, checkOutAddress
       FROM attendance
      WHERE userId = ? AND presence = 1
      ORDER BY workDate DESC, checkInDateTime DESC
      LIMIT 60`,
    [userId]
  );
  return rows;
}

module.exports = {
  listAttendance,
  getAttendanceSummary,
  getAttendanceDashboard,
  getCurrentStatus,
  getMyHistory,
  checkIn,
  checkOut,
};