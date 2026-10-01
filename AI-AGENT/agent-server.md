# Agent: Server Builder — Thinktank Ticketing System

> 📌 **Dokumen ini adalah sumber kebenaran (single source of truth) untuk backend.**
> Terakhir di-sync dengan kode: **30 September 2026** (commit `110ec46` "update master").
> Jika ada perubahan kode, dokumen ini **wajib** di-update pada sesi yang sama.

---

## Current Scope (Tahap Sekarang)

- ✅ **Selesai**: Auth (internal + client), Master Data, Client, Project, User, Ticket Balance.
- ✅ **Selesai**: Modul transaksi **Task / Case / Change Request** + Logs + Status Logs + Rating + Attachment upload.
- ✅ **Selesai**: Modul pendukung — Template, Product Master, Ticket Categories, User Login History, Admin Report, Client Ticket (portal).
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
│   ├── project/                    # CRUD project + contact
│   ├── ticket/                     # Task (ticketTypeId = 1)
│   ├── cases/                      # Case (ticketTypeId = 2)
│   ├── change-requests/            # Change Request (ticketTypeId = 3)
│   ├── ticket-balance/             # Saldo & mutasi ticket
│   ├── rating/                     # Rating master + submit rating
│   ├── template/                   # Template (JSON-based, auto-create table)
│   ├── admin-report/               # Rekap task/case/CR closed
│   ├── client-ticket/              # Portal client: list case/CR + saldo
│   └── user-login-history/         # Riwayat login
├── scripts/
│   └── seed-dummy-data.js          # Seed admin + client demo (npm run seed:dummy)
├── uploads/                        # Hasil multer, disajikan statis di /uploads
├── .env / .env.example
├── app.log                         # Log stdout+stderr (di-intercept di server.js)
└── server.js                       # Single entry: Express + HTTP + Socket.io
```

> **Tidak ada lagi** folder `socket/`, `middlewares/accessControl.js`, atau modul `project-master`.
> Modul `project-master` di-versi lama sudah dipecah menjadi modul `project` + modul `product-master`.


---

## Arsitektur 3-Layer per Modul

Setiap modul `modules/<nama>/` terdiri dari 3 file dengan tanggung jawab tegas:

| File | Isi | Dilarang |
|---|---|---|
| `*.service.js` | Semua query SQL, validasi bisnis, `throw Error` + `error.statusCode` | Tidak boleh menyentuh `req`/`res` |
| `*.controller.js` | Ambil `req.params/query/body`, panggil service, kirim response | Tidak boleh menulis SQL |
| `*.route.js` | Daftar route + middleware | Tidak boleh berisi logika bisnis |

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

### Format ID Otomatis per Modul

| Modul | Sumber ID |
|---|---|
| `ticket` (Task) | `runningNumber('task')` → `TA######` |
| `cases` (Case) | `runningNumber('issue')` → `IS######` |
| `change-requests` (CR) | `runningNumber('cr')` → `CR######` |
| `project` | `PRJ-${randomUUID().split('-')[0].toUpperCase()}` |
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
| `ticket_status` | int AI | `task`, `issues`, `cr` (flag per tipe), `finish`. ⚠️ **Tidak punya `presence`** |
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

#### `project_contact`
```sql
id INT AI PK, clientId VARCHAR(50), projectId VARCHAR(50), userId VARCHAR(100), presence, audit...
```
Tabel penghubung user ↔ project. **Dipakai** modul `client-ticket` untuk menentukan Case/CR mana yang terlihat oleh client.

#### `project_users`
```sql
id INT AI PK, projectId VARCHAR(50), userId VARCHAR(100), asManager TINYINT DEFAULT 0, presence, audit...
```
Menandai user sebagai manager (asManager = 1) sebuah project.


### Tabel Transaksi — Ticket

