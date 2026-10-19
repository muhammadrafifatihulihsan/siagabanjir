---
name: siagabanjir-requirements
description: Menelaah atau mengubah requirement, AC/TC, kontrak dan keterlacakan SiagaBanjir. Gunakan untuk keputusan fungsi atau konflik spesifikasi.
---

# Menjaga konsistensi requirement

> **Living document:** perbarui bersama setiap perubahan terkait menurut [aturan dokumentasi](../../rules/documentation.md#living-documents).

Prasyarat semua tugas: tuntaskan [bacaan lengkap](../../rules/workflow.md#baca-lengkap).
Rujukan khusus di bawah menentukan fokus kerja, tidak mengurangi cakupan bacaan.

## Masukan

Baca [handoff](../../docs/SESSION-HANDOFF.md), instruksi terbaru, lalu bagian
terkait dari [FRD](../../docs/FRD.md), [SRS](../../docs/SRS.md),
[DECISIONS](../../docs/DECISIONS.md), dan
[TRACEABILITY](../../docs/TRACEABILITY.md).
Gunakan [domain](../../rules/domain.md) sebagai peta risiko.

## Prosedur

1. Tentukan apakah pekerjaan berupa audit, klarifikasi redaksi, perubahan
   keputusan, atau kebutuhan bukti implementasi. Jangan menyamakan keempatnya.
2. Cari ID requirement sumber dan keputusan finalnya. FRD STD-001–012 menutup
   discovery historis; label pertanyaan lama bukan otomatis agenda terbuka.
3. Untuk perubahan fungsi, tuliskan perilaku sebelum/sesudah, aktor, akses,
   state, kondisi gagal dan dampak ke requirement lain. Otorisasi yang sudah
   diberikan cukup untuk keputusan rutin dalam cakupannya.
4. Selaraskan FR/AC/TC, SRS, aturan data, serta kontrak wire bila terdampak.
   Pertahankan ID stabil; jangan menghapus keterlacakan historis diam-diam.
   Periksa [OpenAPI](../../docs/openapi.json) dan
   [contoh](../../docs/examples.json) untuk perubahan payload/route.
5. Catat keputusan baru secara append-only pada register, dengan asal mandat
   yang sebenarnya. Approval baseline tidak otomatis menjadi approval untuk
   perluasan fungsi baru di luar mandat.
6. Periksa rujukan ID/anchor/RTM, aturan akses dan kasus batas. Validasi schema
   hanya jika kontrak berubah; jangan mengubah contoh supaya menyembunyikan
   ketidaksesuaian implementasi.
7. Serahkan daftar perubahan dan konflik tersisa. Jika tidak ada perubahan
   fungsi, nyatakan itu dan jangan membuat versi produk baru hanya karena path.

## Batas bukti

Gunakan [aturan verifikasi](../../rules/quality.md). Audit dokumen/schema tidak
mengubah TC aplikasi menjadi PASS. Keputusan provider/perangkat yang terjadwal
tetap memerlukan bukti nyata, tanpa membuka ulang pilihan fungsi yang approved.
Jika instruksi benar-benar bertentangan, tunjukkan ID/teks konflik dan minta
klarifikasi hanya untuk keputusan yang tidak tercakup mandat.

## Penutupan

Terapkan [matriks dokumentasi](../../rules/documentation.md), perbarui sumber
terdampak dan laporkan pemeriksaan aktual beserta keterbatasannya.
