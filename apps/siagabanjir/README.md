# Flutter SiagaBanjir

> **Living document:** perbarui bersama setiap perubahan terkait menurut [aturan dokumentasi](../../rules/documentation.md#living-documents).

Satu package Flutter untuk Android warga dan Web admin memakai
**Feature-First + Layered Architecture**: kelompokkan kode berdasarkan fitur,
lalu pisahkan tanggung jawab di dalam fitur.

Status 25 Oktober 2026: aplikasi membuka beranda warga, halaman buat laporan,
dan kotak masuk peringatan siaga sesuai SVG pemilik. Fitur `home`, `reports`
dan presentation `messages` memiliki UI lokal; layer bisnis dan fitur lainnya
masih placeholder. Belum ada integrasi API, sesi, kamera, GPS atau penyimpanan data.
Backend tidak termasuk pekerjaan ini.

## Struktur

```text
lib/
  main.dart
  app/
  core/
    network/
    storage/
    session/
    errors/
  shared/
    widgets/
    theme/
  features/
    <nama_fitur>/
      presentation/
      domain/
      data/
test/
  features/
    home/
      home_screen_test.dart
```

`<nama_fitur>` adalah notasi contoh; nama sebenarnya ada pada tabel berikut.
Setiap fitur produk memiliki tiga folder layer; `home` hanya membutuhkan
presentation untuk mockup saat ini. `.gitkeep` mempertahankan folder
kosong di Git; hapus penanda ketika folder sudah berisi implementasi.

## Pembagian fitur

Satu tugas fitur mencakup presentation, domain, data, dan tesnya. Pemilik proyek
menentukan pembagian kepada Rafi, Melia, dan Hasan melalui tabel berikut.

| Folder di lib/features | Tanggung jawab | Pemilik |
|---|---|---|
| home | Beranda warga dan pintu masuk pratinjau fitur | Belum ditetapkan |
| auth | Login, pendaftaran, pemulihan, logout | Belum ditetapkan |
| account | Profil dan pengaturan akun | Belum ditetapkan |
| ktp_verification | Pemeriksaan dan konfirmasi KTP | Belum ditetapkan |
| reports | Draf, pengiriman, riwayat dan hasil laporan warga | Belum ditetapkan |
| monitor | Pantau laporan publik | Belum ditetapkan |
| documents | Dokumen pribadi dan status penghapusannya | Belum ditetapkan |
| family | Data keluarga dan peninjauan hasil ekstraksi | Belum ditetapkan |
| emergency_bag | Kebutuhan dan progres tas siaga | Belum ditetapkan |
| contacts | Kontak publik dan kontak pribadi lokal | Belum ditetapkan |
| guides | Panduan kesiapsiagaan dan TTS | Belum ditetapkan |
| messages | Kotak masuk warga dan status baca (UI pratinjau messages_inbox.svg tersedia) | Belum ditetapkan |
| admin_reports | Antrean, kelompok, review, koreksi dan catatan laporan | Belum ditetapkan |
| admin_reporting | Pengaturan pelaporan, kuota, cleanup dan audit | Belum ditetapkan |
| admin_content | Pengelolaan kontak publik, panduan dan katalog tas | Belum ditetapkan |
| admin_messages | Penerbitan dan pengelolaan pesan | Belum ditetapkan |

Contoh tugas: "Kerjakan fitur `family`, termasuk state layar dan tesnya".
Jika satu fitur dibagi lagi, sepakati file dan kontrak sebelum mulai.
Perubahan `app`, `core`, dan `shared` dikoordinasikan melalui PR sesuai
[alur tim](../../docs/GITHUB-WORKFLOW.md).

## Batas layer

| Lokasi | Isi ketika diimplementasikan | Batas |
|---|---|---|
| presentation | Layar, widget lokal, controller dan state UI | Tidak mengakses HTTP/database langsung |
| domain | Model bisnis dan kontrak repository berupa Dart murni | Tidak mengimpor Flutter, HTTP atau implementasi storage |
| data | Implementasi repository, pemetaan dan sumber data lokal/remote | Mengimplementasikan domain; tidak mengimpor presentation |
| app | Perakitan aplikasi, navigasi dan injeksi dependensi | Menyuntikkan implementasi data melalui kontrak domain |
| core | Infrastruktur HTTP, storage, konteks sesi dan error bersama | Tidak bergantung pada fitur atau menampung aturan bisnis fitur |
| shared | Widget lintas fitur dan tema/token tampilan | Tidak mengimpor fitur atau mengakses sumber data |

Arah dependensi kode: **presentation -> domain <- data**; `app` merakit
implementasi. Saat berjalan, UI memanggil controller, lalu controller memakai
repository yang diinjeksi. Pertahankan `ChangeNotifier/ValueNotifier` sesuai
SRS-DEC-009; tidak mewajibkan package state management baru.

Komunikasi lintas fitur memakai kontrak domain yang diinjeksi melalui `app`,
bukan controller atau implementasi data fitur lain. Model bersama memiliki
satu fitur pemilik; jangan menduplikasi model warga/admin. Contohnya,
`admin_reports` dapat memakai kontrak/model domain milik `reports`, tanpa
dependensi balik. Hindari dependensi melingkar.

Use case ditambahkan hanya untuk logika kompleks atau berulang. Tidak wajib
satu use case per aksi. Tambahkan subfolder ketika kode membutuhkannya;
jangan membuat kelas kosong atau file ekspor tanpa penggunaan.

Contoh lokasi saat implementasi, **belum dibuat pada tahap ini**:

```text
lib/features/family/presentation/family_screen.dart
lib/features/family/presentation/family_controller.dart
lib/features/family/domain/family.dart
lib/features/family/domain/family_repository.dart
lib/features/family/data/family_repository_impl.dart
test/features/family/presentation/family_controller_test.dart
test/features/family/data/family_repository_impl_test.dart
```

Gunakan file/folder `snake_case`. Widget khusus fitur tetap di fiturnya;
pindahkan ke `shared/widgets` ketika dipakai lintas fitur. Tema mengikuti
[DESIGN](../../docs/DESIGN.md).

## Mockup beranda warga

Kode berada di `lib/features/home/presentation`; `app/siaga_banjir_app.dart`
merakit aplikasi dan membuka panel fitur. Tema berada di `shared/theme`.
State yang tersedia hanya scroll dan navigasi panel, sehingga belum memerlukan
controller bisnis atau repository kosong. Semua angka adalah data contoh.

| Aksi beranda | Tujuan integrasi berikutnya |
|---|---|
| Pantau Status / Pantau Wilayah | monitor |
| Kontak Darurat / Tas Siaga / Panduan Selamat | contacts / emergency_bag / guides |
| Dokumen Siaga Keluarga / Data Keluarga | documents / family |
| Lapor Banjir Cepat / Lapor / Riwayat | reports |
| Notifikasi / Profil | messages / account |

Lapor dan Lapor Banjir Cepat membuka halaman buat laporan; aksi lainnya
membuka panel pratinjau yang dapat ditutup. Lengkap menampilkan
pilihan fitur, dan Beranda menggulir kembali ke atas. Tidak ada request API,
akses perangkat, penyimpanan atau login. Panel tidak menyatakan aksi bisnis
berhasil. Fitur admin tetap berupa struktur folder.

[Acuan visual dan aset](design/README.md) menjelaskan SVG pemilik, 17 ikon lokal,
script slicing dan penyesuaian aksesibilitas. Bukti aktual ada pada
[WORKSPACE](../../docs/WORKSPACE.md#home-mockup).

Font Inter 4.1 weight 400/500/600/700/800 dibundel pada assets/fonts/inter;
asal dan lisensinya ada pada catatan desain. Tulisan Data contoh dan catatan
Mockup beranda sudah dihapus sesuai revisi pemilik; datanya tetap statis.

Nama tampilan Android, judul Web, nama instalasi Web dan judul Flutter adalah
**SiagaBanjir**. Folder proyek kini `apps/siagabanjir`, package Dart
`siagabanjir`; import memakai `package:siagabanjir/...`. Setelah mengambil
perubahan ini, buka folder baru lalu jalankan `flutter pub get` untuk
memperbarui metadata lokal. Hentikan sesi run lama sebelum berpindah folder.

Android applicationId/namespace tetap `com.example.app` agar identitas
instalasi yang sudah ada tidak berubah. Itu bukan nama yang ditampilkan ke
warga. Penetapan ID distribusi final dilakukan sebelum rilis aplikasi.
`lib/app` dan modul Gradle `android/app` tetap bernama app karena merupakan
nama lapisan perakitan/modul, bukan nama produk.

Kartu dokumen/laporan memakai status rata kanan saat ruang cukup, lalu
berpindah baris saat teks membesar. Deskripsi memakai lebar penuh pada ruang
sempit. Judul 16, isi 14, label pendukung/navigasi 12 logical pixels memakai
Inter lokal tanpa mengunci pembesaran teks. Badge akses cepat berpindah utuh
ke baris berikut, bukan terbelah di tengah kata.

## Batas data dan platform

- `data` adalah kode klien Flutter, bukan backend. Kredensial provider/database
  tidak masuk aplikasi.
- Draf laporan, progres tas dan kontak pribadi lokal diisolasi per akun.
  Data privat layanan tidak otomatis menjadi cache persisten offline.
- Konten publik kontak/panduan/katalog mengikuti pembaruan bundle atomik
  menurut SRS; jangan mencampur revisi melalui sinkronisasi fitur terpisah.
- Konteks sesi mencegah respons akun lama memasuki sesi baru. Token admin Web
  tidak dipersistensikan. Ini persyaratan berikutnya, belum diimplementasikan.
- Satu package melayani warga Android dan admin Web. Dependensi platform
  ditempatkan di implementasi yang sesuai, bukan pada domain.

Rincian normatif tetap pada [FRD](../../docs/FRD.md), [SRS](../../docs/SRS.md)
dan [kontrak API](../../docs/openapi.json). README tidak menggantikan aturan
akses, lifecycle, atau kontrak tersebut.

## Pengembangan dan pemeriksaan

Ikon launcher Android/Web dan splash memakai logo tetes air lokal. Regenerasi
serta sumber ada di [catatan branding](design/README.md#ikon-aplikasi-dan-splash).
APK debug sudah berhasil dibangun dengan `flutter build apk --debug --no-pub`;
ini pemeriksaan build, bukan bukti cold start pada HP. Perubahan resource
native memerlukan build/install ulang, bukan hot reload.

Manifest saat ini: package `siagabanjir`, versi `1.0.0+1`, batas Dart `^3.13.5`;
dependensi langsung Flutter SDK dan `cupertino_icons`, dengan `flutter_test`
dan `flutter_lints` untuk pengembangan. Batas manifest bukan bukti versi SDK
terpasang. Tidak ada dependensi baru pada penataan folder ini.

Jalankan dari root repository di PowerShell atau Bash:

```sh
cd apps/siagabanjir
flutter --version
flutter pub get
flutter analyze
flutter test
flutter devices
flutter run -d <device_id>
```

Ganti `<device_id>` dengan ID dari `flutter devices`. Flutter SDK harus ada
di PATH; Android membutuhkan Android SDK dan emulator/perangkat, sedangkan
Web membutuhkan browser yang didukung. Konfigurasi SDK tetap lokal.
Petunjuk berlaku lintas Windows/macOS/Linux; runtime setiap OS belum diuji.

`flutter pub get` mengunduh dependensi dan dapat memperbarui lockfile; periksa
diff sebelum commit. Analyze/test/run dapat menghasilkan cache/build lokal.
Untuk review Web dengan renderer lokal, jalankan
`flutter build web --no-web-resources-cdn --no-wasm-dry-run`.
SDK yang diverifikasi: Flutter 3.47.7 stable dan Dart 3.13.5 pada Windows.
Analyze, dua belas widget test dan build Web dijalankan untuk mockup beranda;
bukti perangkat Android belum tersedia.

Tes berikutnya mengikuti `test/features/<nama_fitur>/<layer>`: unit test
controller/repository, widget test layar, dan integrasi ketika alurnya tersedia.
Jangan menaikkan status tes aplikasi karena pemeriksaan dokumentasi lulus.

## Dasar keputusan

Riset 23 Oktober 2026 memakai [rekomendasi Flutter](https://docs.flutter.dev/app-architecture/recommendations)
dan [studi kasus resmi](https://docs.flutter.dev/app-architecture/case-study).
Flutter menganjurkan pemisahan UI/data dan repository; domain/use case bersifat
kondisional. Studi kasus memakai susunan campuran, bukan mewajibkan struktur
ini. Adaptasi SiagaBanjir mengelompokkan layer per fitur untuk pembagian tugas,
sambil mempertahankan controller proyek. Keputusan lokal dicatat pada
[WS-DEC-051](../../docs/DECISIONS.md#flutter-feature-first-051).

## Halaman buat laporan

[ReportCreateScreen](lib/features/reports/presentation/report_create_screen.dart)
mengikuti [SVG laporan](design/reports_create.svg). Kategori satu pilihan,
kebutuhan beberapa pilihan dan deskripsi dapat diubah selama halaman terbuka.
Kategori dan kebutuhan mulai kosong agar pengguna memilih sendiri. Isian
memicu konfirmasi sebelum keluar; membuka panel Riwayat/Profil/Notifikasi mempertahankan isian.
Header, ikon lokal dan navbar yang dipakai lintas fitur berada di shared/widgets;
app menyuntikkan callback navigasi tanpa dependensi reports ke presentation home.

Kamera, GPS dan Kirim menampilkan penjelasan layanan belum tersedia; alamat
adalah contoh. Tidak ada draf tersimpan, pengiriman offline, verifikasi foto
atau permintaan bantuan nyata. Kategori/kebutuhan adalah state desain lokal,
bukan field tambahan kontrak API. Deskripsi tidak diberi label opsional karena
baseline produk mewajibkannya. Validasi bisnis menunggu integrasi berikutnya.
[Bukti pemeriksaan](../../docs/WORKSPACE.md#report-create-ui).

### Slicing UI dan perilaku form

ReportCreateScreen mengelola state sementara, fokus, scroll dan navigasi.
Widget di presentation/widgets memisahkan susunan form (report_form), foto/lokasi
(report_evidence_sections), pilihan (report_choice_section), input deskripsi
(report_description_section), pembungkus kartu (report_section) dan dialog
(report_dialogs). Pola ini mengikuti widget kecil home; tidak ada repository
atau controller bisnis kosong. CitizenNavigation dipakai oleh kedua layar;
HomeNavigation hanya menerjemahkan callback ke HomeAction.

Komentar `// ...` berbahasa Indonesia menjelaskan tanggung jawab bagian UI,
state, fokus, navigasi dan tes yang terkait. Judul section 16 dan isi/pilihan 14
mengikuti hierarki home. Indikator radio/checkbox dan fokus keyboard membedakan
status selain warna; label input menetap dan penghitung karakter berbahasa
Indonesia. Saat keyboard terbuka, header/navbar sementara disembunyikan.
Tab Lapor aktif menggulir ke awal tanpa menghapus input; batal keluar memulihkan
fokus sebelumnya. Isian yang dibatalkan hingga kosong tidak meminta konfirmasi.
[Bukti revisi UI/UX](../../docs/WORKSPACE.md#report-uiux-refinement).

## Kotak masuk pesan peringatan siaga

[MessagesInboxScreen](lib/features/messages/presentation/messages_inbox_screen.dart)
mengikuti acuan [messages_inbox.svg](design/messages_inbox.svg). Layar dapat
diakses melalui tombol notifikasi pada CitizenHeader di beranda maupun laporan.
Fitur menyediakan:
- Header dengan tombol kembali, judul Peringatan Siaga, dan badge pesan baru.
- Tab filter horizontal (Semua, Darurat, Cuaca BMKG, Posko).
- Kartu pesan [MessageCard](lib/features/messages/presentation/widgets/message_card.dart)
  dengan aksen garis warna semantik (merah untuk Siaga 2, oranye untuk Potensi
  Banjir, biru untuk Posko, dan abu-abu netral untuk Normal), instansi pengirim,
  judul 16/700, isi 14/400, dan tombol aksi evakuasi/bagikan/posko.
- Dialog penjelasan aksi demo [message_dialogs.dart](lib/features/messages/presentation/widgets/message_dialogs.dart).
- Navigasi bawah menggunakan CitizenNavigation bersama yang menghubungkan
  kembali ke Beranda, Lapor, Riwayat, dan Profil.

