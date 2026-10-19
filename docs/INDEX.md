# Indeks Dokumentasi SiagaBanjir

> **Living document:** perbarui bersama setiap perubahan terkait menurut [aturan dokumentasi](../rules/documentation.md#living-documents).

Peta navigasi seluruh dokumen di folder `docs/`. Setiap dokumen memiliki
peran spesifik dalam siklus pengembangan proyek. Gunakan indeks ini untuk
menemukan informasi yang tepat.

## Spesifikasi Produk

| Dokumen | Deskripsi | Status |
|---------|-----------|--------|
| [BRD.md](BRD.md) | **Business Requirements Document** — tujuan bisnis, stakeholder, masalah yang diselesaikan dan batasan proyek | v0.1.0 APPROVED |
| [PRD.md](PRD.md) | **Product Requirements Document** — fitur produk, prioritas, persona pengguna dan kriteria sukses | v0.1.0 APPROVED |
| [FRD.md](FRD.md) | **Functional Requirements Document** — 68 functional requirements, 136 acceptance criteria, 156 test cases; perilaku detail per fitur | v1.0.0 APPROVED |
| [SRS.md](SRS.md) | **Software Requirements Specification** — arsitektur sistem, model data, kontrak API, batasan teknis dan keputusan implementasi | v1.0.0 APPROVED |
| [SRS-PLAN.md](SRS-PLAN.md) | Rencana tahap penyusunan SRS (sudah dilaksanakan, disimpan sebagai riwayat asal) | Historis |

## Kontrak API

| Dokumen | Deskripsi | Status |
|---------|-----------|--------|
| [openapi.json](openapi.json) | **OpenAPI 3.1** — kontrak API lengkap: 72 operasi, 166 schema, validasi dan autentikasi | v1.0.0 Aktif |
| [examples.json](examples.json) | Contoh payload sintetis valid/invalid untuk validasi JSON Schema | v1.0.0 Aktif |

## Panduan Teknis

| Dokumen | Deskripsi | Status |
|---------|-----------|--------|
| [DESIGN.md](DESIGN.md) | Panduan desain UI: arah visual, Material 3, ikon standar, token tema, aksesibilitas, layout dan state | Aktif |
| [VERSIONING.md](VERSIONING.md) | Panduan Semantic Versioning: format MAJOR.MINOR.PATCH, alur Git tag, conventional commits, release notes | Aktif |
| [GITHUB-WORKFLOW.md](GITHUB-WORKFLOW.md) | Panduan lengkap commit, push, branching, PR, review dan merge | Aktif |
| [GITHUB-NOTES.md](GITHUB-NOTES.md) | Nama, deskripsi dan topics yang disarankan untuk repository GitHub | Aktif |

## Pelacakan & Keputusan

| Dokumen | Deskripsi | Status |
|---------|-----------|--------|
| [DECISIONS.md](DECISIONS.md) | Register keputusan proyek (append-only): setiap keputusan produk dan teknis beserta asal mandat, alasan dan dampak | Aktif |
| [TRACEABILITY.md](TRACEABILITY.md) | Requirements Traceability Matrix (RTM): keterlacakan dari BRD → PRD → FRD → SRS → TC, termasuk hasil audit | Aktif |

## Workspace & Handoff

| Dokumen | Deskripsi | Status |
|---------|-----------|--------|
| [WORKSPACE.md](WORKSPACE.md) | Catatan workspace: kondisi terkini, OS/IDE, peta sumber acuan, skill, skenario routing dan hasil audit | Aktif |
| [SESSION-HANDOFF.md](SESSION-HANDOFF.md) | Status handoff antar sesi kerja: mandat terakhir, hasil, acuan berlaku dan kelanjutan | Aktif |
| [SKILL-RESEARCH.md](SKILL-RESEARCH.md) | Riset dan seleksi skill agent: referensi yang dibaca, keputusan adaptasi, skenario evaluasi | Aktif |

## Navigasi Cepat

```text
docs/
├── BRD.md              ← Kebutuhan bisnis
├── PRD.md              ← Kebutuhan produk
├── FRD.md              ← Kebutuhan fungsional (detail)
├── SRS.md              ← Spesifikasi teknis
├── SRS-PLAN.md         ← Rencana SRS (historis)
├── openapi.json        ← Kontrak API (OpenAPI 3.1)
├── examples.json       ← Contoh payload
├── DESIGN.md           ← Panduan desain UI
├── VERSIONING.md       ← Panduan versioning & release
├── DECISIONS.md        ← Register keputusan
├── TRACEABILITY.md     ← Matriks keterlacakan
├── WORKSPACE.md        ← Catatan workspace
├── SESSION-HANDOFF.md  ← Handoff sesi
├── GITHUB-WORKFLOW.md  ← Panduan Git/GitHub
├── GITHUB-NOTES.md     ← Info repository
├── SKILL-RESEARCH.md   ← Riset skill
└── INDEX.md            ← Indeks ini
```

## Dokumen Terkait di Luar `docs/`

| Lokasi | Deskripsi |
|--------|-----------|
| [AGENTS.md](../AGENTS.md) | Instruksi agent AI bersama |
| [SKILL.md](../SKILL.md) | Katalog delapan skill |
| [CHANGELOG.md](../CHANGELOG.md) | Catatan perubahan per versi |
| [LICENSE](../LICENSE) | Lisensi All Rights Reserved |
| [README.md](../README.md) | Titik masuk proyek |
| [rules/](../rules/) | Tujuh aturan kerja |
| [skills/](../skills/) | Delapan prosedur tugas |
| [apps/](../apps/README.md) | Wadah aplikasi tim |
