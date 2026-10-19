# SiagaBanjir

> **Living document:** perbarui bersama setiap perubahan terkait menurut [aturan dokumentasi](rules/documentation.md#living-documents).

[![CI](https://github.com/muhammadrafifatihulihsan/siagabanjir/actions/workflows/ci.yml/badge.svg)](https://github.com/muhammadrafifatihulihsan/siagabanjir/actions/workflows/ci.yml)

Workspace panduan kerja dan spesifikasi demo kuliah: Flutter Android warga,
Flutter Web admin, dan backend bersama. Tim menyiapkan aplikasi sendiri di
[apps/](apps/README.md).

## Mulai di sini

1. Buka [AGENTS](AGENTS.md). AI wajib membaca **seluruh sumber aktif** sesuai
   [protokol baca lengkap](rules/workflow.md#baca-lengkap), termasuk semua
   rules, delapan skills, docs dan kontrak; bukan hanya ringkasan handoff.
2. Setelah bacaan lengkap, pilih prosedur pada [katalog delapan skill](SKILL.md).
3. Gunakan [FRD](docs/FRD.md), [SRS](docs/SRS.md), dan
   [OpenAPI](docs/openapi.json) untuk perilaku produk.
4. Ikuti [DESIGN](docs/DESIGN.md) untuk UI, ikon dan aksesibilitas.
5. Setiap perubahan mengikuti [sinkronisasi dokumentasi](rules/documentation.md).
6. Navigasi semua dokumen melalui [indeks docs](docs/INDEX.md).

[Riset dan seleksi skill](docs/SKILL-RESEARCH.md) mencatat referensi lokal,
sumber resmi, alasan adaptasi serta skenario pemeriksaan. Skill baru mencakup
debugging dan verifikasi. [Perbandingan Software-BK](docs/SKILL-RESEARCH.md#softwarebk)
menjelaskan tambahan yang diterapkan, yang sudah tercakup dan yang tidak cocok.
Gunakan [peta sumber acuan](docs/WORKSPACE.md#sumber-acuan) untuk menemukan
arsitektur, data, API dan bukti tanpa membuat salinan spesifikasi.

## Versioning

Proyek mengikuti [Semantic Versioning 2.0.0](https://semver.org/lang/id/).
Panduan lengkap ada di [docs/VERSIONING.md](docs/VERSIONING.md).

| Komponen | Versi |
|----------|-------|
| BRD/PRD | v0.1.0 APPROVED |
| FRD/SRS | v1.0.0 APPROVED |
| Workspace | v0.1.0 |

Perubahan dicatat di [CHANGELOG.md](CHANGELOG.md). Setiap tag `vX.X.X`
yang di-push ke GitHub otomatis membuat Release melalui GitHub Actions.

## Otomatisasi (CI/CD)

GitHub Actions menjalankan pemeriksaan otomatis pada push dan PR ke `main`:

| Workflow | Apa yang diperiksa |
|----------|-------------------|
| [CI](.github/workflows/ci.yml) | Lint Markdown, link/case, YAML skill, EditorConfig, OpenAPI, contoh payload dan regresi validator |
| [Release](.github/workflows/release.yml) | Otomatis membuat GitHub Release saat tag `vX.X.X` di-push |

Pemeriksaan workspace memakai Python 3.10+ (CI: 3.12), Node 24 dan
EditorConfig Checker 4.0.2. Dependensi pemeriksaan tidak menginisialisasi apps.
Pasang dependensi Python dalam environment terisolasi yang sudah dipilih tim;
`npx` menyimpan alat sementara di cache pengguna, bukan dependency aplikasi.

```bash
python -m pip install -r .github/requirements-validation.txt
python -B -X utf8 .github/scripts/validate_links.py    # Cek link internal
python -B -X utf8 .github/scripts/validate_skills.py   # Cek YAML skill
python -B -X utf8 .github/scripts/validate_contracts.py
python -B -X utf8 -m unittest discover -s .github/scripts -p 'test_*.py'
npx -y markdownlint-cli2@0.17.2 --config .markdownlint.json '**/*.md'
npx -y @redocly/cli@2.64.1 lint docs/openapi.json --config .redocly.yaml
editorconfig-checker
```

EditorConfig Checker memeriksa file tracked secara default. Sebelum commit
pertama, berikan seluruh path kandidat dari `git ls-files --cached --others
--exclude-standard` sebagai argumen, atau periksa setelah staging. Jangan
menyebut pemeriksaan kosong sebagai PASS. CI memakai checkout yang sudah tracked.
Unduh binary sesuai OS dari [rilis resmi v4.0.2](https://github.com/editorconfig-checker/editorconfig-checker/releases/tag/v4.0.2).
Konfigurasi Redocly mengangkat peringatan kontrak yang diaudit menjadi error;
schema internal SRS yang belum dipakai endpoint tetap diperbolehkan.

## GitHub

Gunakan [panduan commit, push dan PR](docs/GITHUB-WORKFLOW.md) serta
[notes nama/deskripsi repository](docs/GITHUB-NOTES.md).
Kontrak API ada di `docs/openapi.json` dan ikut Git; percakapan mentah tidak.
Pembaruan living documents dilakukan AI dalam pekerjaan yang sama, tanpa
menunggu pengingat; CI memeriksa aturan otomatis, sedangkan konsistensi makna
dan bukti approval tetap diperiksa melalui review.
Tagging dan release mengikuti [panduan versioning](docs/VERSIONING.md).

## Lisensi

**All Rights Reserved.** Lihat [LICENSE](LICENSE) untuk detail.
Dilarang menyalin, mendistribusikan, atau memodifikasi proyek ini tanpa izin
tertulis dari pemilik.

## Struktur

```text
AGENTS.md              sumber instruksi bersama
SKILL.md               katalog delapan skill
CHANGELOG.md           catatan perubahan per versi
LICENSE                 lisensi All Rights Reserved
CLAUDE.md              impor AGENTS untuk Claude Code
.aiassistant/rules/    pengarah ke AGENTS untuk JetBrains AI Assistant
.vscode/extensions.json rekomendasi opsional EditorConfig dan Flutter
.github/
  workflows/ci.yml     CI otomatis: lint, validasi, format
  workflows/release.yml release otomatis dari tag
  scripts/             script validasi untuk CI
  requirements-validation.txt dependensi validator Python
  pull_request_template.md
.markdownlint.json     konfigurasi Markdown linter
.redocly.yaml          aturan pemeriksaan OpenAPI
rules/                 alur, domain, mutu, UI, portabilitas, dokumentasi, riset
skills/                delapan prosedur tugas SiagaBanjir
apps/
  server/              tempat backend tim
  app/                 tempat Flutter tim
docs/                  spesifikasi, desain, keputusan, bukti, handoff, versioning
  INDEX.md             indeks navigasi semua dokumen
  openapi.json         kontrak API (OpenAPI 3.1)
  examples.json        contoh payload SRS
```

AGENTS dibagi bersama untuk Codex, Copilot/VS Code dan Cursor yang mendukungnya.
Adapter IDE tetap ringkas; tidak ada duplikasi kumpulan skill. EditorConfig
dan Git attributes mengatur format berkas lintas OS. Lihat
[matriks dukungan dan pemeriksaan](docs/WORKSPACE.md#ide).

BRD/PRD v0.1.0 dan FRD/SRS v1.0.0 approved adalah status spesifikasi.
Aplikasi/provider/perangkat tetap NOT_RUN. Folder server/app hanya penanda
kosong; belum ada perintah build atau instalasi aplikasi. Hasil pemeriksaan
workspace terbaru ada pada [audit final](docs/WORKSPACE.md#audit-final).
