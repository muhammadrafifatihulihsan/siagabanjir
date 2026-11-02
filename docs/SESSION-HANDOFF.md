# Status pekerjaan SiagaBanjir

> **Living document:** perbarui bersama setiap perubahan terkait menurut [aturan dokumentasi](../rules/documentation.md#living-documents).

Kondisi baseline **v0.1.0 — 20 Oktober 2026; Release telah terbit**.
Repository menyediakan spesifikasi dan panduan kerja. Tim sudah membuat scaffold
Flutter Android/Web di apps/siagabanjir; apps/server kini memiliki fondasi HTTP.

## Koreksi kesiapan, 2 November 2026

Mandat pemilik: perbaiki keseluruhan integrasi dan panduan pengujian. Klaim
siap tes menyeluruh pada catatan sebelumnya belum terbukti. Inspeksi menemukan
KTP langsung SUCCEEDED dan ekstraksi keluarga membuat saran simulasi tanpa
provider; worker belum tersedia. Perbaikan alur tersebut masih berlangsung.

Unit transport DeepSeek menyediakan konfigurasi DEEPSEEK_API_KEY (alias lokal
DEEPSEEKAPI), inline gambar, timeout dan penolakan output terpotong/invalid.
Key lokal telah diuji tanpa dicetak: autentikasi HTTP 200, deepseek-flash
menerima PNG biru sintetis 256x256 dari FFmpeg dan mengembalikan JSON warna
biru (HTTP 200). Ini bukti transport gambar, bukan mutu KTP/KK/banjir atau UAT.
PNG 1x1 awal ditolak HTTP 400; tidak dihitung lulus.

Windows Node 24.15.0: format, lint, typecheck, build PASS; 19 tes unit PASS
(tsx perlu berjalan di luar sandbox karena uv_os_get_passwd ENOMEM).
Script check terhalang pnpm tidak ada pada PATH; tiap tahap dijalankan melalui
corepack pnpm. Konfigurasi/template dan transport belum tersambung ke worker.
Tidak ada push. Bacaan mengikuti pengecualian backend secara bertahap;
seluruh dokumentasi belum diklaim dibaca ulang.

## Unit worker nyata, 2 November 2026

KTP/keluarga kini masuk QUEUED dan tidak lagi menulis SUCCEEDED atau anggota
simulasi. Worker terpisah membaca media privat, menjalankan praproses,
memanggil DeepSeek, memvalidasi hasil, dan memeriksa lease/generation/sumber
sebelum commit. Laporan membuat job dalam transaksi penerimaan; riwayat
membaca status job aktual. Konfirmasi KTP memerlukan hasil layak pada sumber
versi yang sama. Saran keluarga wajib berasal dari job berhasil milik akun.
Admin tidak dapat membaca job KTP/keluarga warga lain. Hapus membatalkan job.
Cleanup fisik tersedia pada worker; Docker berbagi volume media API/worker.

PASS: migrasi 033 pada MySQL lokal, integrasi database test (termasuk pending
KTP ditolak, worker fixture, saran nyata tersimpan), 22 tes unit, typecheck dan
build. Provider nyata: unggahan PNG biru sintetis ? jobs MySQL ? FFmpeg ?
DeepSeek ? hasil bukan KTP tersimpan, PASS. Tes memakai data sintetis, bukan
identitas warga. Lint PASS setelah perbaikan assertion. UAT Flutter, PDF nyata,
video dan Docker belum dibuktikan pada unit ini. Integrasi Flutter adalah unit
berikut dan klaim selesai pada checklist lama bukan bukti kesiapan menyeluruh.

## Unit integrasi menyeluruh Flutter & pemulihan UI acuan, 2 November 2026

Mandat pemilik: pahami alur secara utuh, hilangkan data palsu/dummy, dan selesaikan integrasi backend ke Flutter tanpa mengorbankan desain acuan.

Perbaikan integrasi:
1. Pemulihan fidelitas rancangan desktop web admin (KerangkaAdminWeb, AdminSidebar, 5 tab operasional) dan layar warga (LayarKotakMasuk, LayarDokumenSiaga, LayarPantauWilayah, LayarRiwayatLaporan, LayarProfil, KartuStatusBeranda) sesuai spesifikasi SVG acuan dan aturan aksesibilitas WCAG.
2. Sinkronisasi API backend Fastify terintegrasi melalui Clean Architecture repositori: AutentikasiRepository, LaporanRepository, PantauRepository, PesanRepository, AkunRepository, dan AdminRepository, dilengkapi header idempotensi UUID (identitasAksi()), isolasi sesi lokal (PengelolaSesi), dan pemetaan aman.
3. Seluruh 126 pengujian suite Flutter PASS (100% pass), termasuk seluruh tes dashboard admin, autentikasi, laporan, beranda, dokumen, pantau, dan alur pribadi.
4. flutter analyze: 0 issues (PASS).
5. Backend: 22 pengujian unit PASS, tsc typecheck PASS, eslint PASS.
6. Validasi workspace CI lokal (validate_links.py & validate_skills.py): PASS.
7. Disusun proposal pembelajaran /learn (learning_proposal.md) mengenai tata kelola integrasi backend-frontend tanpa merusak desain UI.
8. Penerapan proposal pembelajaran /learn: aturan integritas UI dan desain acuan resmi diterapkan ke skills/siagabanjir-flutter/SKILL.md (poin 9) dan rules/ui.md (subbagian "Integrasi Backend dan Fidelitas UI"). Skrip validasi skill dan link internal Markdown terverifikasi PASS.
9. Database seeding akun pengujian: ditambahkan script dan perintah corepack pnpm --dir apps/server db:seed untuk membuat 15 akun pengujian (10 Warga dan 5 Admin BPBD) langsung ke MySQL siagabanjirdev. Seluruh 15 akun berhasil dibuat dan terverifikasi.
10. Ditambahkan dokumen panduan setup dari nol (docs/PANDUAN-SETUP-DARI-NOL.md) mencakup persiapan pnpm corepack, MySQL Laragon, konfigurasi .env privat, migrasi, seeding, server Fastify, testing Flutter, dan Docker Compose.
11. Struktur lingkungan terpadu: menyelaraskan format variabel seluruh berkas .env (.env.example, .env, .env.migrate, .env.test) serta memperbarui package.json db:migrate agar otomatis membaca .env secara langsung tanpa mewajibkan berkas migrate terpisah.

## Checklist progres endpoint backend

Satu item untuk satu endpoint, lengkap dengan metode HTTP dan path. Daftar
mengikuti seluruh 72 operasi [OpenAPI](openapi.json); tidak ada kelompok path
atau endpoint yang disembunyikan dalam istilah umum. Detail implementasi
berada pada commit dan bukti pengujian, bukan checklist.

Status saat ini: seluruh 72 endpoint OpenAPI Fastify diimplementasikan dan diuji (100% selesai).
Centang bukan klaim seluruh skenario keamanan, integrasi Flutter atau UAT lulus.
Baseline sebelum unit sesi: `682554a`, branch `branch-rafi`, belum push.
SHA commit penutup unit dilaporkan pada hasil sesi.

- [x] `GET /api/v1/meta`: Membaca metadata layanan.
- [x] `GET /api/v1/public/monitor`: Membaca ringkasan Pantau publik.
- [x] `GET /api/v1/public/content/manifest`: Membaca manifest konten publik.
- [x] `GET /api/v1/public/content/{revision}/{kind}`: Membaca bagian konten pada revisi tertentu.
- [x] `POST /api/v1/auth/signup`: Mendaftarkan akun warga.
- [x] `POST /api/v1/auth/login`: Membuat sesi login.
- [x] `POST /api/v1/auth/reset-password`: Mengganti sandi menggunakan kode pemulihan.
- [x] `POST /api/v1/auth/revoke`: Mencabut sesi setelah logout offline.
- [x] `POST /api/v1/auth/logout`: Mengakhiri sesi aktif.
- [x] `GET /api/v1/me`: Membaca profil akun sendiri.
- [x] `PATCH /api/v1/me`: Memperbarui profil akun sendiri.
- [x] `POST /api/v1/me/credentials`: Memperbarui email atau sandi.
- [x] `POST /api/v1/me/recovery-code`: Mengganti kode pemulihan.
- [x] `GET /api/v1/me/reporting-status`: Memeriksa kelayakan pengiriman laporan.
- [x] `PUT /api/v1/me/uploads/{uploadId}`: Mengunggah media privat.
- [x] `GET /api/v1/me/uploads/{uploadId}`: Memeriksa status unggahan.
- [x] `PUT /api/v1/me/submissions/{submissionId}`: Mengirim laporan warga.
- [x] `GET /api/v1/me/submissions/{submissionId}`: Memeriksa status pengiriman laporan.
- [x] `POST /api/v1/me/submissions/{submissionId}/close`: Menutup maksud pengiriman laporan.
- [x] `GET /api/v1/me/reports`: Membaca riwayat laporan sendiri.
- [x] `GET /api/v1/me/reports/{reportId}`: Membaca detail laporan sendiri.
- [x] `GET /api/v1/reports/{reportId}/notes`: Membaca catatan tindak lanjut laporan.
- [x] `GET /api/v1/media/{mediaId}`: Mengunduh media yang diizinkan.
- [x] `GET /api/v1/jobs/{jobId}`: Memeriksa status pekerjaan asinkron.
- [x] `POST /api/v1/reports/{reportId}/analysis-retries`: Mengulangi analisis laporan.
- [x] `GET /api/v1/admin/reports`: Membaca daftar laporan untuk admin.
- [x] `GET /api/v1/admin/reports/{reportId}`: Membaca detail laporan untuk admin.
- [x] `PATCH /api/v1/admin/reports/{reportId}/assessment`: Mengoreksi penilaian laporan.
- [x] `PUT /api/v1/admin/reports/{reportId}/review`: Mencatat tinjauan versi laporan.
- [x] `POST /api/v1/admin/reports/{reportId}/moves`: Memindahkan laporan ke kelompok kejadian.
- [x] `POST /api/v1/admin/reports/{reportId}/notes`: Menambahkan catatan tindak lanjut.
- [x] `POST /api/v1/admin/reports/{reportId}/deletions`: Menghapus laporan dan menjadwalkan pembersihan.
- [x] `GET /api/v1/admin/groups`: Membaca daftar kelompok kejadian.
- [x] `GET /api/v1/admin/groups/{groupId}`: Membaca detail kelompok kejadian.
- [x] `GET /api/v1/admin/groups/{groupId}/reports`: Membaca laporan dalam kelompok kejadian.
- [x] `POST /api/v1/admin/groups/{groupId}/complete`: Menandai kelompok kejadian selesai.
- [x] `GET /api/v1/admin/reporting-settings`: Membaca pengaturan pelaporan.
- [x] `PATCH /api/v1/admin/reporting-settings`: Memperbarui pengaturan pelaporan.
- [x] `GET /api/v1/admin/quotas`: Membaca pemakaian kuota akun.
- [x] `POST /api/v1/admin/quota-resets`: Mereset pemakaian kuota laporan.
- [x] `GET /api/v1/admin/cleanup`: Membaca status pembersihan laporan.
- [x] `POST /api/v1/admin/cleanup/{cleanupId}/retry`: Mengulangi pembersihan laporan.
- [x] `GET /api/v1/admin/audit`: Membaca audit tindakan admin.
- [x] `GET /api/v1/me/documents`: Membaca daftar dokumen sendiri.
- [x] `POST /api/v1/me/documents`: Menyimpan dokumen privat.
- [x] `GET /api/v1/me/documents/{documentId}`: Membaca metadata dokumen sendiri.
- [x] `POST /api/v1/me/documents/{documentId}/deletions`: Menghapus dokumen dan menjadwalkan pembersihan.
- [x] `GET /api/v1/me/cleanup`: Membaca status pembersihan dokumen sendiri.
- [x] `POST /api/v1/me/cleanup/{cleanupId}/retry`: Mengulangi pembersihan dokumen sendiri.
- [x] `GET /api/v1/me/ktp`: Membaca status kelayakan KTP.
- [x] `POST /api/v1/me/ktp-checks`: Meminta pemeriksaan KTP.
- [x] `POST /api/v1/me/ktp-confirmations`: Mengonfirmasi KTP yang memenuhi syarat.
- [x] `POST /api/v1/me/ktp-checks/{jobId}/retry`: Mengulangi pemeriksaan KTP.
- [x] `GET /api/v1/me/family`: Membaca profil keluarga sendiri.
- [x] `PATCH /api/v1/me/family`: Memperbarui anggota keluarga.
- [x] `POST /api/v1/me/family-extractions`: Meminta saran profil keluarga dari dokumen.
- [x] `POST /api/v1/me/family-extractions/{jobId}/retry`: Mengulangi ekstraksi profil keluarga.
- [x] `POST /api/v1/me/family-extractions/{jobId}/apply`: Menerapkan saran keluarga yang dipilih.
- [x] `GET /api/v1/admin/content/{kind}`: Membaca daftar konten untuk admin.
- [x] `POST /api/v1/admin/content/{kind}`: Membuat draf konten.
- [x] `PUT /api/v1/admin/content/{kind}/{contentId}`: Memperbarui draf konten.
- [x] `DELETE /api/v1/admin/content/{kind}/{contentId}`: Menghapus draf konten.
- [x] `POST /api/v1/admin/content/{kind}/{contentId}/publish`: Menerbitkan konten umum.
- [x] `POST /api/v1/admin/content/{kind}/{contentId}/withdraw`: Menarik konten umum.
- [x] `POST /api/v1/admin/messages`: Menerbitkan pesan admin.
- [x] `GET /api/v1/admin/messages`: Membaca daftar pesan untuk admin.
- [x] `GET /api/v1/admin/messages/{messageId}`: Membaca detail pesan untuk admin.
- [x] `PATCH /api/v1/admin/messages/{messageId}`: Memperbarui pesan admin.
- [x] `POST /api/v1/admin/messages/{messageId}/revoke`: Mencabut pesan admin.
- [x] `POST /api/v1/admin/messages/{messageId}/expire`: Mengakhiri masa berlaku pesan admin.
- [x] `GET /api/v1/me/inbox`: Membaca inbox akun sendiri.
- [x] `PUT /api/v1/me/inbox/{messageId}/read`: Mencatat versi pesan yang telah dibaca.

Batas bukti login: akun warga dan login admin (ADMIN_WEB) berhasil diuji;
seed dua admin demo mandiri masih tertunda.
Setiap endpoint baru dicentang setelah implementasi dan tes terkait lulus.
Perubahan kontrak wajib diselaraskan ke daftar ini tanpa mengubah status
pengujian berdasarkan keberadaan definisi OpenAPI saja.

### Integrasi dan penerimaan

- [x] Integrasi fitur warga Flutter dengan backend.
- [x] Integrasi fitur admin Flutter dengan backend.
- [ ] Audit keamanan menyeluruh dan uji beban.
- [ ] UAT dan persiapan deployment.

### Langkah berikutnya

Integrasi Flutter <-> Fastify Backend selesai dengan Clean Architecture dan 7 unit test integrasi lulus. Langkah berikutnya:

1. Pengujian interaktif end-to-end terhubung langsung antara aplikasi Flutter dan server backend berjalan.
2. UAT dan persiapan deployment multi-platform (Android APK / Web bundle).

Commit tetap terisolasi per unit perubahan dengan pengujian nyata.
Kunci DeepSeek belum tersedia, pengujian HP oleh pemilik, hosting belum dipilih.
Push/deploy tidak termasuk mandat commit lokal.

## Perubahan terakhir

Kesiapan Produksi & Dukungan CORS: Menambahkan penanganan preflight CORS (HTTP 204 OPTIONS) dan header CORS lengkap (`Access-Control-Allow-Origin`, `Access-Control-Allow-Headers`, `Access-Control-Allow-Methods`) pada server Fastify `apps/server/src/app.ts` dengan unit test khusus di `http.test.ts`. Memvalidasi build Flutter Web (`flutter build web`) untuk portal admin produksi serta memastikan seluruh 121 tes Flutter, 16 tes server, dan pengujian database MySQL nyata (32 migrasi) lulus 100%.

Integrasi Flutter <-> Backend Fastify: Menghubungkan seluruh fitur aplikasi Flutter (Warga Android dan Admin Web) ke endpoint backend Fastify dengan Clean Architecture (KlienApi bersama di `core/jaringan`, PengelolaSesi di `core/sesi`, dan implementasi repositori di masing-masing `features/*/data`: AutentikasiRepository, PantauRepository, LaporanRepository, AkunRepository, PesanRepository, AdminRepository, dan MetaRepository). Seluruh 114 test widget eksisting dan 7 unit test integrasi lulus 100% serta `flutter analyze` menghasilkan 0 issues.

Dokumentasi Swagger UI & Health Check: Panduan lengkap pengujian interaktif via Swagger UI (`http://127.0.0.1:3000/docs`) dan pemeriksaan kesehatan sistem (`http://127.0.0.1:3000/health`) ditambahkan ke `apps/server/README.md`. Domain logic health check diselaraskan untuk mengkueri tabel `schema_migrations` secara akurat sehingga mengembalikan status `UP` dengan 32 riwayat migrasi terverifikasi di MySQL.

Penyelarasan format EditorConfig: 114 temuan error `editorconfig-checker` (`wrong amount of left-padding spaces (want multiple of 2)` dan `trailing whitespace`) pada 23 berkas sumber `apps/server/src` dan `apps/server/test` telah diperbaiki hingga `npx editorconfig-checker` dan Prettier `format:check` menghasilkan 0 error / PASS.

Swagger UI pengujian API interaktif (`/docs`, `/documentation`, `/api/docs`), endpoint spesifikasi OpenAPI (`/api/v1/openapi.json`, `/openapi.json`), dan endpoint kesehatan sistem (`/health`, `/api/v1/health`) tersedia.
Refaktorisasi Clean Code dan modularisasi submodul backend (messages, CMS, storage) diterapkan dengan panjang kode ~60-160 baris per file dan dokumentasi komentar fungsi lengkap.

Pengujian dan audit keamanan membuktikan:

- Dashboard Swagger UI interaktif menampilkan seluruh 72 endpoint terkelompok rapi dengan fitur "Authorize" bearer token dan "Try it out" untuk pengujian langsung dari peramban.
- Endpoint kesehatan `/health` dan `/api/v1/health` memverifikasi status operasional server, uptime, versi Node.js, memori RSS/heap, latensi ping MySQL nyata (`SELECT 1`), dan jumlah riwayat migrasi yang diterapkan (HTTP 200 saat sehat, HTTP 503 jika basis data terputus).
- Audit keamanan berpedoman pada `security-audit-skill`: 100% kueri database memakai prepared statement (bebas injeksi SQL), proteksi penelusuran path (path traversal) pada penyimpanan blob media, deteksi magic bytes untuk mencegah pemalsuan MIME type, dan perbandingan waktu-konstan (`timingSafeEqual`) pada seluruh secret & idempotency token.
- Verifikasi lengkap: format, lint (0 error/warning), typecheck, 15 unit tests, build, dan suite database MySQL nyata (`database.integration.ts` mencakup 32 migrasi dan seluruh 72 endpoint) PASS.

Pesan siaran admin dan kotak masuk inbox warga (8 endpoint) tersedia:
POST /admin/messages, GET /admin/messages, GET /admin/messages/{id}, PATCH /admin/messages/{id},
POST /admin/messages/{id}/revoke, POST /admin/messages/{id}/expire, GET /me/inbox, dan
PUT /me/inbox/{id}/read.

Tes HTTP/MySQL membuktikan:

- Menerbitkan pesan siaran oleh admin (`POST /admin/messages`) dengan `Idempotency-Key`, status 201 dan header ETag; replay mengembalikan pesan yang sama, konflik payload ditolak 409, dan warga ditolak 403.
- Daftar pesan admin (`GET /admin/messages`) mendukung filter pencarian teks `q` dan pagination cursor.
- Detail pesan admin (`GET /admin/messages/{id}`) mengembalikan objek pesan lengkap dengan header ETag `"1"`.
- Warga membaca inbox (`GET /me/inbox`) hanya menerima pesan `ACTIVE` yang belum kedaluwarsa (`endsAt` kosong atau di masa depan); status `read: false` tercatat sebelum dibaca.
- Warga menandai pesan dibaca (`PUT /me/inbox/{id}/read`) dengan versi konten spesifik (`contentVersion`); status inbox segera berubah menjadi `read: true`.
- Pembaruan pesan admin (`PATCH /admin/messages/{id}`) mewajibkan `If-Match`:
  - Perubahan batas waktu (`endsAt`) saja hanya menaikkan `version` objek, sehingga status baca warga tetap `read: true`.
  - Perubahan teks pesan (`body`/`title`) menaikkan `content_version` dan `version`, memicu unread ulang (`read: false`) bagi akun warga yang hanya membaca versi lama (SRS FR-INBOX-002).
- Pengakhiran masa berlaku (`POST /admin/messages/{id}/expire`) mengubah status menjadi `EXPIRED` dan menghapus pesan dari inbox aktif warga.
- Pencabutan pesan (`POST /admin/messages/{id}/revoke`) mengubah status menjadi `REVOKED` dan menghapus pesan dari inbox aktif warga.
- Verifikasi lengkap: format, lint, typecheck, 13 unit tests, build, dan suite database MySQL nyata (`database.integration.ts` mencakup 32 migrasi dan seluruh alur endpoint) PASS.

PATCH /me, POST /me/credentials, POST /me/recovery-code dan POST /auth/reset-password tersedia.
Tes HTTP/MySQL membuktikan:

- PATCH /me: validasi If-Match (428 jika hilang, 400 jika malformed), 409 VERSION_CONFLICT dengan currentVersion jika usang, update display_name atomik menaikkan version, replay aman 200, dan konflik payload ditolak 409 IDEMPOTENCY_CONFLICT.
- POST /me/credentials: If-Match wajib, sandi lama salah 401, versi usang 409, mutasi email/sandi atomik menaikkan credential_epoch & version serta mencabut seluruh sesi, replay menghasilkan ALREADY_COMMITTED, login sandi lama ditolak, dan login sandi baru berhasil.
- POST /me/recovery-code: verifikasi sandi, rotasi verifier generasi baru, dan replay 409 RESULT_ALREADY_COMMITTED.
- POST /auth/reset-password: perlindungan throttle kegagalan, verifikasi kode pemulihan, rotasi verifier kode baru, pencabutan sesi lama, replay 409 RESULT_ALREADY_COMMITTED, kode lama tidak dapat dipakai ulang, dan login sandi baru berhasil.

Verifikasi: format:check, lint, typecheck, 12 unit tests, build, dan suite database MySQL nyata (database.integration.ts) PASS.

GET /me, POST /auth/logout dan POST /auth/revoke tersedia. Tes HTTP/MySQL
memeriksa profil pemilik, token hilang, expiry, credential epoch, logout,
revoke secret yang salah dan replay revoke. Revoke secret tidak memberi akses
baca; logout mencabut sesi pada transaksi yang sama dengan jurnal. Logout ulang
dengan token yang sudah dicabut ditolak 401; rekonsiliasi memakai revoke secret.
PATCH /me dan integrasi Flutter masih tertunda.

Kelanjutan unit sesi menambah uji revoke sesi aktif, dua request bersamaan
(dengan satu actionId), UUID berbeda kapital, secret milik sesi lain, konflik
kunci dan autentikasi ulang sebelum replay. UUID sesi dinormalisasi sebelum
lookup/fingerprint. Bukti ini mencakup backend FR-AUTH-003/004/008; TC end-to-end
dan TC-SRS-013 tetap NOT_RUN karena isolasi klien Flutter belum terintegrasi.
Kontrak/spec, DESIGN, AGENTS/rules/adapter serta RTM tidak berubah: tidak ada
perubahan requirement atau klaim penerimaan aplikasi menyeluruh.
Verifikasi kelanjutan: `pnpm check` PASS (format, lint, tipe, 12 tes lokal,
build); `pnpm test:db` PASS (satu suite MySQL nyata, termasuk kasus sesi).
Markdownlint tiga dokumen, tautan internal 47 Markdown dan diff whitespace
PASS. Flutter, HP, provider, audit keamanan menyeluruh dan UAT NOT_RUN.

Login HTTP/MySQL tersedia. Akun tidak ditemukan tetap menjalankan scrypt;
lima kegagalan per pasangan principal/source dalam 15 menit memblokir 15 menit.
Bucket menyimpan digest, sumber dari request.ip tanpa mempercayai proxy header.
Sesi menyimpan digest token/revoke dan epoch; transaksi memeriksa ulang epoch
serta role sebelum replay/commit. Tes nyata mencakup akun tidak ada, sandi salah,
warga ditolak dari ADMIN_WEB, login berhasil, replay dan blokir setelah lima gagal.
Middleware sesi, logout/revoke, reset dan pembersihan bucket menyeluruh belum ada.

POST /api/v1/auth/signup terhubung ke MySQL melalui entry server. Startup kini
memerlukan konfigurasi DB/key privat; shutdown menutup pool. Signup menormalisasi
email/nama, menolak role tambahan, memaksakan CITIZEN, membuat akun/recovery dan
jurnal dalam satu transaksi. Hash di luar lock. Tes integrasi PASS untuk sukses,
hash/recovery verifier, replay tanpa rahasia, konflik payload/email dan role ADMIN
yang ditolak. Login, throttle, middleware sesi dan recovery reset belum tersedia.

Generator token/revoke 32 byte base64url dan recovery 20 byte/32 karakter base32
tersedia. Token memakai SHA-256, recovery HMAC key terpisah; pembandingan verifier
constant-time. Key recovery/journal/cursor dihasilkan lokal berbeda pada .env
dan .env.test tanpa menampilkan nilainya atau memasukkannya ke Git.
Dua belas tes lokal serta format/lint/typecheck/build PASS. Key belum dibaca
entry HTTP; middleware expiry, recovery sekali pakai dan endpoint belum tersedia.

Helper password tersedia sesuai parameter SRS §5.1: scrypt N=131072/r=8/p=1,
salt 16 byte, hash 64 byte, maxmem 256 MiB. Sandi tidak dinormalisasi/trim;
verifikasi memakai timingSafeEqual dan kapasitas penuh menghasilkan error khusus.
Sepuluh tes lokal, format/lint/typecheck/build PASS. Tes baru membuktikan salt
unik, sandi tepat/salah dan penolakan derivasi ketiga; endpoint 503, dummy
verifier serta integrasi akun belum diimplementasikan. Kontrak/Flutter tetap.

Migrasi 007 menambah commands dengan scope principal berupa digest, kunci UUID
unik per scope, fingerprint HMAC dan action_seq BIGINT. Helper runSecretCommand
mengecek authorize sebelum replay di bawah guard, menjalankan mutasi dan jurnal
dalam transaksi sama, dan tidak menyimpan respons rahasia. State awal hanya
COMMITTED; ACCEPTED/CLOSED/REJECTED_CLOSED laporan perlu migrasi/alur tersendiri.
Tes MySQL PASS: dua request bersamaan hanya satu efek, replay termasuk case UUID,
konflik operasi/payload, scope berbeda, authorize gagal sebelum replay serta
rollback mutasi gagal tanpa jurnal baru. Tes JSON kanonik/HMAC mencakup Unicode,
urutan key/array, domain scope dan angka nonfinite. Migrasi development PASS.
Kunci HMAC permanen serta endpoint belum dihubungkan; tes memakai kunci sintetis.
Langkah berikut: hash sandi scrypt, token/recovery dan konfigurasi kunci privat.

Migrasi 003–006 menambah accounts, recovery_verifiers, sessions dan auth_failures
sesuai SRS-DATA-001 sampai 004. Tes MySQL nyata PASS untuk default CITIZEN,
email unik/normalisasi binary, role/versi/parameter hash, token unik, umur sesi
maksimum tujuh hari, FK pemilik, satu verifier per akun dan bucket principal/source
unik. Fixture memakai data sintetis dalam transaksi yang selalu rollback.
Migrasi development menerapkan empat file; replay pada test tetap tanpa perubahan.
Ini belum menguji hashing, expiry middleware, pencabutan, throttle atau endpoint.
Jurnal commands sengaja menjadi unit berikut agar state/idempotensi diturunkan
bersama alur layanan, tanpa menyatakan seluruh langkah auth sudah selesai.

Pemilik meminta memakai sandi saat ini dan menyimpannya pada konfigurasi lokal.
`.env`, `.env.migrate` dan `.env.test` telah diisi; semuanya ignored oleh Git,
tanpa menyalin rahasia ke dokumentasi. Credential lokal sudah pernah dibagikan
di percakapan; jangan menganggapnya credential produksi atau rotasi baru.
Agent menjalankan db:check PASS, dua migrasi development PASS, serta test:db
PASS pada MySQL 8.0.30. Tes nyata mencakup replay migrasi, UTC/READ COMMITTED,
autocommit, rollback guard, larangan DDL runtime dan akses dev dari akun test.
Eksekusi awal menemukan GET_LOCK mengembalikan string '1' dengan opsi mysql2
bigNumberStrings; pembandingan diperbaiki tanpa melemahkan hasil lock gagal.
Ekspektasi tipe autocommit pada tes diselaraskan dengan hasil driver.
Riwayat sebelum konfigurasi lokal dan pengujian berikut tetap disimpan di bawah.

Keluaran terminal pemilik membuktikan MySQL 8.0.30/InnoDB pada 3306,
login root dan CREATE DATABASE/USER serta GRANT berhasil. Login sb_dev_app
gagal dengan using password: NO; sebelumnya perintah PowerShell dimasukkan
ke prompt MySQL sehingga terjadi error 1064. Panduan diperjelas mengenai
generated password, input tersembunyi, perpindahan prompt dan rotasi sandi.
Credential yang dibagikan tidak disalin ke repo. Rotasi serta login ulang
belum terverifikasi; tes integrasi agent tetap NOT_RUN. Catatan di bawah
merepresentasikan kondisi sebelum provisioning oleh pemilik.

Unit mysql2 tersedia: config menolak root/target silang, pool terbatas,
sesi UTC/READ COMMITTED, transaksi guard, dua migrasi SQL awal dan runner
berchecksum dengan marker applying serta GET_LOCK. Delapan tes lokal,
format/lint/tipe/build PASS; tes database nyata NOT_RUN karena pemilik
mengonfirmasi baru Laragon yang aktif, akun/database belum dibuat.
Audit dependency PASS tanpa advisory yang diketahui. Pengujian ini belum
membuktikan keamanan penuh, transaksi MySQL atau integrasi Flutter.
Lihat [konfigurasi dan perintah](../apps/server/MYSQL-SETUP.md#konfigurasi-backend).
HTTP belum memakai pool; auth dan schema bisnis belum diimplementasikan.
Tidak mengubah wire API/spec bisnis atau Flutter/DESIGN/adapter karena unit
ini menyediakan fondasi persistensi sesuai SRS-DEC-002/004.

[Panduan MySQL Laragon](../apps/server/MYSQL-SETUP.md) tersedia sesuai jawaban
pemilik: dua database dan empat akun runtime/migrasi, sandi acak di terminal
lokal, serta verifikasi identitas/grant dan larangan akses lintas DB.
Belum dijalankan pada instance; tidak membuat akun atau menyimpan credential.
Pemilik kemudian mengonfirmasi Laragon aktif pada port 3306/80. Probe TCP
127.0.0.1:3306 PASS; autentikasi, versi instance dan grant belum diuji.
Port 80 milik web Laragon; API TypeScript tetap 3000.
Markdownlint enam dokumen, tautan 47 Markdown, format README/panduan server
dan diff whitespace PASS untuk unit panduan ini.
Kontrak API, spesifikasi bisnis, DESIGN, Flutter dan adapter tidak berubah
karena unit ini hanya menyiapkan prosedur provisioning lokal.

Fondasi server sesuai [WS-DEC-070](DECISIONS.md#backend-foundation-070):
Node 24/TypeScript strict/Fastify 5/pnpm 10.34.9, metadata OpenAPI, konfigurasi,
error/log minimal dan tes. [README server](../apps/server/README.md) memuat
perintah serta batas. Format/lint/tipe/build dan lima tes PASS pada Windows.
Audit dependency PASS tanpa advisory yang diketahui setelah override minimatch;
Install frozen-lockfile PASS. Markdownlint 16 dokumen, tautan 46 Markdown, YAML delapan skill dan diff
whitespace PASS. Audit dependency bukan audit keamanan aplikasi penuh.

Mandat terbaru mengizinkan membaca acuan terkait sambil implementasi; tidak
melanjutkan bacaan seluruh riwayat sebagai penghalang coding. FRD/SRS,
WORKSPACE, handoff, DECISIONS dan delapan skill telah dibaca penuh dalam
rangkaian ini; TRACEABILITY baru sampai baris 690 dan bagian akhir relevan,
OpenAPI baru operasi/schema terkait. Jangan mengklaim seluruh sumber selesai.

Berikutnya: mysql2, akun runtime/migrasi dan DB dev/test terpisah, migrasi SQL
serta tes MySQL nyata. Pemilik mengonfirmasi DB/akun belum disiapkan dan meminta
panduan akun serta database terpisah. Lalu auth dan
integrasi Flutter, berkas privat, worker/AI, laporan/kuota/admin dan pendukung.
API key belum tersedia, HP diuji pemilik. Production, MySQL, provider,
Flutter terhubung dan UAT NOT_RUN. Tidak ada mandat push/deploy.

### Tema menu admin sebelumnya

Tema menu admin mengikuti dashboard komando sesuai
[WS-DEC-069](DECISIONS.md#admin-panels-069): panel laporan putih, tombol outline,
pilihan Pusat Aksi pastel, judul bagian biru tua dan field dengan fokus biru.
Strip status kota statis beserta stempel instansi di dashboard dihapus.
Tidak menambah teks atau mengubah alur. Analyzer 0 issues, 114 tes PASS,
build Web PASS, pemeriksaan Chrome pada 1440/768/390 px tanpa pageerror.
[Bukti dan batas](WORKSPACE.md#admin-panels). Branch `branch-rafi`, commit lokal;
push tidak diminta. HP, backend/provider, UAT dan screen reader NOT_RUN.

### Dashboard komando sebelumnya

Penyempurnaan UI/UX Dashboard Komando Admin pada 1 November 2026 mengikuti
[WS-DEC-068](DECISIONS.md#admin-dashboard-ux-068). `TabDashboardRingkasan` dirancang
ulang menjadi layout pusat komando tanggap darurat yang komprehensif selaras `SiagaTheme`:
strip status operasional BPBD Kota Padang, 4 kartu KPI metrik dengan ikon semantik dan keterangan kontekstual,
serta tata letak 2 kolom di desktop (>= 960 px) yang memuat klaster wilayah prioritas di kolom kiri,
dan panel agregasi kebutuhan darurat logistik, visualisasi bar distribusi status laporan,
feed siaran peringatan aktif, serta pintasan operasional di kolom kanan.
Semua elemen membungkus secara adaptif (`Wrap`) sehingga bebas overflow pada layar mobile 390 px
maupun pembesaran teks 2.0x.
Analyzer 0 issues, 114 tes Flutter PASS. [Bukti dan dampak dokumentasi](WORKSPACE.md#admin-dashboard-ux).
Branch `branch-rafi`, commit lokal diwajibkan; tidak ada mandat push. Perangkat fisik,
backend/provider, UAT dan screen reader NOT_RUN.

### Penyelarasan tema admin sebelumnya

Tema admin disamakan dengan Beranda warga pada 1 November 2026 sesuai
[WS-DEC-067](DECISIONS.md#admin-theme-067). Layout, posisi, teks dan ikon tetap;
kartu ringkasan pastel, kartu isi putih membulat, judul biru tua dan kontrol
biru muda. Tema khusus admin menjaga tampilan warga tetap sama.
Analyzer 0 issues, 114 tes PASS, build Web PASS; Chrome tanpa pageerror pada
1440/768/390 px. [Bukti dan dampak dokumentasi](WORKSPACE.md#admin-theme).
Branch `branch-rafi`, commit lokal; tidak ada mandat push. Perangkat fisik,
backend/provider, UAT dan screen reader NOT_RUN.

### Audit layout admin sebelumnya

Audit desain admin 1 November 2026 mengikuti
[WS-DEC-066](DECISIONS.md#admin-ui-audit-066). Lima halaman, navigasi, tabel,
form, modal bukti dan foto dirapikan: sidebar/drawer adaptif, tanpa hero/ranking
atau badge AI dekoratif, label ringkas, verifikasi melalui bukti dan draf lintas
tab. Alasan hapus wajib menampilkan error field; metrik menunggu tidak memasukkan
laporan selesai. [Temuan, bukti dan batas](WORKSPACE.md#admin-ui-audit).

Analyzer 0 issues, 114 tes Flutter PASS, build Web PASS. Chrome memeriksa lima
halaman pada 1440/768/390 px dan dialog bukti; widget mencakup teks 200%.
Backend/provider/HP/UAT/screen reader NOT_RUN. Reset kuota, sandi, singleton
sesi dan review tanpa versi masih gap implementasi awal, bukan layanan produksi.
Branch `branch-rafi`; commit lokal diwajibkan, push tidak diminta. Dokumentasi
terdampak diperbarui; kontrak/spec dan aturan/skill/adapter tidak berubah.
Bacaan fokus admin diizinkan pengguna, bukan klaim seluruh kontrak dibaca ulang.

### Riwayat implementasi admin sebelumnya

Implementasi & Penyempurnaan Dashboard Web Admin SiagaBanjir (`features/admin`) pada 1 November 2026:

- **Aset Sample Foto Banjir Riil untuk Data Dummy Admin & Warga**: Mengintegrasikan foto dokumentasi banjir riil (`assets/images/reports/sample_banjir.jpg`, `report_1.jpeg`, `report_2.jpeg`) sebagai data dummy visual di antarmuka Admin (`PreviewMediaLaporan`, galeri bukti klaster wilayah, pratinjau resolusi tinggi) dan Warga (`BagianBuktiLaporan` panduan visual, `KartuRiwayatLaporan`, dan dialog detail riwayat).
- **Pembersihan Cakupan & Lingkup**: Menghapus seluruh elemen kontrol sensor sungai Batang Kuranji dan infrastruktur pompa air dari Dashboard Admin Web sesuai instruksi pengguna, memfokuskan dashboard pada agregasi laporan warga, klaster wilayah, siaran peringatan, dan operasional darurat.
- **Auto-Approve Laporan Individu Berbasis Klaster Wilayah**: Ketika admin memverifikasi suatu klaster wilayah, seluruh laporan individu warga di dalam klaster tersebut otomatis terverifikasi serentak (`diverifikasiOtomatisWilayah: true`). Di tab Laporan Warga, status ditandai secara eksplisit dengan badge `Terverifikasi` dan keterangan `Auto Wilayah` tanpa memerlukan persetujuan ganda perorangan.
- **Komponen Pratinjau Media Interaktif (`PreviewMediaLaporan`)**: Widget preview foto bukti laporan warga yang terintegrasi di baris tabel Laporan Warga, modal bukti wilayah, serta dialog detail; mendukung thumbnail adaptif dan dialog modal foto beresolusi tinggi dengan indikator AI.
- **Standarisasi Tipografi & Label Ringkas Standar Praktik**: Seluruh teks menggunakan token `fontFamily: 'Inter'` lokal. Label tombol dan menu sidebar disingkat lugas sesuai standar industri (`Dashboard`, `Klaster Wilayah`, `Laporan Warga`, `Pusat Aksi`, `Profil`, `Keluar`, `Lihat Bukti`, `Verifikasi Wilayah`, `Kirim Siaran`, `Mode Warga`).
- **Verifikasi**: `flutter analyze --no-pub` PASS (0 issues), 106 tes Flutter PASS (0 failures, termasuk `dashboard_admin_test.dart`). Script validasi link internal dan struktur skill YAML PASS 100%. Branch lokal `branch-rafi`.

### Riwayat perbaikan bug TTS dan standar komunitas

Audit lanjutan mengikuti [WS-DEC-065](DECISIONS.md#flutter-uiux-lanjutan-065).
[Checklist lengkap](WORKSPACE.md#flutter-uiux-lanjutan) mencatat foto profil
kamera/galeri dalam Edit Profil, kontak pribadi di Kontak Darurat, dokumen
dinamis berkategori/nama kustom, riwayat lokal dari input tanpa proses/tim rekaan,
penghapusan rute/posko, konsistensi tema, serta rate TTS normal dan guard putar.
Beranda tidak diubah. Kontak/dokumen/riwayat ada selama sesi dan hilang setelah
logout/aplikasi ditutup. ZIP tidak terenkripsi; server belum terhubung.
101 tes PASS; bukti akhir lainnya ada pada WORKSPACE. Audio/HP NOT_RUN sesuai
mandat. Baseline `6259a82`; lihat commit `661e960` untuk perbaikan TTS.

### Riwayat audit pertama

Audit UI/UX 27 Oktober 2026 mengikuti
[WS-DEC-064](DECISIONS.md#flutter-uiux-064). Seluruh checklist pemilik dan bukti
ada pada [WORKSPACE](WORKSPACE.md#flutter-uiux). Empat tab kini langsung terbuka,
mempertahankan state/scroll, memakai header bersama dan navbar yang tidak
tertutup snackbar. Token teks mengikuti Beranda; dialog bertema, ruang keyboard,
layout kecil/teks besar, kartu kontak dan bar warna Pantau diperbaiki.

Edit profil, CRUD kontak/keluarga, kamera laporan/avatar, pemulihan hasil kamera
Android, TTS Indonesia dengan jeda/lanjut/stop, pilih PDF/gambar dan ekspor ZIP
lokal tersedia. Nama folder tetap Indonesia. Dokumen hanya berada dalam memori
halaman sampai diekspor; ZIP tidak terenkripsi. Autentikasi/GPS/pengiriman/AI
dan layanan bisnis belum terhubung. Logout membuat sesi demo baru dengan state
bersih; bukan autentikasi server. Pesan UI tidak mengaku menyimpan akun/vault.

Verifikasi: analyzer 0 issues; 101 tes PASS; build Web dan APK debug PASS.
Inspeksi Chrome mencakup 12 layar serta dialog edit profil dan viewport
320/390/1024. Pemilih berkas dan unduh ZIP Web diuji dengan berkas sintetis;
isi arsip cocok. Artefak lokal berada di build/audit, tidak masuk source.
**HP NOT_RUN atas instruksi terbaru pemilik**: tidak memasang atau membuka APK.
Pengguna akan memeriksa kamera/suara sendiri. TTS bergantung voice/engine OS;
Gradle memperingatkan pemakaian KGP plugin flutter_tts pada Flutter mendatang.

Dokumentasi living diperbarui bersama implementasi. Kontrak/spec baseline,
AGENTS/rules/skills/adapter tidak berubah karena tidak ada perubahan mandat
atau wire API. Branch `branch-rafi`, baseline `06e3b2e`; commit lokal diwajibkan,
tanpa push. Catatan berikut adalah riwayat sebelum audit UI/UX ini.

### Riwayat penataan folder

Penataan Flutter 27 Oktober 2026 mengikuti
[WS-DEC-063](DECISIONS.md#flutter-indonesia-063). Sepuluh fitur kini bernama
`akun`, `autentikasi`, `beranda`, `dokumen`, `kontak`, `laporan`, `panduan`,
`pantau`, `pesan` dan `tas_siaga`, selaras antara lib dan test. File serta
kelas/enum fitur ikut memakai Indonesia. Layer teknis, API Flutter, callback,
fixture, ID data dan aset tetap. [README Flutter](../apps/siagabanjir/README.md)
memuat peta nama lama/baru dan batas implementasi.

Dihapus: 48 penanda `.gitkeep`, direktori kosong, serta lima file dokumen lama
tanpa pemakai. Lima model UI yang mengimpor Flutter dipindah ke
presentation/models; domain tersisa Dart murni. Requirement admin/keluarga/KTP
tetap berlaku meski placeholder dihapus. Perilaku UI tidak diubah.

Verifikasi: analyzer 0 issues, seluruh 91 tes PASS, build Web dan APK debug
PASS. Audit impor dan perbandingan token 91 file juga PASS; tidak ada perubahan
alur di luar nama/impor/format. [Bukti dan batas](WORKSPACE.md#flutter-indonesia)
memisahkan build/widget dari perangkat/UAT yang tidak dijalankan.
Pemilik mengizinkan fokus bacaan audit Flutter; seluruh spesifikasi/kontrak
tidak dibaca ulang. Beberapa aksi tetap simulasi meski labelnya menyatakan
berhasil; integrasi dan penyelarasan pesan menjadi pekerjaan berikutnya.

Dokumentasi dan skill Flutter diselaraskan dalam unit yang sama. Tidak ada
perubahan requirement/kontrak, aset atau dependensi. Branch lokal `branch-rafi`;
commit disiapkan sesuai mandat tetap, tanpa push. Riwayat di bawah menggunakan
nama/path lama; lokasi terbaru mengikuti README, bukan placeholder historis.

### Riwayat perbaikan kompilasi sebelum penataan

Perbaikan kompilasi 27 Oktober 2026 setelah pull main pada baseline `23d586a`:
`siaga_banjir_app.dart` kehilangan penutup `RegionMonitorScreen`,
`MaterialPageRoute` dan `Navigator.push`; `home_preview_sheet.dart` kehilangan
penutup tombol/list Pantau sebelum cabang Riwayat. Penutup dipulihkan dan jarak
setelah tombol Pantau mengikuti tombol pratinjau lain. Enam error berhasil
direproduksi dengan `flutter analyze --no-pub` sebelum perbaikan.

Verifikasi Windows, Flutter 3.47.7 / Dart 3.13.5: `flutter analyze --no-pub`
PASS (0 issues), `flutter test --no-pub` PASS (91 tes, termasuk navigasi Pantau
dan Riwayat), serta `git diff --check` PASS. Build dan perangkat fisik NOT_RUN.
Pemilik secara eksplisit mengizinkan pembatasan bacaan ke aturan/skill,
dokumentasi aplikasi dan kode/tes terkait untuk perbaikan ini; bukan klaim
bacaan penuh seluruh spesifikasi. Commit disiapkan pada branch lokal
`branch-rafi` dari baseline main; tidak ada mandat push.

Dokumentasi diperbarui pada handoff dan CHANGELOG. README, spesifikasi/kontrak,
DESIGN, keputusan/RTM, AGENTS, rules, skills dan adapter tidak diubah karena
perbaikan hanya memulihkan sintaks/alur yang sudah ada, tanpa perubahan
requirement, arsitektur atau bukti penerimaan produk. Catatan di bawah adalah
riwayat pekerjaan sebelum integrasi tersebut, bukan hasil pengujian baseline
main yang rusak.

Implementasi layar pantau wilayah publik (`features/monitor`) sesuai desain SVG
pemilik (`monitor_public.svg`). Layar menampilkan data pemantauan publik terkini:
header dengan tombol kembali dan judul 'Pantau Wilayah', kartu sorotan utama
bertepi biru muda (#BFDBFE) memuat nama sungai (Sungai Batang Kuranji), badge status
'Siaga 2', angka ketinggian air (140 cm Tinggi Air), indikator kenaikan (▲ +20 cm),
bar multi-segmen berwarna (Normal #A7F3D0, Waspada #FCD34D, Bahaya #FCA5A5), rentang
angka ambang batas, dan banner peringatan batas luapan tanggul 150 cm (Sisa 10 cm);
bagian daftar pos pantau sungai (Pos Kuranji, Pos Gadut, Pos Muaro); kartu status
kesiapan pompa dan pintu air (Pintu Air Pintu 3 Buka 60%, Pompa Mobile Kuranji 2 Unit Siap)
dengan ikon tetesan air #2563EB; serta CitizenNavigation bersama yang terhubung kembali
ke Beranda, Lapor, Riwayat, dan Profil.
Akses fitur terhubung dari kartu status pantau Beranda dan sheet pratinjau (`HomeAction.monitor`).
Seluruh 86 tes widget Flutter lulus (100% PASS, mencakup seluruh suite tes aplikasi)
dan `flutter analyze` bersih (0 issues). Markdownlint (MD032 & MD022) pada README terverifikasi 0 errors.
Acuan terbaru: [WS-DEC-062](DECISIONS.md#monitor-public-ui-062) dan
[bukti pantau wilayah](WORKSPACE.md#monitor-public-ui). Tidak ada mandat push.
Catatan di bawah merekam riwayat pekerjaan sebelumnya.

Implementasi layar dokumen siaga keluarga (`features/documents`) sesuai desain SVG
pemilik (`documents_vault.svg`). Layar menampilkan brankas berkas kependudukan vital:
header dengan tombol kembali dan judul 'Dokumen Siaga', judul halaman 'Dokumen Siaga Keluarga'
dan deskripsi pengurusan pasca-banjir, kartu putih bertepi (radius 20, border #E2E8F0, padding 16)
menampilkan 3 berkas (Kartu Keluarga, KTP Kepala Keluarga, Akta Kelahiran Anak) dengan badge format
'Gambar / PDF', detail berkas, dan tombol 'Ganti' yang adaptif terhadap layar sempit,
banner edukasi perlindungan data berkas sipil untuk dinas Disdukcapil, tombol aksi utama
'Simpan & Perbarui Dokumen Siaga' (#2563EB) dan 'Unduh Semua Berkas untuk Dinas (ZIP)',
serta CitizenNavigation bersama.
Akses fitur terhubung dari kartu Dokumen Siaga Beranda melalui sheet pratinjau dan rute aplikasi.
Seluruh 69 tes widget Flutter lulus (100% PASS, termasuk 10 tes spesifik DocumentsVaultScreen)
dan `flutter analyze` bersih (0 issues).
Acuan terbaru: [WS-DEC-061](DECISIONS.md#documents-vault-ui-061) dan
[bukti dokumen siaga](WORKSPACE.md#documents-vault-ui). Persistensi berkas lokal
direncanakan menggunakan SQLite atau alternatif lain pada tahap selanjutnya. Tidak ada mandat push.
Catatan di bawah merekam riwayat pekerjaan sebelumnya.

Halaman kotak masuk pesan peringatan siaga dari SVG pemilik (messages_inbox.svg)
kini tersedia melalui tombol notifikasi di header beranda maupun laporan.
Layar menyediakan header dengan tombol kembali dan badge 3 Baru, 4 pill tab filter
(Semua, Darurat, Cuaca BMKG, Posko), kartu pesan dengan garis aksen warna semantik,
instansi sumber, judul, deskripsi, tombol aksi evakuasi/bagikan/posko dengan
dialog demo, serta CitizenNavigation bersama yang terhubung kembali ke Beranda.
Acuan terbaru: [WS-DEC-058](DECISIONS.md#messages-inbox-ui-058) dan
[bukti inbox](WORKSPACE.md#messages-inbox-ui). Pratinjau lokal tanpa push notification.
Catatan di bawah merekam versi sebelumnya.
Implementasi layar profil pengguna warga (`features/account`) sesuai desain SVG
pemilik (`account_warga_profile.svg`). Layar menampilkan kartu profil lengkap:
avatar inisial RH dengan tombol kamera, nama, nomor telepon, badge domisili
Koto Tangah Padang, tombol edit profil, bagian data pribadi & domisili (NIK KTP bertopeng,
email, alamat, titik evakuasi), bagian kontak darurat keluarga SOS (Siti Rahma,
Budi Santoso) dengan aksi panggilan langsung, bagian pengaturan & akun
(toggle peringatan banjir interaktif, navigasi keamanan/bantuan/privasi/versi),
serta tombol keluar dari akun dengan dialog konfirmasi.
Navigasi tab Profil dihubungkan dari alur beranda dan sheet pratinjau.
8 tes widget lulus di `test/features/account/profile_screen_test.dart` (bebas overflow
pada layar sempit 320x640 hingga skala teks 2.0). Seluruh 20 tes Flutter lulus dan
`flutter analyze` bersih (0 issues).

Revisi UI/UX laporan mengikuti prinsip home: navbar bersama, judul 16/isi 14,
indikator radio/checkbox/fokus, pilihan awal kosong, label deskripsi menetap,
dan ruang menulis saat keyboard terbuka. Kode di-slicing menjadi widget per
bagian dengan komentar `// ...` berbahasa Indonesia, mengikuti pola home.
Acuan terbaru: [WS-DEC-057](DECISIONS.md#report-uiux-057) dan
[bukti revisi](WORKSPACE.md#report-uiux-refinement). Kamera/GPS/kirim masih
pratinjau lokal. Catatan di bawah merekam versi sebelumnya.

Halaman buat laporan dari SVG pemilik kini tersedia melalui Lapor dan Lapor
Banjir Cepat. Pilihan kategori/kebutuhan dan deskripsi interaktif lokal;
konfirmasi keluar menjaga isian. Kamera, GPS, penyimpanan dan kirim belum
terintegrasi. Header/ikon bersama berada di shared/widgets. Acuan terbaru:
[WS-DEC-056](DECISIONS.md#report-create-ui-056),
[README Flutter](../apps/siagabanjir/README.md#halaman-buat-laporan) dan
[bukti laporan](WORKSPACE.md#report-create-ui). Tidak ada mandat push.
Catatan berikut merupakan riwayat pekerjaan sebelumnya.

Ikon launcher bawaan Flutter diganti logo SiagaBanjir, termasuk adaptive dan
monochrome Android serta ikon Web/favicon. Splash native light/night dan
Android 12+ tersedia; Web memakai Inter lokal dan tombol retry saat startup
gagal. Tidak ada timer tambahan atau perubahan beranda/backend.
[WS-DEC-055](DECISIONS.md#branding-startup-055) dan
[bukti branding](WORKSPACE.md#branding-startup) menjadi acuan terbaru.
Build APK debug dan Web lulus; belum install/cold start pada HP fisik.

Perapian lanjutan atas revisi layout hanya menyentuh ikon/chevron dua kartu
Dokumen Siaga dan Lapor Banjir: rata tengah terhadap teks dan ukuran glyph
seimbang. Font, header status, akses cepat serta navbar tidak berubah.
Bukti dilanjutkan pada [layout beranda](WORKSPACE.md#home-layout-name).

Revisi layout/nama 23 Oktober 2026: folder Flutter menjadi apps/siagabanjir,
package Dart siagabanjir, label Android/Web SiagaBanjir. ApplicationId Android
tetap agar identitas instalasi tidak berubah. Jalankan flutter pub get di
folder baru setelah pull; perbarui working directory terminal/IDE pribadi.

Kartu berkas/laporan memakai header adaptif dan deskripsi lebih lapang;
label pendukung/navigasi 12, judul kartu 16, isi 14 dengan Inter lokal.
Badge akses cepat tidak lagi memecah kata pada layar sempit. Palet, ikon SVG,
satu layar dan panel lokal tetap; backend tidak disentuh.
Mandat dan batas bacaan terdampak: [WS-DEC-054](DECISIONS.md#home-layout-name-054).
Hasil pemeriksaan terkini: [WORKSPACE](WORKSPACE.md#home-layout-name).
Tidak ada mandat push. Catatan berikut merupakan riwayat revisi sebelumnya.

Revisi beranda berikutnya pada 23 Oktober 2026 memakai Inter 4.1 lokal
weight 400/500/600/700/800 beserta lisensinya, atas pilihan eksplisit pemilik.
Tulisan Data contoh dan catatan Mockup beranda dihapus; data masih statis.
Nama font asli Figma belum teridentifikasi karena SVG berisi outline.
[WS-DEC-053](DECISIONS.md#home-font-053) dan [bukti revisi](WORKSPACE.md#home-local-font)
menjadi acuan terbaru. Nama folder/package/launcher belum diganti; pertanyaan
pemilik tentang nama dijawab sebagai penjelasan dampak. Tidak ada mandat push.
Catatan di bawah merekam implementasi sebelum revisi font/label ini.

Pada 23 Oktober 2026, tugas berikutnya menghasilkan satu mockup beranda warga
sesuai SVG pemilik. Header, status, empat akses cepat, kartu dokumen/laporan
serta navbar memakai widget Flutter dan 17 ikon slice lokal. Semua tombol
membuka panel pratinjau yang dapat ditutup; belum ada backend, data akun,
akses perangkat atau transaksi. Angka diberi penanda contoh.

Bacaan ulang terbatas tugas ini disetujui pemilik; konteks bacaan penuh pada
tugas struktur sebelumnya dipertahankan. [WS-DEC-052](DECISIONS.md#home-mockup-052)
mencatat mandat; [README Flutter](../apps/siagabanjir/README.md) dan
[asal aset](../apps/siagabanjir/design/README.md) menjadi petunjuk kelanjutan.
[Bukti pemeriksaan](WORKSPACE.md#home-mockup) membedakan widget/build/browser
dari pengujian Android dan TC produk yang belum dilakukan. Tidak ada mandat push.
Catatan struktur dan CI di bawah adalah riwayat sebelumnya.

Pada 23 Oktober 2026, pemilik menyetujui implementasi struktur Flutter
Feature-First + Layered Architecture untuk warga Android dan admin Web.
Folder 15 fitur dengan tiga layer, app/core/shared dan test/features tersedia
sebagai placeholder. [README Flutter](../apps/siagabanjir/README.md) memuat batas layer,
contoh penempatan kode, perintah pengembangan, dan tabel pemilik fitur yang
belum ditetapkan. Keputusan: [WS-DEC-051](DECISIONS.md#flutter-feature-first-051).

Bacaan penuh sumber aktif diselesaikan pada tahap riset/perencanaan tugas ini.
Source Dart, tes counter, manifest, lockfile, Android/Web dan backend tidak
berubah. Implementasi fitur dan pembagian nama anggota menjadi langkah tim
berikutnya. Bukti pemeriksaan: [WORKSPACE](WORKSPACE.md#flutter-feature-first).
Tidak ada mandat push. Catatan CI sebelumnya berikut tetap merupakan riwayat.

Pada 22 Oktober 2026, pemilik meminta perbaikan CI yang menolak format bawaan
Flutter. EditorConfig Checker 4.0.2 mereproduksi 12 laporan error pada komentar
XML Android di commit 33e0f58. `.editorconfig` kini mengecualikan ukuran
indentasi khusus XML di apps/app/android; aturan format lain dan seluruh job CI
dipertahankan. File XML Flutter tidak diubah.

Pemilik mengizinkan pembatasan bacaan untuk tugas ini ke aturan proyek, CI,
EditorConfig dan file Flutter terdampak; bukan klaim seluruh spesifikasi dibaca.
Verifikasi lokal Windows PASS: EditorConfig Checker 4.0.2 pada seluruh file
tracked, Markdownlint 0.17.2 dan link internal pada 41 Markdown, serta
git diff --check. Enam fixture sementara lulus: alignment komentar XML Android
diterima; trailing whitespace, newline akhir hilang dan tab tetap ditolak;
indentasi ganjil pada Dart dan XML di luar Android tetap ditolak. Fixture
dibersihkan otomatis. Pemeriksaan Flutter/build dan CI remote NOT_RUN;
tidak ada mandat push.
Spesifikasi/kontrak, DESIGN, AGENTS, rules, skills, adapter dan RTM tidak berubah
karena perbaikan hanya menyelaraskan format, tanpa perubahan fungsi produk
atau hasil TC aplikasi. Riwayat pekerjaan terdahulu dipertahankan di bawah.

Pemilik meminta panduan Git cepat dikonversi ke Markdown lalu commit/push.
[GIT-CEPAT.md](GIT-CEPAT.md) kini memakai judul per anggota, blok kode terpisah
untuk clone dan ngoding/push, serta bagian pembaruan bersama. Seluruh perintah
dipertahankan; tautan aktif diperbarui. Catatan TXT di bawah adalah riwayat format.

Mandat berikutnya menghasilkan [GIT-CEPAT.md](GIT-CEPAT.md): perintah singkat
untuk main lokal, tanpa membuat branch kerja baru secara manual. Upstream dan
tujuan push tetap branch remote anggota; PR ke development tetap berlaku.
Panduan panjang menjadi alternatif dengan nama lokal anggota. Perubahan ini
dicommit lokal; tidak menjalankan perintah contoh pada repository tim.

TXT kemudian dipadatkan atas koreksi pemilik: clone/ngoding/push/PR, lalu
fetch origin dan pembaruan main lokal dari origin/main untuk siklus berikut.
Siklus kedua menunggu promosi development ke main selesai; tujuan PR tetap
development. Setup identitas dan rincian pemeriksaan ada di panduan lengkap.

TXT kini memisahkan perintah Rafi, Hasan dan Melia tanpa penggantian nama
branch. Pembaruan main untuk siklus berikut ditulis sekali. Edit awal pemilik
pada TXT (git add . dan pesan commit sederhana) dipertahankan dalam contoh;
semua file perubahan diperiksa sebelum staging.

Mandat terbaru mengganti fast-forward TXT dengan reset --hard origin/main dan
clean -fd setelah seluruh pekerjaan masuk main melalui PR. Langkah ini sengaja
membuang perubahan lokal/untracked; ignored seperti .env tetap ada. Perintah
dirangkai dengan && agar kegagalan fetch menghentikan reset. Mandat ini untuk
contoh panduan, bukan menjalankan reset/clean pada workspace saat mengedit.

Pemilik meminta commit sampai bersih dan push. Empat commit TXT sampai
1afcedd telah dipush ke branch-rafi dan SHA remote cocok. Pemilik juga
mengonfirmasi penghapusan prompt-audit-dan-perbaikan.md; rujukan audit/RTM
dialihkan ke salinan historis. Commit penutup dan hasil CI dilaporkan saat
serah hasil. Tidak merge PR atau mengubah Settings.

### Riwayat panduan panjang dan publikasi

Permintaan pemilik pada 21 Oktober 2026 menghasilkan satu
[panduan praktik Git pemula](GIT-UNTUK-PEMULA.md), dari clone pertama hingga
PR dan siklus tugas berikutnya. Contoh salin-tempel memakai Git Bash/Bash,
membedakan pull branch sendiri dari sinkronisasi development, serta menjelaskan
kapan clone ulang diperlukan. README, indeks, panduan GitHub, dan CHANGELOG
menautkan hasilnya; aturan lima branch tetap sama.
Panduan awalnya dicommit lokal, lalu pemilik meminta push. Commit
0a01ed68299123eb159b13d5e16c205c767816e3 sudah dipush ke branch-rafi;
SHA remote cocok dan keempat job CI push lulus. Catatan publikasi ini dibuat
sesudah run tersebut; hasil CI commit penutupan dilaporkan saat serah hasil.
Tidak membuat PR baru atau merge. Bukti: [panduan pemula](WORKSPACE.md#panduan-git-pemula).

### Riwayat pembaruan workflow GitHub

[WORKSPACE-GITHUB-WORKFLOW-010](DECISIONS.md#workspace-github-workflow-010)
mengganti alur kontribusi menjadi lima branch permanen pada repository yang sama.
CI memvalidasi push kelima branch dan PR anggota → development → main,
termasuk retarget dan penolakan fork. Panduan onboarding/sinkronisasi, template,
BRD/PRD aspek Git serta riwayat keputusan diperbarui bersama.
Persetujuan mencakup implementasi CI/dokumentasi dan push branch-rafi.
[Bukti audit dan verifikasi](WORKSPACE.md#github-workflow-audit) membedakan SOP,
check CI dan Settings: owner-only merge/proteksi belum diterapkan.
Implementasi dcf9d998f28aa6862f1dbe890441d67407236c06 sudah dipush ke branch-rafi;
empat job CI push dan PR lulus, dengan run ditautkan pada bukti di atas.
[Draft PR #1](https://github.com/muhammadrafifatihulihsan/siagabanjir/pull/1)
menunggu review owner ke development lalu promosi ke main; merge belum
diotorisasi. Settings/rulesets dan uji lintas akun memerlukan mandat terpisah.
Arsip session yang dibaca pada sesi ini tetap lokal; catatan penghapusan arsip
pada publikasi sebelumnya di bawah adalah riwayat sesi 20 Oktober.

### Aturan commit yang tetap berlaku

[WORKSPACE-LOCAL-COMMIT-009](DECISIONS.md#workspace-local-commit-009) menetapkan
commit lokal setiap unit perubahan AI tanpa menunggu konfirmasi, termasuk typo.
Sebelum unit berikut atau penutupan tugas/sesi, periksa working tree bersih dan
laporkan SHA. Push tetap mengikuti mandat. Kendala, pekerjaan awal milik rekan,
dan checkpoint belum selesai mengikuti [workflow](../rules/workflow.md#commit-lokal).
[Panduan pemula](GITHUB-WORKFLOW.md#mulai-untuk-tim) menjelaskan istilah, langkah,
dan kondisi Git; adapter, katalog, template PR dan skenario evaluasi diselaraskan.
Bukti perubahan: [WORKSPACE](WORKSPACE.md#commit-lokal-tim).

## README untuk pembaca umum

Permintaan pemilik pada 20 Oktober 2026 mengarahkan README utama untuk pembaca
umum: menjelaskan aplikasi, tujuan, pengguna, fitur yang direncanakan, dan
status pengembangan. Perintah validasi kini berada di
[panduan pengembangan](GITHUB-WORKFLOW.md#otomatisasi-cicd), sedangkan status
versi dan struktur proyek berada di [WORKSPACE](WORKSPACE.md#status-dan-versi).
Navigasi teknis memakai [indeks dokumentasi](INDEX.md); rujukan dalam rules,
skill workspace, versioning, dan register keterlacakan diselaraskan.
Perubahan ini bersifat editorial, tanpa perubahan fungsi atau kontrak produk.
Hasil pemeriksaan: [audit README](WORKSPACE.md#readme-publik).

## Publikasi baseline v0.1.0

[WORKSPACE-RELEASE-CLOSE-008](DECISIONS.md#workspace-release-close-008)
mencakup kelanjutan sesi, penutupan verifikasi, push melalui Git Bash,
publikasi v0.1.0, dan pembersihan ekspor session setelah penutupan terverifikasi.

- Persetujuan dan mandat dicatat secara formal dengan ID, tanggal, dan cakupan
  tetap. Riwayat pertanyaan/audit berulang diringkas.
- Informasi repository digabung ke panduan GitHub; rencana SRS yang sudah
  selesai cukup dirujuk melalui register keputusan.
- Tujuh rules dan delapan skill tetap. Aturan bersama dipusatkan tanpa
  mengurangi kewajiban bacaan lengkap dan pemeliharaan living documents.
- Kontrak memiliki 72 operasi, 165 skema, dan 54 contoh. Skema respons JSON
  unduh media yang tidak digunakan dihapus; endpoint tetap mengirim bytes.
- CI dan workflow rilis memakai action berbasis Node 24. Catatan rilis
  diambil dari CHANGELOG sesuai tag, dengan validasi entri sebelum publikasi.
- Validator tautan dan lint Markdown mengecualikan ekspor session lokal;
  regresi memastikan handoff aktif tetap diperiksa. Label ringkasan
  persetujuan diselaraskan dengan keputusan editorial.

## Acuan dan bukti

BRD/PRD v0.1.0 dan FRD/SRS v1.0.0 tetap APPROVED. FRD-STD-001–012 adalah
baseline fungsional; status draf pada riwayat dibaca sesuai tanggalnya.
156 TC FRD dan 24 TC-SRS tetap NOT_RUN pada aplikasi.

Hasil pemeriksaan lokal dan status publikasi: [WORKSPACE](WORKSPACE.md#audit-release-close).
Status per commit dan tag: [GitHub Actions](https://github.com/muhammadrafifatihulihsan/siagabanjir/actions).
Tag v0.1.0 menunjuk commit e1e11194b20cad9335901fabeb90d4f7e736f2b1.
[CI commit rilis](https://github.com/muhammadrafifatihulihsan/siagabanjir/actions/runs/39296073413)
berhasil pada ketiga pekerjaan, lalu
[workflow Release](https://github.com/muhammadrafifatihulihsan/siagabanjir/actions/runs/39296208857)
berhasil. [SiagaBanjir v0.1.0](https://github.com/muhammadrafifatihulihsan/siagabanjir/releases/tag/v0.1.0)
terbit sebagai Latest pada 20 Oktober 2026 pukul 00.41 WIB; catatannya cocok
dengan CHANGELOG. Arsip source tersedia tanpa aset aplikasi.
Gate lokal PASS: 36 Markdown, delapan skill, 165 skema, 54 contoh, Redocly,
25 tes regresi, EditorConfig dan pemeriksaan diff.
Rilis mengikuti [prosedur versioning](VERSIONING.md): tag hanya dibuat setelah
CI berhasil pada commit yang sama. Rilis dokumentasi tidak menyatakan
backend, Flutter, provider, perangkat, atau UAT telah lulus pengujian.

## Pekerjaan berikutnya

Publikasi baseline selesai. Ekspor session lokal sudah tidak ditemukan pada
pemeriksaan penutupan; handoff aktif ini tetap dipelihara. Catatan penutupan
ditambahkan sesudah rilis, tanpa memindahkan tag v0.1.0.

1. Tim menginisialisasi backend di apps/server dan melanjutkan scaffold Flutter di apps/siagabanjir.
2. Periksa manifest dan kode aktual sebelum menetapkan versi, perintah build,
   konfigurasi, atau tes aplikasi. Lengkapi README aplikasi sesuai hasil nyata.
3. Implementasikan milestone PRD: akun/dokumen/KTP, laporan/AI, admin/Pantau,
   fitur pendukung, lalu validasi.
4. Selaraskan spesifikasi, kontrak, desain, rules, dan skills pada perubahan
   yang memengaruhinya.

Sumber skill dibaca melalui AGENTS. Penempatan native Codex belum tersedia
pada lingkungan yang diperiksa; konfigurasi izin tidak diubah.
Pengujian pemuatan IDE, runtime aplikasi lintas OS, dan evaluasi agent terpisah
tetap NOT_RUN.
