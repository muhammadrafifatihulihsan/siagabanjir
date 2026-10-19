# Invariant produk SiagaBanjir

> **Living document:** perbarui bersama setiap perubahan terkait menurut [aturan dokumentasi](documentation.md#living-documents).

Ini peta risiko untuk implementasi/review, bukan spesifikasi pengganti.
Setelah [bacaan lengkap](workflow.md#baca-lengkap), telusuri kembali bagian
[FRD](../docs/FRD.md) dan [SRS](../docs/SRS.md) yang terdampak;
gunakan [OpenAPI](../docs/openapi.json) untuk nama field wire.

## Akses dan privasi

- Tamu hanya membaca data publik yang ditentukan. Pantau memuat
  locationName, level, updatedAt, reviewState; tidak ada pemilik, media privat
  atau koordinat presisi dalam representasi publik.
- Dua admin setara tidak mendapat akses vault, KTP/KK atau keluarga pemilik.
  Pemeriksaan ownership dilakukan pada resource dan unduhan, bukan UI saja.
- Catatan tindak lanjut melekat pada laporan, dibaca admin dan pemiliknya.
  Pemindahan kelompok tidak memperluas pembaca. Koreksi menambah catatan.
- Tujuan AI laporan, pemeriksaan KTP dan ekstraksi keluarga terpisah sesuai
  persetujuan. Jangan log token, isi dokumen, NIK, lokasi presisi atau raw AI.
  Kunci provider berada di backend, tidak di Flutter atau contoh publik.

## Penerimaan dan perubahan bersamaan

- Kuota default 3 laporan/6 jam memakai rentang `(t-H,t]`; penerimaan bisnis
  yang sah mengonsumsi kuota. Retry tidak menggandakan; hapus tidak mengembalikan.
- Identitas submission stabil selama rekonsiliasi. Respons GET 404 tidak
  sendirian membuktikan penerimaan sudah mustahil; ikuti protokol close SRS.
- Hasil/catatan/review/perpindahan memakai versi dan kondisi sumber aktual.
  AI terlambat tidak menimpa koreksi admin atau memulihkan data yang dihapus.
- Kelompok/review harus dihitung dari sumber relevan yang berlaku. Ditinjau
  membutuhkan cakupan seluruh versi bukti/hasil terkini, bukan sekadar dibuka.
  Urutan tunggu memakai kebutuhan review tertua yang masih terbuka.
- Tingkat demo mengikuti bukti: Rendah genangan lokal dengan informasi cukup,
  Sedang air masuk bangunan/akses terganggu, Tinggi terjebak/perlu pertolongan.
  Ambil tingkat tertinggi yang didukung; informasi kurang tetap Belum dinilai.
  Tingkat ini bukan status bahaya resmi.

## Data lokal dan lifecycle

- Tas, kontak dan draf lokal terpisah per akun dan bertahan setelah logout;
  cache privat layanan mengikuti batas sesi, tidak menjadi arsip lokal bebas.
- Refresh Pantau/antrean setiap 30 detik saat terlihat dan online, juga pada
  pemicu FRD lainnya. Kegagalan mempertahankan data/waktu terakhir; refresh
  tidak menimpa form yang sedang diketik.
- Hapus mencabut akses segera, mengeluarkan sumber dari agregat, membatalkan
  generation dan melanjutkan cleanup yang gagal tanpa memulihkan akses.
- Penanda pemilik 30 hari, audit admin 90 hari; tepat tenggat tidak ditampilkan.
  Cleanup tertunda tetap berjalan dan kuota tidak direset.
