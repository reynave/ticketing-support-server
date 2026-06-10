# API Doc — Login & Master Data

## Base URL

`http://127.0.0.1:3000`

## Response Format

Semua endpoint memakai format response:

```json
{
	"status": true,
	"message": "...",
	"data": {}
}
```

## Dummy Login Sample

### Admin
- Email: `admin@thinktank.local`
- Password: `Admin123!`

### Client Demo
- Email: `client.demo@thinktank.local`
- Password: `Client123!`

## Headers

Untuk endpoint protected, kirim header:

```http
Authorization: Bearer <token>
Content-Type: application/json
```

---

## 1. Login

### POST `/api/auth/login`

Login user dan mendapatkan JWT token.

### Request Body

```json
{
	"email": "admin@thinktank.local",
	"password": "Admin123!"
}
```

### Body Fields

| Field | Type | Required | Description |
|------|------|----------|-------------|
| `email` | string | yes | email user |
| `password` | string | yes | password plaintext |

### Success Response Example

```json
{
	"status": true,
	"message": "Login success",
	"data": {
		"token": "<jwt_token>",
		"user": {
			"id": "USR-ADMIN",
			"name": "System Admin",
			"email": "admin@thinktank.local",
			"authlevelId": 1,
			"clientId": null
		}
	}
}
```

### Error Response

```json
{
	"status": false,
	"message": "Email or password is invalid",
	"data": null
}
```

---

## 2. Current User

### GET `/api/auth/me`

Mengambil data user dari token login.

### Params

Tidak ada.

### Query

Tidak ada.

### Headers

```http
Authorization: Bearer <token>
```

### Success Response Example

```json
{
	"status": true,
	"message": "Current user fetched",
	"data": {
		"id": "USR-ADMIN",
		"name": "System Admin",
		"email": "admin@thinktank.local",
		"authlevelId": 1,
		"clientId": null
	}
}
```

### Error Response

```json
{
	"status": false,
	"message": "Unauthorized",
	"data": null
}
```

---

## 3. Master Data

Semua endpoint master data menggunakan pola:

### GET `/api/master/:masterKey`

### Path Params

| Param | Type | Required | Description |
|------|------|----------|-------------|
| `masterKey` | string | yes | nama master data yang ingin diambil |

### Allowed `masterKey`

| masterKey | Table |
|----------|-------|
| `industry` | `industry` |
| `product` | `product` |
| `project-type` | `project_type` |
| `project-billeable` | `project_billeable` |
| `project-categories` | `project_categories` |
| `user-auth-level` | `user_auth_level` |
| `user-type` | `user_type` |
| `global-setting` | `global_setting` |
| `global_setting` | `global_setting` |

### Query Params

| Query | Type | Required | Description |
|------|------|----------|-------------|
| `status` | number | no | filter status, hanya berlaku untuk tabel yang punya kolom `status` |

### Default Filter

- Semua master data otomatis filter `presence = 1`
- Jika query `status` dikirim, maka akan tambah filter `status = value`

### Example URLs

- `GET /api/master/industry`
- `GET /api/master/product?status=1`
- `GET /api/master/project-type?status=1`
- `GET /api/master/project-billeable?status=1`
- `GET /api/master/project-categories?status=1`
- `GET /api/master/user-auth-level`
- `GET /api/master/user-type`
- `GET /api/master/global-setting`

### Example Request

```http
GET /api/master/product?status=1
Authorization: Bearer <token>
```

### Success Response Example

```json
{
	"status": true,
	"message": "Master data fetched",
	"data": [
		{
			"id": 1,
			"name": "Acumatica ERP",
			"status": 1,
			"presence": 1,
			"inputDate": "2024-12-31T17:00:00.000Z",
			"inputBy": 1,
			"updateDate": "2024-12-31T17:00:00.000Z",
			"updateBy": 1
		}
	]
}
```

### Unauthorized Response

```json
{
	"status": false,
	"message": "Unauthorized",
	"data": null
}
```

### Not Found Response

```json
{
	"status": false,
	"message": "Master data endpoint not found",
	"data": null
}
```

---

## 4. Master Data CRUD

Semua endpoint CRUD master data menggunakan auth bearer token dan `masterKey` yang sama seperti tabel di atas.

### GET `/api/master/:masterKey/:id`

Detail 1 data master berdasarkan `id`.

### Path Params

| Param | Type | Required | Description |
|------|------|----------|-------------|
| `masterKey` | string | yes | master key |
| `id` | number | yes | id data master |

### POST `/api/master/:masterKey`

Buat data master baru.

### PUT `/api/master/:masterKey/:id`

Update data master existing.

### DELETE `/api/master/:masterKey/:id`

