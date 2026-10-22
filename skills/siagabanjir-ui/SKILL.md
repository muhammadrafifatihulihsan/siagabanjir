---
name: siagabanjir-ui
description: Merancang atau menilai layar, ikon Material, teks dan aksesibilitas SiagaBanjir. Gunakan untuk desain atau review visual; perubahan state memakai skill Flutter.
---

# Desain dan evaluasi UI SiagaBanjir

> **Living document:** perbarui bersama setiap perubahan terkait menurut [aturan dokumentasi](../../rules/documentation.md#living-documents).

Prasyarat: [bacaan lengkap dan alur kerja bersama](../../rules/workflow.md#baca-lengkap).

Baca [DESIGN](../../docs/DESIGN.md), [aturan UI](../../rules/ui.md), serta
bagian [FRD](../../docs/FRD.md) dan [domain](../../rules/domain.md) yang relevan.
Periksa layar/kode tim jika tersedia; folder kosong bukan alasan membuat aplikasi.

## Cara bekerja

1. Tetapkan aktor, tugas layar, informasi yang boleh dibaca dan keputusan utama.
   Petakan state normal, kosong, gagal, offline dan konflik yang memang relevan.
   Cocokkan label aksi dengan tujuan, objek dan hasil yang dijanjikan; sertakan
   jalan kembali/batal tanpa kehilangan input sesuai FRD.
2. Periksa komponen/token yang sudah ada. Terapkan Material 3, set Material
   Icons bawaan Flutter, pemetaan makna dan token yang ada di DESIGN.
   Untuk beranda berbasis SVG pemilik, ikuti pengecualian aset slice lokal
   yang tercatat di DESIGN; jangan menggantinya dengan ikon tebakan.
3. Tata hierarki konten sesuai tugas. Untuk warga, tekankan langkah dan status
   kirim; untuk admin, antrean/bukti/tindakan. Hindari menyalin dashboard generik
   atau menjadikan semua informasi kartu dekoratif.
4. Pilih ikon berdasarkan makna dengan label/nama aksesibel. Tidak mengganti
   ikon aksi dengan emoji/gambar AI, atau memasang library tambahan tanpa alasan.
5. Nilai ruang sempit/lebar, teks besar/panjang, fokus/keyboard dan kontras.
   Untuk review gambar saja, catat hal interaktif yang belum bisa dibuktikan.
6. Gunakan state dan data sintetis yang jelas. Jangan mengarang akurasi AI,
   jumlah laporan atau status aman untuk membuat desain terlihat lengkap.
   Teks error menyebut fakta yang diketahui dan langkah pemulihan yang tersedia;
   jangan menebak penyebab atau menyatakan tersimpan saat baru ada di draf.
7. Jalankan pemeriksaan visual/aksesibilitas pada platform yang tersedia.
   Jika hanya menyusun pedoman, keluaran adalah keputusan/rancangan dan
   kriteria penerimaan, bukan klaim implementasi sudah lolos.
8. Terapkan [sinkronisasi dokumentasi](../../rules/documentation.md).
   Perubahan token/ikon di DESIGN; perubahan fungsi juga melalui FRD/SRS/RTM.

## Hasil

Serahkan alasan tata letak, keputusan komponen/ikon, state yang dicakup,
temuan konkret beserta lokasi, dan batas bukti. “Clean” dinilai dari kriteria
DESIGN; jangan berhenti pada penilaian selera atau menambah ornamen.
