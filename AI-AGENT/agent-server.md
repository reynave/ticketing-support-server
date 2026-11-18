# Agent: Server Builder — Thinktank Ticketing System

> 📌 **Dokumen ini adalah sumber kebenaran (single source of truth) untuk backend.**
> Terakhir di-sync dengan kode: **18 November 2026** (Client Portal API `modules-clients`, project template, draft project/task, attendance, checklist, home dashboard).
> Jika ada perubahan kode, dokumen ini **wajib** di-update pada sesi yang sama.

---

## Current Scope (Tahap Sekarang)

- ✅ **Selesai**: Auth (internal + client), Master Data, Client, Project, User, Ticket Balance.
- ✅ **Selesai**: Modul transaksi **Task / Case / Change Request** + Logs (`ticket_logs`) + Rating + Attachment upload.
- ✅ **Selesai**: Modul pendukung — Template, Product Master, Ticket Categories, User Login History, Admin Report, Client Ticket (versi **staff**, `modules/client-ticket`).
- ✅ **Selesai**: Modul **Attendance (absen)** — check-in/check-out (geo + IP + user-agent) & rekap admin (list, dashboard harian live, rekap bulanan) — module `7001`. Plus modul **Home dashboard** & **Checklist** task (`ticket_checklist`).
- ✅ **Selesai**: Draft Project (`presence = 4`) + Draft Task (`project_ticket_draft`) — create, auto-save, publish (copy draft task → `ticket`), cascade delete.
- ✅ **Selesai**: **Project Template** — simpan project (beserta team, contact, blueprint task) jadi template (`template` + `template_project*`), instantiate template menjadi project baru, apply template ke project yang ada.
- ✅ **Selesai**: **Client Portal API** (`modules-clients`) — subset API khusus user external, dimount di `/api/client-portal/*` (cases, change-requests, projects, master, client-ticket, rating, ticket-balance, ticket-categories).
- 🟡 **Sebagian**: Socket.io — hanya event `connected` & `notification`. Realtime per-ticket **belum** diimplementasikan.
- ⏳ **Belum ada**: refresh token / blacklisting token, unit test, pagination server-side, validasi `express-validator` di modul selain auth.

### Konsep Inti Domain

- Semua entitas kerja (**Task, Case, Change Request**) disimpan di **satu tabel `ticket`**, dibedakan oleh kolom `ticketTypeId`.
- `ticketTypeId`: `1` = Task, `2` = Case, `3` = Change Request.
- Relasi parent–child antar task:
  - Task turunan **Case** mengisi kolom `issueNo` = `id` Case.
  - Task turunan **Change Request** mengisi kolom `crNoRef` = `id` CR.
- 1 ticket = 2 jam / 1 manDay = 8 jam (dicatat lewat kolom `hours` dan tabel `ticket_balance`).
- Client (external user) hanya melihat Case/CR milik project tempat ia tercatat di `project_contact`.
- **Client Portal** (`/api/client-portal/*`) adalah **jalur resmi** untuk user external: scoping wajib lewat `project_contact` (`userId` + `projectId` + `presence = 1`). API staff (`/api/cases`, `/api/change-requests`, …) tetap bisa diakses token client secara teknis (tidak dibatasi `userTypeId`), jadi jangan mengandalkan UI untuk isolasi data.
- **Template project** disimpan di `template` (`tempateType = 'project'`) + `template_project` (header) + `template_project_users` / `template_project_contact` (team & contact) + `template_project_ticket_draft` (blueprint task). Instantiate/apply akan meng-clone ke `project`, `project_users`, `project_contact`, `project_ticket_draft`.
- Draft project memakai `project.presence = 4` (belum publish) dengan `status = 1` yang sudah di-set saat create; publish **hanya** mengubah `presence` `4 → 1` (bukan `status`).
- Draft task disimpan di tabel **`project_ticket_draft`** (mirror `ticket`). Saat project di-publish (`presence 4→1`), draft task di-copy ke `ticket` (`ticketTypeId = 1`, `ticketStatusId = 1`) lalu soft-delete di `project_ticket_draft`.
- **Attendance (absen)** dicatat pegawai (user `userTypeId = 1`) via `POST /attendance/check-in` & `PUT /attendance/check-out` (geo `lat`/`lng`, IP, user-agent, alamat). Satu baris = satu hari kerja (`workDate`) dengan flag `checkIn`/`checkOut` 0/1. Rekap admin dibaca dari tabel `attendance`; access right module `7001`.

---

## Tech Stack

- Runtime: Node.js
- Framework: **Express.js 5.2.1** (⚠️ bukan Express 4)
- Realtime: Socket.io 4.8.3
- Database: MariaDB 10.4 / MySQL (`mysql2` 3.22.5, promise + pool)
- Auth: JWT (`jsonwebtoken` 9.0.3)
- Password: `bcryptjs` 3.0.3
- Upload: `multer` 2.2.0
- Env: `dotenv` 17.x
- Middleware: `cors`, `helmet`, `express-validator`
- Dev: `nodemon`

> ⚠️ **Perbedaan penting dari Express 4** (penting saat menambah route):
> - Routing memakai `path-to-regexp` v8 — wildcard harus `/*splat`, bukan `*`.
> - Error dari async route handler otomatis diteruskan ke error middleware.
> - `pool` di `config/db.js` memakai `dateStrings: true` → kolom DATETIME dikembalikan sebagai **string**, bukan object `Date`.

---

## Project Root: `c:\nodejs\8thinktank-ticketing\server`

> Repository Git berada di dalam folder `server/` (bukan di root workspace).

---

## Environment Variables (`.env`)

```env
PRODUCTION=false          # true = auth wajib JWT valid; false = boleh fallback x-user-id
PORT=3000
DB_HOST=127.0.0.1
DB_PORT=3306
DB_NAME=thinktank-ticket
DB_USER=root
DB_PASS=
JWT_SECRET=change-this-secret
JWT_EXPIRES_IN=8h
PREFIX_SERVER=/api        # prefix global semua route
```

### Perilaku `PRODUCTION`

`middlewares/auth.js` memakai flag ini:

| `PRODUCTION` | Token tidak valid / tidak ada |
|---|---|
| `true` | Response `401` (`Invalid token` / `Unauthorized`) — request dihentikan |
| `false` | Request **diloloskan**; bila header `x-user-id` ada, dipakai sebagai `req.user` |

> ⚠️ Wajib `PRODUCTION=true` di produksi. Default `false` hanya untuk development.
> ⚠️ `.env.example` belum memuat `PRODUCTION` dan `PREFIX_SERVER` — tambahkan agar tidak lupa saat setup baru.

---

## Folder Structure (Kondisi Real)

```
server/
├── config/
│   └── db.js                       # MySQL pool + testConnection()
├── helpers/
│   ├── autoNumber.js               # runningNumber(name) → prefix+digit, transaksional FOR UPDATE
│   └── response.js                 # success(message, data) / failure(message, data)
├── middlewares/
│   ├── auth.js                     # JWT verify + logic PRODUCTION fallback
│   ├── errorHandler.js             # Global error handler (baca error.statusCode)
│   └── upload.middleware.js        # multer: upload + runMiddleware()
├── modules/
│   ├── auth/                       # Login internal (clientId = 0)
│   ├── client-auth/                # Login client (userTypeId = 2) + profile
│   ├── master/                     # Generic master data CRUD + status/badge/search
│   ├── ticket-categories/          # CRUD kategori ticket
│   ├── product-master/             # CRUD product (parent-child)
│   ├── client/                     # CRUD client + user/project di dalamnya
│   ├── project/                    # CRUD project + contact + draft task + template project
│   ├── ticket/                     # Task (ticketTypeId = 1)
│   ├── cases/                      # Case (ticketTypeId = 2)
│   ├── change-requests/            # Change Request (ticketTypeId = 3)
│   ├── ticket-balance/             # Saldo & mutasi ticket
│   ├── rating/                     # Rating master + submit rating
│   ├── template/                   # Template JSON (auto-create table) + list task template
│   ├── admin-report/               # Rekap task/case/CR closed
│   ├── client-ticket/              # List case/CR + saldo sisi client (API staff, bukan portal)
│   ├── verification/               # Verifikasi case oleh client (ticketStatusId = 400)
│   ├── checklist/                  # Checklist item task (tabel `ticket_checklist`)
│   ├── attendance/                 # Check-in/check-out + rekap attendance
│   ├── home/                       # Dashboard home (task/case/CR kanban + sorting)
│   └── user-login-history/         # Riwayat login
├── modules-clients/                # API khusus CLIENT (dimount di /api/client-portal/*)
│   ├── cases/                      # Case milik client (ticketTypeId = 2)
│   ├── change-requests/            # CR milik client (ticketTypeId = 3)
│   ├── projects/                   # Project milik client (scoped project_contact)
│   ├── master/                     # Status case + ticket severity (read-only)
│   ├── client-ticket/              # List case/CR + saldo client
│   ├── rating/                     # Rating master + submit rating
│   ├── ticket-balance/             # Mutasi saldo per project
│   └── ticket-categories/          # Kategori ticket (tree parent → children)
├── scripts/
│   ├── seed-dummy-data.js          # Seed admin + client demo (npm run seed:dummy)
│   └── seed-attendance.js          # Seed data attendance dummy (~40 baris; manual, belum ada npm script)
├── uploads/                        # Hasil multer, disajikan statis di /uploads
├── .env / .env.example
├── app.log                         # Log stdout+stderr (di-intercept di server.js)
└── server.js                       # Single entry: Express + HTTP + Socket.io
```

> **Tidak ada lagi** folder `socket/`, `middlewares/accessControl.js`, atau modul `project-master`.
> Modul `project-master` di-versi lama sudah dipecah menjadi modul `project` + modul `product-master`.
> `modules-clients/` adalah **salinan terpisah** untuk kebutuhan client portal — bukan symlink/alias dari `modules/`. Saat mengubah logika transaksi (mis. aturan tutup case + `ticket_balance`), **cek keduanya**.


---

## Arsitektur 3-Layer per Modul

Setiap modul `modules/<nama>/` terdiri dari 3 file dengan tanggung jawab tegas:

| File | Isi | Dilarang |
|---|---|---|
| `*.service.js` | Semua query SQL, validasi bisnis, `throw Error` + `error.statusCode` | Tidak boleh menyentuh `req`/`res` |
| `*.controller.js` | Ambil `req.params/query/body`, panggil service, kirim response | Tidak boleh menulis SQL |
| `*.route.js` | Daftar route + middleware | Tidak boleh berisi logika bisnis |

> Pola yang sama dipakai di `modules-clients/<nama>/` (Client Portal). Bedanya: controller di sana **wajib** mengambil actor dari token (`req.user.id`) dan meneruskannya ke service untuk scoping `project_contact`.

**Pola error handling di service:**

```js
const error = new Error('Project not found');
error.statusCode = 404;
throw error;
```

`middlewares/errorHandler.js` membaca `error.statusCode` (default 500) dan `error.details`, lalu membalas `failure(message, details)`.

---

## Konvensi Kode

- Semua response memakai wrapper `helpers/response.js`:
  ```js
  { status: true, message: '', data: null }
  ```
  - `return res.json(success('X fetched', data))`
  - Create → `res.status(201).json(success('X created', data))`
