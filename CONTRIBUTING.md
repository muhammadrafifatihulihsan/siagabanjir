# Panduan Kontribusi SiagaBanjir

> **Living document:** perbarui bersama setiap perubahan terkait menurut [aturan dokumentasi](rules/documentation.md#living-documents).

Terima kasih atas minat Anda untuk berkontribusi pada proyek SiagaBanjir! Dokumen ini memberikan pedoman teknis dan tata kelola kontribusi agar seluruh proses pengembangan berjalan teratur, berkualitas, dan selaras dengan arsitektur proyek.

---

## 1. Kode Etik

Seluruh kontributor, anggota tim, dan pengelola diwajibkan untuk mematuhi [Pedoman Perilaku (Code of Conduct)](CODE_OF_CONDUCT.md). Kami berkomitmen menciptakan lingkungan kolaborasi yang aman, profesional, inklusif, dan saling menghormati.

---

## 2. Model Percabangan (Branching Model)

Pengembangan SiagaBanjir menerapkan alur kerja terstruktur dengan tiga tingkatan cabang permanen di GitHub:

1. **Branch Anggota:** `branch-rafi`, `branch-melia`, `branch-hasan` — Tempat masing-masing anggota tim mengembangkan fitur, perbaikan bug, atau dokumentasi.
2. **Branch Integrasi (`development`):** Cabang penggabungan seluruh pekerjaan tim untuk uji integrasi menyeluruh sebelum dinyatakan stabil.
3. **Branch Produksi (`main`):** Cabang rilis utama yang hanya memuat kode stabil dan teruji melalui Continuous Integration (CI).

```text
[branch-rafi / branch-melia / branch-hasan]
                  │
                  ▼ (Pull Request)
           [development]
                  │
                  ▼ (Pull Request)
                [main]
```

* Untuk alur praktis dan perintah Git cepat dengan `main` lokal, gunakan [docs/GIT-CEPAT.md](docs/GIT-CEPAT.md).
* Panduan langkah-demi-langkah dari *clone* sampai PR tersedia di [docs/GIT-UNTUK-PEMULA.md](docs/GIT-UNTUK-PEMULA.md).
* Kebijakan teknis lengkap dapat dibaca pada [docs/GITHUB-WORKFLOW.md](docs/GITHUB-WORKFLOW.md).

---

## 3. Konvensi Pesan Commit

Kami menerapkan format [Conventional Commits](https://www.conventionalcommits.org/) agar riwayat perubahan mudah dipahami dan otomatis tercermin pada [CHANGELOG.md](CHANGELOG.md).

Format pesan commit:

```text
<tipe>(<cakupan opsional>): <deskripsi singkat dalam kalimat aktif>

[penjelasan lebih rinci bila diperlukan]
```

Tipe commit yang umum digunakan:

* `feat:` Penambahan fitur baru (misal: `feat(pantau): tambah filter lokasi darurat`).
* `fix:` Perbaikan bug (misal: `fix(tts): turunkan rate narasi suara ke 0.5`).
* `docs:` Pembaruan atau penambahan dokumentasi (misal: `docs: sinkronisasi catatan rilis v0.2.0`).
* `test:` Penambahan atau perbaikan unit test / widget test.
* `refactor:` Restrukturisasi kode tanpa mengubah fungsionalitas eksternal.
* `chore:` Pemeliharaan dependensi, konfigurasi build, atau skrip CI.

---

## 4. Standar Kode dan Format

Sebelum melakukan commit, pastikan kode mematuhi standar penulisan proyek:

1. **Flutter / Dart:**
   * Jalankan pemformat kode otomatis: `dart format apps/siagabanjir`
   * Periksa analisis statis: `flutter analyze` pada direktori `apps/siagabanjir`
2. **Dokumentasi Markdown:**
   * Ikuti konfigurasi [.markdownlint.json](.markdownlint.json).
   * Setiap berkas dokumentasi aktif wajib mencantumkan penanda *living document*.
3. **EditorConfig:**
   * Repositori dilengkapi konfigurasi [.editorconfig](.editorconfig) untuk memastikan konsistensi indentasi (spasi), encoding UTF-8, dan *end-of-line* lintas sistem operasi.

---

## 5. Pengujian dan Validasi Lokal

Sebelum mengajukan perubahan ke branch remote, jalankan pengujian mandiri:

1. **Uji Aplikasi Flutter:**

   ```bash
   cd apps/siagabanjir
   flutter test
   ```

2. **Validasi Tautan Internal:**

   ```bash
   python -B -X utf8 .github/scripts/validate_links.py
   ```

3. **Pemeriksaan Status Git:**

   Pastikan tidak ada artefak build atau file sementara yang tertinggal:

   ```bash
   git status --porcelain=v1 --untracked-files=all
   ```

---

## 6. Prosedur Pengajuan Pull Request (PR)

1. Pastikan seluruh commit lokal telah tersimpan rapi dan di-*push* ke branch remote anggota Anda.
2. Buka Pull Request di GitHub menuju branch `development` (bukan langsung ke `main`).
3. Isi deskripsi PR dengan mematuhi template resmi di [.github/pull_request_template.md](.github/pull_request_template.md).
4. Pastikan seluruh *automated check* pada GitHub Actions (CI) berstatus hijau (PASS).
5. Minta *review* dari rekan tim atau pengelola repositori.

---

## 7. Melaporkan Masalah atau Tugas

Untuk mengajukan ide tugas, perbaikan bug, atau pelacakan pekerjaan tim, gunakan fitur GitHub Issues dengan template resmi yang tersedia di [.github/ISSUE_TEMPLATE/tugas.md](.github/ISSUE_TEMPLATE/tugas.md).
