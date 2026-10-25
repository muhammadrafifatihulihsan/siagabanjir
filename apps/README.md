# Aplikasi SiagaBanjir

> **Living document:** perbarui bersama setiap perubahan terkait menurut [aturan dokumentasi](../rules/documentation.md#living-documents).

Satu wadah kode tim, bernama `apps/`.

| Folder | Tanggung jawab |
|---|---|
| server/ | Backend/API/worker yang diinisialisasi tim |
| siagabanjir/ | Flutter warga Android dan admin Web yang diinisialisasi tim |

`server/` masih berisi `.gitkeep`; `siagabanjir/` sudah memiliki scaffold Flutter
dengan target Android dan Web dari setup tim. Folder 15 fitur warga/admin
beserta layer sudah disiapkan. Fitur home menampilkan satu mockup beranda warga
dengan aset lokal dan panel pratinjau. Fitur reports memiliki halaman buat
laporan interaktif lokal sesuai SVG; perilaku bisnis belum diimplementasikan.
Struktur, batas layer dan pembagian kerja ada pada
[README Flutter](siagabanjir/README.md). Buka root repository agar panduan bersama terlihat.
Perubahan sumber dan dokumentasi dikirim mengikuti
[panduan commit, push dan PR](../docs/GITHUB-WORKFLOW.md).

Setelah setup tim tersedia, README aplikasi mencatat versi, perintah aktual,
prasyarat dan perbedaan Windows/macOS/Linux. Gunakan path relatif; konfigurasi
SDK/database lokal tidak masuk source bersama. Ini bukan klaim runtime
aplikasi sudah diuji di semua OS.

## Informasi setelah tim selesai setup

Isi README aplikasi dari manifest dan hasil yang benar-benar diperiksa.
Proyek Flutter berada di `siagabanjir/`; backend belum memiliki perintah build/run.
Pemeriksaan format XML Android mengikuti pengecualian terbatas pada
[panduan CI](../docs/GITHUB-WORKFLOW.md#otomatisasi-cicd).

| Informasi | Isi yang perlu dicatat setelah tersedia |
|---|---|
| Lokasi | Path relatif proyek server, Flutter warga/admin, dan working directory perintah |
| Toolchain | Versi aktual runtime/SDK/package manager; bedakan target SRS dari versi yang terpasang |
| Perintah | Perintah sebenarnya dari proyek, tujuan, prasyarat dan hasil yang diharapkan |
| Pemeriksaan | Formatter, lint/analyzer, pemeriksaan tipe, tes dan build beserta cakupan masing-masing |
| Konfigurasi | Nama variabel, fungsi, wajib/opsional dan contoh tidak rahasia; alamat API sesuai perangkat/lingkungan, bukan angka port pinjaman |
| Efek samping | Jelaskan perintah yang mengubah DB, seed atau berkas; jangan menjadikannya task otomatis saat membuka editor |
| Bukti | OS/platform, metode dan status pemeriksaan aktual, termasuk keterbatasan |

API Flutter memakai repository/client bersama sesuai SRS. Kunci provider dan
database hanya pada backend. Simpan petunjuk aplikasi di sini atau README proyek
aktual, lalu rujuk [sumber bersama](../docs/WORKSPACE.md#sumber-acuan) untuk data,
arsitektur dan kontrak. Jangan membuat ulang salinan spesifikasi di setiap app.

Acuan: [AGENTS](../AGENTS.md), [SRS](../docs/SRS.md),
[OpenAPI](../docs/openapi.json), [DESIGN](../docs/DESIGN.md),
[portabilitas](../rules/portability.md), dan
[sinkronisasi dokumentasi](../rules/documentation.md).
