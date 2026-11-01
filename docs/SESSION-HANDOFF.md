# Status pekerjaan SiagaBanjir

> **Living document:** perbarui bersama setiap perubahan terkait menurut [aturan dokumentasi](../rules/documentation.md#living-documents).

Kondisi baseline **v0.1.0 — 20 Oktober 2026; Release telah terbit**.
Repository menyediakan spesifikasi dan panduan kerja. Tim sudah membuat scaffold
Flutter Android/Web di apps/siagabanjir; apps/server kini memiliki fondasi HTTP.

## Checklist progres backend dan integrasi

Checklist ini adalah checkpoint aktif; catatan kronologis di bawah menyimpan
kondisi lama. Centang hanya setelah implementasi dan pemeriksaan terkait lulus.
Checkpoint kode sebelum unit jurnal: `94890d3`, branch `branch-rafi`, commit lokal tanpa
push. Sembilan tes lokal dan satu tes integrasi MySQL PASS; bukan kelulusan UAT.

- [x] Fondasi TypeScript/pnpm/Fastify, metadata OpenAPI, error/log minimal.
- [x] MySQL Laragon 8.0.30, database dev/test dan akun runtime/migrasi terpisah.
- [x] Konfigurasi env privat tersimpan lokal dan diabaikan Git.
- [x] Pool, migrasi guard, checksum/lock serta tes rollback dan batas akses awal.
- [x] Schema akun, verifier pemulihan, sesi dan bucket kegagalan; tes constraint MySQL.
- [x] Jurnal respons rahasia auth: mutasi atomik, konflik/replay dan concurrency MySQL.
- [ ] Integrasi jurnal ke endpoint; state machine submission/close untuk laporan.
- [ ] Autentikasi backend sesuai SRS-FR-AUTH-001 sampai 008 dan OpenAPI.
- [ ] Integrasi autentikasi Flutter warga/admin dan isolasi state lintas akun.
- [ ] Berkas privat, KTP/KK, keluarga, ownership serta lifecycle penghapusan.
- [ ] Worker MySQL dan DeepSeek, retry/lease serta penolakan hasil terlambat.
- [ ] Laporan, lokasi, idempotensi, kuota dan pengelompokan atomik.
- [ ] Operasi admin, Pantau publik, konten, inbox dan fitur pendukung.
- [ ] Integrasi seluruh alur Flutter dengan API nyata dan regresi lintas peran.
- [ ] Audit keamanan aplikasi menyeluruh, uji beban, UAT dan persiapan deployment.

### Unit berikut: autentikasi backend

Urutan unit kecil; setiap unit selesai wajib diperiksa dan dicommit bersama
dokumentasi terdampak sebelum berpindah ke unit berikutnya:

1. Schema akun/sesi, credential epoch, recovery verifier dan bucket throttle
   sudah tersedia dan diuji. Helper jurnal respons rahasia sesuai SRS-IF-004
   sudah diuji; integrasi endpoint dan algoritme throttle belum diimplementasikan.
2. Implementasikan hash sandi scrypt, token sesi acak/verifier dan pemulihan
   dengan batas concurrency; jangan simpan password/token mentah di database.
3. Signup warga, login, middleware sesi/role, profil dan logout/revoke sesuai
   kontrak; role ADMIN tidak boleh diberikan lewat signup publik.
4. Reset/rotasi recovery, perubahan credential dan pencabutan semua sesi secara
   atomik; ikuti idempotensi respons rahasia serta pembatasan percobaan.
5. Siapkan dua akun admin demo tanpa credential baku di repo; uji API/MySQL
   nyata untuk sesi kedaluwarsa/dicabut, role, konflik dan akses lintas akun.

Endpoint auth belum diimplementasikan. Bukti kelulusannya harus ditambahkan setelah
eksekusi; kredensial provider DeepSeek belum tersedia, pengujian HP oleh pemilik,
dan hosting belum dipilih. Push/deploy tidak termasuk mandat commit lokal.

## Perubahan terakhir

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
