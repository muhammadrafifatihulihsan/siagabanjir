# Status pekerjaan SiagaBanjir

> **Living document:** perbarui bersama setiap perubahan terkait menurut [aturan dokumentasi](../rules/documentation.md#living-documents).

Kondisi baseline **v0.1.0 — 20 Oktober 2026; Release telah terbit**.
Repository menyediakan spesifikasi dan panduan kerja; apps/server dan apps/app
masih berisi penanda kosong. Tim menginisialisasi backend dan Flutter.

## Perubahan terakhir

[WORKSPACE-RELEASE-CLOSE-008](DECISIONS.md#workspace-release-close-008)
mencakup kelanjutan sesi, penutupan verifikasi, push melalui Git Bash,
publikasi v0.1.0, dan pembersihan ekspor session setelah penutupan terverifikasi.

- Persetujuan dan mandat dicatat secara formal dengan ID, tanggal, dan cakupan
  tetap. Riwayat pertanyaan/audit berulang diringkas.
- Informasi repository digabung ke panduan GitHub; rencana SRS yang sudah
  selesai cukup dirujuk melalui register keputusan.
- Tujuh rules dan delapan skill tetap. Aturan bersama dipusatkan tanpa
  mengurangi kewajiban bacaan lengkap dan pemeliharaan living documents.
- Kontrak memiliki 72 operasi, 165 skema, dan 54 contoh. Skema respons JSON
  unduh media yang tidak digunakan dihapus; endpoint tetap mengirim bytes.
- CI dan workflow rilis memakai action berbasis Node 24. Catatan rilis
  diambil dari CHANGELOG sesuai tag, dengan validasi entri sebelum publikasi.
- Validator tautan dan lint Markdown mengecualikan ekspor session lokal;
  regresi memastikan handoff aktif tetap diperiksa. Label ringkasan
  persetujuan diselaraskan dengan keputusan editorial.

## Acuan dan bukti

BRD/PRD v0.1.0 dan FRD/SRS v1.0.0 tetap APPROVED. FRD-STD-001–012 adalah
baseline fungsional; status draf pada riwayat dibaca sesuai tanggalnya.
156 TC FRD dan 24 TC-SRS tetap NOT_RUN pada aplikasi.

Hasil pemeriksaan lokal dan status publikasi: [WORKSPACE](WORKSPACE.md#audit-release-close).
Status per commit dan tag: [GitHub Actions](https://github.com/muhammadrafifatihulihsan/siagabanjir/actions).
Tag v0.1.0 menunjuk commit e1e11194b20cad9335901fabeb90d4f7e736f2b1.
[CI commit rilis](https://github.com/muhammadrafifatihulihsan/siagabanjir/actions/runs/39296073413)
berhasil pada ketiga pekerjaan, lalu
[workflow Release](https://github.com/muhammadrafifatihulihsan/siagabanjir/actions/runs/39296208857)
berhasil. [SiagaBanjir v0.1.0](https://github.com/muhammadrafifatihulihsan/siagabanjir/releases/tag/v0.1.0)
terbit sebagai Latest pada 20 Oktober 2026 pukul 00.41 WIB; catatannya cocok
dengan CHANGELOG. Arsip source tersedia tanpa aset aplikasi.
Gate lokal PASS: 36 Markdown, delapan skill, 165 skema, 54 contoh, Redocly,
25 tes regresi, EditorConfig dan pemeriksaan diff.
Rilis mengikuti [prosedur versioning](VERSIONING.md): tag hanya dibuat setelah
CI berhasil pada commit yang sama. Rilis dokumentasi tidak menyatakan
backend, Flutter, provider, perangkat, atau UAT telah lulus pengujian.

## Pekerjaan berikutnya

Publikasi baseline selesai. Ekspor session lokal sudah tidak ditemukan pada
pemeriksaan penutupan; handoff aktif ini tetap dipelihara. Catatan penutupan
ditambahkan sesudah rilis, tanpa memindahkan tag v0.1.0.

1. Tim menginisialisasi backend di apps/server dan Flutter di apps/app.
2. Periksa manifest dan kode aktual sebelum menetapkan versi, perintah build,
   konfigurasi, atau tes aplikasi. Lengkapi README aplikasi sesuai hasil nyata.
3. Implementasikan milestone PRD: akun/dokumen/KTP, laporan/AI, admin/Pantau,
   fitur pendukung, lalu validasi.
4. Selaraskan spesifikasi, kontrak, desain, rules, dan skills pada perubahan
   yang memengaruhinya.

Sumber skill dibaca melalui AGENTS. Penempatan native Codex belum tersedia
pada lingkungan yang diperiksa; konfigurasi izin tidak diubah.
Pengujian pemuatan IDE, runtime aplikasi lintas OS, dan evaluasi agent terpisah
tetap NOT_RUN.
