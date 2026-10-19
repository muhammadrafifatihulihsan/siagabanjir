# SIAGABANJIR — Register Bukti dan Ketertelusuran

> **Living document:** perbarui bersama setiap perubahan terkait menurut [aturan dokumentasi](../rules/documentation.md#living-documents).

Versi: **0.1.0**\
Status: **Register lintas tahap — BRD/PRD 0.1.0 dan FRD/SRS 1.0.0 APPROVED; tahap 5 panduan workspace; kondisi terbaru pada §44**\
Tanggal pencatatan: **19 Oktober 2026**\
Dokumen terkait: [BRD.md](BRD.md), [PRD.md](PRD.md), [DECISIONS.md](DECISIONS.md), dan [FRD.md](FRD.md).

Dokumen ini mencatat sumber yang tersedia, jawaban pengguna, status konfirmasi, dan hubungan kebutuhan dengan bukti. Instruksi awal **“Implement the plan.”** hanya mengizinkan penyusunan draft tahap 1. Setelah walkthrough diajukan, pengguna menyatakan **“OKE SUDAH GOOD BRD NYA, SEKARANG LANJUT KE STEP LANGKAH SELANJUTNYA.”** Pernyataan berikutnya itu menyetujui BRD 0.1.0 dan mengizinkan tahap 2. Secara historis, discovery PRD dan izin rencana tahap 2 hanya mendasari draft. Persetujuan terbaru menutup PRD v0.1.0 dan mengizinkan draf FRD; lihat [PRD-APPROVAL-01](DECISIONS.md#prd-approval-01). Sumber perencanaan lama tetap berada di lokasi asal dan tidak diubah.

**Status historis:** catatan draf/pertanyaan/riset di bawah mempertahankan waktu pencatatannya. Status final mengikuti [penutupan v1.0.0](#frd-finalization-trace), bukan status terbuka pada putaran lama.

**Kondisi workspace terbaru:** lihat [§44](#workspace-audit-push-traceability). Auditor
dan perintah pemeriksaan pada catatan tahap lama adalah riwayat; berkasnya
tidak tersedia dalam workspace publik. Jangan menjalankannya langsung pada
struktur workspace baru; validator aktif ada pada .github/scripts/.

## 1. Cara membaca register

- **FACT_INSPECTED**: fakta berkas, tampilan statis, atau hasil pemeriksaan yang benar-benar diamati dalam sesi ini. Bukan bukti aplikasi telah berjalan.
- **RAW_SOURCE**: isi paket perencanaan lama. Kata “final”, “wajib”, “terverifikasi”, atau “disetujui” di dalam paket tidak otomatis menjadi keputusan sesi sekarang.
- **CURRENT_USER_CONFIRMED**: arah yang dikonfirmasi pengguna dalam percakapan sekarang. Ini tidak membuktikan klaim objektif seperti akurasi AI atau nomor layanan aktif.
- **CONFIRMED_DIRECTION**: keputusan arah sudah memiliki jawaban pengguna, tetapi semua lapisan konfirmasi dan penerimaan akhir dokumen belum tentu selesai.
- **DELEGATED_DEFAULT**: pengguna menyerahkan pilihan rutin dalam batas yang disebutkan; pilihan kerja dicatat agar dapat ditinjau.
- **PROPOSED_REFINEMENT**: rincian yang diusulkan untuk memperjelas arah; belum boleh ditulis sebagai keputusan final pengguna.
- **OPEN**: belum diputuskan atau bukti belum cukup. **SUPERSEDED**: jawaban atau kandidat lama diganti oleh jawaban berikutnya.

ID `Q-001`–`Q-031` adalah indeks percakapan tahap 1. **Q-001–Q-028 dijawab; Q-029–Q-031 ditutup oleh persetujuan kolektif BRD, bukan jawaban individual atas opsi.** Catatan jawaban berupa ringkasan makna kecuali ditandai kutipan. `ST-001`–`ST-042` selaras dengan `BR-001`–`BR-042`, `DEC-001`–`DEC-042`, dan `AC-001`–`AC-042` pada baseline BRD. Tahap 2 menggunakan namespace terpisah `PRD-Q001`–`PRD-Q043`, `PRD-CL001`–`PRD-CL085`, dan `PRD-DEC-001`–`PRD-DEC-043`. Kriteria AC adalah rencana penerimaan; keberadaannya tidak berarti pengujian lulus.

## 2. Inventaris sumber fisik

Alias lokasi digunakan hanya untuk mempersingkat tabel:

| Alias | Lokasi absolut |
|---|---|
| `PROMPTS` | `C:\Users\Pongo\Desktop\Belajar\prompting-setup` |
| `PAKET` | `C:\Users\Pongo\Desktop\kuliah\Semester 5\Pemrograman Berbasis Platform\Minggu 6\SIAGABANJIR-PAKET-PRA-CODING-v2.0` |
| `MODUL` | `PAKET\SIAGABANJIR-PRECODING-v2.0` |
| `DESAIN` | `PAKET\design(notfixbutthemewillbelikethis)` |
| `HASIL` | `C:\Users\Pongo\Desktop\Belajar\project-kuliah-izin-serius\Newfolder\docs` |

Inventaris fisik yang diperiksa: **5 berkas prompt dan 36 berkas paket**, yaitu 1 master, 14 modul bernomor 00–13, 1 daftar referensi, 1 ERD, 2 CSV, dan 17 SVG. Tidak ada klaim bahwa berkas asli yang hanya disebut dalam paket ikut tersedia.

### 2.1 Prompt proses

| ID | Berkas relatif terhadap PROMPTS | Cakupan pemeriksaan dan penggunaan |
|---|---|---|
| SRC-P01 | `1.PROMPT_BRD.md` | Dibaca oleh agen utama untuk tahap 1; sumber aturan investigasi dan konfirmasi. Tahap 1 kemudian diterima pengguna. |
| SRC-P02 | `2.PROMPT_PRD.md` | Dibaca seluruhnya, 977 baris, dan dibaca ulang seluruhnya saat memulai tahap 2. Menjadi prosedur aktif discovery dan draft PRD. |
| SRC-P03 | `3.PROMPT_FRD.md` | Dibaca seluruhnya, 875 baris; memahami urutan dan ketergantungan tahap 3. Belum dijalankan. |
| SRC-P04 | `4.PROMPT_SRS.md` | Dibaca seluruhnya, 728 baris; memahami urutan dan ketergantungan tahap 4. Belum dijalankan. |
| SRC-P05 | `5.PROMPT_WORKSPACE_SETUP.md` | Dibaca seluruhnya, 1.422 baris; memahami batas setup sesudah BRD/PRD/FRD/SRS. Belum dijalankan. |

Pembacaan prompt sendiri tidak mengizinkan melompati tahap. Tahap 2 diaktifkan setelah persetujuan BRD. Kini PRD-APPROVAL-01 menyetujui penutupan PRD dan pembuatan draf FRD; prompt nomor 3 dibaca kembali untuk tahapnya. SRS, kode, setup, Docker, dan repository belum dikerjakan. Detail prosedur tahap berikutnya tidak menjadi kebutuhan produk hanya karena terdapat dalam prompt.

### 2.2 Dokumen, model, dan CSV paket

Seluruh berkas pada tabel ini tersedia dan telah diperiksa dalam audit tim. Isi produknya tetap **RAW_SOURCE** sampai dihubungkan dengan jawaban sekarang. Audit tim tidak berarti setiap agen membaca ulang seluruh berkas secara mandiri.

| ID | Lokasi dan nama aktual | Fungsi sumber |
|---|---|---|
| SRC-MASTER | `PAKET\SIAGABANJIR-MASTER-PRA-CODING-v2.0.md` | Kompilasi perencanaan; bukan persetujuan final sesi sekarang. |
| SRC-M00 | `MODUL\00-README-DAN-STATUS.md` | Status paket dan petunjuk baca. |
| SRC-M01 | `MODUL\01-PRD-BRD-RUANG-LINGKUP.md` | Tujuan, aktor, cakupan, dan batas awal produk. |
| SRC-M02 | `MODUL\02-FRD-PER-LAYAR-DAN-ALUR.md` | Kandidat layar dan alur. |
| SRC-M03 | `MODUL\03-MODEL-DATA-DAN-KONTRAK-API.md` | Kandidat entitas dan kontrak API; belum menjadi SRS baru. |
| SRC-M04 | `MODUL\04-ALGORITMA-AI-KLASTER-PRIORITAS.md` | Batas AI, pengelompokan, prioritas, dan parameter eksperimental. |
| SRC-M05 | `MODUL\05-FITUR-PENDUKUNG-LENGKAP.md` | Kandidat fitur pendukung. |
| SRC-M06 | `MODUL\06-ARSITEKTUR-KEAMANAN-DAN-NFR.md` | Kandidat arsitektur, keamanan, worker, dan kebutuhan nonfungsional. |
| SRC-M07 | `MODUL\07-TEST-PLAN-DAN-ACCEPTANCE.md` | Kandidat skenario uji; bukan hasil uji aplikasi sekarang. |
| SRC-M08 | `MODUL\08-SETUP-ROADMAP-DAN-GATE.md` | Roadmap lama dan gerbangnya. |
| SRC-M09 | `MODUL\09-REGISTER-DATA-SUMBER-DAN-KLAIM.md` | Register klaim, data simulasi, dan batas verifikasi lama. |
| SRC-M10 | `MODUL\10-DECISION-REGISTER.md` | Keputusan dalam konteks paket lama; perlu dicocokkan dengan sesi sekarang. |
| SRC-M11 | `MODUL\11-AUDIT-ASET-DAN-TRACEABILITY.md` | Audit aset dan matriks layar lama. |
| SRC-M12 | `MODUL\12-CHECKLIST-CEPAT-PRA-SETUP.md` | Checklist lama, bukan bukti checklist setup sekarang telah lulus. |
| SRC-M13 | `MODUL\13-QA-REPORT.md` | Laporan QA paket; berkas terpisah dari kompilasi master. |
| SRC-REF | `MODUL\references.md` | Daftar rujukan paket; keberadaan tautan tidak sama dengan revalidasi saat ini. |
| SRC-ERD | `MODUL\DOMAIN-ERD-KONSEPTUAL.mmd` | ERD konseptual lama, belum menjadi skema database yang disetujui. |
| SRC-CSV01 | `MODUL\manifest_svg.csv` | Manifest nama dan metadata SVG. |
| SRC-CSV02 | `MODUL\traceability_layar.csv` | Pemetaan layar lama; bagian sungai/posko telah terkena perubahan cakupan. |

Audit perbandingan teks tim menemukan bagian dokumen sumber yang disematkan dalam master sama setelah normalisasi pembungkus format; master tidak dihitung sebagai kebutuhan tambahan yang independen. Modul QA 13 tersedia terpisah. Konflik keputusan selalu diselesaikan melalui jawaban terbaru, bukan dengan menghitung berapa kali pernyataan lama muncul.

### 2.3 Desain yang benar-benar tersedia

Seluruh nama di bawah relatif terhadap `DESAIN`. Metadata dan hash sumber dibandingkan dengan manifest oleh audit desain. Seluruh 17 SVG dirender ke PNG sementara untuk inspeksi; 12 layar warga dilihat agen utama dan 5 layar admin dilihat agen audit desain. Statusnya **FACT_INSPECTED untuk tampilan statis**, bukan kelulusan interaksi, responsivitas, aksesibilitas, atau implementasi aplikasi.

| ID | Nama aktual | Perlakuan pada draft sekarang |
|---|---|---|
| SRC-SVG01 | `hifi_beranda 1.svg` | Referensi tema dan navigasi; informasi sungai/posko lama tidak diwariskan. |
| SRC-SVG02 | `hifi_lapor 1.svg` | Referensi pelaporan; aturan media mengikuti Q-018–Q-022. |
| SRC-SVG03 | `hifi_pantau 1.svg` | Referensi visual; makna Pantau diganti menjadi daftar lokasi berlaporan. |
| SRC-SVG04 | `hifi_tassiaga 1.svg` | Kandidat checklist tas siaga. |
| SRC-SVG05 | `hifi_kontak 1.svg` | Kandidat kontak darurat; nomor pada mockup bukan nomor aktif terverifikasi. |
| SRC-SVG06 | `hifi_panduan 1.svg` | Kandidat panduan dan suara. |
| SRC-SVG07 | `hifi_riwayat 1.svg` | Kandidat riwayat warga; mengikuti penghapusan dan penyelesaian baru. |
| SRC-SVG08 | `hifi_dokumen 1.svg` | Kandidat backup dokumen. |
| SRC-SVG09 | `hifi_peringatan 1.svg` | Kandidat peringatan dan inbox. |
| SRC-SVG10 | `hifi_profil 1.svg` | Kandidat profil warga. |
| SRC-SVG11 | `hifi_login 1.svg` | Kandidat login warga. |
| SRC-SVG12 | `hifi_register 1.svg` | Kandidat registrasi warga. |
| SRC-SVG13 | `admin_dashboard 1.svg` | Referensi tema admin; statistik dan operasi mockup bukan fakta operasional. |
| SRC-SVG14 | `admin_wilayah_prioritas 1.svg` | Kandidat pengelompokan, bukti, dan prioritas admin. |
| SRC-SVG15 | `admin_laporan 1.svg` | Kandidat tinjauan laporan dan AI. |
| SRC-SVG16 | `admin_posko 1.svg` | Aset tersedia, tetapi fitur posko dikeluarkan dari cakupan sekarang. |
| SRC-SVG17 | `admin_profil 1.svg` | Kandidat profil admin. |

Temuan aset: **12 layar warga + 5 layar admin = 17 SVG**. Teks pada ekspor berbentuk path; aset tersebut tidak membuktikan tersedianya teks desain yang dapat diedit normal. Beberapa SVG memuat gambar raster. Warna dan arah tema biru dapat dijadikan acuan; angka, label, fitur, atau perilaku di mockup tetap harus dinilai terpisah. File PNG sementara untuk inspeksi bukan aset aplikasi final dan tidak disalin ke hasil tahap 1.

### 2.4 Sumber yang disebut, tetapi tidak tersedia dalam folder paket yang diperiksa

| ID | Sumber yang disebut | Status dan batas penggunaan |
|---|---|---|
| ABS-001 | `dokumentasi-proyek-banjir-v1.3.md` | Disebut oleh SRC-REF/SRC-M11; berkas asli tidak ada dalam inventaris paket ini. Tidak diklaim dibaca langsung. |
| ABS-002 | `SiagaBanjir-PemrogramanBerbasisPlatform.zip` | Disebut sebagai sumber audit lama; ZIP asli tidak tersedia dalam paket ini. SVG hasil ekstrak tersedia dan diperiksa langsung. |
| ABS-003 | `SIAGABANJIR-v1.7-ALGORITMA-DAN-ADMIN-REVIEW.md` | Disebut SRC-REF; berkas asli tidak tersedia dalam paket ini. Algoritma dinilai melalui SRC-M04 yang tersedia. |
| ABS-004 | `admin_login.svg` | Disebut audit lama, tetapi tidak tersedia. Tidak dibuat seolah ada. |
| ABS-005 | `admin_posko_sungai.svg` | Disebut audit lama, tetapi tidak tersedia; fitur sungai/posko juga dikeluarkan sekarang. |
| ABS-006 | Sumber HTML/Figma asli dan interaksi desain | Tidak disertakan dalam inventaris. SVG tidak membuktikan perilaku interaktif sumber aslinya. |

“Tidak tersedia” di sini terbatas pada lokasi yang diberikan dan inventaris yang diperiksa, bukan klaim bahwa berkas tersebut tidak pernah ada di komputer atau layanan lain. Ketidaktersediaannya dicatat tanpa menghalangi draft kerja berbasis sumber yang ada.

## 3. Bukti percakapan dan pemeriksaan tambahan

| ID | Bukti | Klasifikasi dan batas |
|---|---|---|
| CONV-01 | Instruksi awal membaca kedua lokasi, bertanya saat belum jelas, bekerja sesuai nomor, dan memberi ringkasan setiap nomor | CURRENT_USER_CONFIRMED; dasar proses tahap 1–5. |
| CONV-02 | Jawaban Q-001–Q-028 | CURRENT_USER_CONFIRMED sesuai cakupan setiap jawaban; tidak seluruh jawaban merupakan persetujuan rumusan final. |
| PLAN-01 | Rencana tahap 1 yang dipaparkan setelah klarifikasi | Rencana kerja yang menjadi sasaran perintah implementasi; rincian usulan tetap dilabeli. |
| USER-IMPLEMENT | “Implement the plan.” | Izin membuat draft kerja BRD dan register dalam `HASIL`; bukan final signoff dan bukan izin melompati tahap. |
| RES-01 | Riset dokumentasi resmi DeepSeek selama sesi, 18 Oktober 2026 | [Dokumentasi utama](https://api-docs.deepseek.com/), [Vision](https://api-docs.deepseek.com/guides/vision/), dan [JSON mode](https://api-docs.deepseek.com/guides/json_mode/) dibuka saat riset. Dokumentasi menunjukkan contoh Node/Python dan dukungan gambar/multi-image; JSON dapat kosong. Model persis belum dipin. Tidak ada panggilan API berbayar atau pengukuran kualitas AI aplikasi. |
| RES-02 | Riset arsitektur TypeScript dibanding TypeScript + Python | Dokumentasi resmi dibaca dalam sesi, antara lain [FastAPI background tasks](https://fastapi.tiangolo.com/tutorial/background-tasks/), [konsep deployment FastAPI](https://fastapi.tiangolo.com/deployment/concepts/), [Python venv](https://docs.python.org/3/library/venv.html), dan [ffprobe](https://ffmpeg.org/ffprobe.html). Mendukung pembahasan proses worker, biaya dua ekosistem, dan media CLI; bukan benchmark bahasa untuk aplikasi ini. |
| RES-03 | Riset kebutuhan geospasial dan Python | [DBSCAN](https://scikit-learn.org/stable/modules/generated/sklearn.cluster.DBSCAN.html) dan [GeoPandas spatial indexing](https://geopandas.org/en/v1.1.0/docs/user_guide/spatial_indexing.html) dibaca. DBSCAN tidak otomatis menggantikan aturan diameter/waktu/koreksi admin pada SRC-M04. Tidak ada algoritma final atau ambang produksi yang disahkan. |
| RES-04 | Riset alur GitHub | [GitHub flow](https://docs.github.com/en/get-started/using-github/github-flow), [PR dari fork](https://docs.github.com/en/pull-requests/how-tos/create-pull-requests/creating-a-pull-request-from-a-fork), dan [sinkronisasi fork](https://docs.github.com/en/pull-requests/how-tos/work-with-forks/syncing-a-fork) dibaca sebelum Q-014. Tidak ada repository, fork, branch protection, atau PR yang dibuat. |
| OBS-01 | Percobaan media lokal oleh agen utama | Node **24.15** dengan FFmpeg/ffprobe **9.0.2** memeriksa sampel H.264 sintetis 5,0 dan 5,1 detik, mengekstrak 5 JPEG, dan memeriksa roundtrip base64. Berhasil untuk sampel tersebut. Bukan uji perangkat nyata, seluruh codec, aturan media aplikasi, atau kualitas AI; 5 frame percobaan bukan default produk. |
| OBS-02 | Audit seluruh desain statis oleh tim | Seluruh 17 SVG dirender dan ditinjau sebagaimana §2.3. Tidak menguji aplikasi interaktif. |

Daftar di atas mencatat riset yang benar-benar dilakukan sebelumnya dalam sesi. Penyusunan register ini tidak melakukan revalidasi web tambahan dan tidak mengadopsi seluruh klaim “terverifikasi” di SRC-REF. Nomor kontak aktif, data lapangan, kemampuan model pada banjir, biaya nyata per laporan, dan klaim legal tetap memerlukan bukti tersendiri.

## 4. Register pertanyaan dan jawaban tahap 1

### Q-001

**Topik:** sasaran proyek. **Jawaban:** demo untuk kebutuhan kuliah didahulukan. **Dampak:** BR-001; tidak disamakan dengan layanan tanggap darurat operasional. **Status:** CONFIRMED_DIRECTION.

### Q-002

**Topik:** kedudukan desain lama. **Jawaban:** tema dan kandidat fitur dijadikan acuan. **Dampak:** BR-037; desain tidak menjadi kontrak pixel-perfect atau persetujuan otomatis seluruh isi mockup. **Status:** CONFIRMED_DIRECTION.

### Q-003

**Topik:** lokasi hasil kerja. **Jawaban:** hasil disusun pada `Newfolder/docs`. **Dampak:** lokasi tiga dokumen tahap 1; sumber mentah tetap di lokasi asal. **Status:** CONFIRMED_DIRECTION, ditegaskan oleh USER-IMPLEMENT untuk draft kerja.

### Q-004

**Topik:** alur utama. **Jawaban:** ya untuk laporan → AI menilai kesesuaian bukti → kelompok laporan → prioritas admin. **Dampak:** BR-004, BR-006, BR-007, BR-008. **Status:** CONFIRMED_DIRECTION; rumus dan rincian fallback belum final.

### Q-005

**Topik:** tindakan admin. **Jawaban:** tinjauan/koreksi dan tindak lanjut sederhana diperlukan; dispatch tidak termasuk. **Dampak:** BR-009, BR-010. **Status:** CONFIRMED_DIRECTION; daftar status tindak lanjut perlu dirinci di tahap berikutnya.

### Q-006

**Topik:** fitur pendukung. **Jawaban:** pendukung tetap wajib, inti dikerjakan dahulu; Pantau sungai diganti daftar wilayah terdampak; posko dihapus dari cakupan. **Dampak:** BR-021–BR-026, BR-028, BR-029. **Status:** CONFIRMED_DIRECTION; kehadiran pendukung dikonfirmasi, seluruh rincian legacy belum otomatis disetujui.

### Q-007

**Topik:** cara menyajikan lokasi terdampak. **Jawaban:** pengguna menyerahkan pilihan yang paling mudah dan sederhana. **Usulan yang mengikuti:** memakai kelompok laporan sebagai sumber daftar lokasi. **Dampak:** BR-016. **Status:** DELEGATED_DEFAULT untuk penyederhanaan mekanisme; makna tampilannya diperjelas Q-008–Q-010.

### Q-008

**Topik:** gerbang penayangan Pantau. **Jawaban:** langsung tampil dari AI dan perhitungan; tinjauan admin menjadi pemeriksaan tambahan. **Dampak:** BR-017, BR-019. **Status:** CONFIRMED_DIRECTION; tidak menunggu review admin untuk dapat tampil, tetapi hasil otomatis tidak menjadi informasi resmi terverifikasi.

### Q-009

**Topik:** lokasi tanpa laporan. **Jawaban:** hanya lokasi yang memiliki laporan yang masuk daftar; lokasi tanpa laporan tidak tampil. **Dampak:** BR-016. **Status:** CONFIRMED_DIRECTION; tidak adanya baris tidak boleh diterjemahkan sebagai bukti wilayah aman.

### Q-010

**Topik:** isi daftar Pantau dan arti langganan. **Jawaban awal:** ya pada daftar sederhana berisi nama lokasi, tingkat, waktu, dan badge. **Koreksi:** “langganan” yang dimaksud adalah menghindari kewajiban layanan pihak ketiga berbayar untuk pengembangan, bukan berlangganan area/wilayah oleh pengguna. **Dampak:** BR-016, BR-019, BR-035. **Status:** CONFIRMED_DIRECTION; tafsir subscription wilayah SUPERSEDED dan tidak ditambahkan sebagai fitur.

### Q-011

**Topik:** konteks tim, platform, lingkungan, dan jadwal. **Jawaban:** wilayah Padang; Flutter Android warga dan Flutter Web admin; pemilik menangani backend, AI, dan pemeliharaan; teman menangani Flutter/integrasi API; Laragon 6 + MySQL wajib; hosting belum wajib, Docker dipersiapkan; tidak ada deadline keras, 1–3 bulan hanya perkiraan. **Kandidat saat itu:** total anggota masih ambigu, empat branch permanen diusulkan, TypeScript + Python masih dipertimbangkan, dan maksud AI “unlimited” belum jelas. **Dampak:** BR-001–BR-003, BR-030, BR-034, BR-041. **Status:** arah konteks CONFIRMED_DIRECTION; ambiguitas/kandidat tersebut diselesaikan Q-012–Q-015, bukan dianggap telah disetujui pada Q-011.

### Q-012

**Topik:** jumlah anggota. **Jawaban:** total tiga orang, yaitu pemilik dan dua teman. **Dampak:** BR-003. **Status:** CONFIRMED_DIRECTION; menggantikan tafsir jumlah anggota yang ambigu pada Q-011.

### Q-013

**Topik:** layanan dan sumber biaya AI. **Jawaban:** pengguna memiliki banyak kredit API DeepSeek dan perlu memakai token aksesnya. **Dampak:** BR-032. **Status:** CONFIRMED_DIRECTION; bukan janji kuota tidak terbatas, layanan tanpa biaya, atau token sudah tersedia/diuji oleh agen. Tidak ada rahasia dicatat dalam dokumen.

### Q-014

**Topik:** alur kolaborasi GitHub. **Jawaban:** pilih fork, branch per tugas, PR ke `main` repository pusat, lalu pemilik meninjau dan memperbaiki sebelum merge. **Dampak:** BR-036. **Status:** CONFIRMED_DIRECTION; usulan empat branch permanen per orang pada Q-011 SUPERSEDED. Pengaturan izin/proteksi repository belum dikerjakan.

### Q-015

**Topik:** backend TypeScript saja atau TypeScript + Python. **Riwayat awal:** pengguna **belum menyetujui** TypeScript sebagai keputusan akhir dan meminta riset mendalam. Status pada titik ini adalah OPEN, bukan persetujuan diam-diam. **Tindak lanjut:** dokumentasi resmi dibandingkan dan percobaan media lokal OBS-01 dilakukan tanpa menggunakan kredit API. **Jawaban lanjutan:** pengguna memilih **“Setuju arah ini”** untuk API TypeScript dan worker TypeScript sebagai dua proses dalam satu codebase. **Dampak:** BR-031. **Status kini:** CONFIRMED_DIRECTION pada arsitektur tersebut; Python tidak menjadi runtime wajib. Jika kelak ada kebutuhan komputasi atau pustaka yang terukur, perubahan arsitektur harus dicatat kembali. Persetujuan arah ini bukan bukti seluruh stack, versi, algoritma, dan pengujian aplikasi selesai.

### Q-016

**Topik:** bentuk pengujian demo. **Jawaban:** dosen dan mahasiswa harus dapat mencoba alur yang benar, dengan identitas imitasi yang wajar dan akun secukupnya. **Dampak:** BR-027, BR-039. **Status:** CONFIRMED_DIRECTION; akun/data simulasi harus dapat dibedakan dari hasil panggilan AI nyata.

### Q-017

**Topik:** paket data uji dan penghapusan laporan. **Jawaban:** memilih paket awal 2 admin, 6 warga, 16 laporan, dan 6 dokumen, tetapi menyatakan jumlah laporan terlalu banyak dan menyerahkan pengurangannya. Pengguna juga meminta admin dapat menghapus laporan sehingga hilang dari tampilan warga. **Pilihan kerja PLAN-01:** jumlah laporan dikurangi menjadi **12**; jumlah lain tetap. **Dampak:** BR-014, BR-015, BR-038. **Status:** jumlah 12 adalah DELEGATED_DEFAULT; bukan pilihan angka 12 yang dinyatakan langsung oleh pengguna. Identitas dan dokumen uji bersifat spesimen.

### Q-018

**Topik:** kendali admin atas input dan efisiensi AI. **Jawaban:** admin dapat menyalakan/mematikan galeri, mengatur/reset kuota per jam, membatasi maksimum dua foto, serta memakai resize untuk menghemat pemrosesan AI. Frasa “video 3/4” belum jelas saat disampaikan. **Dampak:** BR-011–BR-013, BR-033. **Status:** arah fitur CONFIRMED_DIRECTION; ambiguitas video tidak diubah menjadi durasi baru dan diselesaikan Q-019.

### Q-019

**Topik:** arti “video 3/4”. **Koreksi pengguna:** video tetap maksimum **5 detik**; angka 3/4 merujuk **3–4 frame** untuk masukan AI. **Dampak:** BR-005, BR-033. **Status:** CONFIRMED_DIRECTION untuk durasi dan kisaran frame. Default tepat 3 frame, strategi memilih frame, resolusi, dan cache hasil tetap rincian usulan yang harus dievaluasi; tidak ada klaim persentase penghematan terukur.

### Q-020

**Topik:** cakupan pengaturan galeri/kuota. **Jawaban:** ya untuk aturan umum global berupa **N laporan per H jam per akun**, dengan reset untuk satu akun atau semua akun. **Dampak:** BR-012, BR-013. **Status:** CONFIRMED_DIRECTION; nilai N/H, cara menghitung jendela waktu, dan perlakuan laporan gagal belum diputuskan.

### Q-021

**Topik:** arti menghapus laporan. **Jawaban:** memilih penghapusan permanen dari data aktif berikut media, dengan audit minimal. **Dampak:** BR-014, BR-015. **Status:** CONFIRMED_DIRECTION; detail isi/retensi audit, salinan cadangan, cache, dan pekerjaan AI yang sedang berjalan masih perlu dirinci. Tidak dijanjikan seluruh salinan pada semua perangkat hilang seketika.

### Q-022

**Topik:** kombinasi lampiran. **Jawaban:** ya untuk maksimum **2 foto ATAU 1 video maksimal 5 detik**. **Dampak:** BR-005. **Status:** CONFIRMED_DIRECTION; bukan dua foto ditambah video dalam satu laporan.

### Q-023

**Topik:** hasil yang belum dapat dinilai. **Jawaban:** tampilkan status **belum dinilai** secara terpisah, jangan dimasukkan ke tingkat rendah; admin dapat meninjau. **Dampak:** BR-018. **Status:** CONFIRMED_DIRECTION; perbedaan rinci pending, gagal, tidak cukup bukti, dan tidak pasti masih bagian penyempurnaan alur.

### Q-024

**Topik:** akhir siklus kejadian. **Jawaban:** admin menandai kejadian selesai sehingga keluar dari Pantau aktif, tetapi riwayat tetap ada; penghapusan adalah tindakan terpisah. **Dampak:** BR-020. **Status:** CONFIRMED_DIRECTION; pembukaan kembali kejadian dan laporan baru di lokasi yang sama belum difinalkan.

### Q-025

**Topik:** penyimpanan dan akses backup dokumen pribadi. **Jawaban:** ya, dokumen dicadangkan secara privat di backend; pemilik dapat mengaksesnya setelah login di perangkat lain, dan admin tidak dapat membaca dokumen pribadi tersebut. **Dampak:** memperjelas BR-025/DEC-025/AC-025. **Status:** CONFIRMED_DIRECTION untuk lokasi penyimpanan dan batas akses tersebut. Mekanisme enkripsi/kunci, format/ukuran, pemulihan akun, serta retensi belum ditetapkan oleh jawaban ini.

### Q-026

**Topik:** cakupan offline minimum. **Jawaban:** ya untuk draf laporan beserta media yang dapat disimpan saat offline, dikirim setelah koneksi kembali tanpa membuat laporan ganda, serta kontak dan panduan yang tetap dapat dibaca offline. **Dampak:** BR-042/DEC-042/AC-042; memperjelas cakupan BR-023 dan BR-024. **Status:** CONFIRMED_DIRECTION. Jawaban ini tidak menetapkan suara/TTS harus bekerja offline dan tidak memilih pengiriman ulang otomatis atau manual; rincian keduanya tetap OPEN.

### Q-027

**Topik:** pembuat, penerima, dan kanal peringatan. **Jawaban:** memilih admin membuat pesan yang masuk ke inbox seluruh warga; push di luar aplikasi belum wajib. **Dampak:** memperjelas BR-026/DEC-026/AC-026. **Status:** CONFIRMED_DIRECTION. Jawaban ini tidak menetapkan penargetan menurut domisili, peringatan otomatis dari AI, kewajiban push di luar aplikasi, atau hak admin menyunting kontak/panduan. Rincian status pesan dan perubahan/pencabutan pesan masih perlu dibahas pada tahap terkait.

### Q-028

**Topik:** batas informasi publik pada Pantau. **Jawaban:** ya, Pantau warga hanya menampilkan nama lokasi, tingkat, waktu pembaruan, dan badge tinjauan; identitas/kontak pelapor serta foto/video laporan individual tidak dibuka kepada warga lain. Admin tetap dapat meninjau bukti. **Dampak:** memperjelas BR-016/DEC-016/AC-016 dan batas peran pada BR-009. **Status:** CONFIRMED_DIRECTION. Jawaban ini menetapkan cakupan informasi publik; bukan bukti bahwa pembatasan akses telah diimplementasikan atau diuji.

### Q-029

**Topik:** walkthrough bagian A, tujuan/peran/cakupan pada BRD bagian 2–8: demo Padang, tim tiga orang, platform Flutter, inti dahulu dan pendukung wajib, penggantian Pantau sungai serta penghapusan posko/dispatch. **Jawaban individual:** tidak diberikan. **Status:** CLOSED_BY_COLLECTIVE_APPROVAL melalui BRD-APPROVAL-01; pengguna menyetujui BRD secara keseluruhan dan meminta lanjut tahap 2. Tidak direkonstruksi sebagai pilihan opsi atau jawaban terpisah.

### Q-030

**Topik:** walkthrough bagian B, BRD bagian 9.1–9.2 serta 10–11: batas media, kontrol admin, hapus versus selesai, Pantau otomatis, batas informasi, dan pembedaan prioritas tinjauan admin dari indikasi dampak banjir. **Jawaban individual:** tidak diberikan. **Status:** CLOSED_BY_COLLECTIVE_APPROVAL melalui BRD-APPROVAL-01. Persetujuan baseline tidak mengarang nilai rumus/parameter yang memang masih dicatat terbuka.

### Q-031

**Topik:** walkthrough bagian C, BRD bagian 9.3–9.5 serta 12–16: pendukung, Q-025–Q-028, batas teknis, paket demo, kriteria penerimaan sebagai rencana uji, dan alokasi rincian terbuka ke tahap terkait. **Jawaban individual:** tidak diberikan. **Status:** CLOSED_BY_COLLECTIVE_APPROVAL melalui BRD-APPROVAL-01. Izin tahap 2 berasal dari permintaan lanjut eksplisit pengguna, bukan hasil uji aplikasi atau asumsi dari diam.

## 5. Register pernyataan kebutuhan — snapshot baseline BRD

Pernyataan berikut mempertahankan status arah dan item terbuka saat penyusunan BRD. Persetujuan dokumen kemudian diberikan melalui BRD-APPROVAL-01. Perincian/perubahan pada PRD dicatat di bagian tahap 2, tanpa menimpa riwayat—termasuk enam dokumen spesimen pada BRD yang kemudian menjadi delapan pada PRD. Untuk rumusan BR dan AC, lihat [BRD.md](BRD.md); alasan keputusan ada di [DECISIONS.md](DECISIONS.md).

| ST | Pernyataan kerja | Dasar epistemik | Status sekarang |
|---|---|---|---|
| ST-001 | Sasaran awal adalah demo akademik dalam konteks Kota Padang. | CURRENT_USER_CONFIRMED | CONFIRMED_DIRECTION |
| ST-002 | Warga memakai Flutter Android dan admin memakai Flutter Web. | CURRENT_USER_CONFIRMED | CONFIRMED_DIRECTION |
| ST-003 | Tim berjumlah tiga orang; pemilik bertanggung jawab atas backend, AI, dan pemeliharaan, dua teman atas Flutter dan integrasi API. | CURRENT_USER_CONFIRMED | CONFIRMED_DIRECTION |
| ST-004 | Alur inti menghubungkan laporan, penilaian AI, pengelompokan, dan prioritas admin. | CURRENT_USER_CONFIRMED | CONFIRMED_DIRECTION |
| ST-005 | Satu laporan menerima maksimum dua foto atau satu video paling lama lima detik. | CURRENT_USER_CONFIRMED | CONFIRMED_DIRECTION |
| ST-006 | AI menilai kesesuaian bukti dan keterangan dengan batas ketidakpastian. | CURRENT_USER_CONFIRMED + batas RAW_SOURCE yang relevan | CONFIRMED_DIRECTION; fallback rinci OPEN |
| ST-007 | Laporan yang terkait dapat dikelompokkan tanpa menghilangkan bukti individualnya. | CURRENT_USER_CONFIRMED + SRC-M04 | CONFIRMED_DIRECTION; algoritma/ambang OPEN |
| ST-008 | Prioritas kerja admin dan indikasi bahaya publik mempunyai makna berbeda. | Pemisahan makna dari alur yang dikonfirmasi; perumusan lanjutan | PROPOSED_REFINEMENT untuk rumus/label rinci; arah alur CONFIRMED_DIRECTION |
| ST-009 | Admin dapat meninjau dan mengoreksi keluaran AI serta pengelompokan. | CURRENT_USER_CONFIRMED | CONFIRMED_DIRECTION |
| ST-010 | Admin mencatat tindak lanjut sederhana tanpa sistem dispatch. | CURRENT_USER_CONFIRMED | CONFIRMED_DIRECTION |
| ST-011 | Admin mengendalikan akses galeri melalui toggle global. | CURRENT_USER_CONFIRMED | CONFIRMED_DIRECTION |
| ST-012 | Admin menetapkan aturan global N laporan per H jam yang diterapkan per akun. | CURRENT_USER_CONFIRMED | CONFIRMED_DIRECTION; nilai dan mekanisme waktu OPEN |
| ST-013 | Admin dapat mereset kuota satu akun atau seluruh akun. | CURRENT_USER_CONFIRMED | CONFIRMED_DIRECTION |
| ST-014 | Admin dapat menghapus laporan dan media aktif secara permanen dengan audit minimal. | CURRENT_USER_CONFIRMED | CONFIRMED_DIRECTION; batas salinan/retensi OPEN |
| ST-015 | Penghapusan memperbarui riwayat warga, kelompok, dan Pantau saat tersinkron daring. | Permintaan langsung dampak warga + konsekuensi konsistensi | CONFIRMED_DIRECTION untuk hasil; rincian sinkronisasi PROPOSED_REFINEMENT |
| ST-016 | Pantau menampilkan lokasi/kelompok berlaporan berupa nama lokasi, tingkat, waktu pembaruan, dan badge; identitas/kontak pelapor serta foto/video laporan individual tidak dibuka kepada warga lain, sementara admin tetap meninjau bukti. | CURRENT_USER_CONFIRMED pada Q-007–Q-010 dan Q-028 + delegasi mekanisme | CONFIRMED_DIRECTION untuk cakupan publik; reuse kelompok DELEGATED_DEFAULT |
| ST-017 | Pantau dapat menampilkan hasil otomatis sebelum review admin. | CURRENT_USER_CONFIRMED | CONFIRMED_DIRECTION |
| ST-018 | Status belum dinilai dipisahkan dari tingkat rendah. | CURRENT_USER_CONFIRMED | CONFIRMED_DIRECTION |
| ST-019 | Pantau membedakan hasil otomatis dan hasil yang telah ditinjau admin melalui badge. | CURRENT_USER_CONFIRMED | CONFIRMED_DIRECTION |
| ST-020 | Kejadian yang ditandai selesai keluar dari Pantau aktif, sementara riwayat tetap tersedia. | CURRENT_USER_CONFIRMED | CONFIRMED_DIRECTION |
| ST-021 | Fitur inti didahulukan, sementara fitur pendukung yang disepakati tetap wajib. | CURRENT_USER_CONFIRMED | CONFIRMED_DIRECTION |
| ST-022 | Produk menyediakan checklist tas siaga. | RAW_SOURCE yang cakupan pendukungnya dikonfirmasi Q-006 | CONFIRMED_DIRECTION; rincian isi OPEN |
| ST-023 | Produk menyediakan kontak darurat yang dapat dibaca offline sesuai BR-042. | RAW_SOURCE yang cakupan pendukungnya dikonfirmasi Q-006; CURRENT_USER_CONFIRMED pada Q-026 | CONFIRMED_DIRECTION; nomor aktif belum diverifikasi |
| ST-024 | Produk menyediakan panduan yang dapat dibaca offline dan fungsi suara. | RAW_SOURCE yang cakupan pendukungnya dikonfirmasi Q-006; CURRENT_USER_CONFIRMED pada Q-026 | CONFIRMED_DIRECTION; konten dan kemampuan suara offline tetap OPEN |
| ST-025 | Produk menyediakan backup dokumen privat di backend yang dapat diakses pemilik setelah login dari perangkat lain; admin tidak dapat membacanya. | CURRENT_USER_CONFIRMED pada Q-025, memperjelas cakupan Q-006 | CONFIRMED_DIRECTION; mekanisme keamanan dan penyimpanan rinci OPEN |
| ST-026 | Admin membuat pesan peringatan untuk inbox seluruh warga; push di luar aplikasi belum wajib. | CURRENT_USER_CONFIRMED pada Q-027, memperjelas cakupan Q-006 | CONFIRMED_DIRECTION; status/perubahan pesan rinci OPEN; tidak menetapkan target domisili atau peringatan AI otomatis |
| ST-027 | Produk menyediakan akun, profil, riwayat, dan registrasi untuk pengujian alur. | CURRENT_USER_CONFIRMED + RAW_SOURCE terkait | CONFIRMED_DIRECTION |
| ST-028 | Monitoring sungai dan tinggi muka air tidak termasuk cakupan sekarang. | CURRENT_USER_CONFIRMED | CONFIRMED_DIRECTION; cakupan legacy SUPERSEDED |
| ST-029 | Posko/shelter tidak termasuk cakupan sekarang. | CURRENT_USER_CONFIRMED | CONFIRMED_DIRECTION; cakupan legacy SUPERSEDED |
| ST-030 | Lingkungan lokal menggunakan Laragon 6 dan MySQL. | CURRENT_USER_CONFIRMED | CONFIRMED_DIRECTION; versi komponen terpasang perlu diperiksa pada setup |
| ST-031 | API dan worker memakai TypeScript, satu codebase, dan proses terpisah. | CURRENT_USER_CONFIRMED setelah RES-01/02 dan OBS-01 | CONFIRMED_DIRECTION |
| ST-032 | Integrasi AI memakai API DeepSeek dengan kredit milik pengguna. | CURRENT_USER_CONFIRMED | CONFIRMED_DIRECTION; model/akses nyata belum diuji |
| ST-033 | Pemrosesan AI mempertimbangkan efisiensi melalui 3–4 frame video dan resize yang diukur. | CURRENT_USER_CONFIRMED untuk arah; usulan teknis untuk rincian | CONFIRMED_DIRECTION untuk kisaran; default 3 frame/cache PROPOSED_REFINEMENT |
| ST-034 | Demo lokal didahulukan dan persiapan Docker untuk hosting ditempatkan pada tahap 5. | CURRENT_USER_CONFIRMED | CONFIRMED_DIRECTION; belum ada deployment |
| ST-035 | Proyek menghindari kewajiban langganan pihak ketiga berbayar yang baru. | CURRENT_USER_CONFIRMED | CONFIRMED_DIRECTION; bukan larangan seluruh pihak ketiga |
| ST-036 | Kolaborasi memakai fork dan branch per tugas, PR ke main pusat, lalu review/perbaikan pemilik sebelum merge. | CURRENT_USER_CONFIRMED setelah RES-04 | CONFIRMED_DIRECTION |
| ST-037 | Desain SVG menjadi acuan tema biru dan kandidat fitur. | CURRENT_USER_CONFIRMED + FACT_INSPECTED | CONFIRMED_DIRECTION; bukan kontrak pixel-perfect |
| ST-038 | Paket uji kerja berisi 2 admin, 6 warga, 12 laporan, dan 6 dokumen spesimen. | CURRENT_USER_CONFIRMED untuk paket awal + delegasi pengurangan laporan | DELEGATED_DEFAULT pada 12 laporan; awal 16 SUPERSEDED oleh pilihan kerja |
| ST-039 | Dosen dan mahasiswa dapat menguji alur yang benar, dengan fixture terpisah dari hasil AI nyata. | CURRENT_USER_CONFIRMED + konsekuensi kejujuran bukti uji | CONFIRMED_DIRECTION; implementasi/pengujian belum dilakukan |
| ST-040 | Pekerjaan dilaksanakan berurutan dari nomor 1 sampai 5, dengan ringkasan dan konfirmasi tiap nomor. | CURRENT_USER_CONFIRMED | CONFIRMED_DIRECTION |
| ST-041 | Perencanaan memakai milestone fitur tanpa deadline keras. | CURRENT_USER_CONFIRMED | CONFIRMED_DIRECTION; perkiraan 1–3 bulan bukan komitmen |
| ST-042 | Cakupan offline mencakup draf laporan beserta media, pengiriman setelah tersambung kembali tanpa duplikasi, serta kontak dan panduan yang dapat dibaca offline. | CURRENT_USER_CONFIRMED pada Q-026 | CONFIRMED_DIRECTION; pengiriman ulang otomatis/manual dan suara offline tidak ditetapkan |

### 5.1 Klaim lama yang tidak naik menjadi kebutuhan atau fakta

| ID | Klaim/kandidat | Perlakuan sekarang |
|---|---|---|
| RAW-001 | Akurasi AI lebih dari 92%, anti-hoaks memastikan kejadian benar, atau kedalaman banjir dalam sentimeter dari gambar tanpa referensi ukur | Tidak diterima sebagai fakta atau target yang telah disepakati; memerlukan dataset, metode, dan bukti yang belum ada. |
| RAW-002 | Angka TMA, kapasitas posko, armada, petugas, dan statistik operasional dalam mockup | Tidak digunakan sebagai fakta kondisi Padang; sungai/posko dikeluarkan, data demo lain diberi penanda. |
| RAW-003 | Angka kandidat radius 1.500 m, diameter 3.000 m, waktu 6/12 jam, GPS 150 m, dan Jaccard 0,3 dalam SRC-M04 | Parameter eksperimen lama, belum disetujui sebagai aturan final. |
| RAW-004 | Seluruh 19 layar desain tersedia | Dikoreksi oleh inventaris aktual: 17 SVG tersedia; dua berkas yang disebut tidak ada. |
| RAW-005 | Fitur pendukung lama otomatis membawa seluruh API, CMS, enkripsi, SLA, dan detail offline lama | Tidak diadopsi otomatis; kebutuhan tingkat bisnis dipisahkan dari desain teknis yang masih perlu dibahas. |
| RAW-006 | Semua referensi hukum, kontak, dan library pada paket lama telah diverifikasi ulang | Tidak diklaim. RES-01–RES-04 hanya mencatat riset yang benar-benar dilakukan sesi ini. |
| RAW-007 | Fitur AI berjalan tanpa batas atau tanpa biaya karena pengguna memiliki kredit | Tidak disimpulkan. Kuota, token, biaya, limit provider, dan pengukuran aplikasi masih perlu dibuktikan. |

## 6. Matriks kebutuhan → sumber → jawaban → keputusan → penerimaan

Tabel menggunakan ID AC yang bersesuaian dalam BRD. Seluruh AC berstatus **PLANNED / NOT EXECUTED untuk produk**. OBS-01 hanya mendukung kelayakan jalur media, tidak meluluskan AC-005, AC-031, atau AC-033.

| BR / ST | Sumber awal atau bukti | Klarifikasi utama | Keputusan | Penerimaan |
|---|---|---|---|---|
| BR-001 / ST-001 | SRC-M01, CONV-02 | Q-001, Q-011 | DEC-001 | AC-001 |
| BR-002 / ST-002 | SRC-M01, SRC-M06 | Q-011 | DEC-002 | AC-002 |
| BR-003 / ST-003 | CONV-02 | Q-011, Q-012 | DEC-003 | AC-003 |
| BR-004 / ST-004 | SRC-M01, SRC-M04 | Q-004 | DEC-004 | AC-004 |
| BR-005 / ST-005 | SRC-M02, SRC-SVG02 | Q-018, Q-019, Q-022 | DEC-005 | AC-005 |
| BR-006 / ST-006 | SRC-M04, SRC-M09, RES-01 | Q-004, Q-023 | DEC-006 | AC-006 |
| BR-007 / ST-007 | SRC-M04, SRC-SVG14 | Q-004 | DEC-007 | AC-007 |
| BR-008 / ST-008 | SRC-M04, SRC-SVG14; sintesis makna Pantau | Q-004, Q-008, Q-010, Q-023 | DEC-008 | AC-008 |
| BR-009 / ST-009 | SRC-M02, SRC-M04, SRC-SVG15 | Q-005 | DEC-009 | AC-009 |
| BR-010 / ST-010 | SRC-M02 | Q-005 | DEC-010 | AC-010 |
| BR-011 / ST-011 | CONV-02; kontrol baru atas SRC-SVG02 | Q-018, Q-020 | DEC-011 | AC-011 |
| BR-012 / ST-012 | CONV-02 | Q-018, Q-020 | DEC-012 | AC-012 |
| BR-013 / ST-013 | CONV-02 | Q-018, Q-020 | DEC-013 | AC-013 |
| BR-014 / ST-014 | CONV-02; memperbarui SRC-M03 | Q-017, Q-021 | DEC-014 | AC-014 |
| BR-015 / ST-015 | CONV-02, SRC-SVG07 | Q-017, Q-021; konsekuensi konsistensi | DEC-015 | AC-015 |
| BR-016 / ST-016 | SRC-SVG03 dengan makna diganti; CONV-02 untuk batas informasi publik | Q-006, Q-007, Q-009, Q-010, Q-028 | DEC-016 | AC-016 |
| BR-017 / ST-017 | CONV-02 | Q-008 | DEC-017 | AC-017 |
| BR-018 / ST-018 | SRC-M04, CONV-02 | Q-023 | DEC-018 | AC-018 |
| BR-019 / ST-019 | CONV-02 | Q-008, Q-010 | DEC-019 | AC-019 |
| BR-020 / ST-020 | CONV-02 | Q-024 | DEC-020 | AC-020 |
| BR-021 / ST-021 | SRC-M01, SRC-M05 | Q-006 | DEC-021 | AC-021 |
| BR-022 / ST-022 | SRC-M05, SRC-SVG04 | Q-006 | DEC-022 | AC-022 |
| BR-023 / ST-023 | SRC-M05, SRC-M09, SRC-SVG05, CONV-02 | Q-006, Q-026; cakupan offline pada BR-042 | DEC-023 | AC-023 |
| BR-024 / ST-024 | SRC-M05, SRC-SVG06, CONV-02 | Q-006, Q-026; cakupan offline pada BR-042 | DEC-024 | AC-024 |
| BR-025 / ST-025 | SRC-M05, SRC-SVG08, CONV-02 | Q-006, Q-017, Q-025 | DEC-025 | AC-025 |
| BR-026 / ST-026 | SRC-M05, SRC-SVG09, CONV-02 | Q-006, Q-027 | DEC-026 | AC-026 |
| BR-027 / ST-027 | SRC-M02, SRC-SVG07/10/11/12 | Q-016, Q-017 | DEC-027 | AC-027 |
| BR-028 / ST-028 | SRC-M05, SRC-SVG03; cakupan lama dicabut | Q-006 | DEC-028 | AC-028 |
| BR-029 / ST-029 | SRC-M05, SRC-SVG16; cakupan lama dicabut | Q-006 | DEC-029 | AC-029 |
| BR-030 / ST-030 | CONV-02, SRC-M06 | Q-011 | DEC-030 | AC-030 |
| BR-031 / ST-031 | SRC-M06, RES-01/02/03, OBS-01 | Q-015 awal dan lanjutan | DEC-031 | AC-031 |
| BR-032 / ST-032 | RES-01, CONV-02 | Q-013 | DEC-032 | AC-032 |
| BR-033 / ST-033 | SRC-M04, RES-01/02, OBS-01 | Q-018, Q-019 | DEC-033 | AC-033 |
| BR-034 / ST-034 | CONV-02, SRC-P05 | Q-011 | DEC-034 | AC-034 |
| BR-035 / ST-035 | CONV-02 | Q-010 koreksi, Q-013 | DEC-035 | AC-035 |
| BR-036 / ST-036 | RES-04, CONV-02 | Q-011 kandidat, Q-014 keputusan | DEC-036 | AC-036 |
| BR-037 / ST-037 | SRC-SVG01–SRC-SVG17, OBS-02 | Q-002 | DEC-037 | AC-037 |
| BR-038 / ST-038 | CONV-02, PLAN-01 | Q-016, Q-017; USER-IMPLEMENT | DEC-038 | AC-038 |
| BR-039 / ST-039 | SRC-M07, SRC-M09, CONV-02 | Q-016, Q-017 | DEC-039 | AC-039 |
| BR-040 / ST-040 | SRC-P01–SRC-P05, CONV-01 | Instruksi awal; USER-IMPLEMENT terbatas draft | DEC-040 | AC-040 |
| BR-041 / ST-041 | CONV-02 | Q-011 | DEC-041 | AC-041 |
| BR-042 / ST-042 | CONV-02; SRC-M02/SRC-M05/SRC-M06 sebagai acuan lama | Q-026 | DEC-042 | AC-042 |

## 7. Register lapisan konfirmasi — snapshot sebelum persetujuan BRD

SRC-P01 membedakan empat lapisan: **G1 pemahaman**, **G2 niat/keputusan**, **G3 skenario/konsekuensi**, dan **G4 persetujuan rumusan kebutuhan final**. Satu jawaban dapat memperjelas lebih dari satu hal, tetapi tidak otomatis meluluskan keempatnya. Register ini tidak merekayasa sesi tanya jawab atau menandai gate yang belum ditanyakan sebagai selesai.

Status `ADA BUKTI` berarti jawaban relevan tersedia; `SEBAGIAN` berarti ada skenario yang dibahas tetapi cakupan belum lengkap; `BELUM` berarti belum ada persetujuan yang memenuhi lapisan itu untuk draft versi ini.

| Kelompok kebutuhan | G1: pemahaman | G2: niat/keputusan | G3: skenario/konsekuensi | G4: rumusan final |
|---|---|---|---|---|
| BR-001–BR-004, BR-030–BR-032, BR-034–BR-037, BR-040–BR-041 | ADA BUKTI pada Q-001/002/004/010–015 dan instruksi proses | ADA BUKTI untuk arah yang dinyatakan langsung | SEBAGIAN; biaya, batas demo, alternatif arsitektur, dan alur Git telah dibahas; bukan semua kondisi | BELUM |
| BR-005, BR-011–BR-013 | ADA BUKTI, termasuk koreksi durasi/frame Q-019 dan konfirmasi kombinasi Q-022 | ADA BUKTI Q-018–Q-022 | SEBAGIAN; aturan global/reset dibahas, tetapi kegagalan unggahan dan jendela kuota belum rinci | BELUM |
| BR-006–BR-010, BR-033 | ADA BUKTI untuk alur dan batas peran | ADA BUKTI untuk arah; rincian prioritas/cache masih usulan | SEBAGIAN; fallback AI, rumus, ambang, dan efektivitas resize belum tuntas | BELUM |
| BR-014–BR-015 | ADA BUKTI Q-017/Q-021 | ADA BUKTI untuk hapus permanen data aktif dan media dengan audit minimal | SEBAGIAN; dampak tampilan warga dibahas, tetapi cadangan/cache/job berjalan belum final | BELUM |
| BR-016–BR-020 | ADA BUKTI Q-007–Q-010/Q-023/Q-024/Q-028 | ADA BUKTI untuk tampil otomatis, belum dinilai, selesai, dan pembatasan informasi publik | SEBAGIAN; beda selesai/hapus dan larangan membuka identitas/kontak/media individual kepada warga lain dikonfirmasi; reaktivasi dan kejadian baru belum final | BELUM |
| BR-021–BR-024, BR-027–BR-029 | ADA BUKTI untuk cakupan pendukung dan pengecualian Q-006; baca offline kontak/panduan Q-026 | ADA BUKTI untuk keberadaan/pengecualian fitur | BELUM lengkap untuk perilaku dan isi setiap pendukung; suara offline belum diputuskan | BELUM |
| BR-025 | ADA BUKTI Q-025: backup privat di backend, akses pemilik setelah login di perangkat lain, admin tidak dapat membaca | ADA BUKTI pada jawaban ya Q-025 | SEBAGIAN; skenario perangkat lain dan larangan akses admin dikonfirmasi, rincian keamanan/pemulihan belum tuntas | BELUM |
| BR-026 | ADA BUKTI Q-027: admin membuat pesan untuk inbox seluruh warga, push luar aplikasi belum wajib | ADA BUKTI pada pilihan eksplisit Q-027 | SEBAGIAN; pembuat/penerima/kanal dikonfirmasi, status/perubahan/pencabutan pesan belum rinci | BELUM |
| BR-038–BR-039 | ADA BUKTI Q-016/Q-017 | ADA BUKTI pada paket dan delegasi; 12 laporan adalah default kerja | SEBAGIAN; kebutuhan demo jujur dibahas, bukti uji aplikasi belum ada | BELUM |
| BR-042 | ADA BUKTI Q-026: draf/media, kirim setelah tersambung tanpa duplikasi, kontak/panduan dibaca offline | ADA BUKTI pada jawaban ya Q-026 | SEBAGIAN; hasil setelah tersambung dikonfirmasi, pemicu retry otomatis/manual dan perilaku kegagalan belum dirinci | BELUM |

Tabel di atas adalah snapshot sebelum respons persetujuan, sehingga kolom G4 historis tetap terlihat. **Penutupan tahap 1:** pengguna menyetujui BRD 0.1.0 secara kolektif melalui BRD-APPROVAL-01. Tidak ada jawaban individual atas Q-029–Q-031 yang direkayasa, dan tidak ada klaim semua skenario teknis telah diuji. Persetujuan dosen atau dua teman tidak diklaim. PRD yang saat itu belum disetujui kini ditutup melalui PRD-APPROVAL-01; FRD berstatus DRAFT.

## 8. Kesiapan, item terbuka, dan batas audit — riwayat tahap 1

Tabel dan daftar berikut mempertahankan keadaan audit saat draft BRD diajukan. Baris yang menulis menunggu/belum merupakan status pada snapshot itu, bukan status terkini. Persetujuan BRD dan penanganan item melalui discovery PRD dicatat pada bagian tahap 2 di bawah; tidak ada hasil audit lama yang diklaim dijalankan ulang.

| Pemeriksaan | Status | Bukti atau pekerjaan yang masih diperlukan |
|---|---|---|
| Inventaris lokasi sumber | SELESAI untuk lokasi yang diberikan | 5 prompt + 36 file paket; sumber yang hanya disebut tercatat pada §2.4. |
| Pembacaan perencanaan oleh tim | SELESAI pada cakupan audit tim | Prompt 1 oleh agen utama; prompt 2–5 oleh agen audit proses; dokumen paket diaudit tim. Tidak mengklaim setiap agen membaca ulang semuanya. |
| Inspeksi desain statis | SELESAI | 17 SVG dirender dan dilihat; tidak meluluskan perilaku aplikasi. |
| Rekonsiliasi jawaban penting | TERCAKUP dalam draft | Total tim 3, arti langganan, TS/Python, durasi video/frame, paket 16→12, hapus vs selesai, backup privat Q-025, offline minimum Q-026, inbox seluruh warga dari admin Q-027, dan batas informasi publik Pantau Q-028 tercatat. |
| Pemetaan kebutuhan | TERSEDIA | 42 ST/BR/DEC/AC dipetakan; ini bukti dokumentasi, bukan bukti implementasi. Inventaris sumber fisik tetap 41 berkas. |
| Pemeriksaan dokumen setelah Q-025–Q-028 | LULUS untuk pemeriksaan yang disebutkan | Pencocokan ulang setelah perubahan menemukan 28 heading Q, 42 baris ST, 42 baris matriks, dan 41 baris sumber; seluruh nama dari 41 berkas sumber fisik tercantum. ID BR/AC-001–042 tersedia dalam BRD dan DEC-001–042 tersedia dalam DECISIONS; kedua dokumen juga memuat Q-028. Tidak ditemukan ID/nama sumber yang hilang pada pemeriksaan ini. Ini bukan uji perilaku aplikasi atau persetujuan final. |
| Pemeriksaan struktur oleh agen utama setelah Q-028 | LULUS pada snapshot sebelum pengajuan walkthrough | Masing-masing 42 definisi BR, AC, DEC, ST, dan baris matriks unik; tidak ada ID hilang/duplikat. Sebanyak 85 tautan lokal/anchor Q diperiksa tanpa target hilang; UTF-8 dan pasangan pagar blok kode valid. Workspace hanya memuat tiga dokumen tahap 1. Q-029–Q-031 kemudian ditambahkan sebagai pertanyaan review yang belum dijawab. |
| Audit independen draf setelah Q-025–Q-028 | SELESAI; tidak ada temuan substantif tersisa | Reviewer terpisah membaca ketiga dokumen. Dua temuan awal tentang status resize dan pembagian keputusan bisnis versus rincian FRD/SRS telah diperbaiki. Backup privat, cakupan offline, inbox seluruh warga, dan batas Pantau konsisten. Audit ini bukan penerimaan pengguna atau hasil uji aplikasi. |
| Walkthrough bagian A/B/C | MENUNGGU JAWABAN | Pertanyaan Q-029–Q-031 telah diajukan setelah artefak tersedia dan audit selesai; belum ada jawaban yang dicatat. |
| Kesiapan draft kerja tahap 1 | SIAP DITINJAU | Arah utama cukup untuk draft dengan item terbuka yang dinyatakan. |
| Kelengkapan G3/G4 setiap kebutuhan | BELUM | Lihat §7; tidak dinaikkan menjadi final berdasarkan izin menulis draft. |
| Persetujuan final BRD 0.1.0 | BELUM | Memerlukan walkthrough/rangkuman dan persetujuan eksplisit pada versi yang ditinjau. |
| PRD/FRD/SRS/setup workspace | BELUM DIMULAI | Dikerjakan sesuai nomor setelah ringkasan dan konfirmasi tahap sebelumnya. |
| Pengujian aplikasi dan API DeepSeek nyata | BELUM | OBS-01 adalah percobaan media sintetis, bukan uji aplikasi. Tidak ada kredit API digunakan. |
| Validasi data eksternal | TERBATAS | RES-01–RES-04 mencatat riset yang dilakukan; kontak, konten panduan, dan data lapangan belum disahkan. |

Item yang harus tetap terlihat pada peninjauan berikutnya:

1. **AI dan prioritas:** rumus admin, pemetaan tingkat publik, status kegagalan/tidak pasti, ambang pengelompokan, dan hak koreksi rinci. Arti “belum dinilai” tidak boleh hilang dalam angka rendah.
2. **Media dan kuota:** nilai N/H, batas ukuran/format, cara menghitung percobaan gagal, aturan saat galeri dimatikan, default 3 atau 4 frame, pilihan frame, resize, cache, serta pengukuran biaya dan kualitas.
3. **Penghapusan dan siklus kejadian:** isi audit minimal, retensi/cadangan, pembatalan pekerjaan berjalan, sinkronisasi perangkat, penghitungan ulang kelompok/Pantau, kejadian dibuka kembali, dan laporan baru setelah selesai.
4. **Fitur pendukung:** isi checklist/panduan, nomor darurat, dukungan suara, serta status/perubahan pesan peringatan. Backup privat di backend, akses pemilik dari perangkat lain setelah login, serta larangan admin membaca dokumen telah dikonfirmasi Q-025; mekanisme keamanan dan pemulihannya masih perlu dirinci. Kontak dan panduan dapat dibaca offline sesuai Q-026, tetapi suara offline belum diputuskan. Q-027 menetapkan admin membuat pesan untuk inbox seluruh warga dan push luar aplikasi belum wajib; penargetan domisili maupun peringatan AI otomatis tidak ditambahkan. Konten desain dan data contoh tidak otomatis menjadi konten siap pakai.
5. **Pengujian dan demonstrasi:** komposisi 12 laporan spesimen, cakupan pengujian dosen/mahasiswa, pemisahan fixture dan AI nyata, serta kriteria keberhasilan yang dapat dibuktikan. Tidak ada angka akurasi atau penghematan yang dikarang.
6. **Teknis pada tahap yang sesuai:** versi komponen, model DeepSeek yang dipin, desain persistensi job MySQL, skema/API, keamanan, pengaturan GitHub, dan paket Docker. Arah TypeScript telah dipilih; rincian ini belum dilaksanakan sebagai setup.
7. **Offline:** draf laporan beserta media dan pengiriman setelah koneksi kembali tanpa duplikasi sudah dikonfirmasi. Pemicu retry otomatis/manual, waktu evaluasi kuota/kebijakan galeri, konflik, pergantian akun, serta pembersihan cache tetap perlu dirinci. Tidak ada pengujian offline aplikasi yang dinyatakan lulus pada tahap dokumen ini.

## 9. Aturan pemutakhiran

Saat pengguna mengubah jawaban, simpan riwayat lama sebagai SUPERSEDED dan tautkan jawaban pengganti; jangan menghapus jejak koreksi seperti Q-015 atau Q-019. Jika satu keputusan memengaruhi beberapa kebutuhan, perbarui BRD, DECISIONS, dan matriks ini bersama-sama. Nomor kebutuhan tidak digunakan ulang untuk makna baru yang berbeda.

Selesai menulis register berarti draft dapat ditinjau. Tahap 1 telah ditutup melalui persetujuan eksplisit pengguna. Tahap 2 menghasilkan draft yang harus ditinjau tersendiri; penulisan draft PRD tidak memberikan persetujuan final atau izin memulai tahap 3.

## 10. Status terkini dan bukti otorisasi tahap 2

Bagian 4–8 mempertahankan riwayat tahap 1. Bagian 10 dan seterusnya mencatat keadaan tahap 2. Tidak ada persetujuan lama atau keputusan yang ditimpa untuk membuat seluruh tahap terlihat selesai.

### BRD-APPROVAL-01

**Pernyataan pengguna, kutipan persis:**

> OKE SUDAH GOOD BRD NYA, SEKARANG LANJUT KE STEP LANGKAH SELANJUTNYA.

**Akibat yang dicatat:** BRD 0.1.0 diterima sebagai baseline dan pengguna meminta tahap 2. Q-029–Q-031 ditutup melalui persetujuan kolektif tersebut; tidak ada jawaban individual atau opsi terpilih yang direkayasa. Rincian yang memang dialokasikan ke FRD/SRS tetap memiliki status tersendiri. Tidak ada bukti persetujuan dosen/anggota tim lain atau hasil uji aplikasi dari pernyataan ini.

### 10.1 Sumber aktif untuk PRD

| ID bukti | Sumber | Perlakuan |
|---|---|---|
| PRD-SRC01 | [BRD.md](BRD.md), versi 0.1.0, 42 BR beserta AC; BRD-APPROVAL-01 | Baseline yang disetujui. Perincian/perubahan PRD ditelusuri, bukan dianggap ada sejak awal. |
| PRD-SRC02 | SRC-P02, `2.PROMPT_PRD.md` | Prosedur aktif; dibaca ulang penuh 977 baris pada awal tahap 2. Tidak mengizinkan melompati FRD/SRS/setup. |
| PRD-SRC03 | Percakapan PRD-Q001–PRD-Q043 | Bukti keputusan produk saat discovery; ledger di bawah berupa parafrasa, kecuali dinyatakan kutipan. |
| PRD-SRC04 | Ringkasan scope/urutan yang diterima melalui PRD-Q043 | Persetujuan dasar draft dan alokasi rincian, bukan persetujuan final seluruh PRD. |
| PRD-USER-IMPLEMENT | Instruksi pengguna berikutnya: **“Implement the plan.”** | Izin menuliskan paket dokumen tahap 2 yang direncanakan; bukan implementasi aplikasi atau tahap 3. |
| PRD-SRC05 | Inventaris sumber lama pada §2 dan bukti riset/PoC pada §3 | Acuan historis sesuai batas audit yang telah dicatat. Tidak ada audit ulang semua referensi web atau pengujian aplikasi dalam penulisan PRD ini. |

Inventaris **41 berkas input fisik** tetap berarti 5 prompt + 36 berkas paket. Dokumen kerja BRD/PRD/register dan catatan parafrasa internal tidak dihitung sebagai berkas asli tambahan dalam inventaris tersebut. Katalog PRD berisi **57 PRD-F dan 10 PRD-NF**, dengan AC bernomor sepadan; kini baseline produk APPROVED, tetap bukan bukti fitur selesai.

## 11. Register pertanyaan dan jawaban PRD

Penomoran tahap 2 terpisah dari Q tahap 1. Seluruh 43 entri berikut memiliki jawaban/keputusan yang dicatat; tidak ada pertanyaan baru yang disisipkan sebagai sudah ditanyakan. Fokus pertanyaan dan catatan jawaban adalah parafrasa penelusuran, bukan transkrip verbatim. Pada jawaban yang mendelegasikan pilihan, tindakan yang dipilih dalam delegasi dibedakan dari kata-kata pengguna. Status `CONFIRMED` berarti keputusan produk dikonfirmasi, **bukan final approval PRD**.

Prioritas peninjauan Tinggi/Sedang adalah penilaian kualitatif untuk review draft, bukan angka risiko atau label yang diklaim diberikan pengguna. Detail lanjutan tetap dibawa ke register terbuka FRD/SRS; namespace PRD-Q ini hanya merekam pertanyaan yang benar-benar diajukan. Namespace FRD-Q di tahap 3 berbeda: backlog pertanyaan diberi status NOT_ASKED sampai benar-benar diajukan, tanpa jawaban fiktif.

### PRD-Q001

**Fokus:** Akses tamu. **Mengapa penting:** Menentukan informasi yang boleh dibaca tamu dan batas fitur pribadi. **Prioritas peninjauan:** Sedang.

**Catatan jawaban dan keputusan:** Pantau, kontak umum, panduan tanpa login; laporan, dokumen, riwayat dan fitur pribadi memerlukan login.

**Status:** `CONFIRMED`. **Jejak:** PRD-CL043 → PRD-DEC-001 → PRD-F-001, PRD-F-003. Pemilik keputusan: pengguna/pemilik proyek; pilihan yang didelegasikan dijelaskan dalam catatan di atas.

### PRD-Q002

**Fokus:** Login warga. **Mengapa penting:** Menentukan cara warga memiliki serta memakai akun pada demo. **Prioritas peninjauan:** Sedang.

**Catatan jawaban dan keputusan:** Email dan kata sandi lokal; verifikasi dan pemulihan dibahas terpisah.

**Status:** `CONFIRMED`. **Jejak:** PRD-CL044 → PRD-DEC-002 → PRD-F-002, PRD-F-003. Pemilik keputusan: pengguna/pemilik proyek; pilihan yang didelegasikan dijelaskan dalam catatan di atas.

### PRD-Q003

**Fokus:** Lokasi laporan. **Mengapa penting:** Membedakan lokasi kejadian yang dipilih dari bukti posisi perangkat. **Prioritas peninjauan:** Tinggi.

**Catatan jawaban dan keputusan:** User memilih GPS atau titik manual; tambahan meminta mode developer harus mati untuk mencegah fake GPS. Batas teknis dirinci Q004–008.

**Status:** `REFINED`. **Jejak:** PRD-CL045 → PRD-DEC-003 → PRD-F-009, PRD-F-010. Pemilik keputusan: pengguna/pemilik proyek; pilihan yang didelegasikan dijelaskan dalam catatan di atas.

### PRD-Q004

**Fokus:** Deteksi sesuai dukungan. **Mengapa penting:** Membatasi klaim pemeriksaan perangkat sesuai informasi yang tersedia. **Prioritas peninjauan:** Tinggi.

**Catatan jawaban dan keputusan:** Tolak mock GPS; wajib matikan mode developer bila terdeteksi. Status tidak tersedia tidak diklaim mati.

**Status:** `CONFIRMED`. **Jejak:** PRD-CL046 → PRD-DEC-004 → PRD-F-010. Pemilik keputusan: pengguna/pemilik proyek; pilihan yang didelegasikan dijelaskan dalam catatan di atas.

### PRD-Q005

**Fokus:** Cakupan blokir. **Mengapa penting:** Mencegah pembatasan pengiriman ikut menghilangkan draf atau akses informasi. **Prioritas peninjauan:** Tinggi.

**Catatan jawaban dan keputusan:** Blokir pengiriman laporan saja, draf tersimpan dan informasi umum tetap bisa dibuka.

**Status:** `CONFIRMED`. **Jejak:** PRD-CL047 → PRD-DEC-005 → PRD-F-010, PRD-F-014. Pemilik keputusan: pengguna/pemilik proyek; pilihan yang didelegasikan dijelaskan dalam catatan di atas.

### PRD-Q006

**Fokus:** Titik manual. **Mengapa penting:** Memastikan lokasi manual yang jauh tidak dipresentasikan sebagai kehadiran pelapor. **Prioritas peninjauan:** Tinggi.

**Catatan jawaban dan keputusan:** Boleh lokasi lain; beri sumber manual, bukan bukti posisi/kehadiran pelapor.

**Status:** `CONFIRMED`. **Jejak:** PRD-CL048 → PRD-DEC-006 → PRD-F-009. Pemilik keputusan: pengguna/pemilik proyek; pilihan yang didelegasikan dijelaskan dalam catatan di atas.

### PRD-Q007

**Fokus:** Deteksi tidak tersedia. **Mengapa penting:** Menetapkan perilaku saat status perangkat tidak dapat diperoleh. **Prioritas peninjauan:** Tinggi.

**Catatan jawaban dan keputusan:** User: sesuaikan yang terbaik untuk menghindari laporan fiktif/penipuan. Root memilih tetap boleh mengirim bila status developer tidak tersedia, catat keterbatasan; larangan terdeteksi tetap berlaku termasuk titik manual. Diterima dalam konsolidasi Q043. **Batas delegasi:** izin saat status tidak tersedia adalah pilihan agen yang kemudian masuk konsolidasi; tidak mengklaim perangkat aman atau mode developer pasti mati.

**Status:** `DELEGATED_THEN_CONSOLIDATED`. **Jejak:** PRD-CL049 → PRD-DEC-007 → PRD-F-010. Pemilik keputusan: pengguna/pemilik proyek; pilihan yang didelegasikan dijelaskan dalam catatan di atas.

### PRD-Q008

**Fokus:** Build internal. **Mengapa penting:** Membedakan kebutuhan pengembangan internal dari perilaku APK demo. **Prioritas peninjauan:** Tinggi.

**Catatan jawaban dan keputusan:** Build pengembangan internal boleh mengecualikan blokir mode developer; APK demo menerapkan aturan dan diuji terpisah. Tidak memberi pengecualian mock GPS tanpa batas.

**Status:** `CONFIRMED`. **Jejak:** PRD-CL050 → PRD-DEC-008 → PRD-F-010. Pemilik keputusan: pengguna/pemilik proyek; pilihan yang didelegasikan dijelaskan dalam catatan di atas.

### PRD-Q009

**Fokus:** AI tidak cocok. **Mengapa penting:** Mencegah bukti yang belum layak dipakai sebagai dasar tingkat bahaya. **Prioritas peninjauan:** Tinggi.

**Catatan jawaban dan keputusan:** Terima dan tandai perlu review; bukti tersebut belum dipakai untuk tingkat bahaya sebelum ditinjau. Kelompok tanpa bukti layak tetap belum dinilai.

**Status:** `CONFIRMED`. **Jejak:** PRD-CL051 → PRD-DEC-009 → PRD-F-019, PRD-F-020, PRD-NF-006. Pemilik keputusan: pengguna/pemilik proyek; pilihan yang didelegasikan dijelaskan dalam catatan di atas.

### PRD-Q010

**Fokus:** Detail milik pelapor. **Mengapa penting:** Menentukan informasi hasil pemrosesan yang dapat diperiksa pelapor. **Prioritas peninjauan:** Sedang.

**Catatan jawaban dan keputusan:** Bukti sendiri, status, ringkasan AI/ketidakpastian serta hasil tinjauan admin terlihat oleh pemilik.

**Status:** `CONFIRMED`. **Jejak:** PRD-CL052 → PRD-DEC-010 → PRD-F-016, PRD-F-017. Pemilik keputusan: pengguna/pemilik proyek; pilihan yang didelegasikan dijelaskan dalam catatan di atas.

### PRD-Q011

**Fokus:** Laporan terkirim. **Mengapa penting:** Menetapkan batas perubahan laporan setelah diterima backend. **Prioritas peninjauan:** Tinggi.

**Catatan jawaban dan keputusan:** Hanya baca setelah diterima backend; draf boleh diperbaiki, pengelolaan laporan terkirim melalui admin.

**Status:** `CONFIRMED`. **Jejak:** PRD-CL053 → PRD-DEC-011 → PRD-F-016. Pemilik keputusan: pengguna/pemilik proyek; pilihan yang didelegasikan dijelaskan dalam catatan di atas.

### PRD-Q012

**Fokus:** Kirim offline. **Mengapa penting:** Membedakan draf biasa dari pengiriman yang memang telah diminta pengguna. **Prioritas peninjauan:** Tinggi.

**Catatan jawaban dan keputusan:** Percobaan ulang otomatis untuk laporan yang sudah ditekan Kirim saat aplikasi aktif dan online; tombol coba lagi. Draf belum ditekan Kirim tetap draf. Tidak menjanjikan background saat aplikasi ditutup.

**Status:** `CONFIRMED`. **Jejak:** PRD-CL054 → PRD-DEC-012 → PRD-F-014, PRD-F-015, PRD-NF-006. Pemilik keputusan: pengguna/pemilik proyek; pilihan yang didelegasikan dijelaskan dalam catatan di atas.

### PRD-Q013

**Fokus:** Koreksi kelompok. **Mengapa penting:** Menentukan kemampuan koreksi kelompok yang diperlukan pada demo. **Prioritas peninjauan:** Sedang.

**Catatan jawaban dan keputusan:** Pindah laporan ke kelompok yang ada atau kelompok baru; aksi massal gabung/pisah khusus tidak wajib.

**Status:** `CONFIRMED`. **Jejak:** PRD-CL055 → PRD-DEC-013 → PRD-F-024, PRD-NF-010. Pemilik keputusan: pengguna/pemilik proyek; pilihan yang didelegasikan dijelaskan dalam catatan di atas.

### PRD-Q014

**Fokus:** Catatan tindak lanjut. **Mengapa penting:** Membatasi pembaca dan makna catatan tindak lanjut. **Prioritas peninjauan:** Sedang.

**Catatan jawaban dan keputusan:** Admin dan pelapor dapat membaca catatan; warga lain tidak. Bukan chat dua arah.

**Status:** `CONFIRMED`. **Jejak:** PRD-CL056 → PRD-DEC-014 → PRD-F-025. Pemilik keputusan: pengguna/pemilik proyek; pilihan yang didelegasikan dijelaskan dalam catatan di atas.

### PRD-Q015

**Fokus:** Laporan setelah selesai. **Mengapa penting:** Memisahkan kejadian baru dari riwayat kejadian yang sudah selesai. **Prioritas peninjauan:** Sedang.

**Catatan jawaban dan keputusan:** Buat kelompok aktif untuk kejadian baru, tidak otomatis mengaktifkan kelompok selesai yang lama.

**Status:** `CONFIRMED`. **Jejak:** PRD-CL057 → PRD-DEC-015 → PRD-F-028. Pemilik keputusan: pengguna/pemilik proyek; pilihan yang didelegasikan dijelaskan dalam catatan di atas.

### PRD-Q016

**Fokus:** Badge setelah bukti baru. **Mengapa penting:** Mencegah tinjauan lama dianggap mencakup bukti baru. **Prioritas peninjauan:** Sedang.

**Catatan jawaban dan keputusan:** Perlu ditinjau ulang; riwayat tinjauan lama tetap ada.

**Status:** `CONFIRMED`. **Jejak:** PRD-CL058 → PRD-DEC-016 → PRD-F-026. Pemilik keputusan: pengguna/pemilik proyek; pilihan yang didelegasikan dijelaskan dalam catatan di atas.

### PRD-Q017

**Fokus:** Tingkat Pantau. **Mengapa penting:** Menetapkan istilah tingkat publik tanpa menyamakan ketidakpastian dengan rendah. **Prioritas peninjauan:** Sedang.

**Catatan jawaban dan keputusan:** Rendah, sedang, tinggi; belum dinilai terpisah. Indikasi laporan bukan status resmi.

**Status:** `CONFIRMED`. **Jejak:** PRD-CL059 → PRD-DEC-017 → PRD-F-036. Pemilik keputusan: pengguna/pemilik proyek; pilihan yang didelegasikan dijelaskan dalam catatan di atas.

### PRD-Q018

**Fokus:** Unsur laporan. **Mengapa penting:** Menetapkan unsur laporan wajib tanpa menambahkan field secara diam-diam. **Prioritas peninjauan:** Tinggi.

**Catatan jawaban dan keputusan:** Media, deskripsi dan titik wajib; waktu kirim otomatis, waktu kejadian boleh diisi jika berbeda. User mengizinkan tambahan penting dengan alasan; root tidak menambah isian wajib lain, sumber lokasi/waktu menjadi metadata.

**Status:** `CONFIRMED_WITH_LIMITED_DELEGATION`. **Jejak:** PRD-CL060 → PRD-DEC-018 → PRD-F-008, PRD-F-009. Pemilik keputusan: pengguna/pemilik proyek; pilihan yang didelegasikan dijelaskan dalam catatan di atas.

### PRD-Q019

**Fokus:** Tas personal. **Mengapa penting:** Menentukan hubungan kebutuhan keluarga dengan tas siaga. **Prioritas peninjauan:** Sedang.

**Catatan jawaban dan keputusan:** Kategori kebutuhan keluarga dan item tambahan sendiri; personalisasi berhubungan dengan daftar keluarga dalam fitur dokumen. Sumber ekstraksi dipertegas Q022.

**Status:** `CONFIRMED`. **Jejak:** PRD-CL061 → PRD-DEC-019 → PRD-F-043, PRD-F-046, PRD-F-047. Pemilik keputusan: pengguna/pemilik proyek; pilihan yang didelegasikan dijelaskan dalam catatan di atas.

### PRD-Q020

**Fokus:** Penyimpanan tas. **Mengapa penting:** Membedakan penyimpanan checklist lokal dari sinkronisasi backend. **Prioritas peninjauan:** Sedang.

**Catatan jawaban dan keputusan:** Checklist, item dan progres cukup lokal perangkat, bukan sinkron backend.

**Status:** `CONFIRMED`. **Jejak:** PRD-CL062 → PRD-DEC-020 → PRD-F-047, PRD-F-050. Pemilik keputusan: pengguna/pemilik proyek; pilihan yang didelegasikan dijelaskan dalam catatan di atas.

### PRD-Q021

**Fokus:** Konten dan kontak pribadi. **Mengapa penting:** Membedakan konten umum yang dikelola admin dan kontak pribadi warga. **Prioritas peninjauan:** Sedang.

**Catatan jawaban dan keputusan:** Admin web memperbarui kontak umum/panduan/katalog tas. Warga juga menambah kontak saudara; kontak pribadi lokal perangkat, tidak masuk database backend.

**Status:** `CONFIRMED`. **Jejak:** PRD-CL063 → PRD-DEC-021 → PRD-F-048, PRD-F-049, PRD-F-053, PRD-NF-005. Pemilik keputusan: pengguna/pemilik proyek; pilihan yang didelegasikan dijelaskan dalam catatan di atas.

### PRD-Q022

**Fokus:** Pengisian otomatis keluarga. **Mengapa penting:** Menentukan tujuan pengisian daftar keluarga dari dokumen. **Prioritas peninjauan:** Tinggi.

**Catatan jawaban dan keputusan:** User menginginkan OCR/AI membaca dokumen agar daftar keluarga otomatis terisi, mengurangi input satu per satu.

**Status:** `CONFIRMED`. **Jejak:** PRD-CL064 → PRD-DEC-022 → PRD-F-039, PRD-F-040, PRD-F-043, PRD-NF-003. Pemilik keputusan: pengguna/pemilik proyek; pilihan yang didelegasikan dijelaskan dalam catatan di atas.

### PRD-Q023

**Fokus:** Data minimum keluarga. **Mengapa penting:** Membatasi informasi keluarga pada kebutuhan produk yang disepakati. **Prioritas peninjauan:** Tinggi.

**Catatan jawaban dan keputusan:** Nama panggilan, kelompok usia, kategori kebutuhan khusus opsional; rincian kategori pada tahap berikut.

**Status:** `CONFIRMED`. **Jejak:** PRD-CL065 → PRD-DEC-023 → PRD-F-041, PRD-F-043. Pemilik keputusan: pengguna/pemilik proyek; pilihan yang didelegasikan dijelaskan dalam catatan di atas.

### PRD-Q024

**Fokus:** Penyimpanan keluarga. **Mengapa penting:** Menentukan tempat dan hak akses profil keluarga secara terpisah dari checklist. **Prioritas peninjauan:** Tinggi.

**Catatan jawaban dan keputusan:** Backend privat pemilik, lintas perangkat; keputusan checklist lokal tetap berlaku.

**Status:** `CONFIRMED`. **Jejak:** PRD-CL066 → PRD-DEC-024 → PRD-F-043, PRD-NF-005. Pemilik keputusan: pengguna/pemilik proyek; pilihan yang didelegasikan dijelaskan dalam catatan di atas.

### PRD-Q025

**Fokus:** Pemroses dan bahasa UI. **Mengapa penting:** Menjaga persetujuan pemrosesan dokumen dan kejelasan bahasa antarmuka. **Prioritas peninjauan:** Tinggi.

**Catatan jawaban dan keputusan:** Pertanyaan mengusulkan backend memakai DeepSeek dengan persetujuan pemindaian; user menjawab ya, tetapi minta UI mengonfirmasi manfaat isi otomatis tanpa jargon AI/OCR, proses boleh berlangsung bertahap. Rencana yang disetujui mempertahankan DeepSeek dan informasi layanan eksternal dalam keterangan privasi; tidak mengklaim user menyetujui copy privasi spesifik. **Batas persetujuan:** persetujuan manfaat pengisian otomatis tidak berarti seluruh salinan teks privasi sudah disetujui atau pemrosesan semua dokumen diizinkan tanpa pilihan pemilik.

**Status:** `CONFIRMED_WITH_UX_CONSTRAINT`. **Jejak:** PRD-CL067 → PRD-DEC-025 → PRD-F-039, PRD-F-040, PRD-NF-003, PRD-NF-005. Pemilik keputusan: pengguna/pemilik proyek; pilihan yang didelegasikan dijelaskan dalam catatan di atas.

### PRD-Q026

**Fokus:** Review hasil. **Mengapa penting:** Memastikan hasil otomatis diperiksa sebelum menjadi data keluarga. **Prioritas peninjauan:** Tinggi.

**Catatan jawaban dan keputusan:** Periksa hasil otomatis lalu terapkan sekaligus; dapat memperbaiki. Kebutuhan khusus tidak ditebak dari identitas.

**Status:** `CONFIRMED`. **Jejak:** PRD-CL068 → PRD-DEC-026 → PRD-F-041. Pemilik keputusan: pengguna/pemilik proyek; pilihan yang didelegasikan dijelaskan dalam catatan di atas.

### PRD-Q027

**Fokus:** Gagal ekstraksi. **Mengapa penting:** Menjaga backup dokumen tetap berguna ketika pengisian otomatis gagal. **Prioritas peninjauan:** Tinggi.

**Catatan jawaban dan keputusan:** Ulangi atau isi manual; backup dokumen tetap dapat tersimpan.

**Status:** `CONFIRMED`. **Jejak:** PRD-CL069 → PRD-DEC-027 → PRD-F-037, PRD-F-042, PRD-NF-006. Pemilik keputusan: pengguna/pemilik proyek; pilihan yang didelegasikan dijelaskan dalam catatan di atas.

### PRD-Q028

**Fokus:** Pemisahan data lokal. **Mengapa penting:** Mencegah akun berbeda pada satu perangkat melihat data lokal satu sama lain. **Prioritas peninjauan:** Tinggi.

**Catatan jawaban dan keputusan:** Pisahkan kontak pribadi, item tas dan progres menurut akun di perangkat; akun lain tidak melihatnya.

**Status:** `CONFIRMED`. **Jejak:** PRD-CL070 → PRD-DEC-028 → PRD-F-050, PRD-F-057, PRD-NF-005. Pemilik keputusan: pengguna/pemilik proyek; pilihan yang didelegasikan dijelaskan dalam catatan di atas.

### PRD-Q029

**Fokus:** Impor berikutnya. **Mengapa penting:** Mencegah impor baru menghapus daftar keluarga lama tanpa pilihan pengguna. **Prioritas peninjauan:** Tinggi.

**Catatan jawaban dan keputusan:** Tinjau lalu gabungkan; pilih anggota yang ditambah/diperbarui, tidak hapus anggota lama otomatis.

**Status:** `CONFIRMED`. **Jejak:** PRD-CL071 → PRD-DEC-029 → PRD-F-044. Pemilik keputusan: pengguna/pemilik proyek; pilihan yang didelegasikan dijelaskan dalam catatan di atas.

### PRD-Q030

**Fokus:** Hapus dokumen sumber. **Mengapa penting:** Memisahkan siklus hidup dokumen sumber dan profil keluarga. **Prioritas peninjauan:** Tinggi.

**Catatan jawaban dan keputusan:** Profil keluarga tetap tersimpan; dikelola terpisah dari dokumen.

**Status:** `CONFIRMED`. **Jejak:** PRD-CL072 → PRD-DEC-030 → PRD-F-037, PRD-F-045. Pemilik keputusan: pengguna/pemilik proyek; pilihan yang didelegasikan dijelaskan dalam catatan di atas.

### PRD-Q031

**Fokus:** Offline instalasi pertama. **Mengapa penting:** Menetapkan pengalaman membaca konten dasar pada instalasi awal tanpa jaringan. **Prioritas peninjauan:** Sedang.

**Catatan jawaban dan keputusan:** Kontak umum dan teks panduan dasar dibundel; pembaruan admin diambil saat online.

**Status:** `CONFIRMED`. **Jejak:** PRD-CL073 → PRD-DEC-031 → PRD-F-052. Pemilik keputusan: pengguna/pemilik proyek; pilihan yang didelegasikan dijelaskan dalam catatan di atas.

### PRD-Q032

**Fokus:** Suara offline. **Mengapa penting:** Membatasi janji suara offline sesuai dukungan perangkat. **Prioritas peninjauan:** Sedang.

**Catatan jawaban dan keputusan:** Ikuti dukungan mesin/bahasa perangkat; jika tidak tersedia teks tetap dibaca dan keterbatasan dijelaskan.

**Status:** `CONFIRMED`. **Jejak:** PRD-CL074 → PRD-DEC-032 → PRD-F-051. Pemilik keputusan: pengguna/pemilik proyek; pilihan yang didelegasikan dijelaskan dalam catatan di atas.

### PRD-Q033

**Fokus:** Personalisasi katalog. **Mengapa penting:** Membedakan pemilihan katalog dari generasi daftar bebas oleh AI. **Prioritas peninjauan:** Sedang.

**Catatan jawaban dan keputusan:** Pilih barang dari katalog admin berdasarkan kategori usia/kebutuhan keluarga; warga menambah item sendiri. Tidak perlu generasi daftar bebas oleh AI.

**Status:** `CONFIRMED`. **Jejak:** PRD-CL075 → PRD-DEC-033 → PRD-F-046. Pemilik keputusan: pengguna/pemilik proyek; pilihan yang didelegasikan dijelaskan dalam catatan di atas.

### PRD-Q034

**Fokus:** Verifikasi dan KTP tambahan. **Mengapa penting:** Menetapkan batas login demo dan kebutuhan KTP tanpa menutup akses tamu. **Prioritas peninjauan:** Tinggi.

**Catatan jawaban dan keputusan:** User menegaskan login, mempertimbangkan email verification/Google bila tidak merepotkan dan mendelegasikan pilihan aman; menambahkan KTP minimal untuk melapor. Root memilih email/sandi lokal + kode pemulihan untuk demo, email verification/Google ditunda; Q043 menerima konsolidasi. Tidak mengubah akses informasi umum tanpa login. **Batas delegasi:** penundaan verifikasi email/Google adalah pilihan demo dalam ruang delegasi yang kemudian dikonsolidasikan, bukan penolakan permanen kedua kemampuan itu.

**Status:** `DELEGATED_THEN_CONSOLIDATED`. **Jejak:** PRD-CL076 → PRD-DEC-034 → PRD-F-002, PRD-F-003, PRD-F-011, PRD-NF-004. Pemilik keputusan: pengguna/pemilik proyek; pilihan yang didelegasikan dijelaskan dalam catatan di atas.

### PRD-Q035

**Fokus:** Pemulihan akun. **Mengapa penting:** Menentukan pemulihan akun tanpa kewajiban layanan email. **Prioritas peninjauan:** Tinggi.

**Catatan jawaban dan keputusan:** Kode pemulihan pribadi diberikan saat daftar, disimpan pemilik; tidak perlu layanan email.

**Status:** `CONFIRMED`. **Jejak:** PRD-CL077 → PRD-DEC-035 → PRD-F-005, PRD-NF-004. Pemilik keputusan: pengguna/pemilik proyek; pilihan yang didelegasikan dijelaskan dalam catatan di atas.

### PRD-Q036

**Fokus:** Akun admin. **Mengapa penting:** Menetapkan kesetaraan admin serta tidak adanya registrasi admin publik. **Prioritas peninjauan:** Tinggi.

**Catatan jawaban dan keputusan:** Dua admin setara, disiapkan tim; tidak ada pendaftaran admin publik.

**Status:** `CONFIRMED`. **Jejak:** PRD-CL078 → PRD-DEC-036 → PRD-F-006. Pemilik keputusan: pengguna/pemilik proyek; pilihan yang didelegasikan dijelaskan dalam catatan di atas.

### PRD-Q037

**Fokus:** KTP sebelum melapor. **Mengapa penting:** Menentukan kapan KTP diperlukan dalam perjalanan membuat laporan. **Prioritas peninjauan:** Tinggi.

**Catatan jawaban dan keputusan:** Sekali per akun sebelum laporan pertama; draf boleh dibuat dahulu; KTP tidak dilampirkan ulang pada setiap laporan.

**Status:** `CONFIRMED`. **Jejak:** PRD-CL079 → PRD-DEC-037 → PRD-F-011. Pemilik keputusan: pengguna/pemilik proyek; pilihan yang didelegasikan dijelaskan dalam catatan di atas.

### PRD-Q038

**Fokus:** Pemeriksaan KTP. **Mengapa penting:** Membedakan pemeriksaan dokumen dari verifikasi identitas resmi. **Prioritas peninjauan:** Tinggi.

**Catatan jawaban dan keputusan:** Sistem membantu cek jenis/keterbacaan dan pengguna mengonfirmasi; bukan verifikasi NIK resmi, admin tetap tidak membaca isi. **Batas klaim:** pemeriksaan jenis/keterbacaan tidak membuktikan keaslian KTP, kecocokan orang, atau keabsahan NIK.

**Status:** `CONFIRMED`. **Jejak:** PRD-CL080 → PRD-DEC-038 → PRD-F-012. Pemilik keputusan: pengguna/pemilik proyek; pilihan yang didelegasikan dijelaskan dalam catatan di atas.

### PRD-Q039

**Fokus:** KTP dihapus. **Mengapa penting:** Menetapkan dampak penghapusan KTP tanpa menghapus riwayat laporan. **Prioritas peninjauan:** Tinggi.

**Catatan jawaban dan keputusan:** Tahan pengiriman baru sampai KTP tersedia/memenuhi syarat kembali; riwayat laporan lama tidak dihapus.

**Status:** `CONFIRMED`. **Jejak:** PRD-CL081 → PRD-DEC-039 → PRD-F-013, PRD-F-037. Pemilik keputusan: pengguna/pemilik proyek; pilihan yang didelegasikan dijelaskan dalam catatan di atas.

### PRD-Q040

**Fokus:** Siklus peringatan. **Mengapa penting:** Menentukan penanganan pesan salah/tidak berlaku dan status baca warga. **Prioritas peninjauan:** Sedang.

**Catatan jawaban dan keputusan:** Admin menerbitkan, memperbaiki dan mencabut; warga menandai dibaca; perubahan/pencabutan menunjukkan status. Masa berlaku detail FRD.

**Status:** `CONFIRMED`. **Jejak:** PRD-CL082 → PRD-DEC-040 → PRD-F-054, PRD-F-055, PRD-F-056. Pemilik keputusan: pengguna/pemilik proyek; pilihan yang didelegasikan dijelaskan dalam catatan di atas.

### PRD-Q041

**Fokus:** Hapus akun. **Mengapa penting:** Mencegah penambahan fitur hapus akun sebagai kewajiban demo tanpa keputusan. **Prioritas peninjauan:** Tinggi.

**Catatan jawaban dan keputusan:** Belum wajib demo; ditunda sebagai fitur tersendiri, dokumen/data keluarga tetap dapat dikelola. **Penanganan:** fitur hapus akun tercatat ditunda secara sadar; tidak dihilangkan tanpa jejak dan tidak mengubah kemampuan mengelola dokumen/profil yang telah dipilih.

**Status:** `CONFIRMED`. **Jejak:** PRD-CL083 → PRD-DEC-041 → PRD-NF-010. Pemilik keputusan: pengguna/pemilik proyek; pilihan yang didelegasikan dijelaskan dalam catatan di atas.

### PRD-Q042

**Fokus:** Dokumen spesimen. **Mengapa penting:** Menyelaraskan jumlah spesimen dengan kebutuhan KTP dan pengisian keluarga. **Prioritas peninjauan:** Sedang.

**Catatan jawaban dan keputusan:** 6 KTP + 2 KK = 8 dokumen fiktif, menggantikan 6 dokumen lama; akun 2 admin/6 warga dan 12 laporan tetap. **Delta baseline:** BR-038/DEC-038 mencatat 6 dokumen pada tahap 1; kebutuhan PRD kini 8 spesimen. Jumlah akun dan laporan tidak berubah.

**Status:** `CONFIRMED`. **Jejak:** PRD-CL084 → PRD-DEC-042 → PRD-NF-009. Pemilik keputusan: pengguna/pemilik proyek; pilihan yang didelegasikan dijelaskan dalam catatan di atas.

### PRD-Q043

**Fokus:** Konsolidasi. **Mengapa penting:** Mengesahkan dasar scope dan urutan penulisan draft tanpa memfinalkan PRD. **Prioritas peninjauan:** Sedang.

**Catatan jawaban dan keputusan:** Ringkasan keputusan, urutan akun+KTP → laporan/analisis/admin → Pantau/kontrol → pendukung lengkap → demo serta pembagian rincian FRD/SRS disetujui sebagai dasar draf; bukan final approval PRD. **Batas approval saat Q043 dijawab:** review rumusan PRD dan AC masih diperlukan dan tahap 3 belum dimulai. Status historis jawaban ini tidak diubah; persetujuan yang datang kemudian adalah PRD-APPROVAL-01.

**Status:** `CONFIRMED_FOR_DRAFT`. **Jejak:** PRD-CL085 → PRD-DEC-043 → PRD-NF-008, PRD-NF-009, PRD-NF-010. Pemilik keputusan: pengguna/pemilik proyek; pilihan yang didelegasikan dijelaskan dalam catatan di atas.

## 12. Source Claim Ledger tahap 2

**PRD-CL001–PRD-CL042** masing-masing berasal dari BR-001–BR-042. **PRD-CL043–PRD-CL085** masing-masing berasal dari PRD-Q001–PRD-Q043 (nomor klaim = nomor pertanyaan + 42). Sumber mentah lama tetap tersedia melalui matriks tahap 1; tidak perlu mengarang sumber baru untuk kebutuhan yang memang merupakan keputusan percakapan.

### 12.1 Klaim dari baseline BRD

Status dasar adalah **BASELINE_APPROVED**. Detail yang terbuka pada BRD tidak otomatis memperoleh nilai/rumus ketika baseline diterima. Kolom tujuan menunjukkan arah source → requirement PRD, termasuk constraint atau exclusion yang diteruskan sebagai NF.

| Claim | Pernyataan sumber baseline | Sumber | Interpretasi/penanganan tahap 2 | Tujuan PRD |
|---|---|---|---|---|
| PRD-CL001 | Demo akademik untuk Padang dan sekitarnya. | BR-001; DEC-001; AC-001 | Baseline diteruskan sesuai scope; rincian hanya mengikuti keputusan yang memiliki jejak. | PRD-NF-009 |
| PRD-CL002 | Flutter Android warga dan Flutter Web admin. | BR-002; DEC-002; AC-002 | Baseline diteruskan sesuai scope; rincian hanya mengikuti keputusan yang memiliki jejak. | PRD-NF-001 |
| PRD-CL003 | Tiga pengembang dengan pembagian peran yang disepakati. | BR-003; DEC-003; AC-003 | Baseline diteruskan sesuai scope; rincian hanya mengikuti keputusan yang memiliki jejak. | PRD-F-006, PRD-NF-008 |
| PRD-CL004 | Laporan → analisis bukti → kelompok → prioritas/tinjauan admin. | BR-004; DEC-004; AC-004 | Baseline diteruskan sesuai scope; rincian hanya mengikuti keputusan yang memiliki jejak. | PRD-F-008, PRD-F-009, PRD-F-010, PRD-F-011, PRD-NF-006 |
| PRD-CL005 | Maksimal dua foto ATAU satu video maksimal lima detik per laporan. | BR-005; DEC-005; AC-005 | Baseline diteruskan sesuai scope; rincian hanya mengikuti keputusan yang memiliki jejak. | PRD-F-007 |
| PRD-CL006 | AI membantu menilai kecocokan bukti dengan keterangan. | BR-006; DEC-006; AC-006 | Baseline diteruskan sesuai scope; rincian hanya mengikuti keputusan yang memiliki jejak. | PRD-F-017, PRD-F-018, PRD-F-019 |
| PRD-CL007 | Laporan terkait dikelompokkan dengan bukti individual tetap dapat ditinjau. | BR-007; DEC-007; AC-007 | Baseline diteruskan sesuai scope; rincian hanya mengikuti keputusan yang memiliki jejak. | PRD-F-009, PRD-F-021 |
| PRD-CL008 | Prioritas tinjauan admin dan indikasi bahaya untuk warga mempunyai makna yang jelas. | BR-008; DEC-008; AC-008 | Perbedaan makna tetap; label publik diperinci PRD-Q017, rumus rinci masih pekerjaan berikutnya. | PRD-F-022, PRD-F-036 |
| PRD-CL009 | Admin meninjau dan memperbaiki hasil AI/pengelompokan. | BR-009; DEC-009; AC-009 | Baseline diteruskan sesuai scope; rincian hanya mengikuti keputusan yang memiliki jejak. | PRD-F-023, PRD-F-024 |
| PRD-CL010 | Admin mencatat tindak lanjut sederhana tanpa dispatch armada. | BR-010; DEC-010; AC-010 | Baseline diteruskan sesuai scope; rincian hanya mengikuti keputusan yang memiliki jejak. | PRD-F-025 |
| PRD-CL011 | Admin mengaktifkan/menonaktifkan sumber media galeri secara global. | BR-011; DEC-011; AC-011 | Baseline diteruskan sesuai scope; rincian hanya mengikuti keputusan yang memiliki jejak. | PRD-F-029 |
| PRD-CL012 | Admin mengatur N laporan per H jam untuk setiap akun dengan aturan umum. | BR-012; DEC-012; AC-012 | Baseline diteruskan sesuai scope; rincian hanya mengikuti keputusan yang memiliki jejak. | PRD-F-030 |
| PRD-CL013 | Admin mereset kuota satu akun atau semua akun. | BR-013; DEC-013; AC-013 | Baseline diteruskan sesuai scope; rincian hanya mengikuti keputusan yang memiliki jejak. | PRD-F-031 |
| PRD-CL014 | Admin menghapus laporan dan media secara permanen dari penyimpanan aktif. | BR-014; DEC-014; AC-014 | Baseline diteruskan sesuai scope; rincian hanya mengikuti keputusan yang memiliki jejak. | PRD-F-032 |
| PRD-CL015 | Penghapusan memperbarui riwayat warga, kelompok, dan Pantau. | BR-015; DEC-015; AC-015 | Baseline diteruskan sesuai scope; rincian hanya mengikuti keputusan yang memiliki jejak. | PRD-F-033, PRD-NF-006 |
| PRD-CL016 | Pantau berupa daftar sederhana kelompok lokasi yang mempunyai laporan, tanpa membuka identitas/kontak pelapor atau media laporan individual kepada warga lain. | BR-016; DEC-016; AC-016 | Baseline diteruskan sesuai scope; rincian hanya mengikuti keputusan yang memiliki jejak. | PRD-F-001, PRD-F-034, PRD-F-035 |
| PRD-CL017 | Informasi Pantau muncul otomatis tanpa menunggu persetujuan admin. | BR-017; DEC-017; AC-017 | Baseline diteruskan sesuai scope; rincian hanya mengikuti keputusan yang memiliki jejak. | PRD-F-035 |
| PRD-CL018 | Kelompok yang belum dinilai dipisahkan dari kelompok yang sudah mempunyai tingkat. | BR-018; DEC-018; AC-018 | Baseline diteruskan sesuai scope; rincian hanya mengikuti keputusan yang memiliki jejak. | PRD-F-019, PRD-F-020, PRD-F-036, PRD-NF-006 |
| PRD-CL019 | Tinjauan admin memberi penanda tambahan pada informasi publik. | BR-019; DEC-019; AC-019 | Baseline diteruskan sesuai scope; rincian hanya mengikuti keputusan yang memiliki jejak. | PRD-F-026, PRD-F-034 |
| PRD-CL020 | Admin menandai kejadian selesai untuk mengeluarkannya dari Pantau aktif. | BR-020; DEC-020; AC-020 | Baseline diteruskan sesuai scope; rincian hanya mengikuti keputusan yang memiliki jejak. | PRD-F-027, PRD-F-028 |
| PRD-CL021 | Inti didahulukan; pendukung yang disepakati tetap wajib. | BR-021; DEC-021; AC-021 | Baseline diteruskan sesuai scope; rincian hanya mengikuti keputusan yang memiliki jejak. | PRD-NF-008, PRD-NF-010 |
| PRD-CL022 | Tas siaga berupa checklist kesiapsiagaan. | BR-022; DEC-022; AC-022 | Diperinci melalui discovery fitur pendukung; tidak otomatis mengadopsi seluruh detail legacy. | PRD-F-043, PRD-F-046, PRD-F-047, PRD-F-050, PRD-F-053 |
| PRD-CL023 | Direktori kontak darurat. | BR-023; DEC-023; AC-023 | Diperinci melalui discovery fitur pendukung; tidak otomatis mengadopsi seluruh detail legacy. | PRD-F-001, PRD-F-048, PRD-F-049, PRD-F-050, PRD-F-052, PRD-F-053, PRD-NF-007 |
| PRD-CL024 | Panduan kesiapsiagaan dengan bantuan suara. | BR-024; DEC-024; AC-024 | Diperinci melalui discovery fitur pendukung; tidak otomatis mengadopsi seluruh detail legacy. | PRD-F-001, PRD-F-051, PRD-F-052, PRD-F-053, PRD-NF-007 |
| PRD-CL025 | Backup dokumen pada backend, privat untuk pemilik dan dapat diambil kembali setelah login di perangkat lain. | BR-025; DEC-025; AC-025 | Diperinci oleh keputusan KTP, backup, dan pengisian keluarga; batas akses privat dipertahankan. | PRD-F-011, PRD-F-012, PRD-F-013, PRD-F-037, PRD-F-038, PRD-F-039, PRD-F-040, PRD-F-041, PRD-F-042, PRD-F-043, PRD-F-044, PRD-F-045, PRD-NF-005 |
| PRD-CL026 | Admin membuat pesan peringatan yang masuk ke inbox seluruh warga. | BR-026; DEC-026; AC-026 | Baseline diteruskan sesuai scope; rincian hanya mengikuti keputusan yang memiliki jejak. | PRD-F-054, PRD-F-055, PRD-F-056 |
| PRD-CL027 | Akun, profil, riwayat laporan, dan pembuatan akun untuk pengujian. | BR-027; DEC-027; AC-027 | Baseline diteruskan sesuai scope; rincian hanya mengikuti keputusan yang memiliki jejak. | PRD-F-002, PRD-F-003, PRD-F-004, PRD-F-005, PRD-F-006, PRD-F-011, PRD-F-016, PRD-F-017, PRD-F-050, PRD-F-057, PRD-NF-005 |
| PRD-CL028 | Pemantauan sungai diganti oleh Pantau laporan. | BR-028; DEC-028; AC-028 | Baseline diteruskan sesuai scope; rincian hanya mengikuti keputusan yang memiliki jejak. | PRD-NF-010 |
| PRD-CL029 | Modul posko/shelter dihapus. | BR-029; DEC-029; AC-029 | Baseline diteruskan sesuai scope; rincian hanya mengikuti keputusan yang memiliki jejak. | PRD-NF-010 |
| PRD-CL030 | Laragon 6 dan MySQL digunakan untuk lingkungan kuliah. | BR-030; DEC-030; AC-030 | Baseline diteruskan sesuai scope; rincian hanya mengikuti keputusan yang memiliki jejak. | PRD-NF-002 |
| PRD-CL031 | Satu codebase TypeScript dengan API dan worker sebagai proses berbeda. | BR-031; DEC-031; AC-031 | Baseline diteruskan sesuai scope; rincian hanya mengikuti keputusan yang memiliki jejak. | PRD-NF-002 |
| PRD-CL032 | Memanfaatkan kredit API DeepSeek yang dimiliki pengguna. | BR-032; DEC-032; AC-032 | Baseline diteruskan sesuai scope; rincian hanya mengikuti keputusan yang memiliki jejak. | PRD-NF-003 |
| PRD-CL033 | Efisien memakai AI: frame terbatas dan optimasi media yang mempertahankan kegunaan hasil. | BR-033; DEC-033; AC-033 | Baseline diteruskan sesuai scope; rincian hanya mengikuti keputusan yang memiliki jejak. | PRD-NF-003 |
| PRD-CL034 | Demo lokal utama dan persiapan portabilitas hosting pada tahap 5. | BR-034; DEC-034; AC-034 | Baseline diteruskan sesuai scope; rincian hanya mengikuti keputusan yang memiliki jejak. | PRD-NF-008 |
| PRD-CL035 | Sedapat mungkin tidak menambah langganan pengembangan berbayar yang wajib. | BR-035; DEC-035; AC-035 | Baseline diteruskan sesuai scope; rincian hanya mengikuti keputusan yang memiliki jejak. | PRD-NF-004 |
| PRD-CL036 | Branch tugas pada fork → PR ke main pusat, dengan review/perapian sebelum merge. | BR-036; DEC-036; AC-036 | Baseline diteruskan sesuai scope; rincian hanya mengikuti keputusan yang memiliki jejak. | PRD-NF-008 |
| PRD-CL037 | Desain lama menjadi acuan tema dan kandidat fitur. | BR-037; DEC-037; AC-037 | Baseline diteruskan sesuai scope; rincian hanya mengikuti keputusan yang memiliki jejak. | PRD-NF-007 |
| PRD-CL038 | Paket awal 2 admin, 6 warga, 12 laporan, dan 6 dokumen fiktif. | BR-038; DEC-038; AC-038 | Jumlah 6 dokumen adalah historis; PRD-Q042 mengubahnya menjadi 8 spesimen. Akun/laporan tetap. | PRD-NF-009 |
| PRD-CL039 | Dosen/mahasiswa menguji perilaku aplikasi sebenarnya. | BR-039; DEC-039; AC-039 | Baseline diteruskan sesuai scope; rincian hanya mengikuti keputusan yang memiliki jejak. | PRD-F-010, PRD-NF-006, PRD-NF-009 |
| PRD-CL040 | Lima tahap dikerjakan berurutan dengan ringkasan serta konfirmasi antar tahap. | BR-040; DEC-040; AC-040 | Baseline diteruskan sesuai scope; rincian hanya mengikuti keputusan yang memiliki jejak. | PRD-NF-010 |
| PRD-CL041 | Kemajuan berbasis fitur tanpa tenggat tetap. | BR-041; DEC-041; AC-041 | Baseline diteruskan sesuai scope; rincian hanya mengikuti keputusan yang memiliki jejak. | PRD-NF-008 |
| PRD-CL042 | Draf laporan beserta media tersimpan saat offline, dapat dikirim setelah koneksi kembali tanpa duplikasi; kontak dan teks panduan tetap dapat dibaca offline. | BR-042; DEC-042; AC-042 | Baseline diteruskan sesuai scope; rincian hanya mengikuti keputusan yang memiliki jejak. | PRD-F-014, PRD-F-015, PRD-F-052, PRD-NF-006 |

### 12.2 Klaim dari keputusan discovery PRD

Setiap baris menunjuk jawaban/keputusan pada ledger; tabel ini tidak mengubah parafrasa menjadi kutipan pengguna. `REFINED` pada PRD-Q003 berarti rincian diperjelas oleh Q004–Q008. Delegasi pada Q007/Q034 tetap terlihat meskipun hasil konsolidasi Q043 diterima.

| Claim | Klaim/keputusan ringkas | Sumber pertanyaan | Status bukti dan keputusan | Tujuan PRD |
|---|---|---|---|---|
| PRD-CL043 | Akses tamu — Pantau, kontak umum, panduan tanpa login; laporan, dokumen, riwayat dan fitur pribadi memerlukan login. | [PRD-Q001](#prd-q001) | CONFIRMED; PRD-DEC-001 | PRD-F-001, PRD-F-003 |
| PRD-CL044 | Login warga — Email dan kata sandi lokal; verifikasi dan pemulihan dibahas terpisah. | [PRD-Q002](#prd-q002) | CONFIRMED; PRD-DEC-002 | PRD-F-002, PRD-F-003 |
| PRD-CL045 | Lokasi laporan — User memilih GPS atau titik manual; tambahan meminta mode developer harus mati untuk mencegah fake GPS. Batas teknis dirinci Q004–008. | [PRD-Q003](#prd-q003) | REFINED; PRD-DEC-003 | PRD-F-009, PRD-F-010 |
| PRD-CL046 | Deteksi sesuai dukungan — Tolak mock GPS; wajib matikan mode developer bila terdeteksi. Status tidak tersedia tidak diklaim mati. | [PRD-Q004](#prd-q004) | CONFIRMED; PRD-DEC-004 | PRD-F-010 |
| PRD-CL047 | Cakupan blokir — Blokir pengiriman laporan saja, draf tersimpan dan informasi umum tetap bisa dibuka. | [PRD-Q005](#prd-q005) | CONFIRMED; PRD-DEC-005 | PRD-F-010, PRD-F-014 |
| PRD-CL048 | Titik manual — Boleh lokasi lain; beri sumber manual, bukan bukti posisi/kehadiran pelapor. | [PRD-Q006](#prd-q006) | CONFIRMED; PRD-DEC-006 | PRD-F-009 |
| PRD-CL049 | Deteksi tidak tersedia — User: sesuaikan yang terbaik untuk menghindari laporan fiktif/penipuan. Root memilih tetap boleh mengirim bila status developer tidak tersedia, catat keterbatasan; larangan terdeteksi tetap berlaku termasuk titik manual. Diterima dalam konsolidasi Q043. | [PRD-Q007](#prd-q007) | DELEGATED_THEN_CONSOLIDATED; PRD-DEC-007 | PRD-F-010 |
| PRD-CL050 | Build internal — Build pengembangan internal boleh mengecualikan blokir mode developer; APK demo menerapkan aturan dan diuji terpisah. Tidak memberi pengecualian mock GPS tanpa batas. | [PRD-Q008](#prd-q008) | CONFIRMED; PRD-DEC-008 | PRD-F-010 |
| PRD-CL051 | AI tidak cocok — Terima dan tandai perlu review; bukti tersebut belum dipakai untuk tingkat bahaya sebelum ditinjau. Kelompok tanpa bukti layak tetap belum dinilai. | [PRD-Q009](#prd-q009) | CONFIRMED; PRD-DEC-009 | PRD-F-019, PRD-F-020, PRD-NF-006 |
| PRD-CL052 | Detail milik pelapor — Bukti sendiri, status, ringkasan AI/ketidakpastian serta hasil tinjauan admin terlihat oleh pemilik. | [PRD-Q010](#prd-q010) | CONFIRMED; PRD-DEC-010 | PRD-F-016, PRD-F-017 |
| PRD-CL053 | Laporan terkirim — Hanya baca setelah diterima backend; draf boleh diperbaiki, pengelolaan laporan terkirim melalui admin. | [PRD-Q011](#prd-q011) | CONFIRMED; PRD-DEC-011 | PRD-F-016 |
| PRD-CL054 | Kirim offline — Percobaan ulang otomatis untuk laporan yang sudah ditekan Kirim saat aplikasi aktif dan online; tombol coba lagi. Draf belum ditekan Kirim tetap draf. Tidak menjanjikan background saat aplikasi ditutup. | [PRD-Q012](#prd-q012) | CONFIRMED; PRD-DEC-012 | PRD-F-014, PRD-F-015, PRD-NF-006 |
| PRD-CL055 | Koreksi kelompok — Pindah laporan ke kelompok yang ada atau kelompok baru; aksi massal gabung/pisah khusus tidak wajib. | [PRD-Q013](#prd-q013) | CONFIRMED; PRD-DEC-013 | PRD-F-024, PRD-NF-010 |
| PRD-CL056 | Catatan tindak lanjut — Admin dan pelapor dapat membaca catatan; warga lain tidak. Bukan chat dua arah. | [PRD-Q014](#prd-q014) | CONFIRMED; PRD-DEC-014 | PRD-F-025 |
| PRD-CL057 | Laporan setelah selesai — Buat kelompok aktif untuk kejadian baru, tidak otomatis mengaktifkan kelompok selesai yang lama. | [PRD-Q015](#prd-q015) | CONFIRMED; PRD-DEC-015 | PRD-F-028 |
| PRD-CL058 | Badge setelah bukti baru — Perlu ditinjau ulang; riwayat tinjauan lama tetap ada. | [PRD-Q016](#prd-q016) | CONFIRMED; PRD-DEC-016 | PRD-F-026 |
| PRD-CL059 | Tingkat Pantau — Rendah, sedang, tinggi; belum dinilai terpisah. Indikasi laporan bukan status resmi. | [PRD-Q017](#prd-q017) | CONFIRMED; PRD-DEC-017 | PRD-F-036 |
| PRD-CL060 | Unsur laporan — Media, deskripsi dan titik wajib; waktu kirim otomatis, waktu kejadian boleh diisi jika berbeda. User mengizinkan tambahan penting dengan alasan; root tidak menambah isian wajib lain, sumber lokasi/waktu menjadi metadata. | [PRD-Q018](#prd-q018) | CONFIRMED_WITH_LIMITED_DELEGATION; PRD-DEC-018 | PRD-F-008, PRD-F-009 |
| PRD-CL061 | Tas personal — Kategori kebutuhan keluarga dan item tambahan sendiri; personalisasi berhubungan dengan daftar keluarga dalam fitur dokumen. Sumber ekstraksi dipertegas Q022. | [PRD-Q019](#prd-q019) | CONFIRMED; PRD-DEC-019 | PRD-F-043, PRD-F-046, PRD-F-047 |
| PRD-CL062 | Penyimpanan tas — Checklist, item dan progres cukup lokal perangkat, bukan sinkron backend. | [PRD-Q020](#prd-q020) | CONFIRMED; PRD-DEC-020 | PRD-F-047, PRD-F-050 |
| PRD-CL063 | Konten dan kontak pribadi — Admin web memperbarui kontak umum/panduan/katalog tas. Warga juga menambah kontak saudara; kontak pribadi lokal perangkat, tidak masuk database backend. | [PRD-Q021](#prd-q021) | CONFIRMED; PRD-DEC-021 | PRD-F-048, PRD-F-049, PRD-F-053, PRD-NF-005 |
| PRD-CL064 | Pengisian otomatis keluarga — User menginginkan OCR/AI membaca dokumen agar daftar keluarga otomatis terisi, mengurangi input satu per satu. | [PRD-Q022](#prd-q022) | CONFIRMED; PRD-DEC-022 | PRD-F-039, PRD-F-040, PRD-F-043, PRD-NF-003 |
| PRD-CL065 | Data minimum keluarga — Nama panggilan, kelompok usia, kategori kebutuhan khusus opsional; rincian kategori pada tahap berikut. | [PRD-Q023](#prd-q023) | CONFIRMED; PRD-DEC-023 | PRD-F-041, PRD-F-043 |
| PRD-CL066 | Penyimpanan keluarga — Backend privat pemilik, lintas perangkat; keputusan checklist lokal tetap berlaku. | [PRD-Q024](#prd-q024) | CONFIRMED; PRD-DEC-024 | PRD-F-043, PRD-NF-005 |
| PRD-CL067 | Pemroses dan bahasa UI — Pertanyaan mengusulkan backend memakai DeepSeek dengan persetujuan pemindaian; user menjawab ya, tetapi minta UI mengonfirmasi manfaat isi otomatis tanpa jargon AI/OCR, proses boleh berlangsung bertahap. Rencana yang disetujui mempertahankan DeepSeek dan informasi layanan eksternal dalam keterangan privasi; tidak mengklaim user menyetujui copy privasi spesifik. | [PRD-Q025](#prd-q025) | CONFIRMED_WITH_UX_CONSTRAINT; PRD-DEC-025 | PRD-F-039, PRD-F-040, PRD-NF-003, PRD-NF-005 |
| PRD-CL068 | Review hasil — Periksa hasil otomatis lalu terapkan sekaligus; dapat memperbaiki. Kebutuhan khusus tidak ditebak dari identitas. | [PRD-Q026](#prd-q026) | CONFIRMED; PRD-DEC-026 | PRD-F-041 |
| PRD-CL069 | Gagal ekstraksi — Ulangi atau isi manual; backup dokumen tetap dapat tersimpan. | [PRD-Q027](#prd-q027) | CONFIRMED; PRD-DEC-027 | PRD-F-037, PRD-F-042, PRD-NF-006 |
| PRD-CL070 | Pemisahan data lokal — Pisahkan kontak pribadi, item tas dan progres menurut akun di perangkat; akun lain tidak melihatnya. | [PRD-Q028](#prd-q028) | CONFIRMED; PRD-DEC-028 | PRD-F-050, PRD-F-057, PRD-NF-005 |
| PRD-CL071 | Impor berikutnya — Tinjau lalu gabungkan; pilih anggota yang ditambah/diperbarui, tidak hapus anggota lama otomatis. | [PRD-Q029](#prd-q029) | CONFIRMED; PRD-DEC-029 | PRD-F-044 |
| PRD-CL072 | Hapus dokumen sumber — Profil keluarga tetap tersimpan; dikelola terpisah dari dokumen. | [PRD-Q030](#prd-q030) | CONFIRMED; PRD-DEC-030 | PRD-F-037, PRD-F-045 |
| PRD-CL073 | Offline instalasi pertama — Kontak umum dan teks panduan dasar dibundel; pembaruan admin diambil saat online. | [PRD-Q031](#prd-q031) | CONFIRMED; PRD-DEC-031 | PRD-F-052 |
| PRD-CL074 | Suara offline — Ikuti dukungan mesin/bahasa perangkat; jika tidak tersedia teks tetap dibaca dan keterbatasan dijelaskan. | [PRD-Q032](#prd-q032) | CONFIRMED; PRD-DEC-032 | PRD-F-051 |
| PRD-CL075 | Personalisasi katalog — Pilih barang dari katalog admin berdasarkan kategori usia/kebutuhan keluarga; warga menambah item sendiri. Tidak perlu generasi daftar bebas oleh AI. | [PRD-Q033](#prd-q033) | CONFIRMED; PRD-DEC-033 | PRD-F-046 |
| PRD-CL076 | Verifikasi dan KTP tambahan — User menegaskan login, mempertimbangkan email verification/Google bila tidak merepotkan dan mendelegasikan pilihan aman; menambahkan KTP minimal untuk melapor. Root memilih email/sandi lokal + kode pemulihan untuk demo, email verification/Google ditunda; Q043 menerima konsolidasi. Tidak mengubah akses informasi umum tanpa login. | [PRD-Q034](#prd-q034) | DELEGATED_THEN_CONSOLIDATED; PRD-DEC-034 | PRD-F-002, PRD-F-003, PRD-F-011, PRD-NF-004 |
| PRD-CL077 | Pemulihan akun — Kode pemulihan pribadi diberikan saat daftar, disimpan pemilik; tidak perlu layanan email. | [PRD-Q035](#prd-q035) | CONFIRMED; PRD-DEC-035 | PRD-F-005, PRD-NF-004 |
| PRD-CL078 | Akun admin — Dua admin setara, disiapkan tim; tidak ada pendaftaran admin publik. | [PRD-Q036](#prd-q036) | CONFIRMED; PRD-DEC-036 | PRD-F-006 |
| PRD-CL079 | KTP sebelum melapor — Sekali per akun sebelum laporan pertama; draf boleh dibuat dahulu; KTP tidak dilampirkan ulang pada setiap laporan. | [PRD-Q037](#prd-q037) | CONFIRMED; PRD-DEC-037 | PRD-F-011 |
| PRD-CL080 | Pemeriksaan KTP — Sistem membantu cek jenis/keterbacaan dan pengguna mengonfirmasi; bukan verifikasi NIK resmi, admin tetap tidak membaca isi. | [PRD-Q038](#prd-q038) | CONFIRMED; PRD-DEC-038 | PRD-F-012 |
| PRD-CL081 | KTP dihapus — Tahan pengiriman baru sampai KTP tersedia/memenuhi syarat kembali; riwayat laporan lama tidak dihapus. | [PRD-Q039](#prd-q039) | CONFIRMED; PRD-DEC-039 | PRD-F-013, PRD-F-037 |
| PRD-CL082 | Siklus peringatan — Admin menerbitkan, memperbaiki dan mencabut; warga menandai dibaca; perubahan/pencabutan menunjukkan status. Masa berlaku detail FRD. | [PRD-Q040](#prd-q040) | CONFIRMED; PRD-DEC-040 | PRD-F-054, PRD-F-055, PRD-F-056 |
| PRD-CL083 | Hapus akun — Belum wajib demo; ditunda sebagai fitur tersendiri, dokumen/data keluarga tetap dapat dikelola. | [PRD-Q041](#prd-q041) | CONFIRMED; PRD-DEC-041 | PRD-NF-010 |
| PRD-CL084 | Dokumen spesimen — 6 KTP + 2 KK = 8 dokumen fiktif, menggantikan 6 dokumen lama; akun 2 admin/6 warga dan 12 laporan tetap. | [PRD-Q042](#prd-q042) | CONFIRMED; PRD-DEC-042 | PRD-NF-009 |
| PRD-CL085 | Konsolidasi — Ringkasan keputusan, urutan akun+KTP → laporan/analisis/admin → Pantau/kontrol → pendukung lengkap → demo serta pembagian rincian FRD/SRS disetujui sebagai dasar draf; bukan final approval PRD. | [PRD-Q043](#prd-q043) | CONFIRMED_FOR_DRAFT; PRD-DEC-043 | PRD-NF-008, PRD-NF-009, PRD-NF-010 |

## 13. Requirement Traceability Matrix PRD

Matriks berikut memberikan arah requirement → sumber/keputusan, melengkapi arah sebaliknya pada §12. Tidak ada requirement baru yang ditambahkan hanya untuk memenuhi tabel. `PRD-F-xxx` dan `PRD-NF-xxx` mengikuti katalog [PRD.md](PRD.md); `PRD-AC-F-xxx`/`PRD-AC-NF-xxx` memakai nomor yang sama. Jika suatu requirement meneruskan BR tanpa pertanyaan PRD baru, keputusan tahap 1 dan BRD-APPROVAL-01 tetap menjadi sumber sah; pertanyaan baru tidak direkayasa.

**Status terkini semua baris:** rumusan PRD 0.1.0 **APPROVED — PRD-APPROVAL-01**; detail FRD/SRS tetap terbuka. Prioritas/urutan mengikuti konsolidasi PRD-Q043; tidak ada skor atau skema MoSCoW baru yang ditetapkan diam-diam. AC berstatus **NOT_RUN** untuk aplikasi. Bukti kelayakan historis OBS-01 tidak meluluskan AC produk.

| Requirement / tujuan produk | BR dan source claim | Pertanyaan dan keputusan | Acceptance criterion |
|---|---|---|---|
| PRD-F-001 — Akses baca tamu | BR-016, BR-023, BR-024; PRD-CL016, PRD-CL023, PRD-CL024, PRD-CL043 | PRD-Q001 / PRD-DEC-001 | PRD-AC-F-001 |
| PRD-F-002 — Registrasi email/sandi lokal | BR-027; PRD-CL027, PRD-CL044, PRD-CL076 | PRD-Q002 / PRD-DEC-002; PRD-Q034 / PRD-DEC-034 | PRD-AC-F-002 |
| PRD-F-003 — Login untuk fitur pribadi | BR-027; PRD-CL027, PRD-CL043, PRD-CL044, PRD-CL076 | PRD-Q001 / PRD-DEC-001; PRD-Q002 / PRD-DEC-002; PRD-Q034 / PRD-DEC-034 | PRD-AC-F-003 |
| PRD-F-004 — Profil akun milik sendiri | BR-027; PRD-CL027 | DEC-027; BRD-APPROVAL-01 | PRD-AC-F-004 |
| PRD-F-005 — Kode pemulihan pribadi | BR-027; PRD-CL027, PRD-CL077 | PRD-Q035 / PRD-DEC-035 | PRD-AC-F-005 |
| PRD-F-006 — Dua admin setara, provisioning tim | BR-003, BR-027; PRD-CL003, PRD-CL027, PRD-CL078 | PRD-Q036 / PRD-DEC-036 | PRD-AC-F-006 |
| PRD-F-007 — Batas media 2 foto ATAU 1 video 5 detik | BR-005; PRD-CL005 | DEC-005; BRD-APPROVAL-01 | PRD-AC-F-007 |
| PRD-F-008 — Media/deskripsi/titik dan waktu laporan | BR-004; PRD-CL004, PRD-CL060 | PRD-Q018 / PRD-DEC-018 | PRD-AC-F-008 |
| PRD-F-009 — GPS/manual termasuk remote, sumber lokasi | BR-004, BR-007; PRD-CL004, PRD-CL007, PRD-CL045, PRD-CL048, PRD-CL060 | PRD-Q003 / PRD-DEC-003; PRD-Q006 / PRD-DEC-006; PRD-Q018 / PRD-DEC-018 | PRD-AC-F-009 |
| PRD-F-010 — Pemeriksaan perangkat, blok kirim, unknown, build internal | BR-004, BR-039; PRD-CL004, PRD-CL039, PRD-CL045, PRD-CL046, PRD-CL047, PRD-CL049, PRD-CL050 | PRD-Q003 / PRD-DEC-003; PRD-Q004 / PRD-DEC-004; PRD-Q005 / PRD-DEC-005; PRD-Q007 / PRD-DEC-007; PRD-Q008 / PRD-DEC-008 | PRD-AC-F-010 |
| PRD-F-011 — KTP satu per akun menjadi gerbang kirim | BR-004, BR-025, BR-027; PRD-CL004, PRD-CL025, PRD-CL027, PRD-CL076, PRD-CL079 | PRD-Q034 / PRD-DEC-034; PRD-Q037 / PRD-DEC-037 | PRD-AC-F-011 |
| PRD-F-012 — Pemeriksaan KTP dan konfirmasi pemilik | BR-025; PRD-CL025, PRD-CL080 | PRD-Q038 / PRD-DEC-038 | PRD-AC-F-012 |
| PRD-F-013 — Penghapusan KTP menahan kirim baru | BR-025; PRD-CL025, PRD-CL081 | PRD-Q039 / PRD-DEC-039 | PRD-AC-F-013 |
| PRD-F-014 — Draf lokal beserta media | BR-042; PRD-CL042, PRD-CL047, PRD-CL054 | PRD-Q005 / PRD-DEC-005; PRD-Q012 / PRD-DEC-012 | PRD-AC-F-014 |
| PRD-F-015 — Lanjut kirim saat aktif/online tanpa duplikasi | BR-042; PRD-CL042, PRD-CL054 | PRD-Q012 / PRD-DEC-012 | PRD-AC-F-015 |
| PRD-F-016 — Riwayat sendiri; laporan diterima read-only warga | BR-027; PRD-CL027, PRD-CL052, PRD-CL053 | PRD-Q010 / PRD-DEC-010; PRD-Q011 / PRD-DEC-011 | PRD-AC-F-016 |
| PRD-F-017 — Ringkasan AI dan hasil admin untuk pelapor | BR-006, BR-027; PRD-CL006, PRD-CL027, PRD-CL052 | PRD-Q010 / PRD-DEC-010 | PRD-AC-F-017 |
| PRD-F-018 — Analisis kecocokan bukti dan keterangan | BR-006; PRD-CL006 | DEC-006; BRD-APPROVAL-01 | PRD-AC-F-018 |
| PRD-F-019 — Bukti tak cocok diterima, belum dipakai bahaya | BR-006, BR-018; PRD-CL006, PRD-CL018, PRD-CL051 | PRD-Q009 / PRD-DEC-009 | PRD-AC-F-019 |
| PRD-F-020 — Analisis belum tersedia tidak dianggap rendah | BR-018; PRD-CL018, PRD-CL051 | PRD-Q009 / PRD-DEC-009 | PRD-AC-F-020 |
| PRD-F-021 — Kelompok terkait dengan bukti individual | BR-007; PRD-CL007 | DEC-007; BRD-APPROVAL-01 | PRD-AC-F-021 |
| PRD-F-022 — Prioritas tinjauan berbeda dari indikasi bahaya | BR-008; PRD-CL008 | DEC-008; BRD-APPROVAL-01 | PRD-AC-F-022 |
| PRD-F-023 — Admin meninjau/mengoreksi AI dengan jejak | BR-009; PRD-CL009 | DEC-009; BRD-APPROVAL-01 | PRD-AC-F-023 |
| PRD-F-024 — Pindah laporan atau buat kelompok | BR-009; PRD-CL009, PRD-CL055 | PRD-Q013 / PRD-DEC-013 | PRD-AC-F-024 |
| PRD-F-025 — Tindak lanjut admin terbaca pelapor | BR-010; PRD-CL010, PRD-CL056 | PRD-Q014 / PRD-DEC-014 | PRD-AC-F-025 |
| PRD-F-026 — Bukti baru memerlukan tinjauan ulang | BR-019; PRD-CL019, PRD-CL058 | PRD-Q016 / PRD-DEC-016 | PRD-AC-F-026 |
| PRD-F-027 — Selesaikan kejadian, simpan riwayat | BR-020; PRD-CL020 | DEC-020; BRD-APPROVAL-01 | PRD-AC-F-027 |
| PRD-F-028 — Kejadian baru setelah selesai | BR-020; PRD-CL020, PRD-CL057 | PRD-Q015 / PRD-DEC-015 | PRD-AC-F-028 |
| PRD-F-029 — Toggle galeri global | BR-011; PRD-CL011 | DEC-011; BRD-APPROVAL-01 | PRD-AC-F-029 |
| PRD-F-030 — Kuota N per H jam per akun | BR-012; PRD-CL012 | DEC-012; BRD-APPROVAL-01 | PRD-AC-F-030 |
| PRD-F-031 — Reset kuota satu/semua akun | BR-013; PRD-CL013 | DEC-013; BRD-APPROVAL-01 | PRD-AC-F-031 |
| PRD-F-032 — Hapus permanen aktif beserta media, audit minimal | BR-014; PRD-CL014 | DEC-014; BRD-APPROVAL-01 | PRD-AC-F-032 |
| PRD-F-033 — Rekonsiliasi riwayat/kelompok/Pantau sesudah hapus | BR-015; PRD-CL015 | DEC-015; BRD-APPROVAL-01 | PRD-AC-F-033 |
| PRD-F-034 — Ringkasan Pantau tanpa identitas/media orang lain | BR-016, BR-019; PRD-CL016, PRD-CL019 | DEC-016, DEC-019; BRD-APPROVAL-01 | PRD-AC-F-034 |
| PRD-F-035 — Pantau otomatis hanya lokasi berlaporan | BR-016, BR-017; PRD-CL016, PRD-CL017 | DEC-016, DEC-017; BRD-APPROVAL-01 | PRD-AC-F-035 |
| PRD-F-036 — Rendah/sedang/tinggi dan belum dinilai terpisah | BR-008, BR-018; PRD-CL008, PRD-CL018, PRD-CL059 | PRD-Q017 / PRD-DEC-017 | PRD-AC-F-036 |
| PRD-F-037 — Kelola backup dokumen privat | BR-025; PRD-CL025, PRD-CL069, PRD-CL072, PRD-CL081 | PRD-Q027 / PRD-DEC-027; PRD-Q030 / PRD-DEC-030; PRD-Q039 / PRD-DEC-039 | PRD-AC-F-037 |
| PRD-F-038 — Ambil dokumen lintas perangkat setelah login | BR-025; PRD-CL025 | DEC-025; BRD-APPROVAL-01 | PRD-AC-F-038 |
| PRD-F-039 — Persetujuan isi otomatis dan bahasa UI | BR-025; PRD-CL025, PRD-CL064, PRD-CL067 | PRD-Q022 / PRD-DEC-022; PRD-Q025 / PRD-DEC-025 | PRD-AC-F-039 |
| PRD-F-040 — Pengisian otomatis diproses bertahap | BR-025; PRD-CL025, PRD-CL064, PRD-CL067 | PRD-Q022 / PRD-DEC-022; PRD-Q025 / PRD-DEC-025 | PRD-AC-F-040 |
| PRD-F-041 — Tinjau/koreksi hasil sebelum terapkan | BR-025; PRD-CL025, PRD-CL065, PRD-CL068 | PRD-Q023 / PRD-DEC-023; PRD-Q026 / PRD-DEC-026 | PRD-AC-F-041 |
| PRD-F-042 — Ekstraksi gagal: ulang/manual, backup independen | BR-025; PRD-CL025, PRD-CL069 | PRD-Q027 / PRD-DEC-027 | PRD-AC-F-042 |
| PRD-F-043 — Profil keluarga minimum privat backend | BR-022, BR-025; PRD-CL022, PRD-CL025, PRD-CL061, PRD-CL064, PRD-CL065, PRD-CL066 | PRD-Q019 / PRD-DEC-019; PRD-Q022 / PRD-DEC-022; PRD-Q023 / PRD-DEC-023; PRD-Q024 / PRD-DEC-024 | PRD-AC-F-043 |
| PRD-F-044 — Gabung hasil dengan pilihan pengguna | BR-025; PRD-CL025, PRD-CL071 | PRD-Q029 / PRD-DEC-029 | PRD-AC-F-044 |
| PRD-F-045 — Hapus sumber tidak hapus profil | BR-025; PRD-CL025, PRD-CL072 | PRD-Q030 / PRD-DEC-030 | PRD-AC-F-045 |
| PRD-F-046 — Tas personal dari katalog kategori keluarga | BR-022; PRD-CL022, PRD-CL061, PRD-CL075 | PRD-Q019 / PRD-DEC-019; PRD-Q033 / PRD-DEC-033 | PRD-AC-F-046 |
| PRD-F-047 — Checklist/item/progres lokal | BR-022; PRD-CL022, PRD-CL061, PRD-CL062 | PRD-Q019 / PRD-DEC-019; PRD-Q020 / PRD-DEC-020 | PRD-AC-F-047 |
| PRD-F-048 — Direktori kontak umum | BR-023; PRD-CL023, PRD-CL063 | PRD-Q021 / PRD-DEC-021 | PRD-AC-F-048 |
| PRD-F-049 — Kontak pribadi lokal, tidak diunggah | BR-023; PRD-CL023, PRD-CL063 | PRD-Q021 / PRD-DEC-021 | PRD-AC-F-049 |
| PRD-F-050 — Isolasi data lokal per akun | BR-022, BR-023, BR-027; PRD-CL022, PRD-CL023, PRD-CL027, PRD-CL062, PRD-CL070 | PRD-Q020 / PRD-DEC-020; PRD-Q028 / PRD-DEC-028 | PRD-AC-F-050 |
| PRD-F-051 — Panduan dan suara sesuai kemampuan perangkat | BR-024; PRD-CL024, PRD-CL074 | PRD-Q032 / PRD-DEC-032 | PRD-AC-F-051 |
| PRD-F-052 — Kontak/teks panduan dibundel dan diperbarui online | BR-023, BR-024, BR-042; PRD-CL023, PRD-CL024, PRD-CL042, PRD-CL073 | PRD-Q031 / PRD-DEC-031 | PRD-AC-F-052 |
| PRD-F-053 — Admin kelola kontak/panduan/katalog tas | BR-022, BR-023, BR-024; PRD-CL022, PRD-CL023, PRD-CL024, PRD-CL063 | PRD-Q021 / PRD-DEC-021 | PRD-AC-F-053 |
| PRD-F-054 — Admin terbitkan pesan ke seluruh warga | BR-026; PRD-CL026, PRD-CL082 | PRD-Q040 / PRD-DEC-040 | PRD-AC-F-054 |
| PRD-F-055 — Perbaiki/cabut pesan dengan status terlihat | BR-026; PRD-CL026, PRD-CL082 | PRD-Q040 / PRD-DEC-040 | PRD-AC-F-055 |
| PRD-F-056 — Inbox dan penanda dibaca | BR-026; PRD-CL026, PRD-CL082 | PRD-Q040 / PRD-DEC-040 | PRD-AC-F-056 |
| PRD-F-057 — Logout melindungi akses akun/data privat | BR-027; PRD-CL027, PRD-CL070 | PRD-Q028 / PRD-DEC-028 | PRD-AC-F-057 |
| PRD-NF-001 — Flutter Android warga dan Flutter Web admin | BR-002; PRD-CL002 | DEC-002; BRD-APPROVAL-01 | PRD-AC-NF-001 |
| PRD-NF-002 — Laragon6/MySQL dan TS API+worker terpisah | BR-030, BR-031; PRD-CL030, PRD-CL031 | DEC-030, DEC-031; BRD-APPROVAL-01 | PRD-AC-NF-002 |
| PRD-NF-003 — DeepSeek/efisiensi media terukur | BR-032, BR-033; PRD-CL032, PRD-CL033, PRD-CL064, PRD-CL067 | PRD-Q022 / PRD-DEC-022; PRD-Q025 / PRD-DEC-025 | PRD-AC-NF-003 |
| PRD-NF-004 — Hindari langganan berbayar wajib baru | BR-035; PRD-CL035, PRD-CL076, PRD-CL077 | PRD-Q034 / PRD-DEC-034; PRD-Q035 / PRD-DEC-035 | PRD-AC-NF-004 |
| PRD-NF-005 — Privasi dan batas akses per pemilik | BR-025, BR-027; PRD-CL025, PRD-CL027, PRD-CL063, PRD-CL066, PRD-CL067, PRD-CL070 | PRD-Q021 / PRD-DEC-021; PRD-Q024 / PRD-DEC-024; PRD-Q025 / PRD-DEC-025; PRD-Q028 / PRD-DEC-028 | PRD-AC-NF-005 |
| PRD-NF-006 — Kejelasan status, konsistensi dan kegagalan | BR-004, BR-015, BR-018, BR-039, BR-042; PRD-CL004, PRD-CL015, PRD-CL018, PRD-CL039, PRD-CL042, PRD-CL051, PRD-CL054, PRD-CL069 | PRD-Q009 / PRD-DEC-009; PRD-Q012 / PRD-DEC-012; PRD-Q027 / PRD-DEC-027 | PRD-AC-NF-006 |
| PRD-NF-007 — Tema SVG, konten bersumber dan keterbacaan | BR-023, BR-024, BR-037; PRD-CL023, PRD-CL024, PRD-CL037 | DEC-023, DEC-024, DEC-037; BRD-APPROVAL-01 | PRD-AC-NF-007 |
| PRD-NF-008 — Milestone tanpa deadline, tim/Git, demo lokal/portabilitas | BR-003, BR-021, BR-034, BR-036, BR-041; PRD-CL003, PRD-CL021, PRD-CL034, PRD-CL036, PRD-CL041, PRD-CL085 | PRD-Q043 / PRD-DEC-043 | PRD-AC-NF-008 |
| PRD-NF-009 — UAT nyata dan paket 2admin/6warga/12laporan/8dokumen | BR-001, BR-038, BR-039; PRD-CL001, PRD-CL038, PRD-CL039, PRD-CL084, PRD-CL085 | PRD-Q042 / PRD-DEC-042; PRD-Q043 / PRD-DEC-043 | PRD-AC-NF-009 |
| PRD-NF-010 — Cakupan/gate bertahap, exclusions dan penundaan | BR-021, BR-028, BR-029, BR-040; PRD-CL021, PRD-CL028, PRD-CL029, PRD-CL040, PRD-CL055, PRD-CL083, PRD-CL085 | PRD-Q013 / PRD-DEC-013; PRD-Q041 / PRD-DEC-041; PRD-Q043 / PRD-DEC-043 | PRD-AC-NF-010 |

### 13.1 Keputusan yang menentukan scope atau proses

PRD-Q041 → PRD-DEC-041 → PRD-NF-010 mencatat penundaan hapus akun. PRD-Q042 → PRD-DEC-042 → PRD-NF-009 mencatat paket delapan spesimen. PRD-Q043 → PRD-DEC-043 → PRD-NF-008/009/010 mencatat urutan hasil dan dasar penulisan draft. Ketiganya tetap memiliki tujuan RTM walaupun bukan fitur layar baru.

### 13.2 Delta terhadap baseline BRD

| Delta | Dasar | Perlakuan ketertelusuran |
|---|---|---|
| Syarat KTP sebelum mengirim laporan, pemeriksaan terbatas, dan dampak penghapusannya | PRD-Q034/Q037–Q039 | Penambahan scope eksplisit; PRD-F-011–013. Tidak diklaim sebagai verifikasi identitas resmi atau izin admin membaca KTP. |
| Pengisian profil keluarga dari dokumen dengan persetujuan, review, dan fallback | PRD-Q022–Q027/Q029–Q030 | Perincian/penambahan eksplisit pada area dokumen; PRD-F-039–045. Tidak menjadi pemrosesan otomatis semua dokumen tanpa pilihan pemilik. |
| Profil keluarga privat backend; checklist/progres/kontak pribadi lokal per akun | PRD-Q019–Q024/Q028/Q033 | Lokasi data dibedakan; PRD-F-043/046/047/049/050. Data lokal tidak dijanjikan ikut pindah perangkat. |
| CMS kontak/panduan/katalog tas serta konten awal offline | PRD-Q021/Q031/Q032 | Hak admin dan kemampuan offline diperinci; PRD-F-051–053. Tidak menjanjikan semua suara tersedia offline. |
| Anti-fraud menurut dukungan perangkat, akses tamu, retry foreground, koreksi kelompok, dan siklus pesan | PRD-Q001/Q003–Q008/Q012–Q017/Q040 | Perilaku produk baru dirinci pada PRD terkait; kelayakan deteksi dan detail pelaksanaan belum dianggap terbukti. |
| Paket dokumen 6 menjadi 8 spesimen: 6 KTP + 2 KK | PRD-Q042 | BR-038 tetap menjadi rekam baseline; kebutuhan demo terkini mengikuti PRD-NF-009. Dua admin, enam warga, dan dua belas laporan tetap. |
| Hapus akun mandiri ditunda | PRD-Q041 | Exclusion/deferred yang dipilih secara sadar pada PRD-NF-010; bukan hilangnya kebutuhan tanpa keputusan. |

## 14. Konfirmasi dan kesiapan tahap 2

| Gate PRD | Bukti yang tersedia | Status / batas |
|---|---|---|
| Gate 0 — intake/otoritas | BRD-APPROVAL-01, baseline BRD, pengguna sebagai pemilik keputusan | Dasar tahap 2 tersedia. Tidak mengklaim approval stakeholder lain. |
| Gate 1 — audit/dekomposisi | Inventaris historis, 85 source claim, hubungan ke 42 BR | Ledger draft tersedia; kelengkapan struktural diperiksa terpisah dari kebenaran aplikasi. |
| Gate 2 — discovery | PRD-Q001–PRD-Q043 dengan jejak keputusan | 43 jawaban/keputusan tercatat. Delegasi, perincian, dan jawaban langsung dibedakan. |
| Gate 3 — konsolidasi kebutuhan | 57 F + 10 NF dan AC berpasangan | Rumusan/AC kini termasuk baseline melalui PRD-APPROVAL-01; hasil uji tetap NOT_RUN. |
| Gate 4 — scope/urutan | PRD-Q043 menerima konsolidasi dan urutan | Dasar draft diterima; tidak mengarang skor prioritas, deadline, atau angka kualitas. |
| Gate 5 — draft | PRD-USER-IMPLEMENT dan PRD 0.1.0 | Draf tersedia; penutupan editorial/audit dicatat pada §17. |
| Gate 6 — final PRD | PRD-APPROVAL-01: persetujuan rencana penutupan PRD 0.1.0 | **APPROVED**; tahap 3 FRD dimulai sebagai DRAFT. |

Konfirmasi makna, tujuan, batas, operasi, kegagalan, dan konsekuensi dicatat sejauh benar-benar dibahas. Contohnya, Q005 memperjelas batas blokir, Q012 membedakan draf dari niat mengirim, Q027 memberi jalur gagal ekstraksi, Q029–Q030 menguji dampak impor/hapus sumber, dan Q039 menguji akibat penghapusan KTP. Tidak ada klaim setiap pertanyaan melewati enam sesi konfirmasi terpisah. Q043 merupakan penerimaan konsolidasi **untuk draft**, bukan pengganti review versi PRD dan AC final.

### 14.1 Batas keputusan dan bukti yang masih terbuka

- **FRD:** field dan status rinci, aturan kuota N/H, perubahan kebijakan galeri terhadap kiriman tertunda, label/fallback analisis, masa berlaku pesan, aturan perubahan profil/dokumen, dan detail alur pemulihan.
- **SRS:** cara deteksi mock GPS/mode developer menurut perangkat, model/payload DeepSeek, algoritma/ambang kelompok dan prioritas, keamanan data/kunci, protokol retry/idempotensi, skema/API, serta batas resource. Keputusan memblokir bila terdeteksi bukan bukti teknik deteksinya bekerja pada semua perangkat.
- **Validasi/implementasi:** perangkat nyata, dukungan TTS, media/dokumen spesimen, mutu ekstraksi, rate limit/biaya, uji lintas akun/perangkat, dan UAT. Tidak ada metrik kualitas atau penghematan yang diklaim tercapai.
- **Transparansi:** manfaat isi otomatis memakai bahasa biasa; informasi tentang pemrosesan layanan eksternal tetap perlu diterangkan. Persetujuan atas manfaat bukan persetujuan atas teks privasi yang belum ditinjau.
- **Sumber asli:** bahan yang tidak tersedia pada §2.4 tetap tidak diklaim dibaca. Tidak ada verifikasi ulang seluruh referensi web dalam penyusunan draft ini.

Rincian di atas tidak boleh diisi sebagai default tersembunyi. Penundaan detail ke FRD/SRS tidak memulai kedua tahap tersebut, tidak menggugurkan scope produk yang disepakati, dan tidak berarti pertanyaan teknisnya sudah dijawab.

## 15. Audit dokumen tahap 2 dan perubahan register

Pemeriksaan struktur tahap 2 dicatat setelah dijalankan terhadap hasil penulisan. Audit hanya dapat menyatakan keberadaan/keunikan ID, kecocokan hubungan, dan tautan dokumen yang diperiksa. Audit dokumen tidak membuktikan aplikasi, provider, keamanan, deteksi perangkat, atau UAT telah berjalan.

**Audit internal setelah penulisan tahap 2:** pemeriksaan aktual menemukan 43 heading PRD-Q yang unik/lengkap, 85 baris source claim yang unik/lengkap, serta 57 baris F dan 10 baris NF pada RTM. Sebanyak 186 hubungan sumber–requirement dicocokkan dengan katalog yang disepakati: arah requirement → claim dan claim → requirement tidak memiliki hubungan yang hilang. Sebanyak 42 baris ST tahap 1 dan 41 baris inventaris sumber fisik tetap ada. Pemeriksaan ini tidak menghasilkan temuan struktur pada cakupan tersebut.

**Snapshot historis pemeriksaan lintas dokumen:** belum dinyatakan lulus saat PRD.md masih disusun. Snapshot ini dipertahankan sebagai riwayat; hasil pemeriksaan penutupan terbaru dicatat pada [audit penutupan](#closure-audit).

| Perubahan register | Bukti | Batas |
|---|---|---|
| Status BRD diterima dan tahap 2 diizinkan | BRD-APPROVAL-01 | Q-029–Q-031 ditutup kolektif; tidak ditulis ulang sebagai jawaban individual. |
| Penambahan ledger discovery PRD, source claim, dan RTM | PRD-Q001–Q043; PRD-CL001–CL085; katalog PRD-F/NF | Register tahap 1 tetap historis; tidak mengubah sumber mentah. |
| Pembaruan paket spesimen dan scope tambahan | Keputusan PRD yang ditunjukkan pada §13.2 | Tambahan berasal dari percakapan, bukan diasumsikan sudah ada dalam BRD awal. |
| Penyusunan draft PRD dan register | PRD-USER-IMPLEMENT | Tidak menciptakan codebase, akun, dataset nyata, repository, atau konfigurasi deployment. |

**Status snapshot awal tahap 2:** dahulu siap diaudit sebagai draft dan menunggu persetujuan. **Status terkini:** PRD disetujui melalui PRD-APPROVAL-01 dan FRD dimulai. Tidak ada hasil uji aplikasi baru yang dicatat.

<a id="frd-traceability"></a>

## 16. Keterlacakan tahap 3 — FRD v0.1.2 DRAFT

**Status:** sumber PRD v0.1.0 APPROVED melalui PRD-APPROVAL-01; seluruh FRD masih DRAFT. 67 klaim sumber (57 F + 10 NF) diteruskan ke 68 FR serta 10 batasan NF. AC/TC bukan hasil pengujian. 68 FR mempunyai 136 pasangan AC/TC; tambahan 10 TC-NF dan 10 TC-X menghasilkan 156 skenario rencana NOT_RUN.

Rujukan sumber pada baris berikut mengarah ke requirement PRD yang mempunyai BR/Q serta RTM tahap 2. Keputusan dasar adalah PRD-APPROVAL-01 ditambah PRD-DEC yang sesuai Q asal, bukan keputusan R1/R2 baru. Pemberian ID/struktur FRD mengikuti FRD-DEC-001; elaborasi/pertanyaan terbuka mengikuti FRD-DEC-002. Seluruh tanggal pencatatan tahap ini 18 Oktober 2026.

### 16.1 Register klaim sumber dan arah maju

**Status pengetahuan tiap baris:** INPUT_CLAIM dari baseline PRD yang sudah APPROVED. **Konfirmasi:** bukti Q/DEC historis + approval baseline, tanpa mengarang R2 baru. **Owner keputusan:** pemilik proyek. **Risiko/pertanyaan:** lihat Q pada FR turunan dan FRD §27; NF ke Q yang tercantum pada FRD §23. Judul klaim di sini adalah indeks; pernyataan lengkap tetap pada PRD sumber.

| Claim ID | Klaim / sumber PRD | Asal BR/Q | Turunan FRD / pengujian |
|---|---|---|---|
| FRD-CL-F-001 | [PRD-F-001](PRD.md#prd-f-001) — Akses baca tamu | BR-016, BR-023, BR-024; [PRD-Q001](TRACEABILITY.md#prd-q001) | [FR-AUTH-001](FRD.md#fr-auth-001) |
| FRD-CL-F-002 | [PRD-F-002](PRD.md#prd-f-002) — Registrasi email/sandi lokal | BR-027; [PRD-Q002](TRACEABILITY.md#prd-q002), [PRD-Q034](TRACEABILITY.md#prd-q034) | [FR-AUTH-002](FRD.md#fr-auth-002) |
| FRD-CL-F-003 | [PRD-F-003](PRD.md#prd-f-003) — Login untuk fitur pribadi | BR-027; [PRD-Q001](TRACEABILITY.md#prd-q001), [PRD-Q002](TRACEABILITY.md#prd-q002), [PRD-Q034](TRACEABILITY.md#prd-q034) | [FR-AUTH-003](FRD.md#fr-auth-003) |
| FRD-CL-F-004 | [PRD-F-004](PRD.md#prd-f-004) — Profil akun milik sendiri | BR-027 | [FR-AUTH-004](FRD.md#fr-auth-004) |
| FRD-CL-F-005 | [PRD-F-005](PRD.md#prd-f-005) — Kode pemulihan pribadi | BR-027; [PRD-Q035](TRACEABILITY.md#prd-q035) | [FR-AUTH-005](FRD.md#fr-auth-005), [FR-AUTH-006](FRD.md#fr-auth-006) |
| FRD-CL-F-006 | [PRD-F-006](PRD.md#prd-f-006) — Dua admin setara, provisioning tim | BR-003, BR-027; [PRD-Q036](TRACEABILITY.md#prd-q036) | [FR-AUTH-007](FRD.md#fr-auth-007) |
| FRD-CL-F-007 | [PRD-F-007](PRD.md#prd-f-007) — Batas media 2 foto ATAU 1 video 5 detik | BR-005 | [FR-REPORT-001](FRD.md#fr-report-001) |
| FRD-CL-F-008 | [PRD-F-008](PRD.md#prd-f-008) — Media/deskripsi/titik dan waktu laporan | BR-004; [PRD-Q018](TRACEABILITY.md#prd-q018) | [FR-REPORT-002](FRD.md#fr-report-002) |
| FRD-CL-F-009 | [PRD-F-009](PRD.md#prd-f-009) — GPS/manual termasuk remote, sumber lokasi | BR-004, BR-007; [PRD-Q003](TRACEABILITY.md#prd-q003), [PRD-Q006](TRACEABILITY.md#prd-q006), [PRD-Q018](TRACEABILITY.md#prd-q018) | [FR-REPORT-003](FRD.md#fr-report-003) |
| FRD-CL-F-010 | [PRD-F-010](PRD.md#prd-f-010) — Pemeriksaan perangkat, blok kirim, unknown, build internal | BR-004, BR-039; [PRD-Q003](TRACEABILITY.md#prd-q003), [PRD-Q004](TRACEABILITY.md#prd-q004), [PRD-Q005](TRACEABILITY.md#prd-q005), [PRD-Q007](TRACEABILITY.md#prd-q007), [PRD-Q008](TRACEABILITY.md#prd-q008) | [FR-REPORT-004](FRD.md#fr-report-004), [FR-REPORT-005](FRD.md#fr-report-005), [FR-REPORT-006](FRD.md#fr-report-006) |
| FRD-CL-F-011 | [PRD-F-011](PRD.md#prd-f-011) — KTP satu per akun menjadi gerbang kirim | BR-004, BR-025, BR-027; [PRD-Q034](TRACEABILITY.md#prd-q034), [PRD-Q037](TRACEABILITY.md#prd-q037) | [FR-KTP-001](FRD.md#fr-ktp-001) |
| FRD-CL-F-012 | [PRD-F-012](PRD.md#prd-f-012) — Pemeriksaan KTP dan konfirmasi pemilik | BR-025; [PRD-Q038](TRACEABILITY.md#prd-q038) | [FR-KTP-002](FRD.md#fr-ktp-002), [FR-KTP-003](FRD.md#fr-ktp-003) |
| FRD-CL-F-013 | [PRD-F-013](PRD.md#prd-f-013) — Penghapusan KTP menahan kirim baru | BR-025; [PRD-Q039](TRACEABILITY.md#prd-q039) | [FR-KTP-004](FRD.md#fr-ktp-004) |
| FRD-CL-F-014 | [PRD-F-014](PRD.md#prd-f-014) — Draf lokal beserta media | BR-042; [PRD-Q005](TRACEABILITY.md#prd-q005), [PRD-Q012](TRACEABILITY.md#prd-q012) | [FR-REPORT-007](FRD.md#fr-report-007) |
| FRD-CL-F-015 | [PRD-F-015](PRD.md#prd-f-015) — Lanjut kirim saat aktif/online tanpa duplikasi | BR-042; [PRD-Q012](TRACEABILITY.md#prd-q012) | [FR-REPORT-008](FRD.md#fr-report-008), [FR-REPORT-009](FRD.md#fr-report-009), [FR-REPORT-010](FRD.md#fr-report-010) |
| FRD-CL-F-016 | [PRD-F-016](PRD.md#prd-f-016) — Riwayat sendiri; laporan diterima read-only warga | BR-027; [PRD-Q010](TRACEABILITY.md#prd-q010), [PRD-Q011](TRACEABILITY.md#prd-q011) | [FR-REPORT-011](FRD.md#fr-report-011) |
| FRD-CL-F-017 | [PRD-F-017](PRD.md#prd-f-017) — Ringkasan AI dan hasil admin untuk pelapor | BR-006, BR-027; [PRD-Q010](TRACEABILITY.md#prd-q010) | [FR-REPORT-012](FRD.md#fr-report-012) |
| FRD-CL-F-018 | [PRD-F-018](PRD.md#prd-f-018) — Analisis kecocokan bukti dan keterangan | BR-006 | [FR-AI-001](FRD.md#fr-ai-001) |
| FRD-CL-F-019 | [PRD-F-019](PRD.md#prd-f-019) — Bukti tak cocok diterima, belum dipakai bahaya | BR-006, BR-018; [PRD-Q009](TRACEABILITY.md#prd-q009) | [FR-AI-002](FRD.md#fr-ai-002) |
| FRD-CL-F-020 | [PRD-F-020](PRD.md#prd-f-020) — Analisis belum tersedia tidak dianggap rendah | BR-018; [PRD-Q009](TRACEABILITY.md#prd-q009) | [FR-AI-003](FRD.md#fr-ai-003) |
| FRD-CL-F-021 | [PRD-F-021](PRD.md#prd-f-021) — Kelompok terkait dengan bukti individual | BR-007 | [FR-REVIEW-001](FRD.md#fr-review-001) |
| FRD-CL-F-022 | [PRD-F-022](PRD.md#prd-f-022) — Prioritas tinjauan berbeda dari indikasi bahaya | BR-008 | [FR-REVIEW-002](FRD.md#fr-review-002) |
| FRD-CL-F-023 | [PRD-F-023](PRD.md#prd-f-023) — Admin meninjau/mengoreksi AI dengan jejak | BR-009 | [FR-REVIEW-003](FRD.md#fr-review-003), [FR-REVIEW-009](FRD.md#fr-review-009) |
| FRD-CL-F-024 | [PRD-F-024](PRD.md#prd-f-024) — Pindah laporan atau buat kelompok | BR-009; [PRD-Q013](TRACEABILITY.md#prd-q013) | [FR-REVIEW-004](FRD.md#fr-review-004) |
| FRD-CL-F-025 | [PRD-F-025](PRD.md#prd-f-025) — Tindak lanjut admin terbaca pelapor | BR-010; [PRD-Q014](TRACEABILITY.md#prd-q014) | [FR-REVIEW-005](FRD.md#fr-review-005) |
| FRD-CL-F-026 | [PRD-F-026](PRD.md#prd-f-026) — Bukti baru memerlukan tinjauan ulang | BR-019; [PRD-Q016](TRACEABILITY.md#prd-q016) | [FR-REVIEW-006](FRD.md#fr-review-006) |
| FRD-CL-F-027 | [PRD-F-027](PRD.md#prd-f-027) — Selesaikan kejadian, simpan riwayat | BR-020 | [FR-REVIEW-007](FRD.md#fr-review-007) |
| FRD-CL-F-028 | [PRD-F-028](PRD.md#prd-f-028) — Kejadian baru setelah selesai | BR-020; [PRD-Q015](TRACEABILITY.md#prd-q015) | [FR-REVIEW-008](FRD.md#fr-review-008) |
| FRD-CL-F-029 | [PRD-F-029](PRD.md#prd-f-029) — Toggle galeri global | BR-011 | [FR-CONTROL-001](FRD.md#fr-control-001) |
| FRD-CL-F-030 | [PRD-F-030](PRD.md#prd-f-030) — Kuota N per H jam per akun | BR-012 | [FR-CONTROL-002](FRD.md#fr-control-002) |
| FRD-CL-F-031 | [PRD-F-031](PRD.md#prd-f-031) — Reset kuota satu/semua akun | BR-013 | [FR-CONTROL-003](FRD.md#fr-control-003) |
| FRD-CL-F-032 | [PRD-F-032](PRD.md#prd-f-032) — Hapus permanen aktif beserta media, audit minimal | BR-014 | [FR-CONTROL-004](FRD.md#fr-control-004) |
| FRD-CL-F-033 | [PRD-F-033](PRD.md#prd-f-033) — Rekonsiliasi riwayat/kelompok/Pantau sesudah hapus | BR-015 | [FR-CONTROL-005](FRD.md#fr-control-005) |
| FRD-CL-F-034 | [PRD-F-034](PRD.md#prd-f-034) — Ringkasan Pantau tanpa identitas/media orang lain | BR-016, BR-019 | [FR-MONITOR-001](FRD.md#fr-monitor-001) |
| FRD-CL-F-035 | [PRD-F-035](PRD.md#prd-f-035) — Pantau otomatis hanya lokasi berlaporan | BR-016, BR-017 | [FR-MONITOR-002](FRD.md#fr-monitor-002) |
| FRD-CL-F-036 | [PRD-F-036](PRD.md#prd-f-036) — Rendah/sedang/tinggi dan belum dinilai terpisah | BR-008, BR-018; [PRD-Q017](TRACEABILITY.md#prd-q017) | [FR-MONITOR-003](FRD.md#fr-monitor-003) |
| FRD-CL-F-037 | [PRD-F-037](PRD.md#prd-f-037) — Kelola backup dokumen privat | BR-025; [PRD-Q027](TRACEABILITY.md#prd-q027), [PRD-Q030](TRACEABILITY.md#prd-q030), [PRD-Q039](TRACEABILITY.md#prd-q039) | [FR-VAULT-001](FRD.md#fr-vault-001), [FR-VAULT-002](FRD.md#fr-vault-002), [FR-VAULT-003](FRD.md#fr-vault-003) |
| FRD-CL-F-038 | [PRD-F-038](PRD.md#prd-f-038) — Ambil dokumen lintas perangkat setelah login | BR-025 | [FR-VAULT-004](FRD.md#fr-vault-004) |
| FRD-CL-F-039 | [PRD-F-039](PRD.md#prd-f-039) — Persetujuan isi otomatis dan bahasa UI | BR-025; [PRD-Q022](TRACEABILITY.md#prd-q022), [PRD-Q025](TRACEABILITY.md#prd-q025) | [FR-FAMILY-001](FRD.md#fr-family-001) |
| FRD-CL-F-040 | [PRD-F-040](PRD.md#prd-f-040) — Pengisian otomatis diproses bertahap | BR-025; [PRD-Q022](TRACEABILITY.md#prd-q022), [PRD-Q025](TRACEABILITY.md#prd-q025) | [FR-FAMILY-002](FRD.md#fr-family-002) |
| FRD-CL-F-041 | [PRD-F-041](PRD.md#prd-f-041) — Tinjau/koreksi hasil sebelum terapkan | BR-025; [PRD-Q023](TRACEABILITY.md#prd-q023), [PRD-Q026](TRACEABILITY.md#prd-q026) | [FR-FAMILY-003](FRD.md#fr-family-003) |
| FRD-CL-F-042 | [PRD-F-042](PRD.md#prd-f-042) — Ekstraksi gagal: ulang/manual, backup independen | BR-025; [PRD-Q027](TRACEABILITY.md#prd-q027) | [FR-FAMILY-004](FRD.md#fr-family-004) |
| FRD-CL-F-043 | [PRD-F-043](PRD.md#prd-f-043) — Profil keluarga minimum privat backend | BR-022, BR-025; [PRD-Q019](TRACEABILITY.md#prd-q019), [PRD-Q022](TRACEABILITY.md#prd-q022), [PRD-Q023](TRACEABILITY.md#prd-q023), [PRD-Q024](TRACEABILITY.md#prd-q024) | [FR-FAMILY-005](FRD.md#fr-family-005) |
| FRD-CL-F-044 | [PRD-F-044](PRD.md#prd-f-044) — Gabung hasil dengan pilihan pengguna | BR-025; [PRD-Q029](TRACEABILITY.md#prd-q029) | [FR-FAMILY-006](FRD.md#fr-family-006) |
| FRD-CL-F-045 | [PRD-F-045](PRD.md#prd-f-045) — Hapus sumber tidak hapus profil | BR-025; [PRD-Q030](TRACEABILITY.md#prd-q030) | [FR-FAMILY-007](FRD.md#fr-family-007) |
| FRD-CL-F-046 | [PRD-F-046](PRD.md#prd-f-046) — Tas personal dari katalog kategori keluarga | BR-022; [PRD-Q019](TRACEABILITY.md#prd-q019), [PRD-Q033](TRACEABILITY.md#prd-q033) | [FR-READY-001](FRD.md#fr-ready-001) |
| FRD-CL-F-047 | [PRD-F-047](PRD.md#prd-f-047) — Checklist/item/progres lokal | BR-022; [PRD-Q019](TRACEABILITY.md#prd-q019), [PRD-Q020](TRACEABILITY.md#prd-q020) | [FR-READY-002](FRD.md#fr-ready-002) |
| FRD-CL-F-048 | [PRD-F-048](PRD.md#prd-f-048) — Direktori kontak umum | BR-023; [PRD-Q021](TRACEABILITY.md#prd-q021) | [FR-READY-003](FRD.md#fr-ready-003) |
| FRD-CL-F-049 | [PRD-F-049](PRD.md#prd-f-049) — Kontak pribadi lokal, tidak diunggah | BR-023; [PRD-Q021](TRACEABILITY.md#prd-q021) | [FR-READY-004](FRD.md#fr-ready-004) |
| FRD-CL-F-050 | [PRD-F-050](PRD.md#prd-f-050) — Isolasi data lokal per akun | BR-022, BR-023, BR-027; [PRD-Q020](TRACEABILITY.md#prd-q020), [PRD-Q028](TRACEABILITY.md#prd-q028) | [FR-READY-005](FRD.md#fr-ready-005) |
| FRD-CL-F-051 | [PRD-F-051](PRD.md#prd-f-051) — Panduan dan suara sesuai kemampuan perangkat | BR-024; [PRD-Q032](TRACEABILITY.md#prd-q032) | [FR-READY-006](FRD.md#fr-ready-006) |
| FRD-CL-F-052 | [PRD-F-052](PRD.md#prd-f-052) — Kontak/teks panduan dibundel dan diperbarui online | BR-023, BR-024, BR-042; [PRD-Q031](TRACEABILITY.md#prd-q031) | [FR-READY-007](FRD.md#fr-ready-007), [FR-READY-008](FRD.md#fr-ready-008) |
| FRD-CL-F-053 | [PRD-F-053](PRD.md#prd-f-053) — Admin kelola kontak/panduan/katalog tas | BR-022, BR-023, BR-024; [PRD-Q021](TRACEABILITY.md#prd-q021) | [FR-CONTENT-001](FRD.md#fr-content-001) |
| FRD-CL-F-054 | [PRD-F-054](PRD.md#prd-f-054) — Admin terbitkan pesan ke seluruh warga | BR-026; [PRD-Q040](TRACEABILITY.md#prd-q040) | [FR-INBOX-001](FRD.md#fr-inbox-001) |
| FRD-CL-F-055 | [PRD-F-055](PRD.md#prd-f-055) — Perbaiki/cabut pesan dengan status terlihat | BR-026; [PRD-Q040](TRACEABILITY.md#prd-q040) | [FR-INBOX-002](FRD.md#fr-inbox-002), [FR-INBOX-003](FRD.md#fr-inbox-003) |
| FRD-CL-F-056 | [PRD-F-056](PRD.md#prd-f-056) — Inbox dan penanda dibaca | BR-026; [PRD-Q040](TRACEABILITY.md#prd-q040) | [FR-INBOX-004](FRD.md#fr-inbox-004) |
| FRD-CL-F-057 | [PRD-F-057](PRD.md#prd-f-057) — Logout melindungi akses akun/data privat | BR-027; [PRD-Q028](TRACEABILITY.md#prd-q028) | [FR-AUTH-008](FRD.md#fr-auth-008) |
| FRD-CL-NF-001 | [PRD-NF-001](PRD.md#prd-nf-001) — Flutter Android warga dan Flutter Web admin | BR-002 | FRD §23; [TC-NF-001](FRD.md#tc-nf-001) |
| FRD-CL-NF-002 | [PRD-NF-002](PRD.md#prd-nf-002) — Laragon6/MySQL dan TS API+worker terpisah | BR-030, BR-031 | FRD §23; [TC-NF-002](FRD.md#tc-nf-002) |
| FRD-CL-NF-003 | [PRD-NF-003](PRD.md#prd-nf-003) — DeepSeek/efisiensi media terukur | BR-032, BR-033; [PRD-Q022](TRACEABILITY.md#prd-q022), [PRD-Q025](TRACEABILITY.md#prd-q025) | FRD §23; [TC-NF-003](FRD.md#tc-nf-003) |
| FRD-CL-NF-004 | [PRD-NF-004](PRD.md#prd-nf-004) — Hindari langganan berbayar wajib baru | BR-035; [PRD-Q034](TRACEABILITY.md#prd-q034), [PRD-Q035](TRACEABILITY.md#prd-q035) | FRD §23; [TC-NF-004](FRD.md#tc-nf-004) |
| FRD-CL-NF-005 | [PRD-NF-005](PRD.md#prd-nf-005) — Privasi dan batas akses per pemilik | BR-025, BR-027; [PRD-Q021](TRACEABILITY.md#prd-q021), [PRD-Q024](TRACEABILITY.md#prd-q024), [PRD-Q025](TRACEABILITY.md#prd-q025), [PRD-Q028](TRACEABILITY.md#prd-q028) | FRD §23; [TC-NF-005](FRD.md#tc-nf-005) |
| FRD-CL-NF-006 | [PRD-NF-006](PRD.md#prd-nf-006) — Kejelasan status, konsistensi dan kegagalan | BR-004, BR-015, BR-018, BR-039, BR-042; [PRD-Q009](TRACEABILITY.md#prd-q009), [PRD-Q012](TRACEABILITY.md#prd-q012), [PRD-Q027](TRACEABILITY.md#prd-q027) | FRD §23; [TC-NF-006](FRD.md#tc-nf-006) |
| FRD-CL-NF-007 | [PRD-NF-007](PRD.md#prd-nf-007) — Tema SVG, konten bersumber dan keterbacaan | BR-023, BR-024, BR-037 | FRD §23; [TC-NF-007](FRD.md#tc-nf-007) |
| FRD-CL-NF-008 | [PRD-NF-008](PRD.md#prd-nf-008) — Milestone tanpa deadline, tim/Git, demo lokal/portabilitas | BR-003, BR-021, BR-034, BR-036, BR-041; [PRD-Q043](TRACEABILITY.md#prd-q043) | FRD §23; [TC-NF-008](FRD.md#tc-nf-008) |
| FRD-CL-NF-009 | [PRD-NF-009](PRD.md#prd-nf-009) — UAT nyata dan paket 2admin/6warga/12laporan/8dokumen | BR-001, BR-038, BR-039; [PRD-Q042](TRACEABILITY.md#prd-q042), [PRD-Q043](TRACEABILITY.md#prd-q043) | FRD §23; [TC-NF-009](FRD.md#tc-nf-009) |
| FRD-CL-NF-010 | [PRD-NF-010](PRD.md#prd-nf-010) — Cakupan/gate bertahap, exclusions dan penundaan | BR-021, BR-028, BR-029, BR-040; [PRD-Q013](TRACEABILITY.md#prd-q013), [PRD-Q041](TRACEABILITY.md#prd-q041), [PRD-Q043](TRACEABILITY.md#prd-q043) | FRD §23; [TC-NF-010](FRD.md#tc-nf-010) |

### 16.2 RTM balik — FR, use case, keputusan, acceptance dan tes

**Status setiap baris:** APPROVED v1.0.0 melalui FRD-APPROVAL-01; setiap tes NOT_RUN. Kolom akhir memetakan standar final. Satu sumber PRD boleh mempunyai beberapa FR ketika tindakannya terpisah; ini bukan penambahan scope. Setiap link AC/TC mengarah ke record dengan kondisi dan expected result.

| FR | Sumber / klaim | Use case / keputusan acuan | AC | TC | Penutupan final |
|---|---|---|---|---|---|
| [FR-AUTH-001](FRD.md#fr-auth-001) | [PRD-F-001](PRD.md#prd-f-001); FRD-CL-F-001 | UC-AUTH; PRD-DEC-001; PRD-APPROVAL-01 | [AC-AUTH-001-01](FRD.md#ac-auth-001-01), [AC-AUTH-001-02](FRD.md#ac-auth-001-02) | [TC-AUTH-001-01](FRD.md#tc-auth-001-01), [TC-AUTH-001-02](FRD.md#tc-auth-001-02) | APPROVED; [STD-002](FRD.md#frd-std-002), [STD-003](FRD.md#frd-std-003), [STD-005](FRD.md#frd-std-005); bukti NOT_RUN |
| [FR-AUTH-002](FRD.md#fr-auth-002) | [PRD-F-002](PRD.md#prd-f-002); FRD-CL-F-002 | UC-AUTH; PRD-DEC-002, PRD-DEC-034; PRD-APPROVAL-01 | [AC-AUTH-002-01](FRD.md#ac-auth-002-01), [AC-AUTH-002-02](FRD.md#ac-auth-002-02) | [TC-AUTH-002-01](FRD.md#tc-auth-002-01), [TC-AUTH-002-02](FRD.md#tc-auth-002-02) | APPROVED; [STD-002](FRD.md#frd-std-002), [STD-003](FRD.md#frd-std-003), [STD-005](FRD.md#frd-std-005); bukti NOT_RUN |
| [FR-AUTH-003](FRD.md#fr-auth-003) | [PRD-F-003](PRD.md#prd-f-003); FRD-CL-F-003 | UC-AUTH; PRD-DEC-001, PRD-DEC-002, PRD-DEC-034; PRD-APPROVAL-01 | [AC-AUTH-003-01](FRD.md#ac-auth-003-01), [AC-AUTH-003-02](FRD.md#ac-auth-003-02) | [TC-AUTH-003-01](FRD.md#tc-auth-003-01), [TC-AUTH-003-02](FRD.md#tc-auth-003-02) | APPROVED; [STD-002](FRD.md#frd-std-002), [STD-003](FRD.md#frd-std-003), [STD-005](FRD.md#frd-std-005); bukti NOT_RUN |
| [FR-AUTH-004](FRD.md#fr-auth-004) | [PRD-F-004](PRD.md#prd-f-004); FRD-CL-F-004 | UC-AUTH; BR/DEC pada sumber PRD; PRD-APPROVAL-01 | [AC-AUTH-004-01](FRD.md#ac-auth-004-01), [AC-AUTH-004-02](FRD.md#ac-auth-004-02) | [TC-AUTH-004-01](FRD.md#tc-auth-004-01), [TC-AUTH-004-02](FRD.md#tc-auth-004-02) | APPROVED; [STD-002](FRD.md#frd-std-002), [STD-003](FRD.md#frd-std-003), [STD-005](FRD.md#frd-std-005); bukti NOT_RUN |
| [FR-AUTH-005](FRD.md#fr-auth-005) | [PRD-F-005](PRD.md#prd-f-005); FRD-CL-F-005 | UC-AUTH; PRD-DEC-035; PRD-APPROVAL-01 | [AC-AUTH-005-01](FRD.md#ac-auth-005-01), [AC-AUTH-005-02](FRD.md#ac-auth-005-02) | [TC-AUTH-005-01](FRD.md#tc-auth-005-01), [TC-AUTH-005-02](FRD.md#tc-auth-005-02) | APPROVED; [STD-002](FRD.md#frd-std-002), [STD-003](FRD.md#frd-std-003), [STD-005](FRD.md#frd-std-005); bukti NOT_RUN |
| [FR-AUTH-006](FRD.md#fr-auth-006) | [PRD-F-005](PRD.md#prd-f-005); FRD-CL-F-005 | UC-AUTH; PRD-DEC-035; PRD-APPROVAL-01 | [AC-AUTH-006-01](FRD.md#ac-auth-006-01), [AC-AUTH-006-02](FRD.md#ac-auth-006-02) | [TC-AUTH-006-01](FRD.md#tc-auth-006-01), [TC-AUTH-006-02](FRD.md#tc-auth-006-02) | APPROVED; [STD-002](FRD.md#frd-std-002), [STD-003](FRD.md#frd-std-003), [STD-005](FRD.md#frd-std-005); bukti NOT_RUN |
| [FR-AUTH-007](FRD.md#fr-auth-007) | [PRD-F-006](PRD.md#prd-f-006); FRD-CL-F-006 | UC-AUTH; PRD-DEC-036; PRD-APPROVAL-01 | [AC-AUTH-007-01](FRD.md#ac-auth-007-01), [AC-AUTH-007-02](FRD.md#ac-auth-007-02) | [TC-AUTH-007-01](FRD.md#tc-auth-007-01), [TC-AUTH-007-02](FRD.md#tc-auth-007-02) | APPROVED; [STD-002](FRD.md#frd-std-002), [STD-003](FRD.md#frd-std-003), [STD-005](FRD.md#frd-std-005); bukti NOT_RUN |
| [FR-AUTH-008](FRD.md#fr-auth-008) | [PRD-F-057](PRD.md#prd-f-057); FRD-CL-F-057 | UC-AUTH; PRD-DEC-028; PRD-APPROVAL-01 | [AC-AUTH-008-01](FRD.md#ac-auth-008-01), [AC-AUTH-008-02](FRD.md#ac-auth-008-02) | [TC-AUTH-008-01](FRD.md#tc-auth-008-01), [TC-AUTH-008-02](FRD.md#tc-auth-008-02) | APPROVED; [STD-002](FRD.md#frd-std-002), [STD-003](FRD.md#frd-std-003), [STD-005](FRD.md#frd-std-005); bukti NOT_RUN |
| [FR-REPORT-001](FRD.md#fr-report-001) | [PRD-F-007](PRD.md#prd-f-007); FRD-CL-F-007 | UC-REPORT; BR/DEC pada sumber PRD; PRD-APPROVAL-01 | [AC-REPORT-001-01](FRD.md#ac-report-001-01), [AC-REPORT-001-02](FRD.md#ac-report-001-02) | [TC-REPORT-001-01](FRD.md#tc-report-001-01), [TC-REPORT-001-02](FRD.md#tc-report-001-02) | APPROVED; [STD-002](FRD.md#frd-std-002), [STD-004](FRD.md#frd-std-004), [STD-005](FRD.md#frd-std-005), [STD-010](FRD.md#frd-std-010); bukti NOT_RUN |
| [FR-REPORT-002](FRD.md#fr-report-002) | [PRD-F-008](PRD.md#prd-f-008); FRD-CL-F-008 | UC-REPORT; PRD-DEC-018; PRD-APPROVAL-01 | [AC-REPORT-002-01](FRD.md#ac-report-002-01), [AC-REPORT-002-02](FRD.md#ac-report-002-02) | [TC-REPORT-002-01](FRD.md#tc-report-002-01), [TC-REPORT-002-02](FRD.md#tc-report-002-02) | APPROVED; [STD-002](FRD.md#frd-std-002), [STD-004](FRD.md#frd-std-004), [STD-005](FRD.md#frd-std-005), [STD-010](FRD.md#frd-std-010); bukti NOT_RUN |
| [FR-REPORT-003](FRD.md#fr-report-003) | [PRD-F-009](PRD.md#prd-f-009); FRD-CL-F-009 | UC-REPORT; PRD-DEC-003, PRD-DEC-006, PRD-DEC-018; PRD-APPROVAL-01 | [AC-REPORT-003-01](FRD.md#ac-report-003-01), [AC-REPORT-003-02](FRD.md#ac-report-003-02) | [TC-REPORT-003-01](FRD.md#tc-report-003-01), [TC-REPORT-003-02](FRD.md#tc-report-003-02) | APPROVED; [STD-002](FRD.md#frd-std-002), [STD-004](FRD.md#frd-std-004), [STD-005](FRD.md#frd-std-005), [STD-010](FRD.md#frd-std-010); bukti NOT_RUN |
| [FR-REPORT-004](FRD.md#fr-report-004) | [PRD-F-010](PRD.md#prd-f-010); FRD-CL-F-010 | UC-REPORT; PRD-DEC-003, PRD-DEC-004, PRD-DEC-005, PRD-DEC-007, PRD-DEC-008; PRD-APPROVAL-01 | [AC-REPORT-004-01](FRD.md#ac-report-004-01), [AC-REPORT-004-02](FRD.md#ac-report-004-02) | [TC-REPORT-004-01](FRD.md#tc-report-004-01), [TC-REPORT-004-02](FRD.md#tc-report-004-02) | APPROVED; [STD-002](FRD.md#frd-std-002), [STD-004](FRD.md#frd-std-004), [STD-005](FRD.md#frd-std-005), [STD-010](FRD.md#frd-std-010); bukti NOT_RUN |
| [FR-REPORT-005](FRD.md#fr-report-005) | [PRD-F-010](PRD.md#prd-f-010); FRD-CL-F-010 | UC-REPORT; PRD-DEC-003, PRD-DEC-004, PRD-DEC-005, PRD-DEC-007, PRD-DEC-008; PRD-APPROVAL-01 | [AC-REPORT-005-01](FRD.md#ac-report-005-01), [AC-REPORT-005-02](FRD.md#ac-report-005-02) | [TC-REPORT-005-01](FRD.md#tc-report-005-01), [TC-REPORT-005-02](FRD.md#tc-report-005-02) | APPROVED; [STD-002](FRD.md#frd-std-002), [STD-004](FRD.md#frd-std-004), [STD-005](FRD.md#frd-std-005), [STD-010](FRD.md#frd-std-010); bukti NOT_RUN |
| [FR-REPORT-006](FRD.md#fr-report-006) | [PRD-F-010](PRD.md#prd-f-010); FRD-CL-F-010 | UC-REPORT; PRD-DEC-003, PRD-DEC-004, PRD-DEC-005, PRD-DEC-007, PRD-DEC-008; PRD-APPROVAL-01 | [AC-REPORT-006-01](FRD.md#ac-report-006-01), [AC-REPORT-006-02](FRD.md#ac-report-006-02) | [TC-REPORT-006-01](FRD.md#tc-report-006-01), [TC-REPORT-006-02](FRD.md#tc-report-006-02) | APPROVED; [STD-002](FRD.md#frd-std-002), [STD-004](FRD.md#frd-std-004), [STD-005](FRD.md#frd-std-005), [STD-010](FRD.md#frd-std-010); bukti NOT_RUN |
| [FR-KTP-001](FRD.md#fr-ktp-001) | [PRD-F-011](PRD.md#prd-f-011); FRD-CL-F-011 | UC-KTP; PRD-DEC-034, PRD-DEC-037; PRD-APPROVAL-01 | [AC-KTP-001-01](FRD.md#ac-ktp-001-01), [AC-KTP-001-02](FRD.md#ac-ktp-001-02) | [TC-KTP-001-01](FRD.md#tc-ktp-001-01), [TC-KTP-001-02](FRD.md#tc-ktp-001-02) | APPROVED; [STD-002](FRD.md#frd-std-002), [STD-005](FRD.md#frd-std-005), [STD-006](FRD.md#frd-std-006), [STD-010](FRD.md#frd-std-010); bukti NOT_RUN |
| [FR-KTP-002](FRD.md#fr-ktp-002) | [PRD-F-012](PRD.md#prd-f-012); FRD-CL-F-012 | UC-KTP; PRD-DEC-038; PRD-APPROVAL-01 | [AC-KTP-002-01](FRD.md#ac-ktp-002-01), [AC-KTP-002-02](FRD.md#ac-ktp-002-02) | [TC-KTP-002-01](FRD.md#tc-ktp-002-01), [TC-KTP-002-02](FRD.md#tc-ktp-002-02) | APPROVED; [STD-002](FRD.md#frd-std-002), [STD-005](FRD.md#frd-std-005), [STD-006](FRD.md#frd-std-006), [STD-010](FRD.md#frd-std-010); bukti NOT_RUN |
| [FR-KTP-003](FRD.md#fr-ktp-003) | [PRD-F-012](PRD.md#prd-f-012); FRD-CL-F-012 | UC-KTP; PRD-DEC-038; PRD-APPROVAL-01 | [AC-KTP-003-01](FRD.md#ac-ktp-003-01), [AC-KTP-003-02](FRD.md#ac-ktp-003-02) | [TC-KTP-003-01](FRD.md#tc-ktp-003-01), [TC-KTP-003-02](FRD.md#tc-ktp-003-02) | APPROVED; [STD-002](FRD.md#frd-std-002), [STD-005](FRD.md#frd-std-005), [STD-006](FRD.md#frd-std-006), [STD-010](FRD.md#frd-std-010); bukti NOT_RUN |
| [FR-KTP-004](FRD.md#fr-ktp-004) | [PRD-F-013](PRD.md#prd-f-013); FRD-CL-F-013 | UC-KTP; PRD-DEC-039; PRD-APPROVAL-01 | [AC-KTP-004-01](FRD.md#ac-ktp-004-01), [AC-KTP-004-02](FRD.md#ac-ktp-004-02) | [TC-KTP-004-01](FRD.md#tc-ktp-004-01), [TC-KTP-004-02](FRD.md#tc-ktp-004-02) | APPROVED; [STD-002](FRD.md#frd-std-002), [STD-005](FRD.md#frd-std-005), [STD-006](FRD.md#frd-std-006), [STD-010](FRD.md#frd-std-010); bukti NOT_RUN |
| [FR-REPORT-007](FRD.md#fr-report-007) | [PRD-F-014](PRD.md#prd-f-014); FRD-CL-F-014 | UC-REPORT; PRD-DEC-005, PRD-DEC-012; PRD-APPROVAL-01 | [AC-REPORT-007-01](FRD.md#ac-report-007-01), [AC-REPORT-007-02](FRD.md#ac-report-007-02) | [TC-REPORT-007-01](FRD.md#tc-report-007-01), [TC-REPORT-007-02](FRD.md#tc-report-007-02) | APPROVED; [STD-002](FRD.md#frd-std-002), [STD-004](FRD.md#frd-std-004), [STD-005](FRD.md#frd-std-005), [STD-010](FRD.md#frd-std-010); bukti NOT_RUN |
| [FR-REPORT-008](FRD.md#fr-report-008) | [PRD-F-015](PRD.md#prd-f-015); FRD-CL-F-015 | UC-REPORT; PRD-DEC-012; PRD-APPROVAL-01 | [AC-REPORT-008-01](FRD.md#ac-report-008-01), [AC-REPORT-008-02](FRD.md#ac-report-008-02) | [TC-REPORT-008-01](FRD.md#tc-report-008-01), [TC-REPORT-008-02](FRD.md#tc-report-008-02) | APPROVED; [STD-002](FRD.md#frd-std-002), [STD-004](FRD.md#frd-std-004), [STD-005](FRD.md#frd-std-005), [STD-010](FRD.md#frd-std-010); bukti NOT_RUN |
| [FR-REPORT-009](FRD.md#fr-report-009) | [PRD-F-015](PRD.md#prd-f-015); FRD-CL-F-015 | UC-REPORT; PRD-DEC-012; PRD-APPROVAL-01 | [AC-REPORT-009-01](FRD.md#ac-report-009-01), [AC-REPORT-009-02](FRD.md#ac-report-009-02) | [TC-REPORT-009-01](FRD.md#tc-report-009-01), [TC-REPORT-009-02](FRD.md#tc-report-009-02) | APPROVED; [STD-002](FRD.md#frd-std-002), [STD-004](FRD.md#frd-std-004), [STD-005](FRD.md#frd-std-005), [STD-010](FRD.md#frd-std-010); bukti NOT_RUN |
| [FR-REPORT-010](FRD.md#fr-report-010) | [PRD-F-015](PRD.md#prd-f-015); FRD-CL-F-015 | UC-REPORT; PRD-DEC-012; PRD-APPROVAL-01 | [AC-REPORT-010-01](FRD.md#ac-report-010-01), [AC-REPORT-010-02](FRD.md#ac-report-010-02) | [TC-REPORT-010-01](FRD.md#tc-report-010-01), [TC-REPORT-010-02](FRD.md#tc-report-010-02) | APPROVED; [STD-002](FRD.md#frd-std-002), [STD-004](FRD.md#frd-std-004), [STD-005](FRD.md#frd-std-005), [STD-010](FRD.md#frd-std-010); bukti NOT_RUN |
| [FR-REPORT-011](FRD.md#fr-report-011) | [PRD-F-016](PRD.md#prd-f-016); FRD-CL-F-016 | UC-REPORT; PRD-DEC-010, PRD-DEC-011; PRD-APPROVAL-01; [FRD-DEC-041](DECISIONS.md#frd-dec-041); [FRD-DEC-039](DECISIONS.md#frd-dec-039); [FRD-DEC-022](DECISIONS.md#frd-dec-022) | [AC-REPORT-011-01](FRD.md#ac-report-011-01), [AC-REPORT-011-02](FRD.md#ac-report-011-02) | [TC-REPORT-011-01](FRD.md#tc-report-011-01), [TC-REPORT-011-02](FRD.md#tc-report-011-02) | APPROVED; [STD-002](FRD.md#frd-std-002), [STD-004](FRD.md#frd-std-004), [STD-005](FRD.md#frd-std-005), [STD-010](FRD.md#frd-std-010); bukti NOT_RUN |
| [FR-REPORT-012](FRD.md#fr-report-012) | [PRD-F-017](PRD.md#prd-f-017); FRD-CL-F-017 | UC-REPORT; PRD-DEC-010; PRD-APPROVAL-01; [FRD-DEC-022](DECISIONS.md#frd-dec-022) | [AC-REPORT-012-01](FRD.md#ac-report-012-01), [AC-REPORT-012-02](FRD.md#ac-report-012-02) | [TC-REPORT-012-01](FRD.md#tc-report-012-01), [TC-REPORT-012-02](FRD.md#tc-report-012-02) | APPROVED; [STD-002](FRD.md#frd-std-002), [STD-004](FRD.md#frd-std-004), [STD-005](FRD.md#frd-std-005), [STD-010](FRD.md#frd-std-010); bukti NOT_RUN |
| [FR-AI-001](FRD.md#fr-ai-001) | [PRD-F-018](PRD.md#prd-f-018); FRD-CL-F-018 | UC-AI; BR/DEC pada sumber PRD; PRD-APPROVAL-01; [FRD-DEC-032](DECISIONS.md#frd-dec-032); [FRD-DEC-029](DECISIONS.md#frd-dec-029) | [AC-AI-001-01](FRD.md#ac-ai-001-01), [AC-AI-001-02](FRD.md#ac-ai-001-02) | [TC-AI-001-01](FRD.md#tc-ai-001-01), [TC-AI-001-02](FRD.md#tc-ai-001-02) | APPROVED; [STD-006](FRD.md#frd-std-006), [STD-010](FRD.md#frd-std-010), [STD-012](FRD.md#frd-std-012); bukti NOT_RUN |
| [FR-AI-002](FRD.md#fr-ai-002) | [PRD-F-019](PRD.md#prd-f-019); FRD-CL-F-019 | UC-AI; PRD-DEC-009; PRD-APPROVAL-01; [FRD-DEC-033](DECISIONS.md#frd-dec-033); [FRD-DEC-032](DECISIONS.md#frd-dec-032); [FRD-DEC-021](DECISIONS.md#frd-dec-021); [FRD-DEC-030](DECISIONS.md#frd-dec-030) | [AC-AI-002-01](FRD.md#ac-ai-002-01), [AC-AI-002-02](FRD.md#ac-ai-002-02) | [TC-AI-002-01](FRD.md#tc-ai-002-01), [TC-AI-002-02](FRD.md#tc-ai-002-02) | APPROVED; [STD-006](FRD.md#frd-std-006), [STD-010](FRD.md#frd-std-010), [STD-012](FRD.md#frd-std-012); bukti NOT_RUN |
| [FR-AI-003](FRD.md#fr-ai-003) | [PRD-F-020](PRD.md#prd-f-020); FRD-CL-F-020 | UC-AI; PRD-DEC-009; PRD-APPROVAL-01; [FRD-DEC-032](DECISIONS.md#frd-dec-032); [FRD-DEC-021](DECISIONS.md#frd-dec-021); [FRD-DEC-029](DECISIONS.md#frd-dec-029) | [AC-AI-003-01](FRD.md#ac-ai-003-01), [AC-AI-003-02](FRD.md#ac-ai-003-02) | [TC-AI-003-01](FRD.md#tc-ai-003-01), [TC-AI-003-02](FRD.md#tc-ai-003-02) | APPROVED; [STD-006](FRD.md#frd-std-006), [STD-010](FRD.md#frd-std-010), [STD-012](FRD.md#frd-std-012); bukti NOT_RUN |
| [FR-REVIEW-001](FRD.md#fr-review-001) | [PRD-F-021](PRD.md#prd-f-021); FRD-CL-F-021 | UC-REVIEW; BR/DEC pada sumber PRD; PRD-APPROVAL-01; [FRD-DEC-020](DECISIONS.md#frd-dec-020), [FRD-DEC-023](DECISIONS.md#frd-dec-023), [FRD-DEC-024](DECISIONS.md#frd-dec-024), [FRD-DEC-025](DECISIONS.md#frd-dec-025); [FRD-DEC-026](DECISIONS.md#frd-dec-026), [FRD-DEC-027](DECISIONS.md#frd-dec-027), [FRD-DEC-028](DECISIONS.md#frd-dec-028) | [AC-REVIEW-001-01](FRD.md#ac-review-001-01), [AC-REVIEW-001-02](FRD.md#ac-review-001-02) | [TC-REVIEW-001-01](FRD.md#tc-review-001-01), [TC-REVIEW-001-02](FRD.md#tc-review-001-02) | APPROVED; [STD-002](FRD.md#frd-std-002), [STD-008](FRD.md#frd-std-008), [STD-010](FRD.md#frd-std-010), [STD-011](FRD.md#frd-std-011); bukti NOT_RUN |
| [FR-REVIEW-002](FRD.md#fr-review-002) | [PRD-F-022](PRD.md#prd-f-022); FRD-CL-F-022 | UC-REVIEW; BR/DEC pada sumber PRD; PRD-APPROVAL-01; [FRD-DEC-034](DECISIONS.md#frd-dec-034); [FRD-DEC-035](DECISIONS.md#frd-dec-035); [FRD-DEC-031](DECISIONS.md#frd-dec-031) | [AC-REVIEW-002-01](FRD.md#ac-review-002-01), [AC-REVIEW-002-02](FRD.md#ac-review-002-02) | [TC-REVIEW-002-01](FRD.md#tc-review-002-01), [TC-REVIEW-002-02](FRD.md#tc-review-002-02) | APPROVED; [STD-002](FRD.md#frd-std-002), [STD-008](FRD.md#frd-std-008), [STD-010](FRD.md#frd-std-010), [STD-011](FRD.md#frd-std-011); bukti NOT_RUN |
| [FR-REVIEW-003](FRD.md#fr-review-003) | [PRD-F-023](PRD.md#prd-f-023); FRD-CL-F-023 | UC-REVIEW; BR/DEC pada sumber PRD; PRD-APPROVAL-01; [FRD-DEC-033](DECISIONS.md#frd-dec-033); [FRD-DEC-032](DECISIONS.md#frd-dec-032); [FRD-DEC-021](DECISIONS.md#frd-dec-021); [FRD-DEC-030](DECISIONS.md#frd-dec-030) | [AC-REVIEW-003-01](FRD.md#ac-review-003-01), [AC-REVIEW-003-02](FRD.md#ac-review-003-02) | [TC-REVIEW-003-01](FRD.md#tc-review-003-01), [TC-REVIEW-003-02](FRD.md#tc-review-003-02) | APPROVED; [STD-002](FRD.md#frd-std-002), [STD-008](FRD.md#frd-std-008), [STD-010](FRD.md#frd-std-010), [STD-011](FRD.md#frd-std-011); bukti NOT_RUN |
| [FR-REVIEW-004](FRD.md#fr-review-004) | [PRD-F-024](PRD.md#prd-f-024); FRD-CL-F-024 | UC-REVIEW; PRD-DEC-013; PRD-APPROVAL-01; [FRD-DEC-020](DECISIONS.md#frd-dec-020), [FRD-DEC-025](DECISIONS.md#frd-dec-025); [FRD-DEC-028](DECISIONS.md#frd-dec-028) | [AC-REVIEW-004-01](FRD.md#ac-review-004-01), [AC-REVIEW-004-02](FRD.md#ac-review-004-02) | [TC-REVIEW-004-01](FRD.md#tc-review-004-01), [TC-REVIEW-004-02](FRD.md#tc-review-004-02) | APPROVED; [STD-002](FRD.md#frd-std-002), [STD-008](FRD.md#frd-std-008), [STD-010](FRD.md#frd-std-010), [STD-011](FRD.md#frd-std-011); bukti NOT_RUN |
| [FR-REVIEW-005](FRD.md#fr-review-005) | [PRD-F-025](PRD.md#prd-f-025); FRD-CL-F-025 | UC-REVIEW; PRD-DEC-014; PRD-APPROVAL-01; [FRD-DEC-039](DECISIONS.md#frd-dec-039); [FRD-DEC-036](DECISIONS.md#frd-dec-036); [FRD-DEC-037](DECISIONS.md#frd-dec-037) | [AC-REVIEW-005-01](FRD.md#ac-review-005-01), [AC-REVIEW-005-02](FRD.md#ac-review-005-02) | [TC-REVIEW-005-01](FRD.md#tc-review-005-01), [TC-REVIEW-005-02](FRD.md#tc-review-005-02) | APPROVED; [STD-002](FRD.md#frd-std-002), [STD-008](FRD.md#frd-std-008), [STD-010](FRD.md#frd-std-010), [STD-011](FRD.md#frd-std-011); bukti NOT_RUN |
| [FR-REVIEW-006](FRD.md#fr-review-006) | [PRD-F-026](PRD.md#prd-f-026); FRD-CL-F-026 | UC-REVIEW; PRD-DEC-016; PRD-APPROVAL-01; [FRD-DEC-033](DECISIONS.md#frd-dec-033); [FRD-DEC-034](DECISIONS.md#frd-dec-034); [FRD-DEC-031](DECISIONS.md#frd-dec-031) | [AC-REVIEW-006-01](FRD.md#ac-review-006-01), [AC-REVIEW-006-02](FRD.md#ac-review-006-02) | [TC-REVIEW-006-01](FRD.md#tc-review-006-01), [TC-REVIEW-006-02](FRD.md#tc-review-006-02) | APPROVED; [STD-002](FRD.md#frd-std-002), [STD-008](FRD.md#frd-std-008), [STD-010](FRD.md#frd-std-010), [STD-011](FRD.md#frd-std-011); bukti NOT_RUN |
| [FR-REVIEW-007](FRD.md#fr-review-007) | [PRD-F-027](PRD.md#prd-f-027); FRD-CL-F-027 | UC-REVIEW; BR/DEC pada sumber PRD; PRD-APPROVAL-01; [FRD-DEC-025](DECISIONS.md#frd-dec-025) | [AC-REVIEW-007-01](FRD.md#ac-review-007-01), [AC-REVIEW-007-02](FRD.md#ac-review-007-02) | [TC-REVIEW-007-01](FRD.md#tc-review-007-01), [TC-REVIEW-007-02](FRD.md#tc-review-007-02) | APPROVED; [STD-002](FRD.md#frd-std-002), [STD-008](FRD.md#frd-std-008), [STD-010](FRD.md#frd-std-010), [STD-011](FRD.md#frd-std-011); bukti NOT_RUN |
| [FR-REVIEW-008](FRD.md#fr-review-008) | [PRD-F-028](PRD.md#prd-f-028); FRD-CL-F-028 | UC-REVIEW; PRD-DEC-015; PRD-APPROVAL-01; [FRD-DEC-023](DECISIONS.md#frd-dec-023), [FRD-DEC-024](DECISIONS.md#frd-dec-024), [FRD-DEC-025](DECISIONS.md#frd-dec-025); [FRD-DEC-026](DECISIONS.md#frd-dec-026) | [AC-REVIEW-008-01](FRD.md#ac-review-008-01), [AC-REVIEW-008-02](FRD.md#ac-review-008-02) | [TC-REVIEW-008-01](FRD.md#tc-review-008-01), [TC-REVIEW-008-02](FRD.md#tc-review-008-02) | APPROVED; [STD-002](FRD.md#frd-std-002), [STD-008](FRD.md#frd-std-008), [STD-010](FRD.md#frd-std-010), [STD-011](FRD.md#frd-std-011); bukti NOT_RUN |
| [FR-REVIEW-009](FRD.md#fr-review-009) | [PRD-F-023](PRD.md#prd-f-023); FRD-CL-F-023 | UC-REVIEW; BR/DEC pada sumber PRD; PRD-APPROVAL-01; [FRD-DEC-033](DECISIONS.md#frd-dec-033); [FRD-DEC-035](DECISIONS.md#frd-dec-035); [FRD-DEC-028](DECISIONS.md#frd-dec-028) | [AC-REVIEW-009-01](FRD.md#ac-review-009-01), [AC-REVIEW-009-02](FRD.md#ac-review-009-02) | [TC-REVIEW-009-01](FRD.md#tc-review-009-01), [TC-REVIEW-009-02](FRD.md#tc-review-009-02) | APPROVED; [STD-002](FRD.md#frd-std-002), [STD-008](FRD.md#frd-std-008), [STD-010](FRD.md#frd-std-010), [STD-011](FRD.md#frd-std-011); bukti NOT_RUN |
| [FR-CONTROL-001](FRD.md#fr-control-001) | [PRD-F-029](PRD.md#prd-f-029); FRD-CL-F-029 | UC-CONTROL; BR/DEC pada sumber PRD; PRD-APPROVAL-01 | [AC-CONTROL-001-01](FRD.md#ac-control-001-01), [AC-CONTROL-001-02](FRD.md#ac-control-001-02) | [TC-CONTROL-001-01](FRD.md#tc-control-001-01), [TC-CONTROL-001-02](FRD.md#tc-control-001-02) | APPROVED; [STD-002](FRD.md#frd-std-002), [STD-004](FRD.md#frd-std-004), [STD-010](FRD.md#frd-std-010), [STD-011](FRD.md#frd-std-011); bukti NOT_RUN |
| [FR-CONTROL-002](FRD.md#fr-control-002) | [PRD-F-030](PRD.md#prd-f-030); FRD-CL-F-030 | UC-CONTROL; BR/DEC pada sumber PRD; PRD-APPROVAL-01 | [AC-CONTROL-002-01](FRD.md#ac-control-002-01), [AC-CONTROL-002-02](FRD.md#ac-control-002-02) | [TC-CONTROL-002-01](FRD.md#tc-control-002-01), [TC-CONTROL-002-02](FRD.md#tc-control-002-02) | APPROVED; [STD-002](FRD.md#frd-std-002), [STD-004](FRD.md#frd-std-004), [STD-010](FRD.md#frd-std-010), [STD-011](FRD.md#frd-std-011); bukti NOT_RUN |
| [FR-CONTROL-003](FRD.md#fr-control-003) | [PRD-F-031](PRD.md#prd-f-031); FRD-CL-F-031 | UC-CONTROL; BR/DEC pada sumber PRD; PRD-APPROVAL-01 | [AC-CONTROL-003-01](FRD.md#ac-control-003-01), [AC-CONTROL-003-02](FRD.md#ac-control-003-02) | [TC-CONTROL-003-01](FRD.md#tc-control-003-01), [TC-CONTROL-003-02](FRD.md#tc-control-003-02) | APPROVED; [STD-002](FRD.md#frd-std-002), [STD-004](FRD.md#frd-std-004), [STD-010](FRD.md#frd-std-010), [STD-011](FRD.md#frd-std-011); bukti NOT_RUN |
| [FR-CONTROL-004](FRD.md#fr-control-004) | [PRD-F-032](PRD.md#prd-f-032); FRD-CL-F-032 | UC-CONTROL; BR/DEC pada sumber PRD; PRD-APPROVAL-01; [FRD-DEC-041](DECISIONS.md#frd-dec-041); [FRD-DEC-038](DECISIONS.md#frd-dec-038); [FRD-DEC-039](DECISIONS.md#frd-dec-039); [FRD-DEC-040](DECISIONS.md#frd-dec-040); [FRD-DEC-022](DECISIONS.md#frd-dec-022) | [AC-CONTROL-004-01](FRD.md#ac-control-004-01), [AC-CONTROL-004-02](FRD.md#ac-control-004-02) | [TC-CONTROL-004-01](FRD.md#tc-control-004-01), [TC-CONTROL-004-02](FRD.md#tc-control-004-02) | APPROVED; [STD-002](FRD.md#frd-std-002), [STD-004](FRD.md#frd-std-004), [STD-010](FRD.md#frd-std-010), [STD-011](FRD.md#frd-std-011); bukti NOT_RUN |
| [FR-CONTROL-005](FRD.md#fr-control-005) | [PRD-F-033](PRD.md#prd-f-033); FRD-CL-F-033 | UC-CONTROL; BR/DEC pada sumber PRD; PRD-APPROVAL-01; [FRD-DEC-039](DECISIONS.md#frd-dec-039); [FRD-DEC-021](DECISIONS.md#frd-dec-021), [FRD-DEC-022](DECISIONS.md#frd-dec-022); [FRD-DEC-027](DECISIONS.md#frd-dec-027), [FRD-DEC-028](DECISIONS.md#frd-dec-028) | [AC-CONTROL-005-01](FRD.md#ac-control-005-01), [AC-CONTROL-005-02](FRD.md#ac-control-005-02) | [TC-CONTROL-005-01](FRD.md#tc-control-005-01), [TC-CONTROL-005-02](FRD.md#tc-control-005-02) | APPROVED; [STD-002](FRD.md#frd-std-002), [STD-004](FRD.md#frd-std-004), [STD-010](FRD.md#frd-std-010), [STD-011](FRD.md#frd-std-011); bukti NOT_RUN |
| [FR-MONITOR-001](FRD.md#fr-monitor-001) | [PRD-F-034](PRD.md#prd-f-034); FRD-CL-F-034 | UC-MONITOR; BR/DEC pada sumber PRD; PRD-APPROVAL-01; [FRD-DEC-033](DECISIONS.md#frd-dec-033); [FRD-DEC-035](DECISIONS.md#frd-dec-035); [FRD-DEC-027](DECISIONS.md#frd-dec-027) | [AC-MONITOR-001-01](FRD.md#ac-monitor-001-01), [AC-MONITOR-001-02](FRD.md#ac-monitor-001-02) | [TC-MONITOR-001-01](FRD.md#tc-monitor-001-01), [TC-MONITOR-001-02](FRD.md#tc-monitor-001-02) | APPROVED; [STD-008](FRD.md#frd-std-008), [STD-010](FRD.md#frd-std-010); bukti NOT_RUN |
| [FR-MONITOR-002](FRD.md#fr-monitor-002) | [PRD-F-035](PRD.md#prd-f-035); FRD-CL-F-035 | UC-MONITOR; BR/DEC pada sumber PRD; PRD-APPROVAL-01; [FRD-DEC-035](DECISIONS.md#frd-dec-035) | [AC-MONITOR-002-01](FRD.md#ac-monitor-002-01), [AC-MONITOR-002-02](FRD.md#ac-monitor-002-02) | [TC-MONITOR-002-01](FRD.md#tc-monitor-002-01), [TC-MONITOR-002-02](FRD.md#tc-monitor-002-02) | APPROVED; [STD-008](FRD.md#frd-std-008), [STD-010](FRD.md#frd-std-010); bukti NOT_RUN |
| [FR-MONITOR-003](FRD.md#fr-monitor-003) | [PRD-F-036](PRD.md#prd-f-036); FRD-CL-F-036 | UC-MONITOR; PRD-DEC-017; PRD-APPROVAL-01; [FRD-DEC-032](DECISIONS.md#frd-dec-032); [FRD-DEC-021](DECISIONS.md#frd-dec-021); [FRD-DEC-029](DECISIONS.md#frd-dec-029), [FRD-DEC-030](DECISIONS.md#frd-dec-030) | [AC-MONITOR-003-01](FRD.md#ac-monitor-003-01), [AC-MONITOR-003-02](FRD.md#ac-monitor-003-02) | [TC-MONITOR-003-01](FRD.md#tc-monitor-003-01), [TC-MONITOR-003-02](FRD.md#tc-monitor-003-02) | APPROVED; [STD-008](FRD.md#frd-std-008), [STD-010](FRD.md#frd-std-010); bukti NOT_RUN |
| [FR-VAULT-001](FRD.md#fr-vault-001) | [PRD-F-037](PRD.md#prd-f-037); FRD-CL-F-037 | UC-VAULT; PRD-DEC-027, PRD-DEC-030, PRD-DEC-039; PRD-APPROVAL-01 | [AC-VAULT-001-01](FRD.md#ac-vault-001-01), [AC-VAULT-001-02](FRD.md#ac-vault-001-02) | [TC-VAULT-001-01](FRD.md#tc-vault-001-01), [TC-VAULT-001-02](FRD.md#tc-vault-001-02) | APPROVED; [STD-002](FRD.md#frd-std-002), [STD-005](FRD.md#frd-std-005), [STD-006](FRD.md#frd-std-006), [STD-011](FRD.md#frd-std-011); bukti NOT_RUN |
| [FR-VAULT-002](FRD.md#fr-vault-002) | [PRD-F-037](PRD.md#prd-f-037); FRD-CL-F-037 | UC-VAULT; PRD-DEC-027, PRD-DEC-030, PRD-DEC-039; PRD-APPROVAL-01 | [AC-VAULT-002-01](FRD.md#ac-vault-002-01), [AC-VAULT-002-02](FRD.md#ac-vault-002-02) | [TC-VAULT-002-01](FRD.md#tc-vault-002-01), [TC-VAULT-002-02](FRD.md#tc-vault-002-02) | APPROVED; [STD-002](FRD.md#frd-std-002), [STD-005](FRD.md#frd-std-005), [STD-006](FRD.md#frd-std-006), [STD-011](FRD.md#frd-std-011); bukti NOT_RUN |
| [FR-VAULT-003](FRD.md#fr-vault-003) | [PRD-F-037](PRD.md#prd-f-037); FRD-CL-F-037 | UC-VAULT; PRD-DEC-027, PRD-DEC-030, PRD-DEC-039; PRD-APPROVAL-01 | [AC-VAULT-003-01](FRD.md#ac-vault-003-01), [AC-VAULT-003-02](FRD.md#ac-vault-003-02) | [TC-VAULT-003-01](FRD.md#tc-vault-003-01), [TC-VAULT-003-02](FRD.md#tc-vault-003-02) | APPROVED; [STD-002](FRD.md#frd-std-002), [STD-005](FRD.md#frd-std-005), [STD-006](FRD.md#frd-std-006), [STD-011](FRD.md#frd-std-011); bukti NOT_RUN |
| [FR-VAULT-004](FRD.md#fr-vault-004) | [PRD-F-038](PRD.md#prd-f-038); FRD-CL-F-038 | UC-VAULT; BR/DEC pada sumber PRD; PRD-APPROVAL-01 | [AC-VAULT-004-01](FRD.md#ac-vault-004-01), [AC-VAULT-004-02](FRD.md#ac-vault-004-02) | [TC-VAULT-004-01](FRD.md#tc-vault-004-01), [TC-VAULT-004-02](FRD.md#tc-vault-004-02) | APPROVED; [STD-002](FRD.md#frd-std-002), [STD-005](FRD.md#frd-std-005), [STD-006](FRD.md#frd-std-006), [STD-011](FRD.md#frd-std-011); bukti NOT_RUN |
| [FR-FAMILY-001](FRD.md#fr-family-001) | [PRD-F-039](PRD.md#prd-f-039); FRD-CL-F-039 | UC-FAMILY; PRD-DEC-022, PRD-DEC-025; PRD-APPROVAL-01 | [AC-FAMILY-001-01](FRD.md#ac-family-001-01), [AC-FAMILY-001-02](FRD.md#ac-family-001-02) | [TC-FAMILY-001-01](FRD.md#tc-family-001-01), [TC-FAMILY-001-02](FRD.md#tc-family-001-02) | APPROVED; [STD-002](FRD.md#frd-std-002), [STD-005](FRD.md#frd-std-005), [STD-006](FRD.md#frd-std-006), [STD-007](FRD.md#frd-std-007), [STD-010](FRD.md#frd-std-010); bukti NOT_RUN |
| [FR-FAMILY-002](FRD.md#fr-family-002) | [PRD-F-040](PRD.md#prd-f-040); FRD-CL-F-040 | UC-FAMILY; PRD-DEC-022, PRD-DEC-025; PRD-APPROVAL-01 | [AC-FAMILY-002-01](FRD.md#ac-family-002-01), [AC-FAMILY-002-02](FRD.md#ac-family-002-02) | [TC-FAMILY-002-01](FRD.md#tc-family-002-01), [TC-FAMILY-002-02](FRD.md#tc-family-002-02) | APPROVED; [STD-002](FRD.md#frd-std-002), [STD-005](FRD.md#frd-std-005), [STD-006](FRD.md#frd-std-006), [STD-007](FRD.md#frd-std-007), [STD-010](FRD.md#frd-std-010); bukti NOT_RUN |
| [FR-FAMILY-003](FRD.md#fr-family-003) | [PRD-F-041](PRD.md#prd-f-041); FRD-CL-F-041 | UC-FAMILY; PRD-DEC-023, PRD-DEC-026; PRD-APPROVAL-01 | [AC-FAMILY-003-01](FRD.md#ac-family-003-01), [AC-FAMILY-003-02](FRD.md#ac-family-003-02) | [TC-FAMILY-003-01](FRD.md#tc-family-003-01), [TC-FAMILY-003-02](FRD.md#tc-family-003-02) | APPROVED; [STD-002](FRD.md#frd-std-002), [STD-005](FRD.md#frd-std-005), [STD-006](FRD.md#frd-std-006), [STD-007](FRD.md#frd-std-007), [STD-010](FRD.md#frd-std-010); bukti NOT_RUN |
| [FR-FAMILY-004](FRD.md#fr-family-004) | [PRD-F-042](PRD.md#prd-f-042); FRD-CL-F-042 | UC-FAMILY; PRD-DEC-027; PRD-APPROVAL-01 | [AC-FAMILY-004-01](FRD.md#ac-family-004-01), [AC-FAMILY-004-02](FRD.md#ac-family-004-02) | [TC-FAMILY-004-01](FRD.md#tc-family-004-01), [TC-FAMILY-004-02](FRD.md#tc-family-004-02) | APPROVED; [STD-002](FRD.md#frd-std-002), [STD-005](FRD.md#frd-std-005), [STD-006](FRD.md#frd-std-006), [STD-007](FRD.md#frd-std-007), [STD-010](FRD.md#frd-std-010); bukti NOT_RUN |
| [FR-FAMILY-005](FRD.md#fr-family-005) | [PRD-F-043](PRD.md#prd-f-043); FRD-CL-F-043 | UC-FAMILY; PRD-DEC-019, PRD-DEC-022, PRD-DEC-023, PRD-DEC-024; PRD-APPROVAL-01 | [AC-FAMILY-005-01](FRD.md#ac-family-005-01), [AC-FAMILY-005-02](FRD.md#ac-family-005-02) | [TC-FAMILY-005-01](FRD.md#tc-family-005-01), [TC-FAMILY-005-02](FRD.md#tc-family-005-02) | APPROVED; [STD-002](FRD.md#frd-std-002), [STD-005](FRD.md#frd-std-005), [STD-006](FRD.md#frd-std-006), [STD-007](FRD.md#frd-std-007), [STD-010](FRD.md#frd-std-010); bukti NOT_RUN |
| [FR-FAMILY-006](FRD.md#fr-family-006) | [PRD-F-044](PRD.md#prd-f-044); FRD-CL-F-044 | UC-FAMILY; PRD-DEC-029; PRD-APPROVAL-01 | [AC-FAMILY-006-01](FRD.md#ac-family-006-01), [AC-FAMILY-006-02](FRD.md#ac-family-006-02) | [TC-FAMILY-006-01](FRD.md#tc-family-006-01), [TC-FAMILY-006-02](FRD.md#tc-family-006-02) | APPROVED; [STD-002](FRD.md#frd-std-002), [STD-005](FRD.md#frd-std-005), [STD-006](FRD.md#frd-std-006), [STD-007](FRD.md#frd-std-007), [STD-010](FRD.md#frd-std-010); bukti NOT_RUN |
| [FR-FAMILY-007](FRD.md#fr-family-007) | [PRD-F-045](PRD.md#prd-f-045); FRD-CL-F-045 | UC-FAMILY; PRD-DEC-030; PRD-APPROVAL-01 | [AC-FAMILY-007-01](FRD.md#ac-family-007-01), [AC-FAMILY-007-02](FRD.md#ac-family-007-02) | [TC-FAMILY-007-01](FRD.md#tc-family-007-01), [TC-FAMILY-007-02](FRD.md#tc-family-007-02) | APPROVED; [STD-002](FRD.md#frd-std-002), [STD-005](FRD.md#frd-std-005), [STD-006](FRD.md#frd-std-006), [STD-007](FRD.md#frd-std-007), [STD-010](FRD.md#frd-std-010); bukti NOT_RUN |
| [FR-READY-001](FRD.md#fr-ready-001) | [PRD-F-046](PRD.md#prd-f-046); FRD-CL-F-046 | UC-READY; PRD-DEC-019, PRD-DEC-033; PRD-APPROVAL-01 | [AC-READY-001-01](FRD.md#ac-ready-001-01), [AC-READY-001-02](FRD.md#ac-ready-001-02) | [TC-READY-001-01](FRD.md#tc-ready-001-01), [TC-READY-001-02](FRD.md#tc-ready-001-02) | APPROVED; [STD-002](FRD.md#frd-std-002), [STD-005](FRD.md#frd-std-005), [STD-007](FRD.md#frd-std-007), [STD-008](FRD.md#frd-std-008); bukti NOT_RUN |
| [FR-READY-002](FRD.md#fr-ready-002) | [PRD-F-047](PRD.md#prd-f-047); FRD-CL-F-047 | UC-READY; PRD-DEC-019, PRD-DEC-020; PRD-APPROVAL-01 | [AC-READY-002-01](FRD.md#ac-ready-002-01), [AC-READY-002-02](FRD.md#ac-ready-002-02) | [TC-READY-002-01](FRD.md#tc-ready-002-01), [TC-READY-002-02](FRD.md#tc-ready-002-02) | APPROVED; [STD-002](FRD.md#frd-std-002), [STD-005](FRD.md#frd-std-005), [STD-007](FRD.md#frd-std-007), [STD-008](FRD.md#frd-std-008); bukti NOT_RUN |
| [FR-READY-003](FRD.md#fr-ready-003) | [PRD-F-048](PRD.md#prd-f-048); FRD-CL-F-048 | UC-READY; PRD-DEC-021; PRD-APPROVAL-01 | [AC-READY-003-01](FRD.md#ac-ready-003-01), [AC-READY-003-02](FRD.md#ac-ready-003-02) | [TC-READY-003-01](FRD.md#tc-ready-003-01), [TC-READY-003-02](FRD.md#tc-ready-003-02) | APPROVED; [STD-002](FRD.md#frd-std-002), [STD-005](FRD.md#frd-std-005), [STD-007](FRD.md#frd-std-007), [STD-008](FRD.md#frd-std-008); bukti NOT_RUN |
| [FR-READY-004](FRD.md#fr-ready-004) | [PRD-F-049](PRD.md#prd-f-049); FRD-CL-F-049 | UC-READY; PRD-DEC-021; PRD-APPROVAL-01 | [AC-READY-004-01](FRD.md#ac-ready-004-01), [AC-READY-004-02](FRD.md#ac-ready-004-02) | [TC-READY-004-01](FRD.md#tc-ready-004-01), [TC-READY-004-02](FRD.md#tc-ready-004-02) | APPROVED; [STD-002](FRD.md#frd-std-002), [STD-005](FRD.md#frd-std-005), [STD-007](FRD.md#frd-std-007), [STD-008](FRD.md#frd-std-008); bukti NOT_RUN |
| [FR-READY-005](FRD.md#fr-ready-005) | [PRD-F-050](PRD.md#prd-f-050); FRD-CL-F-050 | UC-READY; PRD-DEC-020, PRD-DEC-028; PRD-APPROVAL-01 | [AC-READY-005-01](FRD.md#ac-ready-005-01), [AC-READY-005-02](FRD.md#ac-ready-005-02) | [TC-READY-005-01](FRD.md#tc-ready-005-01), [TC-READY-005-02](FRD.md#tc-ready-005-02) | APPROVED; [STD-002](FRD.md#frd-std-002), [STD-005](FRD.md#frd-std-005), [STD-007](FRD.md#frd-std-007), [STD-008](FRD.md#frd-std-008); bukti NOT_RUN |
| [FR-READY-006](FRD.md#fr-ready-006) | [PRD-F-051](PRD.md#prd-f-051); FRD-CL-F-051 | UC-READY; PRD-DEC-032; PRD-APPROVAL-01 | [AC-READY-006-01](FRD.md#ac-ready-006-01), [AC-READY-006-02](FRD.md#ac-ready-006-02) | [TC-READY-006-01](FRD.md#tc-ready-006-01), [TC-READY-006-02](FRD.md#tc-ready-006-02) | APPROVED; [STD-002](FRD.md#frd-std-002), [STD-005](FRD.md#frd-std-005), [STD-007](FRD.md#frd-std-007), [STD-008](FRD.md#frd-std-008); bukti NOT_RUN |
| [FR-READY-007](FRD.md#fr-ready-007) | [PRD-F-052](PRD.md#prd-f-052); FRD-CL-F-052 | UC-READY; PRD-DEC-031; PRD-APPROVAL-01 | [AC-READY-007-01](FRD.md#ac-ready-007-01), [AC-READY-007-02](FRD.md#ac-ready-007-02) | [TC-READY-007-01](FRD.md#tc-ready-007-01), [TC-READY-007-02](FRD.md#tc-ready-007-02) | APPROVED; [STD-002](FRD.md#frd-std-002), [STD-005](FRD.md#frd-std-005), [STD-007](FRD.md#frd-std-007), [STD-008](FRD.md#frd-std-008); bukti NOT_RUN |
| [FR-READY-008](FRD.md#fr-ready-008) | [PRD-F-052](PRD.md#prd-f-052); FRD-CL-F-052 | UC-READY; PRD-DEC-031; PRD-APPROVAL-01 | [AC-READY-008-01](FRD.md#ac-ready-008-01), [AC-READY-008-02](FRD.md#ac-ready-008-02) | [TC-READY-008-01](FRD.md#tc-ready-008-01), [TC-READY-008-02](FRD.md#tc-ready-008-02) | APPROVED; [STD-002](FRD.md#frd-std-002), [STD-005](FRD.md#frd-std-005), [STD-007](FRD.md#frd-std-007), [STD-008](FRD.md#frd-std-008); bukti NOT_RUN |
| [FR-CONTENT-001](FRD.md#fr-content-001) | [PRD-F-053](PRD.md#prd-f-053); FRD-CL-F-053 | UC-CONTENT; PRD-DEC-021; PRD-APPROVAL-01 | [AC-CONTENT-001-01](FRD.md#ac-content-001-01), [AC-CONTENT-001-02](FRD.md#ac-content-001-02) | [TC-CONTENT-001-01](FRD.md#tc-content-001-01), [TC-CONTENT-001-02](FRD.md#tc-content-001-02) | APPROVED; [STD-002](FRD.md#frd-std-002), [STD-007](FRD.md#frd-std-007), [STD-008](FRD.md#frd-std-008), [STD-010](FRD.md#frd-std-010); bukti NOT_RUN |
| [FR-INBOX-001](FRD.md#fr-inbox-001) | [PRD-F-054](PRD.md#prd-f-054); FRD-CL-F-054 | UC-INBOX; PRD-DEC-040; PRD-APPROVAL-01 | [AC-INBOX-001-01](FRD.md#ac-inbox-001-01), [AC-INBOX-001-02](FRD.md#ac-inbox-001-02) | [TC-INBOX-001-01](FRD.md#tc-inbox-001-01), [TC-INBOX-001-02](FRD.md#tc-inbox-001-02) | APPROVED; [STD-002](FRD.md#frd-std-002), [STD-009](FRD.md#frd-std-009), [STD-010](FRD.md#frd-std-010); bukti NOT_RUN |
| [FR-INBOX-002](FRD.md#fr-inbox-002) | [PRD-F-055](PRD.md#prd-f-055); FRD-CL-F-055 | UC-INBOX; PRD-DEC-040; PRD-APPROVAL-01 | [AC-INBOX-002-01](FRD.md#ac-inbox-002-01), [AC-INBOX-002-02](FRD.md#ac-inbox-002-02) | [TC-INBOX-002-01](FRD.md#tc-inbox-002-01), [TC-INBOX-002-02](FRD.md#tc-inbox-002-02) | APPROVED; [STD-002](FRD.md#frd-std-002), [STD-009](FRD.md#frd-std-009), [STD-010](FRD.md#frd-std-010); bukti NOT_RUN |
| [FR-INBOX-003](FRD.md#fr-inbox-003) | [PRD-F-055](PRD.md#prd-f-055); FRD-CL-F-055 | UC-INBOX; PRD-DEC-040; PRD-APPROVAL-01 | [AC-INBOX-003-01](FRD.md#ac-inbox-003-01), [AC-INBOX-003-02](FRD.md#ac-inbox-003-02) | [TC-INBOX-003-01](FRD.md#tc-inbox-003-01), [TC-INBOX-003-02](FRD.md#tc-inbox-003-02) | APPROVED; [STD-002](FRD.md#frd-std-002), [STD-009](FRD.md#frd-std-009), [STD-010](FRD.md#frd-std-010); bukti NOT_RUN |
| [FR-INBOX-004](FRD.md#fr-inbox-004) | [PRD-F-056](PRD.md#prd-f-056); FRD-CL-F-056 | UC-INBOX; PRD-DEC-040; PRD-APPROVAL-01 | [AC-INBOX-004-01](FRD.md#ac-inbox-004-01), [AC-INBOX-004-02](FRD.md#ac-inbox-004-02) | [TC-INBOX-004-01](FRD.md#tc-inbox-004-01), [TC-INBOX-004-02](FRD.md#tc-inbox-004-02) | APPROVED; [STD-002](FRD.md#frd-std-002), [STD-009](FRD.md#frd-std-009), [STD-010](FRD.md#frd-std-010); bukti NOT_RUN |

### 16.3 Batasan NF dan pengujian terkait

| Sumber / klaim | Dampak FRD | Acceptance asal | Tes rencana / status |
|---|---|---|---|
| [PRD-NF-001](PRD.md#prd-nf-001); FRD-CL-NF-001 | [FR-AUTH-001](FRD.md#fr-auth-001), [FR-REPORT-008](FRD.md#fr-report-008), [FR-REVIEW-003](FRD.md#fr-review-003) | [PRD-AC-NF-001](PRD.md#prd-ac-nf-001) | [TC-NF-001](FRD.md#tc-nf-001) — NOT_RUN |
| [PRD-NF-002](PRD.md#prd-nf-002); FRD-CL-NF-002 | [FR-REPORT-010](FRD.md#fr-report-010), [FR-AI-001](FRD.md#fr-ai-001) | [PRD-AC-NF-002](PRD.md#prd-ac-nf-002) | [TC-NF-002](FRD.md#tc-nf-002) — NOT_RUN |
| [PRD-NF-003](PRD.md#prd-nf-003); FRD-CL-NF-003 | [FR-AI-001](FRD.md#fr-ai-001), [FR-KTP-002](FRD.md#fr-ktp-002), [FR-FAMILY-002](FRD.md#fr-family-002) | [PRD-AC-NF-003](PRD.md#prd-ac-nf-003) | [TC-NF-003](FRD.md#tc-nf-003) — NOT_RUN |
| [PRD-NF-004](PRD.md#prd-nf-004); FRD-CL-NF-004 | [FR-AUTH-002](FRD.md#fr-auth-002), [FR-AUTH-006](FRD.md#fr-auth-006) | [PRD-AC-NF-004](PRD.md#prd-ac-nf-004) | [TC-NF-004](FRD.md#tc-nf-004) — NOT_RUN |
| [PRD-NF-005](PRD.md#prd-nf-005); FRD-CL-NF-005 | [FR-VAULT-002](FRD.md#fr-vault-002), [FR-FAMILY-005](FRD.md#fr-family-005), [FR-READY-004](FRD.md#fr-ready-004), [FR-MONITOR-001](FRD.md#fr-monitor-001) | [PRD-AC-NF-005](PRD.md#prd-ac-nf-005) | [TC-NF-005](FRD.md#tc-nf-005) — NOT_RUN |
| [PRD-NF-006](PRD.md#prd-nf-006); FRD-CL-NF-006 | [FR-REPORT-010](FRD.md#fr-report-010), [FR-AI-003](FRD.md#fr-ai-003), [FR-CONTROL-005](FRD.md#fr-control-005) | [PRD-AC-NF-006](PRD.md#prd-ac-nf-006) | [TC-NF-006](FRD.md#tc-nf-006) — NOT_RUN |
| [PRD-NF-007](PRD.md#prd-nf-007); FRD-CL-NF-007 | [FR-MONITOR-003](FRD.md#fr-monitor-003), [FR-READY-003](FRD.md#fr-ready-003), [FR-READY-006](FRD.md#fr-ready-006) | [PRD-AC-NF-007](PRD.md#prd-ac-nf-007) | [TC-NF-007](FRD.md#tc-nf-007) — NOT_RUN |
| [PRD-NF-008](PRD.md#prd-nf-008); FRD-CL-NF-008 | Seluruh milestone/modul; FRD §9/26 | [PRD-AC-NF-008](PRD.md#prd-ac-nf-008) | [TC-NF-008](FRD.md#tc-nf-008) — NOT_RUN |
| [PRD-NF-009](PRD.md#prd-nf-009); FRD-CL-NF-009 | Seluruh manifest dan UAT; FRD §24/27 | [PRD-AC-NF-009](PRD.md#prd-ac-nf-009) | [TC-NF-009](FRD.md#tc-nf-009) — NOT_RUN |
| [PRD-NF-010](PRD.md#prd-nf-010); FRD-CL-NF-010 | Seluruh scope/gate; FRD §3/29 | [PRD-AC-NF-010](PRD.md#prd-ac-nf-010) | [TC-NF-010](FRD.md#tc-nf-010) — NOT_RUN |

### 16.4 Coverage modul dan skenario silang

Setiap modul memiliki aktor/aksi/input/output, izin, alur sukses/gagal, state, validasi, dependensi dan AC melalui record §11 serta tabel §12–22. Tidak ada klaim seluruh nilai validasi atau kebijakan sudah lengkap. Audit di bawah membedakan **tercakup dalam draf** dan **siap implementasi**.

| Modul | Jumlah FR | Jumlah AC/TC dasar | Rincian belum lengkap |
|---|---|---|---|
| AUTH | 8 | 16 | Q005, Q006, Q007, Q017; FRD-DEC-005/006/013/014 mengonfirmasi sebagian; sisa detail terbuka |
| REPORT | 12 | 24 | Q001, Q002, Q003, Q004, Q007, Q009, Q013, Q017, Q020; FRD-DEC-004/006/007/008/010/011/014 berlaku sesuai cakupan |
| KTP | 4 | 8 | Q003, Q010, Q014, Q015, Q020; FRD-DEC-010/011 untuk minimum dan penggantian; bukti kualitas/hasil usang belum ditutup |
| AI | 3 | 6 | Q009, Q013, Q018; R1/R2 detail baru belum ada |
| REVIEW | 9 | 18 | Q008, Q009, Q010, Q020; FRD-DEC-018 menetapkan konflik dua admin; formula dan race bukti/worker masih terbuka |
| CONTROL | 5 | 10 | Q001, Q002, Q008, Q010, Q020; FRD-DEC-004/007/008/016/018 menetapkan kuota dasar/perubahan, galeri dan konflik dua admin; sisa terbuka |
| MONITOR | 3 | 6 | Q008, Q009, Q017; R1/R2 detail baru belum ada |
| VAULT | 4 | 8 | Q003, Q005, Q010, Q015, Q017, Q020; dampak KTP/logout dari FRD-DEC-010/011/014; format/consent/retensi belum ditutup |
| FAMILY | 7 | 14 | Q010, Q011, Q014, Q015, Q017, Q020; R1/R2 detail baru belum ada |
| READY | 8 | 16 | Q007, Q011, Q016, Q017; FRD-DEC-006/014 menetapkan retensi/logout; kategori/konten/validasi tersisa |
| CONTENT | 1 | 2 | Q011, Q016, Q020; FRD-DEC-018 menetapkan konflik dua admin; publikasi/konten/validasi masih terbuka |
| INBOX | 4 | 8 | Q012, Q017, Q020; FRD-DEC-009/012/015 menetapkan audience/read/expiry; metadata/retensi/konflik tersisa |

Semua modul tetap DRAFT. Integrasi/notifikasi/audit yang tidak memerlukan fungsi baru mengikuti §18–20, bukan diasumsikan mendapat fitur notifikasi atau ekspor tambahan. Skenario silang: [TC-X-001](FRD.md#tc-x-001), [TC-X-002](FRD.md#tc-x-002), [TC-X-003](FRD.md#tc-x-003), [TC-X-004](FRD.md#tc-x-004), [TC-X-005](FRD.md#tc-x-005), [TC-X-006](FRD.md#tc-x-006), [TC-X-007](FRD.md#tc-x-007), [TC-X-008](FRD.md#tc-x-008), [TC-X-009](FRD.md#tc-x-009), [TC-X-010](FRD.md#tc-x-010). Seluruhnya NOT_RUN; dependensi aturan dicatat pada FRD §24.

### 16.5 Bukti tambahan dan perubahan register

- Dua ekspor lokal dibaca/dicocokkan dengan mempertahankan konteks historis. Ekspor kedua merekam sesi audit sebelumnya; tidak menambahkan keputusan produk baru.
- Pesan aktif terbaru dikutip pada [PRD-APPROVAL-01](DECISIONS.md#prd-approval-01). Tidak diklaim sudah ada pada file ekspor.
- [PRD-CHG-010](DECISIONS.md#prd-open-normalization) memetakan 14 baris agenda PRD lama ke 12 ID register dan approval yang sudah ditutup.
- FRD-CHG-001 menambahkan klaim/RTM ini tanpa menimpa 85 klaim, 43 jawaban, 43 keputusan PRD, atau riwayat BRD.

<a id="closure-audit"></a>

## 17. Audit penutupan PRD dan struktur draf FRD — snapshot historis v0.1.0

Audit ini adalah hasil pada saat penutupan PRD dan pembuatan FRD v0.1.0, sebelum jawaban FRD putaran aktif. Nilai/agenda yang disebut terbuka di sini menggambarkan saat itu. Audit v0.1.1 dicatat terpisah; pemeriksaan dokumentasi tidak menyatakan aplikasi/provider/perangkat/UAT telah lulus.

**Hasil aktual: PASS untuk cakupan pemeriksaan dokumentasi berikut, 18 Oktober 2026.** Pemeriksaan dijalankan dengan pembacaan UTF-8 dan skrip Python non-mutating terhadap lima dokumen hasil; tidak menjalankan aplikasi, API provider, Android, browser UAT, atau migrasi.

| Pemeriksaan | Hasil aktual | Batas kesimpulan |
|---|---|---|
| Baseline BRD | 42 ID BR lengkap/unik; 42 baris kebutuhan identik dengan ekspor sesi pertama | Metadata serah tahap diselaraskan; isi kebutuhan tidak diubah |
| Baseline PRD | 57 F, 10 NF, 57 AC-F dan 10 AC-NF lengkap/unik; 67 baris requirement beserta AC identik dengan ekspor pertama | Perubahan penutupan pada metadata, agenda, namespace dan audit |
| Bukti historis PRD | 43 heading Q, 85 klaim dan 43 keputusan lengkap/unik | Tidak menciptakan jawaban atau approval historis baru |
| Agenda PRD | 12 baris PRD-OPEN identik antara PRD dan DECISIONS | 14 nomor lama dipetakan; persetujuan lama 014 kini ditutup melalui PRD-APPROVAL-01 |
| Struktur FRD | 30 bagian; 68 FR unik dengan field template; 136 AC dan 156 TC unik | Ini kelengkapan artefak, bukan bukti semua keputusan detail final |
| Sumber dan RTM FRD | 57 klaim F + 10 klaim NF; 68 baris RTM FR cocok dengan sumber pada record; semua 57 F punya turunan | NF ditelusuri ke §23/TC-NF dan cakupan fungsinya; tidak menambahkan requirement sumber |
| Tautan lokal | 1185 tautan file/anchor diperiksa; **0 target hilang** | Tidak memverifikasi ulang URL web atau klaim isi referensi eksternal |
| Format | Anchor eksplisit unik; pasangan pagar blok kode utuh; tabel FRD dan tambahan traceability konsisten; tidak ada karakter pengganti UTF-8 | Bukan uji render seluruh editor/aplikasi |
| Backlog FRD | 20 ID lengkap/unik: 17 topik BLOCKER, 2 HIGH, 1 agenda SRS | NOT_ASKED; tidak diklaim sudah dijawab atau sudah ditutup |
| Status dokumen | BRD/PRD APPROVED; FRD DRAFT; sumber persetujuan eksplisit tersedia | Semua tes produk tetap NOT_RUN |

**Pemeriksaan makna lintas fitur:** batas publik/privat, KTP vs bantuan keluarga, draf vs permintaan Kirim, prioritas vs tingkat, selesai vs hapus, data backend vs lokal, dan koreksi/cabut pesan dinyatakan terpisah. Kasus negatif dan konflik terkait mempunyai rujukan FR/TC/Q. Nilai/rumus, kebijakan retensi, pemulihan tanpa kode, dan strategi concurrency masih terbuka secara eksplisit; audit ini tidak menutupnya.

**Serah hasil:** tahap 2 selesai sebagai PRD approved. Tahap 3 telah menghasilkan FRD v0.1.0 DRAFT dan agenda discovery berikutnya. Perubahan metadata BRD hanya menyelaraskan posisi tahap, mempertahankan riwayat dan kebutuhan baseline. Sumber asli/dua ekspor tetap tidak diubah; tidak ada codebase aplikasi, seed, setup, atau deployment yang dibuat pada pekerjaan ini.

<a id="frd-qa-round-1"></a>

## 18. Pertanyaan dan jawaban FRD putaran 1 — 18 Oktober 2026

Bukti berikut berasal dari pesan aktif, bukan disisipkan ke ekspor historis. Jawaban disalin dari pilihan atau teks bebas yang dikirim pengguna. R1/R2 dan interpretasi dibatasi pada [keputusan terkait](DECISIONS.md#frd-round-1); enam belas subjawaban tidak berarti enam belas agenda tertutup.

| Agenda / subpertanyaan | Pertanyaan yang diajukan | Jawaban literal | Keputusan |
|---|---|---|---|
| Q001-A | FRD-Q001 — Untuk demo, saya mengusulkan kuota awal 3 laporan yang berhasil diterima per akun dalam 6 jam terakhir. Kiriman gagal dan retry laporan yang sama tidak dihitung lagi; admin tetap dapat mengubah aturan atau mereset kuota. Nilai awal mana yang Anda pilih? | “3 laporan / 6 jam (disarankan)” | [FRD-DEC-004](DECISIONS.md#frd-dec-004) |
| Q006-A | FRD-Q006 — Jika pengguna kehilangan sandi sekaligus kode pemulihan, saya mengusulkan akun tidak dapat dipulihkan melalui aplikasi; pengguna harus membuat akun baru dan tidak otomatis mendapat data akun lama. Ini menghindari jalur admin membuka akun privat. Pilih kebijakannya. | “Tidak ada pemulihan tanpa kode (disarankan)” | [FRD-DEC-005](DECISIONS.md#frd-dec-005) |
| Q007-A | FRD-Q007 — Saat logout, saya mengusulkan draf, checklist, dan kontak pribadi tetap tersimpan terpisah di perangkat agar tersedia ketika akun yang sama login kembali; akun lain tidak dapat membukanya. Pilih perilaku logout. | “Pertahankan data lokal per akun (disarankan)” | [FRD-DEC-006](DECISIONS.md#frd-dec-006) |
| Q001-B | FRD-Q001 — Jika admin menghapus laporan yang sudah diterima, saya sarankan kuota laporan itu tetap terpakai sampai keluar dari jendela 6 jam, kecuali admin mereset kuota. Penghapusan isi dan reset kuota menjadi dua tindakan berbeda. Pilih kebijakannya. | “Hapus tidak mengembalikan kuota (disarankan)” | [FRD-DEC-007](DECISIONS.md#frd-dec-007) |
| Q002-A | FRD-Q002 — Jika warga menyimpan draf dari galeri, lalu admin mematikan galeri sebelum laporan diterima, saya sarankan kirim ditahan dan warga diminta mengganti media dengan kamera. Draf tetap disimpan. Pilih aturan untuk draf lama. | “Ikuti aturan galeri saat kirim (disarankan)” | [FRD-DEC-008](DECISIONS.md#frd-dec-008) |
| Q012-A | FRD-Q012 — Untuk warga yang baru mendaftar, saya sarankan inbox menampilkan seluruh pesan admin yang masih berlaku, termasuk yang terbit sebelum akun dibuat. Pesan kedaluwarsa atau dicabut tidak dianggap aktif. Pilih cakupan inbox akun baru. | “Semua pesan yang masih berlaku (disarankan)” | [FRD-DEC-009](DECISIONS.md#frd-dec-009) |
| Q003-A | FRD-Q003 — Untuk lolos pemeriksaan keterbacaan KTP, saya mengusulkan dokumen jelas dikenali sebagai KTP dan nama pemilik terbaca, lalu pemilik mengonfirmasi dokumennya. Ini tetap bukan verifikasi identitas resmi dan admin tidak membaca isinya. Apakah NIK juga wajib terbaca? | “Jenis KTP dan nama terbaca (disarankan)” | [FRD-DEC-010](DECISIONS.md#frd-dec-010) |
| Q003-B | FRD-Q003 — Saat pengguna mengganti KTP yang sudah memenuhi syarat, saya mengusulkan KTP lama tetap berlaku sampai penggantinya lolos dan dikonfirmasi. Jika KTP lama dihapus, kirim langsung tertahan sampai syarat terpenuhi lagi. Pilih perilaku penggantian. | “Lama berlaku sampai pengganti lolos (disarankan)” | [FRD-DEC-011](DECISIONS.md#frd-dec-011) |
| Q012-B | FRD-Q012 — Setelah admin mengubah judul atau isi pesan, saya mengusulkan pesan tampil sebagai diperbarui dan kembali belum dibaca untuk setiap warga. Membaca versi lama saat offline tidak menandai versi baru sudah dibaca. Pilih aturan penanda baca. | “Revisi isi kembali belum dibaca (disarankan)” | [FRD-DEC-012](DECISIONS.md#frd-dec-012) |
| Q006-B | FRD-Q006 — Untuk kode pemulihan, saya mengusulkan kode sekali pakai: pemulihan yang berhasil mengganti sandi, mencabut sesi lama, lalu memberi kode pengganti. Jika respons terputus, pengguna tetap bisa login memakai sandi baru dan membuat kode pengganti dari sesi tersebut. Pilih aturan kode. | “Sekali pakai, lalu ganti kode (disarankan)” | [FRD-DEC-013](DECISIONS.md#frd-dec-013) |
| Q007-B | FRD-Q007 — Saat logout, saya mengusulkan pengiriman tertunda di perangkat berhenti sampai akun yang sama login kembali. Pekerjaan yang sudah diterima server boleh selesai untuk akun asal; cache pratinjau dokumen dan sesi dibersihkan, sedangkan draf/checklist/kontak tetap disimpan sesuai pilihan Anda. Pilih perilakunya. | “Hentikan antrean lokal, lanjutkan server (disarankan)” | [FRD-DEC-014](DECISIONS.md#frd-dec-014) |
| Q012-C | FRD-Q012 — Untuk masa berlaku pesan admin, saya mengusulkan tanggal akhir bersifat opsional: tanpa tanggal akhir pesan aktif sampai dicabut; jika berakhir atau dicabut, pesan keluar dari inbox warga. Admin tetap dapat melihat catatan pesannya. Pilih kebijakannya. | “Tanggal akhir opsional (disarankan)” | [FRD-DEC-015](DECISIONS.md#frd-dec-015) |
| Q001-C | FRD-Q001 — Jika admin mengubah batas kuota, saya mengusulkan aturan baru langsung dipakai untuk kiriman baru tanpa mereset pemakaian. Contoh: batas diturunkan dari 3 menjadi 2 ketika akun sudah mengirim 3 laporan; laporan lama tetap, tetapi kiriman baru tertahan sampai pemakaian turun atau admin melakukan reset terpisah. Pilih perilakunya. | “Ubah aturan tanpa reset pemakaian (disarankan)” | [FRD-DEC-016](DECISIONS.md#frd-dec-016) |
| Q002-B | FRD-Q002 — Jika Kirim terputus dan belum diketahui apakah server sudah menerima, saya mengusulkan isi permintaan dikunci sementara sampai statusnya diperiksa. Jika sudah diterima, tampilkan laporan yang sama; jika ditolak sebelum diterima, draf boleh diperbaiki. Ini mencegah dua isi berbeda masuk sebagai laporan ganda. Pilih perilakunya. | “Periksa status sebelum boleh edit (disarankan)” | [FRD-DEC-017](DECISIONS.md#frd-dec-017) |
| Q020-A | FRD-Q020 — Jika dua admin mengubah objek yang sama dari versi lama, saya mengusulkan perubahan pertama yang berhasil disimpan berlaku; admin kedua mendapat pesan konflik dan harus memuat ulang sebelum mengubah lagi. Pilih aturan konflik. | “Tolak perubahan usang, muat ulang (disarankan)” | [FRD-DEC-018](DECISIONS.md#frd-dec-018) |
| Q004-A | FRD-Q004 — Untuk menyiapkan pengujian GPS/mock location, status developer, TTS, dan APK demo, perangkat apa yang bisa dipakai tim? Sebutkan model HP + versi Android, serta browser untuk admin web. Jika belum diketahui atau belum tersedia, tuliskan itu; saya akan mencatatnya sebagai kebutuhan uji yang belum tersedia. | “SAYA AKAN MENCATATNYA SEBAGAI KEBUTUHAN UJI YANG BELUM TERSEDIA” | [FRD-DEC-019](DECISIONS.md#frd-dec-019) |

### 18.1 Dampak pada requirement dan skenario

| Keputusan | FR / skenario yang dipertajam | Batas yang masih terbuka |
|---|---|---|
| 004/007/016 | CONTROL-002/003/004; REPORT-010; TC-CONTROL-002-01; TC-X-001 | Boundary tepat H, rentang dan reset bersamaan; perubahan aturan tidak reset sudah dipilih |
| 008/017 | CONTROL-001; REPORT-007/008/009/010; TC-CONTROL-001-02; TC-X-001/002 | Kontrak revisi lama, timeout dan pembatalan; edit ditahan sampai status jelas sudah dipilih |
| 010/011 | KTP-002/003/004; TC-KTP-002-01/02; TC-KTP-003-01 | Format/kualitas, sumber/konfirmasi usang, berkas lama |
| 005/013 | AUTH-005/006; TC-AUTH-006-01/02 | Format/percobaan kode, validasi sandi, autentikasi ulang |
| 006/014 | AUTH-008; REPORT-007/008; READY-005; TC-AUTH-008-01; TC-X-003 | Pencabutan server saat offline, perlindungan storage, callback/rekonsiliasi |
| 009/012/015 | INBOX-001–004; TC-INBOX-001-01; TC-INBOX-002-01; TC-X-009 | Validasi, perubahan metadata/tanggal akhir, konflik edit, retensi catatan |
| 018 | REVIEW/CONTROL/CONTENT/INBOX; TC-REVIEW-009-02 dan kasus konflik dua admin pada FRD §30.8 | Pilihan mekanisme SRS dan race terhadap worker/bukti baru/keluarga masih terbuka |
| 019 | Q004/Q019; uji perangkat/build dan TTS | Inventaris perangkat/browser belum tersedia; test tetap NOT_RUN, bukan kegagalan test yang sudah dijalankan |

Semua AC/TC tetap NOT_RUN; pemetaan di atas merinci RTM §16 dengan ID yang sama. Temuan bug pada test aktual belum dapat disimpulkan dari audit dokumen.

<a id="frd-research-1"></a>

## 19. Riset primer dan inventaris FRD — 18 Oktober 2026

Metode: membaca dokumentasi resmi melalui web dan melakukan inventaris lokal read-only. **RESEARCH_SUPPORTED** berarti dukungan dari dokumentasi, bukan konfirmasi pengguna, ketersediaan akun, kualitas data atau hasil test aplikasi. Temuan ini tidak mengganti catatan riset historis.

| ID | Sumber primer yang diperiksa | Temuan dan inferensi yang dibatasi | Dampak / status pembuktian |
|---|---|---|---|
| FRD-RES-001 | [DeepSeek Vision](https://api-docs.deepseek.com/guides/vision/) | Dokumentasi mencantumkan masukan gambar pada deepseek-flash, format JPEG/PNG/GIF/WebP dan base64. Pemakaian sebagai kandidat PoC adalah inferensi rancangan; bukan bukti akun/kualitas tersedia. | Q013/014; RESEARCH_SUPPORTED, POC_NOT_RUN. Model/endpoint aktual, batas/biaya dan kualitas perlu dicatat saat PoC. |
| FRD-RES-002 | [DeepSeek JSON Output](https://api-docs.deepseek.com/guides/json_mode/) | Panduan memperingatkan kemungkinan keluaran kosong. Rancangan harus menangani kosong/invalid dan memvalidasi makna field; mode JSON sendiri tidak membuktikan hasil benar. | Q013/014/020; RESEARCH_SUPPORTED; pengujian kegagalan NOT_RUN. |
| FRD-RES-003 | [Android Settings.Global — DEVELOPMENT_SETTINGS_ENABLED](https://developer.android.com/reference/android/provider/Settings.Global#DEVELOPMENT_SETTINGS_ENABLED) | Dokumentasi menyatakan aplikasi pihak ketiga selalu memperoleh 0. Inferensi: nilai itu saja tidak membuktikan developer mode mati; unknown tetap diperlukan menurut baseline. | Q004; RESEARCH_SUPPORTED, DEVICE_TEST_NOT_RUN; tidak memilih plugin atau menjanjikan deteksi universal. |
| FRD-RES-004 | [Android Location — isMock](https://developer.android.com/reference/android/location/Location#isMock()) | API mengenali lokasi yang ditandai mock dan tersedia mulai API 31; jalur versi lebih lama berbeda. Tidak membuktikan semua manipulasi dapat dideteksi atau titik manual menunjukkan keberadaan pelapor. | Q004; RESEARCH_SUPPORTED, DEVICE_TEST_NOT_RUN; perlu uji perangkat/build aktual. |
| FRD-RES-005 | [Android Voice — isNetworkConnectionRequired](https://developer.android.com/reference/android/speech/tts/Voice#isNetworkConnectionRequired()) | Informasi kebutuhan jaringan tersedia per voice. Inferensi: harus memeriksa voice/bahasa terpasang dan fallback teks; bukan jaminan TTS Indonesia offline universal. | Q016; RESEARCH_SUPPORTED, TTS_TEST_NOT_RUN. |

### 19.1 Inventaris alat lokal

| ID bukti | Pemeriksaan read-only | Hasil teramati | Batas |
|---|---|---|---|
| FRD-ENV-001 | Get-Command dan --version | Node v24.15.0; ffprobe 9.0.2 tersedia | Tidak mengesahkan versi runtime SRS atau bukti video pipeline sudah berjalan |
| FRD-ENV-002 | Resolusi perintah proses saat ini | flutter, dart, adb tidak ditemukan pada PATH | Bukan bukti SDK tidak terpasang di folder lain/laptop tim; belum mengidentifikasi perangkat uji |

Belum ada build, provider call, pemeriksaan kredensial atau pemrosesan dokumen privat pada putaran ini. [FRD §30.9](FRD.md#frd-detail-09) menyiapkan protokol PoC media, KTP, keluarga, perangkat dan TTS menggunakan input sintetis. Fixture, provider nyata dan UAT harus mempunyai bukti terpisah. Pemilihan implementasi/framework/SQL tetap tahap SRS.

<a id="frd-audit-v011"></a>

## 20. Audit konsolidasi FRD v0.1.1

**Hasil aktual: PASS pada konsolidasi 16 jawaban dan pencatatan 3 pertanyaan lanjutan, 18 Oktober 2026.** Pemeriksaan UTF-8 dan skrip Python non-mutating terhadap tujuh dokumen menghasilkan hasil berikut. Seluruh pengujian aplikasi/provider/perangkat/UAT tetap NOT_RUN.

| Pemeriksaan | Hasil aktual | Batas |
|---|---|---|
| Baseline BRD/PRD | 42 baris BR dan 67 baris requirement/AC PRD identik dengan ekspor pertama | Metadata/agenda boleh mencatat perkembangan FRD tanpa mengubah baseline kebutuhan |
| Bukti historis PRD | 43 Q, 85 klaim, 43 keputusan lengkap/unik | Tidak menciptakan jawaban historis baru |
| Struktur FRD/RTM | 30 bagian, 68 FR, 136 AC, 156 ID TC; 57 klaim F + 10 NF; sumber record cocok dengan RTM | Kelengkapan ID bukan kelulusan aplikasi atau semua detail final |
| Keputusan aktif | 16 jawaban literal cocok antara DECISIONS dan TRACEABILITY; 15 keputusan produk + 1 status bukti perangkat | Tujuh agenda parsial; Q004 bukti belum tersedia; sisanya masih discovery |
| Agenda PRD | 12 baris PRD-OPEN identik antara PRD dan DECISIONS | Perincian yang diputuskan disebut tanpa menutup subdetail lain |
| Tautan lokal | 1.227 tautan file/anchor diperiksa; 0 target hilang pada snapshot akhir | Tidak menguji URL web atau klaim provider/perangkat |
| Format dan status | Anchor eksplisit unik; tabel tambahan/pagar kode/UTF-8 konsisten; BRD/PRD approved dan FRD draft | Rencana uji tetap NOT_RUN; audit ini bukan sign-off FRD |

Pemeriksaan semantik juga menyelaraskan kuota dengan penghapusan/ubah aturan, penggantian KTP, recovery respons hilang, isolasi logout, read versi pesan, serta konflik dua admin. Sisa proposal tetap diberi label dan dirujuk ke Q terkait. Catatan kelanjutan menyimpan path arahan asli agar sesi dapat diteruskan setelah terpotong.

<a id="frd-wave-2"></a>

## 21. Pertanyaan lanjutan — kelompok, tingkat dan penghapusan

**Status terkini: ANSWERED_R1 untuk ketiga subpertanyaan.** Pertanyaan asli di bawah dipertahankan sebagai riwayat. Setelah sesi dilanjutkan, pemilik menjawab contoh konkret dari tiga pilihan yang sama; jawaban dan kata-kata pertanyaan sesi aktif dicatat pada [putaran 2](#frd-qa-round-2). Q008/009/010 tetap PARTIALLY_CONFIRMED untuk agenda besarnya. Keputusan berlaku pada FRD §30.11.

### FRD-Q008-A

- **Pertanyaan:** FRD-Q008 — Untuk pengelompokan laporan, saya mengusulkan batas jarak dan waktu antar laporan serta batas bentang seluruh kelompok. Jadi, A dekat B dan B dekat C tidak otomatis menggabungkan semuanya bila A–C sudah melampaui batas kelompok. Laporan tetap tersimpan dan admin dapat mengoreksi kelompok. Pilih aturan dasarnya; angka jarak/waktu akan dibahas terpisah.
- **Jawaban literal pada sesi kelanjutan:** “Ya, batasi bentang seluruh kelompok (disarankan)”; [FRD-DEC-020](DECISIONS.md#frd-dec-020).
- **Status konfirmasi:** CONFIRMED_R1 untuk subpertanyaan ini; agenda induk PARTIALLY_CONFIRMED. Riwayat status sebelum jawaban: ASKED_PENDING.
- **Dampak:** agenda Q008 pada FRD dan keputusan FRD §30.11.

### FRD-Q009-A

- **Pertanyaan:** FRD-Q009 — Untuk tingkat rendah/sedang/tinggi di Pantau, saya mengusulkan memakai tingkat tertinggi dari bukti yang layak dipakai dalam kelompok. Bukti tidak sesuai yang belum ditinjau tidak ikut dihitung; tanpa bukti layak tampil Belum dinilai. Jadi, satu bukti layak bertingkat tinggi tidak diturunkan oleh banyak bukti rendah. Pilih aturan agregasinya.
- **Jawaban literal pada sesi kelanjutan:** “Tinggi, gunakan tingkat tertinggi (disarankan)”; [FRD-DEC-021](DECISIONS.md#frd-dec-021).
- **Status konfirmasi:** CONFIRMED_R1 untuk subpertanyaan ini; agenda induk PARTIALLY_CONFIRMED. Riwayat status sebelum jawaban: ASKED_PENDING.
- **Dampak:** agenda Q009 pada FRD dan keputusan FRD §30.11.

### FRD-Q010-A

- **Pertanyaan:** FRD-Q010 — Setelah admin menghapus laporan beserta medianya, saya mengusulkan riwayat pelapor menyisakan penanda “Laporan dihapus admin” dan waktu penghapusan. Isi, foto/video, dan hasil analisisnya tidak dapat dibuka; penanda itu menjelaskan mengapa laporan hilang. Pilih tampilan riwayatnya.
- **Jawaban literal pada sesi kelanjutan:** “Penanda “Laporan dihapus admin” dan waktu hapus (disarankan)”; [FRD-DEC-022](DECISIONS.md#frd-dec-022).
- **Status konfirmasi:** CONFIRMED_R1 untuk subpertanyaan ini; agenda induk PARTIALLY_CONFIRMED. Riwayat status sebelum jawaban: ASKED_PENDING.
- **Dampak:** agenda Q010 pada FRD dan keputusan FRD §30.11.

<a id="frd-qa-round-2"></a>

## 22. Jawaban sesi kelanjutan dan pemulihan sumber — 18 Oktober 2026

Ekspor sesi 3 (arsip lokal) memuat 22 pesan User, termasuk 16 jawaban FRD putaran 1 dan permintaan terakhir menyatukan FRD. Pemulihan ini tidak mengklaim mengembalikan output tool yang sudah terpotong dalam ekspor. Sumber mentah tidak diedit. Status snapshot historis §17/20 dipertahankan; metadata status terkini mengacu v0.1.2.

| Agenda / subpertanyaan | Pertanyaan yang diajukan pada sesi kelanjutan | Jawaban literal | Keputusan |
|---|---|---|---|
| Q008-A | Melanjutkan Q008 yang tertunda: jika A dekat B dan B dekat C, tetapi A terlalu jauh dari C, apakah sistem perlu memisahkan kelompok agar cakupannya tidak melebar? Angka jarak/waktu dibahas setelah aturan ini dipilih. | “Ya, batasi bentang seluruh kelompok (disarankan)” | [FRD-DEC-020](DECISIONS.md#frd-dec-020) |
| Q009-A | Melanjutkan Q009 yang tertunda: jika satu kelompok memiliki satu bukti layak bertingkat tinggi dan empat bukti layak bertingkat rendah, tingkat apa yang tampil di Pantau? Bukti yang tidak layak tidak dihitung; tanpa bukti layak tampil Belum dinilai. | “Tinggi, gunakan tingkat tertinggi (disarankan)” | [FRD-DEC-021](DECISIONS.md#frd-dec-021) |
| Q010-A | Melanjutkan Q010 yang tertunda: setelah admin menghapus laporan beserta media dan analisisnya, apa yang terlihat dalam riwayat pemilik? Pilihan ini diperlukan untuk menuntaskan perilaku penghapusan di FRD. | “Penanda “Laporan dihapus admin” dan waktu hapus (disarankan)” | [FRD-DEC-022](DECISIONS.md#frd-dec-022) |

Dampak: FR/AC terkait dan RULE-025–027 di FRD diperbarui; agregat memakai bukti layak yang masih ada, penanda penghapusan tetap privat dan bukan sumber penilaian. Aturan angka/rubrik/retensi tidak disimpulkan dari pilihan dasar ini. Ringkasan 19 jawaban: 18 kebijakan produk + 1 ketersediaan bukti; 10 agenda parsial, 1 ANSWERED_EVIDENCE_UNAVAILABLE dan 9 NOT_ASKED.

<a id="frd-qa-round-3"></a>

## 23. Rincian pengelompokan — 18 Oktober 2026

**Status: ANSWERED_R1** untuk Q008-B/C/D. Semua pertanyaan berikut dikirim melalui async dan dijawab eksplisit pada sesi aktif; tidak ada jawaban yang ditambahkan ke ekspor historis.

| Agenda / subpertanyaan | Pertanyaan yang diajukan | Jawaban literal | Keputusan |
|---|---|---|---|
| Q008-B | Q008-B — Untuk demo, apakah memakai kandidat angka dari paket lama: jarak antar tetangga ≤1.500 m dan selisih waktu ≤6 jam, dengan bentang seluruh kelompok ≤3.000 m dan rentang waktu ≤12 jam? Tepat batas boleh masuk jika syarat lain terpenuhi. Angka ini usulan konfigurasi demo, belum terbukti sebagai batas kejadian banjir yang akurat. | “Gunakan 1.500 m / 3.000 m dan 6 / 12 jam untuk demo (disarankan)” | [FRD-DEC-023](DECISIONS.md#frd-dec-023) |
| Q008-C | Q008-C — Laporan kejadian pukul 08.00 baru diterima server pukul 13.00. Saya mengusulkan pengelompokan memakai waktu kejadian 08.00 jika diisi valid; jika kosong, memakai waktu penerimaan server. Kuota tetap memakai waktu penerimaan 13.00. Pilih dasar waktu pengelompokan. | “Waktu kejadian; jika kosong gunakan waktu penerimaan (disarankan)” | [FRD-DEC-024](DECISIONS.md#frd-dec-024) |
| Q008-D | Q008-D — Kelompok kejadian 08.00–10.00 sudah ditandai selesai. Pukul 15.00 masuk laporan dengan waktu kejadian 09.00 yang memenuhi batas lokasi. Saya mengusulkan laporan itu masuk kelompok selesai, menambah riwayat tanpa membuka kembali Pantau; admin dapat mengoreksi kelompoknya. Pilih perlakuan laporan terlambat ini. | “Masukkan ke kelompok selesai tanpa membuka kembali (disarankan)” | [FRD-DEC-025](DECISIONS.md#frd-dec-025) |

Dampak dan batas: lihat FRD-CHG-005. Parameter historis kini menjadi keputusan karena jawaban eksplisit FRD-DEC-023, bukan karena disalin dari sumber. Waktu pengelompokan dan kuota berbeda sesuai FRD-DEC-024. Waktu tidak diketahui tidak diberi tanggal kejadian rekaan. Q008 belum ditutup penuh.

<a id="frd-qa-round-4"></a>

## 24. Pemilihan kandidat, nama lokasi dan koreksi manual

**Status: ANSWERED_R1.** Ketiga pertanyaan diajukan melalui async setelah usulan konkret tersedia di FRD §30.13, lalu dijawab pada sesi aktif.

| Agenda / subpertanyaan | Pertanyaan yang diajukan | Jawaban literal | Keputusan |
|---|---|---|---|
| Q008-E | Q008-E — Bila beberapa kelompok memenuhi batas, saya mengusulkan memilih kelompok dengan anggota terdekat; jika jaraknya sama, pilih kelompok yang dibuat lebih dahulu, lalu pengenal internal sebagai pemutus seri. Laporan terlambat yang sesuai aturan sebelumnya tetap mendahulukan kelompok selesai. Satu laporan tidak otomatis menggabungkan beberapa kelompok. Pilih aturan pemilihannya. | “Anggota terdekat, lalu kelompok paling awal (disarankan)” | [FRD-DEC-026](DECISIONS.md#frd-dec-026) |
| Q008-F | Q008-F — Untuk nama lokasi di Pantau, saya mengusulkan memakai nama wilayah dari titik laporan paling awal yang masih ada dalam kelompok. Jika nama wilayah tidak tersedia, gunakan “Lokasi laporan” beserta kode kelompok, tanpa identitas warga atau koordinat presisi. Pilih penamaannya. | “Nama wilayah jika tersedia; label dan kode sebagai cadangan (disarankan)” | [FRD-DEC-027](DECISIONS.md#frd-dec-027) |
| Q008-G | Q008-G — Jika admin mengetahui dua laporan sebenarnya terkait tetapi perpindahannya melampaui batas kelompok otomatis, apakah koreksi manual tetap boleh? Saya mengusulkan boleh dengan alasan wajib dan jejak audit; kedua kelompok dihitung ulang, dan proses otomatis tidak diam-diam membatalkan koreksi itu. | “Boleh melampaui batas, wajib alasan dan audit (disarankan)” | [FRD-DEC-028](DECISIONS.md#frd-dec-028) |

Pemetaan dampak mengikuti FRD-CHG-006: RULE-029–031, FR-REVIEW-001/004/008 dan FR-MONITOR-001 beserta AC/TC terkait. Q008 FUNCTION_CONFIRMED untuk kontrak fungsi; seluruh pengujian NOT_RUN, FRD tetap DRAFT.

<a id="frd-level-questions"></a>

## 25. Pertanyaan penilaian dan prioritas review — 18 Oktober 2026

**Status: ANSWERED_R1.** Ketiganya diajukan melalui async setelah proposal tersedia pada FRD §30.14 dan telah dijawab pada sesi aktif. Q009 tetap PARTIALLY_CONFIRMED karena batas tingkat rinci dan awal waktu tunggu/refresh/catatan belum dipilih.

### FRD-Q009-B

- **Pertanyaan:** Q009-B — Agregasi tingkat tertinggi sudah dipilih. Untuk menentukan tingkat tiap bukti pada demo, saya mengusulkan dasar dampak yang dapat ditunjukkan bukti/keterangan, seperti genangan, gangguan akses/bangunan, dan orang membutuhkan bantuan. Jika informasinya tidak cukup, tetap Belum dinilai. Pilih dasar rubriknya; batas Rendah/Sedang/Tinggi akan dirinci sesudahnya.
- **Jawaban literal:** “Dampak yang ditunjukkan bukti/keterangan (disarankan)”; [FRD-DEC-029](DECISIONS.md#frd-dec-029).
- **Status:** CONFIRMED_R1 untuk subpertanyaan ini; agenda Q009 tetap PARTIALLY_CONFIRMED.
- **Dampak:** [FRD §30.14](FRD.md#frd-level-next); AI/REVIEW/MONITOR.

### FRD-Q009-C

- **Pertanyaan:** Q009-C — Jika AI menilai bukti tidak cocok, apakah admin boleh membuatnya layak dihitung setelah meninjau? Saya mengusulkan boleh hanya jika admin menyatakan relevan, menetapkan tingkat, dan mencatat alasan. Membuka laporan atau memberi catatan biasa saja tidak mengubah kelayakan.
- **Jawaban literal:** “Boleh setelah penetapan relevansi, tingkat, dan alasan (disarankan)”; [FRD-DEC-030](DECISIONS.md#frd-dec-030).
- **Status:** CONFIRMED_R1 untuk subpertanyaan ini; agenda Q009 tetap PARTIALLY_CONFIRMED.
- **Dampak:** [FRD §30.14](FRD.md#frd-level-next); AI/REVIEW/MONITOR.

### FRD-Q009-D

- **Pertanyaan:** Q009-D — Untuk urutan review admin, saya mengusulkan antrean yang sudah dinilai diurutkan Tinggi → Sedang → Rendah, lalu yang paling lama menunggu; jika seri gunakan pengenal stabil. Belum dinilai memiliki antrean tersendiri, juga yang paling lama menunggu di atas. Pilih aturan urutannya.
- **Jawaban literal:** “Tingkat lalu waktu tunggu; Belum dinilai terpisah (disarankan)”; [FRD-DEC-031](DECISIONS.md#frd-dec-031).
- **Status:** CONFIRMED_R1 untuk subpertanyaan ini; agenda Q009 tetap PARTIALLY_CONFIRMED.
- **Dampak:** [FRD §30.14](FRD.md#frd-level-next); AI/REVIEW/MONITOR.

### 25.1 Pemetaan jawaban literal

| Agenda / subpertanyaan | Pertanyaan yang diajukan | Jawaban literal | Keputusan |
|---|---|---|---|
| Q009-B | Q009-B — Agregasi tingkat tertinggi sudah dipilih. Untuk menentukan tingkat tiap bukti pada demo, saya mengusulkan dasar dampak yang dapat ditunjukkan bukti/keterangan, seperti genangan, gangguan akses/bangunan, dan orang membutuhkan bantuan. Jika informasinya tidak cukup, tetap Belum dinilai. Pilih dasar rubriknya; batas Rendah/Sedang/Tinggi akan dirinci sesudahnya. | “Dampak yang ditunjukkan bukti/keterangan (disarankan)” | [FRD-DEC-029](DECISIONS.md#frd-dec-029) |
| Q009-C | Q009-C — Jika AI menilai bukti tidak cocok, apakah admin boleh membuatnya layak dihitung setelah meninjau? Saya mengusulkan boleh hanya jika admin menyatakan relevan, menetapkan tingkat, dan mencatat alasan. Membuka laporan atau memberi catatan biasa saja tidak mengubah kelayakan. | “Boleh setelah penetapan relevansi, tingkat, dan alasan (disarankan)” | [FRD-DEC-030](DECISIONS.md#frd-dec-030) |
| Q009-D | Q009-D — Untuk urutan review admin, saya mengusulkan antrean yang sudah dinilai diurutkan Tinggi → Sedang → Rendah, lalu yang paling lama menunggu; jika seri gunakan pengenal stabil. Belum dinilai memiliki antrean tersendiri, juga yang paling lama menunggu di atas. Pilih aturan urutannya. | “Tingkat lalu waktu tunggu; Belum dinilai terpisah (disarankan)” | [FRD-DEC-031](DECISIONS.md#frd-dec-031) |

<a id="frd-rubric-question"></a>

## 26. Rubrik rinci — kelanjutan sesi 4

### FRD-Q009-E

- **Riwayat penyampaian:** Pada akhir pengerjaan sesi 4, pertanyaan penutup disiapkan dalam register, tetapi ekspor tidak memuat respons penutup itu. Klaim lama “ASKED_PENDING melalui respons penutup” diperbaiki berdasarkan pemeriksaan ekspor. Pertanyaan benar-benar diajukan melalui async pada sesi kelanjutan dan dijawab eksplisit.
- **Pertanyaan:** Q009-E — Untuk demo SiagaBanjir, apakah rubrik berikut sesuai: Rendah = genangan lokal dengan informasi dampak yang cukup; Sedang = air masuk bangunan atau akses terganggu; Tinggi = orang terjebak atau membutuhkan pertolongan/evakuasi. Semua harus didukung bukti/keterangan; jika informasinya tidak cukup tetap Belum dinilai. Bila beberapa indikator didukung, gunakan tingkat tertinggi. Ini klasifikasi laporan untuk demo, bukan status bahaya resmi.
- **Pilihan:** gunakan rubrik; ubah dengan penjelasan; belum diputuskan.
- **Jawaban literal:** “Gunakan rubrik tersebut untuk demo (disarankan)”.
- **Status:** CONFIRMED_R1; [FRD-DEC-032](DECISIONS.md#frd-dec-032). Batas informasi cukup, beberapa indikator dan bukan status resmi tercakup dalam pertanyaan. Tidak mengklaim putaran R2 terpisah atau bukti akurasi AI.
- **Dampak:** [FRD §30.15](FRD.md#frd-impact-rubric-proposal), RULE-035, AI/REVIEW/MONITOR dan skenario terkait. Q009 tetap PARTIALLY_CONFIRMED untuk review/waktu tunggu/refresh/catatan.

| Agenda / subpertanyaan | Pertanyaan yang diajukan | Jawaban literal | Keputusan |
|---|---|---|---|
| Q009-E | Q009-E — Untuk demo SiagaBanjir, apakah rubrik berikut sesuai: Rendah = genangan lokal dengan informasi dampak yang cukup; Sedang = air masuk bangunan atau akses terganggu; Tinggi = orang terjebak atau membutuhkan pertolongan/evakuasi. Semua harus didukung bukti/keterangan; jika informasinya tidak cukup tetap Belum dinilai. Bila beberapa indikator didukung, gunakan tingkat tertinggi. Ini klasifikasi laporan untuk demo, bukan status bahaya resmi. | “Gunakan rubrik tersebut untuk demo (disarankan)” | [FRD-DEC-032](DECISIONS.md#frd-dec-032) |

<a id="frd-audit-v012"></a>

## 27. Audit FRD tunggal v0.1.2 — 18 Oktober 2026

**Hasil aktual: PASS pada checkpoint v0.1.2.** Ekspor sesi 4 berakhir dengan hasil audit 1.319 tautan; pemeriksaan yang dijalankan ulang sebelum perubahan sesi kelanjutan menghasilkan angka dan status yang sama. Placeholder lama kini dilengkapi berdasarkan hasil aktual. Ini catatan historis sebelum DEC-032, bukan hasil audit v0.1.3. Pemeriksaan dokumentasi ini terpisah dari pengujian aplikasi, provider, perangkat dan UAT yang semuanya tetap NOT_RUN.

| Pemeriksaan | Hasil / batas |
|---|---|
| Integritas sumber | Hash SHA-256 BRD.md, PRD.md dan tiga ekspor sesi dibandingkan dengan snapshot sebelum perubahan; seluruh lima berkas sama byte demi byte |
| Satu FRD | Sebelas bagian berkas rincian dipindahkan ke §30.1–30.11, lalu berkas rincian dihapus; §30.12–30.15 merupakan elaborasi lanjutan dengan keputusan/usulan terpisah |
| Baseline dan ID | 42 BR, 57 F + 10 NF PRD, 68 FR, 136 AC dan 156 TC; ID FR/AC/TC identik dengan snapshot sebelumnya |
| Keterlacakan | 67 klaim sumber FRD, 68 baris RTM mencakup seluruh 57 kebutuhan fungsional PRD; 12 baris PRD-OPEN kanonis tetap identik antara PRD dan DECISIONS |
| Jawaban | 28 jawaban literal cocok antara register pertanyaan dan keputusan, FRD-DEC-004–031; 27 keputusan produk + 1 status ketersediaan bukti; tidak menghitung usulan Q009-E sebagai jawaban |
| Status agenda | Q008 FUNCTION_CONFIRMED untuk kontrak fungsi, 9 agenda parsial, 1 bukti perangkat belum tersedia, 9 agenda NOT_ASKED; dependensi lintas agenda tidak ditutup otomatis |
| Tautan dan format | 1.319 tautan lokal diperiksa dan valid; anchor eksplisit unik, tabel FRD/bagian register yang berubah konsisten, pagar kode berpasangan dan pemeriksaan karakter rusak lulus |
| Tinjauan semantik | Rantai/batas inklusif, waktu kejadian vs kuota, laporan terlambat, kandidat ganda, fallback nama, koreksi manual, agregasi tertinggi, penanda hapus, kelayakan review dan urutan admin diselaraskan dengan keputusan terkait |
| Batas hasil | Audit tidak membuktikan mutu AI, akurasi wilayah/jarak, dukungan perangkat atau penghapusan di aplikasi; rubrik rinci, retensi, validasi dan keputusan fungsi lain tetap terbuka |

Pada checkpoint historis ini FRD v0.1.2 tetap DRAFT dan Q009-E belum dijawab; jawabannya kemudian dicatat di §26. Saat checkpoint tersebut belum ada sign-off isi lengkap FRD maupun perpindahan baseline ke SRS. BRD/PRD tetap APPROVED tanpa meminta persetujuan ulang.

<a id="frd-review-lifecycle-questions"></a>

## 28. Cakupan review dan awal waktu tunggu — 18 Oktober 2026

Usulan konkret tersedia di [FRD §30.16](FRD.md#frd-review-lifecycle-proposal). Kedua pertanyaan benar-benar diajukan melalui async pada sesi kelanjutan; pilihan pada antarmuka belum merupakan jawaban sampai pengguna mengirimkannya.

### FRD-Q009-F

- **Pertanyaan:** Q009-F — Agar bukti yang belum diperiksa tidak ikut berstatus Ditinjau, saya mengusulkan admin menandai review per laporan dan versi bukti/hasil yang dilihat. Kelompok baru Ditinjau jika seluruh bukti terkini tercakup. Contoh: A sudah direview, B belum → kelompok masih perlu review. Membuka halaman atau menulis catatan saja tidak cukup; bukti yang sudah direview tetapi tidak relevan tetap tidak dihitung. Pilih cakupannya.
- **Pilihan:** review per laporan/versi; satu tindakan untuk seluruh versi kelompok yang ditampilkan; belum diputuskan.
- **Jawaban literal:** “Review per laporan/versi seperti usulan (disarankan)”; [FRD-DEC-033](DECISIONS.md#frd-dec-033).
- **Status:** CONFIRMED_R1 dengan contoh batas dalam pertanyaan; bukan eksekusi uji produk.
- **Dampak:** REVIEW-003/006/009, AI-002, penanda Pantau; konflik bersamaan Q020 terpisah.

### FRD-Q009-G

- **Pertanyaan:** Q009-G — Untuk pemutus urutan pada tingkat yang sama, apakah waktu tunggu dihitung dari kebutuhan review tertua yang masih terbuka? Contoh: A diterima server 08.00, B 09.00 → mulai 08.00; setelah A direview → 09.00. Bukti baru tidak mereset yang lama. Jika semuanya selesai lalu muncul bukti baru pukul 12.00, mulai 12.00. Hasil yang berubah setelah direview mulai menunggu saat perubahan tersimpan; waktu kejadian warga tidak dipakai untuk antrean.
- **Pilihan:** kebutuhan review tertua yang masih terbuka; selalu waktu pembuatan kelompok; belum diputuskan.
- **Jawaban literal:** “Gunakan kebutuhan review tertua yang masih terbuka (disarankan)”; [FRD-DEC-034](DECISIONS.md#frd-dec-034).
- **Status:** CONFIRMED_R1 dengan contoh batas dalam pertanyaan; bukan eksekusi uji produk.
- **Dampak:** REVIEW-002/006, RULE-034 dan skenario urutan; tidak mengubah waktu kejadian untuk pengelompokan atau waktu penerimaan untuk kuota.

| Agenda / subpertanyaan | Pertanyaan yang diajukan | Jawaban literal | Keputusan |
|---|---|---|---|
| Q009-F | Q009-F — Agar bukti yang belum diperiksa tidak ikut berstatus Ditinjau, saya mengusulkan admin menandai review per laporan dan versi bukti/hasil yang dilihat. Kelompok baru Ditinjau jika seluruh bukti terkini tercakup. Contoh: A sudah direview, B belum → kelompok masih perlu review. Membuka halaman atau menulis catatan saja tidak cukup; bukti yang sudah direview tetapi tidak relevan tetap tidak dihitung. Pilih cakupannya. | “Review per laporan/versi seperti usulan (disarankan)” | [FRD-DEC-033](DECISIONS.md#frd-dec-033) |
| Q009-G | Q009-G — Untuk pemutus urutan pada tingkat yang sama, apakah waktu tunggu dihitung dari kebutuhan review tertua yang masih terbuka? Contoh: A diterima server 08.00, B 09.00 → mulai 08.00; setelah A direview → 09.00. Bukti baru tidak mereset yang lama. Jika semuanya selesai lalu muncul bukti baru pukul 12.00, mulai 12.00. Hasil yang berubah setelah direview mulai menunggu saat perubahan tersimpan; waktu kejadian warga tidak dipakai untuk antrean. | “Gunakan kebutuhan review tertua yang masih terbuka (disarankan)” | [FRD-DEC-034](DECISIONS.md#frd-dec-034) |

<a id="frd-audit-v013"></a>

## 29. Audit kelanjutan FRD v0.1.3 — 18 Oktober 2026

**Status audit struktur: PASS.** Pemeriksaan memvalidasi 6 dokumen, 1.398 tautan lokal dan 38 jawaban literal tanpa kesalahan. Status aplikasi/provider/perangkat/UAT tetap NOT_RUN. Pemeriksaan struktur terpisah dari penerimaan isi lengkap FRD.

| Pemeriksaan | Hasil / batas |
|---|---|
| Integritas sumber | Hash BRD, PRD dan empat ekspor sesi dibandingkan dengan snapshot awal kelanjutan; seluruh 6 berkas sama byte demi byte |
| Persyaratan dan keterlacakan | 68 FR, 136 AC, 156 TC dan 68 baris RTM; identitas tetap; cakupan 57 F + 10 NF PRD tetap |
| Jawaban literal | 38 jawaban: 37 keputusan produk + 1 bukti perangkat belum tersedia; Q009-E–J dan Q010-B–E = DEC-032–041, seluruhnya mempunyai jawaban literal |
| Status agenda | Q008/Q009 FUNCTION_CONFIRMED; 8 PARTIALLY_CONFIRMED; 1 ANSWERED_EVIDENCE_UNAVAILABLE; 9 NOT_ASKED. Konfirmasi fungsi tidak memberi approval seluruh FRD |
| Tautan dan format | 1.398 tautan lokal valid; anchor eksplisit unik, tabel konsisten dan pemeriksaan karakter lulus |
| Pemeriksaan semantik | Rubrik dihubungkan ke AI/REVIEW/MONITOR, RULE-035, AC/TC dan RTM. Cakupan review, waktu tunggu, refresh dan catatan mengikuti DEC-033–037; penghapusan/akses audit/pembersihan/retensi mengikuti DEC-038–041; kasus batas diturunkan ke skenario, seluruhnya tetap NOT_RUN |
| Pemulihan jejak sesi | Placeholder audit v0.1.2 dilengkapi dari hasil aktual; klaim pertanyaan penutup diperbaiki sesuai ekspor. Pertanyaan Q009-E–J dan Q010-B–E dicatat sesuai yang benar-benar dikirim |
| Batas audit | Tidak membuktikan AI benar, aplikasi berjalan, kinerja 30 detik tercapai atau penghapusan diterapkan. FRD tetap DRAFT; belum beralih baseline ke SRS |

Hasil mesin lokal disimpan pada artefak audit (arsip lokal); skrip pemeriksa audit FRD (arsip lokal). Data pembanding permanen ada pada baseline audit (arsip lokal): hash enam sumber, ID FR/AC/TC dan hash bagian lampiran yang dipertahankan. Skrip tidak lagi memerlukan folder sementara. Nilai di artefak adalah hasil pemeriksaan terbaru dan dapat berubah setelah revisi; checkpoint v0.1.2 tetap historis di §27.

<a id="frd-refresh-notes-questions"></a>

## 30. Pembaruan tampilan dan catatan — 18 Oktober 2026

Usulan §30.17 disiapkan sebelum diajukan. Ketiga pertanyaan berikut dijawab melalui async; CONFIRMED_R1 dengan kasus batas yang disajikan. Tidak mengklaim putaran R2 terpisah atau aplikasi sudah diuji.

### FRD-Q009-H

- **Pertanyaan:** Q009-H — Untuk demo, saya mengusulkan Pantau dan antrean review diperbarui saat halaman dibuka/kembali aktif, secara manual, setelah aksi admin berhasil, dan tiap 30 detik selama halaman terlihat serta online. Jika gagal, tampilkan data terakhir beserta waktunya dan penanda gagal/offline; jangan mengosongkan daftar. Refresh tidak menimpa form yang sedang diketik; perubahan sumber diberitahukan dan konflik diperiksa saat simpan. Pilih pola pembaruan.
- **Jawaban literal:** “Gunakan pola tersebut dengan interval 30 detik (disarankan)”.
- **Status:** CONFIRMED_R1; [FRD-DEC-035](DECISIONS.md#frd-dec-035).
- **Interpretasi:** Pantau/antrean review diperbarui saat dibuka/kembali aktif, muat ulang manual, setelah aksi admin berhasil, dan tiap 30 detik selama terlihat serta online. Gagal mempertahankan data terakhir beserta waktu dan penanda gagal/offline. Form yang diketik tidak ditimpa; perubahan sumber diberitahukan dan konflik diperiksa saat simpan.
- **Dampak:** REVIEW-002/009; MONITOR-001/002; RULE-038; TC-MONITOR-002-01/02.

### FRD-Q009-I

- **Pertanyaan:** Q009-I — Agar penerima catatan tindak lanjut jelas, saya mengusulkan catatan melekat pada satu laporan dan hanya terbaca kedua admin serta pemilik laporan itu. Saat laporan dipindah kelompok, catatan tetap ikut laporan; warga lain dalam kelompok lama/baru maupun pelapor baru tidak ikut memperoleh akses. Pilih cakupan catatannya.
- **Jawaban literal:** “Catatan per laporan dengan akses tersebut (disarankan)”.
- **Status:** CONFIRMED_R1; [FRD-DEC-036](DECISIONS.md#frd-dec-036).
- **Interpretasi:** Catatan melekat pada satu laporan dan hanya terbaca kedua admin serta pemiliknya. Pindah kelompok mempertahankan catatan pada laporan; anggota kelompok lama/baru dan pelapor baru tidak memperoleh akses catatan itu.
- **Dampak:** REVIEW-005; RBAC; RULE-039; TC-REVIEW-005-01/02.

### FRD-Q009-J

- **Pertanyaan:** Q009-J — Untuk koreksi catatan tindak lanjut, saya mengusulkan catatan tersimpan tidak diedit/dihapus satu per satu. Admin menambahkan catatan koreksi yang merujuk catatan lama; pelapor melihat urutan dan waktu koreksinya. Penghapusan laporan tetap menghilangkan akses isi catatan terkait; masa simpan/audit dibahas pada agenda penghapusan. Pilih perilaku koreksi.
- **Jawaban literal:** “Tambah catatan koreksi; pertahankan riwayat (disarankan)”.
- **Status:** CONFIRMED_R1; [FRD-DEC-037](DECISIONS.md#frd-dec-037).
- **Interpretasi:** Catatan tersimpan tidak diedit/dihapus satu per satu; koreksi berupa catatan baru yang merujuk catatan lama. Pelapor/admin melihat urutan dan waktu koreksi. Hapus laporan tetap menghilangkan akses isi catatan terkait; retensi/audit dibahas Q010/015.
- **Dampak:** REVIEW-005/009; CONTROL-004; RULE-040; TC-REVIEW-005-01/02.

| Agenda / subpertanyaan | Pertanyaan yang diajukan | Jawaban literal | Keputusan |
|---|---|---|---|
| Q009-H | Q009-H — Untuk demo, saya mengusulkan Pantau dan antrean review diperbarui saat halaman dibuka/kembali aktif, secara manual, setelah aksi admin berhasil, dan tiap 30 detik selama halaman terlihat serta online. Jika gagal, tampilkan data terakhir beserta waktunya dan penanda gagal/offline; jangan mengosongkan daftar. Refresh tidak menimpa form yang sedang diketik; perubahan sumber diberitahukan dan konflik diperiksa saat simpan. Pilih pola pembaruan. | “Gunakan pola tersebut dengan interval 30 detik (disarankan)” | [FRD-DEC-035](DECISIONS.md#frd-dec-035) |
| Q009-I | Q009-I — Agar penerima catatan tindak lanjut jelas, saya mengusulkan catatan melekat pada satu laporan dan hanya terbaca kedua admin serta pemilik laporan itu. Saat laporan dipindah kelompok, catatan tetap ikut laporan; warga lain dalam kelompok lama/baru maupun pelapor baru tidak ikut memperoleh akses. Pilih cakupan catatannya. | “Catatan per laporan dengan akses tersebut (disarankan)” | [FRD-DEC-036](DECISIONS.md#frd-dec-036) |
| Q009-J | Q009-J — Untuk koreksi catatan tindak lanjut, saya mengusulkan catatan tersimpan tidak diedit/dihapus satu per satu. Admin menambahkan catatan koreksi yang merujuk catatan lama; pelapor melihat urutan dan waktu koreksinya. Penghapusan laporan tetap menghilangkan akses isi catatan terkait; masa simpan/audit dibahas pada agenda penghapusan. Pilih perilaku koreksi. | “Tambah catatan koreksi; pertahankan riwayat (disarankan)” | [FRD-DEC-037](DECISIONS.md#frd-dec-037) |

<a id="frd-delete-questions"></a>

## 31. Konfirmasi hapus, pembersihan dan audit — 18 Oktober 2026

Usulan §30.18 tersedia sebelum tiga pertanyaan diajukan melalui async. Semuanya dijawab; Q010 tetap PARTIALLY_CONFIRMED karena retensi/cadangan/cache dan detail audit lain belum dipilih. Tidak ada penghapusan data aplikasi yang dijalankan.

### FRD-Q010-B

- **Pertanyaan:** Q010-B — Sebelum admin menghapus laporan, saya mengusulkan dialog konfirmasi yang menjelaskan: isi/media/analisis/catatan tidak dapat dibuka lagi, agregat dihitung ulang, penanda dan waktu hapus tersisa, kuota tidak kembali, dan tidak ada pemulihan lewat aplikasi. Admin wajib memberi alasan singkat tanpa menyalin isi/data pribadi. Membatalkan dialog tidak mengubah data. Pilih aturan alasannya.
- **Jawaban literal:** “Konfirmasi dampak dan alasan wajib (disarankan)”.
- **Status:** CONFIRMED_R1; [FRD-DEC-038](DECISIONS.md#frd-dec-038), dengan skenario batas dalam pertanyaan. Tidak mencatat putaran R2/R3 terpisah yang belum dilakukan.
- **Interpretasi:** Konfirmasi sebelum hapus menjelaskan hilangnya akses isi/media/analisis/catatan, hitung ulang agregat, penanda/waktu hapus, tanpa refund kuota dan tanpa pemulihan aplikasi. Alasan singkat wajib tanpa menyalin isi/data pribadi; batal tidak mengubah data.
- **Dampak:** CONTROL-004; RULE-041; TC-CONTROL-004-01/02.

### FRD-Q010-C

- **Pertanyaan:** Q010-C — Jika penghapusan sudah sah tercatat tetapi satu berkas media gagal dibersihkan, saya mengusulkan akses laporan/turunannya tetap dicabut dan sumber dikeluarkan dari agregat. Pemilik melihat penanda hapus; admin melihat Pembersihan tertunda/gagal dan dapat mencoba ulang pekerjaan yang sama. Jangan nyatakan selesai penuh sebelum pembersihan aktif tuntas; hasil AI terlambat tidak memulihkan data. Pilih penanganannya.
- **Jawaban literal:** “Tetap cabut akses; retry pembersihan sampai tuntas (disarankan)”.
- **Status:** CONFIRMED_R1; [FRD-DEC-039](DECISIONS.md#frd-dec-039), dengan skenario batas dalam pertanyaan. Tidak mencatat putaran R2/R3 terpisah yang belum dilakukan.
- **Interpretasi:** Setelah penghapusan sah tercatat, akses laporan/turunan tetap dicabut dan sumber tidak dihitung meski pembersihan fisik gagal sebagian. Pemilik melihat penanda; admin melihat Pembersihan tertunda/gagal dan dapat retry pekerjaan sama. Selesai penuh hanya setelah pembersihan aktif tuntas; hasil AI terlambat tidak memulihkan sumber.
- **Dampak:** CONTROL-004/005; state penghapusan/pembersihan; RULE-042; TC-CONTROL-004-01; TC-CONTROL-005-01/02; TC-X-004.

### FRD-Q010-D

- **Pertanyaan:** Q010-D — Saya mengusulkan audit penghapusan hanya dibaca kedua admin; pemilik tetap melihat penanda dan waktu hapus. Audit berisi pengenal tindakan/laporan/admin, waktu, alasan tindakan dan hasil/status pembersihan, tanpa salinan media, deskripsi, analisis, isi catatan/dokumen, token atau koordinat presisi. Masa simpannya dibahas terpisah. Pilih pembacanya.
- **Jawaban literal:** “Audit untuk kedua admin; pemilik hanya penanda/waktu (disarankan)”.
- **Status:** CONFIRMED_R1; [FRD-DEC-040](DECISIONS.md#frd-dec-040), dengan skenario batas dalam pertanyaan. Tidak mencatat putaran R2/R3 terpisah yang belum dilakukan.
- **Interpretasi:** Audit penghapusan hanya untuk kedua admin. Field: pengenal tindakan/laporan/admin, waktu, alasan tindakan dan hasil/status pembersihan. Tidak menyalin media, deskripsi, analisis, isi catatan/dokumen, token atau koordinat presisi. Pemilik hanya penanda/waktu; retensi belum dipilih.
- **Dampak:** CONTROL-004; data/izin audit; RULE-043; TC-CONTROL-004-02.

| Agenda / subpertanyaan | Pertanyaan yang diajukan | Jawaban literal | Keputusan |
|---|---|---|---|
| Q010-B | Q010-B — Sebelum admin menghapus laporan, saya mengusulkan dialog konfirmasi yang menjelaskan: isi/media/analisis/catatan tidak dapat dibuka lagi, agregat dihitung ulang, penanda dan waktu hapus tersisa, kuota tidak kembali, dan tidak ada pemulihan lewat aplikasi. Admin wajib memberi alasan singkat tanpa menyalin isi/data pribadi. Membatalkan dialog tidak mengubah data. Pilih aturan alasannya. | “Konfirmasi dampak dan alasan wajib (disarankan)” | [FRD-DEC-038](DECISIONS.md#frd-dec-038) |
| Q010-C | Q010-C — Jika penghapusan sudah sah tercatat tetapi satu berkas media gagal dibersihkan, saya mengusulkan akses laporan/turunannya tetap dicabut dan sumber dikeluarkan dari agregat. Pemilik melihat penanda hapus; admin melihat Pembersihan tertunda/gagal dan dapat mencoba ulang pekerjaan yang sama. Jangan nyatakan selesai penuh sebelum pembersihan aktif tuntas; hasil AI terlambat tidak memulihkan data. Pilih penanganannya. | “Tetap cabut akses; retry pembersihan sampai tuntas (disarankan)” | [FRD-DEC-039](DECISIONS.md#frd-dec-039) |
| Q010-D | Q010-D — Saya mengusulkan audit penghapusan hanya dibaca kedua admin; pemilik tetap melihat penanda dan waktu hapus. Audit berisi pengenal tindakan/laporan/admin, waktu, alasan tindakan dan hasil/status pembersihan, tanpa salinan media, deskripsi, analisis, isi catatan/dokumen, token atau koordinat presisi. Masa simpannya dibahas terpisah. Pilih pembacanya. | “Audit untuk kedua admin; pemilik hanya penanda/waktu (disarankan)” | [FRD-DEC-040](DECISIONS.md#frd-dec-040) |

<a id="frd-retention-question"></a>

## 32. Retensi penanda dan audit hapus — 18 Oktober 2026

### FRD-Q010-E

- **Pertanyaan:** Q010-E — Untuk konfigurasi demo, saya mengusulkan penanda “Laporan dihapus admin” terlihat 30 hari sejak penghapusan tercatat, dan audit penghapusan disimpan 90 hari sejak tindakan dicatat. Tepat tenggat, entri tidak ditampilkan lagi. Pekerjaan pembersihan yang belum tuntas tetap dilanjutkan; kuota dan pencegahan data muncul kembali tidak direset. Durasi ini belum mencakup cadangan/provider. Pilih masa simpannya, atau tuliskan durasi lain.
- **Jawaban literal:** “Penanda 30 hari; audit 90 hari (disarankan)”.
- **Status:** CONFIRMED_R1; [FRD-DEC-041](DECISIONS.md#frd-dec-041), dengan batas tepat tenggat serta pembersihan/kuota yang disajikan.
- **Interpretasi:** Penanda riwayat terlihat 30 hari sejak penghapusan sah tercatat; audit penghapusan disimpan 90 hari sejak tindakan dicatat. Tepat tenggat entri tidak ditampilkan lagi. Kedaluwarsa tidak menghentikan pembersihan atau mereset kuota/pencegahan resurrection. Cadangan/provider tidak tercakup.
- **Dampak:** REPORT-011, CONTROL-004, RULE-044, state retensi dan skenario tepat batas. Q010 tetap PARTIALLY_CONFIRMED.

| Agenda / subpertanyaan | Pertanyaan yang diajukan | Jawaban literal | Keputusan |
|---|---|---|---|
| Q010-E | Q010-E — Untuk konfigurasi demo, saya mengusulkan penanda “Laporan dihapus admin” terlihat 30 hari sejak penghapusan tercatat, dan audit penghapusan disimpan 90 hari sejak tindakan dicatat. Tepat tenggat, entri tidak ditampilkan lagi. Pekerjaan pembersihan yang belum tuntas tetap dilanjutkan; kuota dan pencegahan data muncul kembali tidak direset. Durasi ini belum mencakup cadangan/provider. Pilih masa simpannya, atau tuliskan durasi lain. | “Penanda 30 hari; audit 90 hari (disarankan)” | [FRD-DEC-041](DECISIONS.md#frd-dec-041) |

<a id="frd-backup-retention-question"></a>

## 33. Pilihan cadangan server untuk kelanjutan

### FRD-Q010-F

- **Usulan konkret:** [FRD §30.20](FRD.md#frd-backup-retention-proposal). Jika cadangan server dibuat, masa simpan 7 hari sejak dibuat; alternatif 30 hari. Keduanya mewajibkan penerapan ulang penghapusan dan retensi sebelum layanan hasil restore dibuka. Berbeda dari fitur Dokumen warga, bukan masa simpan provider, dan bukan instruksi menjalankan backup/restore sekarang.
- **Pertanyaan yang disiapkan untuk respons berikut:** Untuk Q010-F, bila cadangan server dibuat, apakah masa simpannya 7 hari atau 30 hari sejak dibuat? Pada kedua pilihan, penghapusan terbaru harus diterapkan kembali sebelum layanan hasil pemulihan dibuka. Anda juga boleh memilih belum diputuskan.
- **Jawaban literal:** BELUM ADA.
- **Status final:** WITHDRAWN_BY_USER melalui FRD-DLG-001. Pertanyaan yang pernah disiapkan tidak diteruskan; durasi 7/30 hari tidak dipilih. Jangan mengajukannya kembali sebagai syarat FRD.
- **Dampak:** CONTROL-004/005; lifecycle cadangan dan pencegahan resurrection. Q010 tetap PARTIALLY_CONFIRMED.

<a id="frd-finalization-trace"></a>

## 34. Penutupan FRD v1.0.0 melalui mandat pemilik

Sumber terbaru adalah [FRD-DLG-001](DECISIONS.md#frd-dlg-001), dengan [FRD-APPROVAL-01](DECISIONS.md#frd-approval-01). Satu instruksi kolektif mengotorisasi pilihan standar demo dan approval; bukan konfirmasi R2/R3 atau jawaban literal per pertanyaan. 38 jawaban sebelumnya tetap dibandingkan verbatim pada audit. Q010-F ditarik tanpa memilih masa simpan backup server.

| Paket keputusan | Kebutuhan yang diperinci | Bukti verifikasi yang direncanakan |
|---|---|---|
| [FRD-STD-001](FRD.md#frd-std-001) — Batas demo dan penutupan pembahasan server | ; seluruh scope | AC/TC pada FR terkait; seluruhnya NOT_RUN |
| [FRD-STD-002](FRD.md#frd-std-002) — Validasi dan batas masukan demo | AUTH, REPORT, KTP, REVIEW, CONTROL, VAULT, FAMILY, READY, CONTENT, INBOX | AC/TC pada FR terkait; seluruhnya NOT_RUN |
| [FRD-STD-003](FRD.md#frd-std-003) — Akun, sesi dan pemulihan | AUTH | AC/TC pada FR terkait; seluruhnya NOT_RUN |
| [FRD-STD-004](FRD.md#frd-std-004) — Kuota, kirim, rekonsiliasi dan pembatalan lokal | REPORT, CONTROL | AC/TC pada FR terkait; seluruhnya NOT_RUN |
| [FRD-STD-005](FRD.md#frd-std-005) — Dokumen, KTP, logout dan cache pribadi | AUTH, REPORT, KTP, VAULT, FAMILY, READY | AC/TC pada FR terkait; seluruhnya NOT_RUN |
| [FRD-STD-006](FRD.md#frd-std-006) — Analisis, tujuan pemrosesan dan hasil sementara | KTP, AI, VAULT, FAMILY | AC/TC pada FR terkait; seluruhnya NOT_RUN |
| [FRD-STD-007](FRD.md#frd-std-007) — Keluarga, katalog tas dan progres lokal | FAMILY, READY, CONTENT | AC/TC pada FR terkait; seluruhnya NOT_RUN |
| [FRD-STD-008](FRD.md#frd-std-008) — Konten umum, daftar dan suara | REVIEW, MONITOR, READY, CONTENT | AC/TC pada FR terkait; seluruhnya NOT_RUN |
| [FRD-STD-009](FRD.md#frd-std-009) — Publikasi pesan, revisi dan akhir masa berlaku | INBOX | AC/TC pada FR terkait; seluruhnya NOT_RUN |
| [FRD-STD-010](FRD.md#frd-std-010) — Hasil konflik dan perubahan bersamaan | REPORT, KTP, AI, REVIEW, CONTROL, MONITOR, FAMILY, CONTENT, INBOX | AC/TC pada FR terkait; seluruhnya NOT_RUN |
| [FRD-STD-011](FRD.md#frd-std-011) — Lifecycle data dan audit aplikasi sederhana | REVIEW, CONTROL, VAULT | AC/TC pada FR terkait; seluruhnya NOT_RUN |
| [FRD-STD-012](FRD.md#frd-std-012) — Batas bukti, manifest demo dan masukan SRS | AI | AC/TC pada FR terkait; seluruhnya NOT_RUN |

Penutupan 20 agenda berada pada [FRD §27](FRD.md#frd-open): 15 fungsi menjadi baseline, 4 pembuktian dijadwalkan, 1 kontrak teknis dialokasikan SRS. Tidak ada pilihan fungsi yang meminta jawaban tambahan. Ketersediaan provider, inventaris perangkat dan aset aktual tidak direkayasa.

<a id="frd-audit-v100"></a>

## 35. Audit final FRD v1.0.0

**Hasil aktual: PASS, 18 Oktober 2026.** Audit dapat diulang dengan `python -X utf8 .frd_audit.py`; hasil mesin pada hasil audit (arsip lokal). Enam dokumen diperiksa: 30 bagian FRD, 68 FR, 136 AC, 156 TC, seluruh 57 sumber PRD-F dan 10 PRD-NF, serta 2.163 tautan lokal. Tidak ditemukan tautan/anchor rusak, ID hilang/ganda, ketidaksesuaian sumber FR–RTM, atau lebar tabel FRD yang tidak konsisten.

38 jawaban literal tetap sama pada kedua register dan arsip sebelum finalisasi; 12 paket standar mempunyai otoritas delegasi terpisah. Seluruh 20 agenda mempunyai disposisi final (15 fungsi, 4 bukti, 1 SRS). Hash BRD, PRD dan empat ekspor sesi tetap sama; delapan bagian discovery yang dimigrasi tetap utuh. Pemeriksaan semantik juga menyelaraskan metadata FR, aturan bisnis, status/izin, pemulihan kode pengganti, expiry inbox yang sudah diketahui saat offline, dan retry penghapusan dokumen privat oleh pemilik. **Uji aplikasi/provider/perangkat/UAT tetap NOT_RUN.**

<a id="srs-traceability"></a>

## 36. RTM SRS v1.0.0

Otoritas [SRS-DLG-001](DECISIONS.md#srs-dlg-001); baseline [SRS](SRS.md). Setiap baris APPROVED sebagai spesifikasi, seluruh test aplikasi NOT_RUN. Akhiran ID FR dipertahankan untuk hubungan asal; kontrak API/lokal dan skenario teknis memperinci hasil yang dapat diamati.

| SRS requirement | Asal FR / PRD | Kontrak | Verifikasi sumber / teknis |
|---|---|---|---|
| [SRS-FR-AUTH-001](SRS.md#srs-fr-auth-001) | [FR-AUTH-001](FRD.md#fr-auth-001); PRD-F-001 | [getMeta](SRS.md#srs-api-getmeta) | [TC-AUTH-001-01](FRD.md#tc-auth-001-01), [TC-AUTH-001-02](FRD.md#tc-auth-001-02) |
| [SRS-FR-AUTH-002](SRS.md#srs-fr-auth-002) | [FR-AUTH-002](FRD.md#fr-auth-002); PRD-F-002 | [signup](SRS.md#srs-api-signup) | [TC-AUTH-002-01](FRD.md#tc-auth-002-01), [TC-AUTH-002-02](FRD.md#tc-auth-002-02); [TC-SRS-001](SRS.md#tc-srs-001) |
| [SRS-FR-AUTH-003](SRS.md#srs-fr-auth-003) | [FR-AUTH-003](FRD.md#fr-auth-003); PRD-F-003 | [login](SRS.md#srs-api-login), [getAccount](SRS.md#srs-api-getaccount) | [TC-AUTH-003-01](FRD.md#tc-auth-003-01), [TC-AUTH-003-02](FRD.md#tc-auth-003-02); [TC-SRS-024](SRS.md#tc-srs-024) |
| [SRS-FR-AUTH-004](SRS.md#srs-fr-auth-004) | [FR-AUTH-004](FRD.md#fr-auth-004); PRD-F-004 | [getAccount](SRS.md#srs-api-getaccount), [updateProfile](SRS.md#srs-api-updateprofile), [updateCredentials](SRS.md#srs-api-updatecredentials) | [TC-AUTH-004-01](FRD.md#tc-auth-004-01), [TC-AUTH-004-02](FRD.md#tc-auth-004-02) |
| [SRS-FR-AUTH-005](SRS.md#srs-fr-auth-005) | [FR-AUTH-005](FRD.md#fr-auth-005); PRD-F-005 | [signup](SRS.md#srs-api-signup), [rotateRecoveryCode](SRS.md#srs-api-rotaterecoverycode) | [TC-AUTH-005-01](FRD.md#tc-auth-005-01), [TC-AUTH-005-02](FRD.md#tc-auth-005-02); [TC-SRS-001](SRS.md#tc-srs-001) |
| [SRS-FR-AUTH-006](SRS.md#srs-fr-auth-006) | [FR-AUTH-006](FRD.md#fr-auth-006); PRD-F-005 | [resetPassword](SRS.md#srs-api-resetpassword), [rotateRecoveryCode](SRS.md#srs-api-rotaterecoverycode) | [TC-AUTH-006-01](FRD.md#tc-auth-006-01), [TC-AUTH-006-02](FRD.md#tc-auth-006-02); [TC-SRS-002](SRS.md#tc-srs-002) |
| [SRS-FR-AUTH-007](SRS.md#srs-fr-auth-007) | [FR-AUTH-007](FRD.md#fr-auth-007); PRD-F-006 | [login](SRS.md#srs-api-login) | [TC-AUTH-007-01](FRD.md#tc-auth-007-01), [TC-AUTH-007-02](FRD.md#tc-auth-007-02) |
| [SRS-FR-AUTH-008](SRS.md#srs-fr-auth-008) | [FR-AUTH-008](FRD.md#fr-auth-008); PRD-F-057 | [revokeOfflineSession](SRS.md#srs-api-revokeofflinesession), [logout](SRS.md#srs-api-logout); SessionCoordinator §5.4 | [TC-AUTH-008-01](FRD.md#tc-auth-008-01), [TC-AUTH-008-02](FRD.md#tc-auth-008-02); [TC-SRS-013](SRS.md#tc-srs-013) |
| [SRS-FR-REPORT-001](SRS.md#srs-fr-report-001) | [FR-REPORT-001](FRD.md#fr-report-001); PRD-F-007 | [uploadMedia](SRS.md#srs-api-uploadmedia), [submitReport](SRS.md#srs-api-submitreport) | [TC-REPORT-001-01](FRD.md#tc-report-001-01), [TC-REPORT-001-02](FRD.md#tc-report-001-02); [TC-SRS-006](SRS.md#tc-srs-006) |
| [SRS-FR-REPORT-002](SRS.md#srs-fr-report-002) | [FR-REPORT-002](FRD.md#fr-report-002); PRD-F-008 | [submitReport](SRS.md#srs-api-submitreport) | [TC-REPORT-002-01](FRD.md#tc-report-002-01), [TC-REPORT-002-02](FRD.md#tc-report-002-02) |
| [SRS-FR-REPORT-003](SRS.md#srs-fr-report-003) | [FR-REPORT-003](FRD.md#fr-report-003); PRD-F-009 | [submitReport](SRS.md#srs-api-submitreport); Pemilih titik GPS/manual §5.4 | [TC-REPORT-003-01](FRD.md#tc-report-003-01), [TC-REPORT-003-02](FRD.md#tc-report-003-02) |
| [SRS-FR-REPORT-004](SRS.md#srs-fr-report-004) | [FR-REPORT-004](FRD.md#fr-report-004); PRD-F-010 | [submitReport](SRS.md#srs-api-submitreport); DeviceSignalProvider §5.4 | [TC-REPORT-004-01](FRD.md#tc-report-004-01), [TC-REPORT-004-02](FRD.md#tc-report-004-02); [TC-SRS-021](SRS.md#tc-srs-021) |
| [SRS-FR-REPORT-005](SRS.md#srs-fr-report-005) | [FR-REPORT-005](FRD.md#fr-report-005); PRD-F-010 | [submitReport](SRS.md#srs-api-submitreport); DeviceSignalProvider §5.4 | [TC-REPORT-005-01](FRD.md#tc-report-005-01), [TC-REPORT-005-02](FRD.md#tc-report-005-02); [TC-SRS-021](SRS.md#tc-srs-021) |
| [SRS-FR-REPORT-006](SRS.md#srs-fr-report-006) | [FR-REPORT-006](FRD.md#fr-report-006); PRD-F-010 | [submitReport](SRS.md#srs-api-submitreport); BuildProfile §5.4 | [TC-REPORT-006-01](FRD.md#tc-report-006-01), [TC-REPORT-006-02](FRD.md#tc-report-006-02); [TC-SRS-021](SRS.md#tc-srs-021) |
| [SRS-FR-KTP-001](SRS.md#srs-fr-ktp-001) | [FR-KTP-001](FRD.md#fr-ktp-001); PRD-F-011 | [getReportingStatus](SRS.md#srs-api-getreportingstatus), [submitReport](SRS.md#srs-api-submitreport), [getKtpState](SRS.md#srs-api-getktpstate), [confirmKtp](SRS.md#srs-api-confirmktp) | [TC-KTP-001-01](FRD.md#tc-ktp-001-01), [TC-KTP-001-02](FRD.md#tc-ktp-001-02) |
| [SRS-FR-KTP-002](SRS.md#srs-fr-ktp-002) | [FR-KTP-002](FRD.md#fr-ktp-002); PRD-F-012 | [getJob](SRS.md#srs-api-getjob), [checkKtp](SRS.md#srs-api-checkktp), [retryKtp](SRS.md#srs-api-retryktp) | [TC-KTP-002-01](FRD.md#tc-ktp-002-01), [TC-KTP-002-02](FRD.md#tc-ktp-002-02); [TC-SRS-020](SRS.md#tc-srs-020) |
| [SRS-FR-KTP-003](SRS.md#srs-fr-ktp-003) | [FR-KTP-003](FRD.md#fr-ktp-003); PRD-F-012 | [getKtpState](SRS.md#srs-api-getktpstate), [confirmKtp](SRS.md#srs-api-confirmktp) | [TC-KTP-003-01](FRD.md#tc-ktp-003-01), [TC-KTP-003-02](FRD.md#tc-ktp-003-02); [TC-SRS-007](SRS.md#tc-srs-007) |
| [SRS-FR-KTP-004](SRS.md#srs-fr-ktp-004) | [FR-KTP-004](FRD.md#fr-ktp-004); PRD-F-013 | [submitReport](SRS.md#srs-api-submitreport), [deleteDocument](SRS.md#srs-api-deletedocument), [getKtpState](SRS.md#srs-api-getktpstate) | [TC-KTP-004-01](FRD.md#tc-ktp-004-01), [TC-KTP-004-02](FRD.md#tc-ktp-004-02); [TC-SRS-007](SRS.md#tc-srs-007) |
| [SRS-FR-REPORT-007](SRS.md#srs-fr-report-007) | [FR-REPORT-007](FRD.md#fr-report-007); PRD-F-014 | [uploadMedia](SRS.md#srs-api-uploadmedia), [getUpload](SRS.md#srs-api-getupload), [closeSubmission](SRS.md#srs-api-closesubmission); DraftRepository §5.4 | [TC-REPORT-007-01](FRD.md#tc-report-007-01), [TC-REPORT-007-02](FRD.md#tc-report-007-02) |
| [SRS-FR-REPORT-008](SRS.md#srs-fr-report-008) | [FR-REPORT-008](FRD.md#fr-report-008); PRD-F-015 | [submitReport](SRS.md#srs-api-submitreport), [getSubmission](SRS.md#srs-api-getsubmission) | [TC-REPORT-008-01](FRD.md#tc-report-008-01), [TC-REPORT-008-02](FRD.md#tc-report-008-02) |
| [SRS-FR-REPORT-009](SRS.md#srs-fr-report-009) | [FR-REPORT-009](FRD.md#fr-report-009); PRD-F-015 | [submitReport](SRS.md#srs-api-submitreport), [getSubmission](SRS.md#srs-api-getsubmission), [closeSubmission](SRS.md#srs-api-closesubmission) | [TC-REPORT-009-01](FRD.md#tc-report-009-01), [TC-REPORT-009-02](FRD.md#tc-report-009-02); [TC-SRS-004](SRS.md#tc-srs-004) |
| [SRS-FR-REPORT-010](SRS.md#srs-fr-report-010) | [FR-REPORT-010](FRD.md#fr-report-010); PRD-F-015 | [submitReport](SRS.md#srs-api-submitreport), [getSubmission](SRS.md#srs-api-getsubmission), [closeSubmission](SRS.md#srs-api-closesubmission) | [TC-REPORT-010-01](FRD.md#tc-report-010-01), [TC-REPORT-010-02](FRD.md#tc-report-010-02); [TC-SRS-003](SRS.md#tc-srs-003), [TC-SRS-004](SRS.md#tc-srs-004) |
| [SRS-FR-REPORT-011](SRS.md#srs-fr-report-011) | [FR-REPORT-011](FRD.md#fr-report-011); PRD-F-016 | [listOwnReports](SRS.md#srs-api-listownreports), [getOwnReport](SRS.md#srs-api-getownreport), [downloadMedia](SRS.md#srs-api-downloadmedia) | [TC-REPORT-011-01](FRD.md#tc-report-011-01), [TC-REPORT-011-02](FRD.md#tc-report-011-02); [TC-SRS-023](SRS.md#tc-srs-023) |
| [SRS-FR-REPORT-012](SRS.md#srs-fr-report-012) | [FR-REPORT-012](FRD.md#fr-report-012); PRD-F-017 | [listOwnReports](SRS.md#srs-api-listownreports), [getOwnReport](SRS.md#srs-api-getownreport) | [TC-REPORT-012-01](FRD.md#tc-report-012-01), [TC-REPORT-012-02](FRD.md#tc-report-012-02) |
| [SRS-FR-AI-001](SRS.md#srs-fr-ai-001) | [FR-AI-001](FRD.md#fr-ai-001); PRD-F-018 | [getJob](SRS.md#srs-api-getjob), [retryReportAnalysis](SRS.md#srs-api-retryreportanalysis) | [TC-AI-001-01](FRD.md#tc-ai-001-01), [TC-AI-001-02](FRD.md#tc-ai-001-02); [TC-SRS-010](SRS.md#tc-srs-010), [TC-SRS-019](SRS.md#tc-srs-019), [TC-SRS-020](SRS.md#tc-srs-020) |
| [SRS-FR-AI-002](SRS.md#srs-fr-ai-002) | [FR-AI-002](FRD.md#fr-ai-002); PRD-F-019 | [retryReportAnalysis](SRS.md#srs-api-retryreportanalysis), [correctAssessment](SRS.md#srs-api-correctassessment) | [TC-AI-002-01](FRD.md#tc-ai-002-01), [TC-AI-002-02](FRD.md#tc-ai-002-02) |
| [SRS-FR-AI-003](SRS.md#srs-fr-ai-003) | [FR-AI-003](FRD.md#fr-ai-003); PRD-F-020 | [retryReportAnalysis](SRS.md#srs-api-retryreportanalysis), [correctAssessment](SRS.md#srs-api-correctassessment) | [TC-AI-003-01](FRD.md#tc-ai-003-01), [TC-AI-003-02](FRD.md#tc-ai-003-02) |
| [SRS-FR-REVIEW-001](SRS.md#srs-fr-review-001) | [FR-REVIEW-001](FRD.md#fr-review-001); PRD-F-021 | [listGroups](SRS.md#srs-api-listgroups), [getGroup](SRS.md#srs-api-getgroup), [listGroupReports](SRS.md#srs-api-listgroupreports) | [TC-REVIEW-001-01](FRD.md#tc-review-001-01), [TC-REVIEW-001-02](FRD.md#tc-review-001-02); [TC-SRS-008](SRS.md#tc-srs-008) |
| [SRS-FR-REVIEW-002](SRS.md#srs-fr-review-002) | [FR-REVIEW-002](FRD.md#fr-review-002); PRD-F-022 | [listAdminReports](SRS.md#srs-api-listadminreports), [listGroups](SRS.md#srs-api-listgroups) | [TC-REVIEW-002-01](FRD.md#tc-review-002-01), [TC-REVIEW-002-02](FRD.md#tc-review-002-02) |
| [SRS-FR-REVIEW-003](SRS.md#srs-fr-review-003) | [FR-REVIEW-003](FRD.md#fr-review-003); PRD-F-023 | [getAdminReport](SRS.md#srs-api-getadminreport), [correctAssessment](SRS.md#srs-api-correctassessment), [getGroup](SRS.md#srs-api-getgroup) | [TC-REVIEW-003-01](FRD.md#tc-review-003-01), [TC-REVIEW-003-02](FRD.md#tc-review-003-02); [TC-SRS-010](SRS.md#tc-srs-010) |
| [SRS-FR-REVIEW-004](SRS.md#srs-fr-review-004) | [FR-REVIEW-004](FRD.md#fr-review-004); PRD-F-024 | [moveReport](SRS.md#srs-api-movereport), [getGroup](SRS.md#srs-api-getgroup) | [TC-REVIEW-004-01](FRD.md#tc-review-004-01), [TC-REVIEW-004-02](FRD.md#tc-review-004-02); [TC-SRS-012](SRS.md#tc-srs-012) |
| [SRS-FR-REVIEW-005](SRS.md#srs-fr-review-005) | [FR-REVIEW-005](FRD.md#fr-review-005); PRD-F-025 | [getOwnReport](SRS.md#srs-api-getownreport), [listReportNotes](SRS.md#srs-api-listreportnotes), [getAdminReport](SRS.md#srs-api-getadminreport), [appendReportNote](SRS.md#srs-api-appendreportnote) | [TC-REVIEW-005-01](FRD.md#tc-review-005-01), [TC-REVIEW-005-02](FRD.md#tc-review-005-02); [TC-SRS-012](SRS.md#tc-srs-012) |
| [SRS-FR-REVIEW-006](SRS.md#srs-fr-review-006) | [FR-REVIEW-006](FRD.md#fr-review-006); PRD-F-026 | [listAdminReports](SRS.md#srs-api-listadminreports), [getAdminReport](SRS.md#srs-api-getadminreport), [reviewReport](SRS.md#srs-api-reviewreport), [getGroup](SRS.md#srs-api-getgroup), [listGroupReports](SRS.md#srs-api-listgroupreports) | [TC-REVIEW-006-01](FRD.md#tc-review-006-01), [TC-REVIEW-006-02](FRD.md#tc-review-006-02); [TC-SRS-009](SRS.md#tc-srs-009) |
| [SRS-FR-REVIEW-007](SRS.md#srs-fr-review-007) | [FR-REVIEW-007](FRD.md#fr-review-007); PRD-F-027 | [listGroups](SRS.md#srs-api-listgroups), [completeGroup](SRS.md#srs-api-completegroup) | [TC-REVIEW-007-01](FRD.md#tc-review-007-01), [TC-REVIEW-007-02](FRD.md#tc-review-007-02) |
| [SRS-FR-REVIEW-008](SRS.md#srs-fr-review-008) | [FR-REVIEW-008](FRD.md#fr-review-008); PRD-F-028 | [moveReport](SRS.md#srs-api-movereport), [listGroups](SRS.md#srs-api-listgroups), [completeGroup](SRS.md#srs-api-completegroup) | [TC-REVIEW-008-01](FRD.md#tc-review-008-01), [TC-REVIEW-008-02](FRD.md#tc-review-008-02); [TC-SRS-008](SRS.md#tc-srs-008) |
| [SRS-FR-REVIEW-009](SRS.md#srs-fr-review-009) | [FR-REVIEW-009](FRD.md#fr-review-009); PRD-F-023 | [correctAssessment](SRS.md#srs-api-correctassessment), [reviewReport](SRS.md#srs-api-reviewreport), [moveReport](SRS.md#srs-api-movereport), [appendReportNote](SRS.md#srs-api-appendreportnote), [completeGroup](SRS.md#srs-api-completegroup), [listAudit](SRS.md#srs-api-listaudit) | [TC-REVIEW-009-01](FRD.md#tc-review-009-01), [TC-REVIEW-009-02](FRD.md#tc-review-009-02) |
| [SRS-FR-CONTROL-001](SRS.md#srs-fr-control-001) | [FR-CONTROL-001](FRD.md#fr-control-001); PRD-F-029 | [getReportingStatus](SRS.md#srs-api-getreportingstatus), [submitReport](SRS.md#srs-api-submitreport), [getSettings](SRS.md#srs-api-getsettings), [updateSettings](SRS.md#srs-api-updatesettings) | [TC-CONTROL-001-01](FRD.md#tc-control-001-01), [TC-CONTROL-001-02](FRD.md#tc-control-001-02) |
| [SRS-FR-CONTROL-002](SRS.md#srs-fr-control-002) | [FR-CONTROL-002](FRD.md#fr-control-002); PRD-F-030 | [getReportingStatus](SRS.md#srs-api-getreportingstatus), [submitReport](SRS.md#srs-api-submitreport), [getSettings](SRS.md#srs-api-getsettings), [updateSettings](SRS.md#srs-api-updatesettings), [listQuotaAccounts](SRS.md#srs-api-listquotaaccounts) | [TC-CONTROL-002-01](FRD.md#tc-control-002-01), [TC-CONTROL-002-02](FRD.md#tc-control-002-02); [TC-SRS-003](SRS.md#tc-srs-003), [TC-SRS-005](SRS.md#tc-srs-005) |
| [SRS-FR-CONTROL-003](SRS.md#srs-fr-control-003) | [FR-CONTROL-003](FRD.md#fr-control-003); PRD-F-031 | [listQuotaAccounts](SRS.md#srs-api-listquotaaccounts), [resetQuota](SRS.md#srs-api-resetquota) | [TC-CONTROL-003-01](FRD.md#tc-control-003-01), [TC-CONTROL-003-02](FRD.md#tc-control-003-02); [TC-SRS-005](SRS.md#tc-srs-005) |
| [SRS-FR-CONTROL-004](SRS.md#srs-fr-control-004) | [FR-CONTROL-004](FRD.md#fr-control-004); PRD-F-032 | [deleteReport](SRS.md#srs-api-deletereport), [listReportCleanup](SRS.md#srs-api-listreportcleanup), [retryReportCleanup](SRS.md#srs-api-retryreportcleanup), [listAudit](SRS.md#srs-api-listaudit) | [TC-CONTROL-004-01](FRD.md#tc-control-004-01), [TC-CONTROL-004-02](FRD.md#tc-control-004-02); [TC-SRS-011](SRS.md#tc-srs-011), [TC-SRS-023](SRS.md#tc-srs-023) |
| [SRS-FR-CONTROL-005](SRS.md#srs-fr-control-005) | [FR-CONTROL-005](FRD.md#fr-control-005); PRD-F-033 | [deleteReport](SRS.md#srs-api-deletereport), [listReportCleanup](SRS.md#srs-api-listreportcleanup), [retryReportCleanup](SRS.md#srs-api-retryreportcleanup) | [TC-CONTROL-005-01](FRD.md#tc-control-005-01), [TC-CONTROL-005-02](FRD.md#tc-control-005-02); [TC-SRS-011](SRS.md#tc-srs-011) |
| [SRS-FR-MONITOR-001](SRS.md#srs-fr-monitor-001) | [FR-MONITOR-001](FRD.md#fr-monitor-001); PRD-F-034 | [listMonitor](SRS.md#srs-api-listmonitor) | [TC-MONITOR-001-01](FRD.md#tc-monitor-001-01), [TC-MONITOR-001-02](FRD.md#tc-monitor-001-02); [TC-SRS-024](SRS.md#tc-srs-024) |
| [SRS-FR-MONITOR-002](SRS.md#srs-fr-monitor-002) | [FR-MONITOR-002](FRD.md#fr-monitor-002); PRD-F-035 | [listMonitor](SRS.md#srs-api-listmonitor) | [TC-MONITOR-002-01](FRD.md#tc-monitor-002-01), [TC-MONITOR-002-02](FRD.md#tc-monitor-002-02) |
| [SRS-FR-MONITOR-003](SRS.md#srs-fr-monitor-003) | [FR-MONITOR-003](FRD.md#fr-monitor-003); PRD-F-036 | [listMonitor](SRS.md#srs-api-listmonitor) | [TC-MONITOR-003-01](FRD.md#tc-monitor-003-01), [TC-MONITOR-003-02](FRD.md#tc-monitor-003-02) |
| [SRS-FR-VAULT-001](SRS.md#srs-fr-vault-001) | [FR-VAULT-001](FRD.md#fr-vault-001); PRD-F-037 | [uploadMedia](SRS.md#srs-api-uploadmedia), [getUpload](SRS.md#srs-api-getupload), [listDocuments](SRS.md#srs-api-listdocuments), [createDocument](SRS.md#srs-api-createdocument) | [TC-VAULT-001-01](FRD.md#tc-vault-001-01), [TC-VAULT-001-02](FRD.md#tc-vault-001-02); [TC-SRS-006](SRS.md#tc-srs-006) |
| [SRS-FR-VAULT-002](SRS.md#srs-fr-vault-002) | [FR-VAULT-002](FRD.md#fr-vault-002); PRD-F-037 | [downloadMedia](SRS.md#srs-api-downloadmedia), [listDocuments](SRS.md#srs-api-listdocuments), [getDocument](SRS.md#srs-api-getdocument) | [TC-VAULT-002-01](FRD.md#tc-vault-002-01), [TC-VAULT-002-02](FRD.md#tc-vault-002-02); [TC-SRS-014](SRS.md#tc-srs-014) |
| [SRS-FR-VAULT-003](SRS.md#srs-fr-vault-003) | [FR-VAULT-003](FRD.md#fr-vault-003); PRD-F-037 | [deleteDocument](SRS.md#srs-api-deletedocument), [listOwnCleanup](SRS.md#srs-api-listowncleanup), [retryOwnCleanup](SRS.md#srs-api-retryowncleanup) | [TC-VAULT-003-01](FRD.md#tc-vault-003-01), [TC-VAULT-003-02](FRD.md#tc-vault-003-02) |
| [SRS-FR-VAULT-004](SRS.md#srs-fr-vault-004) | [FR-VAULT-004](FRD.md#fr-vault-004); PRD-F-038 | [downloadMedia](SRS.md#srs-api-downloadmedia), [listDocuments](SRS.md#srs-api-listdocuments), [getDocument](SRS.md#srs-api-getdocument) | [TC-VAULT-004-01](FRD.md#tc-vault-004-01), [TC-VAULT-004-02](FRD.md#tc-vault-004-02); [TC-SRS-014](SRS.md#tc-srs-014) |
| [SRS-FR-FAMILY-001](SRS.md#srs-fr-family-001) | [FR-FAMILY-001](FRD.md#fr-family-001); PRD-F-039 | [extractFamily](SRS.md#srs-api-extractfamily) | [TC-FAMILY-001-01](FRD.md#tc-family-001-01), [TC-FAMILY-001-02](FRD.md#tc-family-001-02) |
| [SRS-FR-FAMILY-002](SRS.md#srs-fr-family-002) | [FR-FAMILY-002](FRD.md#fr-family-002); PRD-F-040 | [getJob](SRS.md#srs-api-getjob), [extractFamily](SRS.md#srs-api-extractfamily) | [TC-FAMILY-002-01](FRD.md#tc-family-002-01), [TC-FAMILY-002-02](FRD.md#tc-family-002-02); [TC-SRS-019](SRS.md#tc-srs-019) |
| [SRS-FR-FAMILY-003](SRS.md#srs-fr-family-003) | [FR-FAMILY-003](FRD.md#fr-family-003); PRD-F-041 | [applyFamilySuggestions](SRS.md#srs-api-applyfamilysuggestions) | [TC-FAMILY-003-01](FRD.md#tc-family-003-01), [TC-FAMILY-003-02](FRD.md#tc-family-003-02); [TC-SRS-020](SRS.md#tc-srs-020) |
| [SRS-FR-FAMILY-004](SRS.md#srs-fr-family-004) | [FR-FAMILY-004](FRD.md#fr-family-004); PRD-F-042 | [updateFamily](SRS.md#srs-api-updatefamily), [retryFamilyExtraction](SRS.md#srs-api-retryfamilyextraction) | [TC-FAMILY-004-01](FRD.md#tc-family-004-01), [TC-FAMILY-004-02](FRD.md#tc-family-004-02) |
| [SRS-FR-FAMILY-005](SRS.md#srs-fr-family-005) | [FR-FAMILY-005](FRD.md#fr-family-005); PRD-F-043 | [getFamily](SRS.md#srs-api-getfamily), [updateFamily](SRS.md#srs-api-updatefamily) | [TC-FAMILY-005-01](FRD.md#tc-family-005-01), [TC-FAMILY-005-02](FRD.md#tc-family-005-02) |
| [SRS-FR-FAMILY-006](SRS.md#srs-fr-family-006) | [FR-FAMILY-006](FRD.md#fr-family-006); PRD-F-044 | [updateFamily](SRS.md#srs-api-updatefamily), [applyFamilySuggestions](SRS.md#srs-api-applyfamilysuggestions) | [TC-FAMILY-006-01](FRD.md#tc-family-006-01), [TC-FAMILY-006-02](FRD.md#tc-family-006-02); [TC-SRS-015](SRS.md#tc-srs-015) |
| [SRS-FR-FAMILY-007](SRS.md#srs-fr-family-007) | [FR-FAMILY-007](FRD.md#fr-family-007); PRD-F-045 | [deleteDocument](SRS.md#srs-api-deletedocument), [getFamily](SRS.md#srs-api-getfamily), [applyFamilySuggestions](SRS.md#srs-api-applyfamilysuggestions) | [TC-FAMILY-007-01](FRD.md#tc-family-007-01), [TC-FAMILY-007-02](FRD.md#tc-family-007-02); [TC-SRS-015](SRS.md#tc-srs-015) |
| [SRS-FR-READY-001](SRS.md#srs-fr-ready-001) | [FR-READY-001](FRD.md#fr-ready-001); PRD-F-046 | [getContentPart](SRS.md#srs-api-getcontentpart); BagCalculator §5.4 | [TC-READY-001-01](FRD.md#tc-ready-001-01), [TC-READY-001-02](FRD.md#tc-ready-001-02); [TC-SRS-016](SRS.md#tc-srs-016) |
| [SRS-FR-READY-002](SRS.md#srs-fr-ready-002) | [FR-READY-002](FRD.md#fr-ready-002); PRD-F-047 | BagRepository §5.4 | [TC-READY-002-01](FRD.md#tc-ready-002-01), [TC-READY-002-02](FRD.md#tc-ready-002-02); [TC-SRS-016](SRS.md#tc-srs-016) |
| [SRS-FR-READY-003](SRS.md#srs-fr-ready-003) | [FR-READY-003](FRD.md#fr-ready-003); PRD-F-048 | [getContentPart](SRS.md#srs-api-getcontentpart); ContactsPresenter §5.4 | [TC-READY-003-01](FRD.md#tc-ready-003-01), [TC-READY-003-02](FRD.md#tc-ready-003-02) |
| [SRS-FR-READY-004](SRS.md#srs-fr-ready-004) | [FR-READY-004](FRD.md#fr-ready-004); PRD-F-049 | PrivateContactsRepository §5.4 | [TC-READY-004-01](FRD.md#tc-ready-004-01), [TC-READY-004-02](FRD.md#tc-ready-004-02) |
| [SRS-FR-READY-005](SRS.md#srs-fr-ready-005) | [FR-READY-005](FRD.md#fr-ready-005); PRD-F-050 | AccountScope §5.4 | [TC-READY-005-01](FRD.md#tc-ready-005-01), [TC-READY-005-02](FRD.md#tc-ready-005-02); [TC-SRS-013](SRS.md#tc-srs-013) |
| [SRS-FR-READY-006](SRS.md#srs-fr-ready-006) | [FR-READY-006](FRD.md#fr-ready-006); PRD-F-051 | [getContentPart](SRS.md#srs-api-getcontentpart); SpeechController §5.4 | [TC-READY-006-01](FRD.md#tc-ready-006-01), [TC-READY-006-02](FRD.md#tc-ready-006-02); [TC-SRS-022](SRS.md#tc-srs-022) |
| [SRS-FR-READY-007](SRS.md#srs-fr-ready-007) | [FR-READY-007](FRD.md#fr-ready-007); PRD-F-052 | [getContentManifest](SRS.md#srs-api-getcontentmanifest), [getContentPart](SRS.md#srs-api-getcontentpart); ContentBundle §5.4 | [TC-READY-007-01](FRD.md#tc-ready-007-01), [TC-READY-007-02](FRD.md#tc-ready-007-02); [TC-SRS-017](SRS.md#tc-srs-017) |
| [SRS-FR-READY-008](SRS.md#srs-fr-ready-008) | [FR-READY-008](FRD.md#fr-ready-008); PRD-F-052 | [getContentManifest](SRS.md#srs-api-getcontentmanifest), [getContentPart](SRS.md#srs-api-getcontentpart), [publishContent](SRS.md#srs-api-publishcontent), [withdrawContent](SRS.md#srs-api-withdrawcontent); ContentUpdater §5.4 | [TC-READY-008-01](FRD.md#tc-ready-008-01), [TC-READY-008-02](FRD.md#tc-ready-008-02); [TC-SRS-017](SRS.md#tc-srs-017) |
| [SRS-FR-CONTENT-001](SRS.md#srs-fr-content-001) | [FR-CONTENT-001](FRD.md#fr-content-001); PRD-F-053 | [listContentAdmin](SRS.md#srs-api-listcontentadmin), [createContentDraft](SRS.md#srs-api-createcontentdraft), [updateContentDraft](SRS.md#srs-api-updatecontentdraft), [publishContent](SRS.md#srs-api-publishcontent), [withdrawContent](SRS.md#srs-api-withdrawcontent), [deleteContentDraft](SRS.md#srs-api-deletecontentdraft) | [TC-CONTENT-001-01](FRD.md#tc-content-001-01), [TC-CONTENT-001-02](FRD.md#tc-content-001-02) |
| [SRS-FR-INBOX-001](SRS.md#srs-fr-inbox-001) | [FR-INBOX-001](FRD.md#fr-inbox-001); PRD-F-054 | [publishMessage](SRS.md#srs-api-publishmessage), [listMessagesAdmin](SRS.md#srs-api-listmessagesadmin), [getMessageAdmin](SRS.md#srs-api-getmessageadmin), [listInbox](SRS.md#srs-api-listinbox) | [TC-INBOX-001-01](FRD.md#tc-inbox-001-01), [TC-INBOX-001-02](FRD.md#tc-inbox-001-02) |
| [SRS-FR-INBOX-002](SRS.md#srs-fr-inbox-002) | [FR-INBOX-002](FRD.md#fr-inbox-002); PRD-F-055 | [getMessageAdmin](SRS.md#srs-api-getmessageadmin), [editMessage](SRS.md#srs-api-editmessage), [listInbox](SRS.md#srs-api-listinbox) | [TC-INBOX-002-01](FRD.md#tc-inbox-002-01), [TC-INBOX-002-02](FRD.md#tc-inbox-002-02); [TC-SRS-018](SRS.md#tc-srs-018) |
| [SRS-FR-INBOX-003](SRS.md#srs-fr-inbox-003) | [FR-INBOX-003](FRD.md#fr-inbox-003); PRD-F-055 | [listMessagesAdmin](SRS.md#srs-api-listmessagesadmin), [getMessageAdmin](SRS.md#srs-api-getmessageadmin), [revokeMessage](SRS.md#srs-api-revokemessage), [expireMessage](SRS.md#srs-api-expiremessage), [listInbox](SRS.md#srs-api-listinbox) | [TC-INBOX-003-01](FRD.md#tc-inbox-003-01), [TC-INBOX-003-02](FRD.md#tc-inbox-003-02); [TC-SRS-018](SRS.md#tc-srs-018) |
| [SRS-FR-INBOX-004](SRS.md#srs-fr-inbox-004) | [FR-INBOX-004](FRD.md#fr-inbox-004); PRD-F-056 | [markRead](SRS.md#srs-api-markread) | [TC-INBOX-004-01](FRD.md#tc-inbox-004-01), [TC-INBOX-004-02](FRD.md#tc-inbox-004-02); [TC-SRS-018](SRS.md#tc-srs-018) |

| SRS NFR | Asal | Verifikasi |
|---|---|---|
| [SRS-NFR-001](SRS.md#srs-nfr-001) | [PRD-NF-001](PRD.md#prd-nf-001) | [TC-NF-001](FRD.md#tc-nf-001); NOT_RUN |
| [SRS-NFR-002](SRS.md#srs-nfr-002) | [PRD-NF-002](PRD.md#prd-nf-002) | [TC-NF-002](FRD.md#tc-nf-002); NOT_RUN |
| [SRS-NFR-003](SRS.md#srs-nfr-003) | [PRD-NF-003](PRD.md#prd-nf-003) | [TC-NF-003](FRD.md#tc-nf-003); NOT_RUN |
| [SRS-NFR-004](SRS.md#srs-nfr-004) | [PRD-NF-004](PRD.md#prd-nf-004) | [TC-NF-004](FRD.md#tc-nf-004); NOT_RUN |
| [SRS-NFR-005](SRS.md#srs-nfr-005) | [PRD-NF-005](PRD.md#prd-nf-005) | [TC-NF-005](FRD.md#tc-nf-005); NOT_RUN |
| [SRS-NFR-006](SRS.md#srs-nfr-006) | [PRD-NF-006](PRD.md#prd-nf-006) | [TC-NF-006](FRD.md#tc-nf-006); NOT_RUN |
| [SRS-NFR-007](SRS.md#srs-nfr-007) | [PRD-NF-007](PRD.md#prd-nf-007) | [TC-NF-007](FRD.md#tc-nf-007); NOT_RUN |
| [SRS-NFR-008](SRS.md#srs-nfr-008) | [PRD-NF-008](PRD.md#prd-nf-008) | [TC-NF-008](FRD.md#tc-nf-008); NOT_RUN |
| [SRS-NFR-009](SRS.md#srs-nfr-009) | [PRD-NF-009](PRD.md#prd-nf-009) | [TC-NF-009](FRD.md#tc-nf-009); NOT_RUN |
| [SRS-NFR-010](SRS.md#srs-nfr-010) | [PRD-NF-010](PRD.md#prd-nf-010) | [TC-NF-010](FRD.md#tc-nf-010); NOT_RUN |

| Skenario silang sumber | Turunan SRS teknis |
|---|---|
| [TC-X-001](FRD.md#tc-x-001) | [TC-SRS-003](SRS.md#tc-srs-003), [TC-SRS-005](SRS.md#tc-srs-005) |
| [TC-X-002](FRD.md#tc-x-002) | [TC-SRS-004](SRS.md#tc-srs-004), [TC-SRS-007](SRS.md#tc-srs-007) |
| [TC-X-003](FRD.md#tc-x-003) | [TC-SRS-013](SRS.md#tc-srs-013) |
| [TC-X-004](FRD.md#tc-x-004) | [TC-SRS-011](SRS.md#tc-srs-011), [TC-SRS-019](SRS.md#tc-srs-019) |
| [TC-X-005](FRD.md#tc-x-005) | [TC-SRS-009](SRS.md#tc-srs-009) |
| [TC-X-006](FRD.md#tc-x-006) | [TC-SRS-008](SRS.md#tc-srs-008) |
| [TC-X-007](FRD.md#tc-x-007) | [TC-SRS-020](SRS.md#tc-srs-020) |
| [TC-X-008](FRD.md#tc-x-008) | [TC-SRS-015](SRS.md#tc-srs-015) |
| [TC-X-009](FRD.md#tc-x-009) | [TC-SRS-018](SRS.md#tc-srs-018) |
| [TC-X-010](FRD.md#tc-x-010) | [TC-SRS-024](SRS.md#tc-srs-024) |

| Kontrak bersama SRS | Asal FR | Verifikasi teknis |
|---|---|---|
| SRS-DATA-001 | [FR-AUTH-002](FRD.md#fr-auth-002), [FR-AUTH-004](FRD.md#fr-auth-004), [FR-AUTH-007](FRD.md#fr-auth-007) | [TC-SRS-001](SRS.md#tc-srs-001), [TC-SRS-002](SRS.md#tc-srs-002), [TC-SRS-024](SRS.md#tc-srs-024) |
| SRS-DATA-002 | [FR-AUTH-005](FRD.md#fr-auth-005), [FR-AUTH-006](FRD.md#fr-auth-006) | [TC-SRS-001](SRS.md#tc-srs-001), [TC-SRS-002](SRS.md#tc-srs-002) |
| SRS-DATA-003 | [FR-AUTH-003](FRD.md#fr-auth-003), [FR-AUTH-008](FRD.md#fr-auth-008) | [TC-SRS-002](SRS.md#tc-srs-002), [TC-SRS-013](SRS.md#tc-srs-013), [TC-SRS-024](SRS.md#tc-srs-024) |
| SRS-DATA-004 | [FR-AUTH-003](FRD.md#fr-auth-003), [FR-AUTH-006](FRD.md#fr-auth-006) | [TC-SRS-002](SRS.md#tc-srs-002), [TC-SRS-024](SRS.md#tc-srs-024) |
| SRS-DATA-005 | [FR-REPORT-010](FRD.md#fr-report-010), [FR-CONTROL-002](FRD.md#fr-control-002), [FR-REVIEW-003](FRD.md#fr-review-003) | [TC-SRS-003](SRS.md#tc-srs-003), [TC-SRS-005](SRS.md#tc-srs-005), [TC-SRS-009](SRS.md#tc-srs-009) |
| SRS-DATA-006 | [FR-REPORT-010](FRD.md#fr-report-010), [FR-INBOX-001](FRD.md#fr-inbox-001), [FR-FAMILY-006](FRD.md#fr-family-006) | [TC-SRS-003](SRS.md#tc-srs-003), [TC-SRS-004](SRS.md#tc-srs-004), [TC-SRS-018](SRS.md#tc-srs-018) |
| SRS-DATA-007 | [FR-REPORT-001](FRD.md#fr-report-001), [FR-VAULT-001](FRD.md#fr-vault-001) | [TC-SRS-006](SRS.md#tc-srs-006), [TC-SRS-011](SRS.md#tc-srs-011) |
| SRS-DATA-008 | [FR-REPORT-002](FRD.md#fr-report-002), [FR-REPORT-011](FRD.md#fr-report-011) | [TC-SRS-003](SRS.md#tc-srs-003), [TC-SRS-008](SRS.md#tc-srs-008), [TC-SRS-011](SRS.md#tc-srs-011) |
| SRS-DATA-009 | [FR-REPORT-001](FRD.md#fr-report-001), [FR-REPORT-011](FRD.md#fr-report-011) | [TC-SRS-006](SRS.md#tc-srs-006), [TC-SRS-014](SRS.md#tc-srs-014) |
| SRS-DATA-010 | [FR-CONTROL-001](FRD.md#fr-control-001), [FR-CONTROL-002](FRD.md#fr-control-002), [FR-CONTROL-003](FRD.md#fr-control-003) | [TC-SRS-005](SRS.md#tc-srs-005) |
| SRS-DATA-011 | [FR-CONTROL-002](FRD.md#fr-control-002), [FR-CONTROL-003](FRD.md#fr-control-003) | [TC-SRS-005](SRS.md#tc-srs-005), [TC-SRS-011](SRS.md#tc-srs-011) |
| SRS-DATA-012 | [FR-REVIEW-001](FRD.md#fr-review-001), [FR-REVIEW-008](FRD.md#fr-review-008), [FR-MONITOR-003](FRD.md#fr-monitor-003) | [TC-SRS-008](SRS.md#tc-srs-008), [TC-SRS-012](SRS.md#tc-srs-012) |
| SRS-DATA-013 | [FR-AI-001](FRD.md#fr-ai-001), [FR-REVIEW-003](FRD.md#fr-review-003) | [TC-SRS-010](SRS.md#tc-srs-010), [TC-SRS-020](SRS.md#tc-srs-020) |
| SRS-DATA-014 | [FR-REVIEW-006](FRD.md#fr-review-006) | [TC-SRS-009](SRS.md#tc-srs-009) |
| SRS-DATA-015 | [FR-REVIEW-005](FRD.md#fr-review-005) | [TC-SRS-012](SRS.md#tc-srs-012) |
| SRS-DATA-016 | [FR-AI-001](FRD.md#fr-ai-001), [FR-KTP-002](FRD.md#fr-ktp-002), [FR-FAMILY-002](FRD.md#fr-family-002) | [TC-SRS-019](SRS.md#tc-srs-019), [TC-SRS-020](SRS.md#tc-srs-020) |
| SRS-DATA-017 | [FR-CONTROL-004](FRD.md#fr-control-004), [FR-VAULT-003](FRD.md#fr-vault-003) | [TC-SRS-011](SRS.md#tc-srs-011), [TC-SRS-014](SRS.md#tc-srs-014) |
| SRS-DATA-018 | [FR-VAULT-001](FRD.md#fr-vault-001), [FR-KTP-003](FRD.md#fr-ktp-003) | [TC-SRS-006](SRS.md#tc-srs-006), [TC-SRS-007](SRS.md#tc-srs-007) |
| SRS-DATA-019 | [FR-KTP-002](FRD.md#fr-ktp-002), [FR-FAMILY-001](FRD.md#fr-family-001) | [TC-SRS-020](SRS.md#tc-srs-020), [TC-SRS-024](SRS.md#tc-srs-024) |
| SRS-DATA-020 | [FR-FAMILY-005](FRD.md#fr-family-005), [FR-FAMILY-006](FRD.md#fr-family-006) | [TC-SRS-015](SRS.md#tc-srs-015) |
| SRS-DATA-021 | [FR-FAMILY-003](FRD.md#fr-family-003), [FR-FAMILY-007](FRD.md#fr-family-007) | [TC-SRS-015](SRS.md#tc-srs-015), [TC-SRS-020](SRS.md#tc-srs-020) |
| SRS-DATA-022 | [FR-CONTENT-001](FRD.md#fr-content-001), [FR-READY-008](FRD.md#fr-ready-008) | [TC-SRS-017](SRS.md#tc-srs-017) |
| SRS-DATA-023 | [FR-INBOX-001](FRD.md#fr-inbox-001), [FR-INBOX-002](FRD.md#fr-inbox-002), [FR-INBOX-003](FRD.md#fr-inbox-003) | [TC-SRS-018](SRS.md#tc-srs-018), [TC-SRS-023](SRS.md#tc-srs-023) |
| SRS-DATA-024 | [FR-INBOX-004](FRD.md#fr-inbox-004) | [TC-SRS-018](SRS.md#tc-srs-018) |
| SRS-DATA-025 | [FR-REPORT-011](FRD.md#fr-report-011), [FR-CONTROL-004](FRD.md#fr-control-004) | [TC-SRS-011](SRS.md#tc-srs-011), [TC-SRS-023](SRS.md#tc-srs-023) |
| SRS-DATA-026 | [FR-REVIEW-009](FRD.md#fr-review-009), [FR-CONTROL-004](FRD.md#fr-control-004) | [TC-SRS-011](SRS.md#tc-srs-011), [TC-SRS-023](SRS.md#tc-srs-023), [TC-SRS-024](SRS.md#tc-srs-024) |
| SRS-DATA-027 | [FR-REPORT-007](FRD.md#fr-report-007), [FR-READY-002](FRD.md#fr-ready-002), [FR-READY-004](FRD.md#fr-ready-004), [FR-READY-005](FRD.md#fr-ready-005) | [TC-SRS-013](SRS.md#tc-srs-013), [TC-SRS-016](SRS.md#tc-srs-016), [TC-SRS-017](SRS.md#tc-srs-017) |
| SRS-IF-001 | [FR-REPORT-012](FRD.md#fr-report-012), [FR-MONITOR-001](FRD.md#fr-monitor-001) | [TC-SRS-003](SRS.md#tc-srs-003), [TC-SRS-024](SRS.md#tc-srs-024) |
| SRS-IF-002 | [FR-AUTH-003](FRD.md#fr-auth-003), [FR-REPORT-009](FRD.md#fr-report-009) | [TC-SRS-002](SRS.md#tc-srs-002), [TC-SRS-004](SRS.md#tc-srs-004), [TC-SRS-024](SRS.md#tc-srs-024) |
| SRS-IF-003 | [FR-AUTH-003](FRD.md#fr-auth-003), [FR-VAULT-002](FRD.md#fr-vault-002) | [TC-SRS-014](SRS.md#tc-srs-014), [TC-SRS-024](SRS.md#tc-srs-024) |
| SRS-IF-004 | [FR-REPORT-010](FRD.md#fr-report-010), [FR-AUTH-005](FRD.md#fr-auth-005) | [TC-SRS-001](SRS.md#tc-srs-001), [TC-SRS-003](SRS.md#tc-srs-003), [TC-SRS-004](SRS.md#tc-srs-004) |
| SRS-IF-005 | [FR-REVIEW-003](FRD.md#fr-review-003), [FR-FAMILY-006](FRD.md#fr-family-006), [FR-INBOX-002](FRD.md#fr-inbox-002) | [TC-SRS-009](SRS.md#tc-srs-009), [TC-SRS-012](SRS.md#tc-srs-012), [TC-SRS-015](SRS.md#tc-srs-015), [TC-SRS-018](SRS.md#tc-srs-018) |
| SRS-IF-006 | [FR-REPORT-001](FRD.md#fr-report-001), [FR-VAULT-001](FRD.md#fr-vault-001) | [TC-SRS-006](SRS.md#tc-srs-006) |
| SRS-IF-007 | [FR-AI-001](FRD.md#fr-ai-001), [FR-KTP-002](FRD.md#fr-ktp-002), [FR-FAMILY-001](FRD.md#fr-family-001) | [TC-SRS-020](SRS.md#tc-srs-020) |
| SRS-IF-008 | [FR-REPORT-004](FRD.md#fr-report-004), [FR-REPORT-005](FRD.md#fr-report-005), [FR-REPORT-006](FRD.md#fr-report-006) | [TC-SRS-021](SRS.md#tc-srs-021) |
| SRS-IF-009 | [FR-AUTH-008](FRD.md#fr-auth-008), [FR-READY-005](FRD.md#fr-ready-005) | [TC-SRS-013](SRS.md#tc-srs-013) |
| SRS-IF-010 | [FR-REPORT-011](FRD.md#fr-report-011), [FR-INBOX-001](FRD.md#fr-inbox-001), [FR-READY-008](FRD.md#fr-ready-008) | [TC-SRS-017](SRS.md#tc-srs-017), [TC-SRS-024](SRS.md#tc-srs-024) |
| SRS-CON-001 | [FR-AUTH-007](FRD.md#fr-auth-007), [FR-REPORT-006](FRD.md#fr-report-006) | [TC-SRS-021](SRS.md#tc-srs-021), [TC-SRS-024](SRS.md#tc-srs-024) |
| SRS-CON-002 | [FR-AUTH-002](FRD.md#fr-auth-002), [FR-VAULT-002](FRD.md#fr-vault-002), [FR-FAMILY-005](FRD.md#fr-family-005) | [TC-SRS-001](SRS.md#tc-srs-001), [TC-SRS-014](SRS.md#tc-srs-014), [TC-SRS-024](SRS.md#tc-srs-024) |
| SRS-CON-003 | [FR-MONITOR-003](FRD.md#fr-monitor-003), [FR-INBOX-001](FRD.md#fr-inbox-001) | [TC-SRS-024](SRS.md#tc-srs-024) |
| SRS-CON-004 | [FR-AUTH-005](FRD.md#fr-auth-005), [FR-AI-001](FRD.md#fr-ai-001) | [TC-SRS-020](SRS.md#tc-srs-020), [TC-SRS-024](SRS.md#tc-srs-024) |

Data SRS-DATA-001–027, interface SRS-IF-001–010 dan constraint SRS-CON-001–004 menjadi kontrak bersama record modul dan skenario teknis. Cakupan dibuktikan melalui RTM dan auditor, bukan sekadar jumlah requirement. Register sumber riset lengkap ada pada SRS §9.1; hasilnya DOCUMENTED_SUPPORT, bukan PoC.

<a id="srs-evidence"></a>

## 37. Bukti dan risiko SRS

| Bukti | Sumber / rencana | Status aktual |
|---|---|---|
| Dokumentasi provider/runtime/platform | 17 sumber primer pada SRS §9.1, diperiksa 18 Oktober 2026 | DOCUMENTED_SUPPORT; temuan dibedakan dari pilihan proyek |
| Alat lokal PATH | node/ffmpeg/ffprobe ditemukan; flutter/dart/adb/mysql tidak ditemukan pada PATH proses ini | FACT_INSPECTED terbatas; tidak membuktikan keseluruhan instalasi tim |
| Perangkat/SDK/plugin | SRS-EV-001; inventaris/bukti Flutter | EVIDENCE_PENDING, tes NOT_RUN |
| AI laporan | SRS-EV-002; model/akun/foto/video nyata | EVIDENCE_PENDING, provider NOT_RUN |
| KTP/keluarga/PDF | SRS-EV-003; 8 spesimen sintetis dan parser | EVIDENCE_PENDING, provider NOT_RUN |
| Fixture/konten/izin | SRS-EV-004; manifest akun/report/doc/konten | EVIDENCE_PENDING, UAT NOT_RUN |
| Build/database/patch | SRS-EV-005; manifest tahap 5 dan smoke test | SETUP_PENDING, build NOT_RUN |

Tidak ada credential, akun layanan, panggilan provider, perangkat fisik, SDK/server atau deployment yang dibuat/dijalankan oleh penyusunan dokumen ini. Batas tersebut sesuai cakupan tahap dan bukan penghapusan fitur PRD.

<a id="srs-audit-v100"></a>

## 38. Audit SRS v1.0.0

Jalankan `python -X utf8 .srs_audit.py`; hasil mesin pada hasil audit SRS (arsip lokal). Auditor memeriksa sumber terlindungi, cakupan FR/NF/TC, route/role/schema/ref, contoh valid-invalid, metadata approval, format tabel dan tautan. Hasil aktual diringkas di bawah sesudah audit dijalankan. Semua pengujian aplikasi tetap NOT_RUN.

<!-- srs-audit-summary:start -->
**Hasil aktual: PASS.** 68 kebutuhan fungsional dan 10 NFR tercakup; 72 operasi API, 166 schema, serta 41 contoh valid/invalid lolos pemeriksaan. Seluruh 156 skenario FRD terpetakan dan 24 skenario teknis tambahan tersedia. 3536 tautan lokal diperiksa; BRD/PRD/FRD serta riwayat sumber terlindungi tetap utuh. Audit FRD juga PASS; tidak ada error auditor.

PASS ini mencakup struktur dokumen, keterlacakan, referensi dan validasi contoh JSON Schema. Ini tidak menyatakan aplikasi, database, API aktual, provider AI atau perangkat telah lulus; seluruh tes produk/provider/perangkat tetap **NOT_RUN**.
<!-- srs-audit-summary:end -->

<a id="workspace-traceability"></a>

## 39. Penataan panduan workspace

Sumber mandat: [WORKSPACE-SCOPE-001](DECISIONS.md#workspace-scope-001).
Hasil pemeriksaan terkini: [WORKSPACE](WORKSPACE.md#verifikasi).

| Kebutuhan pengguna | Artefak / hasil |
|---|---|
| AGENTS dan README yang sesuai proyek | [AGENTS](../AGENTS.md), [README](../README.md) |
| Rules kerja | [Alur](../rules/workflow.md), [domain](../rules/domain.md), [mutu](../rules/quality.md) |
| Skills yang berisi prosedur nyata | [Katalog lima skill](../SKILL.md); format YAML dan routing baca langsung |
| Satu tempat backend dan Flutter | Wadah pada tahap ini bernama project; kini [apps](../apps/README.md), server/app hanya penanda kosong |
| Hapus setup aplikasi yang tidak diminta | Scaffold/runtime/utilitas baru dihapus; root tools/reports/cache dikeluarkan |
| Pertahankan hasil spesifikasi dan sesi | Arsip (lokal), baseline FRD/SRS dan kontrak tetap acuan |
| Riset mekanisme resmi | Tiga sumber resmi dan pemisahan native/manual pada [WORKSPACE](WORKSPACE.md) |

Penempatan `.agents/skills/` terhalang izin sesi; tidak ada klaim skill telah
terdaftar dalam menu native. Pengujian aplikasi/provider/perangkat tetap
NOT_RUN. Audit historis §38 tidak menjadi bukti aplikasi atau workspace baru.

<a id="workspace-quality-traceability"></a>

## 40. Apps, panduan UI dan portabilitas

Sumber: [WORKSPACE-QUALITY-002](DECISIONS.md#workspace-quality-002).
§39 mencatat keadaan sebelumnya dengan lima skill; pada putaran 18 Oktober ini
menjadi enam skill dan enam rules. Riset dan hasil pada [WORKSPACE](WORKSPACE.md).

| Kebutuhan terbaru | Artefak / cara diperiksa |
|---|---|
| Rename project menjadi apps | [apps](../apps/README.md); rujukan aktif dan case path diperiksa |
| UI bersih, ikon standar | [DESIGN](DESIGN.md), [rule UI](../rules/ui.md), [skill UI](../skills/siagabanjir-ui/SKILL.md); kriteria konkret, belum UI berjalan |
| Lintas Windows/macOS/Linux | [portabilitas](../rules/portability.md), EditorConfig, Git attributes; uji runtime OS lain NOT_RUN |
| Lintas IDE/harness | [Matriks IDE](WORKSPACE.md#ide), AGENTS dan pengarah Claude/JetBrains; pemuatan IDE aktual NOT_RUN |
| Seluruh informasi terkait selalu mutakhir | [Dokumentasi](../rules/documentation.md), syarat selesai AGENTS dan semua skill |
| Kebersihan workspace | Tanpa source aplikasi/installer/tools/reports/cache aktif; server/app hanya penanda kosong |
| Baseline dan bukti historis tetap | Hash dokumen, kontrak, sesi/snapshot; hasil tercatat di [verifikasi](WORKSPACE.md#verifikasi) |

Pembaruan panduan ini tidak mengubah hasil TC produk/provider/perangkat atau
approval baseline. Dukungan menurut dokumentasi dipisahkan dari pengujian aktual.

<a id="workspace-skills-traceability"></a>

## 41. Audit dan adaptasi skill dari riset

Tanggal: 19 Oktober 2026. Sumber mandat:
[WORKSPACE-SKILLS-003](DECISIONS.md#workspace-skills-003).
§39–40 adalah keadaan putaran sebelumnya; saat ini delapan skill dan tujuh rules.

| Kebutuhan pengguna | Artefak dan batas bukti |
|---|---|
| Riset koleksi SKILLS milik pemilik | [Metode dan seleksi](SKILL-RESEARCH.md); 138 file diinventaris, 15 dibaca penuh dan 3 terpilih, bukan audit semua paket |
| Riset sumber terbaru yang sesuai stack/harness | Sumber resmi Agent Skills, OpenAI, Claude, Flutter dan W3C pada riset; tidak memasang katalog sebagai bundel |
| Tambah prosedur yang diperlukan | [Debug](../skills/siagabanjir-debug/SKILL.md), [verification](../skills/siagabanjir-verification/SKILL.md), [katalog delapan skill](../SKILL.md) |
| Perbaiki agent/rules/adapter | [AGENTS](../AGENTS.md), [riset](../rules/research.md), [CLAUDE](../CLAUDE.md); pemuatan IDE aktual NOT_RUN |
| UI bersih dan ikon standar | [DESIGN](DESIGN.md), UI/Flutter/review; alur aksi, state, aksesibilitas dan teks konkret, tanpa mengganti Material Icons |
| Uji cakupan skill dan mutu informasi | [Skenario positif/negatif](SKILL-RESEARCH.md#evaluasi); inspeksi statis dibedakan dari eksekusi agent |
| Jaga kebersihan dan informasi terkait | Gate dokumentasi, handoff dan [hasil verifikasi](WORKSPACE.md#verifikasi); tanpa source aplikasi/installer/reports/cache aktif |

Hasil pemeriksaan terbaru hanya menyimpulkan kondisi berkas yang diperiksa.
Baseline approved, 156 TC FRD, 24 TC-SRS dan kontrak tidak diubah oleh riset ini;
pengujian aplikasi/provider/perangkat tetap NOT_RUN. Native Codex BLOCKED oleh
izin lokasi, bukan kegagalan format SKILL.md atau permintaan approval baru.

<a id="workspace-reference-traceability"></a>

## 42. Adaptasi selektif referensi Software-BK

Mandat: [WORKSPACE-REFERENCE-004](DECISIONS.md#workspace-reference-004),
19 Oktober 2026. Bagian sebelumnya menyimpan hasil putaran terdahulu.

| Kebutuhan | Penerapan / bukti |
|---|---|
| Analisis proyek referensi tanpa menyalin semuanya | [Perbandingan dan cakupan](SKILL-RESEARCH.md#softwarebk); 16 berkas penuh, satu sebagian; folder aplikasi kosong |
| Tambah panduan yang belum jelas | [Peta sumber](WORKSPACE.md#sumber-acuan), [quality](../rules/quality.md), [apps/README](../apps/README.md) |
| Modifikasi sesuai stack dan fungsi sendiri | Client API bersama, SQL/DTO/kontrak dan ownership sesuai SRS; delapan skill tetap, tanpa model tenant sekolah atau JWT |
| Dukungan editor yang berguna | [extensions.json](../.vscode/extensions.json), [portabilitas](../rules/portability.md), matriks IDE; rekomendasi opsional, belum instalasi/uji client |
| Seleksi yang penting dan hindari duplikasi | Keputusan diterapkan/sudah tercakup/belum perlu/tidak cocok; tidak membuat katalog API, schema atau rules salinan |
| Dokumentasi konsisten dan batas bukti jelas | README/AGENTS/katalog/rules/lima skills, WORKSPACE/riset/keputusan dan handoff; [pemeriksaan terbaru](WORKSPACE.md#audit-softwarebk) |

Skenario SK-E15–SK-E18 menambah evaluasi referensi, arti perintah pemeriksaan,
task spekulatif dan konflik sumber. Inspeksi panduan bukan eksekusi agent.
Baseline approved dan seluruh TC aplikasi tetap pada status sebelumnya.

<a id="workspace-publish-traceability"></a>

## 43. Bacaan lengkap dan persiapan publikasi GitHub

Mandat [WORKSPACE-PUBLISH-005](DECISIONS.md#workspace-publish-005),
19 Oktober 2026. §39–42 menyimpan keadaan putaran sebelumnya.

| Kebutuhan terbaru | Penerapan / batas bukti |
|---|---|
| Seluruh konteks aktif dibaca sebelum bekerja | AGENTS, protokol workflow, katalog dan semua skills, adapter; tidak boleh mengklaim lengkap dari ringkasan/metadata |
| Living documents diperbarui otomatis oleh AI saat perubahan | Marker di Markdown aktif, matriks dokumentasi, gate penutupan dan template PR; bukan daemon/hook/CI |
| Petunjuk commit, push dan PR | [GITHUB-WORKFLOW](GITHUB-WORKFLOW.md), [.github template](../.github/pull_request_template.md); perintah mutasi belum dijalankan |
| Nilai arsip dan kontrak | Indeks arsip (lokal) ikut Git, isi mentah lokal diabaikan; OpenAPI/contoh tetap normatif dan utuh |
| Riset repo/skill terkini | [Sumber resmi dan keputusan](SKILL-RESEARCH.md#publikasi), kasus SK-E19–SK-E24; tidak memasang bundel |
| Nama dan deskripsi untuk pemilik push | [GITHUB-NOTES](GITHUB-NOTES.md); usulan, bukan repo yang telah dibuat |
| Calon repository mandiri dan rujukan valid | [Audit publikasi](WORKSPACE.md#audit-publikasi): file kandidat Git, tautan/anchor, format/skill, keutuhan baseline/arsip |

Perapian mengganti rujukan ke berkas privat dengan indeks yang dapat dibaca
pada clone. Identitas sumber serta kutipan historis tetap, hasil audit lama
tidak dijadikan bukti pemeriksaan baru. Approval baseline dan status TC produk
tetap. Pemeriksaan ini tidak membuktikan kepatuhan otomatis seluruh harness.

<a id="workspace-audit-push-traceability"></a>

## 44. Audit final setup dan publikasi melalui Git Bash

Mandat: [WORKSPACE-AUDIT-PUSH-006](DECISIONS.md#workspace-audit-push-006).
Bagian ?39?43 mempertahankan checkpoint historis; hasil terkini ada pada
[audit final](WORKSPACE.md#audit-final).

| Acuan / risiko | Perubahan dan bukti yang diperiksa |
|---|---|
| Protokol bacaan dan living documents | 52 file aktif awal dibaca penuh pada rangkaian tugas ini; snapshot sebelum edit dipakai untuk review karena repository belum memiliki commit |
| CI salah akar / sukses tanpa cakupan | Validator mencari root repository, memeriksa sumber wajib, mencetak cakupan; tes root hilang dan pemanggilan dari direktori lain |
| YAML rusak lolos pemeriksaan | Parser YAML aman, nilai metadata, nama folder dan key ganda; tes malformed/empty/non-string/duplicate/missing field |
| Tautan lintas OS | Tes path relatif/anchor, file hilang, kapitalisasi salah dan pengecualian sumber arsip privat |
| SRS-IF-004; FR-AUTH-002/003/005/006 | Replay signup 200 dihapus; signup/login/reset/rotasi memakai konflik 409 tanpa rahasia. Tes kontrak menolak pemulihan respons replay, konflik hilang dan recovery code dalam error |
| SRS-IF-002; perubahan kredensial | Respons 4XX merujuk Error; schema CredentialsUpdate ekuivalen untuk 11 kasus yang diperiksa; seluruh contoh lama dipertahankan. Tes kondisi reset kuota dan format tanggal/URI mencegah regresi; dependensi format yang hilang menggagalkan gate |
| Publikasi ke repo pemilik | Git Bash, staging sumber yang ditinjau, commit/push main, pencocokan SHA dan pemeriksaan CI pada commit terkait |

Tes validator/schema merupakan bukti statis. Status 156 TC FRD dan 24 TC-SRS
pada aplikasi tetap NOT_RUN; tidak ada bukti provider, perangkat, UI atau UAT
baru. Metadata BRD/PRD diperbarui agar tidak menyebut FRD/SRS masih draf;
requirement dan bukti approval historis tidak diganti.
