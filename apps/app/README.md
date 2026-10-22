# Flutter SiagaBanjir

> **Living document:** perbarui bersama setiap perubahan terkait menurut [aturan dokumentasi](../../rules/documentation.md#living-documents).

Satu package Flutter untuk Android warga dan Web admin memakai
**Feature-First + Layered Architecture**: kelompokkan kode berdasarkan fitur,
lalu pisahkan tanggung jawab di dalam fitur.

Status 23 Oktober 2026: folder tersedia dengan `.gitkeep`; fitur belum
diimplementasikan. `lib/main.dart` dan `test/widget_test.dart` masih counter bawaan.
Folder bukan bukti fitur, integrasi API, atau isolasi akun sudah berjalan.
Backend tidak termasuk penataan ini.

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
  widget_test.dart
  features/
```

`<nama_fitur>` adalah notasi contoh; nama sebenarnya ada pada tabel berikut.
Setiap fitur memiliki tiga folder layer. `.gitkeep` mempertahankan folder
kosong di Git; hapus penanda ketika folder sudah berisi implementasi.

## Pembagian fitur

Satu tugas fitur mencakup presentation, domain, data, dan tesnya. Pemilik proyek
menentukan pembagian kepada Rafi, Melia, dan Hasan melalui tabel berikut.

| Folder di lib/features | Tanggung jawab | Pemilik |
|---|---|---|
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
| messages | Kotak masuk warga dan status baca | Belum ditetapkan |
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

Manifest saat penataan: package `app`, versi `1.0.0+1`, batas Dart `^3.13.5`;
dependensi langsung Flutter SDK dan `cupertino_icons`, dengan `flutter_test`
dan `flutter_lints` untuk pengembangan. Batas manifest bukan bukti versi SDK
terpasang. Tidak ada dependensi baru pada penataan folder ini.

Jalankan dari root repository di PowerShell atau Bash:

```sh
cd apps/app
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
Perintah pengembangan di atas tidak dijalankan untuk perubahan folder saja.

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
