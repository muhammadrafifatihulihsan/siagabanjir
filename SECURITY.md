# Kebijakan Keamanan SiagaBanjir

> **Living document:** perbarui bersama setiap perubahan terkait menurut [aturan dokumentasi](rules/documentation.md#living-documents).

Keamanan data warga, keandalan informasi kebencanaan, dan integritas sistem adalah prioritas utama dalam perancangan SiagaBanjir. Dokumen ini menjelaskan kebijakan pelaporan dan penanganan celah keamanan (*vulnerability*) secara bertanggung jawab (*Responsible Disclosure*).

---

## 1. Versi yang Didukung

Pembaruan keamanan aktif hanya diberikan untuk versi rilis terbaru dan cabang pengembangan utama:

| Versi | Status Dukungan Keamanan | Catatan |
|---|---|---|
| `v0.2.x` | :white_check_mark: Didukung | Rilis fitur warga terkini |
| `main` | :white_check_mark: Didukung | Cabang stabil produksi |
| `development` | :white_check_mark: Didukung | Cabang integrasi pengembangan |
| `< v0.2.0` | :x: Tidak didukung | Versi rilis awal dokumentasi |

---

## 2. Cara Melaporkan Kerentanan

Jika Anda menemukan potensi celah keamanan pada aplikasi Flutter, arsitektur backend, atau kontrak API SiagaBanjir, mohon **JANGAN membuka issue publik di GitHub**.

Laporan privat dapat dikirimkan melalui saluran berikut:

1. **GitHub Private Vulnerability Reporting (Direkomendasikan):**
   * Masuk ke tab **Security** pada repositori [muhammadrafifatihulihsan/siagabanjir](https://github.com/muhammadrafifatihulihsan/siagabanjir).
   * Klik menu **Advisories** lalu pilih tombol **Report a vulnerability**.
2. **Email Pengelola Proyek:**
   * Kirimkan email ke: `muhammadrafifatihulihsan@gmail.com`
   * Gunakan subjek: `[SECURITY] Laporan Kerentanan SiagaBanjir - <Judul Singkat>`

### Informasi yang Perlu Disertakan

* Deskripsi rinci mengenai kerentanan yang ditemukan.
* Komponen yang terdampak (misalnya: Flutter Android, Web Admin, atau skema API).
* Langkah-langkah untuk mereproduksi masalah (*step-by-step reproduction*).
* Contoh *payload* atau bukti konsep (*proof of concept* / PoC) jika ada.
* Penilaian potensi dampak terhadap kerahasiaan (*confidentiality*), integritas (*integrity*), atau ketersediaan (*availability*) data warga.

---

## 3. Komitmen dan Waktu Tanggap Pengelola

Tim pengembang SiagaBanjir berkomitmen untuk menindaklanjuti laporan keamanan dengan itikad baik:

* **Konfirmasi Awal (Acknowledge):** Maksimal dalam waktu **48 jam** setelah laporan diterima.
* **Investigasi dan Penilaian Dampak:** Maksimal dalam waktu **5 hari kerja**.
* **Perbaikan dan Rilis Tambalan (Patch):** Perbaikan akan diuji dan dirilis pada patch versi berikutnya sesegera mungkin.
* **Pengungkapan Terkoordinasi (Coordinated Disclosure):** Publikasi rincian celah keamanan hanya akan dilakukan setelah perbaikan resmi tersedia dan teruji.

---

## 4. Ruang Lingkup Keamanan

Area prioritas perlindungan keamanan dalam proyek SiagaBanjir meliputi:

* **Data Pribadi Warga:** Pencegahan kebocoran identitas pelapor, lokasi pribadi, dan nomor kontak keluarga.
* **Brankas Dokumen Keluarga:** Perlindungan dokumen penting yang disimpan secara lokal pada perangkat warga.
* **Integritas Informasi Publik:** Pencegahan manipulasi data status banjir pada modul Pantau agar informasi yang disajikan kepada masyarakat tetap akurat dan dapat dipercaya.
