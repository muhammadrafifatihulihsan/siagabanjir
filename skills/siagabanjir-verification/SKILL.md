---
name: siagabanjir-verification
description: Menyusun atau menjalankan rencana tes, regresi dan bukti penerimaan SiagaBanjir. Gunakan untuk permintaan validasi/UAT/kesiapan fitur; bukan setiap edit teks atau diagnosis akar bug.
---

# Memverifikasi perilaku dan batas bukti

> **Living document:** perbarui bersama setiap perubahan terkait menurut [aturan dokumentasi](../../rules/documentation.md#living-documents).

Prasyarat semua tugas: tuntaskan [bacaan lengkap](../../rules/workflow.md#baca-lengkap).
Rujukan khusus di bawah menentukan fokus kerja, tidak mengurangi cakupan bacaan.

Baca [mutu](../../rules/quality.md), bagian [FRD](../../docs/FRD.md)/
[SRS](../../docs/SRS.md) terkait dan [RTM](../../docs/TRACEABILITY.md).
Inspeksi manifest, tes, perangkat serta layanan yang benar-benar tersedia.
Jika aplikasi belum disiapkan tim, hasilnya rencana kasus dan inspeksi dokumen;
pengujian aplikasi tetap NOT_RUN. Jangan membuat proyek atau memasang toolchain.

## Prosedur

1. Tentukan fitur/perubahan, aktor dan FR/AC/TC yang diuji. Nyatakan hasil
   teramati yang membedakan lulus/gagal sebelum memilih alat.
2. Pilih lapisan terkecil yang dapat membuktikan risiko:
   - Dokumen/schema: tautan, ID, bentuk dan contoh payload; tidak membuktikan
     aturan akses, transaksi, provider atau UI.
   - Unit/widget: logika state dan interaksi terkontrol dengan fixture sintetis;
     periksa state awal → aksi → state/efek akhir, bukan snapshot tampilan saja.
   - API/DB/integrasi: efek persisten, hak baca/mutasi, rollback, concurrency,
     idempotensi dan kontrak error dengan lingkungan uji yang tersedia.
   - Perangkat/browser/provider: perilaku aktual di target, izin, aksesibilitas,
     pemrosesan media dan adapter nyata; mock bukan pengganti lapisan ini.
3. Pilih kasus sesuai perubahan, tanpa menjalankan seluruh matriks untuk typo:
   - Ownership: pemilik, warga lain, admin dan proyeksi publik; admin tidak
     memperoleh vault/KTP/KK/keluarga hanya karena perannya.
   - Mutasi: jalur normal, input/batas waktu, duplikasi, konflik versi, replay,
     request lambat dan pembatalan yang belum terminal.
   - Review/hapus/AI: bukti baru, hasil terlambat, agregat berubah, cleanup retry
     dan penanda/audit tepat tenggat tanpa mengembalikan kuota.
   - Flutter: loading/empty/gagal/offline, form saat refresh, kembali/batal,
     pergantian akun, hasil persisten dan respons sesi lama.
   - UI: ikon/label, layar sempit/lebar, teks besar, fokus/keyboard, screen
     reader dan kontras menurut [DESIGN](../../docs/DESIGN.md).
4. Periksa isi script/config untuk membedakan formatter, lint, tipe/analyzer,
   build dan tes; nama script lint saja tidak membuktikan pemeriksaan tipe.
   Gunakan perintah aktual proyek dan lingkungan uji yang sesuai. Catat metode,
   versi/platform, data sintetis, ekspektasi, hasil serta kasus yang terlewat.
   Jangan mengubah data pengguna atau memanggil provider berbayar tanpa mandat
   yang mencakupnya. Bukti cukup ringkas pada dokumen/PR terkait.
5. Untuk kegagalan, simpan langkah reproduksi yang tidak sensitif dan gunakan
   [debug](../siagabanjir-debug/SKILL.md). Jalankan ulang checks terdampak setelah
   perbaikan; jangan mengubah ekspektasi agar bug diterima.
6. Catat PASS/FAIL/BLOCKED/NOT_RUN per pemeriksaan dan cakupan sesuai aturan mutu.
   RTM hanya berubah untuk TC yang benar-benar dijalankan; status approved
   spesifikasi dan kesiapan aplikasi adalah dua hal berbeda.

## Keluaran

Serahkan pemetaan requirement → kasus → metode → hasil, kegagalan/prasyarat
nyata, serta batas kesimpulan. Tidak perlu runner, folder reports atau laporan
baru jika handoff/dokumen yang ada sudah cukup. Jangan menyatakan kompatibilitas
semua OS/IDE, keamanan penuh atau UAT selesai dari sebagian kasus.

Terapkan [matriks dokumentasi](../../rules/documentation.md) dan perbarui RTM
bila bukti requirement berubah. Validasi YAML skill tetap audit struktur;
evaluasi perilaku agent memakai [skenario terpisah](../../docs/SKILL-RESEARCH.md#evaluasi).
