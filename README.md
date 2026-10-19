# SiagaBanjir

> **Living document:** perbarui bersama setiap perubahan terkait menurut [aturan dokumentasi](rules/documentation.md#living-documents).

[![CI](https://github.com/muhammadrafifatihulihsan/siagabanjir/actions/workflows/ci.yml/badge.svg)](https://github.com/muhammadrafifatihulihsan/siagabanjir/actions/workflows/ci.yml)

SiagaBanjir adalah proyek akademik untuk pelaporan dan pemantauan banjir dalam
konteks Kota Padang. Rancangan produk mencakup Flutter Android untuk warga,
Flutter Web untuk admin, dan backend bersama.

Repository ini menyediakan spesifikasi, kontrak API, panduan desain, dan
instruksi kerja tim. **Backend dan aplikasi Flutter belum diimplementasikan.**
Tim menginisialisasi keduanya di [apps/](apps/README.md).

## Dokumentasi

| Kebutuhan | Acuan |
|---|---|
| Tujuan dan kebutuhan produk | [BRD](docs/BRD.md) dan [PRD](docs/PRD.md) |
| Perilaku, aturan, dan penerimaan | [FRD](docs/FRD.md) |
| Arsitektur, data, dan antarmuka | [SRS](docs/SRS.md), [OpenAPI](docs/openapi.json), [contoh payload](docs/examples.json) |
| Desain layar dan aksesibilitas | [DESIGN](docs/DESIGN.md) |
| Keputusan dan keterlacakan | [DECISIONS](docs/DECISIONS.md) dan [TRACEABILITY](docs/TRACEABILITY.md) |
| Kontribusi dan publikasi | [Panduan GitHub](docs/GITHUB-WORKFLOW.md) dan [versioning](docs/VERSIONING.md) |
| Konfigurasi dan status pekerjaan | [WORKSPACE](docs/WORKSPACE.md) dan [handoff](docs/SESSION-HANDOFF.md) |

[Indeks dokumentasi](docs/INDEX.md) memuat seluruh sumber aktif.
Agent mengikuti [AGENTS](AGENTS.md), menuntaskan
[bacaan lengkap](rules/workflow.md#baca-lengkap), lalu menjalankan prosedur dari
[katalog delapan skill](SKILL.md) sesuai tugas. Setiap perubahan menyelaraskan
[dokumen yang terdampak](rules/documentation.md#living-documents).

## Status dan versi

| Komponen | Baseline |
|---|---|
| BRD / PRD | v0.1.0 APPROVED |
| FRD / SRS / kontrak API | v1.0.0 APPROVED |
| Workspace | v0.1.0 |
| Backend / Flutter | Belum tersedia; folder aplikasi berisi penanda kosong |
| Pengujian aplikasi, provider, perangkat, dan UAT | NOT_RUN |

Persetujuan spesifikasi berbeda dari penerimaan implementasi.
Baseline v0.1.0 berisi dokumentasi dan workspace; tidak menyediakan APK
atau aplikasi siap pakai. Catatan versi ada di [CHANGELOG](CHANGELOG.md).
[GitHub Releases](https://github.com/muhammadrafifatihulihsan/siagabanjir/releases)
menyediakan catatan rilis dan arsip repository pada tag terkait.

<a id="otomatisasi-cicd"></a>

## Validasi lokal dan CI

[CI](.github/workflows/ci.yml) memeriksa dokumentasi, format, dan kontrak pada
push serta pull request ke main. Pemeriksaan memakai Python 3.10+ (CI: 3.12),
Node 24, dan EditorConfig Checker 4.0.2.

Pasang dependensi Python dalam environment terisolasi. Perintah berikut
dijalankan dari root repository; dependensinya hanya untuk pemeriksaan workspace.

```bash
python -m pip install -r .github/requirements-validation.txt
python -B -X utf8 .github/scripts/validate_links.py
python -B -X utf8 .github/scripts/validate_skills.py
python -B -X utf8 .github/scripts/validate_contracts.py
python -B -X utf8 -m unittest discover -s .github/scripts -p 'test_*.py'
npx -y markdownlint-cli2@0.17.2 --config .markdownlint.json '**/*.md' '#**/codex-session-*.md' '#archive/**'
npx -y @redocly/cli@2.64.1 lint docs/openapi.json --config .redocly.yaml
editorconfig-checker
git diff --check
```

Lint Markdown dan validator tautan mengecualikan ekspor lokal
`codex-session-*.md` serta arsip privat. [Handoff aktif](docs/SESSION-HANDOFF.md)
tetap diperiksa seperti dokumentasi lainnya.

EditorConfig Checker tersedia dari [rilis resmi v4.0.2](https://github.com/editorconfig-checker/editorconfig-checker/releases/tag/v4.0.2).
Pemeriksaan default mencakup berkas tracked; periksa berkas baru setelah staging
atau berikan path-nya secara eksplisit. Redocly menggunakan
[konfigurasi proyek](.redocly.yaml) untuk menemukan kesalahan kontrak dan komponen
yang tidak dirujuk. Validasi skema tidak menggantikan tes perilaku aplikasi.

## Struktur workspace

| Lokasi | Isi |
|---|---|
| apps/server dan apps/app | Lokasi backend dan Flutter yang disiapkan tim |
| docs | Spesifikasi, desain, keputusan, kontrak, dan panduan kerja |
| rules | Aturan bersama untuk alur kerja, mutu, dan dokumentasi |
| skills | Delapan prosedur tugas yang dirujuk AGENTS |
| .github | CI, rilis, validator, dan template pull request |
| CLAUDE.md dan .aiassistant/rules | Adapter instruksi IDE |
| .vscode/extensions.json | Rekomendasi ekstensi opsional |

Konfigurasi EditorConfig dan Git attributes menjaga format lintas OS.
Dukungan IDE dan batas pengujiannya tercatat pada
[matriks workspace](docs/WORKSPACE.md#ide).

## Lisensi

**All Rights Reserved.** Ketentuan penggunaan tercantum dalam [LICENSE](LICENSE).