- Soft delete: set `presence = 0`, **jangan** `DELETE` dari DB.
- Timestamp audit: `inputDate` / `updateDate` memakai `NOW()` MySQL (bukan `new Date()`).
- `inputBy` / `updateBy`: bertipe **string** pada tabel transaksi (`user.id`), tapi **smallint/int** pada tabel master. Ikuti skema tabel masing-masing.
- Auto number memakai `helpers/autoNumber.js` → `runningNumber(name)`. Konfigurasi ada di tabel `auto_number`:

  | name | prefix | digit | Contoh |
  |---|---|---|---|
  | `project` | `P` | 6 | `P000001` |
  | `client` | `C` | 6 | `C000001` |
  | `task` | `TA` | 6 | `TA000069` |
  | `issue` | `IS` | 6 | `IS000075` |
  | `cr` | `CR` | 6 | `CR000002` |

  `runningNumber` memakai transaksi + `SELECT ... FOR UPDATE`, aman dari race condition.
  Ekspor tersedia: `runningNumber` dan alias `running_number`.
- Password: `bcrypt.hash(password, 4)` — saltRounds **4** (mengikuti kode yang ada; naikkan bila memungkinkan).
- Config env dibaca langsung dari `.env` via `dotenv.config()` (tanpa `config/env.js`).
- Saat insert ke tabel transaksi, kolom **`id` varchar boleh dikirim manual**; bila kosong, backend meng-generate sendiri (lihat tabel di bawah).

### Actor ID Pattern

Controller mengambil user dari token dengan fallback, konsisten di semua modul:

```js
const actorId = req.user?.id ? String(req.user.id) : '1';
```

> ⚠️ Di `modules-clients/*` polanya **berbeda**: fallback-nya string kosong (`return req.user?.id ? String(req.user.id) : '';`), bukan `'1'`. Nilai kosong itu lalu dipakai sebagai `userId` scoping → hasilnya `403` (detail) atau list kosong, sehingga tidak ada eskalasi data. Create **case** dan **CR** di portal sama-sama memakai actor token untuk `submitBy` **dan** `inputBy`/`updateBy` (hard-code `'1'` sudah dihapus).

### Format ID Otomatis per Modul

| Modul | Sumber ID |
|---|---|
| `ticket` (Task) | `runningNumber('task')` → `TA######` |
| `cases` (Case) | `runningNumber('issue')` → `IS######` |
| `change-requests` (CR) | `runningNumber('cr')` → `CR######` |
| `project` | `PRJ-${randomUUID().split('-')[0].toUpperCase()}` |
| `project_ticket_draft` (draft task) | `DRFT-${randomUUID().split('-')[0].toUpperCase()}` |
| `user` | `USR-${randomUUID().split('-')[0].toUpperCase()}` |
| `client` | AUTO_INCREMENT (id int; kolom `code` varchar diisi manual) |

### JWT Payload

| Endpoint login | Payload |
|---|---|
| `/api/auth/login` (internal) | `{ id, name, email, userAuthLevelId, clientId, userTypeId, accessRights[] }` |
| `/api/client-auth/login` (client) | `{ id, name, email, userAuthLevelId, clientId, userTypeId, company }` |

> ⚠️ Nama field adalah **`userAuthLevelId`**, bukan `authlevelId`.
> `accessRights` dihitung dari `user_access_right` join `module`, berisi `{ name, moduleId, c, r, u, d }`.

---


## Database

Engine: **MariaDB 10.4.28** (dari dump `master-table.sql`).
Semua DDL berada di `AI-AGENT/master-table.sql` + `AI-AGENT/alterTable.sql` — **tidak** ada file SQL per modul.

> ⚠️ `alterTable.sql` berisi DDL tabel `ticket_solution_time` yang belum ada di `master-table.sql`. Jalankan keduanya.

### Konvensi Kolom Audit

Hampir semua tabel memiliki:

```sql
presence   TINYINT(2) NOT NULL DEFAULT 1,     -- soft delete flag
inputDate  DATETIME NOT NULL DEFAULT '2025-01-01 00:00:00',
inputBy    ... NOT NULL DEFAULT 1,           -- tipe: smallint / int / varchar
updateDate DATETIME NOT NULL DEFAULT '2025-01-01 00:00:00',
updateBy   ... NOT NULL DEFAULT 1,
```

### Tabel Master

| Tabel | PK | Catatan penting |
|---|---|---|
| `auto_number` | int AI | Konfigurasi sequence: `name`, `prefix`, `digit`, `runningNumber`, `lastRecord` |
| `module` | int AI | Hanya 2 kolom: `id`, `name`. **Tidak punya `presence`/audit**. Charset `utf16` |
| `location` | int AI | `asDefault`, `name`, `address`, `lat`, `lng`, `radius`, `officeHourStart/End`. ⚠️ **Legacy** — tidak ada satu pun query `FROM/INTO/UPDATE location` di `modules/*`; absensi memakai lat/lng yang dikirim client |
| `industry` | mediumint AI | `name`, `status` |
| `product` | smallint AI | `parentId` self-referencing (hierarchical) |
| `project_type` | int AI | `ticketBased`, `categoryBased`, `status` |
| `project_billeable` | int AI | `name`, `status` |
| `ticket_categories` | int AI | `parentId`, `weight`, `sorting`, `status`. ⚠️ Namanya `ticket_categories`, **bukan** `project_categories` |
| `user_auth_level` | smallint AI | `name`, `status` |
| `user_type` | smallint AI | `id`=1 Internal, `id`=2 External |
| `user_access_right` | int AI | `authLevelId`, `moduleId`, flag CRUD `c`/`r`/`u`/`d`, `status` |
| `global_setting` | int AI | `name`, `value`, `note`. **Tidak punya `presence`** — read/update only |
| `rating` | int AI | `name`, `status` |
| `ticket_type` | int AI | `id`=1 Task, `id`=2 Case, `id`=3 Change Request (CR) |
| `ticket_status` | int AI | `task`, `issues`, `cr` (flag per tipe), `finish`, `color`. **Punya `presence`** |
| `ticket_severity` | int AI | `name`, `duration`, `color` |
| `ticket_solution_time` | int AI | Hanya ada di `alterTable.sql` |

### Tabel Transaksi — Identitas

#### `client`
```sql
id INT AI PK, code VARCHAR(50), name VARCHAR(250), address VARCHAR(250),
IndustryId INT DEFAULT 0, status TINYINT, presence, audit...
```
> ⚠️ Kolom bernama **`IndustryId`** (capital I) — wajib di-backtick di SQL.
> ⚠️ `inputBy`/`updateBy` bertipe **smallint**, bukan varchar.

#### `user`
```sql
id VARCHAR(250) PK, email VARCHAR(200) UNIQUE, clientId INT DEFAULT 0,
userTypeId TINYINT DEFAULT 1, password VARCHAR(200), userAuthLevelId SMALLINT,
firstName, lastName, phone, mobile, birthday DATE, division, position,
status TINYINT, presence, audit...
```
> ⚠️ Nama kolom auth level adalah **`userAuthLevelId`**, bukan `authlevelId`.
> ⚠️ `inputBy`/`updateBy` bertipe **INT**, bukan varchar.
> ⚠️ `position` **NOT NULL tanpa default** → wajib diisi saat insert.
> ⚠️ `birthday` **NOT NULL** dengan default `'2000-01-01'`.
> Relasi: internal user `clientId = 0`; external user `clientId` menunjuk `client.id`.

#### `project`
```sql
id VARCHAR(100) PK, name VARCHAR(250) NOT NULL,
projectTypeId SMALLINT, projectBilleableId SMALLINT, productId INT,
ticketCategoriesParentId INT NOT NULL, ticketBaseHours FLOAT DEFAULT 0,
clientId VARCHAR(50) DEFAULT '0', startDate DATE, endDate DATE,
status TINYINT, templateMaster VARCHAR(50), presence, audit...
```
> ⚠️ **Known issue (belum diperbaiki)**: `clientId` masih `varchar(50)`, sementara `client.id` dan `user.clientId` bertipe `int(11)`. Kode saat ini menutupi ini dengan konversi `String()`. Disarankan ubah ke `INT` untuk konsistensi.
> ⚠️ `ticketCategoriesParentId` merujuk `ticket_categories.id`.
> ⚠️ `inputBy`/`updateBy` bertipe **varchar(50)** → diisi `user.id` (contoh: `USR-ADMIN`).
> ⚠️ Nilai `presence`: `1` = published, `4` = **draft**, `0` = soft-delete. `status = 1` **wajib** ada saat create (baik draft maupun publish) — `createProjectDraft` meng-insert `status = 1` & `presence = 4` sekaligus, dan publish hanya mengubah `presence` `4 → 1` (bukan `status`). Jangan pakai `status` sebagai penanda publish.

#### `project_contact`
```sql
id INT AI PK, clientId VARCHAR(50), projectId VARCHAR(50), userId VARCHAR(100), presence, audit...
```
Tabel penghubung user ↔ project. **Sumber kebenaran akses** untuk seluruh Client Portal: setiap query list di `modules-clients/*` memakai `INNER JOIN project_contact pc ON pc.projectId = ... AND pc.userId = ? AND pc.presence = 1`, dan endpoint detail memanggil `canClientAccessProject`.

- Satu baris valid = kombinasi **`clientId` + `projectId` + `userId` + `presence = 1`**.
- ⚠️ Tidak ada `UNIQUE (projectId, userId)` di DDL → baris duplikat mungkin terjadi (data dump memang punya duplikat). `canClientAccessProject` memakai `LIMIT 1` sehingga aman, tetapi query yang meng-`JOIN` tanpa `DISTINCT`/`GROUP BY` bisa menggandakan hasil.
- Hapus contact = soft delete (`presence = 0`); modul staff `project` melakukannya lewat `removeContactFromProject` (lihat Known Issues).
- Modul `client-ticket` (staff) juga memakainya untuk menentukan Case/CR mana yang terlihat oleh client.

#### `project_users`
```sql
id INT AI PK, projectId VARCHAR(50), userId VARCHAR(100), asManager TINYINT DEFAULT 0, presence, audit...
```
Menandai user sebagai manager (asManager = 1) sebuah project.

#### `project_ticket_draft`
```sql
id VARCHAR(50) PK, ticketTypeId INT DEFAULT 0, ticketCategoryId INT, ticketSeverityId INT,
productChildId VARCHAR(50), crNoRef VARCHAR(50), issueNo VARCHAR(50),
title VARCHAR(250), description TEXT, projectId VARCHAR(50),
assignTo VARCHAR(50), targetCompletionDate DATETIME, actualCompletionDate DATETIME,
ticketStatusId INT DEFAULT 0, rating TINYINT, sorting MEDIUMINT DEFAULT 999,
projectSorting MEDIUMINT DEFAULT 999, presence, audit...
```
Draft task milik **draft project** (`presence = 4`), skema **mirror** `ticket`.
- ID di-generate `DRFT-XXXXXXXX` (random), **bukan** `TA...`.
- Saat publish project, di-copy ke `ticket` dengan id `runningNumber('task')` (TA...), `ticketStatusId = 1`, lalu soft-delete di `project_ticket_draft`.
- Urutan di UI memakai `projectSorting` (drag-drop di halaman Project Create).

### Tabel Transaksi — Relasi Product

#### `client_product`
```sql
id SMALLINT AI PK, clientId INT DEFAULT 0, productId SMALLINT DEFAULT 0,
status TINYINT DEFAULT 1, presence, audit (inputBy/updateBy VARCHAR(250))...
```
Relasi client ↔ product.
- Dibaca `GET /api/client/:id/products` (menghasilkan flag `checked` per product) dan **ditimpa total** oleh `PUT /api/client/:id/products` (body `{ productIds: [...] }`).
- ⚠️ Tidak ada `UNIQUE (clientId, productId)` → dump berisi baris duplikat/soft-deleted berulang. Kode saat ini meng-`UPDATE ... presence = 0` untuk semua baris client lalu re-insert, jadi jumlah baris terus bertambah.

