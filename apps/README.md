# Aplikasi SiagaBanjir

> **Living document:** perbarui bersama setiap perubahan terkait menurut [aturan dokumentasi](../rules/documentation.md#living-documents).

Satu wadah kode tim, bernama `apps/`.

| Folder | Tanggung jawab |
|---|---|
| server/ | Backend/API/worker yang diinisialisasi tim |
| app/ | Flutter warga Android dan admin Web yang diinisialisasi tim |

Kedua direktori hanya berisi `.gitkeep`. Tim menentukan pembagian subproyek
Flutter di dalam `app/`. Buka root repository agar panduan bersama terlihat.
Perubahan sumber dan dokumentasi dikirim mengikuti
[panduan commit, push dan PR](../docs/GITHUB-WORKFLOW.md).

Setelah setup tim tersedia, README aplikasi mencatat versi, perintah aktual,
prasyarat dan perbedaan Windows/macOS/Linux. Gunakan path relatif; konfigurasi
SDK/database lokal tidak masuk source bersama. Ini bukan klaim runtime
aplikasi sudah diuji di semua OS.

## Informasi setelah tim selesai setup

Isi README aplikasi dari manifest dan hasil yang benar-benar diperiksa.
Saat ini belum ada perintah build/run yang dapat dijalankan dari wadah ini.

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
