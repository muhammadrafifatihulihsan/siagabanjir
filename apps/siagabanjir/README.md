# Flutter SiagaBanjir

> **Living document:** perbarui bersama setiap perubahan terkait menurut [aturan dokumentasi](../../rules/documentation.md#living-documents).

Satu package Flutter untuk target Android warga dan Web admin. Kode saat ini
berisi **pratinjau UI warga dengan data lokal**, belum integrasi backend,
autentikasi nyata, kamera, GPS, penyimpanan dokumen, atau layanan admin.
Build Web dipakai untuk pemeriksaan UI warga, bukan implementasi admin.

Penataan 27 Oktober 2026 mempertahankan **Feature-First + Layered Architecture**
dengan nama fitur Indonesia. Folder dibuat ketika ada implementasi; tidak ada
lagi layer kosong atau `.gitkeep` dalam `lib`.
Keputusan: [WS-DEC-063](../../docs/DECISIONS.md#flutter-indonesia-063).

## Struktur

```text
lib/
  main.dart
  app/                         # perakitan aplikasi dan navigasi
  shared/
    theme/                     # tema dan token tampilan bersama
    widgets/                   # header, navigasi warga, ikon lokal
  features/
    akun/
    autentikasi/
    beranda/
    dokumen/
    kontak/
    laporan/
    panduan/
    pantau/
    pesan/
    tas_siaga/
test/
  features/                    # nama fitur sama dengan lib/features
```

Setiap fitur mempunyai `presentation` untuk layar dan `widgets`.
`presentation/models` menampung model tampilan yang membawa `Color`/`IconData`.
`domain` hanya ada pada `akun`, `laporan`, dan `panduan`, dengan model Dart murni.
Belum ada implementasi `data` atau infrastruktur bersama `core`.

## Pembagian fitur

Pemilik setiap fitur masih belum ditetapkan. Tabel migrasi berikut membantu
anggota menemukan kode setelah pull; semua layar berada di `presentation`.

| Nama lama | Folder sekarang | File layar |
|---|---|---|
| account | akun | layar_profil.dart |
| auth | autentikasi | layar_masuk.dart, layar_daftar.dart |
| home | beranda | layar_beranda.dart |
| documents | dokumen | layar_dokumen_siaga.dart |
| contacts | kontak | layar_direktori_kontak.dart |
| reports | laporan | layar_buat_laporan.dart, layar_riwayat_laporan.dart |
| guides | panduan | layar_detail_panduan.dart |
| monitor | pantau | layar_pantau_wilayah.dart |
| messages | pesan | layar_kotak_masuk.dart |
| emergency_bag | tas_siaga | layar_tas_siaga.dart |

File, kelas dan enum fitur mengikuti bahasa Indonesia, misalnya `LayarBeranda`,
`AksiBeranda`, `DokumenKeluarga` dan `KategoriStatusLaporan`. Istilah teknis
`lib`, `test`, `features`, `presentation`, `domain`, `models`, `widgets`, `app`
dan `shared` dipertahankan. API Flutter, properti/callback, konstanta fixture,
kunci aset dan ID data tetap memakai nama sebelumnya. File memakai `snake_case`,
kelas/enum `UpperCamelCase`, dan tes tetap berakhiran `_test.dart`.

Enam folder lama yang hanya berisi penanda kosong dihapus: `admin_content`,
`admin_messages`, `admin_reporting`, `admin_reports`, `family` dan
`ktp_verification`. Requirement admin, keluarga dan KTP **tetap berlaku**;
buat folder bernama Indonesia ketika implementasinya dimulai. Menu Data Keluarga
masih berupa panel pratinjau beranda.

Model `DocumentEntry` dan empat widget dokumen lama dihapus setelah penelusuran
impor dari `main.dart` dan semua tes membuktikan tidak ada pemakai aktif.
Layar dokumen menggunakan `DokumenKeluarga` dan empat widget aktif.

## Batas layer

| Lokasi | Tanggung jawab | Batas |
|---|---|---|
| presentation | Layar, widget, state/controller dan model tampilan | Tidak mengakses HTTP/database langsung |
| domain | Model bisnis dan kontrak repository Dart murni | Tidak mengimpor Flutter atau storage |
| data, bila diperlukan | Repository dan sumber data lokal/remote | Mengimplementasikan domain, tidak mengimpor presentation |
| app | Perakitan, navigasi dan injeksi dependensi | Menyuntikkan implementasi melalui kontrak |
| core, bila diperlukan | HTTP, storage, sesi dan error bersama | Tidak menampung aturan bisnis fitur |
| shared | Widget lintas fitur dan tema/token | Tidak mengimpor fitur atau sumber data |

Arah dependensi bisnis: **presentation -> domain <- data**; `app` merakitnya.
Controller mengikuti `ChangeNotifier/ValueNotifier` sesuai SRS-DEC-009 ketika
dibutuhkan. State UI sederhana saat ini memakai `StatefulWidget`; tidak perlu
repository, controller, file ekspor atau use case kosong.

Komunikasi bisnis lintas fitur nantinya memakai kontrak domain melalui `app`.
UI profil saat ini masih memakai pembungkus navigasi beranda dan membuka layar
masuk; dependensi presentasi lokal ini belum menjadi arsitektur sesi produksi.
Widget bersama berada di `shared/widgets`. Perubahan lintas fitur dikoordinasikan
melalui [PR tim](../../docs/GITHUB-WORKFLOW.md).

## Mockup beranda warga

[SiagaBanjirApp](lib/app/siaga_banjir_app.dart) merakit aplikasi. Beranda membuka
laporan, kontak, tas siaga, panduan, dokumen dan pesan secara langsung. Pantau,
Riwayat dan Profil dibuka melalui panel pratinjau dengan tombol menuju layar
lengkap. Lengkap menampilkan daftar akses; Beranda menggulir ke atas.

Data tinggi air, kuota, jumlah dokumen dan notifikasi masih contoh statis.
Autentikasi, panggilan, audio, enkripsi/simpan dokumen dan unduh ZIP belum
terhubung layanan nyata, meskipun sebagian label/umpan balik UI menggambarkan
hasil berhasil. Integrasi dan penyelarasan pesan tersebut adalah pekerjaan
berikutnya; penataan ini mempertahankan perilaku dan tes yang sudah ada.

[Acuan visual dan aset](design/README.md) menjelaskan SVG, ikon lokal, Inter
dan branding. Direktori aset `assets/icons/home` dan `assets/images/reports`
tetap agar kunci aset dan script desain konsisten. Lisensi Inter ada di
`assets/fonts/inter/OFL.txt` dan terdaftar pada aplikasi.

## Halaman buat laporan

[LayarBuatLaporan](lib/features/laporan/presentation/layar_buat_laporan.dart)
mengelola state sementara, fokus, scroll, pilihan kategori/kebutuhan, deskripsi
serta konfirmasi keluar. Widget formulir, bukti, pilihan, deskripsi, bagian kartu
dan dialog berada di `lib/features/laporan/presentation/widgets`.

Kategori/kebutuhan dimulai kosong. Batal keluar mempertahankan isian/fokus;
tab Lapor menggulir ke atas. Kamera, GPS dan Kirim menjelaskan layanan belum
tersedia. Tidak ada draf persisten atau pengiriman nyata. Riwayat menampilkan
contoh laporan dengan filter status dan dialog foto/detail.

## Dokumen dan fitur pendukung

[LayarDokumenSiaga](lib/features/dokumen/presentation/layar_dokumen_siaga.dart)
memakai `HeaderDokumen`, `KartuDokumenSiaga`, `BannerInfoDokumen` dan
`TombolAksiDokumen`. Tiga berkas contoh memiliki tombol Ganti, Simpan dan Unduh
ZIP; tidak ada progress bar atau widget ringkasan dari implementasi lama.

Kontak menyediakan filter dan salin nomor ke clipboard; nomor belum diverifikasi.
Tas siaga mengubah centang/progres dalam memori. Panduan menampilkan accordion
dan simulasi audio. Pesan menyediakan filter/dialog demo. Pantau menampilkan
sungai/infrastruktur statis. Profil, masuk dan daftar memiliki form/umpan balik
lokal; belum ada autentikasi, sesi atau isolasi data per akun.

## Batas data dan platform

- Model UI bukan kontrak API. Kunci provider/database hanya berada di backend.
- Draf, progres tas dan kontak pribadi nantinya harus diisolasi per akun.
  Data privat layanan tidak otomatis menjadi cache offline persisten.
- Kontak/panduan/katalog mengikuti pembaruan bundle atomik sesuai SRS saat diintegrasikan.
- Respons akun lama harus ditolak oleh konteks sesi; token admin Web tidak dipersistensikan.
- Package Dart tetap `siagabanjir`; import memakai `package:siagabanjir/...`.
  Nama tampilan tetap SiagaBanjir; applicationId/namespace Android masih
  `com.example.app`, dengan signing debug untuk pengembangan.

Rujukan: [FRD](../../docs/FRD.md), [SRS](../../docs/SRS.md),
[kontrak API](../../docs/openapi.json) dan [DESIGN](../../docs/DESIGN.md).

## Pengembangan dan pemeriksaan

Manifest: versi `1.0.0+1`, batas Dart `>=3.13.0 <4.0.0`, Flutter SDK dan
`cupertino_icons`; pengembangan memakai `flutter_test` dan `flutter_lints`.
Penataan folder tidak menambah dependensi. SDK pemeriksaan: Flutter 3.47.7 stable
/ Dart 3.13.5 pada Windows. Dari root repository, gunakan PowerShell atau Bash:

```sh
cd apps/siagabanjir
flutter pub get
dart format --output=none --set-exit-if-changed lib test
flutter analyze --no-pub
flutter test --no-pub
flutter build web --no-pub --no-web-resources-cdn --no-wasm-dry-run
flutter build apk --debug --no-pub
flutter devices
flutter run -d <device_id>
```

Ganti `<device_id>` dengan ID perangkat. Android membutuhkan SDK serta emulator/
perangkat; Web membutuhkan browser. Konfigurasi SDK tetap lokal. `pub get` dapat
memperbarui lockfile; tinjau diff. Hentikan sesi run lama dan jalankan ulang setelah
nama file berubah. Petunjuk lintas OS tidak berarti runtime semua OS sudah diuji.

Tes berada di `test/features/<nama_fitur>`; tambahkan subfolder layer ketika tes
controller/repository diperlukan. [Bukti terbaru](../../docs/WORKSPACE.md#flutter-indonesia)
membedakan build/tes widget dari perangkat fisik, backend dan UAT.

## Dasar keputusan

[WS-DEC-051](../../docs/DECISIONS.md#flutter-feature-first-051) menetapkan
pemisahan per fitur/layer. [WS-DEC-063](../../docs/DECISIONS.md#flutter-indonesia-063)
mengganti kebijakan placeholder dengan folder sesuai implementasi dan nama Indonesia.