#### `user_product`
```sql
id SMALLINT AI PK, userId VARCHAR(250) DEFAULT '', productId SMALLINT DEFAULT 0,
status TINYINT DEFAULT 1, presence, audit (inputBy/updateBy VARCHAR(250))...
```
Relasi user ↔ product.
- Menjadi sumber filter `matchUserProduct=1`:
  - `GET /api/client?matchUserProduct=1` → `EXISTS (SELECT 1 FROM client_product cp JOIN user_product up ON up.productId = cp.productId WHERE cp.clientId = c.id AND cp.presence = 1 AND up.userId = ? AND up.presence = 1)`.
  - `GET /api/project?matchUserProduct=1` → `EXISTS (SELECT 1 FROM user_product up WHERE up.productId = p.productId AND up.userId = ? AND up.presence = 1)`.
  - `userId` pada kedua query **selalu** dari token (`req.user.id`); `project.controller` bahkan menghapus `query.userId` kiriman client (`delete query.userId`) lalu mengisi `query.contactUserId` dari token.
- Ditimpa total oleh `PUT /api/user/:id/products` (pola sama: `UPDATE ... presence = 0` lalu insert ulang).

### Tabel Transaksi — Ticket

#### `ticket` (Tabel Tunggal untuk Task/Case/CR)
```sql
id VARCHAR(50) PK,
ticketTypeId INT DEFAULT 0,              -- 1=Task, 2=Case, 3=CR
ticketCategoryId INT NOT NULL,
ticketSeverityId INT NOT NULL,
productChildId VARCHAR(50) DEFAULT '',
crNoRef VARCHAR(50) DEFAULT '',          -- parent CR id (task turunan CR)
issueNo VARCHAR(50) DEFAULT '',          -- parent Case id (task turunan Case)
title VARCHAR(250) DEFAULT '', description TEXT NOT NULL,
responseDateTime DATETIME DEFAULT '2026-01-01', lockTime TINYINT DEFAULT 0,
targetCompletationDateTime DATETIME DEFAULT '2026-01-01',
actualWorkingDateTime DATETIME DEFAULT '2026-01-01',
verificationDateTime DATETIME DEFAULT '2026-01-01', verificationHour FLOAT DEFAULT 0,
actualWorkingHour FLOAT NOT NULL, ticketSolutionTimeId SMALLINT DEFAULT 0,
responseHour FLOAT DEFAULT 0,
projectId VARCHAR(50) DEFAULT '',
submitBy VARCHAR(50) DEFAULT '', submitDate DATETIME DEFAULT '2025-01-01',
deadlineDateTime DATETIME DEFAULT '2026-01-01', targetCompletionDate DATETIME NOT NULL,
assignTo VARCHAR(50) DEFAULT '0', taskSolution TEXT NOT NULL DEFAULT '',
actualCompletionDate DATETIME NOT NULL,
ticketStatusId INT DEFAULT 0,
rating TINYINT NOT NULL, ratesBy VARCHAR(50) DEFAULT '',
ticketEstimationCost DOUBLE DEFAULT 0, hours DOUBLE NOT NULL,
sorting MEDIUMINT DEFAULT 999, projectSorting MEDIUMINT DEFAULT 999,
presence, inputDate, inputBy DEFAULT 'mysql', updateDate, updateBy DEFAULT 'mysql'
```
> ⚠️ **`description` = `TEXT NOT NULL` tanpa default** → wajib diisi saat insert. `taskSolution` juga `NOT NULL` **tapi punya default `''`**.
> ⚠️ `ticketCategoryId`, `ticketSeverityId`, `actualWorkingHour`, `hours`, `rating`, `targetCompletionDate`, `actualCompletionDate` = **NOT NULL tanpa default** → kirim **eksplisit** (`0` untuk `rating`/`hours`/`actualWorkingHour` bila kosong). `createTicket` (`ticket.service.js` ~298) bahkan **tidak** menyertakan `ticketSeverityId`, `hours`, `actualWorkingHour`, `rating`, `taskSolution` → artinya DB produksi berjalan **non-strict**, atau skema DB berbeda dari `master-table.sql`. Jangan andalkan perilaku ini.
> ⚠️ `targetCompletionDate` & `actualCompletionDate` bertipe **DATETIME** (bukan DATE).
> ⚠️ Nama kolom yang mudah salah: `responseDateTime`, `targetCompletationDateTime` (typo "Completation"), `actualWorkingDateTime`, `verificationDateTime` + `verificationHour`.
> ⚠️ `submitDate` & `deadlineDateTime` default `'2025-01-01'` / `'2026-01-01'` — jangan diandalkan sebagai "belum diisi", cek `NULL` tidak mungkin (kolom NOT NULL).
> ⚠️ `inputBy`/`updateBy` bertipe **varchar(50)** dengan default aneh **`'mysql'`** — selalu kirim nilai eksplisit.
> `sorting` dipakai untuk urutan di halaman Task, `projectSorting` untuk urutan di halaman Project.

#### `ticket_logs` (Aktivitas/History)
```sql
id INT AI PK, parentId INT DEFAULT 0, ticketId VARCHAR(50),
starDateTime DATETIME, closeDateTime DATETIME, description TEXT,
presence, inputBySystem TINYINT DEFAULT 0, audit...
```
> ⚠️ Nama kolom **`starDateTime`** (typo "star", bukan "start") — sudah dipakai kode, jangan diubah.

#### `ticket_status_logs` — ⚠️ TIDAK ADA DI DATABASE
```sql
-- skema di bawah hanya "rencana"; tabel fisiknya belum pernah dibuat
id INT UNSIGNED AI PK, ticketId VARCHAR(50), ticketStatusId INT DEFAULT 0,
inputDate DATETIME DEFAULT CURRENT_TIMESTAMP, inputBy VARCHAR(100)
```
> ⚠️ **Jangan dipakai.** `grep` di seluruh repo: tidak ada `CREATE TABLE ticket_status_logs` di `master-table.sql`/`alterTable.sql` dan tidak ada query yang menulis/membacanya. Satu-satunya kemunculan adalah komentar di `verification.service.js` ("hanya ada di dokumen, belum dibuat di database").
> Perubahan status saat ini dicatat lewat `ticket_logs` (deskripsi "Update Status from X to Y") + update kolom `ticket.ticketStatusId`. Bila tabel ini akan diaktifkan, tambahkan DDL ke `master-table.sql` lebih dulu.

#### `ticket_logs_attachments`
```sql
id INT UNSIGNED AI PK, ticketId VARCHAR(50), ticketLogId INT UNSIGNED,
originalName VARCHAR(255), filename VARCHAR(255), mimetype VARCHAR(100),
size INT UNSIGNED, url VARCHAR(500),
inputDate DATETIME DEFAULT CURRENT_TIMESTAMP, inputBy VARCHAR(100)
```
> ⚠️ **Tidak punya `presence`**.

#### `ticket_rating`
```sql
id INT AI PK, ticketId VARCHAR(250), value INT DEFAULT 0, ratingId INT DEFAULT 0, presence, audit...
```

#### `ticket_upload`
```sql
id INT AI PK, url TEXT, presence, audit...
```

### Tabel Transaksi — Balance & History

#### `ticket_balance`
```sql
id INT AI PK, projectId VARCHAR(250), note VARCHAR(250), ticketId VARCHAR(250),
date DATETIME, ticketIn INT DEFAULT 0, ticketOut INT DEFAULT 0, presence, audit...
```
> ⚠️ `note` **NOT NULL tanpa default** → kirim string kosong bila tidak ada.
> ⚠️ `projectId` varchar, konsisten dengan `project.id` (varchar).

#### `user_login_history`
```sql
id INT AI PK, userId VARCHAR(50), loginTime DATETIME (ON UPDATE CURRENT_TIMESTAMP),
ipAddress VARCHAR(50), userAgent TEXT, presence, audit...
```

### Tabel Transaksi — Template Project

#### `template`
```sql
id INT AI PK, name VARCHAR(250), clientId VARCHAR(250), description VARCHAR(250),
version VARCHAR(250), tempateType VARCHAR(250), json TEXT,
presence, status, audit...
```
> ⚠️ Nama kolom **`tempateType`** (typo, bukan `templateType`). Nilai yang dipakai: `'task'` (template task JSON) dan `'project'` (template project).
> ⚠️ `template.service.js` punya `ensureTemplateTable()` yang menjalankan `CREATE TABLE IF NOT EXISTS` dengan skema **berbeda** dari `master-table.sql` (tanpa `clientId`/`status`, charset `utf8mb4_unicode_ci`) dan meng-cache flag di memori modul. Perhatikan ini saat menambah field.

#### `template_project`
```sql
id VARCHAR(100) PK, templateId INT, name VARCHAR(250),
projectTypeId, projectBilleableId, productId, ticketCategoriesParentId INT,
ticketBaseHours FLOAT, clientId VARCHAR(50), startDate DATE, endDate DATE,
status TINYINT, templateMaster VARCHAR(50), presence, audit...
```
> Header project di dalam template. **Tanpa route CRUD sendiri** — hanya ditulis/dibaca lewat endpoint template di `modules/project`.

#### `template_project_users` / `template_project_contact`
```sql
-- users:  id INT AI PK, projectId VARCHAR(100), userId VARCHAR(100), asManager TINYINT, presence, audit...
-- contact: id INT AI PK, projectId VARCHAR(100), clientId VARCHAR(50), userId VARCHAR(100), presence, audit...
```
> Clone dari `project_users` / `project_contact` saat `POST /api/project/:id/template`.

#### `template_project_ticket_draft`
Struktur **mirror `project_ticket_draft`** (kolom `ticketTypeId`, `ticketCategoryId`, `ticketSeverityId`, `title`, `assignTo`, `projectSorting`, `sorting`, dll).
> Blueprint task template. Diisi dari `project_ticket_draft` (project draft) **dan** dari `ticket` dengan `ticketTypeId = 1` (project published), lihat `saveProjectAsTemplate`.

### Tabel Transaksi — Attendance & Checklist

#### `attendance`
```sql
id INT(11) AI PK, userId VARCHAR(250) NOT NULL, workDate DATE,
checkIn TINYINT(4) DEFAULT 0, checkInDateTime DATETIME DEFAULT '2000-01-01 00:00:00',
checkInLng DECIMAL(20,6), checkInLat DECIMAL(20,6),
checkInIp VARCHAR(50), checkInUserAgent VARCHAR(250), checkInAddress VARCHAR(250),
checkOut TINYINT(4) DEFAULT 0, checkOutDateTime DATETIME DEFAULT '2000-01-01 00:00:00',
checkOutLat DECIMAL(20,6), checkOutLng DECIMAL(20,6),
checkOutIp VARCHAR(50), checkOutUserAgent VARCHAR(250), checkOutAddress VARCHAR(250),
presence TINYINT(2) DEFAULT 1, status TINYINT(2) DEFAULT 1, audit (inputBy/updateBy varchar(50))...
```
> Satu baris = satu hari kerja per user. `checkIn`/`checkOut` adalah flag 0/1; timestamp, geo, IP, user-agent, dan alamat hanya terisi saat flag terkait = 1.
> Sudah ada di `master-table.sql` (sekitar baris 18).

