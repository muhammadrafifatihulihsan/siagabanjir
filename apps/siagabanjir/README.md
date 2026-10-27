# Flutter SiagaBanjir

> **Living document:** perbarui bersama setiap perubahan terkait menurut [aturan dokumentasi](../../rules/documentation.md#living-documents).

Satu package Flutter untuk target Android warga dan Web admin. Kode saat ini
berisi **pratinjau UI warga dengan data lokal**, belum integrasi backend,
autentikasi nyata, GPS, brankas dokumen terenkripsi, atau layanan admin.
Adapter kamera/TTS perangkat dan pemilihan/ekspor berkas lokal sudah tersedia;
pengujian HP belum dijalankan sesuai instruksi pemilik.
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
  core/perangkat/              # kamera/galeri sistem dan pemulihan hasil
  shared/
    theme/                     # tema dan token tampilan bersama
    widgets/                   # header, navigasi warga, ikon lokal
  features/
    akun/
    autentikasi/
    beranda/
    dokumen/
    kontak/
    keluarga/
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
`domain` berisi model Dart murni pada akun, kontak, laporan, panduan, dan keluarga.
Adapter TTS ada pada `panduan/data`, berkas lokal pada `dokumen/data`, dan
kamera bersama pada `core/perangkat`. Tidak ada layer placeholder.

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
| family (sebelumnya kosong) | keluarga | layar_keluarga.dart |
| reports | laporan | layar_buat_laporan.dart, layar_riwayat_laporan.dart |
| guides | panduan | layar_detail_panduan.dart |
| monitor | pantau | layar_pantau_wilayah.dart |
| messages | pesan | layar_kotak_masuk.dart |
| emergency_bag | tas_siaga | layar_tas_siaga.dart |

File, kelas dan enum fitur mengikuti bahasa Indonesia, misalnya `LayarBeranda`,
`AksiBeranda`, `KontakDarurat` dan `EntriRiwayatLaporan`. Istilah teknis
`lib`, `test`, `features`, `presentation`, `domain`, `models`, `widgets`, `app`
dan `shared` dipertahankan. API Flutter, properti/callback, konstanta fixture,
kunci aset dan ID data tetap memakai nama sebelumnya. File memakai `snake_case`,
kelas/enum `UpperCamelCase`, dan tes tetap berakhiran `_test.dart`.

Enam folder lama yang hanya berisi penanda kosong dihapus: `admin_content`,
`admin_messages`, `admin_reporting`, `admin_reports`, `family` dan
`ktp_verification`. Requirement admin, keluarga dan KTP **tetap berlaku**;
buat folder bernama Indonesia ketika implementasinya dimulai. Menu Data Keluarga
kini membuka formulir lokal pada fitur `keluarga`; folder dibuat bersama implementasinya.

Widget/model slot dokumen tetap telah dihapus. Dokumen kini berupa daftar
dinamis melalui FormulirDokumen. Model KontakDarurat dan formulirnya dimiliki
fitur kontak, bukan akun.

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
Profil meneruskan logout ke callback app. Kerangka warga membuang route/state
sesi demo dan membuat sesi baru setelah simulasi masuk; ini belum autentikasi produksi.
Widget bersama berada di `shared/widgets`. Perubahan lintas fitur dikoordinasikan
melalui [PR tim](../../docs/GITHUB-WORKFLOW.md).

## Mockup beranda warga

[SiagaBanjirApp](lib/app/siaga_banjir_app.dart) merakit aplikasi. Beranda membuka
seluruh fitur secara langsung. `KerangkaWarga` mempertahankan empat tab
Beranda/Lapor/Riwayat/Profil dengan IndexedStack dan ScrollController masing-masing.
Header yang sama dipakai ulang; navbar hanya memperbarui pilihan. Halaman detail
memiliki judul/kembali, dan tombol Lengkap membuka `PanelAksesFitur`.
Mengetuk tab aktif menggulir ke atas; pindah tab mempertahankan isian/posisi.

Data tinggi air, kuota, jumlah dokumen dan notifikasi masih contoh statis.
Autentikasi dan panggilan tidak dijalankan. Kamera dan TTS memakai adapter
plugin perangkat. Dokumen memilih berkas lokal dan mengekspor ZIP atas tindakan
pengguna; bukan penyimpanan terenkripsi. Pesan hasil mengikuti efek sebenarnya.

[Acuan visual dan aset](design/README.md) menjelaskan SVG, ikon lokal, Inter
dan branding. Direktori aset `assets/icons/home` dan `assets/images/reports`
tetap agar kunci aset dan script desain konsisten. Lisensi Inter ada di
`assets/fonts/inter/OFL.txt` dan terdaftar pada aplikasi.

## Halaman buat laporan

[LayarBuatLaporan](lib/features/laporan/presentation/layar_buat_laporan.dart)
mengelola state sementara, fokus, scroll, pilihan kategori/kebutuhan, deskripsi
serta konfirmasi keluar. Widget formulir, bukti, pilihan, deskripsi, bagian kartu
dan dialog berada di `lib/features/laporan/presentation/widgets`.

Kategori/kebutuhan dimulai kosong. Tab Lapor menggulir ke atas dan isian/foto
tetap ada saat berpindah tab. Layar laporan mandiri tetap mengonfirmasi keluar.
Kamera membuka aplikasi kamera sistem, menampilkan foto, dan mempertahankan foto
lama ketika dibatalkan/gagal. Android memeriksa hasil kamera yang tertunda saat
startup dan meminta pilihan tujuan sebelum memasukkannya ke laporan.
GPS menjelaskan lokasi belum tersedia. Simpan ke Riwayat memvalidasi kategori
dan deskripsi, meminta konfirmasi, lalu menyimpan kategori/deskripsi/kebutuhan,
foto opsional dan waktu sesi. Daftar dimulai kosong; kartu ringkas membuka detail
saat diketuk. Tidak ada draf persisten atau status/tim respons rekaan.

## Dokumen dan fitur pendukung

[LayarDokumenSiaga](lib/features/dokumen/presentation/layar_dokumen_siaga.dart)
menyediakan Tambah Dokumen: pilih PDF/JPG/PNG atau scan berupa foto kamera,
kemudian kategori KTP/KK/Lainnya. Nama lainnya mengikuti input tanpa whitespace
dan disanitasi untuk nama berkas; ekstensi dipertahankan. Maksimal 5 MB per berkas.
Sukses berarti ditambahkan ke sesi, bukan diunggah ke server. ZIP mengekspor
berkas pilihan secara eksplisit, tanpa enkripsi. Dokumen dapat dihapus dengan
konfirmasi dan bertahan saat halaman dibuka ulang selama sesi.

Kontak Pribadi berada di Kontak Darurat: tambah/edit/hapus dengan konfirmasi,
salin nomor, dan retensi sesi. Kontak umum contoh memiliki filter/salin, bukan
nomor darurat terverifikasi. Rute dan saran posko dihapus sesuai mandat terbaru.
Foto profil kamera/galeri berada dalam Edit Profil; Batal tidak mengubah avatar.
Panduan memakai TTS normal eksplisit (Android plugin0.5/native1x, Web1.0),
pitch1.0, putar/jeda/lanjut/hentikan dan speaker per langkah. Ketukan berulang
teks aktif tidak memulai ulang. Tidak ada verifikasi suara HP oleh agen.
Tas dan keluarga tetap lokal, pesan menyediakan salin teks bertanda demo.
Logout membuang state demo; autentikasi/isolasi/persistensi akun server belum ada.

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
`cupertino_icons`, `image_picker`, `flutter_tts`, `file_selector`, `archive` dan
`file_saver`; pengembangan memakai `flutter_test` dan `flutter_lints`.
Versi persis ada di pubspec.lock. SDK pemeriksaan: Flutter 3.47.7 stable
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
controller/repository diperlukan. [Bukti terbaru](../../docs/WORKSPACE.md#flutter-uiux)
membedakan build/tes widget dari perangkat fisik, backend dan UAT.

## Dasar keputusan

### Pemeriksaan manual oleh pemilik

Build debug tersedia di `build/app/outputs/flutter-apk/app-debug.apk` setelah
perintah build. Agen tidak memasang atau menjalankan APK di HP sesuai mandat.

1. Edit Profil lalu pindah tab dan kembali; perubahan harus tetap ada. Keluar
   dari akun demo lalu masuk kembali harus mengembalikan fixture awal.
2. Buka Kamera pada laporan atau Kamera/Galeri di Edit Profil, pilih objek uji, batalkan pengambilan ulang,
   dan periksa bahwa foto sebelumnya tetap ada. Foto belum dikirim ke server.
3. Di Panduan, coba putar, jeda, lanjut, hentikan dan speaker per langkah.
   Pastikan suara berhenti ketika meninggalkan halaman. Voice Indonesia mengikuti
   mesin Teks ke Ucapan HP; kegagalan tidak menghilangkan teks panduan.
4. Tambahkan berkas uji PDF/JPG/PNG atau scan kamera, pilih kategori, lalu simpan.
   Untuk Lainnya coba nama "pajak kendaraan"; hasilnya pajakkendaraan.ext.
   Ekspor ZIP hanya memuat berkas pilihan. Coba batal/hapus dan buka ulang halaman.

Kamera/TTS/pemilih berkas Android tetap NOT_RUN oleh agen; build dan fake test
tidak menggantikan pemeriksaan perangkat tersebut.

[WS-DEC-051](../../docs/DECISIONS.md#flutter-feature-first-051) menetapkan
pemisahan per fitur/layer. [WS-DEC-063](../../docs/DECISIONS.md#flutter-indonesia-063)
mengganti kebijakan placeholder dengan folder sesuai implementasi dan nama Indonesia.
