require('dotenv').config();

const mysql = require('mysql2/promise');
const bcrypt = require('bcryptjs');

async function seed() {
  const connection = await mysql.createConnection({
    host: process.env.DB_HOST || '127.0.0.1',
    port: Number(process.env.DB_PORT || 3306),
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASS || '',
    database: process.env.DB_NAME || 'thinktank-ticket',
  });

  try {
    await connection.beginTransaction();

    await connection.execute(
      `
        INSERT INTO user_auth_level (id, name, c, r, u, d, presence, inputDate, inputBy, updateDate, updateBy)
        VALUES
          (1, 'Administrator', 1, 1, 1, 1, 1, NOW(), 1, NOW(), 1),
          (2, 'Client User', 1, 1, 0, 0, 1, NOW(), 1, NOW(), 1)
        ON DUPLICATE KEY UPDATE
          name = VALUES(name),
          c = VALUES(c),
          r = VALUES(r),
          u = VALUES(u),
          d = VALUES(d),
          presence = VALUES(presence),
          updateDate = NOW(),
          updateBy = VALUES(updateBy)
      `
    );

    await connection.execute(
      `
        INSERT INTO client (code, name, address, IndustryId, status, presence, inputDate, inputBy, updateDate, updateBy)
        SELECT ?, ?, ?, ?, ?, ?, NOW(), ?, NOW(), ?
        WHERE NOT EXISTS (
          SELECT 1 FROM client WHERE code = ?
        )
      `,
      ['CLI-DEMO', 'Demo Client', 'Jakarta', 351, 1, 1, 1, 1, 'CLI-DEMO']
    );

    const [clientRows] = await connection.execute(
      'SELECT id FROM client WHERE code = ? LIMIT 1',
      ['CLI-DEMO']
    );

    const clientId = clientRows[0] ? clientRows[0].id : null;

    const adminPasswordHash = await bcrypt.hash('Admin123!', 4);
    const clientPasswordHash = await bcrypt.hash('Client123!', 4);

    await connection.execute(
      `
        INSERT INTO user (id, email, clientId, password, authlevelId, firstName, lastName, phone, mobile, birthday, status, presence, inputDate, inputBy, updateDate, updateBy)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), ?, NOW(), ?)
        ON DUPLICATE KEY UPDATE
          email = VALUES(email),
          clientId = VALUES(clientId),
          password = VALUES(password),
          authlevelId = VALUES(authlevelId),
          firstName = VALUES(firstName),
          lastName = VALUES(lastName),
          phone = VALUES(phone),
          mobile = VALUES(mobile),
          birthday = VALUES(birthday),
          status = VALUES(status),
          presence = VALUES(presence),
          updateDate = NOW(),
          updateBy = VALUES(updateBy)
      `,
      ['USR-ADMIN', 'admin@thinktank.local', null, adminPasswordHash, 1, 'System', 'Admin', '021000000', '081200000001', '1990-01-01', 1, 1, 1, 1]
    );

    await connection.execute(
      `
        INSERT INTO user (id, email, clientId, password, authlevelId, firstName, lastName, phone, mobile, birthday, status, presence, inputDate, inputBy, updateDate, updateBy)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), ?, NOW(), ?)
        ON DUPLICATE KEY UPDATE
          email = VALUES(email),
          clientId = VALUES(clientId),
          password = VALUES(password),
          authlevelId = VALUES(authlevelId),
          firstName = VALUES(firstName),
          lastName = VALUES(lastName),
          phone = VALUES(phone),
          mobile = VALUES(mobile),
          birthday = VALUES(birthday),
          status = VALUES(status),
          presence = VALUES(presence),
          updateDate = NOW(),
          updateBy = VALUES(updateBy)
      `,
      ['USR-CLIENT', 'client.demo@thinktank.local', clientId, clientPasswordHash, 2, 'Client', 'Demo', '021111111', '081200000002', '1992-02-02', 1, 1, 1, 1]
    );

    await connection.commit();

    console.log('Dummy data inserted successfully.');
    console.log('Login sample 1: admin@thinktank.local / Admin123!');
    console.log('Login sample 2: client.demo@thinktank.local / Client123!');
  } catch (error) {
    await connection.rollback();
    throw error;
  } finally {
    await connection.end();
  }
}

seed().catch((error) => {
  console.error('Seed failed:', error.message);
  process.exit(1);
});
