# Server SiagaBanjir

> **Living document:** perbarui bersama setiap perubahan terkait menurut [aturan dokumentasi](../../rules/documentation.md#living-documents).

Fondasi lokal Node 24, TypeScript strict dan Fastify 5. Seluruh 72 operasi endpoint dari
spesifikasi [OpenAPI](../../docs/openapi.json) telah diimplementasikan lengkap mencakup
autentikasi akun & profil, pelaporan warga, brankas dokumen privat, peninjauan admin,
kelompok insiden, Pantau publik, CMS edukasi, siaran pesan, serta kotak masuk warga.
Server dilengkapi dashboard dokumentasi interaktif Swagger UI dan endpoint pemeriksaan
kesehatan sistem (health check) server dan MySQL.

## Menjalankan Server

### A. Menggunakan Docker Compose (Instan Sekali Jalan)

Dari root workspace, jalankan satu perintah:

```bash
docker compose up -d
```

Perintah ini secara otomatis menjalankan MySQL 8.0, membuat database & akun aman melalui `docker/mysql/init.sql`, mengeksekusi 32 migrasi skema tabel, dan menjalankan Fastify server pada port `3000`.

### B. Menjalankan Manual di Komputer Host

Dari root workspace atau folder `apps/server`, gunakan Node >=24.15.0 <25 dan pnpm 10.34.9:

```sh
# Menjalankan server dalam mode pengembangan dengan auto-reload (watch)
corepack pnpm --dir apps/server dev

# Atau build dan jalankan server hasil kompilasi dist
corepack pnpm --dir apps/server build
corepack pnpm --dir apps/server start
```

API server aktif secara default di `http://127.0.0.1:3000`.

## Pengujian Interaktif via Swagger UI

Server menyediakan antarmuka Swagger UI langsung dari server lokal untuk memudahkan tim menguji seluruh endpoint tanpa memerlukan tool pihak ketiga eksternal seperti Postman:

- **Dashboard Swagger UI:**
  - `http://127.0.0.1:3000/docs`
  - `http://127.0.0.1:3000/documentation`
  - `http://127.0.0.1:3000/api/docs`
- **Spesifikasi Mentah OpenAPI JSON:**
  - `http://127.0.0.1:3000/api/v1/openapi.json`
  - `http://127.0.0.1:3000/openapi.json`

### Cara Menguji Endpoint di Swagger UI

1. Buka peramban ke `http://127.0.0.1:3000/docs`.
2. Untuk endpoint publik (misalnya `GET /api/v1/meta`, `GET /api/v1/public/monitor`, `GET /health`):
   - Klik baris endpoint $\rightarrow$ klik tombol **"Try it out"** $\rightarrow$ klik **"Execute"**.
3. Untuk endpoint terproteksi (misalnya `GET /api/v1/me`, `GET /api/v1/admin/reports`):
   - Jalankan `POST /api/v1/auth/login` terlebih dahulu untuk mendapatkan token sesi.
   - Klik tombol hijau **"Authorize"** di bagian atas halaman Swagger UI.
   - Masukkan token sesi pada field `bearerAuth` lalu klik **"Authorize"**.
   - Sekarang seluruh request yang membutuhkan otorisasi akan otomatis menyertakan header `Authorization: Bearer <token>`.

## Endpoint Pemeriksaan Kesehatan (Health Check)

Untuk memantau apakah server, proses Node.js, konektivitas database MySQL, dan tabel skema migrasi dalam kondisi sehat dan aman:

- **Endpoint:**
  - `GET http://127.0.0.1:3000/health`
  - `GET http://127.0.0.1:3000/api/v1/health`

### Pengujian via CLI / Terminal

```sh
# Menggunakan cURL
curl -i http://127.0.0.1:3000/health

# Menggunakan PowerShell
Invoke-RestMethod http://127.0.0.1:3000/health | ConvertTo-Json -Depth 5
```

### Contoh Respons Sehat (HTTP 200 OK)

```json
{
  "data": {
    "status": "healthy",
    "server": {
      "status": "UP",
      "uptimeSeconds": 12.5,
      "nodeVersion": "v24.15.0",
      "memoryMb": {
        "rss": 102.5,
        "heapUsed": 32.7,
        "heapTotal": 54.4
      }
    },
    "database": {
      "status": "UP",
      "latencyMs": 2.8
    },
    "migrations": {
      "status": "UP",
      "appliedCount": 32
    }
  },
  "requestId": "d358b6f8-629c-4863-baf8-78115b62b88b",
  "serverTime": "2026-11-01T14:51:25.709Z"
}
```

Jika database terputus atau mengalami kegagalan, endpoint mengembalikan status **HTTP 503 Service Unavailable** dengan field `status: "unhealthy"` dan rincian kesalahan yang disanitasi.

## Konfigurasi Environment

DeepSeek memakai `DEEPSEEK_API_KEY` (alias `DEEPSEEKAPI`) dari `.env`
backend. Model `deepseek-flash`, key tidak dimasukkan ke Flutter.
Setelah migrasi, jalankan API dan worker pada dua terminal dari root:

```powershell
corepack pnpm --dir apps/server db:migrate
corepack pnpm --dir apps/server dev
```

```powershell
corepack pnpm --dir apps/server worker
```

Worker memerlukan FFmpeg/ffprobe; PDF memerlukan Poppler pdfinfo/pdftoppm.
Isi path executable pada `.env` jika belum tersedia di PATH. Docker memasang
binary ini dalam image dan menjalankan worker dengan volume media bersama.
Tanpa worker, job tetap menunggu; kegagalan provider ditampilkan sebagai gagal,
bukan keberhasilan simulasi. Pengujian provider eksplisit (menggunakan kredit)
memakai database test: dari apps/server jalankan
`node --env-file=.env --env-file=.env.test --import tsx test/provider.integration.ts`.
Hasil dan keterbatasan ada pada [handoff](../../docs/SESSION-HANDOFF.md).

Salin `.env.example` menjadi `.env` jika ingin mengubah konfigurasi runtime:
startup server kini memerlukan DB runtime dan tiga key keamanan yang valid.
`.env` diabaikan Git. Konfigurasi invalid
menghentikan startup tanpa mencetak nilainya.

| Variabel    | Default dan batas                                     |
| ----------- | ----------------------------------------------------- |
| NODE_ENV    | development; hanya development/test pada unit fondasi |
| HOST        | 127.0.0.1; alternatif ::1, loopback saja              |
| PORT        | 3000; integer 1–65535                                 |
| LOG_LEVEL   | info; info/warn/error/silent                          |
| STORAGE_DIR | `<cwd>/storage`; root berkas media dan workspace AI   |

### Tata letak penyimpanan media

`STORAGE_DIR` menjadi akar dua direktori:

```
storage/
  uploads/
    REPORT/<tahun>/<bulan>/<uploadId>_<sha256>
    DOCUMENT/<tahun>/<bulan>/<uploadId>_<sha256>
  working/            # salinan kerja AI, dibersihkan setelah dipakai
```

Kolom `uploads.blob_key` menyimpan path relatif terhadap `storage/uploads`
(mis. `REPORT/2026/11/<uuid>_<sha256>`). `resolveBlobPath()` menolak segmen
`..`, path absolut, dan karakter di luar `[A-Za-z0-9_.-]`, sehingga permintaan
media tidak dapat keluar dari direktori penyimpanan. Kunci datar lama
(`<uploadId>_<sha256>` tanpa subfolder) tetap dapat dibaca, jadi berkas
pengembangan sebelum penataan ini tidak hilang. Di Docker nilainya
`/app/storage` dengan volume `media_data`; pastikan volume itu persisten.

Saat ini belum dapat diakses langsung dari HP atau origin Flutter Web berbeda.
Konfigurasi jaringan/TLS/CORS dan production akan ditambahkan bersama integrasi;
nilai production sengaja ditolak sampai kontrol tersebut tersedia.

## Struktur dan pemeriksaan

`src/app.ts` merakit HTTP tanpa membuka socket; `src/server.ts` menjalankan
proses dan shutdown. `src/http` berisi metadata/error; `src/config.ts`
memvalidasi environment. `src/db` menyediakan konfigurasi mysql2, pool,
transaksi dengan guard dan runner migrasi. Entry server memeriksa koneksi DB
dan memasang endpoint akun/sesi; factory tanpa dependensi DB tetap dipakai tes metadata.

| Perintah pnpm           | Tujuan                                                                 |
| ----------------------- | ---------------------------------------------------------------------- |
| format / format:check   | Tulis/periksa format Prettier                                          |
| lint                    | ESLint dengan pemeriksaan berbasis tipe                                |
| typecheck               | TypeScript tanpa emit, termasuk tes                                    |
| test                    | node:test + Fastify inject, validasi OpenAPI dan socket loopback nyata |
| build                   | Emit JavaScript ke dist                                                |
| check                   | Format, lint, tipe, tes lalu build                                     |
| audit --audit-level low | Advisory dependensi runtime dan pengembangan                           |
| db:check                | Periksa koneksi dan instance MySQL database                            |
| db:migrate              | Terapkan skema migrasi database SQL                                    |
| db:seed                 | Buat 15 akun pengujian (10 Warga & 5 Admin) ke database MySQL          |
| test:db                 | Pengujian integrasi database MySQL riil                                |

Perintah `db:check`, `db:migrate`, `db:seed` dan `test:db` tersedia setelah provisioning;
ikuti [konfigurasi privat dan migrasi](MYSQL-SETUP.md#konfigurasi-backend).
Tes MySQL sengaja terpisah dari `check`, bukan dianggap lulus saat credential
belum tersedia. Migrasi 001–007 menyediakan guard dan tabel akun, recovery,
sesi, bucket kegagalan serta commands. Helper jurnal khusus respons rahasia
tersedia; signup/login dan pencabutan sesi memakainya. State machine laporan
masih menyusul.

JSON dibatasi 512 KiB; query tidak dikenal ditolak, field tidak dibuang atau
dikonversi diam-diam. Request ID UUID dibuat server. Error tidak mengembalikan
nilai input/stack; log request hanya event, korelasi dan status. Respons memakai
no-store/nosniff. Proxy headers tidak dipercaya. Ini kontrol fondasi, belum
membuktikan keamanan auth/ownership/upload yang belum diimplementasikan.

Lifecycle install hanya mengizinkan esbuild, dependency tsx untuk tes/dev.
Override minimatch 10.2.6 ke 11.0.1 menutup
[GHSA-g3hv-75wg-m249](https://github.com/isaacs/minimatch/security/advisories/GHSA-g3hv-75wg-m249)
pada tool lint; tinjau pencabutannya setelah upstream memakai versi aman.
Tidak memakai pengecualian audit untuk menyembunyikan advisory.

## Bukti dan pekerjaan berikutnya

Login sudah memakai dummy hash, pembatasan kegagalan principal/source dan
pemeriksaan epoch sebelum commit. Tes MySQL mencakup kredensial salah/akun tidak
ada, pembatasan role ADMIN_WEB, replay dan throttle. Middleware token dan
GET /me, logout dan revoke kini tersedia dengan tes expiry, epoch serta
pencabutan sesi. PATCH /me dan integrasi Flutter belum tersedia.

Helper keamanan menyediakan scrypt, token/revoke acak, recovery base32 dan
verifier digest/HMAC. Key RECOVERY_HMAC_KEY, JOURNAL_HMAC_KEY, CURSOR_HMAC_KEY
berformat hex 64 karakter dan wajib berbeda. Nilai lokal ada di .env/.env.test,
tidak masuk Git; entry HTTP membacanya untuk signup. Pertahankan key antar-restart;
mengganti key tanpa migrasi dapat membatalkan verifier dan identitas jurnal.
Jangan memakai key development untuk production.

Pemeriksaan pada Windows, Node 24.15.0: sembilan tes HTTP/config/migrasi/HMAC PASS, mencakup
OpenAPI metadata/error, request ID, ukuran/format/query invalid, sanitasi log,
serta socket nyata. Format/lint/typecheck/build PASS. Hasil audit dan validasi
dokumentasi akhir dicatat pada [handoff](../../docs/SESSION-HANDOFF.md).
MySQL 8.0.30: db:check, dua migrasi development dan satu tes integrasi database
PASS (replay, rollback, sesi dan batas akses runtime). Linux/macOS, CI remote,
Flutter terhubung, provider dan HP NOT_RUN.

mysql2 3.24.6 dan migrasi SQL berurutan sudah tersedia. Unit berikutnya
adalah PATCH profil berversi, perubahan kredensial dan pemulihan akun. DB/akun sudah dibuat; konfigurasi privat
lokal tersedia dan koneksi serta tes transaksi awal sudah diperiksa.
Jangan menjalankan API memakai root.
Ikuti [panduan persiapan MySQL](MYSQL-SETUP.md) untuk provisioning lokal
dan pemeriksaan hak akun tanpa membagikan sandi.
Lalu auth, berkas privat, worker DeepSeek, laporan/kuota, admin dan fitur
pendukung mengikuti [SRS](../../docs/SRS.md) serta mandat terbaru pada
[WS-DEC-070](../../docs/DECISIONS.md#backend-foundation-070).