Soft delete (set `presence = 0`).

Catatan policy sesuai requirement:
- Full CRUD aktif untuk: `industry`, `project_billeable`, `project_categories`, `project_type`.
- `global_setting` hanya bisa `UPDATE`.
- `POST /api/master/global_setting` dan `DELETE /api/master/global_setting/:id` akan return `405`.

### Body Fields per `masterKey`

| masterKey | Required fields | Optional fields |
|----------|------------------|-----------------|
| `industry` | `name` | - |
| `product` | `name` | `status` |
| `project-type` | `name` | `ticketBased`, `status` |
| `project-billeable` | `name` | `status` |
| `project-categories` | `name` | `status` |
| `user-auth-level` | `name` | `c`, `r`, `u`, `d` |
| `user-type` | `name` | - |
| `global-setting` | `name`, `value` | `note` |

### Example Create Request

```http
POST /api/master/industry
Authorization: Bearer <token>
Content-Type: application/json
```

```json
{
	"name": "Manufacture"
}
```

### Example Update Request

```http
PUT /api/master/product/1
Authorization: Bearer <token>
Content-Type: application/json
```

```json
{
	"name": "SAP B1",
	"status": 1
}
```

### Example Delete Request

```http
DELETE /api/master/industry/353
Authorization: Bearer <token>
```

### Example Success Response (Create/Update)

```json
{
	"status": true,
	"message": "Master data created",
	"data": {
		"id": 353,
		"name": "Manufacture",
		"presence": 1,
		"inputDate": "2026-06-10T09:43:35.000Z",
		"inputBy": 1,
		"updateDate": "2026-06-10T09:43:35.000Z",
		"updateBy": 1
	}
}
```

### Example Success Response (Delete)

```json
{
	"status": true,
	"message": "Master data deleted",
	"data": {
		"id": 353
	}
}
```

### Validation Error Response

```json
{
	"status": false,
	"message": "Missing required fields: name",
	"data": null
}
```

---

## Dummy Data Inserted

Data dummy yang sudah saya insert ke database:

### Table `user_auth_level`
- `1` — Administrator
- `2` — Client User

### Table `client`
- `CLI-DEMO` — Demo Client

### Table `user`
- `USR-ADMIN` — `admin@thinktank.local`
- `USR-CLIENT` — `client.demo@thinktank.local`

---

## Quick Test Flow

1. `POST /api/auth/login`
2. Copy token dari response
3. Kirim header `Authorization: Bearer <token>`
4. Test `GET /api/auth/me`

---

## 5. Client CRUD

Semua endpoint client butuh header bearer token.

### GET `/api/client`

List client aktif (`presence=1`).

#### Query Params

| Query | Type | Required | Description |
|------|------|----------|-------------|
| `status` | number | no | filter status |
| `industryId` | number | no | filter IndustryId |
| `keyword` | string | no | search by code or name |

### GET `/api/client/:id`

Detail client by id.

### POST `/api/client`

Create client baru.

#### Body

```json
{
	"code": "CLI-NEW",
	"name": "Client Baru",
	"address": "Jakarta",
	"IndustryId": 351,
	"status": 1
}
```

#### Required Body Fields

| Field | Type | Required |
|------|------|----------|
| `code` | string | yes |
| `name` | string | yes |
| `address` | string | yes |

Validation tambahan:
- `IndustryId` harus integer `0..127` (mengikuti tipe kolom `tinyint` di tabel `client`).
- `status` harus `0` atau `1`.

### PUT `/api/client/:id`

Update client existing (partial update).

#### Body (example)

```json
{
	"name": "Client Baru Updated",
	"status": 1
}
```

### DELETE `/api/client/:id`

Soft delete client (`presence = 0`).

### Success Response Example (Create)

```json
{
	"status": true,
	"message": "Client created",
	"data": {
		"id": 352,
		"code": "CLI-NEW",
		"name": "Client Baru",
		"address": "Jakarta",
		"IndustryId": 351,
		"status": 1,
		"presence": 1
	}
}
```

---

## 6. Project CRUD

Semua endpoint project butuh header bearer token.

### GET `/api/project`

List project aktif (`presence=1`).

#### Query Params

| Query | Type | Required | Description |
|------|------|----------|-------------|
| `status` | number | no | filter status (0/1) |
| `clientId` | string/number | no | filter clientId |
| `projectTypeId` | number | no | filter project type |
| `keyword` | string | no | search by project id atau nama client |

### GET `/api/project/:id`

Detail project by `id`.

### POST `/api/project`

Create project baru.

#### Body

