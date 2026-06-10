# Agent: Server Builder — Thinktank Ticketing System

## Current Scope (Tahap Sekarang)
- Fokus implementasi: LOGIN + MASTER DATA saja.
- Source master data: tabel existing dari `master-table.sql`.
- Modul transaksi ticket (ticket, detail, comment, attachment, socket realtime) ditunda ke tahap berikutnya.

## Tech Stack
- Runtime: Node.js
- Framework: Express.js
- Realtime: Socket.io
- Database: MySQL (mysql2 package)
- Auth: JWT (jsonwebtoken)
- Password: bcryptjs
- Env: dotenv
- Middleware: cors, helmet, express-validator

---

## Project Root: `c:\nodejs\8thinktank-ticketing\server`

---

## Folder Structure Target

```
server/
├── config/
│   ├── db.js                  # MySQL connection pool
├── middlewares/
│   ├── auth.js                # JWT verify middleware
│   ├── accessControl.js       # Role/module access check
│   └── errorHandler.js        # Global error handler
├── helpers/
│   ├── autoNumber.js          # Generate auto number (from auto_number table)
│   └── response.js            # Standar response wrapper {status, message, data}
├── modules/
│   ├── auth/
│   │   ├── auth.route.js
│   │   ├── auth.controller.js
│   │   └── auth.service.js
│   ├── user/
│   │   ├── user.route.js
│   │   ├── user.controller.js
│   │   └── user.service.js
│   ├── client/
│   │   ├── client.route.js
│   │   ├── client.controller.js
│   │   └── client.service.js
│   ├── project/
│   │   ├── project.route.js
│   │   ├── project.controller.js
│   │   └── project.service.js
│   ├── ticket/
│   │   ├── ticket.route.js
│   │   ├── ticket.controller.js
│   │   └── ticket.service.js
│   ├── ticket-balance/
│   │   ├── ticket-balance.route.js
│   │   ├── ticket-balance.controller.js
│   │   └── ticket-balance.service.js
│   └── master/
│       ├── master.route.js        # industry, product, project_type, project_billeable, project_categories
│       ├── master.controller.js
│       └── master.service.js
├── socket/
│   ├── index.js               # Socket.io init & namespace
│   └── ticket.socket.js       # Realtime events untuk ticket
├── .env
├── .env.example
├── package.json
└── server.js                  # Single entry: Express app setup + HTTP server + Socket.io bind
```

---

## Database: Tabel Transaksi yang Perlu Dibuat

Catatan: DDL tabel dibuat langsung di database MySQL (manual), tidak disimpan sebagai file SQL di project.

### `ticket`
Header ticket / case utama
- id (varchar, auto_number)
- projectId (varchar FK → project.id)
- clientId (int FK → client.id)
- title (varchar 500)
- description (text)
- priorityId (tinyint) — 1:Low, 2:Medium, 3:High, 4:Critical
- statusId (tinyint) — 1:Open, 2:In Progress, 3:Pending, 4:Resolved, 5:Closed
- categoryId (int FK → project_categories.id)
- ticketUsed (decimal) — jumlah ticket terpakai
- assignedTo (varchar FK → user.id)
- openDate (datetime)
- closeDate (datetime)
- presence, inputDate, inputBy, updateDate, updateBy

### `ticket_detail`
History/activity log per ticket
- id (int AI)
- ticketId (varchar FK → ticket.id)
- activityDate (datetime)
- description (text)
- hoursSpent (decimal)
- ticketUsed (decimal)
- statusId (tinyint) — status setelah aktivitas ini
- userId (varchar FK → user.id)
- presence, inputDate, inputBy, updateDate, updateBy

### `ticket_comment`
Komentar/diskusi per ticket (bisa dari client maupun internal)
- id (int AI)
- ticketId (varchar FK → ticket.id)
- comment (text)
- userId (varchar FK → user.id)
- presence, inputDate, inputBy, updateDate, updateBy

### `ticket_attachment`
File attachment per ticket / per detail
- id (int AI)
- ticketId (varchar FK → ticket.id)
- ticketDetailId (int, nullable)
- fileName (varchar 250)
- filePath (varchar 500)
- fileSize (int)
- mimeType (varchar 100)
- presence, inputDate, inputBy, updateDate, updateBy

