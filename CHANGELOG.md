# Changelog

> **Living document:** perbarui bersama setiap perubahan terkait menurut [aturan dokumentasi](rules/documentation.md#living-documents).

Catatan ini mengikuti versi repository. Versi spesifikasi mengikuti
[kebijakan versioning](docs/VERSIONING.md).

## [Unreleased]

## [0.1.0] - 2026-10-19

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
