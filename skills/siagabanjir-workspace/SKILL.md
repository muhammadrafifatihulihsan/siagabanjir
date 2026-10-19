---
name: siagabanjir-workspace
description: Menata folder, AGENTS, rules, skills dan adapter IDE SiagaBanjir. Gunakan untuk perubahan panduan workspace; bukan inisialisasi aplikasi.
---

# Merawat workspace SiagaBanjir

> **Living document:** perbarui bersama setiap perubahan terkait menurut [aturan dokumentasi](../../rules/documentation.md#living-documents).

Prasyarat: [bacaan lengkap dan alur kerja bersama](../../rules/workflow.md#baca-lengkap).

## Acuan dan keluaran

Baca [AGENTS](../../AGENTS.md), [handoff](../../docs/SESSION-HANDOFF.md),
[alur kerja](../../rules/workflow.md), serta
[catatan workspace](../../docs/WORKSPACE.md), dan
[portabilitas](../../rules/portability.md).
Hasil harus berupa instruksi yang bisa dipakai, folder yang jelas, dan
tautan yang benar; bukan sekadar rencana.

## Prosedur

1. Inventaris root, status Git jika tersedia, serta path yang ingin dirapikan.
   Bedakan dokumen approved, kode milik tim, artefak generated, dan arsip.
   Jangan membaca secret atau menganggap semua file untracked boleh dihapus.
2. Tentukan perubahan minimum. Pertahankan satu wadah `apps/` dengan
   `server/` dan `app/`. Saat masih kosong, biarkan penanda kosong;
   jangan membuat manifest, source, migrasi, seed atau runner.
3. Tempatkan aturan bersama pada rules; prosedur tugas pada skill tersendiri
   dengan YAML name/description yang menyatakan pemicu dan batas cakupan.
   Root SKILL adalah indeks, bukan salinan semua prosedur.
4. Untuk riset atau referensi skill, ikuti [seleksi sumber](../../rules/research.md).
   Buat prosedur hanya untuk kebutuhan berulang yang belum tercakup; jangan
   mengimpor bundel atau menambah skill untuk satu aturan sederhana.
   Jika memakai proyek referensi, bedakan yang baru, sudah tercakup, belum
   relevan dan bertentangan; periksa keberadaan source/manifest sebelum meniru
   quickstart atau klaim implementasi. Catat keputusan pada riset yang ada.
   Jika mengubah mekanisme pemuatan agent, periksa dokumentasi resmi terkini.
   Bedakan lokasi native dari routing baca manual. Jangan menyebut folder
   sembarang otomatis terbaca, atau mengubah izin/global config.
5. Saat memindah berkas, validasi path tetap dalam workspace dan tujuan tidak
   menimpa data. Perbarui tautan aktif. Simpan riwayat yang masih diperlukan;
   jangan menjalankan generator arsip atau menambah folder utilitas tanpa alasan.
6. Periksa pemicu positif/negatif serta hasil yang diharapkan menurut
   [skenario skill](../../docs/SKILL-RESEARCH.md#evaluasi). Bedakan validasi
   struktur dari eksekusi agent nyata. Resolusi tautan relatif dimulai dari
   folder file sumber, termasuk skill yang bertingkat; bukan selalu dari root.
   Periksa case tautan, YAML, format, pengarah
   IDE dan daftar file akhir. Pastikan perubahan ini
   tidak menambahkan program, cache, dependensi atau runtime di luar mandat.
7. Untuk persiapan publikasi, ikuti [panduan GitHub](../../docs/GITHUB-WORKFLOW.md):
   periksa calon file commit, aturan ignore, tautan pada hasil clone tanpa arsip
   privat, serta template PR. Kontrak dalam docs tetap sumber normatif, bukan
   artefak generated. Menyiapkan panduan saja tidak memberi mandat push/merge;
   instruksi pengguna untuk publikasi mengotorisasi commit/remote/push terkait.
   Jalankan validator dan tes regresinya sesuai [panduan pengembangan](../../docs/GITHUB-WORKFLOW.md#otomatisasi-cicd); jangan menaikkan hasil
   statis menjadi bukti runtime aplikasi.
8. Perbarui README/handoff dan hasil pemeriksaan singkat pada dokumen workspace.

## Jika terhalang

Jika lokasi instruksi dilindungi izin, laporkan penolakan secara spesifik.
Siapkan sumber yang bisa direview di lokasi yang diizinkan dan rujuk melalui
AGENTS. Jangan memakai shell/tool lain untuk menembus path yang ditolak.
Jangan mengklaim penemuan native sudah berhasil; verifikasi berkas dan pemuatan
runtime adalah dua pemeriksaan berbeda.
