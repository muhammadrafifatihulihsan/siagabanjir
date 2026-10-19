# Versioning SiagaBanjir

> **Living document:** perbarui bersama setiap perubahan terkait menurut [aturan dokumentasi](../rules/documentation.md#living-documents).

Proyek mengikuti [Semantic Versioning 2.0.0](https://semver.org/lang/id/).
Panduan ini menjelaskan apa itu versioning, bagaimana formatnya, dan bagaimana
tim menerapkannya di Git/GitHub.

## Apa itu Semantic Versioning (SemVer)

Semantic Versioning adalah standar industri penomoran versi perangkat lunak
yang memberikan **makna** pada setiap angka. Format:

```text
MAJOR.MINOR.PATCH
```

Contoh: `1.2.3` berarti **Major 1**, **Minor 2**, **Patch 3**.

### Arti setiap komponen

| Komponen | Kapan dinaikkan | Contoh |
|----------|----------------|--------|
| **MAJOR** (X.0.0) | Perubahan **tidak kompatibel mundur** (breaking change): API berubah, skema data migrasi, fitur dihapus | `1.0.0` → `2.0.0` |
| **MINOR** (0.X.0) | Penambahan fitur **kompatibel mundur**: endpoint baru, kemampuan baru yang tidak merusak | `1.0.0` → `1.1.0` |
| **PATCH** (0.0.X) | Perbaikan bug **kompatibel mundur**: fix error, perbaikan typo, optimasi kecil | `1.1.0` → `1.1.1` |

### Pre-release dan Build Metadata

| Format | Contoh | Keterangan |
|--------|--------|------------|
| Pre-release alpha | `1.0.0-alpha.1` | Versi awal pengembangan, belum stabil |
| Pre-release beta | `1.0.0-beta.1` | Fitur lengkap tapi masih diuji |
| Release Candidate | `1.0.0-rc.1` | Kandidat rilis, siap uji akhir |
| Build metadata | `1.0.0+build.123` | Info build, tidak mempengaruhi urutan versi |

### Aturan penomoran

1. Versi `0.x.y` menandakan API belum stabil (fase pengembangan awal)
2. Versi `1.0.0` menandakan API publik pertama yang stabil
3. Setiap kenaikan MAJOR mereset MINOR dan PATCH ke 0
4. Setiap kenaikan MINOR mereset PATCH ke 0
5. Urutan prioritas: `1.0.0-alpha` < `1.0.0-beta` < `1.0.0-rc.1` < `1.0.0`

## Alur Versioning di Git

### Membuat tag versi

```bash
# Setelah perubahan di-merge ke main
git switch main
git pull --ff-only origin main

# Sebelum tag: pastikan CHANGELOG untuk versi ini sudah masuk commit dan CI lulus.
# Buat annotated tag
git tag -a v0.2.0 -m "feat: tambah fitur pantau realtime"

# Push tag ke GitHub
git push origin v0.2.0
```

### Apa yang terjadi setelah tag di-push

1. GitHub Actions workflow `release.yml` otomatis membuat **GitHub Release**
2. Release notes di-generate otomatis dari commit sejak tag sebelumnya
3. Release menunjuk [CHANGELOG.md](../CHANGELOG.md) pada tag tersebut;
   detail perubahan wajib sudah masuk commit sebelum tag dibuat

### Konvensi pesan commit

Gunakan format [Conventional Commits](https://www.conventionalcommits.org/):

```text
<type>(<scope>): <deskripsi singkat>
```

| Type | Kapan dipakai | Contoh |
|------|-------------|--------|
| `feat` | Fitur baru | `feat(laporan): tambah upload foto bukti` |
| `fix` | Perbaikan bug | `fix(auth): token refresh gagal di Android` |
| `docs` | Perubahan dokumentasi | `docs: perbarui panduan versioning` |
| `refactor` | Refaktor tanpa ubah perilaku | `refactor(api): pisahkan handler review` |
| `test` | Tambah/ubah test | `test(kuota): tambah kasus batas waktu` |
| `ci` | Perubahan CI/CD | `ci: tambah validasi OpenAPI di workflow` |
| `chore` | Maintenance umum | `chore: update dependencies` |
| `style` | Format tanpa ubah logika | `style: konsistensi indentasi` |

Jika commit mengandung **breaking change**, tambahkan `!` setelah type:

```text
feat(api)!: ubah format response laporan
```

## Apa yang Didata dalam Setiap Release

Setiap rilis di [CHANGELOG.md](../CHANGELOG.md) mencatat:

1. **Nomor versi** — tag Git (contoh: `v0.2.0`)
2. **Tanggal rilis** — format YYYY-MM-DD
3. **Perubahan** dikategorikan:
   - **Added** — fitur baru yang ditambahkan
   - **Changed** — perubahan pada fitur yang sudah ada
   - **Deprecated** — fitur yang akan dihapus di versi mendatang
   - **Removed** — fitur yang dihapus
   - **Fixed** — perbaikan bug
   - **Security** — perbaikan kerentanan keamanan
4. **Breaking changes** — jika ada perubahan yang tidak kompatibel mundur
5. **Link ke PR/issue** terkait

Format ini mengikuti standar [Keep a Changelog](https://keepachangelog.com/id/1.1.0/).

## Status Versi Proyek Saat Ini

| Komponen | Versi | Status |
|----------|-------|--------|
| BRD/PRD | v0.1.0 | APPROVED |
| FRD | v1.0.0 | APPROVED |
| SRS | v1.0.0 | APPROVED |
| OpenAPI kontrak | v1.0.0 | Aktif |
| Workspace/panduan | v0.1.0 | Setup |
| Backend (apps/server) | — | Belum diinisialisasi |
| Flutter App (apps/app) | — | Belum diinisialisasi |

Versi workspace dimulai dari `v0.1.0` karena spesifikasi sudah approved tetapi
aplikasi belum diinisialisasi. Versi dokumen/kontrak menyatakan baseline
spesifikasi, bukan API produksi yang sudah dirilis. Audit setup dicatat pada
Unreleased dan tidak otomatis membuat tag/release atau menaikkan versi approved.

## Referensi

- [Semantic Versioning 2.0.0](https://semver.org/lang/id/)
- [Keep a Changelog](https://keepachangelog.com/id/1.1.0/)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [GitHub — Managing Releases](https://docs.github.com/en/repositories/releasing-projects-on-github/managing-releases-in-a-repository)
