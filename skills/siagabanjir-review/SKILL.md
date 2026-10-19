---
name: siagabanjir-review
description: Mereview perubahan kode, kontrak atau dokumentasi SiagaBanjir dengan temuan berbukti. Gunakan untuk audit perubahan; diagnosis bug memakai skill debug.
---

# Review dengan temuan yang dapat diperiksa

> **Living document:** perbarui bersama setiap perubahan terkait menurut [aturan dokumentasi](../../rules/documentation.md#living-documents).

Prasyarat semua tugas: tuntaskan [bacaan lengkap](../../rules/workflow.md#baca-lengkap).
Rujukan khusus di bawah menentukan fokus kerja, tidak mengurangi cakupan bacaan.

## Masukan dan cakupan

Baca [AGENTS](../../AGENTS.md), [domain](../../rules/domain.md), dan
[mutu](../../rules/quality.md). Periksa diff jika repository memiliki baseline;
jika belum ada commit, sebut berkas/baseline dokumen yang dipakai.
Jangan menyebut semua file untracked sebagai perubahan yang dibuat tim.

## Prosedur

1. Tentukan scope review dan baca bagian FRD/SRS/kontrak yang terkait.
   Periksa jalur pemanggilan dan data sekitar perubahan, bukan diff saja.
2. Susun kasus pemicu untuk dugaan bug: aktor, kondisi awal, aksi bersamaan
   atau kegagalan, hasil aktual dan hasil yang diwajibkan.
3. Prioritaskan risiko sesuai perubahan: ownership/public serializer,
   kuota/idempotensi, versi review, form saat refresh, pergantian akun,
   penghapusan dan hasil AI terlambat. Jangan menerapkan checklist yang tidak
   relevan pada perubahan dokumentasi sederhana.
4. Jalankan checks yang tersedia bila berguna, atau buktikan temuan melalui
   alur kode/kontrak yang konkret. Nyatakan jika hanya inspeksi; jangan
   menyebut celah hipotetis sebagai bug pasti.
5. Untuk instruksi agent, periksa bukti bacaan lengkap, penanda living document,
   pemicu skill, tautan dan batas scope. Saat review kesiapan GitHub, periksa
   daftar calon commit dan tautan setelah arsip privat dikecualikan; checklist
   PR tidak membuktikan file sudah dibaca atau tes sudah dijalankan.
   Pastikan permintaan “rapikan workspace” tidak membuat scaffold aplikasi.
   Bedakan sumber yang bisa dibaca manual dari skill native yang terdeteksi.
   Cocokkan quickstart/task/versi dengan manifest dan file aktual. Periksa
   perbedaan ringkasan API dengan kontrak serta aturan format dengan setting IDE.
6. Untuk requirement, pastikan keputusan final mengungguli discovery lama dan
   status audit dokumen tidak mengubah status tes aplikasi.
7. Untuk UI, gunakan [DESIGN](../../docs/DESIGN.md) untuk menilai ikon,
   hierarki tindakan, state, kontras dan aksesibilitas; hindari temuan selera
   tanpa kriteria. Untuk OS/IDE, pisahkan inspeksi file dari tes pemuatan nyata.
8. Jika hanya diminta review, serahkan temuan. Jika perbaikan juga diminta,
   lakukan perubahan terarah dan jalankan kembali checks terdampak.
   Gunakan [debug](../siagabanjir-debug/SKILL.md) bila penyebab perlu ditelusuri;
   [verification](../siagabanjir-verification/SKILL.md) untuk paket bukti penerimaan.

## Format hasil

Tulis temuan berurutan menurut dampak, masing-masing berisi tingkat dampak,
path/baris, pemicu, akibat dan rujukan requirement. Pisahkan pertanyaan nyata
dari temuan terbukti. Jika tidak ada temuan, katakan itu dengan cakupan
pemeriksaan dan risiko yang belum diuji; jangan mengklaim bebas bug.
Gabungkan gejala dengan akar masalah sama. Pisahkan bukti kode, screenshot dan
runtime; jangan mengarang lokasi kode atau interaksi dari gambar saja.

## Penutupan

Terapkan [matriks dokumentasi](../../rules/documentation.md), perbarui sumber
terdampak dan laporkan pemeriksaan aktual beserta keterbatasannya.