#### `ticket` (Tabel Tunggal untuk Task/Case/CR)
```sql
id VARCHAR(50) PK,
ticketTypeId INT DEFAULT 0,              -- 1=Task, 2=Case, 3=CR
ticketCategoryId INT NOT NULL,
ticketSeverityId INT NOT NULL,
productChildId VARCHAR(50),
crNoRef VARCHAR(50),                     -- parent CR id (task turunan CR)
issueNo VARCHAR(50),                     -- parent Case id (task turunan Case)
title VARCHAR(250), description TEXT,
projectId VARCHAR(50),
submitBy VARCHAR(50), submitDate DATETIME,
deadlineDateTime DATETIME, targetCompletionDate DATE,
assignTo VARCHAR(50), taskSolution TEXT,
actualCompletionDate DATE,
ticketStatusId INT DEFAULT 0,
rating TINYINT, ratesBy VARCHAR(50),
ticketEstimationCost DOUBLE DEFAULT 0, hours DOUBLE,
presence, audit...
```
> ⚠️ **`description` & `taskSolution` = `NOT NULL` tanpa default** → wajib diisi saat insert.
> ⚠️ `ticketCategoryId` & `ticketSeverityId` **NOT NULL tanpa default** → wajib diisi.
> ⚠️ `targetCompletionDate` & `actualCompletionDate` **NOT NULL tanpa default**.
> ⚠️ `hours` **NOT NULL tanpa default** → kirim `0` bila kosong.
> ⚠️ `deadlineDateTime` default `2026-01-01`; `targetCompletionDate` **tidak punya default** (MariaDB strict mode menolak insert tanpa nilai).
> ⚠️ `inputBy`/`updateBy` bertipe **varchar(50)**.

#### `ticket_logs` (Aktivitas/History)
```sql
id INT AI PK, parentId INT DEFAULT 0, ticketId VARCHAR(50),
starDateTime DATETIME, closeDateTime DATETIME, description TEXT,
presence, inputBySystem TINYINT DEFAULT 0, audit...
```
> ⚠️ Nama kolom **`starDateTime`** (typo "star", bukan "start") — sudah dipakai kode, jangan diubah.

#### `ticket_status_logs`
```sql
id INT UNSIGNED AI PK, ticketId VARCHAR(50), ticketStatusId INT DEFAULT 0,
inputDate DATETIME DEFAULT CURRENT_TIMESTAMP, inputBy VARCHAR(100)
```
> ⚠️ **Tidak punya `presence`**, `updateDate`, maupun `updateBy`.

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

#### `template`
```sql
id INT AI PK, name VARCHAR(250), clientId VARCHAR(250), description VARCHAR(250),
version VARCHAR(250), tempateType VARCHAR(250), json TEXT,
presence, status, audit...
```
> ⚠️ Nama kolom **`tempateType`** (typo, bukan `templateType`).
> ⚠️ `template.service.js` punya `ensureTemplateTable()` yang menjalankan `CREATE TABLE IF NOT EXISTS` dengan skema **berbeda** dari `master-table.sql` (tanpa `clientId`/`status`, charset `utf8mb4_unicode_ci`) dan meng-cache flag di memori modul. Perhatikan ini saat menambah field.

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

---

## API Endpoints

Base URL: `http://127.0.0.1:3000` + `PREFIX_SERVER` (default `/api`).
Health check: `GET /api` → `{ status: true, message: 'Server is running', data: { uptime } }`

> Semua endpoint kecuali `*/login` dilindungi `authMiddleware` (`Authorization: Bearer <token>`).
> ⚠️ Dengan `PRODUCTION=false`, middleware tidak menolak request tanpa token. Selalu tes proteksi dengan `PRODUCTION=true`.

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
| GET | `/api/client` | List clients |
| GET | `/api/client/:id` | Detail client |
| GET | `/api/client/:id/users` | List external user milik client |
| GET | `/api/client/:id/project/:projectId` | List user client yang terkait project |
| GET | `/api/client/:id/projects` | List project milik client |
| POST | `/api/client` | Create client |
| POST | `/api/client/:id/users` | Create external user dari client detail |
| POST | `/api/client/:id/removeProject` | Lepas project dari client |
| PUT | `/api/client/:id` | Update client |
| DELETE | `/api/client/:id` | Soft delete + **cascade** ke external user |

