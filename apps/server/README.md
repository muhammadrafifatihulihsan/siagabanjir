# Server SiagaBanjir

> **Living document:** perbarui bersama setiap perubahan terkait menurut [aturan dokumentasi](../../rules/documentation.md#living-documents).

Fondasi lokal Node 24, TypeScript strict dan Fastify 5. Implementasi saat ini
hanya `GET /api/v1/meta` dari [OpenAPI](../../docs/openapi.json), konfigurasi,
error terstruktur dan log minimal. Respons metadata bukan bukti kesiapan DB,
worker, autentikasi, fitur bisnis atau deployment.

## Menjalankan

Dari folder `apps/server`, gunakan Node >=24.15.0 <25 dan pnpm 10.34.9.
Versi dependency persis tersedia pada package.json dan pnpm-lock.yaml.
TypeScript 5.9.3 dipilih dalam rentang dukungan typescript-eslint; tidak
mengambil major TypeScript terbaru yang belum didukung linter ini.

```sh
npx --yes pnpm@10.34.9 install --frozen-lockfile
npx --yes pnpm@10.34.9 check
npx --yes pnpm@10.34.9 start
```

PowerShell dapat memakai `npx.cmd` bila kebijakan mesin menolak `npx.ps1`.
Tidak perlu instalasi global atau perubahan PATH. `start` memerlukan `build`
yang sudah dijalankan oleh `check`. `dev` menjalankan source dengan watch.
Hentikan proses menggunakan Ctrl+C. API default di `http://127.0.0.1:3000`.

Salin `.env.example` menjadi `.env` hanya jika ingin mengganti konfigurasi;
default cukup untuk metadata lokal. `.env` diabaikan Git. Konfigurasi invalid
menghentikan startup tanpa mencetak nilainya.

| Variabel  | Default dan batas                                     |
| --------- | ----------------------------------------------------- |
| NODE_ENV  | development; hanya development/test pada unit fondasi |
| HOST      | 127.0.0.1; alternatif ::1, loopback saja              |
| PORT      | 3000; integer 1–65535                                 |
| LOG_LEVEL | info; info/warn/error/silent                          |

Saat ini belum dapat diakses langsung dari HP atau origin Flutter Web berbeda.
Konfigurasi jaringan/TLS/CORS dan production akan ditambahkan bersama integrasi;
nilai production sengaja ditolak sampai kontrol tersebut tersedia.

## Struktur dan pemeriksaan

`src/app.ts` merakit HTTP tanpa membuka socket; `src/server.ts` menjalankan
proses dan shutdown. `src/http` berisi metadata/error; `src/config.ts`
memvalidasi environment. `src/db` menyediakan konfigurasi mysql2, pool,
transaksi dengan guard dan runner migrasi. HTTP metadata belum memakai DB.

| Perintah pnpm           | Tujuan                                                                 |
| ----------------------- | ---------------------------------------------------------------------- |
| format / format:check   | Tulis/periksa format Prettier                                          |
| lint                    | ESLint dengan pemeriksaan berbasis tipe                                |
| typecheck               | TypeScript tanpa emit, termasuk tes                                    |
| test                    | node:test + Fastify inject, validasi OpenAPI dan socket loopback nyata |
| build                   | Emit JavaScript ke dist                                                |
| check                   | Format, lint, tipe, tes lalu build                                     |
| audit --audit-level low | Advisory dependensi runtime dan pengembangan                           |

Perintah `db:check`, `db:migrate` dan `test:db` tersedia setelah provisioning;
ikuti [konfigurasi privat dan migrasi](MYSQL-SETUP.md#konfigurasi-backend).
Tes MySQL sengaja terpisah dari `check`, bukan dianggap lulus saat credential
belum tersedia. Migrasi 001–007 menyediakan guard dan tabel akun, recovery,
sesi, bucket kegagalan serta commands. Helper jurnal khusus respons rahasia
tersedia; endpoint auth dan state machine laporan menyusul.

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

Helper keamanan menyediakan scrypt, token/revoke acak, recovery base32 dan
verifier digest/HMAC. Key RECOVERY_HMAC_KEY, JOURNAL_HMAC_KEY, CURSOR_HMAC_KEY
berformat hex 64 karakter dan wajib berbeda. Nilai lokal ada di .env/.env.test,
tidak masuk Git; entry HTTP belum menggunakannya. Pertahankan key antar-restart;
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
adalah hashing, konfigurasi key dan integrasi HTTP auth. DB/akun sudah dibuat; konfigurasi privat
lokal tersedia dan koneksi serta tes transaksi awal sudah diperiksa.
Jangan menjalankan API memakai root.
Ikuti [panduan persiapan MySQL](MYSQL-SETUP.md) untuk provisioning lokal
dan pemeriksaan hak akun tanpa membagikan sandi.
Lalu auth, berkas privat, worker DeepSeek, laporan/kuota, admin dan fitur
pendukung mengikuti [SRS](../../docs/SRS.md) serta mandat terbaru pada
[WS-DEC-070](../../docs/DECISIONS.md#backend-foundation-070).
