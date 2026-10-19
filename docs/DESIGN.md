# Desain UI SiagaBanjir

> **Living document:** perbarui bersama setiap perubahan terkait menurut [aturan dokumentasi](../rules/documentation.md#living-documents).

Arahan implementasi di bawah memenuhi mandat UI bersih dan ikon standar.
Ini keputusan desain proyek untuk pekerjaan berikutnya; belum ada UI berjalan.
Fungsi, hak akses dan state tetap mengikuti [FRD](FRD.md) dan [SRS](SRS.md).

## Arah visual dan isi layar

Warga membutuhkan pengiriman laporan yang jelas dan bacaan Pantau yang mudah
dipindai; admin membutuhkan antrean, bukti dan tindakan review yang terurut.
Mulai dari kebutuhan itu sebelum memilih komponen.

- Gunakan Material 3 sebagai dasar komponen, lalu bentuk tema SiagaBanjir
  secara konsisten. Pertahankan komponen standar untuk input, dialog dan navigasi.
  Rujukan teknis: [Material 3 Flutter](https://api.flutter.dev/flutter/material/ThemeData/useMaterial3.html).
- Pilihan proyek: permukaan netral, teks berkontras, satu warna primer biru
  untuk navigasi/tindakan, serta warna semantik khusus status. Tidak mengandalkan
  warna saja; tingkat selalu disertai label.
- Hirarki umum: judul konteks, informasi penting, tindakan utama, lalu detail.
  Gunakan daftar/tabel untuk data berulang; kartu hanya untuk kelompok yang
  memang mandiri. Tidak semua bagian perlu kotak, bayangan atau rounded pill.
- Satu tindakan utama per konteks keputusan. Aksi destruktif dipisahkan dan
  menjelaskan dampaknya. Jangan menambah dashboard statistik tanpa sumber data.
- Hindari pola template yang tidak membantu: hero pemasaran di antrean admin,
  gradient/glow/glass dekoratif, emoji pengganti ikon, judul bombastis,
  lorem ipsum, badge “AI” di semua elemen, serta angka demo seolah data aktual.

## Token dan komponen

| Unsur | Pilihan awal proyek |
|---|---|
| Warna | Peran ColorScheme; status memakai token tersendiri dengan pasangan foreground/background |
| Tipografi | TextTheme yang konsisten, font sistem/bawaan; jangan mengunduh font eksternal sebagai syarat demo |
| Jarak | Skala 4, 8, 12, 16, 24, 32 logical pixels; perubahan global melalui token |
| Kontainer khusus | Radius 8 atau 12 bila diperlukan; komponen Material mengikuti tema bersama |
| Ikon | Glyph umumnya 24 logical pixels; area interaksi lebih besar daripada glyph |
| Form | Label menetap, bantuan/error dekat field, nilai tidak hilang saat gagal |
| Gerak | Hanya menjelaskan perubahan state; hormati pengaturan pengurangan animasi |

Nilai awal ini pilihan proyek, bukan aturan vendor yang universal. Ketika tim
mengubah token berdasarkan hasil review, ubah sumber tema dan dokumen ini bersama;
jangan menanam variasi angka/warna baru di tiap layar.

## Ikon standar

Baseline: **Material Icons melalui kelas Icons bawaan Flutter**, varian outlined
untuk keadaan biasa. Varian filled dapat menandai destinasi terpilih pada set
yang sama. Hindari mencampur Material Icons dengan Material Symbols/Cupertino/
Font Awesome/Lucide tanpa keputusan migrasi yang jelas. Jangan menambah package
ikon hanya untuk mendapatkan glyph yang sudah tersedia.

Saat tim menginisialisasi Flutter, pastikan konfigurasi Material font sesuai
[panduan Icons Flutter](https://api.flutter.dev/flutter/material/Icons-class.html),
termasuk uses-material-design. Tidak ada pubspec yang dibuat pada tahap ini.

| Makna | Ikon dasar |
|---|---|
| Pantau | Icons.map_outlined |
| Laporan banjir | Icons.water_drop_outlined |
| Dokumen pribadi | Icons.folder_outlined |
| Keluarga | Icons.people_outline |
| Tas siaga | Icons.backpack_outlined |
| Kontak | Icons.phone_outlined |
| Inbox | Icons.inbox_outlined |
| Panduan | Icons.menu_book_outlined |
| Review admin | Icons.fact_check_outlined |
| Hapus | Icons.delete_outline |
| Muat ulang | Icons.refresh |

Tabel memetakan makna, bukan kewajiban memasukkan semua fitur ke satu navbar.
Destinasi utama memiliki label teks. Tombol ikon memiliki nama aksi aksesibel
dan tooltip yang relevan; hindari pembacaan ganda oleh screen reader.
Ikon dekoratif tidak diberi makna palsu. Logo/ilustrasi berbeda dari ikon aksi;
hanya ditambahkan bila memang dibutuhkan, dengan asal/lisensi yang jelas.

## Aksesibilitas dan layout

- Target proyek untuk kontrol sentuh minimal 48 × 48 logical pixels.
  Uji teks biasa minimal 4.5:1; teks besar memenuhi batas 3:1 sesuai definisi
  aksesibilitas. Jangan mengunci text scaling; uji layar sempit dengan font
  sistem terbesar yang didukung. [Panduan Flutter](https://docs.flutter.dev/ui/accessibility/ui-design-and-styling).
- Bagian visual kontrol/status yang diperlukan untuk dikenali mempunyai
  kontras minimal 3:1 terhadap warna bersebelahan, dengan pengecualian standar
  yang relevan. [WCAG non-text contrast](https://www.w3.org/WAI/WCAG22/Understanding/non-text-contrast.html).
- Target 48 milik proyek tidak boleh disebut batas minimum WCAG AA: WCAG 2.2
  SC 2.5.8 menetapkan 24 × 24 CSS pixels atau pengecualiannya.
  [WCAG target size](https://www.w3.org/WAI/WCAG22/Understanding/target-size-minimum.html).
- Admin Web mendukung keyboard, urutan fokus yang masuk akal, indikator fokus,
  dan pengembalian fokus setelah dialog. Status tidak hanya memakai warna.
- Layout mengikuti ruang tersedia, bukan deteksi OS atau nama perangkat.
  Gunakan constraints/LayoutBuilder atau MediaQuery.sizeOf sesuai kebutuhan.
  Ubah susunan kolom/navigasi berdasarkan ruang; jangan sekadar mengecilkan
  desktop menjadi mobile. [Flutter adaptive](https://docs.flutter.dev/ui/adaptive-responsive/general).
- Data lebar boleh memakai area tabel yang dapat digulir; label/aksi penting
  tetap dapat dicapai. Uji nama/lokasi panjang, daftar kosong dan text scaling.

## State dan bahasa produk

Gunakan bahasa Indonesia yang lugas: “Kirim laporan”, “Coba lagi”,
“Belum dinilai”, “Perlu ditinjau”. Gunakan istilah final FRD untuk state
bisnis; jangan mengganti maknanya demi kalimat yang terdengar positif.

Bedakan draf lokal, menunggu penerimaan, laporan diterima, analisis dan review.
Pantau hanya menampilkan proyeksi publik; “Rendah” bukan jaminan aman.
Kegagalan refresh menampilkan data/waktu terakhir serta kegagalannya.
Empty state menjelaskan belum ada data; error state menjelaskan pemulihan;
loading tidak menampilkan angka/statistik rekaan. Konfirmasi hapus menyebut
dampak dan alasan yang diwajibkan FRD, bukan sekadar “Yakin?”.

## Kecocokan aksi dan hasil

Untuk alur yang berubah, periksa titik masuk → objek/tujuan → sumber data →
state menunggu → hasil tersimpan/gagal → kembali atau pemulihan. Catat bagian
belum diimplementasikan; screenshot hanya menunjukkan tampilan pada satu state.

- Label tombol menyebut tindakan yang benar-benar terjadi. Jangan mengganti
  perilaku bisnis hanya agar label lebih singkat atau alur terlihat selesai.
- Sukses harus sesuai sumber kebenaran: draf lokal berbeda dari penerimaan
  server. Toast bukan bukti data tersimpan, review tercatat atau cleanup selesai.
- Kembali/batal mempertahankan input sesuai FRD; retry mengikuti submission dan
  versi yang sama bila diwajibkan. Dialog memiliki jalan keluar dan fokus jelas.
- Teks error menyebut kegagalan yang diketahui serta tindakan tersedia. Jika
  sebabnya belum diketahui, jangan menyalahkan koneksi atau mengatakan file rusak.
- Gunakan komponen Material dan Semantics Flutter. Uji nama/peran/state dengan
  alat aksesibilitas; contoh ARIA/HTML referensi web bukan atribut untuk Dart.

## Pemeriksaan sebelum menerima perubahan UI

1. Tugas, hierarki dan tindakan utama jelas tanpa dekorasi penutup kelemahan.
2. Ikon, token dan istilah konsisten; tidak ada emoji UI atau statistik palsu.
3. State loading/empty/error/offline/pending/conflict dan alur aksi sampai
   hasil, kembali/batal serta retry ditangani sesuai kebutuhan.
4. Layar sempit/lebar, teks panjang/besar, keyboard dan aksesibilitas diperiksa.
5. Screenshot/hasil visual memakai data sintetis; scope platform dan metode
   dicatat. Jangan mengklaim aksesibilitas penuh dari inspeksi gambar saja.
6. [Sinkronisasi dokumentasi](../rules/documentation.md) selesai.

Sumber visual utama dibaca 18 Oktober 2026; pemeriksaan referensi skill dan
alur ditambahkan 19 Oktober 2026 pada [riset skill](SKILL-RESEARCH.md).
Versi SDK aktual diverifikasi setelah
setup tim tersedia; riset ini tidak mengubah patch dependency dalam SRS.
