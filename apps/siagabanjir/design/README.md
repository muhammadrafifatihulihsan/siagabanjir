# Acuan desain warga

> **Living document:** perbarui bersama setiap perubahan terkait menurut [aturan dokumentasi](../../../rules/documentation.md#living-documents).

Pemilik memberikan `app_beranda.svg` pada 23 Oktober 2026 sebagai acuan wajib
untuk satu mockup beranda warga. [Salinan sumber](app_beranda.svg) berukuran
390 x 1097; sumber asli di direktori desain kuliah pengguna tidak diubah.
Aset digunakan untuk tugas yang diminta pemilik, bukan dinyatakan sebagai
aset berlisensi bebas atau unduhan library pihak ketiga.

## Aset lokal

[slice_icons.py](slice_icons.py) mengekstrak 17 grup ikon bermask dari SVG:
brand, notifications, home, report, history, profile, water, arrow, monitor,
contacts, bag, guides, document_badge, documents, chevron, ai_badge dan camera.
Grup dan mask dipertahankan sebagai SVG mandiri di [icons](icons/).
Rasterisasi transparan 3x menghasilkan PNG di [assets/icons/home](../assets/icons/home/).
Total PNG runtime 24.295 byte; SVG sumber tidak masuk bundle aplikasi.

Teks dan kartu dibangun sebagai widget Flutter, bukan screenshot dengan area
klik. Font Inter lokal dipilih pemilik pada revisi berikutnya; SVG mengubah teks
menjadi path sehingga nama font Figma asli belum terverifikasi.
Tidak ada font, ikon, atau gambar remote
pada kode layar. Titik status digambar sebagai lingkaran Flutter agar tidak
memicu font Unicode cadangan dari internet.

Untuk mengekstrak ulang, gunakan Python dengan Playwright pada lingkungan
pengembangan dan browser Chromium yang sudah terpasang. Dari root repository:

```sh
python apps/siagabanjir/design/slice_icons.py --browser "<path-browser-chromium>"
```

Perintah menulis ulang SVG hasil slice dan PNG; periksa diff setelahnya.
Playwright hanya alat pengembangan, bukan dependensi aplikasi Flutter.
Sumber desain penuh tidak didaftarkan sebagai aset runtime.

### Font Inter lokal

Font berasal dari [rilis resmi Inter 4.1](https://github.com/rsms/inter/releases/tag/v4.1),
arsip Inter-4.1.zip, direktori extras/otf. File asli Regular (400), Medium (500),
SemiBold (600), Bold (700) dan ExtraBold (800) disimpan tanpa modifikasi pada
[assets/fonts/inter](../assets/fonts/inter/), total 3.132.960 byte.
[Lisensi SIL OFL 1.1](../assets/fonts/inter/OFL.txt) disertakan dalam bundle
dan didaftarkan ke LicenseRegistry Flutter. Lisensi proyek tidak menggantikan
lisensi font pihak ketiga ini.

Pubspec memetakan setiap weight secara eksplisit; tema memakai keluarga Inter.
Tidak memakai google_fonts atau HTTP saat aplikasi berjalan. Bentuk glyph
tidak bergantung pada font sistem HP, meski rasterisasi layar dan pembesaran
teks dapat berbeda antarperangkat. Pemilihan Inter adalah persetujuan pemilik
untuk mendekati desain, bukan verifikasi jenis font asli Figma.

## Adaptasi dan batas mockup

- Hierarki, palet, ikon, teks utama, kartu dan navigasi mengikuti SVG.
  Kontras label waktu/navigasi diperkuat; target sentuh minimal 48 logical pixels.
- Tulisan Data contoh dan catatan Mockup beranda dihapus atas permintaan pemilik.
  Status pengembangan dicatat di dokumentasi. Siaga 2, tinggi air, 3 notifikasi,
  3/3 berkas dan kuota 1/2 tetap ilustrasi, bukan
  status resmi, berkas tersimpan atau aturan kuota produk.
- Konten dapat digulir, header/navigasi tetap terlihat. Teks besar mengubah
  grid menjadi satu kolom; lebar konten dibatasi 600 logical pixels pada Web.
- Lapor membuka halaman buat laporan; tombol lain membuka panel pratinjau
  dengan jalan kembali. Tidak mengirim laporan,
  mengakses kamera/lokasi, menelepon, membaca dokumen atau melakukan login.
- Beranda dipilih pada navbar selama panel tampil; tombol Beranda kembali ke
  atas. Menu Lengkap meneruskan ke panel fitur lain tanpa menumpuk panel.

Build pratinjau memakai `flutter build web --no-web-resources-cdn --no-wasm-dry-run`;
renderer dan font fallback dasar dilayani dari build lokal. Ini bukan pemasangan
PWA atau jaminan halaman Web bisa dibuka pertama kali tanpa server.
Sasaran produk layar ini tetap Android warga; Web digunakan untuk review UI.

Bukti pemeriksaan dan batas platform ada pada
[WORKSPACE](../../../docs/WORKSPACE.md#home-mockup).

[Pratinjau hasil Flutter](beranda-preview.png) direkam dari build Web lokal
pada viewport 390 x 1097, device scale 2. Gambar adalah bukti tampilan mockup,
bukan screenshot Android atau aset yang ditampilkan aplikasi.

Revisi layout berikutnya memperbaiki perataan status 3/3 dan kuota, ruang
teks kartu, serta badge akses cepat pada layar sempit. Deskripsi kartu dapat
berpindah ke bawah ikon/judul tanpa mengecilkan font. Judul kartu 16, isi 14,
label pendukung/navigasi 12; pembesaran teks tetap mengikuti pengguna.
[Pratinjau kartu setelah scroll](beranda-cards-preview.png) melengkapi screenshot
awal, sehingga seluruh kartu Lapor Banjir dapat diperiksa di atas navbar.

Perapian lanjutan dua kartu menengahkan ikon/chevron terhadap teks. Lingkaran
44 tetap sama; ukuran widget dokumen 24 dan kamera 22 menyeimbangkan glyph
terlihat sekitar 21 karena padding transparan hasil slice berbeda. Ikon sumber,
font, header kartu dan bagian beranda lain tetap.

## Ikon aplikasi dan splash

Logo tetes air berasal dari [slice brand](icons/brand.svg) milik pemilik,
bukan logo baru pihak ketiga. [Master launcher](launcher.svg) memakai biru
`#2563EB` di atas `#EFF6FF`. [Generator](generate_branding.py) menghasilkan PNG
launcher Android lima density, ikon Web 192/512 biasa dan maskable, favicon,
logo SVG Web serta vector Android dari satu path sumber.

Jalankan `python apps/siagabanjir/design/generate_branding.py` dari root dengan
Python, Playwright dan Chrome lokal. Ini alat pengembangan, bukan dependency
runtime. File hasil disimpan di repository; sumber SVG awal tidak diubah.
Glyph dipusatkan pada kanvas 108 dan masuk area aman adaptive/maskable.
Android 26+ memakai foreground/background adaptive; 33+ memiliki monochrome.

Splash Android sebelum API 31 memakai launch background, API 31+ memakai
windowSplashScreenBackground/AnimatedIcon; varian light/night memakai latar
`#F8FAFC` sesuai tema aplikasi. Native splash berakhir ketika frame Flutter siap,
tanpa timer atau halaman Flutter tambahan. Logo vector tidak memakai font.

Web memakai logo, judul Inter lokal dan status pemuatan pada HTML/CSS lokal.
Bootstrap menghapus splash setelah runApp selesai; kegagalan startup memberi
pesan dan tombol muat ulang. Tidak ada penundaan buatan atau animasi.
[Pratinjau splash Web](splash-web-preview.png) direkam saat entrypoint ditahan
oleh alat tes; bukan screenshot splash Android.

Acuan resmi: [adaptive icons Android](https://developer.android.com/develop/ui/compose/system/icon_design_adaptive),
[splash Android](https://developer.android.com/develop/ui/views/launch/splash-screen),
[launch Flutter Android](https://docs.flutter.dev/platform-integration/android/splash-screen),
[bootstrap Web](https://docs.flutter.dev/platform-integration/web/initialization).

## Halaman buat laporan

Pemilik memberikan reports_create.svg dari direktori Downloads pada
25 Oktober 2026. [Salinan sumber](reports_create.svg) berukuran 390 x 1421;
sumber dipertahankan sebagai acuan, bukan aset runtime atau aset berlisensi bebas.
Kartu dan kontrol dibuat sebagai widget Flutter dengan Inter lokal, ikon
Material dan header/navbar lokal yang dipakai bersama beranda.

Hierarki dan susunan mengikuti sumber; teks kamera/GPS/kirim disesuaikan agar
tidak mengklaim integrasi yang belum tersedia. Alamat dan pilihan awal merupakan
contoh desain. Label deskripsi opsional dihapus untuk konsistensi baseline.
Tidak ada perubahan API untuk kategori/kebutuhan, akses perangkat atau transaksi.
[Bukti pemeriksaan](../../../docs/WORKSPACE.md#report-create-ui) membedakan
preview Web dari perangkat Android dan penerimaan produk.

[Pratinjau laporan Flutter](reports-create-preview.png) direkam dari build Web
lokal pada viewport 390 x 1421, device scale 2; bukan screenshot Android.