```json
{
	"projectTypeId": 1,
	"projectBilleableId": 1,
	"projectCategoryId": 1,
	"productId": 1,
	"clientId": 351,
	"startDate": "2026-06-10",
	"endDate": "2026-07-10",
	"status": 1,
	"templateMaster": "TMP-001"
}
```

---

## 7. User CRUD

Semua endpoint user butuh header bearer token.

### GET `/api/user`

List user aktif (`presence=1`).

#### Query Params

| Query | Type | Required | Description |
|------|------|----------|-------------|
| `status` | number | no | filter status (0/1) |
| `authlevelId` | number | no | filter auth level |
| `clientId` | number | no | filter client user |
| `keyword` | string | no | search by id/email/firstName/lastName |

### GET `/api/user/:id`

Detail user by `id`.

### POST `/api/user`

Create user baru.

#### Body

```json
{
	"email": "new.user@thinktank.local",
	"password": "Strong123!",
	"authlevelId": 2,
	"firstName": "New",
	"lastName": "User",
	"clientId": 351,
	"status": 1
}
```

---

## 8. Ticket Balance

Semua endpoint ticket balance butuh header bearer token.

### GET `/api/ticket-balance/project/:projectId`

List transaksi ticket balance per project (hanya `presence=1`).

### GET `/api/ticket-balance/summary/:projectId`

Summary ticket balance per project.

#### Response Fields

| Field | Type | Description |
|------|------|-------------|
| `projectId` | string | id project |
| `totalTicketIn` | number | total ticket masuk |
| `totalTicketOut` | number | total ticket keluar |
| `balance` | number | sisa ticket (`in - out`) |

### POST `/api/ticket-balance`

Tambah transaksi ticket balance.

#### Body

```json
{
	"projectId": "PRJ-822BC171",
	"ticketIn": 10,
	"ticketOut": 0,
	"date": "2026-06-10T09:58:11.000Z"
}
```

#### Required Body Fields

| Field | Type | Required | Notes |
|------|------|----------|-------|
| `projectId` | string | yes | project harus ada dan `presence=1` |
| `ticketIn` | number | no | non-negative |
| `ticketOut` | number | no | non-negative |

Catatan:
- `ticketIn` atau `ticketOut` minimal salah satu harus > 0.
- `date` optional, default waktu server saat insert.

### Example Summary Response

```json
{
	"status": true,
	"message": "Ticket balance summary fetched",
	"data": {
		"projectId": "PRJ-822BC171",
		"totalTicketIn": 10,
		"totalTicketOut": 3,
		"balance": 7
	}
}
```

#### Required Body Fields

| Field | Type | Required |
|------|------|----------|
| `email` | string | yes |
| `password` | string | yes |
| `authlevelId` | number | yes |
| `firstName` | string | yes |

Catatan:
- `id` boleh dikirim manual.
- Jika `id` tidak dikirim, backend auto-generate format `USR-XXXXXXXX`.
- `email` harus unik.

### PUT `/api/user/:id`

Update user existing (partial update).

#### Body (example)

```json
{
	"firstName": "Updated Name",
	"status": 0,
	"password": "NewPass123!"
}
```

### DELETE `/api/user/:id`

Soft delete user (`presence = 0`).

### Success Response Example (Create)

```json
{
	"status": true,
	"message": "User created",
	"data": {
		"id": "USR-62199DD8",
		"email": "temp.user.crud@thinktank.local",
		"authlevelId": 2,
		"firstName": "Temp",
		"status": 1,
		"presence": 1
	}
}
```

#### Required Body Fields

| Field | Type | Required |
|------|------|----------|
| `projectTypeId` | number | yes |
| `projectBilleableId` | number | yes |
| `projectCategoryId` | number | yes |
| `productId` | number | yes |
| `clientId` | string/number | yes |
| `startDate` | string (YYYY-MM-DD) | yes |
| `endDate` | string (YYYY-MM-DD) | yes |

Catatan:
- `id` boleh dikirim manual.
- Jika `id` tidak dikirim, backend auto-generate format `PRJ-XXXXXXXX`.

### PUT `/api/project/:id`

Update project existing (partial update).

#### Body (example)

```json
{
	"status": 0,
	"templateMaster": "TMP-UPDATED"
}
```

### DELETE `/api/project/:id`

Soft delete project (`presence = 0`).

### Success Response Example (Create)

```json
{
	"status": true,
	"message": "Project created",
	"data": {
		"id": "PRJ-CACC2C8D",
		"projectTypeId": 1,
		"projectBilleableId": 1,
		"projectCategoryId": 1,
		"productId": 1,
		"clientId": "351",
		"status": 1,
		"presence": 1
	}
}
```
5. Test `GET /api/master/product?status=1`
