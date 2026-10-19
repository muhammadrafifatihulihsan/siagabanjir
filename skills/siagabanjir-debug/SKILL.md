---
name: siagabanjir-debug
description: Mereproduksi bug, menguji hipotesis penyebab dan memverifikasi perbaikan SiagaBanjir. Gunakan saat ada error, hasil salah atau regresi; bukan review umum atau setup aplikasi.
---

# Menelusuri bug sampai penyebabnya terbukti

> **Living document:** perbarui bersama setiap perubahan terkait menurut [aturan dokumentasi](../../rules/documentation.md#living-documents).

Prasyarat semua tugas: tuntaskan [bacaan lengkap](../../rules/workflow.md#baca-lengkap).
Rujukan khusus di bawah menentukan fokus kerja, tidak mengurangi cakupan bacaan.

Baca [mutu](../../rules/quality.md), requirement terkait, dan implementasi aktual.
Gunakan [backend](../siagabanjir-backend/SKILL.md) atau
[Flutter](../siagabanjir-flutter/SKILL.md) untuk aturan implementasi yang disentuh.

## Alur diagnosis

1. Catat gejala, perilaku yang diharapkan, aktor, platform, versi sumber, kondisi
   awal dan langkah pemicu. Periksa perubahan pengguna serta perintah yang ada.
   Jika apps masih kosong, sebut prasyarat itu; telaah kontrak boleh dilanjutkan
   tetapi tidak disebut reproduksi runtime.
2. Reproduksi kasus terkecil dengan data sintetis. Pisahkan gangguan lingkungan,
   input yang tidak sah, bug aplikasi dan dugaan kontrak tidak konsisten.
   Jika belum bisa direproduksi, tulis fakta yang tersedia dan hipotesis tersisa.
3. Ikuti aliran input → validasi/akses → state/transaksi → efek → respons.
   Buat hipotesis yang dapat dibedakan oleh bukti, lalu periksa penyebab paling
   dekat. Ubah satu faktor per percobaan; jangan mengacak timeout/dependency.
4. Pilih pemeriksaan sesuai gejala:
   - Kirim ganda/kuota: identitas submission, acceptance/ledger atomik, replay
     dan close; timeout atau GET 404 belum tentu berarti permintaan tidak masuk.
   - Data usang/lintas akun: versi sumber, session generation, cache dan urutan
     respons; periksa hasil AI terlambat setelah koreksi atau penghapusan.
   - Antrean/review: bukti terkini, cakupan review dan kebutuhan tertua terbuka.
   - Layout: exception pertama, constraints induk, ukuran ruang, teks/keyboard;
     jangan mengatasi error turunan dengan clipping atau ukuran tetap sembarang.
5. Pilih perbaikan terkecil yang menghilangkan penyebab dalam cakupan mandat.
   Jangan melemahkan validasi/akses, menghapus tes gagal, mereset data, atau
   mengganti stack hanya supaya gejala menghilang.
6. Jalankan ulang pemicu dan pemeriksaan batas yang relevan. Untuk perubahan
   perilaku berisiko, tambah regresi yang gagal sebelum perbaikan jika dapat
   dibuktikan aman; jangan mengklaim hasil sebelum perbaikan tanpa menjalankannya.
   Edit dokumentasi sederhana cukup inspeksi terarah.
7. Singkirkan instrumentasi sementara milik perubahan ini. Jangan menyimpan
   credential, payload privat atau screenshot data nyata sebagai bukti.

## Keluaran

Sampaikan gejala → penyebab yang terbukti atau hipotesis → perubahan →
pemeriksaan aktual. Cantumkan file/baris serta requirement saat relevan.
Jika terhalang, sebut prasyarat dan lanjutkan bagian mandiri; jangan mengarang
tes lulus atau menginisialisasi aplikasi tim sebagai jalan pintas.

Terapkan [matriks dokumentasi](../../rules/documentation.md). Paket pengujian
penerimaan yang lebih luas menggunakan
[verification](../siagabanjir-verification/SKILL.md) bila memang diminta.
