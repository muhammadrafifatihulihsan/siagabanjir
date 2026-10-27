---
name: siagabanjir-flutter
description: Mengubah fitur, state, offline dan isolasi akun pada Flutter Android warga/Web admin SiagaBanjir milik tim. Gunakan untuk implementasi alur aplikasi.
---

# Mengubah alur Flutter sesuai spesifikasi

> **Living document:** perbarui bersama setiap perubahan terkait menurut [aturan dokumentasi](../../rules/documentation.md#living-documents).

Prasyarat: [bacaan lengkap dan alur kerja bersama](../../rules/workflow.md#baca-lengkap).

## Pemeriksaan awal

Baca [domain](../../rules/domain.md), [mutu](../../rules/quality.md), dan bagian
terkait [FRD](../../docs/FRD.md)/[SRS](../../docs/SRS.md).
Untuk perubahan UI, baca [DESIGN](../../docs/DESIGN.md) dan
[aturan UI](../../rules/ui.md): komponen Material 3, ikon standar, token,
aksesibilitas, serta pemeriksaan visual pada state yang relevan.
Inspeksi `apps/siagabanjir/` untuk menemukan proyek warga/admin, manifest, routing,
repository dan perintah tes sebenarnya. Jika masih kosong, laporkan kondisi
itu dan kerjakan telaah mandiri yang diminta; jangan menjalankan flutter create.

Ikuti [struktur Flutter aktual](../../apps/siagabanjir/README.md#struktur): nama
fitur/file/kelas Indonesia, layer hanya ketika ada implementasi. Model tampilan
yang membawa Color/IconData berada di presentation/models, bukan domain.
Jangan membuat ulang folder placeholder berdasarkan catatan historis.

## Prosedur

1. Petakan layar/aksi ke aktor dan FR/AC/TC. Tentukan data publik, data privat
   dari layanan, serta data lokal per akun sebelum membangun state.
2. Telusuri setiap aksi yang berubah dari titik masuk, objek/ID dan hak akses
   ke sumber data, penyimpanan, hasil, lalu kembali/batal/retry. Pastikan tombol
   tidak berhenti pada toast sukses tanpa efek yang dijanjikan.
   Gunakan struktur dan pola state proyek tim. Pisahkan UI/controller/repository
   seperlunya; jangan mengganti framework state demi mengikuti contoh.
   Widget tidak merakit panggilan API sendiri: gunakan repository dan client
   bersama untuk base URL, autentikasi, error dan session generation. Konfigurasi
   endpoint mengikuti lingkungan tim; kunci provider/database tidak masuk klien.
3. Definisikan loading, empty, success, error, offline, pending dan conflict
   yang relevan. Refresh Pantau/antrean harus menjaga data terakhir serta waktu,
   berjalan saat visible+online dan tidak menimpa form yang sedang diketik.
4. Pertahankan submission ID/draf selama status penerimaan belum terminal.
   Jangan membuka kirim baru hanya karena timeout/GET 404; ikuti rekonsiliasi
   dan close dalam SRS, termasuk respons terlambat.
5. Periksa pergantian akun/logout: data lokal tas/kontak/draf milik akun tetap
   terisolasi; respons lama tidak masuk sesi baru; cache privat layanan dicabut
   sesuai lifecycle. Token admin Web tidak dipersistensikan.
6. Tampilkan koreksi catatan, versi review dan penanda penghapusan sesuai hak
   baca. Admin bukan pemilik vault/keluarga. Jangan menjadikan label tingkat demo
   seolah status darurat resmi atau menyebut kirim selesai saat baru lokal.
7. Untuk layout, periksa constraints induk, ruang jendela, keyboard dan text
   scaling. Jangan menambahkan Expanded atau scroll secara coba-coba tanpa
   memahami constraint. Gunakan komponen Material dan Semantics Flutter untuk
   nama, peran, state dan fokus; jangan menyalin atribut HTML/ARIA ke Dart.
8. Jalankan analyzer/test/build yang ada untuk platform terdampak. Untuk lokasi,
   secure storage, TTS dan izin Android, pisahkan tes mock dari bukti perangkat.
   Gunakan data sintetis pada screenshot dan fixture.

## Keluaran

Serahkan perubahan state/alur, pemetaan requirement, pemeriksaan aktual dan
batas platform yang diuji. Perubahan UI sederhana tidak memerlukan restrukturisasi
proyek. Jika perintah belum tersedia, jangan mengarang hasil build atau memasang
toolchain tanpa mandat yang sesuai.
