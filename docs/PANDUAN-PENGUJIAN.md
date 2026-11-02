# Panduan Lengkap & Ringkas Pengujian SiagaBanjir

> **Panduan Pengujian:** Ikuti urutan langkah berikut dari persiapan awal (environment & database), verifikasi server, pengujian Swagger UI, hingga menjalankan aplikasi Flutter (Web & Android).

---

## 1. Persiapan Awal (Prerequisites)

Sebelum pengujian dimulai, pastikan perangkat lunak berikut telah siap di komputer:

| Komponen | Versi Minimal | Fungsi |
| --- | --- | --- |
| **Node.js** | `>=24.15.0 <25` | Runtime server backend Fastify |
| **pnpm** | `10.34.9` (via Corepack) | Paket manager dependensi server |
| **MySQL Server** | `8.0` (Laragon / XAMPP / Native) | Basis data relasional penyimpanan laporan & akun |
| **Flutter SDK** | `>=3.47.7` / Dart `>=3.13.5` | SDK antarmuka Warga (Android) dan Admin (Web) |
| **Peramban Web** | Chrome / Edge | Untuk Swagger UI & Flutter Web Admin |

---

## 2. Berkas Konfigurasi yang Wajib Diisi (.env)

Server backend membutuhkan berkas `.env` dan `.env.migrate` di dalam folder `apps/server/`.

### A. Berkas `apps/server/.env` (Runtime Server)

Pastikan berkas `apps/server/.env` ada dan terisi:

```env
NODE_ENV=development
HOST=127.0.0.1
PORT=3000
LOG_LEVEL=info

# Kredensial MySQL Runtime
DB_HOST=127.0.0.1
DB_PORT=3306
DB_NAME=siagabanjirdev
DB_USER=sb_dev_app
DB_PASSWORD=<sandi_akun_sb_dev_app>

# Kunci Kriptografi (Wajib 64 karakter HEX unik)
RECOVERY_HMAC_KEY=0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef
JOURNAL_HMAC_KEY=abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789
CURSOR_HMAC_KEY=456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123
```

> [!TIP]
> Jika belum memiliki kunci HEX 64 karakter, Anda dapat membuatnya lewat terminal:
> `node -e "console.log(crypto.randomBytes(32).toString('hex'))"`

### B. Berkas `apps/server/.env.migrate` (Eksekusi Migrasi Skema)

```env
NODE_ENV=development
DB_NAME=siagabanjirdev
MIGRATION_DB_HOST=127.0.0.1
MIGRATION_DB_PORT=3306
MIGRATION_DB_USER=sb_dev_migrate
MIGRATION_DB_PASSWORD=<sandi_akun_sb_dev_migrate>
```

---

## 3. Langkah 1: Uji Kesiapan Database & Jalankan Migrasi

Buka terminal di root proyek SiagaBanjir, lalu jalankan:

1. **Pastikan Service MySQL Aktif** (nyalakan MySQL di panel Laragon/XAMPP).
2. **Cek Konektivitas Database:**

   ```bash
   corepack pnpm --dir apps/server db:check
   ```

   *Indikator Berhasil:* `Koneksi MySQL dan konfigurasi instance valid.`

3. **Terapkan 32 Skema Migrasi Database:**

   ```bash
   corepack pnpm --dir apps/server db:migrate
   ```

   *Indikator Berhasil:* `Migrasi selesai: ... diterapkan.` (semua 32 tabel/tampilan berhasil dibuat).

---

## 4. Langkah 2: Menjalankan Server Backend

Jalankan server dalam mode pengembangan:

```bash
corepack pnpm --dir apps/server dev
```

*Server aktif di:* **`http://127.0.0.1:3000`**  
*(Biarkan terminal ini tetap menyala).*

---

## 5. Langkah 3: Uji Kesehatan Sistem (Health Check)

Buka tab baru di browser atau gunakan terminal:

- **URL:** [http://127.0.0.1:3000/health](http://127.0.0.1:3000/health)
- **PowerShell:**

  ```powershell
  Invoke-RestMethod http://127.0.0.1:3000/health | ConvertTo-Json -Depth 5
  ```

**Parameter Keberhasilan Respons:**

- `data.status`: `"healthy"` (HTTP 200 OK)
- `data.server.status`: `"UP"`
- `data.database.status`: `"UP"` (latensi MySQL ~1-3 ms)
- `data.migrations.status`: `"UP"`
- `data.migrations.appliedCount`: `32`

---

## 6. Langkah 4: Uji Interaktif Seluruh Endpoint via Swagger UI

Buka di browser: **[http://127.0.0.1:3000/docs](http://127.0.0.1:3000/docs)**

### Alur Uji Endpoint Publik (Tanpa Login)

1. Cari baris `GET /api/v1/public/monitor`.
2. Klik tombol **"Try it out"** $\rightarrow$ klik **"Execute"**.
3. Hasil: Menampilkan ringkasan status air sungai dan pemantauan wilayah publik.

### Alur Uji Endpoint Terproteksi (Warga / Admin)

1. Buka endpoint `POST /api/v1/auth/login`.
2. Klik **"Try it out"**, isi request body:

   ```json
   {
     "identifier": "081234567890",
     "password": "Password123!",
     "expectedRole": "WARGA"
   }
   ```

3. Klik **"Execute"** dan salin isi field `data.token`.
4. Gulir ke bagian paling atas halaman Swagger UI, klik tombol hijau **"Authorize"**.
5. Masukkan token ke kotak `bearerAuth` $\rightarrow$ klik **"Authorize"** $\rightarrow$ **"Close"**.
6. Sekarang Anda bisa menguji endpoint privat seperti `GET /api/v1/me` (profil akun) atau `GET /api/v1/me/reports` (riwayat laporan) langsung dari peramban.

---

## 7. Langkah 5: Uji Otomatis Server Backend

Di terminal baru, Anda dapat memverifikasi seluruh unit test backend:

```bash
# Menjalankan 16 unit tests Fastify & CORS preflight:
corepack pnpm --dir apps/server test

# Menjalankan integrasi MySQL nyata (32 migrasi & 72 alur):
corepack pnpm --dir apps/server test:db
```

*Keduanya wajib menghasilkan output: `All tests passed!` (100% PASS).*

---

## 8. Langkah 6: Menjalankan & Menguji Aplikasi Flutter

Buka terminal di root workspace, lalu masuk ke direktori `apps/siagabanjir`:

### A. Uji Unit Integrasi Jaringan Flutter

```bash
cd apps/siagabanjir
flutter test test/integrasi_backend_test.dart
```

*Hasil:* 7 pengujian integrasi HTTP & repository lulus.

### B. Menjalankan Flutter Web (Portal Admin & Pratinjau Warga)

```bash
cd apps/siagabanjir
flutter run -d chrome
```

*(Bisa diganti `-d edge` jika memakai Microsoft Edge).*

**Skenario Uji di Aplikasi:**

1. **Masuk sebagai Warga:**
   - Pada Layar Masuk, pilih tab **Warga** $\rightarrow$ klik **Masuk sebagai Warga**.
   - Cek tab **Pantau Wilayah**: Data tersinkronisasi dari endpoint `/api/v1/public/monitor`.
   - Cek tab **Lapor**: Isi formulir laporan dan klik simpan untuk mengirim laporan ke backend.
   - Cek tab **Peringatan Siaga**: Membaca notifikasi siaran dari `/api/v1/me/inbox`.
   - Cek tab **Profil**: Membaca dan memperbarui profil dari `/api/v1/me`.
2. **Masuk sebagai Petugas Admin BPBD:**
   - Kembali ke Layar Masuk, pilih tab **Petugas Admin** $\rightarrow$ klik **Masuk sebagai Petugas Admin**.
   - Antarmuka akan otomatis beralih ke **Dashboard Web Admin SiagaBanjir**:
     - **Klaster Wilayah:** Memantau kelompok insiden dari `/api/v1/admin/groups`.
     - **Laporan Masuk:** Meninjau antrean verifikasi laporan warga dari `/api/v1/admin/reports`.
     - **Pusat Aksi:** Menerbitkan pesan siaran peringatan darurat ke warga (`/api/v1/admin/messages`).

### C. Menjalankan di Android Emulator / HP Fisik

```bash
cd apps/siagabanjir
flutter run
```

*Catatan emulator:* Aplikasi Flutter telah otomatis mendeteksi platform Android dan menghubungkan API ke `http://10.0.2.2:3000` (IP loopback host PC dari emulator).

---

## 9. Rangkuman Perintah Singkat (Cheatsheet)

```bash
# 1. Cek & Migrasi Database
corepack pnpm --dir apps/server db:check
corepack pnpm --dir apps/server db:migrate

# 2. Jalankan Server Fastify
corepack pnpm --dir apps/server dev

# 3. Uji Kesehatan Sistem
curl -i http://127.0.0.1:3000/health

# 4. Buka Swagger UI di Browser
start http://127.0.0.1:3000/docs

# 5. Jalankan Aplikasi Flutter
cd apps/siagabanjir && flutter run -d chrome
```
