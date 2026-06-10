# Todo List — Server Backend

Scope dokumen ini: fokus tahap awal hanya LOGIN + MASTER DATA dari tabel existing di `master-table.sql`.

## Phase 1: Setup & Foundation

- [ ] **1.1** Init project — `npm init`, install dependencies:
  - express, mysql2, socket.io, jsonwebtoken, bcryptjs, dotenv, cors, helmet, express-validator, multer, uuid
  - devDependencies: nodemon

- [ ] **1.2** Buat file `.env` dan `.env.example`
  ```
  PORT=3000
  DB_HOST=localhost
  DB_PORT=3306
  DB_NAME=thinktank-ticket
  DB_USER=root
  DB_PASS=
  JWT_SECRET=
  JWT_EXPIRES_IN=8h
  UPLOAD_PATH=./uploads
  ```

- [ ] **1.3** Buat `config/db.js` — MySQL connection pool (mysql2)

- [ ] **1.4** Buat `server.js` (single entry)
  - Express setup (cors, helmet, json parser, routes)
  - HTTP server + Socket.io bind
  - Load env langsung dari `.env` via `dotenv.config()`

- [ ] **1.5** Buat `helpers/response.js` — standar response wrapper

- [ ] **1.6** Buat `middlewares/errorHandler.js` — global error handler

---

## Phase 2: Database Existing (Master Data)

- [ ] **2.1** Import / pastikan `master-table.sql` sudah terpasang di MySQL

- [ ] **2.2** Validasi data minimum untuk login:
  - Tabel `user` ada minimal 1 user aktif (`status=1`, `presence=1`)
  - Password user tersimpan hash bcrypt
  - `authlevelId` user terisi

- [ ] **2.3** Validasi tabel master yang akan dipakai API:
  - `industry`, `product`, `project_type`, `project_billeable`, `project_categories`, `user_auth_level`, `user_type`, `global_setting`

---

## Phase 3: Auth Module

- [ ] **3.1** Buat `modules/auth/auth.service.js`
  - `login(email, password)` — cek user, compare bcrypt, return JWT
  - `getMe(userId)` — return user info dari token

- [ ] **3.2** Buat `modules/auth/auth.controller.js`
  - `POST /api/auth/login`
  - `GET /api/auth/me`

- [ ] **3.3** Buat `middlewares/auth.js` — verify JWT, attach `req.user`

- [ ] **3.4** Buat `modules/auth/auth.route.js` — register routes

---

## Phase 4: Master Data Module

- [ ] **4.1** Buat `modules/master/master.service.js`
  - getIndustry, getProduct, getProjectType, getProjectBilleable, getProjectCategories, getUserAuthLevel

- [ ] **4.2** Buat `modules/master/master.controller.js` + `master.route.js`
  - `GET /api/master/industry`
  - `GET /api/master/product`
  - `GET /api/master/project-type`
  - `GET /api/master/project-billeable`
  - `GET /api/master/project-categories`
  - `GET /api/master/user-auth-level`

- [ ] **4.3** Tambah endpoint master pelengkap dari tabel existing:
  - `GET /api/master/user-type`
  - `GET /api/master/global-setting`

- [ ] **4.4** Tambah filter standar di semua endpoint master:
  - hanya data `presence=1`
  - optional query `status=1` untuk tabel yang punya kolom `status`

---

## Phase 5: Testing Login + Master Data

- [ ] **5.1** Test auth endpoint:
  - `POST /api/auth/login`
  - `GET /api/auth/me`

- [ ] **5.2** Test semua endpoint master data (read-only)

- [ ] **5.3** Validasi response konsisten:
  - `{ status, message, data }`

- [ ] **5.4** Validasi unauthorized request ke endpoint protected → `401`

---

## Out of Scope (Tahap Berikutnya)

- [ ] Modul User CRUD
- [ ] Modul Client CRUD
- [ ] Modul Project CRUD
- [ ] Modul Ticket Balance
- [ ] Modul Ticket (core, detail, comment, attachment)
- [ ] Socket.io realtime events
- [ ] Attachment upload/download

---

## Catatan Implementasi Login

- Login menggunakan tabel `user` existing.
- Password wajib bcrypt hash.
- JWT payload minimal: `{ id, email, authlevelId, clientId }`.
- Tidak ada perubahan skema database untuk tahap awal ini.

---

## Referensi Tabel Master (Existing)

- `industry`
- `product`
- `project_type`
- `project_billeable`
- `project_categories`
- `user_auth_level`
- `user_type`
- `global_setting`

---

## Catatan Penting

| Item | Nilai |
|------|-------|
| Scope Saat Ini | Login + Master Data only |
| Source Master Data | `master-table.sql` (existing) |
| Soft Delete | Set `presence = 0` |
| Response Format | `{ status: bool, message: string, data: any }` |
| JWT Payload | `{ id, name, email, authlevelId, clientId }` |
| Password Hash | bcrypt, saltRounds = 4 |
