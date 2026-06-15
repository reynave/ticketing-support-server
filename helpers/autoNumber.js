const { pool } = require('../config/db');

function assertName(name) {
  const normalizedName = String(name || '').trim();

  if (!normalizedName) {
    const error = new Error('auto number name is required');
    error.statusCode = 400;
    throw error;
  }

  return normalizedName;
}

function buildRecord(prefix, digit, runningNumber) {
  const safePrefix = String(prefix || '');
  const safeDigit = Number.isFinite(Number(digit)) ? Number(digit) : 0;
  const safeRunningNumber = Number.isFinite(Number(runningNumber)) ? Number(runningNumber) : 0;

  if (safeDigit <= 0) {
    return `${safePrefix}${safeRunningNumber}`;
  }

  return `${safePrefix}${String(safeRunningNumber).padStart(safeDigit, '0')}`;
}

async function runningNumber(name) {
  const normalizedName = assertName(name);
  const connection = await pool.getConnection();

  try {
    await connection.beginTransaction();

    const [rows] = await connection.execute(
      `
        SELECT id, prefix, digit, runningNumber
        FROM auto_number
        WHERE name = ?
        LIMIT 1
        FOR UPDATE
      `,
      [normalizedName]
    );

    const row = rows[0];

    if (!row) {
      const error = new Error(`auto number config not found for name: ${normalizedName}`);
      error.statusCode = 404;
      throw error;
    }

    const nextRunningNumber = Number(row.runningNumber || 0) + 1;
    const record = buildRecord(row.prefix, row.digit, nextRunningNumber);

    await connection.execute(
      `
        UPDATE auto_number
        SET runningNumber = ?, lastRecord = ?, updateDate = NOW()
        WHERE id = ?
      `,
      [nextRunningNumber, record, row.id]
    );

    await connection.commit();
    return record;
  } catch (error) {
    await connection.rollback();
    throw error;
  } finally {
    connection.release();
  }
}

module.exports = {
  runningNumber,
  running_number: runningNumber,
};
