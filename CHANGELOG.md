# Changelog

> **Living document:** perbarui bersama setiap perubahan terkait menurut [aturan dokumentasi](rules/documentation.md#living-documents).

Semua perubahan signifikan pada proyek SiagaBanjir didokumentasikan di sini.
Format mengikuti [Keep a Changelog](https://keepachangelog.com/id/1.1.0/),
dan proyek mematuhi [Semantic Versioning](https://semver.org/lang/id/).

## [Unreleased]

### Fixed

- Akar validator dipulihkan ke root repository; kegagalan cakupan tidak menjadi PASS
- YAML skill diparse sungguhan dengan validasi nilai dan penolakan key ganda
- Pemeriksaan EditorConfig benar-benar dijalankan; format Markdown, Python dan LF diselaraskan
- Kontrak signup tidak lagi menawarkan replay recovery code; konflik rahasia mengikuti SRS-IF-004
- Respons error, lisensi API dan schema perubahan kredensial diselaraskan tanpa menambah endpoint
- Panduan CI, arsip, GitHub, status baseline dan tautan changelog release diperbarui

### Added

- CI/CD GitHub Actions: lint Markdown, validasi link, validasi YAML skill, cek OpenAPI dan EditorConfig
- Release workflow otomatis via GitHub Actions saat tag `vX.X.X` di-push
- Panduan Semantic Versioning di [docs/VERSIONING.md](docs/VERSIONING.md)
- Indeks dokumentasi [docs/INDEX.md](docs/INDEX.md)
- Script validasi di `.github/scripts/`: validate_links.py dan validate_skills.py
- Konfigurasi Markdown linter (`.markdownlint.json`)
- Lisensi All Rights Reserved (LICENSE)
- File CHANGELOG.md ini
- Validator kontrak/contoh, 20 tes regresi validator, dan 13 contoh tambahan (total 54)
- Versi alat validasi dikunci; peringatan kontrak yang diaudit menjadi error CI
- Pemeriksaan format JSON Schema lengkap dan gate untuk dependensi format yang hilang

### Changed

- Kontrak API (`openapi.json`, `examples.json`) dipindahkan dari `contracts/` ke `docs/`
- README diperbarui: badge CI, section versioning, otomatisasi dan lisensi
- Rules workflow dan quality ditambah panduan CI/versioning
- Panduan GitHub ditambah alur tagging dan release
- Seluruh referensi `contracts/` dan `archive/` diperbarui

### Removed

- Folder `contracts/` (isi dipindahkan ke `docs/`)
- Folder `archive/` beserta seluruh isi
- Folder `tools/` (script validasi dipindah ke `.github/scripts/`)
- File session Codex dari root

## [0.1.0] - 2026-10-19

Baseline penyusunan workspace; entri ini bukan bukti tag atau GitHub Release
telah dibuat. Audit/push saat ini tidak menerbitkan tag/release.

### Added

- BRD v0.1.0 dan PRD v0.1.0 (APPROVED)
- FRD v1.0.0 (APPROVED): 68 FR, 136 AC, 156 TC
- SRS v1.0.0 (APPROVED): arsitektur, model data, kontrak API
- OpenAPI v1.0.0: 72 operasi, 166 schema, 41 contoh payload
- Delapan skill agent SiagaBanjir
- Tujuh rules panduan kerja
- Desain UI: Material 3, ikon standar, token, aksesibilitas
- Panduan GitHub: commit, push, PR workflow
- Template pull request
- Konfigurasi EditorConfig dan gitattributes lintas OS
- Adapter IDE: VS Code, Claude Code, JetBrains, Cursor
- Wadah aplikasi `apps/server/` dan `apps/app/` (belum diinisialisasi)