#### `ticket_checklist`
```sql
id INT(11) AI PK, ticketId VARCHAR(50) NOT NULL DEFAULT '',
ticketChecklistId INT(11) DEFAULT 0,   -- 0 = root, >0 = sub-item
status TINYINT(4) DEFAULT 0, description TEXT NOT NULL,
sorting MEDIUMINT(9) DEFAULT 999, presence TINYINT(2) DEFAULT 1, audit (varchar)...
```
> **Juga di-auto-create** via `checklist.service.js` → `ensureChecklistTable()` (DDL duplikat). Skema di `master-table.sql` (sekitar baris 908) **sudah ada** — jaga agar keduanya tetap sama.

### Nilai Default Hard-coded di Kode

| Konstanta | Nilai | Lokasi |
|---|---|---|
| `CASE_TYPE_ID` | `2` | `cases/*.service.js` |
| `TASK_TYPE_ID` | `1` | `cases`, `change-requests` |
| `CHANGE_REQUEST_TYPE_ID` | `3` | `change-requests`, `client-ticket` |
| `CLOSED_STATUS_ID` | `900` | `admin-report.service.js` |
| `INTERNAL_USER_TYPE_ID` | `1` | `user.service.js` |
| `EXTERNAL_USER_TYPE_ID` | `2` | `user.service.js` |
| Client id untuk internal user | `0` | filter login internal |
| `LATE_THRESHOLD` | `'08:15:00'` | `attendance.service.js` |
| `END_HOURS` | `'17:00:00'` | `attendance.service.js` |
| Actor hard-code `'1'` | `inputBy`/`updateBy` | `ticket.service.js` (`createTicket`), `ticket-balance.service.js` (`addBalance`) |
| `DEFAULT_TICKET_STATUS_ID` | `1` | `modules-clients/cases/case.service.js` & `modules-clients/change-requests/change-request.service.js` (create) |
| Default kolom `inputBy`/`updateBy` | `'mysql'` | DDL `ticket` di `master-table.sql` |

---

## API Endpoints

Base URL: `http://127.0.0.1:3000` + `PREFIX_SERVER` (default `/api`).
Health check: `GET /api` → `{ status: true, message: 'Server is running', data: { uptime } }`

> Semua endpoint kecuali `*/login` dilindungi `authMiddleware` (`Authorization: Bearer <token>`).
> ⚠️ Dengan `PRODUCTION=false`, middleware tidak menolak request tanpa token. Selalu tes proteksi dengan `PRODUCTION=true`.

### Daftar Mount Point (`server.js`)

Urutan pendaftaran di `server.js` (relevan untuk debugging 404):

| Prefix | Route file | Seksi dokumen |
|---|---|---|
| `/api/auth` | `modules/auth` | Auth — Internal |
| `/api/client-auth` | `modules/client-auth` | Auth — Client |
| `/api/master` | `modules/master` | Master Data Generic |
| `/api/ticket-categories` · `/api/product-master` | `modules/ticket-categories` · `modules/product-master` | Ticket Categories · Product Master |
| `/api/client` | `modules/client` | Client |
| `/api/project` | `modules/project` | Project · Draft Task · Template project |
| `/api/ticket` · `/api/cases` · `/api/change-requests` | `modules/ticket` · `modules/cases` · `modules/change-requests` | Task · Case · Change Request |
| `/api/ticket-balance` · `/api/rating` · `/api/template` | modul masing-masing | Ticket Balance · Rating · Template |
| `/api/user` · `/api/user-login-history` | `modules/user` · `modules/user-login-history` | User · User Login History |
| `/api/adminReport` · `/api/verification` | `modules/admin-report` · `modules/verification` | Admin Report · Verification |
| `/api/client-ticket` | `modules/client-ticket` | Client Ticket — Staff |
| `/api/checklist` · `/api/attendance` · `/api/home` | modul masing-masing | Checklist · Attendance · Home |
| `/api/client-portal/{cases,change-requests,projects,client-ticket,rating,ticket-balance,master,ticket-categories}` | `modules-clients/*` | **Client Portal** |
| `/api/uploads` | static (`server/uploads/`) | Upload File |

> ⚠️ `errorHandler` didaftarkan **paling akhir**; jangan menambah `app.use` setelahnya.

### Auth — Internal (`modules/auth`)
| Method | Endpoint | Keterangan |
|---|---|---|
| POST | `/api/auth/login` | Login user internal (filter `clientId = 0`), return JWT + accessRights |
| GET | `/api/auth/me` | Get current user (re-query DB) |

```json
// POST /api/auth/login
{ "email": "admin@thinktank.local", "password": "Admin123!" }
```
> Login juga mencatat ke `user_login_history` (`userId`, `loginTime`, `ipAddress`, `userAgent`).

### Auth — Client (`modules/client-auth`)
| Method | Endpoint | Keterangan |
|---|---|---|
| POST | `/api/client-auth/login` | Login user external (filter `userTypeId = 2`), return JWT + `company` |
| GET | `/api/client-auth/me` | Get current client user |
| GET | `/api/client-auth/profile` | Detail profil (phone, mobile, birthday, division, position) |
| PUT | `/api/client-auth/profile` | Update profil (email opsional, harus unik) |

### Master Data Generic (`modules/master`)
| Method | Endpoint | Keterangan |
|---|---|---|
| GET | `/api/master/:masterKey` | List master data |
| GET | `/api/master/:masterKey/:id` | Detail (id harus integer) |
| POST | `/api/master/:masterKey` | Create |
| PUT | `/api/master/:masterKey/:id` | Update (partial) |
| DELETE | `/api/master/:masterKey/:id` | Soft delete (`presence = 0`) |

**`masterKey` yang didukung** (dari `tableMap` di `master.service.js`):

| masterKey | Tabel | Create | Update | Delete |
|---|---|---|---|---|
| `industry` | `industry` | ya | ya | ya |
| `project-type` / `project_type` | `project_type` | ya | ya | ya |
| `project-billeable` / `project_billeable` | `project_billeable` | ya | ya | ya |
| `project-categories` / `project_categories` | `project_categories` | ya | ya | ya |
| `user-auth-level` | `user_auth_level` | ya | ya | ya |
| `user-type` | `user_type` | ya | ya | ya |
| `user-access-right` / `user_access_right` | `user_access_right` | ya | ya | ya |
| `module` | `module` | tidak | tidak | tidak |
| `global-setting` / `global_setting` | `global_setting` | tidak | ya | tidak |
| `ticketStatus` | `ticket_status` | tidak | ya | tidak |
| `ticket-severities` / `ticket_severities` / `ticket-severity` / `ticket_severity` / `ticketSeverity` | `ticket_severity` | ya | ya | ya |
| `rating` | `rating` | ya | ya | ya |
| `ticket-solution-time` | `ticket_solution_time` | ya | ya | ya |

> ❌ **Tidak ada lagi** key `product` dan `project` di sini.
> → `product` dipindah ke modul `product-master`, `project` ke modul `project`.
> ⚠️ masterKey `project-categories` mengarah ke tabel `project_categories`, padahal tabel yang ada di DB adalah **`ticket_categories`**. Modul yang aktif untuk kategori ticket adalah `/api/ticket-categories`.
> ⚠️ Master **harus** memakai `masterKey` yang terdaftar di `tableMap`; key tak dikenal akan error.
> ⚠️ Master dengan `allowCreate/Update/Delete: false` akan membalas `405` bila dipanggil.
> `requiredFields` per key: `name` (industry, project-type, project-billeable, project-categories, user-auth-level, user-type, rating), `authLevelId` + `moduleId` (user-access-right), `name` + `value` (global-setting), `name` + `id` (ticketStatus), `name` + `duration` + `color` (ticket-severity, ticket-solution-time).

**Endpoint khusus master** (harus diakses **sebelum** `/:masterKey` agar tidak tertangkap sebagai param):

| Method | Endpoint | Keterangan |
|---|---|---|
| GET | `/api/master/status/task` | Status dengan `task = 1` |
| GET | `/api/master/status/cases` | Status dengan `issues = 1` |
| GET | `/api/master/status/cr` | Status dengan `cr = 1` |
| GET | `/api/master/loadbBadge` | Badge count task/issue/cr aktif untuk `req.user.id` |
| GET | `/api/master/searchTickets?searchText=` | Cari id/title (min 7 karakter, limit 500) |
| GET | `/api/master/searchAllTickets?searchText=` | Cari id saja (min 7 karakter) |

### Client (`modules/client`)
| Method | Endpoint | Keterangan |
|---|---|---|
| GET | `/api/client` | List clients (filter `status`, `industryId`, `keyword`, `matchUserProduct=1`) |
| GET | `/api/client/without-products` | Client yang **belum** punya baris `client_product` aktif — ⚠️ daftar **sebelum** `/:id` |
| GET | `/api/client/:id` | Detail client |
| GET | `/api/client/:id/users` | List external user milik client |
| GET | `/api/client/:id/products` | List product root + flag `checked` (join `client_product`) |
| PUT | `/api/client/:id/products` | **Timpa** seluruh `client_product` client (soft delete lama → insert baru, transaksional) |
| GET | `/api/client/:id/project/:projectId` | List user client yang terkait project |
| GET | `/api/client/:id/projects` | List project milik client |
| POST | `/api/client` | Create client |
| POST | `/api/client/:id/users` | Create external user dari client detail |
| POST | `/api/client/:id/removeProject` | Lepas project dari client |
| PUT | `/api/client/:id` | Update client |
| DELETE | `/api/client/:id` | Soft delete + **cascade** ke external user |

> `matchUserProduct=1` memfilter client yang product-nya beririsan dengan `user_product` milik user login (`client_product.productId = user_product.productId`).
> ⚠️ Body `PUT /:id/products` **hanya** menerima `{ "productIds": [1, 2, 3] }` (integer positif, didedup). Semua baris lama di-soft-delete dulu, jadi kirim **daftar lengkap**, bukan delta. `[]` = kosongkan semua.

### Project (`modules/project`)
| Method | Endpoint | Keterangan |
|---|---|---|
| GET | `/api/project` | List projects **published** (`presence = 1`). Filter: `status`, `clientId`, `projectTypeId`, `id`, `keyword`, `matchUserProduct=1` (+`userId`) |
| GET | `/api/project/ticketList` | List ticket pada project (filter `projectId`) |
| GET | `/api/project/drafts` | List **draft** projects (`presence = 4`, milik user login) |
| GET | `/api/project/templates` | List **template project** (`template` ⨝ `template_project`) |
| GET | `/api/project/detail/:id` | Detail project ⚠️ path `detail/:id`, **bukan** `/:id` (bisa presence 1/4) |
| POST | `/api/project` | Create project |
| POST | `/api/project/draft` | Buat **draft project** kosong (`presence=4`, `status=1`), return `{ id }` |
| POST | `/api/project/contact` | Tambah contact ke project (isi `project_contact`) |
| POST | `/api/project/:id/task` | **Create task langsung** di project (langsung ke tabel `ticket`, `ticketTypeId = 1`) |
| POST | `/api/project/:id/template` | **Simpan project sebagai template** (body `name` wajib, `description`, `version`) |
| POST | `/api/project/template/:id/instantiate` | **Buat project baru** dari template (`id` = `template.id`) |
| POST | `/api/project/:id/apply-template/:templateId` | **Terapkan template** ke project yang sudah ada (clone task/team/contact) |
| PUT | `/api/project/contact` | Hapus contact dari project |
| PUT | `/api/project/task/reorder` | Simpan urutan task project (`projectSorting`) — ⚠️ daftar **sebelum** `/:id` |
| PUT | `/api/project/:id` | Update project — dukung **publish** (`presence 4→1`, `status=1`, copy draft task → `ticket`) |
| DELETE | `/api/project/template/:id` | Soft delete template project — ⚠️ daftar **sebelum** `/:id` |
| DELETE | `/api/project/:id` | Soft delete project + **cascade** `project_ticket_draft` |

