# Acuan beranda warga

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
Total PNG runtime 24.295 byte; hanya direktori PNG tersebut masuk bundle aplikasi.

Teks dan kartu dibangun sebagai widget Flutter, bukan screenshot dengan area
klik. Font bawaan Flutter dipakai karena sumber SVG mengubah teks menjadi
path dan tidak menyertakan file font. Tidak ada font, ikon, atau gambar remote
pada kode layar. Titik status digambar sebagai lingkaran Flutter agar tidak
memicu font Unicode cadangan dari internet.

Untuk mengekstrak ulang, gunakan Python dengan Playwright pada lingkungan
pengembangan dan browser Chromium yang sudah terpasang. Dari root repository:

```sh
python apps/app/design/slice_icons.py --browser "<path-browser-chromium>"
```

Perintah menulis ulang SVG hasil slice dan PNG; periksa diff setelahnya.
Playwright hanya alat pengembangan, bukan dependensi aplikasi Flutter.
Sumber desain penuh tidak didaftarkan sebagai aset runtime.

## Adaptasi dan batas mockup

- Hierarki, palet, ikon, teks utama, kartu dan navigasi mengikuti SVG.
  Kontras label waktu/navigasi diperkuat; target sentuh minimal 48 logical pixels.
- Label `Data contoh` dan catatan mockup membedakan angka ilustrasi dari data
  sungguhan. Siaga 2, tinggi air, 3 notifikasi, 3/3 berkas dan kuota 1/2 bukan
  status resmi, berkas tersimpan atau aturan kuota produk.
- Konten dapat digulir, header/navigasi tetap terlihat. Teks besar mengubah
  grid menjadi satu kolom; lebar konten dibatasi 600 logical pixels pada Web.
- Tombol membuka panel pratinjau dengan jalan kembali. Tidak mengirim laporan,
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
