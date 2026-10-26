# SiagaBanjir — Register Keputusan Produk dan Workspace

> **Living document:** perbarui bersama setiap perubahan terkait menurut [aturan dokumentasi](../rules/documentation.md#living-documents).

| Metadata | Nilai |
|---|---|
| Versi | `v0.1.0` |
| Tanggal | 20 Oktober 2026 |
| Status BRD | **APPROVED — versi `v0.1.0` disetujui pengguna** |
| Status PRD | **APPROVED — versi `v0.1.0`; PRD-APPROVAL-01** |
| Status FRD | **APPROVED — versi `v1.0.0`; FRD-APPROVAL-01 melalui delegasi finalisasi** |
| Status SRS | **APPROVED — v1.0.0 melalui SRS-DLG-001; uji produk NOT_RUN** |
| Kesiapan | Spesifikasi approved; panduan workspace tersedia; backend/Flutter disiapkan tim |
| Tahap | Tahap 5 panduan workspace; kondisi terbaru pada WORKSPACE-LOCAL-COMMIT-009; riwayat dipertahankan |
| Otoritas keputusan bisnis | Pemilik proyek/pengguna |
| Otorisasi pekerjaan saat ini | Commit lokal setiap unit perubahan AI tanpa konfirmasi, gerbang tree bersih, panduan tim pemula, dan push pembaruan aturan; WORKSPACE-LOCAL-COMMIT-009 |
| Dokumen terkait | [BRD](BRD.md) · [PRD](PRD.md) · [FRD](FRD.md) · [Sumber, pertanyaan dan keterlacakan](TRACEABILITY.md) |

**Status historis:** bagian sebelum §27 mencatat keadaan pada saat keputusan dibuat. Pernyataan DRAFT/terbuka di riwayat tidak menjadi status final saat ini; FRD ditutup pada §27, SRS pada §28, dan mandat workspace terbaru pada §37. Keputusan arsip/publikasi §33 juga dibaca sesuai checkpoint-nya.

Register ini menyimpan keputusan, alasan, konflik, risiko, persoalan terbuka, dan perubahan. Penomoran `DEC-001`–`DEC-042` mengikuti `BR-001`–`BR-042` dalam BRD; `PRD-DEC-001`–`PRD-DEC-043` mengikuti urutan pertanyaan `PRD-Q001`–`PRD-Q043`, bukan nomor requirement PRD. Catatan keputusan menggunakan parafrasa; ID sumber, tanggal, cakupan, dan urutan otorisasi dipertahankan.

**Riwayat persetujuan:** BRD-APPROVAL menetapkan BRD v0.1.0 sebagai baseline dan mengotorisasi penyusunan PRD. Persetujuan PRD serta kelanjutan FRD dicatat pada [PRD-APPROVAL-01](#prd-approval-01). Persetujuan final FRD/SRS dan keputusan workspace tercatat pada bagian berikut sesuai urutan waktunya.

Bagian 2–5 serta Change Log tahap 1 mempertahankan riwayat keadaan ketika keputusan dicatat. Jika keputusan dirinci atau berubah pada tahap 2, keputusan baru dicatat dengan prefix PRD dan rujukan perubahan; pilihan lama tidak diam-diam diganti. Register OPEN pada bagian 6 merekam agenda tahap 1; disposisi berikutnya ditelusuri pada catatan PRD/FRD/SRS.

## 1. Status dan batas kepastian

| Status | Makna |
|---|---|
| `CONFIRMED_DIRECTION` | Pengguna telah mengonfirmasi arah/cakupan yang ditulis. Ini tidak mengesahkan detail teknis yang belum dibahas maupun seluruh dokumen. |
| `DELEGATED_DEFAULT` | Pilihan kerja ditentukan dalam batas delegasi pengguna; dicatat terbuka agar dapat dikoreksi. |
| `PROPOSED_REFINEMENT` | Penajaman yang diajukan untuk review; belum menjadi keputusan final pengguna. |
| `SOURCE_ONLY` | Pernyataan dari bahan lama, termasuk label lama `CONFIRMED`; belum otomatis berlaku sebagai persetujuan sesi ini. |
| `DEFERRED_DETAIL` | Detail dialokasikan ke interview tahap berikutnya tanpa mengarang nilai default. |
| `APPROVAL_PENDING` | Persetujuan final dokumen belum diberikan. |
| `APPROVED_BASELINE` | Versi dokumen tertentu sudah disetujui eksplisit; saat ini berlaku untuk BRD dan PRD `v0.1.0`. FRD tetap DRAFT. |

Keputusan terbaru yang merupakan koreksi eksplisit dicatat bersama riwayatnya, bukan menimpa jejak lama. Angka/rumus, kandidat vendor, keamanan dan fitur dalam paket lama tidak otomatis disetujui hanya karena pernah ditulis. Perbedaan antara izin membuat draf, persetujuan arah, delegasi pilihan, dan persetujuan final harus dipertahankan.

## 2. Decision Log Tahap 1 — Riwayat Baseline BRD

Seluruh keputusan langsung berasal dari pengguna. Pilihan yang dibuat melalui delegasi atau masih berupa penajaman ditandai pada kolom status.

| ID / requirement | Keputusan yang digunakan pada draf | Alasan dan batas keputusan | Status | Bukti |
|---|---|---|---|---|
| DEC-001 / BR-001 | SiagaBanjir ditujukan dahulu untuk demo akademik dengan konteks Padang. | Pengujian tugas kuliah mendahului rilis nyata; tidak mengklaim layanan resmi instansi. | `CONFIRMED_DIRECTION` | [Q-001](TRACEABILITY.md#q-001), [Q-011](TRACEABILITY.md#q-011) |
| DEC-002 / BR-002 | Aplikasi warga memakai Flutter Android; aplikasi admin memakai Flutter Web. | Keduanya merupakan batas platform tugas, bukan pilihan framework yang masih bebas. | `CONFIRMED_DIRECTION` | [Q-011](TRACEABILITY.md#q-011) |
| DEC-003 / BR-003 | Tim berjumlah tiga orang: pemilik proyek menangani backend, AI, pemeliharaan dan review akhir; dua teman mengerjakan Flutter/desain serta integrasi API. | Klarifikasi jumlah mengatasi frasa awal yang ambigu. Pembagian rinci dua teman tidak dikarang. | `CONFIRMED_DIRECTION` | [Q-011](TRACEABILITY.md#q-011), [Q-012](TRACEABILITY.md#q-012) |
| DEC-004 / BR-004 | Alur inti adalah laporan → AI pemeriksaan bukti → kelompok laporan → prioritas tinjauan admin. | Satu alur bisnis inti menjadi dasar urutan pembangunan. | `CONFIRMED_DIRECTION` | [Q-004](TRACEABILITY.md#q-004) |
| DEC-005 / BR-005 | Satu laporan memuat maksimal dua foto **atau** satu video maksimal lima detik. | Foto dan video bukan kombinasi dalam satu laporan. Angka tiga/empat yang disebut kemudian adalah jumlah frame AI, bukan durasi video. | `CONFIRMED_DIRECTION` | [Q-018](TRACEABILITY.md#q-018), [Q-019](TRACEABILITY.md#q-019), [Q-022](TRACEABILITY.md#q-022) |
| DEC-006 / BR-006 | AI memeriksa kesesuaian media dengan keterangan pelapor. | Pemeriksaan ini bukan pembuktian mutlak kejadian atau keaslian. Rincian keluaran, kegagalan dan pemeriksaan manual masih perlu FRD/SRS. | `CONFIRMED_DIRECTION` | [Q-004](TRACEABILITY.md#q-004) |
| DEC-007 / BR-007 | Laporan yang berkaitan dapat dikelompokkan; bukti individual tetap dapat ditinjau. | Kelompok membantu admin memahami sejumlah laporan. Aturan numerik dari bahan lama belum disahkan; penghapusan eksplisit mengikuti DEC-014/015. | `CONFIRMED_DIRECTION` | [Q-004](TRACEABILITY.md#q-004), [Q-005](TRACEABILITY.md#q-005) |
| DEC-008 / BR-008 | Draf membedakan prioritas tinjauan admin dari indikasi bahaya yang ditampilkan kepada warga. | Arah kedua keluaran ada dalam jawaban; pembedaan makna ini merupakan penajaman untuk mencegah skor tinjauan dianggap ukuran bahaya terverifikasi. Label, aturan dan rumus belum final. | `PROPOSED_REFINEMENT` | [Q-004](TRACEABILITY.md#q-004), [Q-008](TRACEABILITY.md#q-008), [Q-010](TRACEABILITY.md#q-010), [Q-023](TRACEABILITY.md#q-023) |
| DEC-009 / BR-009 | Admin meninjau bukti dan dapat mengoreksi hasil AI serta pengelompokan. | Admin tetap memiliki kendali koreksi; bentuk aksi dan aturan konflik perubahan diturunkan pada FRD/SRS. | `CONFIRMED_DIRECTION` | [Q-005](TRACEABILITY.md#q-005) |
| DEC-010 / BR-010 | Admin mencatat tindak lanjut sederhana; dispatch armada/TRC tidak masuk cakupan. | Produk mendukung tinjauan laporan, tidak membangun operasi penugasan bantuan. | `CONFIRMED_DIRECTION` | [Q-005](TRACEABILITY.md#q-005) |
| DEC-011 / BR-011 | Admin mempunyai pengaturan global ON/OFF penggunaan galeri sebagai sumber media laporan. | Ini pengaturan pemilihan media dari galeri perangkat, bukan izin melihat galeri bukti admin. Nilai awal dan perilaku draf lama masih terbuka. | `CONFIRMED_DIRECTION` | [Q-018](TRACEABILITY.md#q-018), [Q-020](TRACEABILITY.md#q-020) |
| DEC-012 / BR-012 | Admin mengatur aturan global N laporan per H jam yang dihitung per akun warga. | N dan H belum ditetapkan. Aturan global tidak berarti satu kuota bersama untuk seluruh akun. | `CONFIRMED_DIRECTION` | [Q-018](TRACEABILITY.md#q-018), [Q-020](TRACEABILITY.md#q-020) |
| DEC-013 / BR-013 | Admin dapat mereset kuota satu akun atau seluruh akun. | Mendukung pengelolaan dan pengujian demo. Rincian batas waktu/reset dicatat sebagai detail tahap berikutnya. | `CONFIRMED_DIRECTION` | [Q-018](TRACEABILITY.md#q-018), [Q-020](TRACEABILITY.md#q-020) |
| DEC-014 / BR-014 | Admin dapat menghapus laporan secara permanen beserta media pada penyimpanan aktif; audit tindakan admin tetap minimal. | Pengguna memilih penghapusan, bukan sekadar menyembunyikan laporan. Ini tidak menjanjikan penghapusan serentak dari semua backup atau sistem provider yang belum dirancang. | `CONFIRMED_DIRECTION` | [Q-017](TRACEABILITY.md#q-017), [Q-021](TRACEABILITY.md#q-021) |
| DEC-015 / BR-015 | Setelah penghapusan, riwayat warga, kelompok dan Pantau diperbarui; perangkat offline menyesuaikan saat online/sinkronisasi. | Tidak boleh tersisa laporan terhapus dalam daftar aktif atau hitungan tanpa rekonsiliasi. Kebijakan cache rinci belum ditetapkan. | `CONFIRMED_DIRECTION` | [Q-017](TRACEABILITY.md#q-017), [Q-021](TRACEABILITY.md#q-021), PLAN-01 |
| DEC-016 / BR-016 | Pantau hanya menampilkan ringkasan lokasi yang mempunyai laporan: nama lokasi, tingkat, waktu pembaruan dan badge review. Warga lain tidak dapat mengakses identitas/kontak pelapor maupun foto/video laporan individual; admin tetap dapat meninjau bukti laporan. Kelompok laporan dipakai sebagai unit lokasi kerja. | Cakupan ringkasan dan batas akses publik dikonfirmasi. Penggunaan kelompok merupakan pilihan sederhana dalam delegasi pengguna, bukan batas administratif atau luas banjir terukur. | `CONFIRMED_DIRECTION`; unit kelompok `DELEGATED_DEFAULT` | [Q-007](TRACEABILITY.md#q-007), [Q-009](TRACEABILITY.md#q-009), [Q-010](TRACEABILITY.md#q-010), [Q-028](TRACEABILITY.md#q-028), PLAN-01 |
| DEC-017 / BR-017 | Informasi lokasi tampil otomatis dari pemrosesan laporan tanpa menunggu persetujuan publikasi admin. | Review admin merupakan pemeriksaan tambahan, bukan gerbang wajib sebelum tampil. | `CONFIRMED_DIRECTION` | [Q-008](TRACEABILITY.md#q-008) |
| DEC-018 / BR-018 | Kelompok yang belum dapat dinilai ditampilkan terpisah dan tidak dilabeli bahaya rendah; admin tetap dapat meninjaunya. | Ketiadaan penilaian tidak boleh disamakan dengan kondisi ringan. | `CONFIRMED_DIRECTION` | [Q-023](TRACEABILITY.md#q-023) |
| DEC-019 / BR-019 | Pantau membedakan hasil otomatis dengan hasil yang telah ditinjau admin melalui badge. | Badge menjelaskan asal/status peninjauan, bukan pengesahan resmi instansi. Masa berlaku badge setelah data berubah masih terbuka. | `CONFIRMED_DIRECTION` | [Q-008](TRACEABILITY.md#q-008), [Q-010](TRACEABILITY.md#q-010) |
| DEC-020 / BR-020 | Admin dapat menandai kejadian selesai sehingga keluar dari Pantau aktif, sementara laporan tetap ada dalam riwayat pribadi. | Menyelesaikan kejadian berbeda dari menghapus laporan. Laporan yang dihapus mengikuti DEC-014/015. | `CONFIRMED_DIRECTION` | [Q-024](TRACEABILITY.md#q-024) |
| DEC-021 / BR-021 | Pembangunan mendahulukan inti, tetapi fitur pendukung yang disepakati tetap wajib pada hasil akhir. | Urutan delivery tidak mengubah pendukung menjadi fitur opsional; posko/sungai mengikuti pengecualian eksplisit. | `CONFIRMED_DIRECTION` | [Q-006](TRACEABILITY.md#q-006) |
| DEC-022 / BR-022 | Checklist tas siaga tetap dalam cakupan pendukung. | Detail daftar barang, personalisasi dan perhitungan diturunkan kemudian. | `CONFIRMED_DIRECTION` | [Q-006](TRACEABILITY.md#q-006) |
| DEC-023 / BR-023 | Kontak darurat tetap dalam cakupan pendukung dan dapat dibaca offline. | Sumber, validasi nomor, pembaruan dan mekanisme penyimpanan offline belum boleh dianggap tersedia dari mockup. | `CONFIRMED_DIRECTION` | [Q-006](TRACEABILITY.md#q-006), [Q-026](TRACEABILITY.md#q-026) |
| DEC-024 / BR-024 | Panduan keselamatan beserta kemampuan suara tetap dalam cakupan pendukung; teks panduan dapat dibaca offline. | Konfirmasi akses teks offline tidak mengonfirmasi TTS offline. Konten dan kemampuan suara perangkat masih harus ditentukan/diuji. | `CONFIRMED_DIRECTION` | [Q-006](TRACEABILITY.md#q-006), [Q-026](TRACEABILITY.md#q-026) |
| DEC-025 / BR-025 | Backup dokumen disimpan secara privat pada backend dan dapat diambil pemilik setelah login pada perangkat lain; admin tidak boleh membaca isi dokumen. Demonstrasi menggunakan dokumen spesimen sintetis. | Cakupan bisnis dan batas akses pemilik/admin kini dikonfirmasi eksplisit. Desain autentikasi, enkripsi/kunci dan pemulihan teknis tetap dirinci kemudian, bukan otomatis mengadopsi bahan lama. | `CONFIRMED_DIRECTION` | [Q-006](TRACEABILITY.md#q-006), [Q-016](TRACEABILITY.md#q-016), [Q-017](TRACEABILITY.md#q-017), [Q-025](TRACEABILITY.md#q-025) |
| DEC-026 / BR-026 | Admin membuat pesan yang masuk ke inbox seluruh warga. Push di luar aplikasi belum wajib. | Cakupan yang dikonfirmasi adalah pesan admin dan inbox seluruh warga; tidak mengesahkan peringatan otomatis AI, target domisili, atau kewajiban push. Detail composer/inbox dirinci kemudian. | `CONFIRMED_DIRECTION` | [Q-006](TRACEABILITY.md#q-006), [Q-010](TRACEABILITY.md#q-010), [Q-027](TRACEABILITY.md#q-027) |
| DEC-027 / BR-027 | Akun, profil, riwayat dan registrasi untuk pengujian mendukung alur warga/admin. | Detail field, pemulihan akun, sesi, serta provisioning admin belum dikunci. | `CONFIRMED_DIRECTION` | [Q-004](TRACEABILITY.md#q-004), [Q-016](TRACEABILITY.md#q-016), [Q-017](TRACEABILITY.md#q-017) |
| DEC-028 / BR-028 | Pemantauan sungai/TMA, stasiun/observasi dan turunannya dikeluarkan; Pantau memakai laporan warga. | Merupakan penggantian fungsi, bukan integrasi sensor atau data sungai. | `CONFIRMED_DIRECTION` | [Q-006](TRACEABILITY.md#q-006), [Q-007](TRACEABILITY.md#q-007) |
| DEC-029 / BR-029 | Modul posko/shelter dikeluarkan dari cakupan. | Layar, kapasitas, sumber data, API dan acceptance posko lama tidak dibawa ke baseline baru. | `CONFIRMED_DIRECTION` | [Q-006](TRACEABILITY.md#q-006) |
| DEC-030 / BR-030 | Laragon 6 dan MySQL wajib sebagai lingkungan/database yang dipakai. | Tidak mewajibkan PHP. Versi dependency serta konfigurasi backend dipastikan pada tahap teknis. | `CONFIRMED_DIRECTION` | [Q-011](TRACEABILITY.md#q-011) |
| DEC-031 / BR-031 | Backend memakai TypeScript: proses API dan proses worker terpisah dalam satu codebase. | Kandidat TS+Python ditinjau dahulu. Pengguna baru menyetujui arah ini setelah meminta riset dan menerima hasil riset/PoC; bukan persetujuan pada jawaban awal Q-015. | `CONFIRMED_DIRECTION` | [Q-011](TRACEABILITY.md#q-011), [Q-015 — awal dan lanjutan](TRACEABILITY.md#q-015) |
| DEC-032 / BR-032 | Gunakan akses/kredit DeepSeek milik pengguna untuk kebutuhan AI. | Ketersediaan kredit adalah pernyataan pengguna. Model, endpoint, token dan kemampuan akun nyata belum diuji/dikunci. | `CONFIRMED_DIRECTION` | [Q-013](TRACEABILITY.md#q-013), [Q-015](TRACEABILITY.md#q-015) |
| DEC-033 / BR-033 | Pemakaian AI diupayakan efisien melalui frame video terbatas dan resize terukur. Video diarahkan ke tiga–empat frame; tiga frame dan pemakaian kembali hasil yang masih sesuai merupakan penajaman draf. | Tidak ada janji persentase penghematan atau kualitas setara. Nilai resize, cache dan pemilihan frame memerlukan pengujian. | Arah efisiensi `CONFIRMED_DIRECTION`; tiga frame/cache `PROPOSED_REFINEMENT` | [Q-018](TRACEABILITY.md#q-018), [Q-019](TRACEABILITY.md#q-019), PLAN-01 |
| DEC-034 / BR-034 | Demo dijalankan lokal; persiapan Docker/kemudahan hosting ditempatkan pada tahap setup nomor 5. | Hosting aktif bukan kewajiban saat ini. Keberadaan CLI Docker bukan bukti deployment berhasil. | `CONFIRMED_DIRECTION` | [Q-011](TRACEABILITY.md#q-011) |
| DEC-035 / BR-035 | Hindari tambahan layanan pengembangan berbayar yang wajib. | Ini bukan larangan semua layanan pihak ketiga, dan bukan keputusan menghapus langganan wilayah warga. Kredit AI yang sudah dimiliki tetap dapat dipakai. | `CONFIRMED_DIRECTION` | [Q-010](TRACEABILITY.md#q-010), [Q-013](TRACEABILITY.md#q-013) |
| DEC-036 / BR-036 (historis; SUPERSEDED oleh [WORKSPACE-GITHUB-WORKFLOW-010](#workspace-github-workflow-010)) | Kolaborasi melalui fork dan branch per tugas, lalu PR ke `main` pusat; pemilik proyek meninjau dan perbaikan dilakukan sebelum merge. | Usulan awal empat branch tetap tidak digunakan sebagai keputusan akhir. Repository/Git belum dibuat pada tahap BRD. | `CONFIRMED_DIRECTION` | [Q-011](TRACEABILITY.md#q-011), [Q-014](TRACEABILITY.md#q-014) |
| DEC-037 / BR-037 | Tema biru dan SVG menjadi acuan visual; fitur di dalamnya diperlakukan sebagai kandidat, bukan kewajiban meniru setiap pixel/teks. | Angka, branding dan elemen operasional desain lama bukan otomatis data nyata atau scope wajib. | `CONFIRMED_DIRECTION` | [Q-002](TRACEABILITY.md#q-002) |
| DEC-038 / BR-038 | Rancangan paket demo tahap 1: dua admin, enam warga, dua belas laporan dan enam dokumen spesimen. | Paket awal memuat enam belas laporan; pengguna menyatakan terlalu banyak dan mendelegasikan jumlah. Dua belas adalah default kerja pada rencana, bukan angka awal yang dipilih pengguna secara eksplisit. Belum ada akun/seed/dokumen contoh yang dibuat. **Delta tahap 2:** dokumen menjadi delapan sesuai PRD-DEC-042; angka enam di baris ini dipertahankan sebagai riwayat. | Komposisi akun/dokumen `CONFIRMED_DIRECTION`; 12 laporan `DELEGATED_DEFAULT` | [Q-017](TRACEABILITY.md#q-017), PLAN-01, USER-IMPLEMENT |
| DEC-039 / BR-039 | Dosen/mahasiswa harus dapat menguji alur yang benar-benar bekerja. Fixture/simulasi, pengujian API AI nyata dan UAT manusia dibedakan. | Tampilan berjalan atau respons fixture bukan bukti akurasi model nyata. Dataset/media dan bukti uji masih harus disiapkan. | Arah UAT `CONFIRMED_DIRECTION`; pemisahan bukti adalah penajaman validasi draf | [Q-016](TRACEABILITY.md#q-016), [Q-017](TRACEABILITY.md#q-017), PLAN-01 |
| DEC-040 / BR-040 | Kerjakan nomor setup 1–5 berurutan, satu nomor per tahap, berikan ringkasan dan konfirmasi setiap nomor; dokumen disimpan di `Newfolder/docs`. | Instruksi implementasi saat pencatatan tahap 1 hanya menjalankan rencana dokumentasi nomor 1. Kelanjutan ke tahap 2 kemudian memperoleh otorisasi tersendiri; PRD/FRD/SRS/setup tidak dikerjakan bersamaan. | `CONFIRMED_DIRECTION` | Permintaan awal, [Q-003](TRACEABILITY.md#q-003), PLAN-01, USER-IMPLEMENT; BRD-APPROVAL |
| DEC-041 / BR-041 | Tidak ada tenggat keras; kemajuan dinilai melalui milestone fitur. | Perkiraan satu–tiga bulan disebut hanya sebagai perkiraan bila diperlukan, bukan komitmen jadwal. | `CONFIRMED_DIRECTION` | [Q-011](TRACEABILITY.md#q-011) |
| DEC-042 / BR-042 | Laporan beserta media dapat disimpan sebagai draf offline, lalu dikirim setelah koneksi kembali tanpa menghasilkan duplikasi. Kontak dan teks panduan dapat dibaca offline. | Ini cakupan offline yang dikonfirmasi. Tidak menetapkan TTS offline, pilihan retry otomatis/manual, atau kebijakan sinkronisasi rinci. | `CONFIRMED_DIRECTION` | [Q-026](TRACEABILITY.md#q-026) |

`PLAN-01` adalah rencana tahap 1. `USER-IMPLEMENT` mengotorisasi penyusunan draf BRD, sedangkan `BRD-APPROVAL` menetapkan persetujuan final secara terpisah. `PRD-IMPLEMENT` mengotorisasi penyusunan tahap 2; konsolidasi awal tercatat pada PRD-Q043.

## 3. Conflict Register

| ID | Pernyataan/interpretasi sebelumnya | Penyelesaian pada draf | Status / dampak |
|---|---|---|---|
| CON-001 | Label `CONFIRMED` dalam paket v2.0 dianggap persetujuan pengguna saat ini. | Bahan lama tetap `SOURCE_ONLY` sampai didukung konfirmasi sesi ini. | Diselesaikan sebagai aturan sumber; berlaku untuk semua requirement. |
| CON-002 | Semua fitur dan 19 layar lama dianggap wajib dipertahankan. | Tema/desain adalah acuan; penghapusan/penggantian scope terbaru mengungguli daftar lama. | Diselesaikan melalui Q-002/Q-006; jumlah layar bukan target tetap. |
| CON-003 | Pantau memakai stasiun sungai, TMA, ambang sensor serta data pompa/pintu air. | Ganti dengan daftar kelompok lokasi yang mempunyai laporan warga. | Diselesaikan melalui Q-006–Q-010; terkait DEC-016/028. |
| CON-004 | Posko/shelter dan kapasitasnya tetap menjadi pendukung wajib. | Posko/shelter dikeluarkan secara eksplisit. | Diselesaikan melalui Q-006; terkait DEC-029. |
| CON-005 | “Tanpa langganan” diartikan menghapus fitur langganan wilayah pengguna. | Pengguna menjelaskan maksudnya adalah menghindari kewajiban layanan pengembangan berbayar. Konfirmasi terpisah Q-027 kemudian menetapkan pesan admin ke inbox seluruh warga. | Interpretasi sebelumnya dicabut; Q-010/Q-027, DEC-026/035. |
| CON-006 | “Anggota kelompok 2” dianggap dua orang total. | Pengguna menegaskan pemilik proyek + dua teman = tiga orang. | Diselesaikan melalui Q-012; DEC-003. |
| CON-007 | TypeScript + Python sudah menjadi pilihan final, atau jawaban awal Q-015 dianggap setuju TS saja. | Awalnya hanya kandidat; Q-015 awal meminta riset. Persetujuan TS API + TS worker baru muncul pada jawaban lanjutan setelah riset/PoC. | Diselesaikan dengan histori dua respons Q-015; DEC-031. |
| CON-008 | Usulan empat branch tetap menjadi alur tim. | Pilihan final adalah branch per tugas melalui fork/PR ke `main`, dengan review/perbaikan sebelum merge. | Diselesaikan pada tahap BRD melalui Q-014; DEC-036. Kini SUPERSEDED oleh [WORKSPACE-GITHUB-WORKFLOW-010](#workspace-github-workflow-010). |
| CON-009 | “Video 3/4” dianggap mengubah batas durasi. | Durasi tetap maksimal lima detik; tiga/empat mengacu jumlah frame untuk AI. | Diselesaikan melalui Q-019/Q-022; tiga frame tepat masih penajaman, DEC-005/033. |
| CON-010 | Bukti laporan harus selalu dipertahankan atau penghapusan hanya menyembunyikan tampilan. | Pengguna memilih penghapusan permanen laporan/media aktif, dengan audit tindakan minimal dan pembaruan tampilan/agregat. | Sumber lama digantikan pada tindakan hapus eksplisit; Q-017/Q-021, DEC-014/015. |
| CON-011 | Menyelesaikan kejadian sama dengan menghapus laporan. | Selesai mengeluarkan kejadian dari Pantau aktif dan mempertahankan riwayat; hapus merupakan tindakan terpisah. | Diselesaikan melalui Q-024; DEC-020. |
| CON-012 | Nilai yang belum diketahui dianggap bahaya rendah atau menunggu review sebelum publikasi. | Tampil otomatis, pisahkan belum dinilai, tambahkan badge sesudah review. | Diselesaikan melalui Q-008/Q-023; DEC-017–019. |
| CON-013 | Paket enam belas laporan dianggap angka final yang tidak boleh diubah. | Pengguna mendelegasikan pengurangan; rencana kerja memakai dua belas. | Default didelegasikan, bukan persetujuan eksplisit angka awal; DEC-038. |
| CON-014 | Satu–tiga bulan dianggap deadline, atau semua pendukung menjadi opsional agar masuk jadwal. | Tidak ada deadline keras; gunakan milestone, inti dahulu dan pendukung tetap wajib. | Diselesaikan melalui Q-006/Q-011; DEC-021/041. |
| CON-015 | Skor prioritas internal otomatis sama dengan tingkat bahaya publik. | Draf membedakan makna keduanya; label dan aturan operasional perlu review lebih lanjut. | Penajaman terbuka; DEC-008, OPEN-006. |
| CON-016 | Otorisasi penyusunan draf dianggap persetujuan final BRD. | USER-IMPLEMENT hanya mencakup draf. Persetujuan final diberikan terpisah melalui BRD-APPROVAL. | OPEN-001 ditutup oleh persetujuan final; urutan otorisasi tetap dipertahankan. |

## 4. Register Riset dan Bukti Kelayakan

Catatan ini merangkum penelusuran resmi dan inspeksi/PoC sesi sebelumnya pada 18 Oktober 2026. Tidak ada penelusuran baru, penggunaan token, atau panggilan API berbayar untuk menulis register ini. Klaim versi/layanan harus diperiksa kembali ketika tahap teknis dimulai.

| ID | Bukti dan temuan yang relevan | Batas kesimpulan |
|---|---|---|
| RES-001 | [Panduan resmi DeepSeek Vision](https://api-docs.deepseek.com/guides/vision/) yang dibaca menyebut `deepseek-flash` menerima beberapa gambar melalui format yang didokumentasikan, termasuk URL/base64/file. [Dokumentasi API DeepSeek](https://api-docs.deepseek.com/) menampilkan contoh penggunaan Node dan Python. | Mendukung kelayakan integrasi melalui HTTP, bukan bukti token pengguna sudah bekerja. Model/endpoint versi final belum dipilih; tidak menyimpulkan ada input video native atau akurasi banjir tertentu. |
| RES-002 | [Panduan JSON Output DeepSeek](https://api-docs.deepseek.com/guides/json_mode) yang dibaca mencatat kemungkinan respons kosong. | Kontrak dan validasi hasil/fallback tetap dibutuhkan. Belum diuji dengan media proyek atau akun pengguna. |
| RES-003 | [Panduan event loop Node](https://nodejs.org/en/learn/asynchronous-work/dont-block-the-event-loop) menjelaskan dampak pekerjaan JavaScript yang terlalu lama pada pelayanan request. [Worker threads](https://nodejs.org/api/worker_threads.html) membedakan manfaat untuk komputasi dari pekerjaan I/O. | Mendukung pemisahan API/worker, bukan klaim TypeScript lebih cepat dari Python. Menandai fungsi `async` saja tidak memindahkan hitungan graf ke thread lain. |
| RES-004 | [Child process Node](https://nodejs.org/api/child_process.html) mendokumentasikan `spawn()` asinkron dan array argumen. [ffprobe](https://ffmpeg.org/ffprobe.html) menyediakan metadata/JSON; [FFmpeg](https://ffmpeg.org/ffmpeg.html) menyediakan pembatasan frame keluaran. | Python bukan syarat menjalankan FFmpeg. Batas resource, timeout dan kompatibilitas media tetap perlu implementasi serta pengujian. |
| RES-005 | [Locking reads MySQL 8.0](https://dev.mysql.com/doc/refman/8.0/en/innodb-locking-reads.html) membahas `SKIP LOCKED` untuk tabel menyerupai antrean; [panduan deadlock](https://dev.mysql.com/doc/refman/8.0/en/innodb-deadlocks-handling.html) menganjurkan transaksi singkat. | Kelayakan antrean berbasis MySQL bukan bukti retry/lease/idempotensi/pemulihan crash sudah dibuat atau lulus. Desainnya masih tahap SRS/setup. |
| RES-006 | [FastAPI Background Tasks](https://fastapi.tiangolo.com/tutorial/background-tasks/) membahas kebutuhan alat background yang lebih besar untuk pekerjaan tertentu. [FAQ Celery](https://docs.celeryq.dev/en/stable/faq.html#windows) menyatakan Windows tidak didukung sejak Celery 4.x. | Pertimbangan operasional kandidat TS+Python, bukan larangan Python di Windows. Redis/Celery juga tidak otomatis berarti langganan berbayar. |
| RES-007 | Inspeksi lokal sebelumnya menemukan Laragon 6.0.0 dengan MySQL 8.0.30 dan Node 18.8.0 bawaan; sistem mempunyai Node 24.15.0, Python 3.10.8, dan FFmpeg 9.0.2. | Inventaris mesin pada sesi ini, bukan keputusan mengunci versi untuk semua laptop. Environment tiga anggota belum divalidasi seragam. |
| RES-008 | PoC lokal Node 24.15.0 → FFmpeg/ffprobe 9.0.2 berhasil membedakan sampel sintetis H.264 lima detik dan 5,1 detik, menghasilkan lima JPEG, serta melakukan roundtrip base64. | Bukan kode aplikasi, dataset banjir, atau uji codec Android nyata. Lima frame pada PoC tidak menetapkan jumlah frame produk. Batas 5,01 detik dan semua format tidak diklaim telah diuji. |
| RES-009 | CLI Docker/Compose ditemukan pada inspeksi sebelumnya; akses konfigurasi ditolak dan engine tidak diuji. | Tidak ada bukti image, container, compose stack atau deployment proyek berjalan. |
| RES-010 | Diagram, spesifikasi dan test plan paket lama telah ditinjau sebagai bahan acuan. | Test case tertulis bukan hasil `PASS`. Tidak ada pengujian API AI nyata, recovery job database, aplikasi Flutter, keamanan vault, atau UAT produk pada tahap ini. |

Inferensi dari bukti tersebut adalah bahwa API TypeScript dan worker TypeScript terpisah cukup layak untuk arah prototipe saat ini, dengan MySQL sebagai kandidat penyimpanan pekerjaan persisten. Pengguna menerima **arah** tersebut pada lanjutan Q-015. Framework, library queue, jumlah worker, parameter beban dan kontrak job belum dibekukan. Tidak ada klaim keunggulan performa komparatif, persentase penghematan biaya, atau akurasi AI nyata.

## 5. Risk Register

Risiko berikut diungkap untuk review; tingkat probabilitas/dampak numerik belum dinilai. Pemilik tindakan adalah peran kerja yang sudah disepakati, bukan stakeholder baru. Kontrol yang belum dibahas rinci merupakan usulan untuk tahap terkait.

| ID | Risiko dan penyebab | Dampak | Penanganan yang direncanakan / pemilik | Status |
|---|---|---|---|---|
| RISK-001 | Indikasi otomatis publik dianggap status banjir resmi atau kepastian keselamatan. | Salah memahami informasi demo, terutama sebelum review. | Label demo/otomatis, pisahkan belum dinilai, review semantik DEC-008; pemilik proyek dan tim Flutter. | Terbuka; OPEN-006/007 |
| RISK-002 | Media/keterangan ambigu atau provider gagal menghasilkan penilaian yang keliru/tidak tersedia. | Prioritas dan daftar publik menyesatkan atau laporan tidak diproses. | Simpan laporan, tampilkan status yang benar, review admin, validasi keluaran dan uji kasus gagal; pemilik backend/AI. | Terbuka; OPEN-004/005 |
| RISK-003 | Grouping menggabungkan kejadian berbeda, merambat terlalu jauh, atau menimpa koreksi admin. | Ringkasan dan prioritas tidak mewakili bukti. | Versi aturan, fixture geografi/waktu, koreksi admin dan pengujian konflik; pemilik backend/AI. | Terbuka; OPEN-006 |
| RISK-004 | Penghapusan permanen meninggalkan cache, hitungan, media turunan, atau referensi kelompok yang salah. | Tampilan tidak konsisten dan janji penghapusan tidak terpenuhi. | Bedakan aktif/backup, rekonsiliasi semua proyeksi, jelaskan pembaruan offline dan uji penghapusan; pemilik backend dan integrasi Flutter. | Terbuka; OPEN-010 |
| RISK-005 | Dokumen/media/akun uji mengandung data pribadi nyata atau bocor lintas akun/Pantau. | Penyalahgunaan data dan demonstrasi yang tidak sesuai tujuan. | Gunakan spesimen sintetis; isi dokumen hanya untuk pemilik, termasuk penolakan admin sesuai Q-025. Pantau dibatasi ke ringkasan tanpa identitas/kontak/media individual bagi warga lain sesuai Q-028; admin tetap dapat meninjau bukti laporan. Tinjau cache/log/kunci dan uji akses; pemilik backend dan tim Flutter. | Kontrol bisnis dikonfirmasi; pembuktian teknis terbuka, OPEN-007/008/011/014 |
| RISK-006 | Banyak fitur pendukung wajib membebani satu pemilik backend dan dua pengembang Flutter. | Integrasi terhambat meskipun tidak ada deadline keras. | Milestone fitur, inti dahulu, kontrak sebelum integrasi, review tiap tahap; seluruh tim. | Dikelola melalui DEC-003/021/041 |
| RISK-007 | Kredit AI yang banyak dianggap berarti tanpa batas rate, biaya ulang, retensi, atau kapasitas. | Retry mahal, antrean macet, atau asumsi integrasi keliru. | Verifikasi provider aktual, batas concurrency, pencatatan pemakaian dan uji input terbatas; pemilik backend/AI. | Terbuka; OPEN-004/005/015 |
| RISK-008 | Versi runtime berbeda, path Windows khusus atau Docker belum berfungsi. | Demo tidak dapat direproduksi pada laptop tim atau dipindah nanti. | Pin versi setelah PoC, dokumentasikan environment, uji build bersih dan portability pada tahap 5; pemilik proyek. | Terbuka; OPEN-015 |
| RISK-009 | Nomor kontak, panduan, media atau ilustrasi lama diperlakukan sebagai data valid/berizin. | Demo menyajikan informasi tidak terverifikasi atau dataset tidak dapat dipertanggungjawabkan. | Catat sumber/izin dan review editorial; tandai sintetis/fixture; pemilik proyek dan tim konten/desain. | Terbuka; OPEN-012/014 |
| RISK-010 | Crash worker/retry offline/dua proses memproses pekerjaan sama. | Duplikasi laporan, hasil AI berulang atau job hilang. | Idempotensi, transaksi, pengambilan job terbatas waktu dan uji recovery; pemilik backend/AI. | Terbuka; OPEN-009/015 |
| RISK-011 | Pengaturan galeri/kuota/reset tidak mempunyai perilaku batas yang jelas. | Pengguna ditolak tidak konsisten, retry dihitung ulang atau kuota dapat dilampaui. | Definisikan aturan per akun, waktu evaluasi, reset dan pengiriman tertunda di FRD; pemilik proyek/backend. | Terbuka; OPEN-002/003/009 |
| RISK-012 | Fixture/demo dianggap bukti akurasi model atau kesiapan produksi. | Laporan akademik melebih-lebihkan hasil yang sebenarnya. | Pisahkan bukti fixture, provider dan UAT; catat build/dataset/metode; seluruh tim. | Terbuka; OPEN-014/016 |

## 6. Open Issues dan Pending Decisions

Entri `OPEN-xxx` mengagendakan detail yang masih perlu interview/validasi; ID ini bukan bukti bahwa seluruh pertanyaannya telah diajukan. Register ini diperbarui setelah jawaban tahap 2. Bagian yang telah dijawab ditandai selesai dan dirujuk ke PRD-DEC terkait; sisa teknis tetap terbuka untuk FRD/SRS. ID pertanyaan tahap 1 `Q-xxx` berbeda dari `PRD-Qxxx` tahap 2.

| ID | Hal yang masih harus diputuskan/divalidasi | Tahap yang menangani | Pengaruh pada kesiapan |
|---|---|---|---|
| OPEN-001 | **DITUTUP:** pengguna menyetujui BRD `v0.1.0` dan meminta lanjut langkah berikutnya melalui pernyataan `BRD-APPROVAL`. | 1 — selesai; kelanjutan 2 diotorisasi | Tidak lagi menghalangi BRD; persetujuan final PRD tetap terpisah. |
| OPEN-002 | Nilai N/H, jendela tetap/bergulir, kapan laporan dihitung, batas/reset kuota dan pesan pengguna. Tidak ada angka default yang disahkan. | 3 FRD → 4 SRS | Sebelum implementasi kuota. |
| OPEN-003 | Nilai awal toggle galeri; perilaku draf saat aturan berubah; format/ukuran/resolusi media; penanganan dua foto dan kompresi. Jumlah media dan video lima detik sudah tetap. | 3 FRD → 4 SRS | Sebelum implementasi capture/upload. |
| OPEN-004 | Model/endpoint DeepSeek final, payload gambar/frame/dokumen, kebijakan pemrosesan data, rate limit, token dan kemampuan akun aktual. PRD-DEC-025 menerima arah pengisian otomatis dengan DeepSeek dan pemberitahuan pemrosesan; konfigurasi dan naskah persetujuan belum dibekukan. Jangan menaruh token di dokumen. | 4 SRS → PoC 5 | Sebelum integrasi AI nyata; kredit tersedia bukan bukti keberhasilan. |
| OPEN-005 | **Perilaku produk terjawab:** bukti tidak sesuai tetap diterima/ditandai, dikecualikan dari bahaya sebelum review (PRD-DEC-009); hasil pengisian keluarga harus ditinjau, kegagalan dapat diulang/manual (PRD-DEC-026/027). **Sisa:** kontrak keluaran, respons kosong/invalid, retry teknis, pengujian resize/frame/cache dan batas kelayakan bukti. | 3 FRD → 4 SRS | Sebelum membekukan AI dan optimasi; tidak membuka kembali pilihan menerima laporan yang ditandai. |
| OPEN-006 | **Terjawab:** prioritas admin dibedakan dari indikasi publik; level Rendah/Sedang/Tinggi dengan Belum dinilai terpisah, pemindahan laporan/kelompok baru, kejadian baru setelah selesai dan review ulang setelah bukti berubah (PRD-DEC-013/015/016/017). **Sisa:** rumus, radius/waktu, ketelitian lokasi, urutan, konflik koreksi dan evaluasi numerik. | 3 FRD → 4 SRS | Makna produk sudah cukup untuk PRD; parameter tidak diwarisi diam-diam dari bahan lama. |
| OPEN-007 | **Terjawab:** ringkasan publik tanpa identitas/kontak/media individual (Q-028), akses tamu (PRD-DEC-001), kategori/bagian belum dinilai (PRD-DEC-017). **Sisa:** penamaan/ketelitian lokasi, penegakan akses API, aturan urutan dan penyegaran daftar. | 3 FRD → 4 SRS | Tidak lagi meminta keputusan bisnis mengenai akses tamu atau isi publik. |
| OPEN-008 | **Terjawab:** email/password lokal, kode pemulihan privat, dua admin setara disiapkan tim, tanpa pendaftaran admin publik, pemisahan data lokal per akun; verifikasi email/Google serta hapus akun mandiri ditunda (PRD-DEC-002/028/034/035/036/041). **Sisa:** field/validasi, lifecycle kode, sesi, akses dan pembersihan cache saat logout. | 3 FRD → 4 SRS | Sebelum implementasi autentikasi; tidak mengklaim email terverifikasi. |
| OPEN-009 | **Terjawab:** retry otomatis hanya kiriman yang sudah diperintahkan pengguna ketika aplikasi aktif+online, tombol retry manual, data privat lokal terpisah per akun, kontak/panduan dasar dibundel dan suara offline bergantung perangkat (PRD-DEC-012/028/031/032). **Sisa:** penyimpanan/antrean, evaluasi kuota/kelayakan saat retry, idempotensi, konflik dan recovery. | 3 FRD → 4 SRS | Tidak menjanjikan pengiriman ketika aplikasi ditutup atau suara offline universal. |
| OPEN-010 | **Terjawab:** hapus laporan permanen pada penyimpanan aktif; hapus dokumen sumber tidak menghapus profil keluarga; hapus KTP menahan kiriman baru tanpa menghapus riwayat (PRD-DEC-030/039). **Sisa:** konfirmasi aksi, turunan/cache, audit minimal, backup/retensi dan rekonsiliasi kelompok. | 3 FRD → 4 SRS; operasi 5 | Pisahkan objek laporan, dokumen, profil keluarga dan akun; jangan menyatukan dampak penghapusannya. |
| OPEN-011 | **Terjawab:** vault/profil keluarga privat pemilik lintas perangkat, isi ditolak bagi admin; pengisian otomatis dengan persetujuan dan review, fallback manual, penggabungan impor atas pilihan pengguna, KTP sekali per akun sebelum kirim (PRD-DEC-022–030/037–039). **Sisa:** format/ukuran, pemrosesan file, penegakan akses, enkripsi/kunci, naskah persetujuan, preview/download dan pemulihan. | 3 FRD → 4 SRS | Scope bisnis telah jelas; pemindaian bukan verifikasi NIK resmi dan kemampuan provider belum diuji. |
| OPEN-012 | **Terjawab:** personalisasi dari profil keluarga dan katalog admin, barang tambahan/progres lokal, kontak keluarga lokal, editor admin untuk konten umum, paket offline awal dan TTS sesuai perangkat (PRD-DEC-019–021/023/028/031–033). **Sisa:** isi/sumber katalog, kategori usia/kebutuhan, aturan pemetaan, versi/update/cache serta uji bahasa/perangkat. | 3 FRD → 4 SRS | Tidak lagi memperlakukan editor admin, profil keluarga backend, atau batas suara sebagai pilihan belum dijawab. |
| OPEN-013 | **Terjawab:** admin menerbitkan/mengoreksi/menarik pesan, warga menandai baca, status perubahan/penarikan tetap terlihat (PRD-DEC-040). **Sisa:** field/validasi, masa berlaku, cache, makna baca setelah koreksi dan jangkauan pesan untuk akun yang mendaftar kemudian. | 3 FRD → 4 SRS | Tetap tanpa kewajiban push, target domisili atau peringatan AI otomatis. |
| OPEN-014 | **Komposisi terbaru:** dua admin, enam warga, dua belas laporan, **delapan dokumen: enam KTP dan dua KK spesimen sintetis** (PRD-DEC-042). **Sisa:** manifest kasus/media/label, sumber/izin, desain spesimen, akun tanpa secret dan reset dataset. Paket lama enam dokumen dipertahankan sebagai riwayat DEC-038. | Skenario 3; seed/setup 5 | Jumlah bukan dataset yang telah dibuat/lulus uji. |
| OPEN-015 | Framework/library, versi/runtime tim, storage, skema/API, antrean MySQL, recovery/idempotensi, batas resource, monitoring, dukungan pemeriksaan perangkat dan OCR, serta validasi Docker/portability. | 4 SRS → 5 setup | Arah TS API/worker, MySQL dan DeepSeek tetap; detail implementasi dan kompatibilitas belum terbukti. |
| OPEN-016 | Milestone fitur diterima untuk draf (PRD-DEC-043). Metode UAT dosen/mahasiswa, rubrik tambahan bila ada, dataset pembanding, metrik dan bukti penerimaan masih perlu dirinci, termasuk APK demo vs build pengembangan dan alur KTP/pengisian keluarga. | 3 FRD → 4 SRS; pembuktian saat implementasi | Tidak mengarang akurasi, SLA atau deadline; fixture, provider nyata, perangkat dan UAT dibedakan. |

Sisa detail tersebut tidak menghalangi penyusunan draf PRD yang diotorisasi. FRD, SRS dan setup tetap mengikuti urutan serta konfirmasi tiap nomor. Perubahan tahap 2 dicatat pada log PRD di bawah; setiap revisi bisnis berikutnya harus mempunyai bukti dan jejak perubahan.

## 7. Change Log

Seluruh entri merupakan rekonstruksi perubahan keputusan selama sesi perencanaan hingga otorisasi draf pada 18 Oktober 2026. Urutan ID mempertahankan perubahan penting; tidak mengklaim timestamp yang tidak direkam.

| ID | Pemicu | Perubahan / dampak |
|---|---|---|
| CHG-001 | Permintaan awal; Q-001–Q-003 | Menetapkan demo akademik, bahan lama sebagai acuan mentah, tema/fitur kandidat, serta output dokumentasi di `Newfolder/docs`. |
| CHG-002 | Q-004–Q-006 | Mengonfirmasi alur inti, koreksi admin/tindak lanjut tanpa dispatch, pendukung wajib sesudah inti; mengeluarkan posko dan mengganti pemantauan sungai. |
| CHG-003 | Q-007–Q-010 | Menetapkan daftar Pantau sederhana, hanya lokasi berlaporan, publikasi otomatis dan badge; memilih unit kelompok dalam delegasi kesederhanaan. |
| CHG-004 | Koreksi Q-010 | Mencabut interpretasi “tanpa langganan wilayah”; mencatat batas sebenarnya berupa menghindari layanan pengembangan berbayar yang wajib. |
| CHG-005 | Q-011–Q-012 | Memastikan Padang, Flutter Android/Web, Laragon 6/MySQL, tim tiga orang, pembagian peran, tanpa deadline keras, demo lokal dan kesiapan Docker kelak. |
| CHG-006 | Q-013–Q-014 | Memperjelas kredit API DeepSeek dan memilih branch per tugas melalui fork/PR; menggantikan usulan awal empat branch tetap. |
| CHG-007 | Q-015 awal | Keputusan TS saja **belum diberikan**; pengguna meminta riset mendalam sebelum memilih TS vs TS+Python. |
| CHG-008 | Riset/PoC; Q-015 lanjutan | Setelah bukti dan keterbatasan disampaikan, pengguna menyetujui TS API + TS worker, satu codebase dengan dua proses. Model AI/versi/detail queue belum dikunci. |
| CHG-009 | Q-016–Q-017; PLAN-01 | Memilih pengujian alur oleh dosen/mahasiswa serta paket akun/dokumen demo; jumlah laporan awal enam belas diturunkan menjadi dua belas dalam delegasi pengguna. Belum membuat seed. |
| CHG-010 | Q-018–Q-020 | Menambahkan kontrol galeri global, kuota per akun dan reset; mengklarifikasi video lima detik dengan tiga–empat frame AI dan arah resize hemat pemakaian. |
| CHG-011 | Q-021–Q-022 | Menetapkan hapus permanen laporan/media aktif dengan audit minimal serta dampak tampilan; mengunci maksimal dua foto **atau** satu video lima detik. |
| CHG-012 | Q-023–Q-024 | Memisahkan kelompok belum dinilai; menyelesaikan kejadian mengeluarkannya dari Pantau aktif sambil mempertahankan riwayat, berbeda dari hapus. |
| CHG-013 | PLAN-01; USER-IMPLEMENT | Mengotorisasi penulisan tiga dokumen draf tahap 1. Status `v0.1.0`, `READY WITH DISCLOSED OPEN ITEMS`; final approval belum diberikan. |
| CHG-014 | Q-025–Q-026 | Mengonfirmasi backup backend privat dengan akses pemilik lintas perangkat dan penolakan isi bagi admin; menambahkan BR/DEC-042 untuk draf laporan+media offline, pengiriman tanpa duplikasi setelah online, serta baca kontak/teks panduan offline. Mempersempit OPEN-009/011 menjadi detail pelaksanaan. Saat perubahan ini dicatat, Q-027 masih menunggu jawaban; versi draf tetap `v0.1.0`. |
| CHG-015 | Q-027 | Mengonfirmasi admin membuat pesan ke inbox seluruh warga; push di luar aplikasi belum wajib. Memperbarui DEC-026/OPEN-013; tidak menambahkan alert AI otomatis, target domisili atau editor kontak/panduan sebagai keputusan baru. |
| CHG-016 | Q-028 | Mengonfirmasi Pantau hanya berisi nama lokasi, tingkat, waktu pembaruan dan badge; warga lain tidak dapat mengakses identitas/kontak pelapor atau foto/video laporan individual. Admin tetap meninjau bukti. Memperbarui DEC-016, OPEN-007 dan RISK-005 tanpa menambah requirement; versi tetap draf `v0.1.0` dengan 42 requirement/keputusan. |
| CHG-017 | BRD-APPROVAL | Pengguna menyetujui BRD `v0.1.0` dan meminta lanjut tahap berikutnya. Menutup OPEN-001; status penajaman/approval sebelumnya tetap terbaca sebagai riwayat, bukan permintaan konfirmasi ulang. |
| CHG-018 | Interview PRD; PRD-IMPLEMENT | Mengotorisasi dokumentasi tahap 2 setelah 43 jawaban dan konsolidasi. PRD tetap draf `v0.1.0`; perubahan rinci dicatat pada PRD-CHG, termasuk delapan spesimen menggantikan enam. Tidak mengotorisasi FRD atau implementasi aplikasi. |

## 8. Pemeriksaan Persetujuan dan Serah Hasil BRD — Status Terkini

| Pemeriksaan | Status terkini dengan riwayat tahap 1 dipertahankan |
|---|---|
| Keputusan langsung dapat dirujuk ke jawaban pengguna | Tercatat dalam DEC-001–042 dan register Q di TRACEABILITY |
| Koreksi penting, delegasi dan usulan dipisahkan | Tercatat; perhatian khusus DEC-008/016/033/038 |
| Keterbatasan riset dan PoC diungkap | Tercatat pada RES-001–010; tidak ada klaim API AI/aplikasi telah diuji |
| Persoalan yang belum ditanyakan tidak diberi nomor Q fiktif | Menggunakan OPEN-001–016 |
| Izin menyusun draf BRD | Diberikan melalui USER-IMPLEMENT tahap 1 |
| Persetujuan final BRD | `APPROVED_BASELINE` untuk `v0.1.0`, berdasarkan BRD-APPROVAL |
| Kelanjutan tahap 2 PRD | Diotorisasi melalui pernyataan persetujuan BRD; penulisan draf melalui PRD-IMPLEMENT |
| Persetujuan final PRD | `APPROVED_BASELINE` melalui PRD-APPROVAL-01; bukti PRD-Q043 tetap historis sebagai konsolidasi draf |
| Izin tahap berikut dalam pekerjaan saat ini | Tahap 3 draf FRD diotorisasi dan dimulai; SRS/setup belum dimulai |

Perubahan selanjutnya mencatat versi dokumen yang terdampak dan entri Change Log serta mengonfirmasi perubahan bisnis kepada pemilik proyek. Register bersama saat ini tetap `v0.1.0` dengan status BRD dan PRD yang dibedakan. Register tidak boleh mengubah persetujuan basis draf menjadi persetujuan final hanya agar checklist terlihat selesai.

## 9. Decision Log Tahap 2 — Basis Draf PRD

Status persetujuan pada baris keputusan berikut merekam keadaan saat jawaban itu diberikan. Khusus PRD-DEC-043, APPROVAL_PENDING adalah status historis; persetujuan final yang datang sesudahnya tercatat pada PRD-APPROVAL-01, tanpa mengubah makna jawaban Q043.

Satu baris keputusan mengikuti satu pertanyaan `PRD-Q001`–`PRD-Q043`. Pemilik keputusan produk adalah pengguna; pilihan yang didelegasikan dijelaskan pada baris terkait. Ringkasan berikut adalah parafrasa jawaban dan konsolidasi yang diterima untuk menyusun draf. Katalog PRD memuat **57 requirement fungsional dan 10 nonfungsional**, dengan acceptance criterion masing-masing. Perincian produk berikut melengkapi BRD yang telah disetujui. Perubahan nyata dari baseline, khususnya delapan dokumen spesimen, dicatat eksplisit.

| ID | Keputusan produk dan batasnya | Status | Requirement PRD | Bukti |
|---|---|---|---|---|
| PRD-DEC-001 | Tamu dapat membaca Pantau, kontak umum dan panduan tanpa login. Laporan, dokumen, riwayat dan fitur privat memerlukan login; tidak mengubah batas data ringkasan publik. | `CONFIRMED_DIRECTION` | PRD-F-001/003 | [PRD-Q001](TRACEABILITY.md#prd-q001) |
| PRD-DEC-002 | Akun warga memakai email dan kata sandi lokal. Keputusan ini sendiri tidak berarti email sudah diverifikasi atau layanan pemulihan email tersedia. | `CONFIRMED_DIRECTION` | PRD-F-002/003 | [PRD-Q002](TRACEABILITY.md#prd-q002); dirinci PRD-DEC-034/035 |
| PRD-DEC-003 | Lokasi laporan dapat berasal dari GPS atau titik manual. Pengguna meminta pengendalian lokasi palsu dan Developer Mode; penerapannya dirinci pada keputusan berikutnya, tidak dianggap bukti keaslian lokasi. | Arah dikonfirmasi; diperinci PRD-DEC-004–008 | PRD-F-009/010 | [PRD-Q003](TRACEABILITY.md#prd-q003) |
| PRD-DEC-004 | Tolak pengiriman jika mock location terdeteksi dan wajibkan Developer Mode dimatikan bila status aktif benar-benar terdeteksi. Status yang tidak tersedia tidak boleh diperlakukan sebagai bukti bahwa opsi tersebut mati. | `CONFIRMED_DIRECTION` | PRD-F-010 | [PRD-Q004](TRACEABILITY.md#prd-q004) |
| PRD-DEC-005 | Pemeriksaan perangkat membatasi pengiriman laporan saja. Warga tetap dapat menyimpan draf dan membaca informasi umum; bukan penguncian seluruh aplikasi. | `CONFIRMED_DIRECTION` | PRD-F-010/014 | [PRD-Q005](TRACEABILITY.md#prd-q005) |
| PRD-DEC-006 | Titik manual boleh menunjuk tempat lain. Tampilkan sumbernya sebagai lokasi manual, bukan bukti posisi/kehadiran pelapor; pilihan manual tidak menjadi jalan melewati blok perangkat yang terdeteksi. | `CONFIRMED_DIRECTION` | PRD-F-009/010 | [PRD-Q006](TRACEABILITY.md#prd-q006); PRD-Q004/007 |
| PRD-DEC-007 | Dalam delegasi pengguna, laporan boleh dikirim ketika status Developer Mode **tidak dapat diketahui**, dengan keterbatasan dicatat. Blok untuk status aktif/mock yang benar-benar terdeteksi tetap berlaku, termasuk saat memakai titik manual. | `DELEGATED_DEFAULT`, diterima dalam konsolidasi draf | PRD-F-010 | [PRD-Q007](TRACEABILITY.md#prd-q007), [PRD-Q043](TRACEABILITY.md#prd-q043) |
| PRD-DEC-008 | Build pengembangan internal boleh melewati blok Developer Mode untuk pekerjaan tim. APK demo harus menerapkan dan diuji terhadap kebijakan sebenarnya secara terpisah. Tidak ada izin umum melewati mock location. | `CONFIRMED_DIRECTION` | PRD-F-010; PRD-NF-009 | [PRD-Q008](TRACEABILITY.md#prd-q008) |
| PRD-DEC-009 | Bukti yang dinilai tidak sesuai tetap diterima sebagai laporan dengan penanda perlu review. Bukti itu tidak digunakan untuk indikasi bahaya sebelum ditinjau admin; kelompok tanpa bukti yang layak tetap Belum dinilai. Ketidaksesuaian AI bukan vonis laporan palsu. | `CONFIRMED_DIRECTION` | PRD-F-019/020; PRD-NF-006 | [PRD-Q009](TRACEABILITY.md#prd-q009) |
| PRD-DEC-010 | Pemilik dapat melihat media laporannya sendiri, status, ringkasan hasil AI/ketidakpastian dan review admin. Akses ini tidak diberikan kepada warga lain melalui Pantau. | `CONFIRMED_DIRECTION` | PRD-F-016/017 | [PRD-Q010](TRACEABILITY.md#prd-q010) |
| PRD-DEC-011 | Setelah diterima backend, laporan hanya dapat dibaca oleh warga; draf masih dapat diedit. Pengelolaan laporan yang diterima menjadi kewenangan admin sesuai scope. | `CONFIRMED_DIRECTION` | PRD-F-016 | [PRD-Q011](TRACEABILITY.md#prd-q011) |
| PRD-DEC-012 | Retry otomatis hanya berlaku untuk laporan yang sudah diperintahkan **Kirim**, ketika aplikasi aktif dan koneksi tersedia; sediakan retry manual. Draf yang belum dikirim tetap draf. Tidak menjanjikan proses saat aplikasi ditutup; retry tidak membuat laporan ganda. | `CONFIRMED_DIRECTION` | PRD-F-014/015; PRD-NF-006 | [PRD-Q012](TRACEABILITY.md#prd-q012) |
| PRD-DEC-013 | Admin dapat memindahkan laporan ke kelompok yang ada atau membuat kelompok baru. Operasi khusus penggabungan/pemisahan kelompok secara massal tidak wajib dalam demo. | `CONFIRMED_DIRECTION` | PRD-F-024; PRD-NF-010 | [PRD-Q013](TRACEABILITY.md#prd-q013) |
| PRD-DEC-014 | Catatan tindak lanjut dapat dibaca admin dan pelapor terkait; warga lain tidak dapat membacanya. Ini catatan satu arah, bukan percakapan dua arah atau dispatch. | `CONFIRMED_DIRECTION` | PRD-F-025 | [PRD-Q014](TRACEABILITY.md#prd-q014) |
| PRD-DEC-015 | Laporan baru setelah kejadian ditutup membentuk kelompok aktif untuk kejadian baru; tidak otomatis membuka kembali kelompok lama yang sudah selesai. Aturan keterkaitan rinci diturunkan di FRD/SRS. | `CONFIRMED_DIRECTION` | PRD-F-028 | [PRD-Q015](TRACEABILITY.md#prd-q015) |
| PRD-DEC-016 | Bukti baru memerlukan review lagi. Riwayat review sebelumnya tetap tersimpan, tetapi tidak boleh memberi kesan bukti baru telah ditinjau. | `CONFIRMED_DIRECTION` | PRD-F-026 | [PRD-Q016](TRACEABILITY.md#prd-q016) |
| PRD-DEC-017 | Pantau memakai tingkat **Rendah, Sedang, Tinggi** dan bagian **Belum dinilai** yang terpisah. Tingkat tersebut adalah indikasi aplikasi, bukan status resmi pemerintah; prioritas review admin tetap berbeda makna. | `CONFIRMED_DIRECTION` | PRD-F-036; terkait PRD-F-022 | [PRD-Q017](TRACEABILITY.md#prd-q017) |
| PRD-DEC-018 | Laporan wajib mempunyai media, keterangan dan titik lokasi. Waktu kirim otomatis; waktu kejadian boleh diisi bila berbeda. Delegasi penambahan field penting digunakan untuk metadata sumber lokasi/waktu, tanpa menambah field wajib lain. | `CONFIRMED_DIRECTION` dengan delegasi terbatas | PRD-F-008/009 | [PRD-Q018](TRACEABILITY.md#prd-q018) |
| PRD-DEC-019 | Checklist tas dipersonalisasi menurut profil keluarga/rumah tangga dan menerima barang tambahan warga. Sumber daftar keluarga kemudian dirinci melalui pengisian otomatis dokumen. | `CONFIRMED_DIRECTION` | PRD-F-043/046/047 | [PRD-Q019](TRACEABILITY.md#prd-q019); PRD-DEC-022 |
| PRD-DEC-020 | Checklist pribadi, barang tambahan dan progres tersimpan lokal pada perangkat. Tidak ada janji sinkronisasi progres melalui backend atau antarperangkat. | `CONFIRMED_DIRECTION` | PRD-F-047/050 | [PRD-Q020](TRACEABILITY.md#prd-q020) |
| PRD-DEC-021 | Admin web mengelola kontak umum, panduan dan katalog dasar tas. Warga dapat menambahkan kontak keluarga pribadi yang tersimpan lokal, bukan di database backend. Hak editor konten umum tidak membuka isi dokumen/profil keluarga privat. | `CONFIRMED_DIRECTION` | PRD-F-048/049/053; PRD-NF-005 | [PRD-Q021](TRACEABILITY.md#prd-q021) |
| PRD-DEC-022 | Dokumen yang diunggah dapat dibaca melalui OCR/AI untuk membantu mengisi daftar keluarga sehingga warga tidak memasukkan semuanya satu per satu. Hasilnya masih calon isian, bukan langsung menjadi data final. | `CONFIRMED_DIRECTION` | PRD-F-039/040/041/042/043; PRD-NF-003 | [PRD-Q022](TRACEABILITY.md#prd-q022) |
| PRD-DEC-023 | Data keluarga minimum: nama panggilan, kelompok usia, dan kategori kebutuhan khusus opsional. Daftar kategori dan pemetaan rinci belum ditetapkan. | `CONFIRMED_DIRECTION` | PRD-F-041/043 | [PRD-Q023](TRACEABILITY.md#prd-q023) |
| PRD-DEC-024 | Profil keluarga disimpan privat pada backend dan dapat diakses pemilik lintas perangkat. Ini tidak mengubah keputusan bahwa progres/checklist pribadi dan kontak keluarga bersifat lokal. | `CONFIRMED_DIRECTION` | PRD-F-043; PRD-NF-005 | [PRD-Q024](TRACEABILITY.md#prd-q024) |
| PRD-DEC-025 | Arah pengisian otomatis memakai backend/DeepSeek dengan persetujuan pemindaian diterima. Antarmuka menonjolkan manfaat **isi otomatis**, tidak jargon AI/OCR; pemrosesan bertahap diperbolehkan. Informasi pemrosesan oleh layanan eksternal tetap perlu disampaikan dalam penjelasan privasi; naskah final belum disetujui. | `CONFIRMED_DIRECTION` dengan batas UX | PRD-F-039/040; PRD-NF-003/005 | [PRD-Q025](TRACEABILITY.md#prd-q025) |
| PRD-DEC-026 | Pengguna meninjau, membetulkan, lalu menerapkan hasil pengisian otomatis secara kelompok. Kebutuhan khusus tidak ditebak dari dokumen identitas; pengisian kategori tersebut tetap pilihan pengguna. | `CONFIRMED_DIRECTION` | PRD-F-041 | [PRD-Q026](TRACEABILITY.md#prd-q026) |
| PRD-DEC-027 | Bila ekstraksi gagal, pengguna dapat mencoba lagi atau mengisi manual. Backup dokumen masih dapat disimpan; kegagalan ekstraksi tidak otomatis menggagalkan fungsi penyimpanan dokumen. | `CONFIRMED_DIRECTION` | PRD-F-037/042; PRD-NF-006 | [PRD-Q027](TRACEABILITY.md#prd-q027) |
| PRD-DEC-028 | Kontak keluarga, barang tambahan dan progres lokal dipisahkan per akun. Pengguna akun lain tidak boleh melihatnya; perilaku logout/pergantian akun harus menjaga batas ini. | `CONFIRMED_DIRECTION` | PRD-F-050/057; PRD-NF-005 | [PRD-Q028](TRACEABILITY.md#prd-q028) |
| PRD-DEC-029 | Impor dokumen berikutnya ditinjau dahulu; pengguna memilih menambah atau memperbarui anggota. Tidak otomatis menghapus anggota lama. | `CONFIRMED_DIRECTION` | PRD-F-044 | [PRD-Q029](TRACEABILITY.md#prd-q029) |
| PRD-DEC-030 | Menghapus dokumen sumber tidak menghapus profil keluarga yang sudah disimpan. Kedua jenis data dikelola terpisah. Aturan khusus KTP untuk kelayakan mengirim mengikuti PRD-DEC-039. | `CONFIRMED_DIRECTION` | PRD-F-037/045 | [PRD-Q030](TRACEABILITY.md#prd-q030) |
| PRD-DEC-031 | Kontak umum dan teks panduan dasar dibundel agar bisa dibaca setelah instalasi baru tanpa unduhan pertama. Pembaruan konten admin diterima ketika online; rincian versi/cache belum dibekukan. | `CONFIRMED_DIRECTION` | PRD-F-052 | [PRD-Q031](TRACEABILITY.md#prd-q031) |
| PRD-DEC-032 | Suara offline hanya tersedia jika mesin suara dan bahasa pada perangkat mendukungnya. Bila tidak, teks tetap dapat dibaca dan keterbatasan dijelaskan; tidak menjanjikan suara universal. | `CONFIRMED_DIRECTION` | PRD-F-051 | [PRD-Q032](TRACEABILITY.md#prd-q032) |
| PRD-DEC-033 | Personalisasi mengambil barang dari katalog yang dikelola admin berdasarkan kategori usia/kebutuhan keluarga. Warga tetap dapat menambah barang sendiri; tidak diperlukan generator daftar bebas berbasis AI. | `CONFIRMED_DIRECTION` | PRD-F-046 | [PRD-Q033](TRACEABILITY.md#prd-q033) |
| PRD-DEC-034 | Login tetap wajib untuk fitur pribadi; pengguna menambahkan syarat KTP sebelum mengirim laporan dan mendelegasikan pilihan autentikasi yang sesuai demo. Pilihan kerja: email/password lokal serta kode pemulihan, tanpa kewajiban verifikasi email/Google saat ini. Pilihan ini diterima pada konsolidasi; baca informasi umum sebagai tamu tetap berlaku. | `DELEGATED_DEFAULT`, diterima dalam konsolidasi draf | PRD-F-002/003/011; PRD-NF-004 | [PRD-Q034](TRACEABILITY.md#prd-q034), [PRD-Q043](TRACEABILITY.md#prd-q043) |
| PRD-DEC-035 | Kode pemulihan privat diberikan saat registrasi untuk disimpan pemilik akun. Tidak memerlukan layanan email untuk jalur pemulihan yang disepakati; format, lifecycle dan perlindungannya masih FRD/SRS. | `CONFIRMED_DIRECTION` | PRD-F-005; PRD-NF-004 | [PRD-Q035](TRACEABILITY.md#prd-q035) |
| PRD-DEC-036 | Dua akun admin mempunyai kewenangan setara dan disiapkan tim. Tidak ada registrasi admin publik; akun admin tetap tidak boleh membaca isi vault privat warga. | `CONFIRMED_DIRECTION` | PRD-F-006 | [PRD-Q036](TRACEABILITY.md#prd-q036) |
| PRD-DEC-037 | KTP disiapkan sekali per akun sebelum pengiriman laporan pertama; bukan lampiran setiap laporan. Warga boleh membuat draf sebelum memenuhi syarat tersebut. | `CONFIRMED_DIRECTION` | PRD-F-011 | [PRD-Q037](TRACEABILITY.md#prd-q037) |
| PRD-DEC-038 | Sistem memeriksa bahwa dokumen berupa KTP dan cukup terbaca, lalu meminta konfirmasi pengguna. Ini bukan verifikasi resmi NIK, keaslian identitas, atau kecocokan dengan database kependudukan. Isi tetap tidak dapat dibaca admin. | `CONFIRMED_DIRECTION` | PRD-F-012 | [PRD-Q038](TRACEABILITY.md#prd-q038) |
| PRD-DEC-039 | Jika KTP dihapus, pengiriman laporan baru ditahan sampai tersedia KTP yang memenuhi syarat lagi. Riwayat laporan lama tidak dihapus oleh tindakan tersebut. | `CONFIRMED_DIRECTION` | PRD-F-013/037 | [PRD-Q039](TRACEABILITY.md#prd-q039) |
| PRD-DEC-040 | Admin dapat menerbitkan, mengoreksi dan menarik peringatan/pesan. Warga mempunyai penanda baca; perubahan dan status penarikan tetap terlihat/tersimpan. Masa berlaku dan detail status diturunkan pada FRD. | `CONFIRMED_DIRECTION` | PRD-F-054/055/056 | [PRD-Q040](TRACEABILITY.md#prd-q040) |
| PRD-DEC-041 | Hapus akun mandiri tidak wajib untuk demo dan ditunda sebagai fitur terpisah. Pengguna tetap dapat mengelola dokumen serta data keluarga; keputusan ini bukan pembatalan kemampuan menghapus objek tersebut. | `CONFIRMED_DIRECTION` | PRD-NF-010 | [PRD-Q041](TRACEABILITY.md#prd-q041) |
| PRD-DEC-042 | Paket terbaru berisi **enam KTP dan dua KK: delapan dokumen spesimen sintetis**. Ini menggantikan jumlah enam dokumen pada baseline tahap 1. Dua admin, enam warga dan dua belas laporan tetap; aset/seed belum dibuat. | `CONFIRMED_DIRECTION` | PRD-NF-009; delta BR-038 | [PRD-Q042](TRACEABILITY.md#prd-q042) |
| PRD-DEC-043 | Konsolidasi cakupan dan urutan disetujui sebagai **basis draf**: akun/KTP → laporan/AI/admin → Pantau/kontrol → seluruh pendukung → demo. Pembagian detail ke FRD/SRS diterima. Jawaban ini tidak menyetujui PRD final dan tidak mengizinkan tahap 3. | `CONFIRMED_DIRECTION` untuk draf; persetujuan final `APPROVAL_PENDING` | PRD-NF-008/009/010 | [PRD-Q043](TRACEABILITY.md#prd-q043) |

Keputusan tahap 1 yang tidak diubah tetap berlaku. Contohnya batas media dua foto atau satu video lima detik, publikasi Pantau otomatis, hapus laporan aktif beserta media dan audit minimal, kuota global per akun, Laragon/MySQL, TypeScript API/worker, tema biru, tanpa posko/sungai, serta pendukung wajib. Persetujuan BRD mengesahkan baseline tertulis, tetapi angka atau implementasi yang masih ditandai terbuka tidak otomatis menjadi final.

## 10. Delegasi, Asumsi dan Batas Penurunan PRD

| ID | Kategori | Pilihan/batas yang dicatat | Dasar dan status |
|---|---|---|---|
| PRD-ASM-001 | Delegasi produk | Status Developer Mode yang tidak dapat diketahui tidak memblokir kirim, tetapi dicatat sebagai keterbatasan; tidak dikonversi menjadi “mati”. | PRD-DEC-007/043; pilihan delegasi diterima untuk draf, kemampuan deteksi belum diuji. |
| PRD-ASM-002 | Delegasi autentikasi | Email/password lokal + kode pemulihan dipilih untuk demo. Verifikasi email dan Google ditunda, bukan dianggap sudah diimplementasikan. | PRD-DEC-034/035/043; tidak memerlukan langganan email tambahan. |
| PRD-ASM-003 | Delegasi field | Tidak menambah field wajib di luar media, keterangan dan titik lokasi. Catat waktu kirim/sumber lokasi sebagai metadata; waktu kejadian opsional. | PRD-DEC-018; bukan izin menambah data pribadi wajib tanpa alasan/konfirmasi. |
| PRD-ASM-004 | Delegasi tahap 1 yang diteruskan | Kelompok laporan sebagai unit Pantau sederhana dan dua belas laporan demo tetap digunakan. | DEC-016/038; tidak menetapkan radius/ambang atau lokasi administratif. |
| PRD-ASM-005 | Penajaman yang belum menjadi parameter final | Tiga frame sebagai pilihan awal dari arah tiga–empat frame, resize terukur dan pemakaian ulang hasil masih perlu validasi. Tidak ada angka ukuran, TTL, akurasi atau penghematan yang dikarang. | DEC-033; OPEN-005/015, tahap FRD/SRS. |
| PRD-ASM-006 | Penurunan kontrak data | Profil keluarga backend, dokumen backend, dan data checklist/kontak pribadi lokal memiliki lifecycle berbeda. Keputusan penyimpanan tidak otomatis menjamin enkripsi ujung ke ujung atau pemulihan seluruh data setelah perangkat hilang. | PRD-DEC-020/024/028/030; mekanisme keamanan/pemulihan masih SRS. |
| PRD-ASM-007 | Batas pengalaman pemindaian | Bahasa antarmuka mengutamakan “isi otomatis”; informasi layanan eksternal tetap tersedia dalam penjelasan persetujuan/privasi yang akan dirancang. Tidak ada naskah consent final yang sudah disetujui. | PRD-DEC-025; penjabaran konsolidasi draf, bukan kutipan jawaban baru. |
| PRD-ASM-008 | Batas bukti | Requirement dan acceptance criterion mendefinisikan hasil yang harus diuji nanti. Selesainya dokumentasi tidak berarti aplikasi, pemeriksaan KTP, ekstraksi keluarga atau APK demo sudah lulus. | DEC-039, PRD-DEC-008/038/043; tidak membuat klaim hasil uji. |

Tidak ditetapkan diam-diam: jumlah N/H, ukuran/resolusi/format file final, kategori usia/kebutuhan rinci, rumus kelompok/bahaya/prioritas, strategi key/enkripsi, versi dependency, endpoint/model AI, timeout/retry/retensi, atau metode pasti membaca status Android. Semua tetap mengikuti register OPEN dan tahapan berikutnya.

## 11. Konflik dan Perubahan Interpretasi Tahap 2

| ID | Potensi konflik/interpretasi | Penyelesaian yang dipakai | Dasar |
|---|---|---|---|
| PRD-CON-001 | “Wajib login” dianggap melarang semua akses tamu. | Login untuk fitur privat; Pantau, kontak umum dan panduan dapat dibaca tamu. | PRD-DEC-001/034 |
| PRD-CON-002 | Nilai Android nol/tidak tersedia dianggap bukti Developer Mode mati; atau manual dianggap bypass. | Bedakan status tidak diketahui dari mati. Kebijakan status tidak diketahui mengikuti delegasi; blok yang terdeteksi tetap berlaku saat titik manual. | PRD-DEC-004/006/007; PRD-RES-001 |
| PRD-CON-003 | Pengecualian build internal dianggap aturan APK demo atau izin memalsukan lokasi. | Pengecualian hanya blok Developer Mode pada build pengembangan internal; APK demo diuji terpisah dengan kebijakan sebenarnya. Tidak ada bypass mock location umum. | PRD-DEC-008 |
| PRD-CON-004 | AI tidak sesuai berarti laporan ditolak/palsu atau kelompok dilabeli rendah. | Laporan diterima dengan penanda; bukti itu belum menyumbang bahaya sebelum review. Tanpa bukti layak, kelompok Belum dinilai. | PRD-DEC-009/017 |
| PRD-CON-005 | Semua draf otomatis terkirim saat online atau laporan yang diterima masih bebas diedit warga. | Hanya laporan yang telah ditekan Kirim dapat dicoba ulang ketika aplikasi aktif+online; laporan diterima bersifat baca saja. | PRD-DEC-011/012 |
| PRD-CON-006 | Koreksi kelompok harus menyertakan fitur bulk merge/split; atau bukti baru mewarisi review lama. | Pindah laporan/kelompok baru cukup untuk scope demo. Bukti baru memerlukan review lagi; riwayat review tetap ada. | PRD-DEC-013/016 |
| PRD-CON-007 | Kejadian selesai otomatis dibuka lagi ketika laporan baru masuk. | Laporan baru membentuk kejadian aktif baru, tanpa membuka otomatis kejadian lama. | PRD-DEC-015 |
| PRD-CON-008 | Semua data keluarga/checklist harus sama-sama lokal atau semuanya tersinkron. | Profil keluarga privat ada di backend; checklist/barang tambahan/progres dan kontak keluarga lokal per akun. | PRD-DEC-020/021/024/028 |
| PRD-CON-009 | Pengelolaan konten oleh admin memberi akses vault; atau KTP harus dilihat admin untuk verifikasi. | Admin mengedit konten umum, tetap tidak membaca isi dokumen/profil keluarga. Pemeriksaan KTP dilakukan sistem dan dikonfirmasi pemilik, tanpa verifikasi NIK resmi. | PRD-DEC-021/024/036/038 |
| PRD-CON-010 | OCR otomatis langsung menjadi profil final; kategori kebutuhan khusus disimpulkan dari identitas; impor menghapus anggota lama. | Review/edit/apply oleh pengguna; kebutuhan khusus opsional dan tidak diinferensikan; impor berikutnya tambah/perbarui atas pilihan pengguna. | PRD-DEC-026/029 |
| PRD-CON-011 | Menghilangkan jargon AI/OCR berarti menyembunyikan pemrosesan pihak eksternal. | Istilah manfaat dipakai pada alur; penjelasan pemrosesan tetap dibutuhkan dalam persetujuan/privasi. Naskah belum final. | PRD-DEC-025 |
| PRD-CON-012 | Hapus dokumen otomatis menghapus keluarga/riwayat, atau KTP harus dilampirkan berulang. | Profil keluarga bertahan setelah sumber dihapus. KTP sekali per akun; penghapusan KTP menahan kiriman baru tanpa menghapus laporan lama. | PRD-DEC-030/037/039 |
| PRD-CON-013 | Suara offline dan pengiriman saat aplikasi ditutup dianggap dijamin pada semua perangkat. | Suara bergantung dukungan mesin/bahasa; teks tetap tersedia. Retry otomatis dibatasi aplikasi aktif+online. | PRD-DEC-012/031/032 |
| PRD-CON-014 | Enam dokumen tahap 1 tetap menjadi jumlah terkini atau diubah tanpa riwayat. | Baseline historis tetap mencatat enam; paket PRD terbaru delapan spesimen, yaitu enam KTP dan dua KK. | DEC-038, PRD-DEC-042 |
| PRD-CON-015 | Konsolidasi atau otorisasi penyusunan dianggap persetujuan final PRD dan izin FRD. | Pada tahap draf, PRD-IMPLEMENT belum mencakup persetujuan final. Persetujuan kemudian diberikan melalui PRD-APPROVAL-01. | BRD-APPROVAL, PRD-DEC-043, PRD-IMPLEMENT |

## 12. Bukti Kajian dan Ketergantungan Tahap 2

Sumber berikut dibaca dalam perencanaan PRD pada sesi ini. Pencatatan ini tidak menjalankan ulang riset, menggunakan kredit API, atau menguji perangkat. RES-001–010 tetap menjadi bukti kelayakan awal dengan keterbatasannya, bukan bukti produk sudah berjalan.

| ID | Sumber/temuan | Implikasi dan batas |
|---|---|---|
| PRD-RES-001 | [Android `DEVELOPMENT_SETTINGS_ENABLED`](https://developer.android.com/reference/android/provider/Settings.Global#DEVELOPMENT_SETTINGS_ENABLED) yang dibaca menyatakan nilainya mengembalikan nol untuk aplikasi pihak ketiga. | Nilai nol dari jalur itu tidak cukup untuk menyatakan Developer Mode mati. SRS perlu membedakan kemampuan pemeriksaan/status tidak diketahui. Tidak menyimpulkan perilaku semua versi Android historis atau semua produsen. |
| PRD-RES-002 | [Android `Location.isMock()`](https://developer.android.com/reference/android/location/Location#isMock()) mendeskripsikan penanda lokasi mock/test provider. | Menjadi kandidat sinyal sesuai kebijakan pengguna, bukan jaminan mendeteksi seluruh pemalsuan lokasi atau membuktikan kehadiran pelapor. Belum diuji pada perangkat tim. |
| PRD-RES-003 | [Android Developer options](https://developer.android.com/studio/debug/dev-options) membahas opsi untuk debugging/pengembangan. | Menjelaskan kebutuhan memisahkan build internal dari APK demo. Mekanisme build flag dan pembuktian bahwa pengecualian tidak ikut demo masih perlu SRS/uji. |
| PRD-RES-004 | [OWASP Forgot Password Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Forgot_Password_Cheat_Sheet.html) dan [Multifactor Authentication Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Multifactor_Authentication_Cheat_Sheet.html) ditinjau sebagai acuan pemulihan, termasuk metode/kode pemulihan. | Membantu menilai alternatif tanpa layanan email; bukan sertifikasi keamanan rancangan ini. Format, penyimpanan, penggunaan ulang/rotasi, percobaan gagal dan lifecycle kode tetap FRD/SRS. Tidak menambahkan kewajiban MFA yang belum dipilih. |

Ketergantungan yang belum terbukti mencakup kemampuan DeepSeek pada spesimen KTP/KK, kontrak hasil ekstraksi, deteksi status Android nyata, mesin suara/bahasa, penyimpanan lokal lintas akun, serta API/worker dan perangkat demo. Ketersediaan kredit tidak menetapkan kemampuan model, batas data, atau keberhasilan pemindaian. Dokumen privat yang diproses backend/provider memerlukan rancangan batas akses dan penanganan data; “admin tidak boleh membaca” adalah ketentuan produk yang harus dibuktikan, bukan klaim bahwa arsitektur keamanan sudah selesai.

## 13. Risiko Tambahan Tahap 2

Risiko tahap 1 tetap berlaku. Berikut penambahan akibat keputusan produk PRD; penanganan adalah rencana kerja, bukan kontrol yang telah terimplementasi. Pemilik backend/AI adalah pemilik proyek; tim Flutter terdiri dari dua rekan sesuai DEC-003.

| ID | Risiko/dampak | Penanganan yang direncanakan dan pemilik | Status/ketergantungan |
|---|---|---|---|
| PRD-RISK-001 | Status Android tidak dapat dibaca atau sinyal mock tidak mencakup semua manipulasi; aplikasi memberi kesan lokasi terjamin. | Bedakan unknown, jelaskan titik manual/sinyal terbatas, uji perangkat/APK demo. Backend dan tim Flutter. | Terbuka; PRD-OPEN-001, PRD-RES-001/002 |
| PRD-RISK-002 | Pengecualian pengembangan terbawa ke APK demo atau aturan hanya diterapkan di satu jalur kirim. | Pisahkan konfigurasi build, uji GPS/manual/retry dan cek artefak demo. Tim Flutter dan maintainer. | Terbuka; PRD-OPEN-001/002 |
| PRD-RISK-003 | Pemeriksaan KTP dianggap verifikasi resmi; hasil tidak terbaca atau dokumen sintetis memberi keyakinan palsu tentang identitas. | Gunakan bahasa cek jenis/keterbacaan dan konfirmasi pemilik, uji kasus gagal, pisahkan spesimen dari dokumen asli. Backend/AI dan Flutter. | Terbuka; PRD-OPEN-003/004/012 |
| PRD-RISK-004 | Ekstraksi keliru menambah/mengubah anggota salah atau menginferensikan kebutuhan sensitif. | Wajib review/edit/apply, kategori kebutuhan dipilih pengguna, impor tambah/perbarui eksplisit. Backend/AI dan Flutter. | Perilaku disepakati; pembuktian PRD-OPEN-004/005 |
| PRD-RISK-005 | Isi dokumen/profil keluarga bocor melalui API, cache, log, hasil pemindaian atau akses admin. | Tegakkan kepemilikan, batasi hasil/log, uji warga lain/admin, rancang consent dan keamanan storage/provider. Backend dan Flutter. | Terbuka; OPEN-004/011, PRD-OPEN-004/006 |
| PRD-RISK-006 | Pengguna menyangka checklist/kontak lokal dapat dipulihkan lintas perangkat seperti profil keluarga backend, atau data akun lama terlihat setelah berganti akun. | Nyatakan batas penyimpanan pada pengalaman terkait, isolasi per akun, uji logout/pergantian akun/perangkat. Flutter dan backend. | Terbuka; PRD-OPEN-006/007 |
| PRD-RISK-007 | Kode pemulihan hilang, tersalin pihak lain atau bisa ditebak; jalur pemulihan menjadi celah akun. | Rancang lifecycle, penyimpanan dan kontrol percobaan; instruksi penyimpanan kode untuk pemilik. Backend dan Flutter. | Terbuka; PRD-OPEN-006; tidak menjanjikan pemulihan tanpa kode |
| PRD-RISK-008 | Kondisi KTP/kuota/galeri/perangkat berubah selama offline sehingga retry melanggar aturan atau menghasilkan duplikasi. | Tetapkan evaluasi pada saat kirim/terima, status penolakan yang dapat dipahami dan idempotensi. Backend dan integrasi Flutter. | Terbuka; OPEN-002/003/009, PRD-OPEN-002/003 |
| PRD-RISK-009 | Bukti baru, koreksi kelompok, status selesai atau pesan ditarik belum tercermin pada cache/penanda review/baca. | Definisikan transisi/versi, pertahankan jejak yang disepakati, uji pembaruan dan reconnect. Backend dan Flutter. | Terbuka; OPEN-006/007/013, PRD-OPEN-008/010 |
| PRD-RISK-010 | Tambahan KTP/pengisian keluarga memperluas beban tiga anggota dan pemakaian AI; dokumentasi dianggap bukti implementasi. | Milestone fitur dan acceptance per alur, catat penggunaan provider, pisahkan hasil fixture/API/perangkat/UAT. Seluruh tim. | Dikelola; PRD-DEC-043, PRD-OPEN-011/012 |

## 14. Detail PRD yang Diteruskan ke FRD/SRS

ID `PRD-OPEN-xxx` adalah agenda detail lanjutan, **bukan nomor pertanyaan yang sudah dijawab**. Daftar 12 ID di sini menjadi acuan PRD §14; ini merinci OPEN tahap 1 tanpa membuka ulang keputusan produk. Izin tahap 3 berasal dari PRD-APPROVAL-01, bukan dari keberadaan daftar OPEN. Nilai/aturan yang belum diputuskan tetap terbuka setelah PRD disetujui.

| ID | Detail tersisa, dengan batas yang telah tetap | Tahap/pemilik | Rujukan |
|---|---|---|---|
| PRD-OPEN-001 | Definisi status pemeriksaan perangkat, jalur API/plugin sesuai versi, pesan blok/unknown, matriks perangkat dan pemisahan build. Tetap: unknown diizinkan sesuai delegasi; deteksi aktif/mock memblokir kirim; manual bukan bypass. | FRD perilaku → SRS/PoC; Flutter + backend | PRD-DEC-003–008; OPEN-015 |
| PRD-OPEN-002 | Tersisa: kontrak rekonsiliasi/revisi lama/batal, boundary tepat H, rentang N/H, reset bersamaan, format/ukuran media, validasi deskripsi/lokasi/waktu dan retry. Diputuskan di FRD v0.1.1: awal 3 penerimaan unik per akun/6 jam rolling; gagal/retry sama tidak menambah, hapus tidak refund; ubah aturan tanpa reset; isi Kirim dengan hasil belum diketahui dikunci sampai rekonsiliasi, diterima membuka laporan sama dan penolakan definitif membolehkan koreksi; galeri OFF sebelum diterima menahan draf lama dan meminta kamera tanpa menghapus draf. Tetap: hanya setelah Kirim, aktif+online, retry manual, diterima baca saja. | FRD → SRS; backend + integrasi Flutter | PRD-DEC-011/012; OPEN-002/003/009 |
| PRD-OPEN-003 | Tersisa: format/ukuran, consent/provider, hasil/konfirmasi usang, kualitas pembacaan dan nasib berkas lama setelah ganti. Diputuskan di FRD v0.1.1: jenis KTP dikenali dan nama terbaca + konfirmasi, NIK tidak wajib terbaca; KTP lama berlaku sampai pengganti lolos/dikonfirmasi; hapus KTP aktif menahan kirim. Tetap: sekali per akun sebelum kirim, draf boleh, bukan verifikasi NIK resmi. | FRD → SRS; backend/AI + Flutter | PRD-DEC-037–039; OPEN-011 |
| PRD-OPEN-004 | Format/ukuran dokumen dan tahap pemrosesan, model/endpoint, kontrak ekstraksi, kualitas/ambang hasil, timeout/retry/cache, data yang dikirim ke provider, naskah persetujuan per tujuan dan retensi hasil sementara. Tetap: review pengguna, fallback manual/ulang, backup independen, admin tidak membaca isi. | FRD → SRS/PoC; backend/AI + pemilik produk | PRD-DEC-022/025–027; OPEN-004/005/011 |
| PRD-OPEN-005 | Daftar kelompok usia/kebutuhan, validasi nickname/anggota, review hasil, pemetaan sumber-ke-profil, pilihan tambah/perbarui, perubahan profil terhadap saran katalog dan progres lama. Tetap: kebutuhan khusus opsional/tidak diinferensikan, tidak hapus anggota otomatis, profil bertahan setelah sumber dihapus. | FRD → SRS; pemilik produk + backend/Flutter | PRD-DEC-023/026/029/030/033; OPEN-012 |
| PRD-OPEN-006 | Tersisa: field/validasi akun, format/percobaan kode, autentikasi ulang, provisioning admin, lifetime sesi, logout server offline, storage/enkripsi dan retensi. Diputuskan di FRD v0.1.1: kehilangan sandi+kode tanpa recovery; kode sah sekali pakai, reset mencabut sesi lama/memberi pengganti; respons hilang dapat login dengan sandi baru untuk membuat pengganti; logout mempertahankan draf/checklist/kontak, menghentikan antrean lokal, membersihkan sesi/cache pratinjau; server boleh menyelesaikan tugas diterima. Tetap: auth lokal, dua admin setara, tanpa Google/email verification wajib. | FRD → SRS; backend + Flutter | PRD-DEC-002/028/034–036; OPEN-008/011 |
| PRD-OPEN-007 | Tersisa: perlindungan storage, logout offline/rekonsiliasi, paket konten awal, revisi katalog/panduan/kontak dan uji bahasa TTS. Diputuskan di FRD v0.1.1: draf/checklist/item/progres/kontak lokal tetap bagi akun asal saat login kembali; cache pratinjau dokumen/sesi dibersihkan dan antrean lokal berhenti selama logout. Tetap: data pribadi lokal tidak tersinkron; profil keluarga backend; teks dasar tersedia instalasi baru; suara bergantung perangkat. | FRD → SRS; Flutter + backend konten | PRD-DEC-019–021/024/028/031–033; OPEN-009/012 |
| PRD-OPEN-008 | Perhitungan prioritas/bahaya dan kelompok termasuk jarak/waktu, kontrak keluaran analisis media, review bukti tidak sesuai, mekanisme konflik dua admin, bukti baru, label lokasi, pengurutan dan refresh. Diputuskan FRD-DEC-018: perubahan pertama yang sah berlaku, perubahan admin dari versi usang ditolak dan wajib muat ulang. Tetap: bukan status resmi, Belum dinilai terpisah, badge tidak menutupi bukti baru, kejadian selesai tidak dibuka otomatis. | FRD → SRS; backend/AI + pemilik produk | PRD-DEC-009/013/015–017; OPEN-005/006/007 |
| PRD-OPEN-009 | Konfirmasi hapus objek, ruang simpan, turunan/cache/audit, backup/retensi, hasil worker terlambat, hapus dokumen saat diproses dan rekonsiliasi. Tetap: laporan aktif/media hapus permanen; dokumen berbeda dari profil keluarga; hapus KTP menahan kirim baru tanpa menghapus riwayat; hapus akun mandiri ditunda. | FRD → SRS; backend + Flutter | PRD-DEC-030/039/041; OPEN-010/011 |
| PRD-OPEN-010 | Tersisa: validasi pesan, perubahan metadata/tanggal akhir, konflik publikasi/edit, cache versi dan retensi catatan admin. Diputuskan di FRD v0.1.1: akun baru memperoleh semua pesan aktif; revisi judul/isi kembali belum dibaca, read versi lama offline tidak meluluskan versi baru; tanggal akhir opsional, tanpa akhir aktif sampai dicabut; berakhir/cabut keluar inbox warga, catatan tetap bagi admin. Tetap: seluruh warga, bukan chat/target domisili/alert AI otomatis/push wajib. | FRD → SRS; backend + Flutter admin/warga | PRD-DEC-040; OPEN-013 |
| PRD-OPEN-011 | Framework/dependency, resource, skema/API/jobs, proteksi akses, observabilitas, runtime tim, repo/CI, format/resize dan jumlah frame tepat, batas laju/biaya, ukuran performa serta Docker/local demo yang dapat direproduksi. Tetap: Flutter Android/Web, Laragon/MySQL, TS API + TS worker satu codebase, DeepSeek dan tanpa langganan berbayar tambahan wajib. | SRS → setup 5; maintainer/backend | OPEN-015; PRD-NF-001/002/003/004/008 |
| PRD-OPEN-012 | Manifest dua admin/enam warga/dua belas laporan/delapan spesimen, sumber/lisensi media, pemeriksaan nomor kontak dan isi panduan, keterbacaan/TTS, rubrik dan skenario uji, build demo, data pembanding, bukti provider nyata/akurasi/kegagalan dan UAT. Tetap: enam KTP + dua KK sintetis, tanpa target angka performa/akurasi yang belum disepakati. | FRD/SRS → implementasi/UAT; seluruh tim | PRD-DEC-008/042/043; OPEN-014/016; PRD-NF-009 |

## 15. Change Log Tahap 2

Urutan ini mengikuti interview dan konsolidasi pada 18 Oktober 2026. Uraian jawaban dan persetujuan merupakan parafrasa; identitas persetujuan tetap dirujuk pada register ini.

| ID | Pemicu | Perubahan dan dampak |
|---|---|---|
| PRD-CHG-001 | BRD-APPROVAL; PRD-Q001/002 | Memulai tahap 2 setelah BRD disetujui; menetapkan batas akses tamu dan login email/password untuk fitur privat. OPEN-001 ditutup, persetujuan PRD terpisah. |
| PRD-CHG-002 | PRD-Q003–008; kajian Android | Memperjelas GPS/manual, sinyal mock/Developer Mode, blok hanya pada kirim, unknown dalam delegasi, serta pengecualian build internal terbatas. Tidak mengklaim kemampuan deteksi perangkat sudah terbukti. |
| PRD-CHG-003 | PRD-Q009–018 | Menetapkan penanganan bukti tidak sesuai, akses pemilik, laporan diterima baca saja, retry aktif setelah Kirim, koreksi kelompok, catatan tindak lanjut, kejadian baru, review ulang, tingkat Pantau dan field laporan. |
| PRD-CHG-004 | PRD-Q019–030 | Merinci personalisasi katalog, data lokal per akun, editor konten umum, OCR/AI pengisian keluarga, profil backend privat, persetujuan/review/fallback, impor atas pilihan pengguna dan lifecycle dokumen/profil terpisah. Menambah pekerjaan AI untuk dokumen dari scope awal pemeriksaan laporan. |
| PRD-CHG-005 | PRD-Q031–033 | Menetapkan konten dasar dibundel sejak instalasi, suara sesuai dukungan perangkat dan personalisasi berbasis katalog admin tanpa generator daftar bebas AI. |
| PRD-CHG-006 | PRD-Q034–039 | Memilih jalur autentikasi demo melalui delegasi, kode pemulihan, dua admin setara; menambahkan KTP sekali per akun sebelum kirim, pemeriksaan jenis/keterbacaan + konfirmasi tanpa NIK resmi, serta penahanan kirim baru setelah KTP dihapus. |
| PRD-CHG-007 | PRD-Q040/041 | Merinci publikasi/koreksi/penarikan pesan dan penanda baca; menunda hapus akun mandiri tanpa membatalkan pengelolaan dokumen/data keluarga. |
| PRD-CHG-008 | PRD-Q042 | **Mengubah enam dokumen spesimen tahap 1 menjadi delapan pada tahap 2: enam KTP + dua KK.** Jumlah dua admin, enam warga dan dua belas laporan tetap. Riwayat DEC-038/CHG-009 dipertahankan. Tidak membuat aset/seed. |
| PRD-CHG-009 | PRD-Q043; PRD-IMPLEMENT | Pengguna menerima konsolidasi sebagai basis draf dan menginstruksikan penulisan dokumen. Menyusun PRD `v0.1.0` beserta log/traceability, memperbarui OPEN dan mencatat delta BRD. Belum ada final approval PRD atau izin FRD. |

## 16. Status Persetujuan dan Batas Hasil Tahap 2

| Gerbang/bukti | Keadaan saat register diperbarui |
|---|---|
| Baseline BRD `v0.1.0` | **APPROVED** melalui BRD-APPROVAL pada register ini; tidak meminta persetujuan yang sama ulang. |
| Interview produk PRD | 43 jawaban tercatat pada PRD-DEC-001–043 dan register PRD-Q di TRACEABILITY; delegasi/koreksi dibedakan. |
| Konsolidasi untuk draf | Diterima melalui PRD-Q043; bukan persetujuan final dokumen. |
| Penulisan dokumen tahap 2 | PRD-IMPLEMENT mengotorisasi dokumentasi dan pemeriksaan konsistensi dokumen. |
| PRD `v0.1.0` | **APPROVED — PRD-APPROVAL-01**; rincian FRD/SRS dipertahankan dalam agenda terbuka. |
| Bukti implementasi produk | Belum ada: tidak membuat aplikasi, database/seed, Git, workspace setup atau deploy dalam tahap ini. Tidak ada pengujian API DeepSeek, OCR/KTP, Android, queue atau UAT produk yang diklaim lulus. |
| Riset/PoC yang pernah dilakukan | Terbatas pada RES dan PRD-RES dengan keterbatasan eksplisit; tidak dapat dipakai sebagai hasil acceptance produk. |
| Tahap 3 FRD | **BERJALAN — DRAFT v0.1.2**, sesuai rencana yang disetujui; keputusan parsial pada putaran aktif, belum final seluruh isi FRD. |
| Tahap 4 SRS, tahap 5 setup | Belum dimulai; urutan sesudah penyelesaian rincian FRD tetap berlaku. |

Serah hasil tahap 2 mempertahankan delta delapan spesimen, batas kemampuan perangkat/AI serta rincian FRD/SRS. Persetujuan PRD berasal dari pesan pengguna setelah rencana penutupan dapat direview, bukan dari checklist internal. Baris change log terdahulu menggambarkan status pada saat kejadian; penutupan terbaru dicatat terpisah di bawah.

## 17. Penutupan PRD dan pembukaan FRD — 18 Oktober 2026

<a id="prd-approval-01"></a>

### PRD-APPROVAL-01 — Persetujuan PRD v0.1.0

- **Pemilik keputusan:** pengguna/pemilik proyek.
- **Otorisasi awal:** pemilik proyek meminta PRD dituntaskan dan proses dilanjutkan ke FRD dengan mengacu pedoman penyusunan yang tersedia.
- **Objek yang kemudian ditampilkan:** rencana menuntaskan PRD v0.1.0 tanpa perubahan scope, menyelaraskan 12 agenda, mencatat approval, memeriksa dokumen, lalu membuat FRD v0.1.0 DRAFT dengan TBD eksplisit.
- **Persetujuan pelaksanaan:** pemilik menerima rencana penutupan PRD v0.1.0 dan kelanjutan penyusunan FRD.
- **Keputusan:** PRD v0.1.0 **APPROVED**; finalisasi editorial dan draf FRD diotorisasi. Versi PRD tetap karena requirement dan AC tidak berubah. Penutupan dicatat sebagai revisi administrasi pada versi yang sama.
- **Batas:** bukan pengisian nilai N/H, formula bahaya, kebijakan retensi, atau detail lain yang belum dijawab; bukan sign-off FRD yang belum pernah disajikan. Pengujian produk tetap NOT_RUN.
- **Asal otorisasi:** konfirmasi pemilik setelah ekspor percakapan kedua. Catatan ini tidak menambahkan jawaban PRD-Q044 atau konfirmasi individual R1/R2.

<a id="prd-open-normalization"></a>

### PRD-CHG-010 — Normalisasi agenda dan audit

Nomor pada PRD §14 draf awal berbeda arti dengan PRD-OPEN di register ini. Pertahankan 12 ID register sebagai acuan karena risiko dan dependensi sudah merujuknya; perluas uraian untuk membawa semua rincian lama. Tabel berikut adalah migrasi **nomor baris PRD lama**, bukan pengubahan makna ID register.

| Nomor baris PRD lama | Tujuan sekarang | Rincian yang dipertahankan |
|---|---|---|
| 001 | PRD-OPEN-002 | N/H, jendela, penghitungan kuota, retry/reset dan galeri/draf |
| 002 | PRD-OPEN-003, PRD-OPEN-004 | Pemeriksaan KTP, gagal/ulang dan persetujuan/provider |
| 003 | PRD-OPEN-001 | Perangkat, sinyal, unknown dan build |
| 004 | PRD-OPEN-008 | Kelompok, jarak/waktu, prioritas, tingkat dan koreksi |
| 005 | PRD-OPEN-002–006, PRD-OPEN-009 | Validasi media/dokumen/lokasi/profil, ruang simpan dan hapus |
| 006 | PRD-OPEN-004, PRD-OPEN-008, PRD-OPEN-011, PRD-OPEN-012 | Kontrak AI, frame, kualitas, rate/biaya dan bukti provider |
| 007 | PRD-OPEN-005, PRD-OPEN-007 | Kategori keluarga, merge dan katalog |
| 008 | PRD-OPEN-003, PRD-OPEN-004, PRD-OPEN-006, PRD-OPEN-009 | Privasi/consent per tujuan, transfer dan retensi |
| 009 | PRD-OPEN-002, PRD-OPEN-006, PRD-OPEN-007 | Rahasia, kode, sesi, cache dan retry lintas akun |
| 010 | PRD-OPEN-008, PRD-OPEN-009 | Backup/audit, konflik admin dan worker terlambat |
| 011 | PRD-OPEN-010 | Pesan, akun baru, masa berlaku dan status baca |
| 012 | PRD-OPEN-007, PRD-OPEN-011, PRD-OPEN-012 | Konten, TTS, keterbacaan dan performa |
| 013 | PRD-OPEN-011 | Framework, API/schema, jobs, repo/CI dan Docker |
| 014 | PRD-APPROVAL-01 — CLOSED | Gerbang persetujuan PRD sudah dipenuhi |

Perbaikan lain: `PRD-CL-001–085` dinormalisasi menjadi namespace yang sudah ada, `PRD-CL001–PRD-CL085`; audit lama ditandai snapshot historis, bukan dihapus. Tidak ada fitur baru pada penutupan ini.

### FRD-DEC-001 — Dasar draf dan delegasi editorial

| Aspek | Catatan |
|---|---|
| Opsi/keputusan | Lanjut dari baseline PRD approved; tidak mengulang seluruh interview yang sudah mempunyai bukti |
| Dasar | PRD-APPROVAL-01 dan rencana yang disetujui |
| Owner | Pemilik proyek; asisten menyusun dan memeriksa dokumentasi |
| R1/R2 | Bukti historis dirujuk apa adanya; tidak mengarang putaran konfirmasi FRD baru |
| Dampak | FRD berstatus DRAFT, menguraikan perilaku yang bersumber; keputusan baru tetap diberi status |
| Status | CONFIRMED_DIRECTION untuk kelanjutan; pilihan struktur/ID adalah DELEGATED_DEFAULT editorial |

### FRD-DEC-002 — Model perilaku dan rekomendasi belum final

Status produk, kamus data konseptual, pengelompokan use case dan skenario uji pada FRD adalah elaborasi draf. Nama status bukan enum API; field panjang, model AI, formula, timeout dan retensi yang belum disepakati tidak diisi angka rekaan. Rekomendasi discovery diberi **PROPOSED / NOT_ASKED**; rincian yang telah dialokasikan ke SRS diberi **DEFERRED_DETAIL**. Semua pertanyaan berikut mempunyai owner dan dampak di [FRD §27](FRD.md#frd-open).

### FRD-CHG-001 — Draf awal tahap 3

Membuat FRD v0.1.0 dari 57 F dan 10 NF PRD; memisahkan perilaku yang dapat diuji, menambahkan use case, aturan, kamus data, transisi, izin, skenario uji, dan RTM ke register bersama. Tidak mengubah sumber asli atau kebutuhan baseline BRD dan tidak menambah scope aplikasi. Metadata serah tahap BRD diselaraskan dengan status terbaru tanpa mengubah riwayat persetujuan. **Status:** DRAFT; pemeriksaan dokumen bukan pengujian produk atau pengesahan detail baru.

<a id="frd-round-1"></a>

## 18. Discovery FRD putaran 1 — 18 Oktober 2026

### FRD-DEC-003 — Melanjutkan discovery dari draf yang tersedia

**Dasar otorisasi:** pemilik meminta penyusunan FRD dilanjutkan dari draf dan keputusan yang telah tersedia.

**Keputusan:** melanjutkan analisis, riset dan penyusunan FRD dari progres tersimpan. Tidak meminta ulang approval PRD atau jawaban yang sudah diterima. Ini otorisasi pekerjaan, bukan jawaban atas seluruh detail yang belum ditanyakan. Status **CONFIRMED_DIRECTION**. FRD v0.1.1 tetap DRAFT.

### 18.1 Keputusan produk yang mempunyai jawaban

Seluruh jawaban di bawah berasal dari pemilik proyek pada pesan aktif setelah kedua ekspor, tanggal 18 Oktober 2026. Ringkasan pilihan tersimpan pada [register keterlacakan](TRACEABILITY.md#frd-qa-round-1). Suffix A/B/C adalah subpertanyaan dalam agenda, bukan agenda baru. Status konfirmasi hanya berlaku pada cakupan yang dinyatakan; bukan approval keseluruhan FRD atau bukti test PASS.

| Keputusan / agenda | Interpretasi berlaku | Bukti konfirmasi / batas | Dampak |
|---|---|---|---|
| <a id="frd-dec-004"></a>FRD-DEC-004 / Q001-A | N awal 3, H awal 6 jam berjalan; pemakaian per akun untuk laporan unik yang diterima. Gagal sebelum diterima/retry sama tidak menambah hitungan. | CONFIRMED_R1; batas penghapusan diuji pada DEC-007; boundary waktu/config/reset masih terbuka. | CONTROL-002/003; REPORT-010; TC-X-001 |
| <a id="frd-dec-005"></a>FRD-DEC-005 / Q006-A | Kehilangan keduanya tidak dapat dipulihkan melalui aplikasi/admin; akun baru tidak mewarisi data akun lama. | CONFIRMED_R1 untuk kehilangan; pemulihan sah diperinci DEC-013, bukan pengecualian kehilangan keduanya. | AUTH-006 |
| <a id="frd-dec-006"></a>FRD-DEC-006 / Q007-A | Draf/checklist/item/progres/kontak lokal dipertahankan per identitas akun untuk login ulang akun yang sama; tidak terbuka bagi akun lain/tamu. | CONFIRMED_R1; batas cache/tugas diperdalam pada DEC-014. | AUTH-008; REPORT-007/008; READY-002/004/005; TC-X-003 |
| <a id="frd-dec-007"></a>FRD-DEC-007 / Q001-B | Penghapusan tidak refund pemakaian. Keluar jendela atau reset adalah alasan berbeda untuk bebas kuota. | CONFIRMED_R2 hanya untuk batas penghapusan dari DEC-004; tidak menutup seluruh Q001. | CONTROL-002/003/004; TC-X-001 |
| <a id="frd-dec-008"></a>FRD-DEC-008 / Q002-A | Aturan galeri saat penerimaan baru berlaku terhadap draf lama; OFF menahan pengiriman, meminta media kamera dan mempertahankan draf. | CONFIRMED_R1; kasus tandingan baseline galeri; rekonsiliasi penerimaan lama belum ditutup. | CONTROL-001; REPORT-008/009; TC-X-002 |
| <a id="frd-dec-009"></a>FRD-DEC-009 / Q012-A | Akun baru memperoleh semua pesan aktif, termasuk yang mendahului pendaftaran; dicabut/berakhir bukan aktif. | CONFIRMED_R1 untuk audience; read/expiry diperinci DEC-012/015. | INBOX-001 |
| <a id="frd-dec-010"></a>FRD-DEC-010 / Q003-A | Minimum: dikenali sebagai KTP, nama pemilik terbaca dan pemilik mengonfirmasi. NIK tidak wajib terbaca; bukan verifikasi resmi, admin tidak membaca isi. | CONFIRMED_R1 untuk minimum; bukti kualitas aktual tetap NOT_RUN. | KTP-002/003; Q014/017 |
| <a id="frd-dec-011"></a>FRD-DEC-011 / Q003-B | KTP lama tetap menjadi dasar kelayakan selama penggantian; pengganti efektif sesudah lolos dan dikonfirmasi. Hapus KTP aktif segera menahan kirim baru. | CONFIRMED_R1 untuk penggantian; boundary kelayakan/hapus diperiksa, tidak membuktikan kualitas provider. | KTP-002/003/004; TC-X-002 |
| <a id="frd-dec-012"></a>FRD-DEC-012 / Q012-B | Edit judul/isi menandai diperbarui dan belum dibaca pada tiap akun. Read versi lama offline tidak meluluskan versi baru. | CONFIRMED_R1 dengan boundary offline eksplisit; bukan konfirmasi retensi atau semua konflik edit. | INBOX-002/004; TC-X-009 |
| <a id="frd-dec-013"></a>FRD-DEC-013 / Q006-B | Pemulihan sah mengganti sandi, menghabiskan kode, mencabut sesi lama dan menyediakan kode pengganti. Setelah sukses dengan respons hilang, login memakai sandi baru menyediakan jalan membuat kode pengganti. | CONFIRMED_R1 dengan boundary respons hilang; format/percobaan/autentikasi ulang SRS/Q005/017 belum dipilih. | AUTH-005/006; sesi Q005 |
| <a id="frd-dec-014"></a>FRD-DEC-014 / Q007-B | Logout menghentikan antrean lokal sampai akun asal login lagi, membersihkan sesi lokal/cache pratinjau dokumen, mempertahankan data lokal yang dipilih; server boleh menyelesaikan tugas yang sudah diterima untuk akun asal. | CONFIRMED_R2 untuk batas data/tugas dari DEC-006; pencabutan server saat offline tetap detail terbuka. | AUTH-008; REPORT-008; READY-005; TC-X-003 |
| <a id="frd-dec-015"></a>FRD-DEC-015 / Q012-C | Tanggal akhir opsional; tanpa tanggal akhir aktif sampai dicabut. Berakhir/dicabut keluar inbox warga setelah keadaan tersinkron; admin tetap dapat melihat catatannya. | CONFIRMED_R1 untuk expiry; CONFIRMED_R2 batas berakhir/cabut pada audience DEC-009; masa simpan catatan belum dipilih. | INBOX-001/003; TC-X-009 |
| <a id="frd-dec-016"></a>FRD-DEC-016 / Q001-C | Perubahan aturan berlaku untuk penerimaan baru tanpa reset otomatis atau membatalkan laporan lama. Jika pemakaian sudah mencapai/melebihi batas baru, kiriman baru tertahan sampai cukup kuota atau reset terpisah. | CONFIRMED_R2 untuk perubahan aturan dari DEC-004; boundary waktu, rentang dan operasi bersamaan tetap terbuka. | CONTROL-002/003; TC-CONTROL-002-01/02; TC-X-001 |
| <a id="frd-dec-017"></a>FRD-DEC-017 / Q002-B | Selama hasil Kirim belum diketahui, isi permintaan dikunci untuk rekonsiliasi. Sudah diterima menampilkan laporan yang sama; penolakan definitif sebelum diterima mengizinkan perbaikan draf. | CONFIRMED_R1 untuk edit/rekonsiliasi dengan boundary respons hilang; penutupan revisi lama, pembatalan dan timeout tetap detail terbuka. | REPORT-007/008/009/010; CONTROL-001; TC-X-001/002 |
| <a id="frd-dec-018"></a>FRD-DEC-018 / Q020-A | Untuk perubahan bersaing atas versi objek yang sama, perubahan pertama yang sah tersimpan berlaku; perubahan dari versi usang ditolak dan admin harus memuat ulang sebelum mengubah lagi. | CONFIRMED_R1 untuk konflik dua admin; bukan penetapan semua race job/review/delete/keluarga atau pilihan mekanisme SRS. | REVIEW; CONTROL; CONTENT; INBOX; Q020 |
| <a id="frd-dec-019"></a>FRD-DEC-019 / Q004-A | Inventaris perangkat/browser uji dicatat sebagai kebutuhan yang belum tersedia. Tidak menetapkan model HP, versi Android, browser atau kelulusan pengujian tanpa bukti. | CONFIRMED_R1 untuk status ketersediaan bukti; bukan konfirmasi dukungan perangkat atau penutupan Q004. | Q004/Q019; REPORT-004–006; READY-008; TC-NF-001/007/009 |

### FRD-CHG-002 — Menyatukan jawaban, perilaku dan riset pada v0.1.1

**Sebelum:** FRD v0.1.0 menganggap 20 agenda NOT_ASKED; nilai awal kuota, pemulihan tanpa kode, retensi logout, minimum KTP, audience/revisi/expiry pesan belum ditetapkan.

**Sesudah:** 16 jawaban tercatat: 15 keputusan produk FRD-DEC-004–018 pada tujuh agenda (Q001/002/003/006/007/012/020) yang **PARTIALLY_CONFIRMED**, serta status inventaris perangkat/browser belum tersedia pada FRD-DEC-019 / Q004 (**ANSWERED_EVIDENCE_UNAVAILABLE**). Dari dua belas agenda yang belum mempunyai jawaban, Q008/009/010 telah diajukan pada gelombang lanjutan dan menunggu jawaban; sembilan lainnya NOT_ASKED. Riset dokumentasi tidak diubah menjadi jawaban manusia.

**Dampak:** FR/AC/TC terkait dipertajam dengan ID stabil; aturan, kamus, transisi dan agenda diselaraskan. [lampiran discovery FRD](FRD.md#frd-appendix) memisahkan kebijakan diterima, proposal batas dan protokol PoC. Riset primer serta inventaris alat dicatat pada TRACEABILITY. Tetap 68 FR, 136 AC dan 156 skenario rencana NOT_RUN; BRD/PRD beserta requirement/AC approved tetap. Rincian PRD-OPEN diselaraskan untuk menyebut hasil FRD tanpa mengubah baseline requirement.

**Owner/status:** pemilik proyek memutuskan kebijakan; asisten menyusun/audit. Tidak ada aplikasi, setup, provider call atau UAT yang diklaim selesai. Keputusan dan batas yang sudah dijawab tidak diminta ulang hanya untuk memenuhi jumlah putaran.

<a id="frd-consolidation"></a>

## 19. Konsolidasi satu FRD — 18 Oktober 2026

### FRD-CHG-003 — Menggabungkan rincian dan memperbaiki kesiapan serah

- **Dasar keputusan:** pemilik meminta dua dokumen FRD dikonsolidasikan menjadi satu spesifikasi yang siap untuk tahap berikutnya.
- **Kelanjutan pekerjaan:** penyusunan diteruskan dari dokumen dan catatan keputusan yang sudah tersedia.
- **Sebelum:** FRD v0.1.1 dan berkas rincian terpisah; referensi/metadata versi belum seluruhnya sinkron; tiga pertanyaan tertunda pada akhir sesi 3.
- **Sesudah:** [FRD v0.1.2](FRD.md) menjadi satu spesifikasi; seluruh sebelas bagian rincian masuk §30.1–30.11; navigasi, referensi, sumber ekspor dan kriteria penutupan di §29.1 diperbaiki. Berkas rincian lama dihapus setelah isinya dipindahkan.
- **Alasan:** pemisahan sebelumnya membedakan katalog FR dari catatan discovery, tetapi keduanya bagian spesifikasi fungsional yang dapat dibaca dalam satu dokumen. Register keputusan dan keterlacakan tetap terpisah karena menyimpan sejarah lintas BRD/PRD/FRD.
- **Dampak:** 68 FR/136 AC/156 TC mempertahankan ID; BRD/PRD dan ekspor sumber tidak diedit. Jawaban baru dicatat pada putaran 2, terpisah dari otorisasi editorial ini.
- **Owner/status:** pengguna mengarahkan konsolidasi; asisten menyusun/audit. CONFIRMED_DIRECTION untuk pekerjaan; FRD DRAFT dan semua uji produk NOT_RUN. Kesiapan baseline SRS masih bergantung pada agenda terbuka, bukan jumlah berkas.

<a id="frd-round-2"></a>

## 20. Keputusan FRD putaran 2 — 18 Oktober 2026

Tiga jawaban berikut diberikan pada sesi kelanjutan atas pertanyaan yang tertunda di akhir sesi 3. Bentuk pertanyaan dilanjutkan dengan contoh konkret; ID subpertanyaan tetap Q008-A/Q009-A/Q010-A. Tidak dibuat agenda baru atau approval seluruh FRD.

| Keputusan / agenda | Interpretasi berlaku | Bukti konfirmasi / batas | Dampak |
|---|---|---|---|
| <a id="frd-dec-020"></a>FRD-DEC-020 / Q008-A | Pengelompokan otomatis dibatasi bentang seluruh kelompok selain kedekatan antar laporan; rantai A–B–C tidak membenarkan gabungan jika A–C melewati batas. | CONFIRMED_R1 dengan contoh rantai; angka jarak/waktu, acuan waktu, kandidat ganda, laporan terlambat dan batas koreksi admin tetap terbuka. | REVIEW-001/004/008; RULE-025; TC-REVIEW-001-02; TC-X-006 |
| <a id="frd-dec-021"></a>FRD-DEC-021 / Q009-A | Tingkat kelompok mengambil tingkat tertinggi dari bukti layak; satu bukti layak tinggi tidak turun karena banyak bukti rendah. Bukti tidak layak dikecualikan; tanpa bukti layak Belum dinilai. | CONFIRMED_R1 dengan contoh satu tinggi vs empat rendah; tidak menetapkan rubrik tiap bukti, kelayakan setelah review atau prioritas admin. | AI-002/003; REVIEW-003; MONITOR-003; RULE-026; TC-MONITOR-003-02 |
| <a id="frd-dec-022"></a>FRD-DEC-022 / Q010-A | Riwayat pemilik menyisakan penanda “Laporan dihapus admin” dan waktu hapus, tanpa akses isi/media/analisis. Penanda bukan laporan aktif atau bukti kelompok; kuota mengikuti DEC-007. | CONFIRMED_R1 untuk tampilan pemilik; retensi penanda, isi/akses audit, cadangan, gagal sebagian dan kontrak retry masih terbuka. | REPORT-011/012; CONTROL-004/005; RULE-027; TC-REPORT-011-01; TC-CONTROL-004-01 |

### FRD-CHG-004 — Menerapkan tiga keputusan ke FRD v0.1.2

Memperjelas input/output/alternatif dan AC terkait, menambah RULE-025–027, menyelaraskan kamus data, transisi, izin, backlog dan lampiran. Tetap 68 FR, 136 AC dan 156 TC dengan ID stabil. Q008/009/010 menjadi PARTIALLY_CONFIRMED, sehingga 10 agenda parsial, 1 status bukti perangkat dan 9 agenda NOT_ASKED. Total 19 jawaban: 18 kebijakan produk dan 1 status bukti. Semua skenario produk tetap NOT_RUN; audit struktur dicatat terpisah.

<a id="frd-round-3"></a>

## 21. Keputusan batas pengelompokan — 18 Oktober 2026

Usulan konkret telah ditulis di FRD §30.12 sebelum pertanyaan dikirim. Jawaban berikut memilih konfigurasi demo dan perilaku waktu, tanpa mengklaim kualitas algoritma/provider sudah terbukti.

| Keputusan / agenda | Interpretasi berlaku | Bukti konfirmasi / batas | Dampak |
|---|---|---|---|
| <a id="frd-dec-023"></a>FRD-DEC-023 / Q008-B | Tetangga ≤1.500 m dan ≤6 jam; bentang seluruh kelompok ≤3.000 m dan ≤12 jam, batas inklusif. Nilai dipilih untuk demo, bukan bukti validitas geografis. | CONFIRMED_R1 untuk nilai/boundary, memperinci DEC-020; metrik/presisi, kandidat ganda dan koreksi manual tersisa. | REVIEW-001; RULE-025; TC-REVIEW-001-02 |
| <a id="frd-dec-024"></a>FRD-DEC-024 / Q008-C | Pengelompokan memakai waktu kejadian yang diisi valid; jika kosong gunakan waktu penerimaan server dengan asal waktu dapat dibedakan. Kuota tetap memakai waktu penerimaan. | CONFIRMED_R1 dengan contoh 08.00/13.00; validasi waktu masa depan/usia dan kasus ambigu masih Q017/Q008. | REPORT-002; REVIEW-001/008; RULE-025; TC-X-006 |
| <a id="frd-dec-025"></a>FRD-DEC-025 / Q008-D | Laporan terlambat dengan waktu kejadian dalam interval kejadian selesai dan batas lokasi memenuhi masuk kelompok selesai, menambah riwayat tanpa membuka kembali Pantau; admin dapat mengoreksi. | CONFIRMED_R1 untuk terlambat, pemeriksaan batas keputusan tidak reopen; kandidat ganda, waktu kosong/ambigu dan race selesai belum dipilih. | REVIEW-001/004/007/008; RULE-028; TC-REVIEW-008-02; TC-X-006 |

### FRD-CHG-005 — Memperinci aturan kelompok pada v0.1.2

Memperbarui FR-REVIEW-001/007/008, RULE-025/028, state kejadian, TC-REVIEW-001-02/TC-REVIEW-008-02/TC-X-006 dan backlog. Total 22 jawaban: 21 keputusan produk dan 1 status bukti perangkat. Jumlah agenda tetap 20: 10 parsial, 1 ANSWERED_EVIDENCE_UNAVAILABLE dan 9 NOT_ASKED. Q008 masih terbuka untuk kandidat ganda, nama lokasi, kasus ambigu dan koreksi manual; semua pengujian tetap NOT_RUN.

<a id="frd-round-4"></a>

## 22. Penutupan kontrak fungsi pengelompokan — 18 Oktober 2026

| Keputusan / agenda | Interpretasi berlaku | Bukti konfirmasi / batas | Dampak |
|---|---|---|---|
| <a id="frd-dec-026"></a>FRD-DEC-026 / Q008-E | Prioritaskan kandidat selesai untuk laporan terlambat yang memenuhi DEC-025; selebihnya kandidat aktif. Dalam kelas kandidat yang sama, pilih anggota terdekat, lalu kelompok paling awal dibuat, lalu pengenal stabil; tidak merge otomatis beberapa kelompok. | CONFIRMED_R1 untuk pemilihan/tie-break; metrik jarak/pengenal teknis SRS, konflik proses Q020. | REVIEW-001/008; RULE-029; TC-REVIEW-001-02; TC-X-006 |
| <a id="frd-dec-027"></a>FRD-DEC-027 / Q008-F | Nama wilayah dari titik laporan paling awal diterima yang masih ada; bila tidak tersedia gunakan label “Lokasi laporan” dan kode kelompok tanpa identitas warga/koordinat presisi. Sumber yang dihapus/dipindah tidak terus menjadi dasar ringkasan. | CONFIRMED_R1 dengan fallback; pilihan layanan/nomenklatur nama SRS, format/panjang label Q017. Tidak menambah aksi rename admin. | MONITOR-001; REVIEW-001/004; CONTROL-005; RULE-030; TC-MONITOR-001-01 |
| <a id="frd-dec-028"></a>FRD-DEC-028 / Q008-G | Koreksi manual admin boleh melampaui batas otomatis dengan alasan wajib/audit; kedua kelompok dihitung ulang dan koreksi tidak dibatalkan diam-diam oleh proses otomatis. Pemindahan tidak otomatis membuka kelompok selesai. | CONFIRMED_R1 untuk pengecualian manual dan pemeriksaan batas otomatis DEC-020/023; validasi alasan Q017, retensi audit Q010, race Q020. | REVIEW-004/009; CONTROL-005; RULE-031; TC-REVIEW-004-01/02 |

### FRD-CHG-006 — Kontrak fungsi Q008 dikonfirmasi

Q008-A–G telah mempunyai jawaban eksplisit. Perilaku dasar, boundary/rantai, waktu, terlambat, kandidat, nama lokasi dan koreksi manual dapat dipakai sebagai masukan rancangan. Status agenda Q008 menjadi FUNCTION_CONFIRMED; validasi input tetap Q017, konflik proses Q020, mekanisme/metrik/layanan nama Q018 dan bukti kualitas Q013/019. Tidak menutup dependensi tersebut atau memberi approval FRD. Total 25 jawaban: 24 kebijakan produk dan 1 status bukti. Agenda: 1 fungsi dikonfirmasi, 9 parsial, 1 bukti belum tersedia, 9 NOT_ASKED.

<a id="frd-round-5"></a>

## 23. Dasar penilaian dan prioritas review — 18 Oktober 2026

| Keputusan / agenda | Interpretasi berlaku | Bukti konfirmasi / batas | Dampak |
|---|---|---|---|
| <a id="frd-dec-029"></a>FRD-DEC-029 / Q009-B | Dasar rubrik tingkat tiap bukti pada demo memakai dampak yang ditunjukkan bukti/keterangan. Informasi tidak cukup tetap Belum dinilai. | CONFIRMED_R1 untuk dasar, bukan batas tiap tingkat atau akurasi AI; rubrik rinci Q009 dan PoC Q013. | AI-001/003; MONITOR-003; RULE-032 |
| <a id="frd-dec-030"></a>FRD-DEC-030 / Q009-C | Bukti yang semula tidak cocok kembali layak dihitung hanya setelah admin menetapkan relevansi, tingkat dan alasan. Membuka laporan/catatan biasa tidak cukup; jejak AI awal tetap dipertahankan sesuai lifecycle. | CONFIRMED_R1 dengan batas tindakan biasa; rubrik tingkat Q009, audit/validasi/konflik Q010/017/020. | AI-002; REVIEW-003; RULE-033; TC-AI-002-01/02 |
| <a id="frd-dec-031"></a>FRD-DEC-031 / Q009-D | Antrean review yang punya tingkat berurutan Tinggi → Sedang → Rendah, lalu tunggu terlama dan pengenal stabil. Belum dinilai mempunyai antrean terpisah menurut tunggu terlama dan pengenal stabil. | CONFIRMED_R1 untuk urutan/tie-break dan pemisahan Belum dinilai; awal waktu tunggu/refresh/cakupan review masih Q009/020. | REVIEW-002/006; RULE-034; TC-REVIEW-002-01/02 |

### FRD-CHG-007 — Dasar penilaian/review pada v0.1.2

Memperbarui FR-AI-002, FR-REVIEW-002/003 dan FR-MONITOR-003, RULE-032–034, transisi kelayakan, AC/TC, RTM, backlog dan lampiran. Total 28 jawaban: 27 kebijakan produk dan 1 status bukti perangkat. Q008 fungsi dikonfirmasi; Q009 tetap parsial karena rubrik rinci/awal waktu tunggu/refresh/catatan belum dipilih. Tidak ada perubahan jumlah ID FR/AC/TC atau klaim hasil pengujian produk.

<a id="frd-round-6"></a>

## 24. Rubrik demo — kelanjutan sesi 4, 18 Oktober 2026

| Keputusan / agenda | Interpretasi berlaku | Bukti konfirmasi / batas | Dampak |
|---|---|---|---|
| <a id="frd-dec-032"></a>FRD-DEC-032 / Q009-E | Rubrik dampak demo: Rendah untuk genangan lokal dengan informasi cukup; Sedang untuk air masuk bangunan/akses terganggu; Tinggi untuk orang terjebak/perlu pertolongan atau evakuasi yang didukung bukti. Informasi kurang tetap Belum dinilai; pilih tingkat tertinggi yang didukung jika beberapa indikator ada. | CONFIRMED_R1 pada kelanjutan kajian FRD; batas informasi dan bukan status resmi tercakup. Q009 belum tertutup; mutu AI/PoC Q013/019 tetap NOT_RUN. | AI-001/002/003; REVIEW-003; MONITOR-003; RULE-035; §30.15; TC-AI-001-01 dan TC-MONITOR-003-01/02 |

### FRD-CHG-008 — Melanjutkan FRD menjadi v0.1.3

- **Sumber arahan:** pengguna meminta melanjutkan pekerjaan dari ekspor sesi 4 (arsip lokal). Arahan melanjutkan bukan approval kebijakan; Q009-E mempunyai jawaban terpisah di [register](TRACEABILITY.md#frd-rubric-question).
- **Perubahan:** rubrik yang sebelumnya usulan menjadi keputusan demo; persyaratan, aturan, AC, RTM dan backlog diselaraskan. Usulan cakupan review/waktu tunggu tersedia pada §30.16 dan tetap PROPOSED sampai dijawab.
- **Perbaikan bukti:** audit v0.1.2 yang masih berisi placeholder dilengkapi berdasarkan hasil PASS aktual; penyampaian Q009-E diperbaiki karena respons penutup tidak ditemukan dalam ekspor.
- **Dampak:** 29 catatan keputusan = 28 keputusan produk + 1 bukti perangkat belum tersedia; 68 FR/136 AC/156 TC tetap. Q008 FUNCTION_CONFIRMED, Q009 dan delapan agenda lain PARTIALLY_CONFIRMED. BRD/PRD approved tetap; FRD DRAFT; uji produk NOT_RUN.

<a id="frd-round-7"></a>

## 25. Cakupan review, waktu tunggu, pembaruan dan catatan — 18 Oktober 2026

Lima keputusan berikut dikonfirmasi dalam dua tahap setelah §30.16 dan §30.17 tersedia sebagai usulan. Contoh batas yang disajikan termasuk cakupan versi, antrean yang masih terbuka, koneksi gagal, perpindahan kelompok dan koreksi catatan.

| Keputusan / agenda | Interpretasi berlaku | Bukti konfirmasi / batas | Dampak |
|---|---|---|---|
| <a id="frd-dec-033"></a>FRD-DEC-033 / Q009-F | Review eksplisit per laporan dan versi bukti/hasil yang dilihat. Kelompok Ditinjau hanya jika semua bukti terkini tercakup; membuka halaman atau menulis catatan tidak cukup. Ditinjau tidak otomatis berarti relevan/layak dihitung. | CONFIRMED_R1; pertanyaan/kasus batas pada register. Lifecycle Q010/015, validasi Q017, konflik Q020 dan bukti kualitas Q013/019 terpisah. | REVIEW-003/006/009; AI-002; penanda Pantau; RULE-036; TC-REVIEW-006-01/02; TC-X-005 |
| <a id="frd-dec-034"></a>FRD-DEC-034 / Q009-G | Awal tunggu adalah kebutuhan review tertua yang masih terbuka: penerimaan server untuk laporan baru, waktu perubahan tersimpan untuk hasil yang berubah sesudah review. Tambahan bukti tidak mereset kebutuhan lama; selesai/hapus kebutuhan tertua memilih kebutuhan tersisa. Semua selesai keluar antrean; bukti baru mulai siklus baru. | CONFIRMED_R1; pertanyaan/kasus batas pada register. Lifecycle Q010/015, validasi Q017, konflik Q020 dan bukti kualitas Q013/019 terpisah. | REVIEW-002/006; RULE-037; TC-REVIEW-002-01/02 |
| <a id="frd-dec-035"></a>FRD-DEC-035 / Q009-H | Pantau/antrean review diperbarui saat dibuka/kembali aktif, muat ulang manual, setelah aksi admin berhasil, dan tiap 30 detik selama terlihat serta online. Gagal mempertahankan data terakhir beserta waktu dan penanda gagal/offline. Form yang diketik tidak ditimpa; perubahan sumber diberitahukan dan konflik diperiksa saat simpan. | CONFIRMED_R1; pertanyaan/kasus batas pada register. Lifecycle Q010/015, validasi Q017, konflik Q020 dan bukti kualitas Q013/019 terpisah. | REVIEW-002/009; MONITOR-001/002; RULE-038; TC-MONITOR-002-01/02 |
| <a id="frd-dec-036"></a>FRD-DEC-036 / Q009-I | Catatan melekat pada satu laporan dan hanya terbaca kedua admin serta pemiliknya. Pindah kelompok mempertahankan catatan pada laporan; anggota kelompok lama/baru dan pelapor baru tidak memperoleh akses catatan itu. | CONFIRMED_R1; pertanyaan/kasus batas pada register. Lifecycle Q010/015, validasi Q017, konflik Q020 dan bukti kualitas Q013/019 terpisah. | REVIEW-005; RBAC; RULE-039; TC-REVIEW-005-01/02 |
| <a id="frd-dec-037"></a>FRD-DEC-037 / Q009-J | Catatan tersimpan tidak diedit/dihapus satu per satu; koreksi berupa catatan baru yang merujuk catatan lama. Pelapor/admin melihat urutan dan waktu koreksi. Hapus laporan tetap menghilangkan akses isi catatan terkait; retensi/audit dibahas Q010/015. | CONFIRMED_R1; pertanyaan/kasus batas pada register. Lifecycle Q010/015, validasi Q017, konflik Q020 dan bukti kualitas Q013/019 terpisah. | REVIEW-005/009; CONTROL-004; RULE-040; TC-REVIEW-005-01/02 |

### FRD-CHG-009 — Kontrak fungsi Q009 dikonfirmasi

Q009-A–J mempunyai jawaban eksplisit; fungsi tingkat/review/refresh/catatan kini FUNCTION_CONFIRMED. Jumlah keseluruhan 34 jawaban = 33 keputusan produk + 1 status bukti perangkat. Dua agenda fungsi dikonfirmasi (Q008/Q009), delapan parsial, satu bukti belum tersedia, sembilan NOT_ASKED. FR/AC/TC, aturan, data, state, akses dan RTM diselaraskan dengan ID stabil (68/136/156). FRD v0.1.3 tetap DRAFT; tidak ada approval isi lengkap, hasil provider/UAT atau perpindahan tahap SRS.

<a id="frd-round-8"></a>

## 26. Penghapusan, pembersihan sebagian dan audit — 18 Oktober 2026

| Keputusan / agenda | Interpretasi berlaku | Bukti konfirmasi / batas | Dampak |
|---|---|---|---|
| <a id="frd-dec-038"></a>FRD-DEC-038 / Q010-B | Konfirmasi sebelum hapus menjelaskan hilangnya akses isi/media/analisis/catatan, hitung ulang agregat, penanda/waktu hapus, tanpa refund kuota dan tanpa pemulihan aplikasi. Alasan singkat wajib tanpa menyalin isi/data pribadi; batal tidak mengubah data. | CONFIRMED_R1 dengan skenario batas yang disajikan; retensi/cadangan/cache Q010/015, validasi Q017 dan konflik Q020 tetap terbuka. | CONTROL-004; RULE-041; TC-CONTROL-004-01/02 |
| <a id="frd-dec-039"></a>FRD-DEC-039 / Q010-C | Setelah penghapusan sah tercatat, akses laporan/turunan tetap dicabut dan sumber tidak dihitung meski pembersihan fisik gagal sebagian. Pemilik melihat penanda; admin melihat Pembersihan tertunda/gagal dan dapat retry pekerjaan sama. Selesai penuh hanya setelah pembersihan aktif tuntas; hasil AI terlambat tidak memulihkan sumber. | CONFIRMED_R1 dengan skenario batas yang disajikan; retensi/cadangan/cache Q010/015, validasi Q017 dan konflik Q020 tetap terbuka. | CONTROL-004/005; state penghapusan/pembersihan; RULE-042; TC-CONTROL-004-01; TC-CONTROL-005-01/02; TC-X-004 |
| <a id="frd-dec-040"></a>FRD-DEC-040 / Q010-D | Audit penghapusan hanya untuk kedua admin. Field: pengenal tindakan/laporan/admin, waktu, alasan tindakan dan hasil/status pembersihan. Tidak menyalin media, deskripsi, analisis, isi catatan/dokumen, token atau koordinat presisi. Pemilik hanya penanda/waktu; retensi belum dipilih. | CONFIRMED_R1 dengan skenario batas yang disajikan; retensi/cadangan/cache Q010/015, validasi Q017 dan konflik Q020 tetap terbuka. | CONTROL-004; data/izin audit; RULE-043; TC-CONTROL-004-02 |
| <a id="frd-dec-041"></a>FRD-DEC-041 / Q010-E | Penanda riwayat terlihat 30 hari sejak penghapusan sah tercatat; audit penghapusan disimpan 90 hari sejak tindakan dicatat. Tepat tenggat entri tidak ditampilkan lagi. Kedaluwarsa tidak menghentikan pembersihan atau mereset kuota/pencegahan resurrection. Cadangan/provider tidak tercakup. | CONFIRMED_R1 dengan batas tepat tenggat/pembersihan/kuota; cadangan/cache/provider dan lifecycle data kendali masih terbuka. | REPORT-011; CONTROL-004; RULE-044; TC-REPORT-011-01; TC-CONTROL-004-02 |

### FRD-CHG-010 — Memisahkan pencabutan akses dan penyelesaian pembersihan

DEC-038–040 diterapkan pada CONTROL-004/005, data/state/izin audit, RULE-041–043, AC/TC, RTM dan backlog. Setelah penghapusan tercatat, kegagalan pembersihan tidak memulihkan akses dan tidak disebut selesai penuh. Jumlah 37 jawaban = 36 keputusan produk + 1 bukti perangkat belum tersedia. Q010 masih parsial untuk retensi/cadangan/cache dan detail audit lain; Q008/Q009 tetap dikonfirmasi fungsi, keseluruhan FRD v0.1.3 DRAFT. ID 68 FR/136 AC/156 TC tetap dan semua uji produk NOT_RUN.

### FRD-CHG-011 — Masa simpan penanda dan audit hapus

DEC-041 memilih penanda 30 hari dan audit penghapusan 90 hari, dengan tenggat server serta pembersihan/kuota yang tidak direset. Perilaku, RULE-044, state, AC/TC dan RTM diperbarui. Total 38 jawaban = 37 keputusan produk + 1 status bukti perangkat; status agenda tetap 2 fungsi dikonfirmasi, 8 parsial, 1 bukti belum tersedia dan 9 NOT_ASKED. Sisa Q010 mencakup cadangan/cache, data kendali/hasil sementara dan audit selain penghapusan. Seluruh uji produk tetap NOT_RUN.

<a id="frd-dlg-001"></a>

## 27. Mandat finalisasi dan approval FRD — 18 Oktober 2026

**FRD-DLG-001 — otorisasi finalisasi dari pemilik:**

**Ringkasan mandat:** Pemilik mendelegasikan pemilihan standar demo dan finalisasi FRD sebagai baseline approved. Pembahasan operasional server berada di luar cakupan; pekerjaan dilanjutkan ke tahap spesifikasi berikutnya.

Makna yang diterapkan: pemilik meminta asisten menyelesaikan seluruh rincian FRD dengan pilihan standar demo dan mencatat status approved, tanpa putaran pertanyaan lanjutan. Pembahasan setup/backup server dikeluarkan dari syarat FRD. Ini mandat eksplisit terbaru yang menggantikan proses menunggu jawaban per rincian; tidak mengubah keputusan terdahulu atau menambah klaim pengujian.

<a id="frd-approval-01"></a>

### FRD-APPROVAL-01 — APPROVED v1.0.0 melalui delegasi

Baseline [FRD v1.0.0](FRD.md) ditutup di bawah mandat di atas. Pilihan di bawah dibuat asisten dalam cakupan delegasi dan berstatus DELEGATED_APPROVED. Tidak ada klaim bahwa pemilik memberi 12 jawaban individual atau melakukan review terpisah setelah penulisan. Tahap berikut SRS; tidak menjalankan server/deployment. Bukti aplikasi/provider/perangkat/UAT tetap NOT_RUN.

| Keputusan delegasi | Isi final | Agenda / sumber |
|---|---|---|
| FRD-STD-001 | [Batas demo dan penutupan pembahasan server](FRD.md#frd-std-001) | Q001; FRD-DLG-001 |
| FRD-STD-002 | [Validasi dan batas masukan demo](FRD.md#frd-std-002) | Q017; FRD-DLG-001 |
| FRD-STD-003 | [Akun, sesi dan pemulihan](FRD.md#frd-std-003) | Q005/006; FRD-DLG-001 |
| FRD-STD-004 | [Kuota, kirim, rekonsiliasi dan pembatalan lokal](FRD.md#frd-std-004) | Q001/002; FRD-DLG-001 |
| FRD-STD-005 | [Dokumen, KTP, logout dan cache pribadi](FRD.md#frd-std-005) | Q003/007/015; FRD-DLG-001 |
| FRD-STD-006 | [Analisis, tujuan pemrosesan dan hasil sementara](FRD.md#frd-std-006) | Q013/014/015; FRD-DLG-001 |
| FRD-STD-007 | [Keluarga, katalog tas dan progres lokal](FRD.md#frd-std-007) | Q011; FRD-DLG-001 |
| FRD-STD-008 | [Konten umum, daftar dan suara](FRD.md#frd-std-008) | Q016; FRD-DLG-001 |
| FRD-STD-009 | [Publikasi pesan, revisi dan akhir masa berlaku](FRD.md#frd-std-009) | Q012; FRD-DLG-001 |
| FRD-STD-010 | [Hasil konflik dan perubahan bersamaan](FRD.md#frd-std-010) | Q020; FRD-DLG-001 |
| FRD-STD-011 | [Lifecycle data dan audit aplikasi sederhana](FRD.md#frd-std-011) | Q010/015; FRD-DLG-001 |
| FRD-STD-012 | [Batas bukti, manifest demo dan masukan SRS](FRD.md#frd-std-012) | Q004/013/014/018/019; FRD-DLG-001 |

### FRD-CHG-012 — Menutup fungsi dan menyerahkan baseline ke SRS

Rincian validasi, akun/pemulihan, penerimaan/kuota, cache/dokumen, AI/consent, keluarga/tas, konten/TTS/daftar, inbox, konflik dan lifecycle ditetapkan dalam 12 paket standar. Q010-F ditarik tanpa memilih 7/30 hari. Status agenda: 15 FUNCTION_BASELINED, 4 EVIDENCE_SCHEDULED, 1 ALLOCATED_SRS. 68 FR/136 AC/156 TC dan 38 catatan keputusan historis tetap; satu mandat kolektif baru dicatat terpisah. BRD/PRD serta empat ekspor sumber tidak diubah. Audit dokumen ditelusuri pada [audit final](TRACEABILITY.md#frd-audit-v100).

<a id="srs-dlg-001"></a>

## 28. Pelaksanaan dan finalisasi SRS — 18 Oktober 2026

**Otorisasi pemilik setelah penyajian rencana SRS:**

**Ringkasan mandat:** Pemilik menyetujui pelaksanaan rencana SRS, termasuk penyelesaian rincian teknis dan pemeriksaan konsistensinya.

**SRS-DLG-001:** instruksi ini mengaktifkan rencana SRS yang telah disajikan, bersama mandat sebelumnya memakai pilihan standar demo tanpa mengulang pertanyaan rincian. Keputusan teknis berikut dipilih asisten dalam cakupan tersebut. Bukan jawaban individual pengguna, bukan izin setup server/deployment, dan bukan bukti pengujian produk.

<a id="srs-approval-01"></a>
**SRS-APPROVAL-01:** [SRS v1.0.0](SRS.md) menjadi baseline spesifikasi APPROVED melalui delegasi finalisasi setelah penyusunan dan audit. Tidak mengklaim pemilik melakukan sign-off terpisah sesudah membaca setiap kontrak. Batas pembuktian provider/perangkat/fixture dari FRD STD-012 tetap berlaku; spesifikasi siap tahap 5, bukan aplikasi yang sudah lulus.

| ID keputusan | Pilihan teknis / alasan | Alternatif yang tidak diwajibkan / batas |
|---|---|---|
| <a id="srs-dec-001"></a>SRS-DEC-001 | API Node 24/TypeScript/Fastify 5 dengan schema; DELEGATED_APPROVED, SRS-DLG-001 | Framework lebih berat tidak dibutuhkan demo; patch dicatat saat setup |
| <a id="srs-dec-002"></a>SRS-DEC-002 | MySQL InnoDB, SQL migrations, driver mysql2; DELEGATED_APPROVED, SRS-DLG-001 | ORM bukan kewajiban; instance aktual diverifikasi sebelum migrasi |
| <a id="srs-dec-003"></a>SRS-DEC-003 | Antrean tabel MySQL, satu worker/concurrency 2; DELEGATED_APPROVED, SRS-DLG-001 | Tidak menambah Redis/broker sebagai layanan wajib |
| <a id="srs-dec-004"></a>SRS-DEC-004 | Guard transaksi mutasi bisnis sederhana; DELEGATED_APPROVED, SRS-DLG-001 | Tidak membangun locking terdistribusi; tidak memegang guard selama I/O luar |
| <a id="srs-dec-005"></a>SRS-DEC-005 | Opaque sessions, scrypt dan recovery verifier; token web hanya memori; DELEGATED_APPROVED, SRS-DLG-001 | Tidak memerlukan JWT/refresh-token service atau email recovery |
| <a id="srs-dec-006"></a>SRS-DEC-006 | Berkas privat di luar webroot, staging/cleanup terpisah; DELEGATED_APPROVED, SRS-DLG-001 | Tidak membuat public object URL untuk dokumen; tidak menambah cloud storage |
| <a id="srs-dec-007"></a>SRS-DEC-007 | Adapter deepseek-flash + inline gambar, FFmpeg/Poppler; DELEGATED_APPROVED, SRS-DLG-001 | Provider nyata belum diuji; bukan OCR/identitas resmi; tiga frame tetap FRD |
| <a id="srs-dec-008"></a>SRS-DEC-008 | Target Android API 24+, Flutter stable; adapter lokasi/secure storage/TTS; DELEGATED_APPROVED, SRS-DLG-001 | Versi patch dan perangkat nyata manifest setup; tidak mengklaim semua HP mendukung |
| <a id="srs-dec-009"></a>SRS-DEC-009 | Controller/repository Flutter dan SQLite per akun; DELEGATED_APPROVED, SRS-DLG-001 | Tidak mewajibkan framework state atau sinkron tas/kontak backend |
| <a id="srs-dec-010"></a>SRS-DEC-010 | Peta tile interaktif OSM, koordinat manual/fallback nama generik; DELEGATED_APPROVED, SRS-DLG-001 | Tidak ada reverse geocoding atau peta offline wajib |
| <a id="srs-dec-011"></a>SRS-DEC-011 | OpenAPI 3.1/schema + semantik SRS; NFR demo terukur; DELEGATED_APPROVED, SRS-DLG-001 | Schema saja tidak membuktikan ownership/kuota atau kinerja aktual |
| <a id="srs-dec-012"></a>SRS-DEC-012 | Spesifikasi final dengan lima paket bukti terjadwal; DELEGATED_APPROVED, SRS-DLG-001 | Tidak mengubah NOT_RUN menjadi PASS; tidak melaksanakan setup/deploy |

### SRS-CHG-001

SRS, kontrak OpenAPI, contoh schema dan RTM disusun; keputusan BRD/PRD/FRD tidak ditulis ulang. Pilihan teknis menutup desain penerimaan/replay/close, locking/reset, lease worker, hasil usang, ownership blob, keluarga dan versi pesan. Target kinerja demo adalah pilihan engineering dalam delegasi, bukan metrik yang sudah terukur. [Audit SRS](TRACEABILITY.md#srs-audit-v100) memisahkan validator dokumen/schema dari seluruh tes aplikasi NOT_RUN.

<a id="workspace-scope-001"></a>

## 29. Koreksi cakupan setup workspace — 18 Oktober 2026

**WORKSPACE-SCOPE-001 — otorisasi pemilik:**

**Ringkasan mandat:** Setup dibatasi pada AGENTS, rules, skills, README, dan struktur workspace. Tim menginisialisasi backend dan Flutter sendiri; scaffold aplikasi, cache, laporan otomatis, dan utilitas yang tidak diperlukan dikeluarkan dari cakupan.

Status: **CURRENT_USER_CONFIRMED untuk cakupan**, bukan sign-off baru atas hasil
penataan. Workspace mencakup AGENTS, README, rules, skills serta satu wadah
`project/` dengan `server/` dan `app/`. Tim menginisialisasi backend/Flutter.
Permintaan ini menggantikan interpretasi asisten yang membuat scaffold,
migrasi/seed, konfigurasi runtime dan utilitas instalasi pada tahap workspace.

**WORKSPACE-CHG-001:** scaffold dan utilitas baru yang keliru ditarik dari
workspace aktif; dokumen approved dan riwayat dipertahankan, tautan arsip
disesuaikan. Lima skill tugas dan tiga rules disusun dari kebutuhan proyek.
FRD/SRS tidak diganti dan seluruh pengujian produk tetap NOT_RUN.

Penulisan `.agents/` ditolak otomatis oleh kebijakan izin sesi. Skills disiapkan
di `skills/` dan diarahkan melalui AGENTS; penemuan native belum tersedia.
Ini batas pelaksanaan, bukan keputusan pengguna untuk menonaktifkan native
skills. Dasar resmi, hasil pemeriksaan dan lokasi akhir ada pada
[WORKSPACE](WORKSPACE.md) dan [RTM workspace](TRACEABILITY.md#workspace-traceability).

<a id="workspace-quality-002"></a>

## 30. Apps, mutu UI, portabilitas dan pembaruan informasi — 18 Oktober 2026

**WORKSPACE-QUALITY-002 — otorisasi pemilik:**

**Ringkasan mandat:** Pemilik menetapkan folder apps, panduan UI dengan ikon standar, dukungan workspace lintas OS/IDE, serta kewajiban memperbarui seluruh informasi proyek yang terdampak.

Status: **CURRENT_USER_CONFIRMED untuk arah pekerjaan**, bukan sign-off hasil
atau klaim runtime lintas OS/IDE telah diuji. Menggantikan nama wadah pada §29;
inisialisasi Flutter/backend tetap tanggung jawab tim.

| ID | Penerapan dalam mandat |
|---|---|
| WS-DEC-002 | Rename wadah menjadi `apps/`, berisi `server/` dan `app/`; seluruh tautan aktif diselaraskan |
| WS-DEC-003 | Material 3 dan Material Icons bawaan Flutter; enam skill termasuk UI; detail/kriteria pada DESIGN |
| WS-DEC-004 | Panduan Windows/macOS/Linux, path relatif/case tepat, EditorConfig dan Git attributes; byte arsip dipertahankan |
| WS-DEC-005 | AGENTS sumber bersama; pengarah tipis Claude dan JetBrains; dukungan tiap harness dibedakan dari bukti pemuatan |
| WS-DEC-006 | Setiap perubahan wajib memeriksa semua kelompok dokumentasi/instruksi dan memperbarui yang terdampak dalam pekerjaan yang sama |

Pilihan komponen, token awal dan prosedur dibuat dalam mandat ini, bukan hasil
uji UI atau jawaban individual pengguna. Pengarah IDE tidak memperluas izin.
Penempatan native skill Codex tetap terhalang izin `.agents/`; baca langsung
melalui routing AGENTS. Rules sinkronisasi adalah gate kerja/review, belum hook
atau CI otomatis. Baseline fungsi, kontrak, peran dan platform produk tetap.
Riset/bukti: [WORKSPACE](WORKSPACE.md), [DESIGN](DESIGN.md),
[RTM terbaru](TRACEABILITY.md#workspace-quality-traceability).

<a id="workspace-skills-003"></a>

## 31. Audit dan riset skill sesuai proyek — 19 Oktober 2026

**WORKSPACE-SKILLS-003 — otorisasi pemilik:**

**Ringkasan mandat:** Pemilik mengotorisasi audit panduan agent dan seleksi referensi skill yang relevan. Koleksi SKILLS lokal digunakan sebagai bahan kajian, tanpa kewajiban mengimpor paketnya.

Status: **CURRENT_USER_CONFIRMED untuk mandat audit/penyempurnaan**.
Pilihan implementasi panduan di bawah dibuat dalam mandat itu, bukan sign-off
terpisah pengguna atau klaim seluruh aplikasi telah diuji. Batas §29–30 tetap.

| ID | Penerapan dan alasan |
|---|---|
| WS-DEC-007 | Seleksi koleksi lokal dan sumber resmi dicatat pada SKILL-RESEARCH; inventaris dibedakan dari bacaan penuh/terpilih; tidak mengimpor bundel |
| WS-DEC-008 | Tambah siagabanjir-debug dan siagabanjir-verification untuk diagnosis dan paket bukti; total delapan skill dengan pemicu spesifik |
| WS-DEC-009 | Tambah rule riset; sumber eksternal tidak memberikan izin alat; metadata/path dan skenario positif/negatif diperiksa terpisah dari runtime |
| WS-DEC-010 | CLAUDE memakai impor @AGENTS.md sesuai dokumentasi, tanpa symlink atau konfigurasi global |
| WS-DEC-011 | Perjelas alur aksi sampai hasil, teks faktual, Semantics Flutter, review berbukti dan praproses sesuai SRS; Material Icons tetap |
| WS-DEC-012 | Kurangi pengulangan gate dokumen pada skills; README, AGENTS, katalog, rules, desain, keputusan/RTM dan handoff diselaraskan |

Riset: [SKILL-RESEARCH](SKILL-RESEARCH.md). Pemeriksaan dan batas:
[WORKSPACE](WORKSPACE.md#verifikasi), [RTM](TRACEABILITY.md#workspace-skills-traceability).
Tidak ada perubahan baseline fungsi/kontrak, setup SDK/aplikasi, tool baru atau
layanan. Native skills tetap terhalang izin .agents; pembacaan melalui AGENTS
tersedia. Uji aplikasi/provider/perangkat dan evaluasi agent terpisah tetap NOT_RUN.

<a id="workspace-reference-004"></a>

## 32. Seleksi pola dari setup-softwarebk — 19 Oktober 2026

**WORKSPACE-REFERENCE-004 — otorisasi pemilik:**

**Ringkasan mandat:** Referensi setup-softwarebk dikaji secara selektif untuk melengkapi panduan SiagaBanjir. Hanya pola yang sesuai kebutuhan dan batas proyek yang diadaptasi.

Status: **CURRENT_USER_CONFIRMED untuk analisis/adaptasi selektif**.
Ini melanjutkan mandat workspace; tidak memindahkan aturan approval, stack,
peran atau fungsi Software-BK ke SiagaBanjir. Referensi tidak diedit.

| ID | Penerapan dalam mandat dan alasan |
|---|---|
| WS-DEC-013 | Peta sumber normatif/implementasi/bukti pada WORKSPACE; arsitektur/data/API merujuk SRS/kontrak yang ada, tanpa dokumen paralel |
| WS-DEC-014 | Pertegas client API bersama di Flutter serta keselarasan SQL/DTO/kontrak; mengikuti SRS, bukan menambahkan Prisma/JWT/tenant sekolah |
| WS-DEC-015 | Unit perubahan utuh, pemeriksaan sesuai dampak, sumber dokumen bersama; lanjut dalam mandat tanpa konfirmasi per modul |
| WS-DEC-016 | apps/README menetapkan informasi perintah/versi/config aktual setelah setup tim; pisahkan formatter, lint, tipe/analyzer, build dan tes |
| WS-DEC-017 | .vscode/extensions.json hanya merekomendasikan EditorConfig dan Flutter; petunjuk Neovim ditambahkan, tanpa pemasangan ekstensi/SDK atau tasks/launch spekulatif |
| WS-DEC-018 | Perkuat lima skill yang terkait dan catat seleksi/konflik referensi; jumlah tetap delapan skill/tujuh rules |

Kondisi referensi: 17 berkas diinventaris, 16 dibaca penuh dan satu sebagian;
backend/frontend kosong. Klaim versi, perintah dan implementasinya tidak dianggap
bukti runtime. Rincian keputusan termasuk pola yang tidak diadopsi ada di
[perbandingan](SKILL-RESEARCH.md#softwarebk). Hasil pemeriksaan:
[WORKSPACE](WORKSPACE.md#audit-softwarebk), [RTM](TRACEABILITY.md#workspace-reference-traceability).

FRD/SRS/kontrak, Material Icons dan target produk tidak berubah. Aplikasi tetap
disiapkan tim di apps. Penempatan native Codex masih terhalang izin .agents;
pengujian aplikasi, provider/perangkat serta pemuatan IDE aktual tetap NOT_RUN.

<a id="workspace-publish-005"></a>

## 33. Bacaan penuh, living documents dan persiapan GitHub — 19 Oktober 2026

**WORKSPACE-PUBLISH-005 — otorisasi pemilik:**

**Ringkasan mandat:** Pemilik mewajibkan bacaan lengkap sebelum pekerjaan, pemeliharaan living documents, pemeriksaan artefak, serta panduan commit/push/PR. Mandat pada tahap ini mencakup persiapan publikasi; otorisasi push dicatat terpisah.

Status: **CURRENT_USER_CONFIRMED untuk mandat perapian/persiapan**.
Tidak memberi mandat asisten membuat remote, commit/push atau merge;
pemilik menyatakan akan melakukan push. Batas inisialisasi aplikasi tetap.

| ID | Penerapan dan alasan |
|---|---|
| WS-DEC-019 | Seluruh dokumentasi/instruksi aktif, skills, kontrak dan konfigurasi bersama wajib dibaca penuh sebelum pekerjaan proyek, tanpa pengecualian ukuran tugas. Menggantikan routing bacaan selektif; prosedur pelaksanaan tetap sesuai tugas |
| WS-DEC-020 | Living documents diperbarui AI secara proaktif pada perubahan yang sama; marker Markdown mengarah ke satu aturan. Tidak mengklaim layanan latar belakang atau hook/CI |
| WS-DEC-021 | Panduan commit/push/PR lintas OS dan template PR; belum menjalankan operasi publikasi |
| WS-DEC-022 | Isi mentah archive tetap lokal dan diabaikan Git, hanya README indeks ikut publikasi; rujukan sumber privat diganti ke indeks tanpa menghapus bukti asli |
| WS-DEC-023 | contracts dipertahankan sebagai sumber normatif SRS. Baseline hanya mendapat marker metadata/rujukan arsip; requirement, ID dan approval tidak berubah |
| WS-DEC-024 | Riset resmi terkini, delapan skill/tujuh rules tetap, tanpa bundel tambahan. Notes nama/deskripsi repo dibuat setelah pemeriksaan, bukan klaim repo sudah dibuat |

Aturan baca penuh merupakan pilihan eksplisit pemilik. Rekomendasi vendor
tentang pemuatan selektif dan keputusan putaran referensi sebelumnya tidak
menjadi pengecualian. File rahasia/generated dan isi arsip lokal bukan sumber
instruksi aktif; README arsip tetap termasuk bacaan.

Detail: [workflow](../rules/workflow.md#baca-lengkap),
[living documents](../rules/documentation.md#living-documents),
[panduan GitHub](GITHUB-WORKFLOW.md), [riset](SKILL-RESEARCH.md#publikasi),
[hasil audit](WORKSPACE.md#audit-publikasi), dan
[RTM](TRACEABILITY.md#workspace-publish-traceability).

<a id="workspace-audit-push-006"></a>

## 34. Audit final setup dan mandat push — 19 Oktober 2026

**WORKSPACE-AUDIT-PUSH-006 — CURRENT_USER_CONFIRMED.** Pemilik meminta
pemeriksaan seluruh setup, perbaikan sampai layak, lalu push menggunakan Git
Bash ke `https://github.com/muhammadrafifatihulihsan/siagabanjir.git`.
Rencana audit, perbaikan, dan publikasi disetujui pemilik proyek.
Mandat ini mencakup commit, penambahan remote tujuan,
push main dan perbaikan CI terkait; tidak mencakup tag, release, deploy,
perubahan visibilitas, identitas Git atau konfigurasi global.

| ID | Keputusan dan dasar |
|---|---|
| WS-DEC-025 | Perbaiki akar validator setelah pemindahan ke .github/scripts; parsing YAML nyata dan pemeriksaan cakupan mencegah PASS palsu |
| WS-DEC-026 | Jalankan EditorConfig, kunci versi alat, tambahkan regresi validator serta pemeriksaan contoh API pada CI; dependency ini hanya alat verifikasi workspace |
| WS-DEC-027 | Errata OpenAPI mengikuti SRS-IF-004: hapus replay 200 signup yang membawa recovery code; empat operasi rahasia mendokumentasikan konflik 409 aman. Respons 4XX menggunakan Error yang sudah ada |
| WS-DEC-028 | CredentialsUpdate memakai minProperties=2 bersama currentPassword wajib dan larangan field tambahan; kemampuan email/sandi tetap sama. Sebelas kasus kredensial dan dua contoh konflik menambah corpus menjadi 54. Definisi accountId pada kondisi QuotaReset diperjelas tanpa mengubah syarat scope, dengan regresi tersendiri |
| WS-DEC-029 | Pertahankan kondisi restrukturisasi yang ditemukan: archive/tools/contracts tidak tersedia; kontrak berada di docs. Seluruh archive/ diabaikan Git bila dibuat lagi. Tidak mengarang pemulihan arsip atau mengubah hasil audit lama |
| WS-DEC-030 | Pertahankan delapan skill dengan routing AGENTS, tanpa duplikasi/instalasi global atau penulisan .agents yang dilindungi. Lisensi All Rights Reserved dan versi baseline tetap |
| WS-DEC-031 | Normalisasi format/LF diperlukan agar gate CI berjalan; isi requirement, ID, kutipan historis dan status NOT_RUN produk dipertahankan. Git Bash dapat memakai safe.directory khusus path per perintah jika ownership sandbox berbeda |

Temuan awal: validator skill gagal menemukan folder, validator link hanya
memeriksa satu Markdown, YAML rusak diterima, 287 error Markdown, 103 laporan
EditorConfig, dan 74 peringatan Redocly. Replay rahasia adalah ketidaksesuaian
kontrak yang terbukti secara statis; tidak diklaim sebagai kebocoran runtime.
Hasil perbaikan: [audit final](WORKSPACE.md#audit-final),
[RTM](TRACEABILITY.md#workspace-audit-push-traceability), dan
[handoff](SESSION-HANDOFF.md). BRD/PRD/FRD/SRS tetap approved; audit ini tidak
membuat approval produk baru ataupun bukti aplikasi lulus.

<a id="workspace-editorial-release-007"></a>

## 35. Standardisasi dokumentasi dan rilis baseline — 19 Oktober 2026

**WORKSPACE-EDITORIAL-RELEASE-007 — CURRENT_USER_CONFIRMED.**
Pemilik mengotorisasi perapian seluruh dokumentasi, evaluasi kebutuhan konfigurasi,
pemeriksaan rules/skills, perbaikan, dan publikasi melalui Git Bash. Rilis pertama
ditetapkan sebagai v0.1.0 untuk baseline dokumentasi dan workspace.

| ID | Keputusan dan batas |
|---|---|
| WS-DEC-032 | Catatan percakapan diparafrasakan menjadi keputusan formal. ID, tanggal, otoritas, urutan dan cakupan persetujuan dipertahankan; penyuntingan tidak menambah persetujuan produk. Aturan ini menggantikan kewajiban menyimpan kutipan langsung pada dokumen aktif. |
| WS-DEC-033 | Informasi identitas repository digabung ke README/panduan GitHub. Rencana penyusunan SRS telah selesai melalui SRS-APPROVAL-01; berkas rencana terpisah dihapus. Riwayat isi tersedia melalui Git. |
| WS-DEC-034 | Delapan skill dan tujuh rules tetap digunakan. Aturan bersama dipusatkan, bacaan lengkap dan pembaruan living documents tetap wajib, tanpa instalasi bundel atau perubahan izin. |
| WS-DEC-035 | Redocly dipertahankan untuk validasi kontrak. Skema downloadMediaResponse yang tidak dirujuk dihapus dan pemeriksaan komponen tidak terpakai diaktifkan sebagai error. Unduh media tetap mengirim bytes; 72 operasi dan perilaku wire tidak berubah. |
| WS-DEC-036 | Workflow CI/rilis memakai action berbasis Node 24. Catatan rilis diambil dari entri CHANGELOG yang sesuai tag dan harus terisi sebelum publikasi. Versi alat validasi tetap dikunci. |
| WS-DEC-037 | Commit/push main diikuti pemeriksaan CI pada SHA yang sama; tag v0.1.0 dibuat setelah CI berhasil. Rilis memuat baseline dokumentasi tanpa APK, deploy, atau klaim aplikasi telah diuji. |

Perubahan LICENSE milik pemilik dipertahankan. Versi BRD/PRD v0.1.0 dan
FRD/SRS v1.0.0 tetap. Cakupan, keputusan produk, AC/TC, dan status NOT_RUN
implementasi tidak berubah. [Bukti pemeriksaan](WORKSPACE.md#audit-final) dan
[keterlacakan perubahan](TRACEABILITY.md#workspace-editorial-release-traceability)
memisahkan hasil validasi workspace dari pengujian produk.

<a id="workspace-release-close-008"></a>

## 36. Penutupan verifikasi dan publikasi v0.1.0 — 20 Oktober 2026

**WORKSPACE-RELEASE-CLOSE-008 — CURRENT_USER_CONFIRMED.**
Pemilik meminta kelanjutan sesi yang terhenti: pastikan workspace jelas dan
terverifikasi, perbaiki temuan, push melalui Git Bash yang sudah login, dan
terbitkan GitHub Release pertama. Rencana pelaksanaan disetujui pada sesi ini.

| ID | Keputusan dan batas |
|---|---|
| WS-DEC-038 | Kecualikan ekspor lokal codex-session-*.md dari validator tautan dan lint Markdown sesuai .gitignore. Dokumentasi aktif, termasuk SESSION-HANDOFF, tetap diperiksa; tambahkan regresi untuk batas ini. |
| WS-DEC-039 | Pertahankan v0.1.0 sebagai rilis dokumentasi/workspace. Gunakan tanggal publikasi aktual pada CHANGELOG; tag dibuat pada commit yang seluruh pekerjaan CI-nya berhasil. Catat SHA, CI, tag dan hasil workflow rilis sebelum penutupan. |
| WS-DEC-040 | Hapus hanya ekspor session lokal yang telah dibaca setelah publikasi dan commit penutupan terverifikasi di GitHub. Handoff aktif dan riwayat keputusan tetap dipelihara. |

Mandat ini tidak mengubah approval spesifikasi, requirement produk, maupun
status tes aplikasi. [Bukti](WORKSPACE.md#audit-release-close) dan
[keterlacakan](TRACEABILITY.md#workspace-release-close-traceability) mencatat
hasil aktual tanpa mengubah pemeriksaan yang belum dijalankan menjadi PASS.

<a id="workspace-local-commit-009"></a>

## 37. Commit lokal otomatis oleh AI dan panduan tim — 20 Oktober 2026

**WORKSPACE-LOCAL-COMMIT-009 — CURRENT_USER_CONFIRMED.**
Pemilik meminta AI selalu membuat commit lokal untuk perubahan sekecil apa pun
tanpa menunggu konfirmasi, menjaga working tree bersih sebelum unit berikut atau
penutupan tugas/sesi, menjelaskan kemungkinan kendala untuk teman yang belum
mengenal Git/GitHub, dan push pembaruan setelah terverifikasi.

Ketentuan berikut menerapkan mandat tersebut dengan menjaga pekerjaan tim dan
batas akses; bukan persetujuan produk baru.

| ID | Keputusan dan batas pelaksanaan |
|---|---|
| WS-DEC-041 | Semua perubahan AI dalam mandat, termasuk typo, dicommit lokal per unit utuh setelah review/pemeriksaan. Tidak perlu konfirmasi baru; tugas baca tanpa diff tidak membuat commit kosong. |
| WS-DEC-042 | Gerbang penutupan/unit berikut memeriksa status Git yang berhasil tanpa keluaran, termasuk file untracked. Perubahan milik orang lain/rahasia dan kendala Git dilaporkan BLOCKED; tidak dibuang, disembunyikan, atau ikut dicommit demi clean. Checkpoint WIP lokal hanya untuk penghentian terencana sesuai workflow, bukan hasil selesai. |
| WS-DEC-043 | Push/merge/tag/release/deploy tetap mengikuti mandat tersendiri. Pertahankan riwayat commit kecil; jangan otomatis amend/squash/rebase/force push. Preferensi penggabungan PR mempertahankan commit bila kebijakan repository mengizinkan. |
| WS-DEC-044 | Instruksi utama, workflow, adapter dan panduan pemula dirujuk bersama. Tidak memasang hook, mengubah Git identity/global config, proteksi branch, atau izin untuk menerapkan aturan ini. Kepatuhan semua IDE tidak diklaim telah diuji. |

Prosedur ada pada [workflow](../rules/workflow.md#commit-lokal), contoh dan
kendala pada [panduan tim](GITHUB-WORKFLOW.md#mulai-untuk-tim), dan hasil
pemeriksaan pada [WORKSPACE](WORKSPACE.md#commit-lokal-tim).

<a id="workspace-github-workflow-010"></a>

## 38. Audit dan alur lima branch permanen — 21 Oktober 2026

**WORKSPACE-GITHUB-WORKFLOW-010 — CURRENT_USER_CONFIRMED.**
Pemilik meminta melanjutkan riwayat sesi dan prompt audit di root, kemudian
menyetujui: “Ya, implementasikan dan push CI/dokumentasi”. Persetujuan mencakup
branch-rafi setelah audit; Settings/ruleset tetap memerlukan persetujuan terpisah.

| ID | Keputusan dan batas |
|---|---|
| WS-DEC-045 | Ganti arah historis DEC-036/CON-008/Q-014: satu repo, branch-rafi/branch-melia/branch-hasan → PR development → PR main. Lima branch tetap, satu PR aktif per branch anggota. Rafi meninjau dan merge memakai merge commit; tidak hapus branch permanen. |
| WS-DEC-046 | Terapkan CI pada push kelima branch dan PR kedua base termasuk retarget. Validasi pasangan head/base dan repository yang sama; checkout tidak menyimpan credential. Tambahkan regresi serta template tugas/PR. |
| WS-DEC-047 | Audit read-only lebih dahulu sudah dilaksanakan; persetujuan berikutnya mengizinkan perubahan CI/dokumentasi, commit dan push branch-rafi. Tidak mengotorisasi merge, Settings, undangan, tag/release atau deploy. |
| WS-DEC-048 | SOP/nama branch/check CI bukan isolasi akun atau bukti owner-only merge. Rancangan ruleset berlapis, kasus PR owner dan proteksi tag memerlukan persetujuan serta uji terpisah. Tidak menambahkan CODEOWNERS yang berpotensi mengunci PR owner. |

BR-036/AC-036 dan aspek Git PRD-NF-008 diperbarui oleh mandat ini; versi baseline
dan approval produk tetap, riwayat keputusan lama dipertahankan. [Audit](GITHUB-AUDIT.md)
memuat fakta awal, rancangan dan keterbatasan. [Bukti](WORKSPACE.md#github-workflow-audit)
dan [RTM](TRACEABILITY.md#workspace-github-workflow-traceability) mengikuti hasil aktual.

## 39. Main lokal untuk panduan ringkas - 21 Oktober 2026

**WS-DEC-049 - CURRENT_USER_CONFIRMED.** Pemilik meminta satu TXT berisi
perintah langsung dan bekerja di main lokal. [GIT-CEPAT.md](GIT-CEPAT.md)
menggunakan clone branch anggota lalu rename lokal; upstream anggota tetap.
Push memakai refspec main:branch-anggota. Arah PR pada WS-DEC-045 tetap berlaku
untuk branch GitHub; mandat ini tidak mengizinkan direct push remote main.

## 40. Penyegaran lokal dari main - 21 Oktober 2026

**WS-DEC-050 - CURRENT_USER_CONFIRMED.** Pemilik meminta contoh TXT untuk
mengganti isi kerja lokal dengan main terbaru. Sesudah semua pekerjaan masuk
main melalui PR, contoh memakai fetch, reset --hard origin/main dan clean -fd.
Perubahan lokal dan untracked dibuang; ignored dipertahankan. Ini pengecualian
eksplisit untuk prosedur pengguna pada TXT, bukan izin AI membersihkan workspace
demi status bersih. Tidak mengotorisasi force push atau perubahan alur PR.

<a id="flutter-feature-first-051"></a>

## 41. Struktur Flutter per fitur - 23 Oktober 2026

**WS-DEC-051 - CURRENT_USER_CONFIRMED.** Pemilik meminta riset dan struktur
Feature-First + Layered Architecture untuk membagi pekerjaan tim bertiga,
memilih cakupan warga Android dan admin Web, lalu meminta implementasi rencana.
Mandat hanya folder dan panduan Flutter; backend dan implementasi fitur ditunda.

Satu package apps/app dipertahankan. Setiap fitur memiliki presentation, domain,
dan data; app merakit dependensi, core menampung infrastruktur, shared menampung
UI bersama. Controller tetap ChangeNotifier/ValueNotifier sesuai SRS-DEC-009.
Domain menampung model/kontrak Dart murni; use case hanya ketika diperlukan.
Batas dan daftar fitur menjadi sumber operasional di [README Flutter](../apps/siagabanjir/README.md).

Placeholder .gitkeep mencatat folder di Git. Source counter, tes bawaan,
manifest/dependensi dan platform tidak diubah. Penataan tidak mengubah API,
requirement, atau penerimaan TC produk. Commit lokal termasuk mandat tetap;
push, merge, dan deploy tidak termasuk tugas ini.

<a id="home-mockup-052"></a>

## 42. Mockup beranda warga dari SVG - 23 Oktober 2026

**WS-DEC-052 - CURRENT_USER_CONFIRMED.** Pemilik meminta satu beranda Flutter
mengikuti app_beranda.svg sebagai contoh penghubung fitur, dengan ikon hasil
slice/aset lokal dan interaksi mockup; tidak mencakup backend atau layar fitur
lengkap. Pemilik mengizinkan bacaan ulang terbatas untuk tugas beranda ini
ke instruksi, desain/UI, Flutter, requirement beranda dan kode terdampak.
Bacaan penuh tugas struktur sebelumnya tetap menjadi konteks.

Fitur home/presentation ditambahkan tanpa repository/controller bisnis kosong.
Navigasi panel dirakit di app; angka sumber tetap ilustrasi berlabel Data contoh.
Teks menjadi widget, 17 ikon diekstrak dari sumber, dan font tetap bawaan.
DESIGN/rule UI/skill UI mencatat pengecualian aset dan token yang terarah.
Kebutuhan produk, level penilaian, kuota dan kontrak tidak berubah. Bukti ada
pada [WORKSPACE](WORKSPACE.md#home-mockup), asal aset pada
[catatan desain](../apps/siagabanjir/design/README.md). Tidak mengotorisasi push/deploy.

<a id="home-font-053"></a>

## 43. Font lokal dan teks beranda - 23 Oktober 2026

**WS-DEC-053 - CURRENT_USER_CONFIRMED.** Pemilik meminta menghapus tulisan
Data contoh dan Mockup beranda, menyimpan font sebagai aset untuk konsistensi
perangkat, lalu memilih Inter lokal setelah dijelaskan bahwa SVG tidak
menyimpan nama font asli Figma. Inter 4.1 asli, weight 400/500/600/700/800,
dibundel bersama lisensi OFL; tema dan tes memakai aset tersebut.

Ini revisi tampilan atas WS-DEC-052. Data tetap statis; penghapusan label bukan
perubahan penerimaan fitur bisnis atau klaim data layanan. Penjelasan naming
membedakan folder, package Dart, nama launcher dan applicationId; tidak ada
rename pada revisi ini. Bukti: [WORKSPACE](WORKSPACE.md#home-local-font).

<a id="home-layout-name-054"></a>

## 44. Layout beranda dan nama aplikasi - 23 Oktober 2026

**WS-DEC-054 - CURRENT_USER_CONFIRMED.** Pemilik meminta inspeksi skill dan
perbaikan layout 3/3 berkas, Lapor Banjir serta keterbacaan masyarakat dewasa;
Inter lokal dipertahankan. Header/status, susunan teks dan badge dibuat adaptif.
Satu mockup dan batas data WS-DEC-052/053 tetap, tanpa backend.

Pemilik menetapkan SiagaBanjir sebagai nama tampilan dan meminta rename folder.
Folder apps/app menjadi apps/siagabanjir, package Dart menjadi siagabanjir,
label Android dan metadata Web menjadi SiagaBanjir. ApplicationId/namespace
Android dipertahankan agar tidak memutus identitas instalasi; lib/app dan
android/app tetap nama lapisan/modul teknis. Referensi aktif, import dan
pengecualian EditorConfig diselaraskan; path pada uraian historis tetap
merekam kondisi saat itu, sementara tautan menuju sumber saat ini.

Pemilik menyetujui bacaan terbatas ke skill, aturan, UI Flutter, konfigurasi
dan referensi nama/path terdampak. Commit lokal termasuk mandat; push tidak.
[Bukti pemeriksaan](WORKSPACE.md#home-layout-name) tidak menaikkan TC bisnis.

<a id="branding-startup-055"></a>

## 45. Ikon aplikasi dan splash - 23 Oktober 2026

**WS-DEC-055 - CURRENT_USER_CONFIRMED.** Pemilik meminta mengganti ikon bawaan
Flutter dengan ikon sendiri, memperbaiki splash, serta commit dan update
setiap perubahan. Logo tetes air dari SVG pemilik dipakai sebagai identitas
launcher Android/Web dan splash, dengan aset lokal tanpa package baru.

Android menyediakan legacy, adaptive/monochrome dan splash sebelum/sesudah
API 31. Web memakai Inter lokal dan bootstrap yang melepas splash ketika
aplikasi siap, dengan retry bila gagal; tidak menambahkan timer paksa.
Layout beranda, applicationId, backend dan kontrak tetap. Commit lokal
termasuk mandat, push/install perangkat/deploy tidak dilakukan.

<a id="report-create-ui-056"></a>

## 46. Desain halaman buat laporan - 25 Oktober 2026

**WS-DEC-056 - CURRENT_USER_CONFIRMED.** Pemilik meminta implementasi desain
Flutter halaman laporan dari reports_create.svg setelah pembacaan lengkap
workspace. Mandat mencakup tampilan dan navigasi lokal; tidak mencakup backend,
push, deploy atau perubahan baseline approved.

Halaman dibuka dari Lapor/Lapor Banjir Cepat. Kategori, kebutuhan dan deskripsi
interaktif lokal; header/ikon bersama dipindahkan ke shared/widgets. Adaptasi
implementasi menghilangkan klaim kamera terverifikasi, GPS aktual dan kirim
otomatis offline. Label opsional deskripsi tidak diterapkan karena baseline
mewajibkannya. Kategori/kebutuhan bukan penambahan field kontrak atau dispatch.
Pilihan awal mengikuti contoh desain, tanpa makna kebutuhan warga terverifikasi.
Bukti dan batas integrasi: [WORKSPACE](WORKSPACE.md#report-create-ui).

<a id="report-uiux-057"></a>

## 47. Penyelarasan UI/UX dan slicing laporan - 25 Oktober 2026

**WS-DEC-057 - CURRENT_USER_CONFIRMED.** Pemilik meminta pemeriksaan dan
pemaksimalan UI/UX laporan mengikuti prinsip home, komentar `// ...` untuk
menjelaskan fungsi bagian kode, serta slicing clean code sesuai program yang
sudah tersedia. Implementasi memisahkan widget per tugas dan memakai navbar
bersama. Komentar diterapkan per bagian bermakna, bukan mengulang sintaks.

Revisi menggantikan pilihan awal contoh pada WS-DEC-056 dengan pilihan kosong,
memperbesar teks pilihan, memberi indikator radio/checkbox/fokus, label input
menetap, ruang keyboard dan navigasi tab aktif yang konsisten. Perisai hijau
diganti informasi netral. Mandat tidak mencakup integrasi API/perangkat/push.
[Bukti](WORKSPACE.md#report-uiux-refinement) membedakan tes UI dari TC bisnis.

<a id="messages-inbox-ui-058"></a>

## 48. Desain kotak masuk pesan peringatan siaga - 25 Oktober 2026

**WS-DEC-058 - CURRENT_USER_CONFIRMED.** Pemilik meminta fokus pada implementasi
desain Flutter untuk halaman kotak masuk pesan dari messages_inbox.svg yang
diserahkan. Mandat mencakup UI lokal, slicing widget, dan integrasi navigasi
notifikasi; tidak mencakup integrasi push notification, backend, atau klaim
panggilan darurat nyata.

Implementasi menghasilkan MessagesInboxScreen di lib/features/messages/presentation
yang terhubung dari tombol notifikasi pada CitizenHeader di beranda dan halaman laporan.
UI mencakup header dengan tombol kembali dan badge jumlah pesan baru, tab filter
horizontal pill (Semua, Darurat, Cuaca BMKG, Posko), kartu peringatan dengan aksen
garis warna semantik vertikal di sisi kiri, instansi pengirim, judul, deskripsi,
serta tombol aksi (Rute Evakuasi, Bagikan, Hubungi Posko) yang membuka dialog
penjelasan simulasi demo akademik. Navigasi bawah memakai CitizenNavigation bersama.
Bukti dan batas implementasi: [WORKSPACE](WORKSPACE.md#messages-inbox-ui).

<a id="emergency-bag-ui-059"></a>

## 49. Desain checklist tas siaga bencana - 26 Oktober 2026

**WS-DEC-059 - CURRENT_USER_CONFIRMED.** Pemilik meminta fokus pada Flutter untuk
mengimplementasikan desain checklist tas siaga dari `emergency_bag_checklist.svg`
yang diserahkan dari direktori Downloads. Mandat mencakup pembangunan UI lokal,
pemodelan data domain barang, widget interaktif checklist, dan integrasi rute
pada tombol akses cepat "Tas Siaga" di beranda. Mandat tidak mencakup integrasi
backend sinkronisasi akun atau cloud storage.

Implementasi menghasilkan:
- Domain `EmergencyBagItem` dan `EmergencyBagCategory` di `lib/features/emergency_bag/domain`
  dengan 14 item default yang tepat mereproduksi kondisi awal desain (12 dari 14 barang tercentang, 85%).
- UI `EmergencyBagScreen` di `lib/features/emergency_bag/presentation`:
  - `EmergencyBagHeader`: tombol kembali aksesibel (target sentuh 48) dan judul "Tas Siaga Bencana".
  - `EmergencyBagSummaryCard`: kartu ringkasan kemajuan kesiapan logistik keluarga dengan
    badge persentase dinamis, penghitung jumlah barang tercentang, progress bar, dan keterangan kesiapan 3 hari.
  - `EmergencyBagCategoryCard`: empat kategori (Dokumen Berharga, Obat & P3K Keluarga, Logistik & Komunikasi,
    Pakaian & Perlengkapan) dengan checkbox kustom rounded, transisi status visual, serta pembaruan progres kategori.
  - `EmergencyBagInfoBanner`: banner himbauan penempatan tas siaga di dekat pintu utama.
  - Navigasi bawah menggunakan `CitizenNavigation` bersama yang terhubung kembali ke beranda, laporan, riwayat, dan profil.
Bukti dan batas implementasi: [WORKSPACE](WORKSPACE.md#emergency-bag-ui).
