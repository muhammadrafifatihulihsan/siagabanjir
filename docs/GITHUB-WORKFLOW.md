# Kontribusi dan publikasi GitHub

> **Living document:** perbarui bersama setiap perubahan terkait menurut [aturan dokumentasi](../rules/documentation.md#living-documents).

Repository: [muhammadrafifatihulihsan/siagabanjir](https://github.com/muhammadrafifatihulihsan/siagabanjir).
Branch utama adalah main. Repository berisi spesifikasi dan workspace demo
akademik; backend serta Flutter diinisialisasi tim.

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

## Pemeriksaan dan commit

Jalankan seluruh [validasi lokal](../README.md#otomatisasi-cicd), lalu tinjau
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
