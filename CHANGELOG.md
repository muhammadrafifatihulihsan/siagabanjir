# Changelog

> **Living document:** perbarui bersama setiap perubahan terkait menurut [aturan dokumentasi](rules/documentation.md#living-documents).

Catatan ini mengikuti versi repository. Versi spesifikasi mengikuti
[kebijakan versioning](docs/VERSIONING.md).

## [Unreleased]

- Penataan Flutter: sepuluh folder fitur beserta file/kelas/enum dan tes memakai
  nama Indonesia; hapus 48 penanda folder kosong dan lima file dokumen tanpa
  pemakai. Lima model yang memakai Flutter dipindah ke presentation/models.
  README dan rujukan struktur diselaraskan; perilaku UI tetap.
  Nama lama pada catatan implementasi di bawah adalah riwayat sebelum
  [migrasi WS-DEC-063](docs/DECISIONS.md#flutter-indonesia-063).

- Halaman pantau wilayah publik (RegionMonitorScreen) sesuai desain SVG pemilik
  (`monitor_public.svg`) pada fitur `monitor`, mencakup `MonitorHeader` (tombol kembali
  dan judul halaman adaptif), `MonitorFeaturedCard` (kartu sorotan sungai utama bertepi
  #BFDBFE dengan metrik ketinggian 140 cm, tren ▲ +20 cm, bar segmen warna ambang batas
  Normal/Waspada/Bahaya, rentang cm, dan peringatan luapan tanggul 150 cm / sisa 10 cm),
  `MonitorRiverPostsSection` (daftar pos pantau sungai: Kuranji, Gadut, Muaro),
  `MonitorInfrastructureCard` (status operasional Pintu Air Pintu 3 Buka 60% dan Pompa
  Mobile Kuranji 2 Unit Siap), integrasi navigasi dari kartu status pantau Beranda
  dan sheet pratinjau (`HomeAction.monitor`), serta 6 tes widget bebas overflow.

- Halaman brankas dokumen siaga keluarga (DocumentsVaultScreen) sesuai desain SVG
  pemilik (`documents_vault.svg`) pada fitur `documents`, mencakup `DocumentsVaultCard`
  (tiga berkas vital: KK, KTP, dan Akta Kelahiran Anak dengan badge format, detail,
  dan tombol ganti berkas), `DocumentsInfoBanner` (edukasi perlindungan berkas sipil
  untuk dinas Disdukcapil pasca-banjir), `DocumentsActionButtons` (simpan dokumen dan
  unduh arsip dinas ZIP), integrasi rute navigasi dari kartu Dokumen Siaga di Beranda
  dan sheet pratinjau, serta 10 tes widget bebas overflow.

- Halaman pendaftaran akun baru warga (RegisterScreen) sesuai desain SVG pemilik
  (`auth_register.svg`) pada fitur `auth`, mencakup `RegisterCard` (nama lengkap KTP,
  nomor ponsel/email, sandi akun dengan toggle visibilitas, checkbox persetujuan syarat
  & ketentuan privasi, tombol 'Daftar ke SiagaBanjir >', tombol daftar Google),
  `RegisterFooter` ('Sudah punya akun? Masuk Sekarang'), serta integrasi navigasi dua arah
  dengan `LoginScreen` dan 10 tes widget bebas overflow.

- Halaman checklist tas siaga bencana (EmergencyBagScreen) sesuai desain SVG
  pemilik (emergency_bag_checklist.svg), terhubung dari akses cepat "Tas Siaga"
  pada beranda. Fitur menyediakan kartu ringkasan kesiapan logistik keluarga dengan
  badge persentase dinamis dan progress bar, empat kartu kategori (Dokumen Berharga,
  Obat & P3K Keluarga, Logistik & Komunikasi, Pakaian & Perlengkapan), checkbox
  rounded kustom interaktif, banner himbauan pintu utama, serta navbar CitizenNavigation.

- Halaman kotak masuk peringatan siaga warga (MessagesInboxScreen) sesuai SVG
  pemilik (messages_inbox.svg), terhubung dari tombol notifikasi pada CitizenHeader
  di beranda maupun laporan. Fitur menyediakan header dengan status pesan baru,
  filter tab horizontal (Semua, Darurat, Cuaca BMKG, Posko), kartu pesan dengan
  aksen garis warna semantik vertikal, instansi pengirim, serta dialog aksi demo.

- Implementasi layar masuk ke akun (login) Flutter sesuai SVG pemilik (`auth_login.svg`)
  pada fitur `auth`, mencakup `LoginHeader`, `LoginCard`, tombol masuk Google
  dengan kurva 4 warna SVG, tautan pendaftaran, dan 9 tes widget bebas overflow.

- Implementasi layar profil pengguna warga (`features/account`) sesuai desain SVG
  pemilik (`account_warga_profile.svg`) beserta 8 tes widget bebas overflow.

- Halaman buat laporan Flutter sesuai SVG pemilik, terhubung dari beranda,
  dengan pilihan lokal, deskripsi dan konfirmasi keluar. Header/ikon bersama
  digunakan lintas fitur; kamera, GPS dan kirim belum terintegrasi.

- Ikon SiagaBanjir dari logo tetes air lokal untuk launcher Android, ikon
  adaptif/monochrome, Web dan favicon. Splash native Android serta pemuatan
  Web memakai identitas yang sama; Web menyediakan pemulihan gagal startup.

- Satu mockup beranda warga Flutter mengikuti SVG pemilik, dengan 17 ikon
  hasil slice lokal, panel pratinjau fitur, layout adaptif dan tes widget.
  Seluruh status/angka adalah contoh; belum ada integrasi backend/perangkat.

- Struktur Flutter Feature-First + Layered Architecture untuk 15 fitur warga/admin,
  folder infrastruktur/UI bersama, serta panduan layer dan pembagian kerja tim.
  Tahap ini hanya placeholder dan dokumentasi; aplikasi counter tetap.

- GIT-CEPAT.md berisi perintah Git Bash singkat: main lokal melacak branch
  remote anggota, push eksplisit, PR development, dan siklus sesudah merge.

- Satu panduan Git pemula terpisah di docs: clone pertama, identitas/branch,
  rutinitas harian, validasi, commit/push, PR/revisi, sinkronisasi sesudah merge,
  clone di perangkat lain, dan penanganan error dengan contoh Git Bash.

### Diubah

- Memulihkan penutup rute dan blok tombol Pantau yang hilang sebelum cabang
  Riwayat, sehingga aplikasi kembali lolos analyzer dan seluruh 91 tes Flutter.

- Pembersihan sisa conflict markers pada `HomeNavigation` dan penyesuaian import `CitizenHeader`
  pada `ProfileScreen`.

- UI/UX laporan diselaraskan dengan home: navbar bersama, pilihan awal kosong,
  indikator/fokus jelas, teks lebih terbaca, label input menetap dan ruang keyboard.
  Widget dan tes di-slicing per tanggung jawab, dengan komentar fungsi berbahasa Indonesia.

- Ikon utama dan chevron kartu Dokumen Siaga/Lapor Banjir diratakan tengah;
  ukuran optis dokumen disetarakan dengan kamera tanpa mengubah aset sumber.

- Folder Flutter menjadi apps/siagabanjir dan package Dart siagabanjir;
  label Android serta metadata Web memakai SiagaBanjir. Referensi aktif dan
  pengecualian format mengikuti folder baru; identitas instalasi Android tetap.
- Layout status berkas/kuota dan isi kartu beranda adaptif terhadap ruang/teks.
  Label pendukung diperbesar dan badge akses cepat tidak memecah kata.

- Beranda memakai Inter 4.1 yang dibundel lokal beserta lisensi dan lima weight.
  Label Data contoh serta catatan Mockup beranda dihapus sesuai revisi pemilik.

- EditorConfig tidak memaksa ukuran indentasi XML Android Flutter agar
  alignment komentar template diterima; pemeriksaan format lainnya tetap aktif.
- Status workspace mencatat scaffold Flutter Android/Web yang sudah dibuat tim.

- Git cepat dikonversi dari TXT ke Markdown dengan bagian per anggota dan
  blok kode; seluruh rujukan aktif memakai GIT-CEPAT.md. Perintah tetap sama.

- Prompt audit di root dihapus atas konfirmasi pemilik; rujukan audit dan RTM
  menunjuk salinan historis pada commit agar bukti sumber tetap tersedia.

- Sesuai mandat pemilik, pembaruan lokal pada TXT memakai reset hard ke
  origin/main dan clean -fd setelah seluruh pekerjaan masuk main; ignored
  dipertahankan dan tidak memakai force push.

- TXT Git menyediakan blok Rafi, Hasan dan Melia siap salin, dengan satu
  langkah pembaruan main bersama untuk tugas berikutnya.

- TXT Git dipadatkan menjadi dua siklus; pembaruan main lokal diambil dari
  origin/main setelah PR anggota dan promosi ke main selesai digabung.

- Handoff dan bukti workspace mencatat publikasi panduan Git pemula ke
  branch-rafi serta empat job CI push yang berhasil setelah mandat push pemilik.
- Alur tim menjadi lima branch permanen: branch anggota → PR development → PR
  main. BRD/PRD aspek Git, keputusan, RTM dan panduan pemula diselaraskan.
- CI mencakup push kelima branch, PR kedua base dan perubahan base; validasi arah
  menolak fork/pasangan salah, dilengkapi regresi dan checkout tanpa credential tersimpan.
- Audit GitHub memisahkan fakta, SOP dan kontrol Settings yang belum diterapkan;
  template tugas/PR dan prosedur sinkronisasi mempertahankan riwayat merge commit.
- Bukti CI push dan PR nyata pada commit implementasi dicatat dalam WORKSPACE
  dan handoff; draft PR menuju development tetap menunggu review/merge owner.

- AI wajib commit lokal setiap unit perubahan, termasuk typo, tanpa konfirmasi
  tambahan; working tree diperiksa bersih sebelum unit berikut atau penutupan.
- Panduan tim mencakup dasar Git/GitHub, branch, commit, push/PR, konflik,
  pekerjaan awal, checkpoint, kendala akses, dan batas bukti hasil pemeriksaan.
- Adapter IDE, katalog skill, template PR dan skenario evaluasi mengikuti
  aturan commit bersama; push dan publikasi tetap sesuai mandat.
- README utama memperkenalkan tujuan, pengguna, fitur yang direncanakan, dan
  status SiagaBanjir dengan bahasa untuk pembaca umum.
- Panduan validasi dipindahkan ke GITHUB-WORKFLOW; status versi dan struktur
  proyek berada di WORKSPACE. Indeks serta rujukan teknis diselaraskan.

## [0.1.0] - 2026-10-20

Rilis awal baseline dokumentasi dan workspace SiagaBanjir.
Backend dan Flutter belum diimplementasikan. Rilis ini tidak menyediakan APK
atau layanan siap pakai; pengujian aplikasi/provider/perangkat/UAT tetap NOT_RUN.

### Ditambahkan

- BRD/PRD v0.1.0 dan FRD/SRS v1.0.0 approved, keputusan, keterlacakan, dan panduan desain.
- Kontrak OpenAPI 3.1 dengan 72 operasi, 165 skema, serta 54 contoh payload.
- Tujuh rules, delapan skill proyek, dan adapter instruksi IDE.
- Lokasi aplikasi tim di apps/server dan apps/app, masing-masing berupa penanda kosong.
- Konfigurasi format lintas OS, validator dokumentasi/kontrak, CI, dan rilis dari tag.

### Diperbaiki

- Ekspor session lokal dikecualikan dari lint Markdown dan validator tautan;
  tes regresi memastikan handoff aktif tetap diperiksa.
- Label ringkasan persetujuan diselaraskan dengan keputusan editorial.
- Redaksi dokumentasi menjadi catatan profesional; transkrip percakapan diganti
  ringkasan keputusan dengan identitas, tanggal, dan cakupan otorisasi tetap.
- Rujukan SRS, navigasi dokumen, petunjuk GitHub, dan informasi status workspace.
- Validasi akar repository, kapitalisasi tautan, YAML skill, format payload,
  serta kontrak replay operasi yang mengembalikan rahasia.
- Kontrak kredensial dan reset kuota diselaraskan dengan SRS serta contoh regresi.
- Skema respons unduh media yang tidak digunakan dihapus; Redocly memeriksa
  seluruh komponen yang tidak dirujuk.
- Workflow CI dan rilis memakai action berbasis Node 24. Catatan rilis diambil
  dari entri versi pada CHANGELOG.

### Disederhanakan

- Informasi repository digabung ke README dan panduan GitHub.
- Rencana penyusunan SRS yang telah selesai digabung ke catatan keputusan.
- Riwayat audit dan pertanyaan berulang diringkas dengan mempertahankan
  ID, keterlacakan, dan batas bukti.
