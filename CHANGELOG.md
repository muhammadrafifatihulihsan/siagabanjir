# Changelog

> **Living document:** perbarui bersama setiap perubahan terkait menurut [aturan dokumentasi](rules/documentation.md#living-documents).

Catatan ini mengikuti versi repository. Versi spesifikasi mengikuti
[kebijakan versioning](docs/VERSIONING.md).

## [Unreleased]

### Ditambahkan

- Satu panduan Git pemula terpisah di docs: clone pertama, identitas/branch,
  rutinitas harian, validasi, commit/push, PR/revisi, sinkronisasi sesudah merge,
  clone di perangkat lain, dan penanganan error dengan contoh Git Bash.

### Diubah

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
