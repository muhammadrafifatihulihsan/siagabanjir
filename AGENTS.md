# Instruksi agent SiagaBanjir

> **Living document:** perbarui bersama setiap perubahan terkait menurut [aturan dokumentasi](rules/documentation.md#living-documents).

Workspace spesifikasi dan panduan kerja demo kuliah SiagaBanjir.
Komunikasikan hasil dalam bahasa Indonesia secara konkret dan ringkas.

## Wajib membaca keseluruhan sebelum bekerja

Sebelum merencanakan solusi, mengedit atau mereview, AI **wajib membaca penuh
seluruh dokumentasi dan instruksi aktif tanpa pengecualian karena ukuran tugas**.
Ikuti [protokol baca lengkap](rules/workflow.md#baca-lengkap): README, handoff,
semua rules, katalog dan **seluruh delapan SKILL.md**, seluruh docs, kontrak,
README aplikasi, adapter dan konfigurasi bersama. File aktif baru ikut tercakup.
Jangan menganggap ringkasan, pencarian kata, metadata skill atau daftar file
sebagai bukti membaca isi lengkap. Jika output terpotong, lanjutkan bagian
yang belum terbaca; jangan mengklaim siap selama cakupan belum lengkap.

Setelah bacaan lengkap, gunakan [peta sumber acuan](docs/WORKSPACE.md#sumber-acuan)
untuk menyelesaikan konflik. Tabel berikut memilih prosedur **yang dijalankan**,
bukan membatasi dokumen yang dibaca.

| Pekerjaan | Skill |
|---|---|
| Folder, instruksi agent dan dukungan OS/IDE | [workspace](skills/siagabanjir-workspace/SKILL.md) |
| Requirement, keputusan dan keterlacakan | [requirements](skills/siagabanjir-requirements/SKILL.md) |
| Endpoint, data, worker dan adapter AI | [backend](skills/siagabanjir-backend/SKILL.md) |
| Implementasi Flutter warga/admin dan state | [flutter](skills/siagabanjir-flutter/SKILL.md) |
| Desain layar, ikon, aksesibilitas dan evaluasi visual | [ui](skills/siagabanjir-ui/SKILL.md) |
| Review perubahan dengan temuan dan bukti | [review](skills/siagabanjir-review/SKILL.md) |
| Reproduksi bug dan penelusuran penyebab | [debug](skills/siagabanjir-debug/SKILL.md) |
| Rencana tes, regresi dan bukti penerimaan | [verification](skills/siagabanjir-verification/SKILL.md) |

Seluruh skill wajib dibaca. Jalankan prosedur sesuai keluaran: diagnosis memakai
debug, implementasi memakai backend/Flutter, dan pemeriksaan mengikuti dampak.
Membaca semua skill tidak mewajibkan semua workflow/tes dijalankan untuk setiap tugas.

[SKILL](SKILL.md) adalah katalog. `skills/` dibaca melalui routing di sini;
bukan klaim penemuan otomatis Codex. Gunakan lokasi dan izin yang tersedia
pada lingkungan aktual. Adapter IDE hanya menunjuk
ke sumber bersama, tidak menyalin seluruh aturan. [Matriks IDE](docs/WORKSPACE.md#ide)
membedakan dukungan dokumentasi dari pemuatan yang benar-benar diuji.

## Batas mandat

- **Tim menginisialisasi backend dan Flutter sendiri** di
  [apps/](apps/README.md): `server/` dan `app/`.
- Setup panduan tidak membuat package, source, migrasi, seed, lockfile atau
  memasang SDK/dependensi. Gunakan proyek aktual tim setelah tersedia.
  Dependensi validator workspace yang dimandatkan terpisah dari aplikasi;
  gunakan versi pada `.github/requirements-validation.txt` dan CI, tanpa
  instalasi global atau inisialisasi apps.
- BRD/PRD v0.1.0 dan FRD/SRS v1.0.0 adalah baseline approved.
  Terapkan mandat pengguna terbaru; catat perubahan keputusan tanpa menulis
  ulang riwayat atau mengarang persetujuan/pengujian.
- Windows, macOS dan Linux adalah sasaran portabilitas workspace. Platform
  produk tetap Android warga dan Web admin sesuai SRS.
- Jangan mengubah izin/global config, Git identity atau remote, maupun
  push/deploy tanpa mandat yang mencakup tindakan tersebut.

## Otomatisasi dan versioning

- [CI](.github/workflows/ci.yml) memvalidasi Markdown, link, skill YAML,
  format, OpenAPI/contoh serta regresi validator pada push/PR ke main. Script validasi tersedia
  di `.github/scripts/` untuk pemeriksaan lokal.
- Versioning mengikuti [Semantic Versioning](docs/VERSIONING.md).
  Perubahan dicatat di [CHANGELOG](CHANGELOG.md). Tag `vX.X.X`
  otomatis membuat [GitHub Release](.github/workflows/release.yml).

## Syarat pekerjaan selesai

AI wajib memperbarui living documents secara proaktif tanpa menunggu pengingat,
mengikuti [aturan pembaruan](rules/documentation.md#living-documents).
Periksa dampak ke README, spesifikasi/kontrak, DESIGN, AGENTS, rules, skills,
adapter IDE, keputusan/RTM dan handoff. Perbarui semua yang terdampak dalam
perubahan yang sama. Yang tidak terdampak cukup dijelaskan singkat; jangan
membuat perubahan kosmetik atau salinan baru hanya untuk terlihat lengkap.
Tautan/path, petunjuk kerja dan status bukti harus sesuai hasil aktual.
Keterbatasan atau konflik yang belum selesai harus disebut, bukan disembunyikan.

## Code Review Rules

Utamakan bug terbukti: kebocoran akses, konflik versi, kirim ganda, kuota,
penghapusan/AI terlambat, dan state lintas akun. Review UI juga memeriksa
konsistensi ikon, hierarki tindakan, aksesibilitas dan state nyata.
Dokumentasi/instruksi yang bertentangan dengan perubahan adalah temuan review.
Kaitkan temuan ke file/baris serta requirement. Bedakan inspeksi, tes aplikasi,
provider dan perangkat; NOT_RUN tidak menjadi PASS tanpa eksekusi.