> ⚠️ **Urutan route penting**: semua path literal (`/ticketList`, `/drafts`, `/templates`, `/draftTasks`, `/detail/:id`, `/contact`, `/task/reorder`, `/template/...`) didaftarkan **sebelum** `/:id`. Menambah route literal baru di bawah `/:id` akan tertangkap sebagai `id`.
> ⚠️ **Trigger publish adalah `presence: 1`** (bukan `status`). Saat itu terjadi, `project_ticket_draft` (`presence = 1`) di-copy ke `ticket` lalu draft-nya soft-delete, semuanya dalam satu transaksi.
> ⚠️ `payload.users` / `payload.projectUsers` meng-**hapus permanen** (`DELETE FROM project_users`) lalu insert ulang — satu-satunya tempat di repo yang melanggar aturan soft delete. Kirim daftar lengkap bila memakai field ini.
> ⚠️ Template project memakai flag `presence` sendiri di `template` + `template_project*`; `DELETE /template/:id` hanya menyentuh `template` (bukan project hasil instantiate).
> ⚠️ **SQL Injection**: `createProject` menyusun `INSERT INTO project` dengan interpolasi string (`'${name}'`, `'${clientId}'`, tanggal, dsb) alih-alih parameter binding, dan `addContactToProject`/`removeContactFromProject` juga menginterpolasi `projectId`/`clientId`/`a.id`. Lihat Known Issues.
> ⚠️ `PUT /api/project/contact` (removeContact) mengharapkan `req.body` berupa **array**; body berbentuk object akan gagal (`payload is not iterable`).

### Draft Task (`modules/project`, tabel `project_ticket_draft`)
| Method | Endpoint | Keterangan |
|---|---|---|
| GET | `/api/project/draftTasks?projectId=&ticketTypeId=` | List draft task (di-group by `ticketCategoryId`) |
| POST | `/api/project/draftTasks` | Create draft task (body `projectId`, `ticketTypeId=1`, id `DRFT-...`) |
| PUT | `/api/project/draftTasks/reorder` | Simpan urutan `projectSorting` — ⚠️ daftar **sebelum** `/:id` |
| PUT | `/api/project/draftTasks/:id` | Update draft task |
| DELETE | `/api/project/draftTasks/:id` | Soft delete draft task |

### Product Master (`modules/product-master`)
| Method | Endpoint | Keterangan |
|---|---|---|
| GET | `/api/product-master` | List product |
| GET | `/api/product-master/:id` | Detail product |
| POST | `/api/product-master` | Create product |
| PUT | `/api/product-master/:id` | Update product |
| DELETE | `/api/product-master/:id` | Soft delete product |

### Ticket Categories (`modules/ticket-categories`)
| Method | Endpoint | Keterangan |
|---|---|---|
| GET | `/api/ticket-categories` | List (dukung filter `parentId`) |
| GET | `/api/ticket-categories/:id` | Detail |
| POST | `/api/ticket-categories` | Create |
| PUT | `/api/ticket-categories/:id` | Update |
| DELETE | `/api/ticket-categories/:id` | Soft delete |

### User (`modules/user`)
| Method | Endpoint | Keterangan |
|---|---|---|
| GET | `/api/user` | List users |
| GET | `/api/user/:id` | Detail user |
| GET | `/api/user/:id/products` | Product yang di-assign ke user (`user_product`) |
| GET | `/api/user/:id/projects` | Project yang melibatkan user (`project_users`) |
| GET | `/api/user/:id/clients` | Client terkait user |
| GET | `/api/user/:id/attendance` | Riwayat attendance per user |
| POST | `/api/user` | Create user (bcrypt hash, saltRounds 4) |
| PUT | `/api/user/:id` | Update user (partial) |
| PUT | `/api/user/:id/password` | Ganti password |
| PUT | `/api/user/:id/products` | **Timpa** assignment product user (soft delete lama → insert baru) |
| DELETE | `/api/user/:id` | Soft delete + acak email |

> **Soft delete user**: set `presence = 0`, `status = 0`, dan email diacak jadi `delete.<RANDOM>.<EMAIL_LAMA>` (agar tidak bentrok dengan UNIQUE email).
> **Soft delete client** cascade ke seluruh external user terkait dengan rule yang sama.

### User Login History (`modules/user-login-history`)
| Method | Endpoint | Keterangan |
|---|---|---|
| GET | `/api/user-login-history` | List riwayat login (filter `userId`, `startDate`, `endDate`) |

### Template (`modules/template`)
| Method | Endpoint | Keterangan |
|---|---|---|
| GET | `/api/template` | List template (filter `tempateType`, `keyword`) |
| GET | `/api/template/task` | List template dengan `tempateType = 'task'` — ⚠️ daftar **sebelum** `/:id` |
| GET | `/api/template/:id` | Detail template |
| POST | `/api/template` | Create template |
| PUT | `/api/template/:id` | Update template |
| DELETE | `/api/template/:id` | Soft delete template |

> ⚠️ Template **project** (`tempateType = 'project'`) dikelola lewat `/api/project/templates`, `/api/project/:id/template`, `/api/project/template/:id/instantiate`, `/api/project/:id/apply-template/:templateId`, bukan lewat modul ini.
> Semua fungsi di modul ini memanggil `ensureTemplateTable()` lebih dulu.

### Task — `modules/ticket` (`ticketTypeId = 1`)
| Method | Endpoint | Keterangan |
|---|---|---|
| GET | `/api/ticket` | List task (filter: `projectId`, `clientId`, `userId`, `ticketStatusId`, `issueNo`, `keyword`, `closed`) |
| GET | `/api/ticket/:id` | Detail task |
| GET | `/api/ticket/:id/logs` | List activity log |
| POST | `/api/ticket` | Create task |
| POST | `/api/ticket/log/:id` | Tambah activity log ⚠️ path `log/:id` (POST) |
| PUT | `/api/ticket/:id` | Update task |
| PUT | `/api/ticket/:id/submitRate` | Submit rating |
| DELETE | `/api/ticket/:id` | Soft delete task |

> `listTickets` **hard-code** `ticketTypeId = 1` dan selalu memfilter `t.ticketStatusId < 900` (Closed).
> `closed=true` atau `ticketStatusId=1` memakai `< 900`; selain itu `= ticketStatusId` yang diminta.
> ⚠️ `updateTicket` menyisipkan `id` langsung ke query hitung `totalHour` (`FROM ticket WHERE id = '${id}'`), dan insert `ticket_logs` menginterpolasi `submitBy` — lihat Known Issues.
> ⚠️ `createTicket` (`ticket.service.js` ~298) meng-hard-code `inputBy`/`updateBy = '1'` dan **tidak** menyertakan `ticketSeverityId`, `hours`, `actualWorkingHour`, `rating`, `taskSolution` pada `INSERT` — kolom NOT NULL itu terisi nilai "longgar" dari DB non-strict. Field wajib (`validateRequiredCreateFields`): `ticketTypeId`, `title`, `description`, `projectId`, `submitBy`, `submitDate`, `targetCompletionDate`, `assignTo`, `ticketStatusId` (+ `ticketCategoryId` dipakai walau tidak divalidasi).
> ⚠️ `submitBy` diambil **dari body**, bukan dari token (`req.user.id`) → aktor task bisa dipalsukan lewat request.

### Case — `modules/cases` (`ticketTypeId = 2`)
| Method | Endpoint | Keterangan |
|---|---|---|
| GET | `/api/cases` | List case |
| GET | `/api/cases/closed` | List case closed (`ticketStatusId >= 900`) |
| GET | `/api/cases/:id` | Detail case |
| GET | `/api/cases/:id/logs` | List activity log |
| GET | `/api/cases/:id/tasks` | List task turunan (filter `issueNo = caseId`) |
| POST | `/api/cases` | Create case |
| POST | `/api/cases/:id/tasks` | Create task turunan case (isi `issueNo`) |
| POST | `/api/cases/log/:id` | Tambah activity log |
| PUT | `/api/cases/:id` | Update case |
| PUT | `/api/cases/:id/status` | Update status oleh client |
| PUT | `/api/cases/:id/submitInProgress` | Set `responseDateTime`/`targetCompletationDateTime`/`ticketSolutionTimeId`/`responseHour`/`assignTo`, status → **`100`** |
| PUT | `/api/cases/:id/submitVerification` | Body `assignTo` + `taskSolution` (wajib), `verificationDateTime = NOW()`, status → **`400`** |
| PUT | `/api/cases/:id/submitRate` | Submit rating |
| DELETE | `/api/cases/:id` | Soft delete case |

> ⚠️ `submitInProgress` & `submitVerification` **hanya ada di modul `cases`** (staff), tidak ada di `change-requests` maupun di Client Portal.
> ⚠️ `submitInProgress` melempar `error.isWarning = true` untuk kesalahan validasi (mis. target ≤ response) — handler global membalas `400` dengan flag peringatan, bukan error fatal.
> ⚠️ `POST /api/cases/log/:id` didaftarkan **setelah** `/:id/logs` dan `/:id/tasks`, aman karena method berbeda (`POST` vs `GET`).
> ⚠️ Insert `ticket_logs` di `case.service.js` & `change-request.service.js` menyisipkan `payload.submitBy` langsung ke string SQL (`'${payload.submitBy}'`) — ganti ke prepared statement (lihat Known Issues).

### Change Request — `modules/change-requests` (`ticketTypeId = 3`)
| Method | Endpoint | Keterangan |
|---|---|---|
| GET | `/api/change-requests` | List CR |
| GET | `/api/change-requests/:id` | Detail CR |
| GET | `/api/change-requests/:id/logs` | List activity log |
| GET | `/api/change-requests/:id/tasks` | List task turunan (filter `crNoRef = crId`) |
| POST | `/api/change-requests` | Create CR |
| POST | `/api/change-requests/:id/tasks` | Create task turunan CR (isi `crNoRef`) |
| POST | `/api/change-requests/log/:id` | Tambah activity log |
| PUT | `/api/change-requests/:id` | Update CR |
| PUT | `/api/change-requests/:id/status` | Update status oleh client |
| PUT | `/api/change-requests/:id/submitRate` | Submit rating |
| DELETE | `/api/change-requests/:id` | Soft delete CR |

> ⚠️ Modul `cases` dan `change-requests` **duplikatif** — route & nama fungsi identik, hanya berbeda konstanta tipe dan nama kolom relasi (`issueNo` vs `crNoRef`). Saat menambah fitur, terapkan ke **keduanya** atau refactor jadi shared service.
> ⚠️ `change-request.service.js` punya `assertCaseExists()` yang pesannya masih `'Case not found'`, dan pemanggilnya **di-comment** pada `createRelatedTask` (baris ~80). Tidak konsisten dengan `cases`.

### Ticket Balance (`modules/ticket-balance`)
| Method | Endpoint | Keterangan |
|---|---|---|
| GET | `/api/ticket-balance/history` | List mutasi (filter query, optional) |
| GET | `/api/ticket-balance/project/:projectId` | List mutasi per project + saldo berjalan (limit 100) |
| GET | `/api/ticket-balance/summary/:projectId` | Summary `totalTicketIn` / `totalTicketOut` / `balance` |
| POST | `/api/ticket-balance` | Tambah mutasi (top up / pemakaian) |

