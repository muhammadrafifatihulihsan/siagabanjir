# Mutu UI SiagaBanjir

> **Living document:** perbarui bersama setiap perubahan terkait menurut [aturan dokumentasi](documentation.md#living-documents).

Gunakan [DESIGN](../docs/DESIGN.md) sebagai sumber keputusan visual dan ikon.
Aturan ini berlaku saat merancang, mengimplementasikan atau mereview tampilan.

- Mulai dari tugas warga/admin dan data yang sah. Prioritaskan informasi,
  tindakan utama dan state; setiap komponen harus punya fungsi yang jelas.
- Gunakan komponen Material 3 dan satu set ikon Material bawaan Flutter.
  Ikon navigasi/tindakan bukan emoji, gambar AI atau campuran library.
  Pengecualian beranda dari SVG pemilik memakai hasil slice lokal sesuai
  [keputusan desain beranda](../docs/DESIGN.md#acuan-beranda-warga-dari-pemilik).
- Terapkan token tema, jarak, tipografi dan status secara konsisten.
  Hindari dekorasi yang mengaburkan tugas: hero pemasaran di layar operasional,
  kartu berulang tanpa alasan, badge/statistik palsu, atau efek visual berlebihan.
- Konten singkat dan spesifik: apa yang terjadi, apa yang tersimpan, dan aksi
  berikutnya. Sebut penyebab error hanya jika diketahui. Jangan menampilkan
  bahasa teknis backend atau klaim darurat resmi.
- Setiap aksi punya tujuan, objek dan hasil yang sesuai labelnya. Periksa
  navigasi, batal/kembali, penyimpanan dan retry, bukan hanya tampilan sukses.
- Wajib menilai layout sempit/lebar, pembesaran teks, keyboard/fokus,
  label aksesibel, kontras dan state gagal/offline pada UI yang berubah.
- “Terlihat clean” harus dibuktikan terhadap kriteria DESIGN. Jika belum ada
  UI yang berjalan, catat sebagai rancangan/inspeksi, bukan PASS visual.
- Perubahan keputusan visual memperbarui DESIGN dan semua rujukan terdampak
  menurut [aturan dokumentasi](documentation.md); perubahan fungsi juga ke FRD/SRS.