### Project (`modules/project`)
| Method | Endpoint | Keterangan |
|---|---|---|
| GET | `/api/project` | List projects |
| GET | `/api/project/ticketList` | List ticket pada project (filter `projectId`) |
| GET | `/api/project/detail/:id` | Detail project ⚠️ path `detail/:id`, **bukan** `/:id` |
| POST | `/api/project` | Create project |
| POST | `/api/project/contact` | Tambah contact ke project (isi `project_contact`) |
| PUT | `/api/project/contact` | Hapus contact dari project |
| PUT | `/api/project/:id` | Update project |
| DELETE | `/api/project/:id` | Soft delete project |

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
| POST | `/api/user` | Create user (bcrypt hash, saltRounds 4) |
| PUT | `/api/user/:id` | Update user (partial) |
| PUT | `/api/user/:id/password` | Ganti password |
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
| GET | `/api/template` | List template |
| GET | `/api/template/:id` | Detail template |
| POST | `/api/template` | Create template |
| PUT | `/api/template/:id` | Update template |
| DELETE | `/api/template/:id` | Soft delete template |

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
| PUT | `/api/cases/:id/submitRate` | Submit rating |
| DELETE | `/api/cases/:id` | Soft delete case |

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

### Client Ticket — Portal Client (`modules/client-ticket`)
| Method | Endpoint | Keterangan |
|---|---|---|
| GET | `/api/client-ticket/cases` | List case milik client (scoped via `project_contact`) |
| GET | `/api/client-ticket/change-requests` | List CR milik client (scoped via `project_contact`) |
| GET | `/api/client-ticket/balance/client/:projectId` | Saldo client untuk project |

> Scoping: `project_contact WHERE userId = ? AND presence = 1` di-`INNER JOIN` dengan `project`.
> Filter tambahan: `keyword` (id/title/crNoRef/issueNo).
> ⚠️ **BUG (SQL Injection)**: `getClientBalance` menyisipkan `projectId` langsung ke string query tanpa binding parameter. **Wajib diperbaiki** sebelum dipakai di produksi.

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
- File disajikan statis di `/uploads` (dengan header `Cross-Origin-Resource-Policy: cross-origin`).
- Pemakaian di controller:
  ```js
  const { runMiddleware, upload } = require('../../middlewares/upload.middleware');
  await runMiddleware(req, res, upload.array('files'));
  ```

---

## Known Issues / TODO Prioritas

| Prioritas | Item | Lokasi |
|---|---|---|
| 🔴 Tinggi | **SQL Injection** — `projectId` di-embed ke string query | `client-ticket.service.js` → `getClientBalance` |
| 🔴 Tinggi | `PRODUCTION=false` membuat auth bypass — pastikan `true` di produksi | `.env` |
| 🟡 Sedang | Duplikasi logika `cases` vs `change-requests` | kedua modul |
| 🟡 Sedang | `project.clientId` varchar(50) vs `client.id` int(11) | skema DB |
| 🟡 Sedang | masterKey `project-categories` → tabel tidak ada | `master.service.js` |
| 🟡 Sedang | DDL `template` duplikat & tidak sinkron dengan `master-table.sql` | `template.service.js` |
| 🟡 Sedang | Belum ada refresh token / token blacklist | `modules/auth` |
| 🟢 Rendah | Belum ada unit test (`npm test` masih placeholder) | `package.json` |
| 🟢 Rendah | Belum ada pagination server-side | semua modul list |
| 🟢 Rendah | `.env.example` kurang `PRODUCTION` & `PREFIX_SERVER` | `.env.example` |
| 🟢 Rendah | `console.log` debug tersisa di beberapa service/controller | lihat `app.log` |
| 🟢 Rendah | `saltRounds = 4` lemah untuk produksi | `user.service.js` |

---

## Scripts

| Command | Fungsi |
|---|---|
| `npm start` | Jalankan server (`node server.js`) |
| `npm run dev` | Jalankan dengan nodemon |
| `npm run seed:dummy` | Seed data dummy (admin + client demo) |
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
| `AI-AGENT/alterTable.sql` | DDL tambahan (`ticket_solution_time`) |
| `AI-AGENT/flowchard.drawio` | Diagram alur (CASES / TASK) |
| `server/README.md` | README ringkas backend |