```json
// POST /api/ticket-balance
{ "projectId": "PRJ-1CF03AF3", "note": "top up", "ticketIn": 10, "ticketOut": 0, "date": "2026-09-10 07:45:34" }
```
> `ticketIn` atau `ticketOut` minimal salah satu `> 0`. `date` optional (default NOW). `projectId` harus ada & `presence = 1`.
> ⚠️ `addBalance` meng-hard-code `inputBy = 1`/`updateBy = 1` (bukan actor dari token).
> `listByProject` menghitung saldo kumulatif di JS, lalu **`rows.reverse()`** sebelum dikirim.

### Rating (`modules/rating`)
| Method | Endpoint | Keterangan |
|---|---|---|
| GET | `/api/rating` | List rating ticket |
| GET | `/api/rating/master` | List rating master |
| GET | `/api/rating/master/:id` | Detail rating master |
| POST | `/api/rating/master` | Create rating master |
| PUT | `/api/rating/master/:id` | Update rating master |
| DELETE | `/api/rating/master/:id` | Soft delete rating master |
| POST | `/api/rating/rate` | Submit rating untuk ticket |

> ⚠️ `createRating` menyisipkan `ticketId`, `averageRating`, dan `ratesBy`/`updateBy` **langsung** ke string query (`WHERE id = '${ticketId}'`) → SQL injection. Baris `ticket_rating` sendiri sudah memakai prepared statement. Lihat Known Issues.

### Admin Report (`modules/admin-report`)
| Method | Endpoint | Keterangan |
|---|---|---|
| GET | `/api/adminReport/task` | Rekap task closed (`ticketStatusId >= 900`, tipe 1) |
| GET | `/api/adminReport/task/detail` | Detail rekap task |
| GET | `/api/adminReport/case` | Rekap case closed (tipe 2) |
| GET | `/api/adminReport/case/detail` | Detail rekap case |
| GET | `/api/adminReport/cr` | Rekap CR closed (tipe 3) |
| GET | `/api/adminReport/cr/detail` | Detail rekap CR |

> ⚠️ Prefix memakai camelCase: **`/api/adminReport`** (bukan `/api/admin-report`).
> Filter yang didukung: `projectId`, `keyword`, `startDate`, `endDate`.
> ⚠️ Query memakai interpolasi `pu.userId = '${filters.userId}'` (3 tempat, ~baris 73/151/229). Nilainya berasal dari token (`req.user.id`), jadi belum bisa dieksploitasi dari input user — tapi pola ini **harus** diganti prepared statement sebelum ada filter `userId` yang berasal dari query string.
> ⚠️ Ketiga endpoint `*/detail` menunjuk ke **controller function yang sama** (`ticketDetail`) — kemungkinan belum membedakan tipe.

### Verification (`modules/verification`)
| Method | Endpoint | Keterangan |
|---|---|---|
| GET | `/api/verification` | Antrean verifikasi client: `ticketStatusId = 400`, `ticketTypeId = 2` |
| GET | `/api/verification/:id` | Detail case + rating + activity log (per-log attachment) + related tasks |
| PUT | `/api/verification/:id/status` | Close (`ticketStatusId = 900`) / Cancel (`990`) satu case |
| PUT | `/api/verification/bulk-status` | Update status banyak case sekaligus ("Update All Selected") |

> Filter yang didukung (list): `keyword`, `clientId`, `startDate`, `endDate`.
> Response `/:id` berbentuk `{ detail, rating, activities, tasks }` — sama dengan `adminReport/*/detail`.
> `activities[].attachment` dikelompokkan per `ticketLogId` (bukan per `ticketId` seperti `adminReport`).
>
> **Body `PUT /:id/status`** (wajib): `{ "action": "close" }` atau `{ "action": "cancel" }`.
> - `action` selain itu → `400`.
> - Hanya case yang **masih** `ticketStatusId = 400` yang bisa diproses → selain itu `404` (anti double-process).
> - `close` mengisi `actualCompletionDate = NOW()` + insert `ticket_balance` (potong saldo).
> - `cancel` **tidak** mengisi `actualCompletionDate` dan **tidak** menyentuh `ticket_balance`.
> - Keduanya menandai `ticket_logs` dengan `inputBySystem = 1`.
> - Semua langkah dalam satu transaction (lock `FOR UPDATE` + `rollback` bila gagal).
>
> Module untuk access right: `5106` — `Case Verification` (butuh permission `u` untuk aksi ini).
>
> **Body `PUT /bulk-status`** (wajib): `{ "ids": ["IS000001", "IS000002"], "action": 900 }`.
> - `action` menerima **id status** (`900` / `990`) **atau** string (`"close"` / `"cancel"`).
> - `ids` wajib array non-kosong, divalidasi max `200` item, didedup otomatis.
> - `ids` bukan array / kosong → `400`.
> - Semua case diproses dalam **SATU transaction** dengan `FOR UPDATE` di semua baris terpilih.
>   Bila satu baris gagal → **seluruhnya rollback** (tidak ada update setengah jalan).
> - Case yang tidak lagi `ticketStatusId = 400` (mis. sudah diproses user lain) **dilewati**,
>   bukan error — dikembalikan di `skippedIds`.
> - Response: `{ ticketStatusId, ticketStatusName, total, updated, updatedIds[], skippedIds[] }`.
> - ⚠️ Route `/bulk-status` **wajib didaftarkan sebelum `/:id`** agar tidak tertangkap sbg `id = "bulk"`.

### Client Ticket — Staff (`modules/client-ticket`)
| Method | Endpoint | Keterangan |
|---|---|---|
| GET | `/api/client-ticket/cases` | List case ringkas (scoped `project_contact`) |
| GET | `/api/client-ticket/change-requests` | List CR ringkas (scoped `project_contact`) |
| GET | `/api/client-ticket/balance/client/:projectId` | Saldo project + `note` bila minus |

> Scoping: `project_contact WHERE userId = ? AND presence = 1` di-`INNER JOIN` dengan `project`.
> Filter tambahan: `keyword` (id/title/crNoRef/issueNo).
> ⚠️ **BUG (SQL Injection)**: `getClientBalance` menyisipkan `projectId` langsung ke string query (`WHERE projectId = '${projectId}'`) tanpa binding parameter, **dan** mencetak query ke `console.log`. **Wajib diperbaiki** sebelum dipakai di produksi.
> ⚠️ Endpoint saldo ini **tidak** memvalidasi `project_contact` — padanan yang aman ada di `/api/client-portal/ticket-balance/project/:projectId`.
> Modul ini **duplikat** dari `modules-clients/client-ticket` (versi portal memakai prepared statement).

### Attendance (`modules/attendance`)
| Method | Endpoint | Keterangan |
|---|---|---|
| GET | `/api/attendance` | List rekap attendance (filter `userId`, `workDateFrom`, `workDateTo`, `keyword`) |
| GET | `/api/attendance/summary` | ⚠️ **Dashboard harian live** — `kpi` (`totalEmployees`, `checkedInToday`, `lateArrivals`, `notCheckedInToday`, `missingCheckOut`, `avgWorkHoursPerDay`), `trend`, `locations`, `needsAttention`, `today` |
| GET | `/api/attendance/dashboard` | ⚠️ **Rekap bulanan** per karyawan — `month`, `periodLabel`, `workingDays`, `employees[]` (present/late/absent/missingOut/totalHours/avgPerDay/rate), `totals`. Filter `month` format `YYYY-MM` |
| GET | `/api/attendance/status` | Status check-in user login (`{ checkedIn, record, lastRecord }`) |
| GET | `/api/attendance/my` | Riwayat attendance user login (limit 60) |
| POST | `/api/attendance/check-in` | Check-in (body `lng`/`lat`, `address`; IP & user-agent auto dari request) |
| PUT | `/api/attendance/check-out` | Check-out (body sama seperti check-in) |

```json
// POST /api/attendance/check-in
{ "lng": 106.798959, "lat": -6.201907, "address": "Kantor Utama" }
```

> ⚠️ **Nama route tertukar dari intuisi**: `/attendance/summary` = **dashboard harian live**, sedangkan `/attendance/dashboard` = **rekap bulanan**. Jangan bingung saat menambah/membaca fitur.
> ⚠️ `check-in` menolak (400 `You are already checked in...`) bila masih ada check-in terbuka; `check-out` menolak (400 `You have not checked in yet.`) bila tidak ada check-in terbuka. Satu check-out hanya menutup record check-in **terakhir** yang masih terbuka.
> ⚠️ Ambang telat & jam normal pulang hard-coded di `attendance.service.js`: `LATE_THRESHOLD = '08:15:00'`, `END_HOURS = '17:00:00'`.

### Checklist (`modules/checklist`)
| Method | Endpoint | Keterangan |
|---|---|---|
| GET | `/api/checklist/:ticketId` | List checklist item milik ticket |
| POST | `/api/checklist` | Create item (`ticketId`, `description`; `ticketChecklistId` = 0 root / >0 sub-item) |
| PUT | `/api/checklist/reorder` | Simpan urutan (`items[]` berisi `id` + `sorting`) — ⚠️ daftar **sebelum** `/:id` |
| PUT | `/api/checklist/:id` | Update item (`description`, `status`, `sorting`) |
| DELETE | `/api/checklist/:id` | Soft delete item + cascade sub-item (`ticketChecklistId`) |

> Tabel **`ticket_checklist`** di-auto-create via `checklist.service.js` → `ensureChecklistTable()`; DDL-nya juga sudah ada di `master-table.sql`.

### Home (`modules/home`)
| Method | Endpoint | Keterangan |
|---|---|---|
| GET | `/api/home` | Dashboard kanban user login (`tasks`, `cases`, `changeRequests` + total open per tipe) |
| GET | `/api/home/users` | Daftar user untuk filter assignee |
| PUT | `/api/home/sorting` | Simpan urutan kanban (body `ticketTypeId` + `ids[]`) |

---

## Client Portal (`/api/client-portal/*`)

API terpisah untuk aplikasi **client** (`ng18-client`). Semua route berada di `modules-clients/` dan dimount dengan prefix `/api/client-portal`, memakai **`authMiddleware` yang sama** dengan API staff (`middlewares/auth.js`) — tidak ada middleware khusus client dan **tidak ada pengecekan `userTypeId`**.

| Prefix | Modul | Fungsi |
|---|---|---|
| `/api/client-portal/cases` | `modules-clients/cases` | Case (`ticketTypeId = 2`) milik client |
| `/api/client-portal/change-requests` | `modules-clients/change-requests` | CR (`ticketTypeId = 3`) milik client |
| `/api/client-portal/projects` | `modules-clients/projects` | Project yang terhubung ke client |
| `/api/client-portal/client-ticket` | `modules-clients/client-ticket` | List case/CR ringkas + saldo |
| `/api/client-portal/rating` | `modules-clients/rating` | Master rating + submit rating |
| `/api/client-portal/ticket-balance` | `modules-clients/ticket-balance` | Mutasi saldo per project |
| `/api/client-portal/master` | `modules-clients/master` | Status case + ticket severity |
| `/api/client-portal/ticket-categories` | `modules-clients/ticket-categories` | Kategori ticket (parent → children) |

### Scoping & Auth (WAJIB dipahami)

- Actor **selalu** diambil dari token: `req.user.id` lewat `getUserId(req)` di setiap controller. `userId` dari query/body ditimpa, bukan dipercaya.
- Hampir semua query list memakai subquery `INNER JOIN`:
  ```sql
  SELECT c.userId, c.projectId, p.name AS name
  FROM project_contact AS c
  LEFT JOIN project AS p ON p.id = c.projectId
  WHERE c.userId = ? AND p.presence = 1 AND c.presence = 1
  ```
  Artinya client **hanya** melihat data project tempat ia terdaftar di `project_contact` (`userId` + `projectId` + `presence = 1`) **dan** project tersebut belum soft-delete.
