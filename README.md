# Thinktank Ticketing - Server API

Backend API untuk aplikasi ticketing support dan implementasi ERP/SAP.

Project ini dibangun untuk:
- Login user internal dan client
- Kelola master data (industry, product, project type, dll)
- Kelola data operasional awal (client, project, user)
- Kelola ticket balance per project

Database menggunakan MySQL/MariaDB dengan struktur dasar pada file AI-AGENT/master-table.sql.

## Tech Stack

- Node.js
- Express.js
- MySQL (mysql2)
- JWT (jsonwebtoken)
- bcryptjs
- dotenv
- Socket.io (fondasi sudah ada, realtime event belum dipakai untuk modul ticket)

## Status Implementasi Saat Ini

Sudah selesai:
- Auth API (login, me)
- Master Data API (list/detail/create/update/delete)
- Batasan khusus global_setting: update only
- Client CRUD (soft delete)
- Project CRUD (soft delete)
- User CRUD (soft delete)
- Ticket Balance API (list per project, summary, create transaction)

Belum dikerjakan:
- Modul Ticket (core/detail/comment/attachment)
- Socket.io realtime event untuk ticket
- Attachment upload/download untuk ticket

## Konvensi Umum API

- Semua endpoint (kecuali login) pakai Authorization Bearer token.
- Response format konsisten:

```json
{
	"status": true,
	"message": "...",
	"data": {}
}
```

- Soft delete menggunakan kolom presence = 0 (bukan hard delete).

## Endpoint Ringkas

### Auth
- POST /api/auth/login
- GET /api/auth/me

### Master Data
- GET /api/master/:masterKey
- GET /api/master/:masterKey/:id
- POST /api/master/:masterKey
- PUT /api/master/:masterKey/:id
- DELETE /api/master/:masterKey/:id

Catatan masterKey yang didukung:
- industry
- product
- project-type / project_type
- project-billeable / project_billeable
- project-categories / project_categories
- user-auth-level
- user-type
- global-setting / global_setting

Catatan khusus:
- global_setting hanya bisa UPDATE
- POST/DELETE global_setting akan return 405

### Client
- GET /api/client
- GET /api/client/:id
- POST /api/client
- PUT /api/client/:id
- DELETE /api/client/:id

### Project
- GET /api/project
- GET /api/project/:id
- POST /api/project
- PUT /api/project/:id
- DELETE /api/project/:id

### User
- GET /api/user
- GET /api/user/:id
- POST /api/user
- PUT /api/user/:id
- DELETE /api/user/:id

### Ticket Balance
- GET /api/ticket-balance/project/:projectId
- GET /api/ticket-balance/summary/:projectId
- POST /api/ticket-balance

## Struktur Folder Utama

```text
server/
	config/
		db.js
	helpers/
		response.js
	middlewares/
		auth.js
		errorHandler.js
	modules/
		auth/
		master/
		client/
		project/
		user/
		ticket-balance/
	scripts/
		seed-dummy-data.js
	server.js
```

## Setup Lokal

1. Install dependency

```bash
npm install
```

2. Siapkan file environment

Contoh dari .env.example:

```env
PORT=3000
DB_HOST=127.0.0.1
DB_PORT=3306
DB_NAME=thinktank-ticket
DB_USER=root
DB_PASS=
JWT_SECRET=change-this-secret
JWT_EXPIRES_IN=12h
```

3. Pastikan database master sudah diimport
- gunakan AI-AGENT/master-table.sql

4. Seed dummy data (opsional, untuk test cepat)

```bash
npm run seed:dummy
```

5. Jalankan server

```bash
npm start
```

Mode development:

```bash
npm run dev
```

## Dummy Login (Hasil Seed)

- admin@thinktank.local / Admin123!
- client.demo@thinktank.local / Client123!

## Catatan Penting Schema

- Tabel client.IndustryId bertipe tinyint, validasi API membatasi nilai 0..127.
- Project menggunakan id varchar (bisa manual atau auto-generated PRJ-XXXXXXXX).
- User menggunakan id varchar (bisa manual atau auto-generated USR-XXXXXXXX).

## Dokumentasi Detail API

Dokumentasi detail request/response ada di:
- AI-AGENT/api-doc.md