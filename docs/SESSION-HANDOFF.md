# Status pekerjaan SiagaBanjir

> **Living document:** perbarui bersama setiap perubahan terkait menurut [aturan dokumentasi](../rules/documentation.md#living-documents).

Kondisi baseline **v0.1.0 — 20 Oktober 2026; Release telah terbit**.
Repository menyediakan spesifikasi dan panduan kerja. Tim sudah membuat scaffold
Flutter Android/Web di apps/siagabanjir; apps/server masih berisi penanda kosong.

## Perubahan terakhir

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
