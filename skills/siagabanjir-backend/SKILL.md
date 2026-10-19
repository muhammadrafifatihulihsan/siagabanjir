---
name: siagabanjir-backend
description: Mengubah API, transaksi, worker AI dan lifecycle data pada backend SiagaBanjir yang sudah disiapkan tim. Gunakan untuk implementasi backend sesuai kontrak.
---

# Mengubah backend sesuai kontrak

> **Living document:** perbarui bersama setiap perubahan terkait menurut [aturan dokumentasi](../../rules/documentation.md#living-documents).

Prasyarat: [bacaan lengkap dan alur kerja bersama](../../rules/workflow.md#baca-lengkap).

## Pemeriksaan awal

Baca [domain](../../rules/domain.md), [mutu](../../rules/quality.md),
bagian terkait [SRS](../../docs/SRS.md), dan
[OpenAPI](../../docs/openapi.json).
Inspeksi `apps/server/`, manifest, README dan tes aktual.
Jika folder masih hanya penanda kosong, keluaran yang mungkin adalah telaah
kontrak/rancangan tugas; jangan membuat backend sebagai efek samping.

## Prosedur

1. Petakan aksi ke FR/TC dan operationId: aktor, ownership objek, payload,
   respons/error, versi, idempotensi serta efek transaksi. Periksa serializer
   publik secara terpisah dari endpoint pemilik dan admin.
2. Ikuti stack/struktur tim yang sudah ada. Jika berbeda dari SRS, jelaskan
   dampaknya sebelum memigrasikan framework atau mengganti package.
   Cocokkan migrasi SQL/constraint dan pemetaan DTO dengan kamus data SRS serta
   kontrak wire. Schema proyek lain bukan sumber kolom atau hak akses kita.
3. Untuk penerimaan/reset, uji acceptance dan ledger kuota secara atomik.
   Pertahankan replay/close submission, termasuk kirim lambat setelah GET 404,
   request bersamaan, batas waktu kuota dan reset pada timestamp yang sama.
4. Untuk worker, pisahkan I/O provider/media dari lock bisnis. Periksa lease,
   generation, versi sumber dan hasil efektif saat commit. Hasil AI terlambat
   tidak menimpa koreksi manusia atau membangkitkan laporan yang dihapus.
5. Untuk penghapusan, cabut akses dan keluarkan dari agregat sebelum cleanup.
   Retry cleanup tetap pekerjaan yang sama; penanda/audit punya batas waktu
   tanpa membatalkan cleanup atau mengembalikan kuota.
6. Untuk dokumen/AI, validasi purpose, ownership dan keluaran terstruktur.
   Gunakan fixture sintetis; jangan mengirim data nyata ke provider hanya untuk
   membuktikan unit test. Hindari raw payload, credential dan PII dalam log.
7. Saat mengubah praproses media, cocokkan probe/durasi/orientasi, tiga posisi
   frame, batas ukuran/waktu dan cleanup dengan SRS. Pakai executable serta
   argument array yang terkontrol, direktori kerja privat dan nama keluaran
   unik; jangan menimpa bukti asli atau menyalin opsi overwrite dari resep umum.
8. Jalankan checks yang tersedia dan kasus regresi sesuai risiko. Selaraskan
   kontrak/dokumen jika perilaku yang diotorisasi berubah.

## Hasil dan keterbatasan

Laporkan requirement yang dipenuhi, file berubah, bukti aktual dan hal yang
belum diuji. Mock worker atau schema valid tidak membuktikan layanan provider,
DB aktual, pemrosesan media, atau mutu klasifikasi.
Jika dependensi tidak tersedia, lanjutkan review bagian mandiri; jangan
memasang SDK atau menyiapkan layanan sebagai perluasan tugas otomatis.
