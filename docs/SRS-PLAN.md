# SiagaBanjir — Rencana tahap 4: SRS

> **Living document:** perbarui bersama setiap perubahan terkait menurut [aturan dokumentasi](../rules/documentation.md#living-documents).

Status: rencana telah dilaksanakan; hasilnya [SRS v1.0.0](SRS.md), kontrak API, RTM dan audit. Isi berikut dipertahankan sebagai rencana asal.

## Dasar dan tujuan

FRD v1.0.0 telah APPROVED melalui mandat pemilik. Pemeriksaan ulang `python -X utf8 .frd_audit.py` pada sesi perencanaan menghasilkan PASS: 68 FR, 136 AC, 156 TC, cakupan 57 PRD-F dan 10 PRD-NF, serta sumber terlindungi tetap utuh. Seluruh tes produk masih NOT_RUN.

Tujuan tahap ini adalah menghasilkan spesifikasi perangkat lunak yang cukup konkret untuk membagi pekerjaan backend/AI, Flutter warga, dan Flutter admin tanpa masing-masing menebak kontrak data atau perilaku kegagalan.

Sumber berlaku: [BRD](BRD.md), [PRD](PRD.md), [FRD](FRD.md), [keputusan finalisasi](DECISIONS.md#frd-dlg-001), dan [keterlacakan](TRACEABILITY.md#frd-finalization-trace). FRD §1–29 dan STD-001–012 berlaku; usulan lama pada lampiran historis tidak dibuka kembali sebagai pertanyaan. Panduan penyusunan adalah `C:\Users\Pongo\Desktop\Belajar\prompting-setup\4.PROMPT_SRS.md`, disesuaikan dengan keputusan dan mandat pengguna terbaru.

## Batas pekerjaan

- Tetap demo lokal: Flutter Android warga, Flutter Web admin, API/worker TypeScript dalam satu codebase dengan proses terpisah, dan Laragon 6/MySQL.
- Semua modul PRD/FRD tetap dicakup. Keputusan rutin teknis dipilih dengan alasan tertulis dan kebutuhan demo sebagai batasnya; keputusan fungsi yang sudah final tidak ditanyakan ulang.
- Tahap ini menyusun kontrak dan rancangan yang diperlukan. Setup workspace, instalasi layanan, hosting/deployment dan implementasi aplikasi mengikuti tahap berikutnya. Backup server tidak menjadi syarat SRS.
- Versi library/model, kemampuan provider, inventaris perangkat, biaya dan hasil pengujian harus dibuktikan sebelum disebut fakta. Pemeriksaan dokumentasi memakai sumber resmi pada saat pilihan dibuat.
- Perubahan yang ternyata diperlukan terhadap fungsi FRD dicatat dengan alasan dan dampak FR/AC/TC; keputusan baru tidak disisipkan diam-diam ke baseline lama.

## Urutan kerja dan hasil setiap langkah

| Langkah | Pekerjaan | Hasil konkret / selesai bila |
|---|---|---|
| 1. Pemetaan turunan | Petakan 68 FR dan 10 batasan NF ke calon requirement SRS; pisahkan aturan wajib, keputusan desain, dan bukti yang belum tersedia | Kerangka SRS, indeks requirement ber-ID stabil, dan daftar dependensi tanpa kehilangan modul |
| 2. Batas komponen dan kelayakan awal | Tetapkan tanggung jawab aplikasi warga/admin, API, worker, database, penyimpanan privat, data lokal dan adapter AI. Periksa dokumentasi pilihan teknis yang relevan; identifikasi format/model/plugin yang perlu dibuktikan | Diagram konteks/alur, daftar keputusan teknis beserta alasan, serta protokol pembuktian provider/perangkat. Pilihan yang belum terbukti diberi batas jelas |
| 3. Model data dan integritas | Rinci entitas/relasi, field/tipe/null/enum, ownership, versi, keunikan, waktu, retensi dan penghapusan | ERD dan kamus data; transaksi penerimaan/kuota, review per versi, perubahan kelompok, dan penghapusan mempunyai invariant yang dapat diuji |
| 4. Kontrak antarmuka | Rinci operasi API, autentikasi, izin per objek, input/output, validasi, error, pagination, versi dan pengulangan permintaan. Rinci pertukaran data dengan worker/provider | Katalog operasi dan contoh request/response sukses/gagal yang dapat dipakai kedua aplikasi serta backend; tidak ada field yang berbeda makna antarbagian |
| 5. Proses, sesi dan keadaan lokal | Rinci state/transisi, timeout/retry, rekonsiliasi, hasil usang, konflik dua admin, logout/switch akun, polling, cache dan konten offline | Diagram urutan untuk kasus kritis; setiap kegagalan/konflik mempunyai keadaan akhir dan tindakan pengguna yang jelas |
| 6. Verifikasi dan pembagian implementasi | Turunkan seluruh 156 TC FRD ke pemeriksaan SRS; tambahkan kasus teknis jika diperlukan. Tentukan data uji, kondisi pengukuran NFR dan pembagian pekerjaan per modul | RTM FRD ↔ SRS ↔ verifikasi, manifest demo, kriteria masuk/keluar pengujian dan urutan pekerjaan sesuai dependensi |
| 7. Rekonsiliasi dan penutupan | Periksa konsistensi data/API/state/izin, cakupan sumber, tautan, contoh, keputusan dan risiko tersisa | SRS lengkap dan layak menjadi acuan tahap 5, dengan status versi serta batas bukti yang jujur; handoff diperbarui |

Langkah 2 dimulai sebelum merinci seluruh API agar ketidakcocokan input AI atau kemampuan perangkat diketahui lebih awal. Langkah 3–5 direkonsiliasi bersama: perubahan satu field/state harus tercermin pada kontrak dan skenario terkait. Tidak ada estimasi hari yang dikarang sebelum volume kontrak dan ketersediaan bukti dipetakan.

## Fokus teknis pertama

Rinci fondasi akun/ownership dan penerimaan laporan lebih dahulu karena dipakai banyak modul. Walkthrough pertama mencakup:

1. Daftar/login → dokumen/KTP aktif → draf → Kirim → diterima → analisis → review → Pantau.
2. Respons Kirim hilang, dua permintaan berebut satu kuota, dan revisi lama tiba setelah penolakan definitif.
3. Admin menyimpan review ketika bukti baru masuk atau hasil berubah; koreksi admin berhadapan dengan hasil AI terlambat.
4. Hapus tercatat ketika analisis/pembersihan belum selesai; akses tetap dicabut dan laporan tidak dibuat kembali.
5. Logout A/login B saat callback A tiba; data dan antrean tetap terisolasi.

Sesudah fondasi tersebut jelas, lengkapi keluarga/tas, konten/panduan/TTS, inbox, dan pengelolaan admin. Urutan ini adalah dependensi penyusunan; semua fitur pendukung tetap wajib.

## Empat paket bukti yang dilanjutkan

| Asal FRD | Pekerjaan | Batas klaim |
|---|---|---|
| Q004 — perangkat | Catat perangkat Android/browser yang benar-benar tersedia; susun matriks GPS/manual/mock/developer unknown, build internal/demo dan TTS | Dokumentasi plugin tidak membuktikan perilaku pada perangkat pengguna |
| Q013 — AI laporan | Verifikasi dukungan input foto/frame pada model dan akun yang dipilih; siapkan PoC hasil sah/invalid/timeout/tidak sesuai dengan spesimen sintetis | Fixture tidak disebut panggilan provider nyata; mutu/biaya/waktu belum dianggap terukur |
| Q014 — KTP/keluarga | Pisahkan pemeriksaan jenis/nama KTP dari ekstraksi keluarga; siapkan kasus jelas/buram/salah jenis/parsial dan sumber dihapus | Tidak mengklaim verifikasi identitas resmi atau hasil ekstraksi pasti benar |
| Q019 — demo/UAT | Rancang manifest 2 admin, 6 warga, 12 laporan, 6 KTP dan 2 KK sintetis; catat asal/izin, expected result dan penguji | Actual result hanya diisi setelah eksekusi; skenario gagal/retry dapat menjadi varian tanpa menambah jumlah laporan bisnis |

Inventaris dan protokol dibuat saat penyusunan SRS. Eksekusi PoC/uji dilakukan ketika kode, akses dan perangkat yang diperlukan tersedia; kekurangan bukti tidak menghalangi penulisan bagian SRS yang independen. Bukti yang belum tersedia tetap tercatat dengan dampak, penanggung jawab dan titik verifikasi sebelum fitur terkait dinyatakan lulus.

## Dokumen yang dihasilkan

- `docs/SRS.md`: kontrol dokumen, pendahuluan, konteks, requirement fungsional, data, antarmuka, nonfungsional, verifikasi, tata kelola dan lampiran. ERD, diagram urutan serta contoh kontrak ditempatkan di bagian terkait; pilihan desain dibedakan dari requirement wajib.
- `docs/DECISIONS.md`: tambahan keputusan SRS dan alasan tanpa menulis ulang jawaban historis.
- `docs/TRACEABILITY.md`: tambahan pemetaan SRS, sumber riset, risiko/bukti, dan audit.
- `docs/SESSION-HANDOFF.md`: keadaan terbaru, keputusan yang sudah dibuat, pekerjaan tersisa dan titik lanjut.

Jumlah requirement SRS mengikuti granularitas kontrak yang dibutuhkan, bukan dipaksa sama dengan jumlah FR. ID FR/AC/TC yang sudah ada tetap stabil dan tidak kehilangan cakupan.

## Kriteria selesai tahap SRS

SRS selesai ketika seluruh fungsi dan batasan NF mempunyai turunan yang dapat diuji; data, API, izin dan transisi saling konsisten; kasus duplikasi/konflik/gagal tercakup; pilihan teknis dan batas bukti tercatat; serta keputusan implementasi yang kritis sudah ditentukan atau penundaannya memiliki dampak dan batas penggunaan yang jelas. Status approved tidak dipasang pada kerangka atau kontrak yang belum selesai.

Tahap setelah SRS adalah **workspace setup dan implementasi bertahap sesuai milestone PRD**. Rencana tahap SRS ini tidak menjalankan setup maupun mengklaim aplikasi sudah lulus pengujian.
