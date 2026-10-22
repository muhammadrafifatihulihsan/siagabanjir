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
  [apps/](apps/README.md): `server/` dan `siagabanjir/`.
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

Alur kontribusi mengikuti [panduan GitHub](docs/GITHUB-WORKFLOW.md): branch-rafi,
branch-melia, branch-hasan → development → main melalui PR dalam repo yang sama.
Nama tersebut merujuk branch remote. Anggota boleh memakai `main` lokal yang
melacak branch remote sendiri, dengan push eksplisit sesuai
[skrip ringkas](docs/GIT-CEPAT.md). Branch permanen tidak dihapus; mandat push tidak mengizinkan merge atau Settings.

## Otomatisasi dan versioning

- [CI](.github/workflows/ci.yml) memvalidasi Markdown, link, skill YAML,
  format, OpenAPI/contoh serta regresi validator pada push kelima branch permanen serta PR ke main/development; arah PR juga diperiksa. Script validasi tersedia
  di `.github/scripts/` untuk pemeriksaan lokal.
- Versioning mengikuti [Semantic Versioning](docs/VERSIONING.md).
  Perubahan dicatat di [CHANGELOG](CHANGELOG.md). Tag `vX.X.X`
  otomatis membuat [GitHub Release](.github/workflows/release.yml).

## Commit lokal wajib tanpa menunggu konfirmasi

Mandat tetap pemilik: **AI wajib membuat commit lokal untuk setiap unit perubahan
yang selesai, sekecil apa pun, termasuk typo dan dokumentasi**, tanpa menunggu
pengguna meminta atau menyetujui commit lagi. Tinjau diff, jalankan pemeriksaan
sesuai dampak, lalu commit perubahan tugas beserta dokumentasi terkait.
Satu commit memuat satu maksud yang utuh; tidak perlu commit tiap penekanan tombol
atau membuat commit kosong untuk tugas baca saja.

Sebelum berpindah ke unit pekerjaan berikut, menyerahkan hasil, atau menutup
tugas/sesi, jalankan `git status --porcelain=v1 --untracked-files=all` dan
pastikan perintah berhasil tanpa keluaran. Jika belum bersih, selesaikan
perubahan tugas terlebih dahulu. Jangan memakai reset, clean, stash, ignore
tambahan, atau memasukkan perubahan orang lain hanya untuk membuat status bersih.
Jika keselamatan data atau izin menghalangi, laporkan **BLOCKED**, path dan
penyebabnya; jangan mengklaim selesai/clean.

Push tetap mengikuti mandat pengguna; commit lokal tidak mengotorisasi push,
merge PR, tag, release, atau deploy. Detail checkpoint pekerjaan belum selesai,
perubahan awal, dan bukti penutupan ada pada
[aturan commit](rules/workflow.md#commit-lokal) dan
[panduan tim pemula](docs/GITHUB-WORKFLOW.md#mulai-untuk-tim).

## Syarat pekerjaan selesai

AI wajib memperbarui living documents secara proaktif tanpa menunggu pengingat,
mengikuti [aturan pembaruan](rules/documentation.md#living-documents).
Periksa dampak ke README, spesifikasi/kontrak, DESIGN, AGENTS, rules, skills,
adapter IDE, keputusan/RTM dan handoff. Perbarui semua yang terdampak dalam
perubahan yang sama. Yang tidak terdampak cukup dijelaskan singkat; jangan
membuat perubahan kosmetik atau salinan baru hanya untuk terlihat lengkap.
Tautan/path, petunjuk kerja dan status bukti harus sesuai hasil aktual.
Keterbatasan atau konflik yang belum selesai harus disebut, bukan disembunyikan.
Syarat selesai juga mencakup commit lokal, working tree bersih, serta pelaporan
branch, SHA commit, hasil pemeriksaan, dan status push sesuai aturan di atas.

## Code Review Rules

Utamakan bug terbukti: kebocoran akses, konflik versi, kirim ganda, kuota,
penghapusan/AI terlambat, dan state lintas akun. Review UI juga memeriksa
konsistensi ikon, hierarki tindakan, aksesibilitas dan state nyata.
Dokumentasi/instruksi yang bertentangan dengan perubahan adalah temuan review.
Kaitkan temuan ke file/baris serta requirement. Bedakan inspeksi, tes aplikasi,
provider dan perangkat; NOT_RUN tidak menjadi PASS tanpa eksekusi.
