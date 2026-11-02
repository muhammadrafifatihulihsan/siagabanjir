# Panduan Setup & Eksekusi SiagaBanjir dari Nol (Fresh Clone to Running)

> **Living document:** perbarui bersama setiap perubahan terkait menurut [aturan dokumentasi](../rules/documentation.md#living-documents).

Dokumen ini adalah panduan langkah demi langkah yang ditujukan bagi dosen penguji, mahasiswa, atau pengembang baru yang baru saja mengkloning (*git clone*) repositori **SiagaBanjir** dari GitHub pada komputer yang belum terpasang dependensi proyek sama sekali.

Tersedia **2 Metode Eksekusi**:
1. **[Metode A: Setup Manual / Native (Rekomendasi Utama)](#metode-a-setup-manual-native)**: Menggunakan Laragon (MySQL), Node.js Fastify, dan Flutter SDK secara mandiri di komputer host. Cocok untuk pengembangan, evaluasi kode, dan pengujian interaktif.
2. **[Metode B: Setup Instan Menggunakan Docker](#metode-b-setup-instan-menggunakan-docker-one-command)**: Satu perintah instan menggunakan Docker Compose tanpa perlu instalasi Node.js, pnpm, atau Laragon secara manual.

---

## Prasyarat Perangkat Lunak (Prerequisites)

Sebelum memulai, pastikan komputer Anda telah terpasang:

| Perangkat Lunak | Versi Minimal | Fungsi |
|---|---|---|
| **Git** | Versi terbaru | Mengunduh repositori dan manajemen versi |
| **Node.js** | `>=24.15.0 <25` (LTS) atau `>=20.x` | Runtime server backend Fastify |
| **Laragon** (atau MySQL Server) | MySQL `8.0` (Port 3306) | Basis data relasional penyimpanan data |
| **Flutter SDK** | `>=3.47.7` / Dart `>=3.13.5` | SDK antarmuka aplikasi Warga & Admin |
| **Peramban Web** | Google Chrome / Microsoft Edge | Antarmuka Flutter Web & Swagger UI |
| **Docker Desktop** *(opsional)* | Docker Engine v20+ | Untuk metode eksekusi kontainer instan |

---

## Langkah Awal: Clone Repositori

Buka terminal (PowerShell / Command Prompt / Bash), lalu jalankan:

```bash
git clone https://github.com/muhammadrafifatihulihsan/siagabanjir.git
cd siagabanjir
```

---

## Metode A: Setup Manual / Native

### 1. Persiapan Paket Manajer Server (pnpm via Corepack)

Proyek backend SiagaBanjir menggunakan paket manajer `pnpm` versi `10.34.9`. Anda **tidak perlu** menginstal pnpm secara global. Cukup aktifkan `corepack` bawaan Node.js:

```powershell
corepack enable
```

Jika tidak ingin mengaktifkan corepack secara global, Anda dapat langsung memanggilnya dengan prefiks `corepack pnpm` pada setiap perintah.

---

### 2. Instalasi Dependensi Backend Server

Dari direktori root proyek `siagabanjir`, jalankan:

```powershell
corepack pnpm --dir apps/server install
```

Perintah ini akan mengunduh seluruh dependensi Fastify, driver MySQL2, TypeScript, dan pustaka pendukung ke folder `apps/server/node_modules/`.

---

### 3. Menyalakan MySQL di Laragon & Inisialisasi Database

1. Buka aplikasi **Laragon**.
2. Klik tombol **Start All** (pastikan modul MySQL aktif pada port `3306`).
3. Buka terminal MySQL (di Laragon: klik kanan $\rightarrow$ **MySQL** $\rightarrow$ **Terminal** atau buka HeidiSQL bawaan Laragon), lalu jalankan perintah SQL berikut untuk membuat database dan akun akses:

```sql
-- 1. Buat database Development dan Testing
CREATE DATABASE IF NOT EXISTS siagabanjirdev CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
CREATE DATABASE IF NOT EXISTS siagabanjirtest CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

-- 2. Buat akun akses (Password disamakan persis dengan nama usernya untuk kenyamanan dev)
CREATE USER IF NOT EXISTS 'sb_dev_app'@'127.0.0.1' IDENTIFIED BY 'sb_dev_app';
CREATE USER IF NOT EXISTS 'sb_dev_migrate'@'127.0.0.1' IDENTIFIED BY 'sb_dev_migrate';
CREATE USER IF NOT EXISTS 'sb_test_app'@'127.0.0.1' IDENTIFIED BY 'sb_test_app';
CREATE USER IF NOT EXISTS 'sb_test_migrate'@'127.0.0.1' IDENTIFIED BY 'sb_test_migrate';

-- 3. Berikan hak akses sesuai prinsip keamanan (Principle of Least Privilege)
GRANT SELECT, INSERT, UPDATE, DELETE ON siagabanjirdev.* TO 'sb_dev_app'@'127.0.0.1';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, ALTER, INDEX, REFERENCES ON siagabanjirdev.* TO 'sb_dev_migrate'@'127.0.0.1';
GRANT SELECT, INSERT, UPDATE, DELETE ON siagabanjirtest.* TO 'sb_test_app'@'127.0.0.1';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, ALTER, INDEX, REFERENCES ON siagabanjirtest.* TO 'sb_test_migrate'@'127.0.0.1';

FLUSH PRIVILEGES;
```

---

### 4. Menyiapkan Berkas Konfigurasi Lingkungan (`.env`)

Karena berkas `.env` privat tidak di-push ke GitHub demi standar keamanan informasi, buatlah 3 berkas berikut di dalam direktori `apps/server/`:

#### A. Berkas `apps/server/.env` (Konfigurasi Terpadu Server & Migrasi Dev)
Cukup salin dari `apps/server/.env.example` ke `apps/server/.env`:

```env
# 1. Konfigurasi Lingkungan Server
NODE_ENV=development
HOST=127.0.0.1
PORT=3000
LOG_LEVEL=info

# 2. Basis Data Runtime (DML - Digunakan oleh server & signup)
DB_HOST=127.0.0.1
DB_PORT=3306
DB_NAME=siagabanjirdev
DB_USER=sb_dev_app
DB_PASSWORD=sb_dev_app

# 3. Basis Data Migrasi Skema (DDL - Digunakan oleh db:migrate)
MIGRATION_DB_HOST=127.0.0.1
MIGRATION_DB_PORT=3306
MIGRATION_DB_USER=sb_dev_migrate
MIGRATION_DB_PASSWORD=sb_dev_migrate

# 4. Kunci Kriptografi Keamanan (Wajib 64 Karakter Hex Unik)
RECOVERY_HMAC_KEY=0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef
JOURNAL_HMAC_KEY=abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789
CURSOR_HMAC_KEY=456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123
```

> [!TIP]
> Berkas `.env` di atas telah disatukan strukturnya memuat kredensial aplikasi (`DB_*`) dan migrasi (`MIGRATION_DB_*`). Perintah `db:migrate` otomatis membaca konfigurasi dari berkas `.env` ini secara langsung, sehingga Anda **cukup menyalin satu berkas `.env` saja** untuk kebutuhan pengembangan dan pengujian lokal!

#### B. Berkas `apps/server/.env.test` (Opsional - Khusus Pengujian Otomatis `test:db`)
Jika ingin menjalankan tes integrasi otomatis (`corepack pnpm --dir apps/server test:db`), buat berkas `.env.test` dengan struktur yang sama persis:

```env
NODE_ENV=test
HOST=127.0.0.1
PORT=3000
LOG_LEVEL=silent

DB_HOST=127.0.0.1
DB_PORT=3306
DB_NAME=siagabanjirtest
DB_USER=sb_test_app
DB_PASSWORD=sb_test_app

MIGRATION_DB_HOST=127.0.0.1
MIGRATION_DB_PORT=3306
MIGRATION_DB_USER=sb_test_migrate
MIGRATION_DB_PASSWORD=sb_test_migrate

RECOVERY_HMAC_KEY=49e91dc63e4297223025fc2ebfe011ddce818268aa12f27cc76f8caee7511271
JOURNAL_HMAC_KEY=70f49015aaf1a2f3f50cb3af2bfd9136ab3a8884a4ebf2088c36f97059d631d9
CURSOR_HMAC_KEY=fbbb1068220e493421ecf4447f636fa722b3802e6332778f426d5202a9e0520b
```

---

### 5. Migrasi Skema Database & Seeding Akun Pengujian

Dari root repositori, jalankan rangkaian perintah berikut:

```powershell
# 1. Periksa konektivitas basis data
corepack pnpm --dir apps/server db:check
# Output: "Koneksi MySQL dan konfigurasi instance valid."

# 2. Terapkan 33 skema tabel database
corepack pnpm --dir apps/server db:migrate
# Output: "Migrasi selesai: ... diterapkan."

# 3. Buat 15 akun pengujian siap pakai (10 Warga & 5 Petugas Admin)
corepack pnpm --dir apps/server db:seed
# Output: "Berhasil melakukan seeding seluruh 15 akun pengujian!"
```

---

### 6. Menjalankan Server Backend Fastify

Buka **Terminal 1** (khusus backend), lalu jalankan:

```powershell
corepack pnpm --dir apps/server dev
```

*Server aktif di:* **`http://127.0.0.1:3000`**  
*(Biarkan terminal ini tetap berjalan).*

**Verifikasi di Peramban:**
- **Health Check:** [http://127.0.0.1:3000/health](http://127.0.0.1:3000/health) $\rightarrow$ Status `"healthy"`, database `"UP"`.
- **Swagger UI (Uji API Interaktif):** [http://127.0.0.1:3000/docs](http://127.0.0.1:3000/docs).

---

### 7. Menjalankan & Menguji Aplikasi Flutter

Buka **Terminal 2** (terminal baru di root proyek), lalu masuk ke direktori Flutter:

```powershell
cd apps/siagabanjir

# 1. Unduh paket dependensi Flutter
flutter pub get

# 2. Jalankan rangkaian pengujian otomatis (126 unit & widget tests)
flutter test

# 3. Jalankan aplikasi pada peramban Chrome (Rekomendasi Utama)
flutter run -d chrome
```

*(Opsi target lain: `-d edge` untuk Microsoft Edge, `-d windows` untuk aplikasi desktop Windows, atau `flutter run` untuk emulator Android).*

Peramban akan otomatis terbuka dan menampilkan antarmuka aplikasi **SiagaBanjir**.

---

### 8. Masuk & Mencoba Fitur (Login)

Gunakan salah satu dari 15 akun pengujian yang telah di-seed (semua akun menggunakan kata sandi: **`Password123!`**):

#### A. Akun Petugas Admin BPBD (Dashboard Web Admin)
Pilih tab **Petugas Admin** pada layar masuk, lalu gunakan salah satu kredensial:
- `admin1@siagabanjir.id` s.d. `admin5@siagabanjir.id` | Sandi: `Password123!`
- `admin.bpbd@padang.go.id` | Sandi: `Password123!`
- *Atau klik tombol cepat:* **"Masuk sebagai Petugas Admin"**.

#### B. Akun Warga Terdaftar (Aplikasi Warga)
Pilih tab **Warga** pada layar masuk, lalu gunakan salah satu kredensial:
- `warga1@siagabanjir.id` s.d. `warga10@siagabanjir.id` | Sandi: `Password123!`
- *Atau klik tombol cepat:* **"Masuk sebagai Warga"**.

---

## Metode B: Setup Instan Menggunakan Docker (One-Command)

Jika Anda tidak ingin mengonfigurasi MySQL Laragon atau Node.js secara manual di komputer host, gunakan Docker Compose:

### 1. Menjalankan Backend Fastify & MySQL 8.0 Saja

Pastikan Docker Desktop aktif, lalu jalankan di root repositori:

```powershell
docker compose up -d
```

- Kontainer MySQL 8.0 otomatis dibuat dan dikonfigurasi melalui `docker/mysql/init.sql`.
- Kontainer Fastify otomatis menunggu database siap, mengeksekusi 33 migrasi tabel, dan menyalakan server di port `3000`.
- Swagger UI dapat langsung diakses di: `http://localhost:3000/docs`.

### 2. Menjalankan Seluruh Sistem Sekaligus (Backend, MySQL, & Flutter Web)

```powershell
docker compose --profile all up -d
```

- **Backend API & Swagger UI:** `http://localhost:3000/docs`
- **Health Check:** `http://localhost:3000/health`
- **Flutter Web Production (Nginx):** `http://localhost:8080` (dilengkapi reverse proxy otomatis ke `/api/v1/`).

### 3. Menghentikan Kontainer Docker

```powershell
docker compose down
```

---

## Rangkuman Perintah Cepat (Cheat Sheet)

```powershell
# 1. Setup Backend
corepack pnpm --dir apps/server install
corepack pnpm --dir apps/server db:check
corepack pnpm --dir apps/server db:migrate
corepack pnpm --dir apps/server db:seed
corepack pnpm --dir apps/server dev

# 2. Setup Frontend Flutter
cd apps/siagabanjir
flutter pub get
flutter test
flutter run -d chrome
```

Jika terjadi kendala seputar basis data atau hak akses, rujuk panduan [MYSQL-SETUP.md](../apps/server/MYSQL-SETUP.md) dan pengujian lengkap di [PANDUAN-PENGUJIAN.md](PANDUAN-PENGUJIAN.md).
