# Desain UI SiagaBanjir

> **Living document:** perbarui bersama setiap perubahan terkait menurut [aturan dokumentasi](../rules/documentation.md#living-documents).

Arahan implementasi di bawah memenuhi mandat UI bersih dan ikon standar.
Seluruh layar warga tersedia sebagai demo lokal; integrasi bisnis server belum tersedia.
Fungsi, hak akses dan state tetap mengikuti [FRD](FRD.md) dan [SRS](SRS.md).

## Arah visual dan isi layar

### Acuan beranda warga dari pemilik

Mandat 23 Oktober 2026 memakai [SVG beranda](../apps/siagabanjir/design/app_beranda.svg)
sebagai acuan wajib satu layar. [Catatan aset](../apps/siagabanjir/design/README.md)
memuat sumber, slicing dan batas mockup. Ini pengecualian terarah terhadap
baseline ikon Material di bawah: 17 ikon beranda memakai hasil slice lokal,
sedangkan kontrol tambahan panel memakai Material. Tidak memakai package ikon
atau font remote. Ketentuan ini tidak mengganti seluruh desain fitur lainnya.

Tema pada `apps/siagabanjir/lib/shared/theme/siaga_theme.dart` memakai latar #F8FAFC,
teks #0F172A, biru #2563EB, judul status #1E3A8A, dan teks sekunder #64748B.
Teks sekunder di permukaan berwarna memakai #475569 untuk kontras. Kartu status
biru #D5E4FF; akses cepat biru muda/merah muda/ungu muda/hijau mengikuti SVG.
Radius beranda 12/16/20/22/24 sesuai komponen sumber, sebagai pengecualian token
awal 8/12. Revisi pemilik memakai Inter 4.1 lokal weight 400/500/600/700/800;
teks tetap widget yang dapat diperbesar. SVG berisi outline, jadi Inter adalah
pilihan yang disetujui, bukan klaim identifikasi font Figma asli.

Beranda membatasi konten pada lebar 600 logical pixels, memakai scroll dengan
header/navbar menetap, dan grid dua kolom yang menjadi satu pada teks besar.
Area sentuh minimal 48; label waktu/navigasi diperkuat kontrasnya dari sumber.
Angka Siaga 2, tinggi air, notifikasi, berkas dan kuota adalah ilustrasi dengan
data statis, bukan data layanan atau perubahan level/kuota normatif. Atas
permintaan pemilik, label Data contoh dan catatan Mockup beranda dihilangkan
dari layar; keterbatasan pengembangan tetap dicatat pada dokumentasi.
Semua pintu masuk fitur kini membuka layar langsung. Menu Lengkap berupa daftar
akses. Kamera, TTS dan ekspor berkas lokal tersedia; transaksi server belum ada. Bukti: [mockup beranda](WORKSPACE.md#home-mockup).

### Revisi keterbacaan kartu beranda

Header kartu memakai badge dan status dengan ruang alami: status rata kanan
ketika muat, berpindah baris saat ruang sempit/teks besar. Isi kartu memakai
judul 16/700, deskripsi 14/400 dengan tinggi baris 1.4; label status 12/600.
Deskripsi mendapat lebar penuh ketika lebar dalam kartu kurang dari 260
logical pixels setelah pembesaran teks. Tidak memakai ellipsis atau mengecilkan
font untuk memaksa teks muat. Ikon dan chevron tetap aset lokal dari SVG;
kedua kartu punya petunjuk navigasi yang konsisten. Ikon utama dan chevron
rata tengah secara vertikal terhadap blok teks (judul pada susunan sempit).
Lingkaran ikon tetap 44; slice dokumen ditampilkan 24 dan kamera 22 agar
bentang glyph terlihat sama sekitar 21, mengimbangi padding transparan sumber.
Ini penyesuaian optis pada dua kartu saja; aset asli tidak diubah.

Label lokasi, badge akses cepat dan navigasi dinaikkan ke 12 untuk keterbacaan.
Badge akses cepat berpindah utuh ketika tidak muat di samping ikon. Struktur
warna/kartu sumber dipertahankan; tidak menambah fitur bisnis atau dekorasi.
[Bukti revisi](WORKSPACE.md#home-layout-name) mencatat batas inspeksi aktual.

### Pedoman umum fitur berikutnya

Ikon launcher dan splash menggunakan logo tetes air dari SVG pemilik:
biru #2563EB di atas #EFF6FF untuk ikon, latar #F8FAFC untuk splash. Native
Android mengikuti bentuk/masking launcher serta splash OS; Web memakai judul
SiagaBanjir dan status pemuatan dengan Inter lokal. Tidak menunda masuk ke
beranda untuk memamerkan splash. [Sumber dan regenerasi](../apps/siagabanjir/design/README.md#ikon-aplikasi-dan-splash)
memuat konfigurasi platform; perubahan ini tidak mengubah layout beranda.

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

## Audit UI/UX warga 27 Oktober 2026

[WS-DEC-064](DECISIONS.md#flutter-uiux-064) memakai Beranda sebagai tolok ukur
keterbacaan: Inter, judul halaman 22, judul bagian 16, isi 14, keterangan 12,
tinggi baris isi 1.4. Angka metrik dan judul autentikasi tetap memiliki hierarki
tersendiri. Ukuran ini token bersama, bukan alasan memotong teks besar.

Empat tab mempertahankan state/scroll, header memakai instance widget yang sama,
dan navbar berada pada slot bottomNavigationBar agar snackbar tidak menutupinya.
Indikator tab tetap diperbarui ketika pilihan berubah; tidak mengklaim semua
render/paint berhenti. Keyboard menyembunyikan header/navbar dan hanya kerangka
luar menyesuaikan ruang. Halaman detail tetap mempunyai tombol kembali.

Dialog memakai DialogSiaga (Material AlertDialog dengan radius 24, latar putih,
Inter dan isi yang dapat digulir), sehingga fokus, semantics dan tombol kembali
tetap berasal dari Flutter. Scroll memakai bouncing tanpa glow; reduced motion
memakai clamping dan aksi kembali ke atas tanpa animasi. Ini pilihan perilaku,
bukan pengukuran peningkatan FPS pada HP.

Perbandingan 12 SVG aktif mempertahankan susunan utama dan warna tiap fitur.
Direktori kontak memakai kartu ringkas ikon/nama/nomor/aksi, kartu darurat dan
posko; filter serta kontak tambahan dipertahankan agar informasi lama tetap ada.
Aksi kontak publik tetap salin/informasi, bukan klaim nomor resmi atau panggilan.
Panduan memulihkan judul langkah 4 tentang alas kaki tertutup dan speaker tiap
langkah. Bar warna Pantau diperbaiki agar benar-benar memiliki tinggi tampilan.
Status dokumen tidak dipotong, dan nama berkas panjang tetap boleh disingkat.

Penyimpangan sengaja dari SVG: pesan penyimpanan/enkripsi/registrasi harus sesuai
kemampuan demo, persetujuan daftar dimulai kosong, target sentuh diperbesar,
dan dialog/input ditambah untuk tindakan nyata. Tidak menyalin klaim bahwa
nomor, jarak posko, hasil AI atau status banjir fixture telah diverifikasi.
Nama folder tetap Indonesia. Desain deprecated_admin_posko tidak diimplementasikan.

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
termasuk uses-material-design, yang sudah aktif pada pubspec proyek tim.

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

### Halaman buat laporan dari SVG pemilik

Mandat 25 Oktober 2026 memakai [reports_create.svg](../apps/siagabanjir/design/reports_create.svg)
sebagai acuan kartu kamera, lokasi, kategori, kebutuhan, deskripsi dan kirim.
Inter lokal, palet biru, kartu putih radius 22, header bersama dan navbar Lapor
aktif menyambungkan tampilan dengan beranda. Ikon kontrol memakai Material;
header/navbar memakai aset lokal yang sudah tersedia. Konten dapat digulir,
lebar maksimal 600; pilihan menjadi satu kolom pada ruang sempit/teks besar.

Alamat diberi label contoh; klaim kamera terverifikasi, akurasi GPS dan kirim
otomatis offline diganti keterangan kemampuan aktual. Kategori dan kebutuhan
hanya pilihan lokal; tidak mengubah kontrak atau menyediakan dispatch bantuan.
Deskripsi tanpa label opsional mengikuti baseline. Konfirmasi keluar melindungi
isian lokal, bukan penyimpanan draf. [Bukti](WORKSPACE.md#report-create-ui).

### Penyelarasan UI/UX laporan dengan home

Revisi atas mandat pemilik mempertahankan urutan SVG dengan prinsip UI home:
judul section 16/700, isi dan pilihan 14 dengan tinggi baris 1.4, label pendukung
12, kartu radius 22 dan jarak kelompok 16. CitizenNavigation menjadi komponen
bersama; ikon aktif biru dan nonaktif abu-abu, label/pill memperjelas state.
Token selectionBackground #EFF6FF dan navigationBackground #E1EDFF dipakai
bersama untuk menghindari variasi warna per layar.

Pilihan kategori/kebutuhan dimulai kosong. Radio menandakan satu pilihan;
checkbox menandakan beberapa pilihan. Instruksi singkat, indikator bentuk,
semantics checked dan garis fokus tidak mengandalkan warna saja. Dua kolom
memiliki tinggi minimum dua baris yang mengikuti skala teks; pada ruang sempit
berubah satu kolom. Kontrol bertepi memakai #64748B, pilihan/fokus #2563EB.

Deskripsi memiliki label menetap, contoh spesifik, penghitung karakter Indonesia
dan fokus yang jelas. Header/navbar sementara disembunyikan saat keyboard
terbuka. Tab aktif menggulir ke awal; preferensi pengurangan animasi dihormati.
Batal keluar mempertahankan teks dan memulihkan fokus; konfirmasi hanya untuk
isian yang masih ada. Dialog dapat digulir pada teks besar.

Perisai hijau dihapus karena dapat menyiratkan foto telah diverifikasi;
penjelasan kamera memakai teks netral. Ini revisi UI lokal, bukan integrasi
kamera/GPS/kirim atau perubahan kontrak. [Bukti](WORKSPACE.md#report-uiux-refinement).

### Halaman masuk ke akun (login) dari SVG pemilik

Mandat 26 Oktober 2026 memakai `auth_login.svg` sebagai acuan tampilan layar masuk warga.
Palet latar #F8FAFC, kartu putih radius 22 bertepi #E2E8F0, judul section 22/800,
isi/label 13/700, teks input 14/600 dengan Inter lokal. Wadah brand tetes air 58x58
radius 18 memakai biru muda #EFF6FF dengan border #BFDBFE.
Input nomor ponsel/email dan kata sandi/PIN berlatar #F8FAFC dengan border #E2E8F0
dan fokus biru #2563EB. Baris opsi memakai Checkbox Ingat Saya serta link Lupa Sandi
yang adaptif (Wrap). Tombol utama biru #2563EB dengan teks dan chevron putih,
diikuti pemisah 'atau' dan tombol masuk Google dengan logo 4 warna presisi kurva SVG.
Bagian bawah menyediakan tautan pendaftaran bagi warga yang belum memiliki akun.
[Bukti pemeriksaan](WORKSPACE.md#auth-login-ui).

### Kotak masuk peringatan siaga dari SVG pemilik

Mandat 25 Oktober 2026 memakai [messages_inbox.svg](../apps/siagabanjir/design/messages_inbox.svg)
sebagai acuan kotak masuk peringatan siaga warga. Layar diakses dari tombol
notifikasi CitizenHeader di beranda maupun laporan. Struktur visual:

- Header dengan tombol kembali (rounded 14, border #E2E8F0, touch target 48),
  judul "Peringatan Siaga" 20/700 #0F172A, dan badge status "3 Baru" 14/700 #DC2626.
- Tab filter horizontal berbentuk pill (Semua, Darurat, Cuaca BMKG, Posko).
  Pill aktif menggunakan warna #0F172A dengan teks putih; pill tidak aktif
  berlatar putih dengan border #E2E8F0 dan teks #334155.
- Kartu pesan `KartuPesan` berlatar putih dengan radius 20 dan border #E2E8F0.
  Kartu memiliki aksen garis vertikal di sisi kiri selebar 4 px penanda tingkat/kategori:
  merah #DC2626 untuk Siaga 2 (Waspada), oranye #D97706 untuk Potensi Banjir Kilat,
  biru #2563EB untuk Posko Bencana Siaga, dan netral #E2E8F0 untuk Normal (Siaga 4).
- Badge kategori, stempel waktu #64748B, nama instansi sumber #1D4ED8 13/600,
  judul 16/700 #0F172A, deskripsi 14/400 #334155 dengan tinggi baris 1.4.
- Tombol aksi: "Rute Evakuasi" (#EFF6FF, border #BFDBFE, teks #2563EB), "Bagikan"
  (#F1F5F9, teks #0F172A), dan "Hubungi Posko" (#EFF6FF, border #BFDBFE, teks #2563EB).
- Seluruh aksi dan ketukan kartu menampilkan dialog penjelasan demo tanpa
  mengklaim panggilan darurat nyata. Navigasi bawah menggunakan CitizenNavigation bersama.
