# Indeks dokumentasi SiagaBanjir

> **Living document:** perbarui bersama setiap perubahan terkait menurut [aturan dokumentasi](../rules/documentation.md#living-documents).

[README utama](../README.md) memperkenalkan SiagaBanjir untuk pembaca umum.
Indeks ini menjadi pintu masuk spesifikasi dan panduan bagi tim pengembang.
Baru memakai Git? Mulai dari [panduan praktik clone sampai PR](GIT-UNTUK-PEMULA.md)
dan [penanganan kondisi Git](GITHUB-WORKFLOW.md#kondisi-git).

Perintah ringkas untuk bekerja di `main` lokal: [GIT-CEPAT.txt](GIT-CEPAT.txt).

## Spesifikasi dan desain

| Dokumen | Fungsi |
|---|---|
| [BRD](BRD.md) | Tujuan, lingkup, dan kebutuhan bisnis |
| [PRD](PRD.md) | Kebutuhan produk dan prioritas |
| [FRD](FRD.md) | Perilaku, aturan bisnis, AC, dan skenario uji |
| [SRS](SRS.md) | Arsitektur, data, antarmuka, dan persyaratan teknis |
| [OpenAPI](openapi.json) | Kontrak HTTP yang dapat divalidasi |
| [Contoh payload](examples.json) | Kasus valid dan tidak valid untuk kontrak |
| [DESIGN](DESIGN.md) | Desain UI, ikon, state, dan aksesibilitas |

BRD/PRD v0.1.0 dan FRD/SRS v1.0.0 berstatus APPROVED.
Persetujuan tersebut berlaku untuk spesifikasi; pengujian aplikasi tetap NOT_RUN.

## Keputusan dan panduan kerja

| Dokumen | Fungsi |
|---|---|
| [DECISIONS](DECISIONS.md) | Keputusan, alasan, otorisasi, dan perubahan |
| [TRACEABILITY](TRACEABILITY.md) | Pemetaan sumber, requirement, penerimaan, dan bukti |
| [WORKSPACE](WORKSPACE.md) | Status versi, struktur, peta sumber, konfigurasi, dukungan OS/IDE, dan verifikasi |
| [SKILL-RESEARCH](SKILL-RESEARCH.md) | Seleksi referensi dan skenario evaluasi skill |
| [GITHUB-AUDIT](GITHUB-AUDIT.md) | Fakta audit GitHub, gap, matriks akses dan rancangan Settings yang belum diterapkan |
| [GITHUB-WORKFLOW](GITHUB-WORKFLOW.md) | Panduan Git untuk pemula, commit lokal AI, kendala umum, validasi, push dan pull request |
| [GIT-UNTUK-PEMULA](GIT-UNTUK-PEMULA.md) | Urutan salin-tempel setup pertama, kerja harian, commit/push, PR/revisi, sesudah merge dan clone di perangkat lain |
| [VERSIONING](VERSIONING.md) | Kebijakan versi dan prosedur rilis |
| [SESSION-HANDOFF](SESSION-HANDOFF.md) | Kondisi terkini dan pekerjaan berikutnya |

Instruksi utama ada di [AGENTS](../AGENTS.md), prosedur pada
[katalog skill](../SKILL.md), dan aturan bersama di [rules](../rules/workflow.md).
[README aplikasi](../apps/README.md) menetapkan tanggung jawab inisialisasi tim.
Riwayat versi repository tersedia dalam [CHANGELOG](../CHANGELOG.md).
