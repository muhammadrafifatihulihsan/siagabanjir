# Persiapan MySQL Laragon lokal

> **Living document:** perbarui bersama setiap perubahan terkait menurut [aturan dokumentasi](../../rules/documentation.md#living-documents).

Pemilik mengonfirmasi database dan akun belum disiapkan. Panduan ini menyiapkan
prasyarat unit mysql2/migrasi; belum dijalankan terhadap instance MySQL.
Pemilik kemudian mengonfirmasi Laragon aktif pada 3306/80. Probe TCP ke
127.0.0.1:3306 berhasil; login dan versi instance belum diverifikasi.
Port 80 adalah web Laragon, sedangkan API TypeScript tetap memakai 3000.
Tidak memerlukan perubahan konfigurasi global atau instalasi MySQL baru.
API metadata saat ini tetap berjalan tanpa database.

## 1. Periksa instance

Buka Laragon 6 dan aktifkan MySQL. Pastikan pilihan versi adalah MySQL 8.0,
bukan MariaDB. Binary 8.0.30 ditemukan sebelumnya pada mesin ini; versi binary
tidak membuktikan versi layanan yang sedang berjalan. Gunakan terminal lokal
PowerShell, dari root repository:

```powershell
$mysqlClient = 'C:\laragon\bin\mysql\mysql-8.0.30-winx64\bin\mysql.exe'
& $mysqlClient --protocol=TCP --host=127.0.0.1 --port=3306 --user=root --password
```

Sesuaikan path/port dengan pilihan Laragon jika berbeda. `--password` meminta
sandi secara interaktif; jangan menulis sandi pada argumen command atau chat.
Jika root memang belum memiliki sandi pada instalasi lokal, tekan Enter pada
prompt. Jangan mereset sandi atau mengubah plugin autentikasi untuk memaksa login.
Root hanya dipakai untuk provisioning oleh pemilik, tidak oleh API/worker.

Di prompt MySQL jalankan:

```sql
SELECT VERSION() AS version, @@port AS port, @@hostname AS server_host,
       @@default_storage_engine AS storage_engine;
SHOW DATABASES LIKE 'siagabanjirdev';
SHOW DATABASES LIKE 'siagabanjirtest';
SELECT User, Host FROM mysql.user
WHERE User IN ('sb_dev_app', 'sb_dev_migrate', 'sb_test_app', 'sb_test_migrate');
```

Harus MySQL 8.0/8.4 dan InnoDB sesuai SRS-DEC-002. Jika nama database atau akun
sudah ada, berhenti sebelum langkah 2 dan periksa kepemilikannya; jangan drop
atau menimpa. Jika koneksi gagal, catat pesan error tanpa credential. Panduan ini
mengasumsikan port 3306 hanya sebagai nilai awal yang harus diverifikasi.

## 2. Buat database dan akun

Nama database sengaja tanpa underscore untuk menghindari wildcard pada grant
database MySQL. Akun hanya untuk host loopback `127.0.0.1`, bukan `%`.
Empat sandi acak berbeda akan ditampilkan oleh MySQL: simpan langsung di
password manager lokal, jangan screenshot, redirect output, atau kirim ke chat.
Jalankan satu per satu; jika ada kegagalan, jangan mengulang seluruh blok.
DDL akun/database tidak dibungkus transaksi rollback.

```sql
CREATE DATABASE siagabanjirdev
  CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
CREATE DATABASE siagabanjirtest
  CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

CREATE USER 'sb_dev_app'@'127.0.0.1'
  IDENTIFIED WITH caching_sha2_password BY RANDOM PASSWORD;
CREATE USER 'sb_dev_migrate'@'127.0.0.1'
  IDENTIFIED WITH caching_sha2_password BY RANDOM PASSWORD;
CREATE USER 'sb_test_app'@'127.0.0.1'
  IDENTIFIED WITH caching_sha2_password BY RANDOM PASSWORD;
CREATE USER 'sb_test_migrate'@'127.0.0.1'
  IDENTIFIED WITH caching_sha2_password BY RANDOM PASSWORD;

GRANT SELECT, INSERT, UPDATE, DELETE
  ON siagabanjirdev.* TO 'sb_dev_app'@'127.0.0.1';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, ALTER, INDEX, REFERENCES
  ON siagabanjirdev.* TO 'sb_dev_migrate'@'127.0.0.1';
GRANT SELECT, INSERT, UPDATE, DELETE
  ON siagabanjirtest.* TO 'sb_test_app'@'127.0.0.1';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, ALTER, INDEX, REFERENCES
  ON siagabanjirtest.* TO 'sb_test_migrate'@'127.0.0.1';
```

Runtime hanya DML pada satu database. Migrator mendapat tambahan DDL untuk
migrasi awal; tidak mendapat DROP, FILE, SUPER, CREATE USER, GRANT OPTION atau
hak global. Migrasi destruktif kelak perlu telaah khusus dan hak terbatas
sesuai perubahan; jangan memberi ALL PRIVILEGES sebagai jalan pintas.
Tidak perlu FLUSH PRIVILEGES setelah CREATE USER/GRANT.

## 3. Verifikasi batas akun

Keluar dari root dengan `exit`, lalu login runtime development:

```powershell
& $mysqlClient --protocol=TCP --host=127.0.0.1 --port=3306 --user=sb_dev_app --password --database=siagabanjirdev
```

Jalankan:

```sql
SELECT CURRENT_USER(), DATABASE();
SHOW GRANTS;
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
SET SESSION time_zone = '+00:00';
SELECT @@session.transaction_isolation, @@session.time_zone;
USE siagabanjirtest;
```

Identitas efektif harus `sb_dev_app@127.0.0.1`, database `siagabanjirdev`,
isolasi READ-COMMITTED dan zona +00:00. `USE siagabanjirtest` **harus ditolak**
dengan access denied. Jika berhasil, hak akses terlalu luas dan setup belum
lulus. SHOW GRANTS boleh menyertakan USAGE global; USAGE tidak memberi hak data.
Tidak boleh ada role/hak tambahan yang membuka database lain.

Ulangi login dan pemeriksaan berikut untuk tiga akun lainnya:

| Akun            | Database login  | Database yang harus ditolak oleh USE |
| --------------- | --------------- | ------------------------------------ |
| sb_dev_migrate  | siagabanjirdev  | siagabanjirtest                      |
| sb_test_app     | siagabanjirtest | siagabanjirdev                       |
| sb_test_migrate | siagabanjirtest | siagabanjirdev                       |

Periksa SHOW GRANTS terhadap daftar hak langkah 2. Jangan menguji DROP/DELETE
pada data pengguna. Tes DML, rollback dan constraint dilakukan kelak melalui
migrasi/fixture sintetis di database test. SET SESSION di atas hanya berlaku
untuk koneksi terminal; pool mysql2 wajib mengatur ulang sesi saat implementasi.

## 4. Serah-terima tanpa rahasia

Laporkan hanya versi MySQL, host/port, nama database, dan hasil login/grant/
penolakan lintas database. Jangan kirim sandi atau keluaran CREATE USER.
Simpan credential migrator terpisah dari credential runtime menggunakan
konfigurasi berikut; jangan menaruh sandi pada `.env.example`, kode atau commit.

<a id="konfigurasi-backend"></a>

## 5. Konfigurasi privat dan migrasi

Dari `apps/server`, salin `.env.example` menjadi `.env` dan isi DB_PASSWORD
melalui editor lokal. `db:check` hanya menggunakan sb_dev_app. Untuk migrasi,
buat `.env.migrate` sendiri berisi:

```dotenv
NODE_ENV=development
DB_HOST=127.0.0.1
DB_PORT=3306
DB_NAME=siagabanjirdev
MIGRATION_DB_USER=sb_dev_migrate
MIGRATION_DB_PASSWORD=
```

Isi sandi migrator lokal. Semua `.env`/`.env.*` privat diabaikan Git;
`.env.example` tetap template publik tanpa sandi. Jangan masukkan credential
migrator ke konfigurasi runtime. Jalankan:

```powershell
npx.cmd --yes pnpm@10.34.9 db:check
npx.cmd --yes pnpm@10.34.9 db:migrate
```

Migrasi menggunakan file SQL berurutan pada `migrations/`, satu pernyataan
per file, serta checksum SHA-256 dengan EOL dinormalisasi. GET_LOCK mencegah
dua runner pada DB yang sama berjalan bersamaan. Riwayat berstatus applying
ditulis sebelum SQL: karena DDL MySQL implicit commit, kegagalan tidak dijanjikan
rollback seluruh migrasi. Jika terputus, runner berhenti pada eksekusi ulang.
Periksa `schema_migrations` dan struktur aktual bersama maintainer; jangan
menghapus marker, mengedit file lama atau mengulang SQL secara buta.
Migrasi baru harus ditambahkan sebagai file berikutnya.

Saat ini hanya `business_write_guard` dan satu row id=1 yang disiapkan sesuai
SRS-DEC-004. Tabel akun, laporan dan job belum dibuat. HTTP belum membuka pool
database; utilitas ini akan dihubungkan bersama implementasi auth.

Untuk tes nyata buat `.env.test` lokal:

```dotenv
NODE_ENV=test
DB_HOST=127.0.0.1
DB_PORT=3306
DB_NAME=siagabanjirtest
DB_USER=sb_test_app
DB_PASSWORD=
MIGRATION_DB_USER=sb_test_migrate
MIGRATION_DB_PASSWORD=
```

Isi kedua sandi test lalu jalankan `npx.cmd --yes pnpm@10.34.9 test:db`.
Runner menolak lingkungan selain test, akun selain nama/peran yang ditetapkan,
dan target development. Tes menerapkan migrasi pada DB test, memeriksa replay,
UTC/READ COMMITTED, rollback guard, larangan DDL runtime dan akses lintas DB.
Tidak melakukan drop/reset database. Jalankan saat DB test tidak dipakai proses
lain. Kegagalan credential menghasilkan FAIL, bukan skip/PASS palsu.

Pool dibatasi empat koneksi dan antrean 16; setiap checkout menyiapkan UTC,
READ COMMITTED dan lock wait lima detik. Koneksi yang gagal dibuang agar state
transaksi tidak bocor ke peminjam berikut. Mutasi bisnis mengambil guard dahulu;
callback transaksi tidak boleh melakukan hash/media/panggilan provider.

Status saat panduan dibuat: **provisioning, koneksi, grant dan tes transaksi
NOT_RUN**. Database terpisah mencegah tes memakai data development, tetapi
tidak menggantikan backup atau kontrol akses produksi. Tidak ada perubahan
firewall, bind-address global atau akses LAN dalam langkah ini.

Rujukan primer: [manajemen akun MySQL](https://dev.mysql.com/doc/refman/8.0/en/creating-accounts.html),
[password acak](https://dev.mysql.com/doc/refman/8.0/en/password-management.html),
dan [cakupan GRANT](https://dev.mysql.com/doc/refman/8.0/en/grant.html).
Kembali ke [README server](README.md).