### `module`
Untuk user_access_right.moduleId
- id (int AI)
- name (varchar 100)
- code (varchar 50)
- presence, inputDate, inputBy, updateDate, updateBy

---

## API Endpoints

### Auth
| Method | Endpoint | Keterangan |
|--------|----------|------------|
| POST | /api/auth/login | Login, return JWT |
| POST | /api/auth/logout | Invalidate token |
| GET | /api/auth/me | Get current user info |

### Master Data
| Method | Endpoint | Keterangan |
|--------|----------|------------|
| GET | /api/master/industry | List industry |
| GET | /api/master/product | List product |
| GET | /api/master/project-type | List project type |
| GET | /api/master/project-billeable | List project billeable |
| GET | /api/master/project-categories | List project categories |
| GET | /api/master/user-auth-level | List auth level |

### User
| Method | Endpoint | Keterangan |
|--------|----------|------------|
| GET | /api/user | List all users |
| GET | /api/user/:id | Detail user |
| POST | /api/user | Create user |
| PUT | /api/user/:id | Update user |
| DELETE | /api/user/:id | Soft delete (presence=0) |

### Client
| Method | Endpoint | Keterangan |
|--------|----------|------------|
| GET | /api/client | List clients |
| GET | /api/client/:id | Detail client |
| POST | /api/client | Create client |
| PUT | /api/client/:id | Update client |
| DELETE | /api/client/:id | Soft delete |

### Project
| Method | Endpoint | Keterangan |
|--------|----------|------------|
| GET | /api/project | List projects |
| GET | /api/project/:id | Detail project |
| POST | /api/project | Create project |
| PUT | /api/project/:id | Update project |
| DELETE | /api/project/:id | Soft delete |

### Ticket Balance
| Method | Endpoint | Keterangan |
|--------|----------|------------|
| GET | /api/ticket-balance/project/:projectId | Saldo per project |
| POST | /api/ticket-balance | Top up ticket |
| GET | /api/ticket-balance/summary/:projectId | Rekap ticketIn vs ticketOut |

### Ticket
| Method | Endpoint | Keterangan |
|--------|----------|------------|
| GET | /api/ticket | List tickets (filter by project/client/status) |
| GET | /api/ticket/:id | Detail ticket |
| POST | /api/ticket | Buat ticket baru |
| PUT | /api/ticket/:id | Update ticket |
| DELETE | /api/ticket/:id | Soft delete |
| POST | /api/ticket/:id/detail | Tambah aktivitas/history |
| GET | /api/ticket/:id/detail | List aktivitas ticket |
| POST | /api/ticket/:id/comment | Tambah komentar |
| GET | /api/ticket/:id/comment | List komentar |
| POST | /api/ticket/:id/attachment | Upload file |
| GET | /api/ticket/:id/attachment | List attachment |

---

## Socket.io Events

| Event | Direction | Keterangan |
|-------|-----------|------------|
| `ticket:new` | Server → Client | Ada ticket baru |
| `ticket:updated` | Server → Client | Status ticket berubah |
| `ticket:comment` | Server → Client | Komentar baru masuk |
| `ticket:assigned` | Server → Client | Ticket di-assign ke user |
| `join:project` | Client → Server | Subscribe ke room project |
| `leave:project` | Client → Server | Unsubscribe dari room project |

---

## Konvensi Kode

- Semua response pakai wrapper: `{ status: true/false, message: '', data: null }`
- Soft delete: set `presence = 0`, jangan DELETE dari DB
- Auto number: gunakan helper `autoNumber.js` dengan tabel `auto_number`
- Error handling: semua async pakai try/catch → forward ke `errorHandler` middleware
- JWT payload: `{ id, email, authlevelId, clientId, userType }`
- Password: bcrypt hash dengan saltRounds = 4
- Config env: baca langsung dari `.env` menggunakan `dotenv.config()` (tanpa `config/env.js`)
- Semua timestamp: `inputDate`, `updateDate` pakai `NOW()` dari MySQL

---

## Fix Database yang Diperlukan

1. Tabel `user` tambah field `userTypeId` (FK → user_type.id)
2. Tabel `project` ubah `clientId` dari `varchar(50)` ke `int(11)` agar sesuai dengan `client.id`
3. Buat tabel `module` untuk referensi `user_access_right.moduleId`
