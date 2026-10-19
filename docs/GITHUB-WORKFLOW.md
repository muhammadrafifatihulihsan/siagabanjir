# Panduan pengembangan dan publikasi GitHub

> **Living document:** perbarui bersama setiap perubahan terkait menurut [aturan dokumentasi](../rules/documentation.md#living-documents).

[![CI](https://github.com/muhammadrafifatihulihsan/siagabanjir/actions/workflows/ci.yml/badge.svg)](https://github.com/muhammadrafifatihulihsan/siagabanjir/actions/workflows/ci.yml)

Repository: [muhammadrafifatihulihsan/siagabanjir](https://github.com/muhammadrafifatihulihsan/siagabanjir).
Branch utama adalah main. Repository berisi spesifikasi dan workspace demo
akademik; backend serta Flutter diinisialisasi tim.

Status versi, struktur, dan dukungan OS/IDE ada di [WORKSPACE](WORKSPACE.md).
[Indeks dokumentasi](INDEX.md) memetakan spesifikasi dan panduan aktif;
[README aplikasi](../apps/README.md) menetapkan tanggung jawab inisialisasi tim.
Agent mengikuti [AGENTS](../AGENTS.md), menuntaskan
[bacaan lengkap](../rules/workflow.md#baca-lengkap), lalu memakai prosedur dari
[katalog delapan skill](../SKILL.md) sesuai tugas. Setiap perubahan menyelaraskan
[dokumen yang terdampak](../rules/documentation.md#living-documents).

## Sebelum mengubah berkas

1. Buka root repository dan ikuti [alur kerja](../rules/workflow.md).
2. Periksa branch, perubahan lokal, dan remote tujuan:

   ```bash
   git status --short --branch
   git remote -v
   git diff --stat
   ```

3. Pertahankan perubahan milik rekan kerja. Sinkronisasi dari remote hanya
   dilakukan setelah kondisi lokal dipahami; jangan memakai force push untuk
   menyelesaikan perbedaan riwayat.
4. Gunakan branch tugas untuk kontribusi biasa:

   ```bash
   git switch -c docs/nama-perubahan
   ```

Publikasi langsung ke main dapat dilakukan bila mandat pemilik mencakupnya.
Jangan mengubah identitas Git, konfigurasi global, atau remote yang sudah benar.

<a id="otomatisasi-cicd"></a>

## Validasi lokal dan CI

[CI](../.github/workflows/ci.yml) memeriksa dokumentasi, format, dan kontrak pada
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
`codex-session-*.md` serta arsip privat. [Handoff aktif](SESSION-HANDOFF.md)
tetap diperiksa seperti dokumentasi lainnya.

EditorConfig Checker tersedia dari [rilis resmi v4.0.2](https://github.com/editorconfig-checker/editorconfig-checker/releases/tag/v4.0.2).
Pemeriksaan default mencakup berkas tracked; periksa berkas baru setelah staging
atau berikan path-nya secara eksplisit. Redocly menggunakan
[konfigurasi proyek](../.redocly.yaml) untuk menemukan kesalahan kontrak dan komponen
yang tidak dirujuk. Validasi skema tidak menggantikan tes perilaku aplikasi.

## Pemeriksaan dan commit

Jalankan seluruh [validasi lokal](#otomatisasi-cicd), lalu tinjau
diff dan dampak dokumentasi. Kontrak dalam docs ikut Git; rahasia, data pribadi,
dependensi, artefak build, dan arsip percakapan lokal mengikuti .gitignore.

Stage hanya path yang sudah diperiksa, kemudian tinjau hasil staging:

```bash
git add -- path/yang-sudah-ditinjau
git diff --cached --stat
git diff --cached
git diff --cached --check
git commit -m "docs: jelaskan perubahan yang dilakukan"
```

Ganti contoh path dan pesan dengan perubahan aktual. Pesan commit menjelaskan
hasil konkret; perubahan yang saling bergantung disertakan dalam commit yang sama.
Berkas baru juga harus tercakup pemeriksaan format.

## Push dan pull request

```bash
git push -u origin HEAD
```

Buat pull request menuju main melalui GitHub dan gunakan
[template PR](../.github/pull_request_template.md). Jelaskan masalah, perubahan,
hasil pemeriksaan, dan keterbatasan yang relevan. Tinjau seluruh pekerjaan
[CI](https://github.com/muhammadrafifatihulihsan/siagabanjir/actions/workflows/ci.yml)
pada commit terbaru. Perubahan setelah pemeriksaan memerlukan CI pada commit baru.

Untuk publikasi main yang telah diotorisasi:

```bash
git push origin main
git rev-parse HEAD
git ls-remote origin refs/heads/main
```

SHA lokal harus sama dengan SHA remote. Keberhasilan push berbeda dari
keberhasilan CI; verifikasi keduanya. Rilis mengikuti
[prosedur versioning](VERSIONING.md) setelah CI berhasil.

## Git Bash dan lintas OS

Di Windows, jalankan perintah Git di Git Bash yang terpasang. Gunakan path
repository yang nyata dan kutip path yang mengandung spasi. Pada macOS/Linux,
perintah Git yang sama dapat dijalankan melalui shell setempat.

Jika Git menolak ownership pada lingkungan sandbox, periksa bahwa path tersebut
benar-benar repository yang dimaksud. Pengecualian dapat dibatasi pada satu
perintah, tanpa mengubah konfigurasi global:

```bash
git -c safe.directory="$(pwd -W)" status --short --branch
```

Contoh pwd -W khusus Git Bash Windows. Terapkan pengecualian yang sama pada
perintah terkait hanya bila diperlukan. Jika sandbox menolak operasi Git atau
jaringan, gunakan mekanisme izin alat; jangan mengubah permission workspace.

## Kriteria publikasi selesai

- Diff, kandidat commit, dan living documents telah ditinjau.
- Pemeriksaan lokal dan seluruh pekerjaan CI berhasil pada commit yang dipush.
- SHA branch lokal dan remote sesuai.
- Untuk rilis, tag menunjuk commit yang telah lolos CI dan halaman Release
  memuat catatan versi yang benar.
- Hasil aplikasi, perangkat, provider, atau UAT hanya dilaporkan jika dijalankan.
