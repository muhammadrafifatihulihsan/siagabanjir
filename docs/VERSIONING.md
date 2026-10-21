# Versioning dan rilis SiagaBanjir

> **Living document:** perbarui bersama setiap perubahan terkait menurut [aturan dokumentasi](../rules/documentation.md#living-documents).

## Kebijakan versi

Versi repository mengikuti [Semantic Versioning](https://semver.org/lang/id/)
dengan format vMAJOR.MINOR.PATCH. Versi mayor menandai perubahan yang memutus
kompatibilitas, minor menambah kemampuan yang kompatibel, dan patch memperbaiki
kesalahan tanpa mengubah kompatibilitas. Selama versi 0.x, proyek masih dalam
pengembangan awal; perubahan yang memengaruhi pengguna tetap dijelaskan.

Versi spesifikasi berdiri sendiri: BRD/PRD v0.1.0 dan FRD/SRS/kontrak API v1.0.0
adalah baseline approved. Penyuntingan redaksi tidak mengubah keputusan produk
atau menaikkan versi spesifikasi secara otomatis.

## Rilis awal v0.1.0

Rilis awal mencakup dokumentasi, kontrak API, panduan kerja, dan validator
workspace. Backend dan Flutter belum tersedia; tidak ada APK atau layanan yang
dinyatakan siap digunakan. Pengujian aplikasi/provider/perangkat/UAT tetap NOT_RUN.

GitHub Release adalah publikasi pada tag tertentu, dengan catatan perubahan
dan arsip repository. GitHub menyediakan unduhan ZIP/tarball otomatis; aset
aplikasi ditambahkan hanya ketika tersedia dan telah diverifikasi.
Push branch biasa tidak membuat release.
Sumber: [GitHub Releases](https://docs.github.com/en/repositories/releasing-projects-on-github/about-releases).

## Prosedur rilis

1. Perbarui entri versi pada [CHANGELOG](../CHANGELOG.md) dengan tanggal
   publikasi, perubahan, dan batas hasil aktual. Bagian Unreleased menampung
   perubahan untuk rilis berikutnya.
2. Jalankan [pemeriksaan lokal](GITHUB-WORKFLOW.md#otomatisasi-cicd), review diff,
   commit/push ke branch remote anggota, lalu PR ke development dan promosi development → main
   sesuai [panduan GitHub](GITHUB-WORKFLOW.md); merge harus diotorisasi.
3. Tunggu seluruh pekerjaan CI berhasil pada SHA commit yang akan dirilis.
   Pastikan SHA berada pada main terbaru dan tag belum ada di lokal maupun remote.
   Tag/release hanya dibuat oleh Rafi dalam mandat rilis terpisah.
4. Buat tag beranotasi pada SHA yang telah diverifikasi:

   ```bash
   git tag -a v0.1.0 SHA_COMMIT_TERVERIFIKASI -m "SiagaBanjir v0.1.0: baseline dokumentasi dan workspace"
   git push origin refs/tags/v0.1.0
   ```

5. [Workflow release](../.github/workflows/release.yml) membaca entri CHANGELOG
   sesuai tag dan membuat release dengan judul SiagaBanjir v0.1.0. Entri yang
   hilang atau kosong menyebabkan workflow gagal sebelum publikasi.
6. Periksa tag, SHA, workflow, isi catatan, dan
   [halaman Releases](https://github.com/muhammadrafifatihulihsan/siagabanjir/releases).

Ganti versi dan SHA contoh untuk rilis berikutnya. Jangan memindahkan atau
menimpa tag yang sudah dipublikasikan. Jika workflow gagal, perbaiki penyebab
dan nilai apakah diperlukan commit serta versi baru; jangan menyatakan release
berhasil hanya karena tag telah dipush.

Workflow saat ini dipicu tag v*.*.* dengan contents: write; ia memvalidasi
catatan versi, tetapi belum memverifikasi ancestry main maupun hasil CI secara
otomatis. Pemeriksaan langkah 3 masih prosedural. Proteksi tag dan penguatan
workflow rilis adalah usulan terpisah pada [audit](GITHUB-AUDIT.md), belum diterapkan.