- Detail project & mutasi saldo memakai `canClientAccessProject(projectId, userId)` → `403 Forbidden` bila tidak ada baris `project_contact`.
  ```sql
  SELECT 1 FROM project_contact
  WHERE presence = 1 AND projectId = ? AND userId = ? LIMIT 1
  ```
  ⚠️ Fungsi ini **tidak** mengecek `project.presence`, jadi project yang sudah soft-delete masih lolos cek akses (detail-nya tetap bisa dibaca). List tetap aman karena memfilter `p.presence = 1`.
- ⚠️ **Tidak ada guard `userTypeId`**: token staff juga sah untuk `/api/client-portal/*`, dan token client juga sah untuk `/api/*`. Isolasi staff vs client saat ini bergantung pada UI, **bukan** server.
- ⚠️ Di mode non-production, `middlewares/auth.js` **meloloskan** request yang token-nya tidak valid (`req.user` bisa `undefined`). Akibatnya `userId` jadi `''` dan list mengembalikan array kosong (bukan 401).

### Case — Client Portal (`modules-clients/cases`)
| Method | Endpoint | Keterangan |
|---|---|---|
| GET | `/api/client-portal/cases` | Case **aktif** (`ticketStatusId <= 900`, `ticketTypeId = 2`), filter `keyword` |
| GET | `/api/client-portal/cases/closed` | Case **selesai** (`ticketStatusId >= 900`) + `rating`/`ratesBy` — ⚠️ daftar **sebelum** `/:id` |
| GET | `/api/client-portal/cases/:id` | Detail case (cek `project_contact`, `403` bila bukan miliknya) |
| GET | `/api/client-portal/cases/:id/logs` | `ticket_logs` + `ticket_logs_attachments` — ⚠️ **tanpa cek akses** (IDOR) |
| POST | `/api/client-portal/cases` | Create case (`ticketTypeId = 2`, `submitBy` dari token) |
| PUT | `/api/client-portal/cases/:id/status` | Ubah status dari sisi client (body `ticketStatusId`) |

> Body `POST` (divalidasi `normalizeCreatePayload`): `title`, `projectId` (**wajib**), opsional `description`, `submitDate`, `targetCompletionDate`, `deadlineDateTime`, `actualCompletionDate`, `assignTo`, `ticketStatusId` (default `1`), `ticketCategoryId`, `severityId` (alias `ticketSeverityId`), `productChildId`, `taskSolution`, dan `id` (bila kosong → `runningNumber('issue')`).
> - Tanggal menerima `YYYY-MM-DD`, `YYYY-MM-DD HH:mm[:ss]`, `YYYY-MM-DDTHH:mm[:ss]` (dipakai frontend), ISO, atau `Date`; semuanya dinormalisasi ke `YYYY-MM-DD HH:mm:ss` (`normalizeDateTime`). Bila kosong: `submitDate = NOW()`, lalu `targetCompletionDate` / `deadlineDateTime` / `actualCompletionDate` mengikuti nilai sebelumnya (`targetCompletionDate` → `deadlineDateTime` → `actualCompletionDate`).
> - `submitBy` **selalu** diambil dari token (body diabaikan); `inputBy`/`updateBy` juga memakai actor token, bukan hard-code `'1'`.
> - Akses dicek ke `project_contact` (`userId` + `projectId` + `presence = 1`, `project.presence = 1`) → `403 Forbidden` bila client bukan anggota project.
> - `assignTo` divalidasi ke `project_users` project tersebut; bila kosong/tidak cocok → fallback manager (`asManager = 1`) lalu member pertama; bila project belum punya user → `'0'`.
> - Kolom `ticket` yang NOT NULL tanpa default diisi eksplisit: `ticketCategoryId`/`ticketSeverityId` = `0` bila kosong, `productChildId`/`taskSolution` = `''`, `rating`/`ticketEstimationCost`/`hours`/`actualWorkingHour` = `0`, `presence` = `1`.
> ⚠️ `PUT /:id/status` **tidak mengecek** `project_contact`: siapa pun yang punya token bisa mengubah case apa pun bila tahu `id`. Status `>= 900 && < 990` **memicu potong saldo** otomatis (`INSERT INTO ticket_balance`, `ticketOut = ticketEstimationCost`).

### Change Request — Client Portal (`modules-clients/change-requests`)
Struktur **identik** dengan Case di atas, hanya `ticketTypeId = 3`.

| Method | Endpoint | Keterangan |
|---|---|---|
| GET | `/api/client-portal/change-requests` | CR aktif (`ticketStatusId <= 900`), filter `keyword` |
| GET | `/api/client-portal/change-requests/closed` | CR selesai (`ticketStatusId >= 900`) — ⚠️ daftar **sebelum** `/:id` |
| GET | `/api/client-portal/change-requests/:id` | Detail CR (cek `project_contact`) |
| GET | `/api/client-portal/change-requests/:id/logs` | Log CR — ⚠️ **tanpa cek akses** |
| POST | `/api/client-portal/change-requests` | Create CR (`ticketTypeId = 3`, `submitBy` dari token) |
| PUT | `/api/client-portal/change-requests/:id/status` | Ubah status + potong saldo bila `>= 900` |

> Body `POST` mengikuti aturan Case di atas (`normalizeCreatePayload` + `normalizeDateTime` + `assertProjectAccess` + `resolveAssignee`), dengan perbedaan: ID memakai `runningNumber('cr')` (`CR######`), `ticketTypeId = 3`, dan **CR tidak punya severity** — `severityId` opsional dan default `0`. Field `ticketSeverityId` juga diterima sebagai alias.


### Project — Client Portal (`modules-clients/projects`)
| Method | Endpoint | Keterangan |
|---|---|---|
| GET | `/api/client-portal/projects` | Project milik client (`presence = 1` + `INNER JOIN project_contact`), filter `status`, `keyword` (id/name/client name). Response menyertakan `ticketBalance` per project + member internal (`project_users`) |
| GET | `/api/client-portal/projects/detail/:id` | Detail project (cek `canClientAccessProject` → `403`) |
| GET | `/api/client-portal/projects/:id` | **Alias** detail — didaftarkan setelah `detail/:id`, perilaku sama |

> ⚠️ `GET /api/client-portal/projects/:id` **hanya bisa** diakses lewat `detail/:id`; path `:id` di route kedua praktis tidak pernah tercapai karena `detail/:id` sudah menangkap `/detail/xxx` lebih dulu. Jangan hapus salah satunya tanpa mengecek client.
> Detail mengembalikan header project + `project_contact` (via `p.presence = 1 AND p.projectId = ?`) — **bukan** seluruh isi template/task.

### Client Ticket — Client Portal (`modules-clients/client-ticket`)
| Method | Endpoint | Keterangan |
|---|---|---|
| GET | `/api/client-portal/client-ticket/cases` | List case ringkas (`ticketTypeId = 2`), scoped `project_contact`, filter `keyword` |
| GET | `/api/client-portal/client-ticket/change-requests` | List CR ringkas (`ticketTypeId = 3`) |
| GET | `/api/client-portal/client-ticket/balance/client/:projectId` | Saldo project (`SUM(ticketIn - ticketOut)`) + `note` bila minus — ⚠️ **tanpa cek akses project** |

> ⚠️ Berbeda dengan `modules/client-ticket` (staff), versi portal ini memakai **prepared statement** (`WHERE projectId = ?`) sehingga tidak ada SQL injection di sini.
> ⚠️ Tetap ada celah otorisasi: `getClientBalance` tidak memanggil `canClientAccessProject`, jadi `projectId` mana pun bisa dibaca. Gunakan `/api/client-portal/ticket-balance/project/:projectId` bila butuh versi yang ter-scope.

### Ticket Balance — Client Portal (`modules-clients/ticket-balance`)
| Method | Endpoint | Keterangan |
|---|---|---|
| GET | `/api/client-portal/ticket-balance/project/:projectId` | Mutasi saldo project (max 100 baris, urut `date ASC`, lalu dibalik) + kolom `balance` berjalan |

> `projectId` divalidasi `assertProjectId` (400 bila kosong) dan **wajib** lolos `canClientAccessProject` (403).
> Kolom `balance` dihitung di JavaScript (running sum dari `ticketIn - ticketOut`), bukan dari DB — `0 as balance` di SQL hanya placeholder.

### Rating — Client Portal (`modules-clients/rating`)
| Method | Endpoint | Keterangan |
|---|---|---|
| GET | `/api/client-portal/rating/master` | List `rating` (`presence = 1`), filter `status` |
| POST | `/api/client-portal/rating/rate` | Submit rating: update `ticket.rating` + `ratesBy`, lalu insert baris `ticket_rating` per pertanyaan |

```json
// POST /api/client-portal/rating/rate
{ "ticketId": "CASE-0001", "averageRating": 4.5, "ratings": [{ "questionId": 1, "rating": 5 }] }
```

> ⚠️ `rating` di `ticket` diisi `averageRating` dari body **apa adanya** (tidak dihitung server), dan `ratesBy` diisi `req.user.id`.
> ⚠️ Tidak ada validasi bahwa ticket benar-benar milik client dan tidak ada cek duplikat — submit berulang akan menambah `ticket_rating` baru.

### Master — Client Portal (`modules-clients/master`)
| Method | Endpoint | Keterangan |
|---|---|---|
| GET | `/api/client-portal/master/status/cases` | `ticket_status` dengan `issues = 1` (`presence = 1`), urut `id` |
| GET | `/api/client-portal/master/ticket-severities` | Seluruh `ticket_severity` (`presence = 1`), urut `id` |

> Read-only, tanpa filter. Padanan staff-nya ada di `/api/master/*` (modul generic).

### Ticket Categories — Client Portal (`modules-clients/ticket-categories`)
| Method | Endpoint | Keterangan |
|---|---|---|
| GET | `/api/client-portal/ticket-categories` | Kategori **root** (`parentId = 0`) + `children[]` (satu level), filter `status`, urut `sorting` |

> Hanya **satu level** anak yang dilampirkan (`parent.children = rows2.filter(...)`); cucu tidak disertakan.

### Perbandingan Client Portal vs API Staff

| Aspek | `/api/*` (staff, `modules/`) | `/api/client-portal/*` (client, `modules-clients/`) |
|---|---|---|
| Sumber actor | `req.user` (jarang dipakai untuk scoping) | `req.user.id` **wajib**, dipakai untuk `project_contact` |
| Guard tipe user | Tidak ada | Tidak ada (celah, lihat Known Issues) |
| Scoping data | Tidak ada (semua data terbuka) | `project_contact` (`userId` + `projectId` + `presence = 1`) |
| Validasi payload | Lebih lengkap (`masterKey`, numeric/date parser) | Lebih longgar; `title`/`projectId`/`ticketStatusId` hanya trim + cast |
| Potong saldo | Di service staff saat status berubah | **Juga** di `updateStatusByClient` (`ticketTypeId` 2 & 3) |
| Template project | Ya (lihat `/api/project/templates*`) | Tidak ada |
| Cek akses detail | Tidak ada | Ada untuk `projects/detail/:id` & `ticket-balance`, **tidak** untuk `cases/:id/logs`, `change-requests/:id/logs`, `*/:id/status`, `client-ticket/balance` |

