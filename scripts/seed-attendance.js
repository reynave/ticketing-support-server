require('dotenv').config();

const { pool } = require('../config/db');

const OFFICE_LAT = -6.201907;
const OFFICE_LNG = 106.798959;

const USER_AGENTS = [
  'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36',
  'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36',
  'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36',
  'Mozilla/5.0 (iPhone; CPU iPhone OS 18_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.0 Mobile/15E148 Safari/604.1',
  'Mozilla/5.0 (Linux; Android 16; SM-S921B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Mobile Safari/537.36',
];

const ADDRESSES = [
  'Kantor Utama',
  'Menara BCA - Jl. M.H. Thamrin, Jakarta Pusat',
  'Jl. Jend. Sudirman Kav. 1, Jakarta Pusat',
  'The Plaza - Jl. M.H. Thamrin, Jakarta Pusat',
];

function rand(min, max) {
  return Math.random() * (max - min) + min;
}

function randInt(min, max) {
  return Math.floor(rand(min, max + 1));
}

function pick(arr) {
  return arr[Math.floor(Math.random() * arr.length)];
}

function pad(n) {
  return String(n).padStart(2, '0');
}

function toDateStr(d) {
  return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())}`;
}

function toDateTimeStr(d) {
  return `${toDateStr(d)} ${pad(d.getHours())}:${pad(d.getMinutes())}:${pad(d.getSeconds())}`;
}

function jitterCoord(base) {
  return Number((base + rand(-0.004, 0.004)).toFixed(6));
}

function randomIp() {
  if (Math.random() < 0.7) {
    return `192.168.${randInt(1, 50)}.${randInt(2, 250)}`;
  }

  return `10.10.${randInt(0, 5)}.${randInt(2, 250)}`;
}

async function main() {
  const [users] = await pool.query(
    `SELECT id FROM user WHERE userTypeId = 1 AND status = 1 AND presence = 1 ORDER BY id`
  );

  const userIds = users.map((u) => u.id);

  if (!userIds.length) {
    throw new Error('No active internal users found (userTypeId = 1).');
  }

  // Idempotent: hapus sample hasil seed sebelumnya agar tidak duplikat kalau dijalankan ulang.
  await pool.execute(`DELETE FROM attendance WHERE updateBy = 'seed'`);

  const total = 40;
  const today = new Date();

  for (let i = 0; i < total; i++) {
    const userId = pick(userIds);

    const workDate = new Date(today);
    workDate.setDate(today.getDate() - randInt(0, 30));
    const workDateStr = toDateStr(workDate);

    const checkIn = Math.random() < 0.9 ? 1 : 0;
    const checkOut = checkIn === 1 && Math.random() < 0.85 ? 1 : 0;

    const checkInDate = new Date(workDate);
    checkInDate.setHours(randInt(7, 9), randInt(0, 59), randInt(0, 59), 0);
    const checkInDateTime = checkIn ? toDateTimeStr(checkInDate) : '2000-01-01 00:00:00';

    const checkOutDate = new Date(workDate);
    checkOutDate.setHours(randInt(16, 18), randInt(0, 59), randInt(0, 59), 0);
    const checkOutDateTime = checkOut ? toDateTimeStr(checkOutDate) : '2000-01-01 00:00:00';

    await pool.execute(
      `INSERT INTO attendance
        (userId, workDate, checkIn, checkInDateTime, checkInLng, checkInLat, checkInIp, checkInUserAgent, checkInAddress,
         checkOut, checkOutDateTime, checkOutLat, checkOutLng, checkOutIp, checkOutUserAgent, checkOutAddress,
         presence, status, inputDate, inputBy, updateDate, updateBy)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 1, 1, NOW(), 'seed', NOW(), 'seed')`,
      [
        userId,
        workDateStr,
        checkIn,
        checkInDateTime,
        checkIn ? jitterCoord(OFFICE_LNG) : null,
        checkIn ? jitterCoord(OFFICE_LAT) : null,
        checkIn ? randomIp() : null,
        checkIn ? pick(USER_AGENTS) : null,
        checkIn ? pick(ADDRESSES) : null,
        checkOut,
        checkOutDateTime,
        checkOut ? jitterCoord(OFFICE_LAT) : null,
        checkOut ? jitterCoord(OFFICE_LNG) : null,
        checkOut ? randomIp() : null,
        checkOut ? pick(USER_AGENTS) : null,
        checkOut ? pick(ADDRESSES) : null,
      ]
    );
  }

  const [count] = await pool.query(`SELECT COUNT(*) AS c FROM attendance WHERE updateBy = 'seed'`);
  console.log(`Seeded ${count[0].c} attendance rows (userTypeId = 1).`);

  await pool.end();
}

main().catch((error) => {
  console.error('Seed failed:', error.message);
  process.exit(1);
});