> ⚠️ **Duplikasi kode**: `modules-clients/cases` ≈ `modules/cases`, `modules-clients/change-requests` ≈ `modules/change-requests`, `modules-clients/client-ticket` ≈ `modules/client-ticket`. Setiap perbaikan logika (terutama potong saldo & aturan status `900`) harus diterapkan di **kedua** tempat, atau ekstrak ke shared service.

---



## Socket.io

Diinisialisasi inline di `server.js` (tidak ada folder `socket/`), dengan `cors.origin = '*'`.

| Event | Direction | Payload | Keterangan |
|---|---|---|---|
| `connected` | Server → Client | `{ status: true, message: 'Socket connected' }` | Dikirim otomatis saat connect |
| `notification` | Client → Server | `{ action: 'reload' }` | Diteruskan **hanya** bila `action === 'reload'` |
| `notification` | Server → Client | `{ action: 'reload' }` | Broadcast ke **semua** client via `io.emit` |

> ⚠️ **Room/project-scoped event belum ada.** Event lama (`ticket:new`, `ticket:updated`, `ticket:comment`, `ticket:assigned`, `join:project`, `leave:project`) **sudah tidak ada di kode** — jangan dokumentasikan sebagai aktif.
> ⚠️ `io.emit` broadcast ke semua client; belum ada filtering per user/project.

---

## Upload File

- Config: `middlewares/upload.middleware.js` (multer, disk storage ke `server/uploads/`).
- Nama file: `${Date.now()}-${Math.round(Math.random() * 1e9)}${ext}`.
- Extension diblokir: `.js`, `.exe`, `.py`, `.php`, `.html`.
- Limit: maks **5 MB** per file, maks **20 file** per request.
- File disajikan statis di **`/api/uploads`** (`PREFIX_SERVER` + `/uploads`, dengan header `Cross-Origin-Resource-Policy: cross-origin`).
- Pemakaian di controller:
  ```js
  const { runMiddleware, upload } = require('../../middlewares/upload.middleware');
  await runMiddleware(req, res, upload.array('files'));
  ```

---

## Known Issues / TODO Prioritas

| Prioritas | Item | Lokasi |
|---|---|---|
| 🔴 Tinggi | **SQL Injection** — `projectId` di-embed langsung ke string query (`WHERE projectId = '${projectId}'`) | `modules/client-ticket/client-ticket.service.js` → `getClientBalance` |
| 🔴 Tinggi | **SQL Injection** — payload di-embed langsung: `name`, `clientId`, `startDate`, `endDate`, `templateMaster`, `ticketBaseHours` pada `INSERT INTO project`; `projectId`/`clientId`/`a.id` pada `addContactToProject` & `removeContactFromProject` | `modules/project/project.service.js` (~632, ~969-987) |
| 🔴 Tinggi | **SQL Injection** — `ticketId` pada `UPDATE ticket ... WHERE id = '${ticketId}'`, `ratesBy`/`updateBy` pada insert `ticket_rating`, `id` pada query `TIMESTAMPDIFF` | `modules/rating/rating.service.js` (~217), `modules/ticket/ticket.service.js` (~458) |
| 🔴 Tinggi | **IDOR** — `GET /:id/logs` tidak memverifikasi `project_contact`; siapa pun yang punya token bisa membaca log case/CR mana pun | `modules-clients/cases`, `modules-clients/change-requests` |
| 🔴 Tinggi | `PUT /:id/status` di portal tidak mengecek kepemilikan case → client bisa menutup case apa pun **dan memicu potong saldo** | `modules-clients/cases`, `modules-clients/change-requests` |
| 🔴 Tinggi | `GET /client-ticket/balance/client/:projectId` tanpa `canClientAccessProject` → saldo project lain bisa dibaca | `modules-clients/client-ticket` |
| 🔴 Tinggi | **Tidak ada guard `userTypeId`** di route staff; blok pengecekan di controller masih di-comment. Token client sah untuk `/api/*` dan token staff sah untuk `/api/client-portal/*` — isolasi hanya di UI | `middlewares/auth.js`, `modules/cases/case.controller.js` (baris ~163) |
| 🔴 Tinggi | `PRODUCTION=false` membuat auth bypass & meloloskan token invalid — pastikan `true` di produksi | `.env`, `middlewares/auth.js` |
| 🟡 Sedang | `canClientAccessProject` tidak memfilter `project.presence = 1` → project soft-deleted masih bisa dibuka via `projects/detail/:id` & `ticket-balance` | `modules-clients/projects/project.service.js` |
| 🟡 Sedang | Duplikasi logika: `cases` ≈ `change-requests` ≈ `modules-clients/cases` ≈ `modules-clients/change-requests`; `client-ticket` ada di dua folder | `modules/*`, `modules-clients/*` |
| 🟡 Sedang | Insert `ticket_balance` untuk potong saldo ada di **7 tempat** dan tidak transaksional → status bisa berubah tanpa log/saldo bila salah satu query gagal: `modules/cases/case.service.js` (2×), `modules/change-requests/change-request.service.js` (2×), `modules-clients/cases/case.service.js`, `modules-clients/change-requests/change-request.service.js`, `modules/verification/verification.service.js` | `modules/*`, `modules-clients/*` |
| 🟡 Sedang | `updateStatusByClient` tidak idempoten: `900 → 400 → 900` memotong saldo **dua kali** | staff & portal, fungsi `updateCaseStatusByClient` |
| 🟡 Sedang | `PUT /api/project/:id` menghapus **permanen** `project_users` (`DELETE FROM project_users`) lalu insert ulang | `modules/project/project.service.js` |
| 🟡 Sedang | `removeContactFromProject` meng-iterasi `for (const a of payload)`, jadi `req.body` **wajib array** (bukan `{ contacts: [...] }`) → body object melempar `TypeError: payload is not iterable` (500). `actorId` ditempel controller sebagai property pada array tersebut | `modules/project/project.service.js`, `project.controller.js` (`removeContact`) |
| 🟡 Sedang | `POST /api/ticket` trusted `submitBy` dari body (bukan token) → aktor bisa dipalsukan; `inputBy`/`updateBy` malah hard-code `'1'` | `modules/ticket/ticket.service.js` (`createTicket` ~298) |
| 🟢 Rendah | ~~Create **CR** di portal menulis `inputBy`/`updateBy = '1'` hard-coded~~ → **sudah diperbaiki**: create case & CR memakai actor token | `modules-clients/change-requests` |
| 🟡 Sedang | `project.clientId` varchar(50) vs `client.id` int(11) | skema DB |
| 🟡 Sedang | masterKey `project-categories` → tabel `project_categories` tidak ada (yang dipakai `ticket_categories`) | `master.service.js` |
| 🟡 Sedang | DDL `template` duplikat (`ensureTemplateTable`) & beda skema dengan `master-table.sql` | `template.service.js` |
| 🟡 Sedang | DDL `ticket_checklist` juga duplikat (`ensureChecklistTable`), sudah ada di `master-table.sql` — jaga agar sinkron | `checklist.service.js` |
| 🟡 Sedang | `ticket_status_logs` didokumentasikan tapi **tidak ada** di DB/DDL dan tidak dipakai kode — jangan dibuat query baru ke tabel ini | `master-table.sql`, `verification.service.js` (komentar) |
| 🟡 Sedang | Belum ada refresh token / token blacklist | `modules/auth` |
| 🟡 Sedang | Nama route attendance tertukar dari intuisi: `/attendance/summary` = dashboard harian, `/attendance/dashboard` = rekap bulanan | `attendance.route.js` |
| 🟢 Rendah | Belum ada unit test (`npm test` masih placeholder) | `package.json` |
| 🟢 Rendah | Belum ada pagination server-side (attendance `list` `LIMIT 1000`, ticket balance `LIMIT 100`) | semua modul list |
| 🟢 Rendah | `.env.example` kurang `PRODUCTION` & `PREFIX_SERVER` | `.env.example` |
| 🟢 Rendah | `addBalance` (`POST /api/ticket-balance`) meng-hard-code `inputBy = 1` — top-up tidak mencatat aktor sebenarnya | `ticket-balance.service.js` |
| 🟢 Rendah | `console.log` debug tersisa di beberapa service/controller | `server.js`, `modules/*`, `modules-clients/*` |
| 🟢 Rendah | `saltRounds = 4` lemah untuk produksi | `user.service.js` |
| 🟢 Rendah | `scripts/seed-attendance.js` belum terdaftar di `package.json` | `package.json` |

---

## Scripts

| Command | Fungsi |
|---|---|
| `npm start` | Jalankan server (`node server.js`) |
| `npm run dev` | Jalankan dengan nodemon |
| `npm run seed:dummy` | Seed data dummy (admin + client demo) |
| `node scripts/seed-attendance.js` | Seed data attendance dummy (~40 baris); **belum** terdaftar di `package.json` |
| `npm test` | **Belum diimplementasikan** (selalu exit 1) |

Dummy login hasil seed:
- Internal: `admin@thinktank.local` / `Admin123!`
- Client: `client.demo@thinktank.local` / `Client123!`

---

## Instruksi Eksekusi AI Agent

1. **Baca dokumen ini dulu** sebelum mengubah kode. Dokumen ini mencerminkan kondisi kode terkini.
2. Ikuti arsitektur 3-layer: SQL hanya di `*.service.js`, validasi `req` hanya di `*.controller.js`, route hanya di `*.route.js`.
3. Saat menambah modul baru, buat 3 file (`*.service.js`, `*.controller.js`, `*.route.js`) di `modules/<nama>/` lalu daftarkan di `server.js` dengan `app.use(\`${PREFIX_SERVER}/<nama>\`, <nama>Routes)`.
4. Gunakan `helpers/response.js` (`success`/`failure`) untuk semua response. Jangan pernah kirim object mentah.
5. Gunakan soft delete (`presence = 0`) dan timestamp `NOW()`. Jangan pernah `DELETE` dari DB.
6. Untuk ID berurutan, pakai `helpers/autoNumber.js` → `runningNumber(name)`. Pastikan row `auto_number` dengan `name` tersebut sudah ada.
7. Saat menambah field pada tabel, **selalu** sinkronkan ke 4 tempat: `*.service.js`, `*.controller.js`, `master-table.sql` (bila tabel master), dan **dokumen ini**.
8. Saat menambah `masterKey` baru, tambahkan entry di `tableMap` (`master.service.js`) lengkap dengan `requiredFields`, `editableFields`, `numericFields`, dan flag `allowCreate/Update/Delete`.
9. Jangan menambahkan key `product`, `project`, atau `project-master` ke generic `/api/master/:masterKey` — semuanya punya modul sendiri.
10. Verifikasi sintaks setelah edit: jalankan `node --check <file>` untuk tiap file JS yang diubah.
11. Jika menemukan ketidaksesuaian antara dokumen dan kode, **perbaiki dokumennya**, bukan hanya kodenya.
12. Jangan pernah commit `.env`, `DB_PASS`, atau `JWT_SECRET` ke dokumentasi.

---

## Referensi Dokumen Terkait

| File | Isi |
|---|---|
| `AI-AGENT/agent-server.md` | Dokumen ini — panduan arsitektur & konvensi backend |
| `AI-AGENT/api-doc.md` | Detail request/response per endpoint |
| `AI-AGENT/description.md` | Deskripsi bisnis aplikasi |
| `AI-AGENT/todo-list-server.md` | Todo list per phase |
| `AI-AGENT/master-table.sql` | DDL + data master & transaksi |
| `AI-AGENT/alterTable.sql` | DDL tambahan (`ticket_solution_time` + modul `7001 Attendance`) |
| `AI-AGENT/flowchard.drawio` | Diagram alur (CASES / TASK) |
| `server/README.md` | README ringkas backend |
