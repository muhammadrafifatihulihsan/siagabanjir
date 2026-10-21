# Instruksi Audit dan Revisi GitHub Workflow SiagaBanjir

**Status:** Sumber mandat audit 21 Oktober 2026; persetujuan implementasi berikutnya dicatat di bawah.\
**Tanggal penyusunan:** 21 Oktober 2026\
**Repository:** <https://github.com/muhammadrafifatihulihsan/siagabanjir>\
**Pemilik dan maintainer utama:** `muhammadrafifatihulihsan` (Rafi)\
**Bahasa pekerjaan dan dokumentasi:** Indonesia, jelas dan profesional.

> **Instruksi tertinggi:** Mulai dalam mode **READ-ONLY**. Audit fakta dan kemampuan GitHub yang tersedia, sampaikan temuan serta rancangan perubahan, lalu **berhenti menunggu persetujuan eksplisit pemilik**. Jangan melakukan commit, push, merge, mengubah Settings, mengundang akun, mengaktifkan ruleset, mengubah secrets, membuat tag, atau mengubah file apa pun sebelum disetujui. Jangan mengaku sudah menerapkan proteksi jika yang dibuat baru dokumentasi atau YAML.
>
> **Living document:** pemeliharaan mengikuti [aturan dokumentasi](rules/documentation.md#living-documents).
> **Otorisasi lanjutan:** pemilik menyetujui implementasi dan push CI/dokumentasi
> ke branch-rafi setelah audit. Larangan perubahan awal dan STOP di bawah adalah
> urutan historis sebelum persetujuan tersebut, bukan permintaan persetujuan ulang.
> Settings/rulesets, undangan, merge, tag/release dan deploy belum diotorisasi.
> Hasil dan batas bukti: [laporan audit](docs/GITHUB-AUDIT.md).

## 1. Tujuan

Tugas Anda adalah mengaudit repository SiagaBanjir yang sudah ada dan menyusun rencana revisi Git, GitHub, GitHub Actions, security, onboarding, dan dokumentasi. Setelah pemilik menyetujui rencana dan tindakan spesifik, Anda boleh mengimplementasikan bagian yang disetujui, memvalidasi hasilnya, dan memperbarui seluruh dokumentasi terdampak.

Targetnya: satu repository bersama milik Rafi, tiga kontributor dengan branch permanen berdasarkan nama, satu branch integrasi, dan satu branch stabil. Tim berisi tiga orang dengan pengalaman Git/GitHub yang berbeda. Prosedur sehari-hari harus sederhana, tetapi branch penting harus dilindungi secara **teknis**, bukan hanya melalui kesepakatan lisan.

**Jangan mengubah model menjadi fork, branch per fitur, GitFlow standar, atau mengganti nama branch tanpa persetujuan.** Beri alternatif jika ada keterbatasan keamanan nyata, tetapi pertahankan keputusan pemilik sebagai baseline.

## 2. Konfigurasi branch yang sudah diputuskan

Nama branch berikut **persis** sebagaimana telah dibuat oleh pemilik:

| Branch | Pemilik pekerjaan / fungsi | Status yang diinginkan |
|---|---|---|
| `main` | Kode stabil, release/demo, dikendalikan Rafi | Permanen, tetap default branch |
| `development` | Integrasi kode dan pengujian gabungan | Permanen, terproteksi |
| `branch-rafi` | Area kerja Rafi | Permanen |
| `branch-melia` | Area kerja Melia | Permanen |
| `branch-hasan` | Area kerja Hasan | Permanen |

**Penting:** Gunakan `development`, **bukan** `develop`, dan `branch-rafi`, `branch-melia`, `branch-hasan`, bukan `rafi`, `melia`, `hasan`. Jangan membuat ulang lima branch yang sudah ada atau mengubah riwayatnya. Tabel branch yang diberikan pemilik menunjukkan kelimanya ada; verifikasi kembali kondisi live, commit SHA, default branch, dan ahead/behind sebelum bekerja.

### Alur kontribusi yang wajib dipertahankan

1. Semua anggota meng-clone **repository yang sama**, tidak melakukan fork untuk alur normal.
2. Rafi mengerjakan tugas pada `branch-rafi`; Melia pada `branch-melia`; Hasan pada `branch-hasan`.
3. Satu PR aktif per branch anggota adalah baseline untuk pemula. Jangan campurkan tugas yang sudah siap dengan tugas yang belum siap ke dalam PR yang sama.
4. Setiap anggota melakukan commit dan push hanya ke branch kerja yang ditetapkan dalam **kebijakan tim**.
5. Arah Pull Request pekerjaan: `branch-rafi` → `development`, `branch-melia` → `development`, `branch-hasan` → `development`.
6. Rafi mereview, memeriksa CI, memutuskan penerimaan PR, lalu melakukan merge yang sah ke `development`.
7. Rafi menguji integrasi aplikasi warga, admin web, backend, serta kontrak API pada `development`. Lulus CI dasar **bukan** bukti integrasi aplikasi sudah siap.
8. Bila stabil, Rafi membuat PR **`development` → `main`**, memeriksa checklist rilis dan hasil CI, lalu melakukan merge.
9. Sesudah merge, branch anggota **tidak dihapus**. Anggota memperbarui branch permanennya dari `development` agar pekerjaan berikutnya dimulai dari basis terbaru.
10. Jangan menganggap tiga PR harus digabung serentak. Penggabungan boleh bertahap berdasarkan kesiapan dan dependensi.

### Kebijakan sinkronisasi branch permanen

- Tentukan strategi merge yang konsisten dengan histori repository saat ini. Preferensi awal: **merge commit**, bukan squash, selama terbukti sesuai kebijakan repo.
- Untuk branch anggota yang semua commit-nya sudah masuk ke `development` melalui merge commit, prosedur yang dapat diuji adalah `git fetch origin` lalu `git merge --ff-only origin/development` ketika sedang berada di branch anggota. Jika fast-forward gagal, **jangan** gunakan `reset --hard`, force push, atau rebase yang mengubah histori bersama. Periksa graph dan konflik, laporkan ke maintainer.
- Jika merge method ternyata squash atau rebase, dokumentasikan metode sinkronisasi yang benar untuk kasus tersebut. Jangan menyalin prosedur yang hanya valid untuk merge commit.
- Bila anggota telah memulai pekerjaan baru sebelum menyinkronkan branch, selesaikan atau simpan pekerjaan secara aman lebih dahulu. Jangan menghapus pekerjaan yang belum di-merge.

## 3. Model hak akses dan keterbatasan teknis GitHub

### Harapan pemilik

- Hanya Rafi sebagai maintainer boleh menerima atau menggabungkan PR ke `development` dan `main`.
- Melia dan Hasan boleh membuat PR yang ditujukan ke `development` dari branch kerja masing-masing.
- Tidak boleh ada direct push, force push, deletion, atau merge tanpa otorisasi pada `main` dan `development`.
- `main` hanya menerima promosi dari `development` setelah integrasi dan pengujian dinyatakan selesai.
- Branch pribadi tidak boleh dirusak oleh developer lain, sejauh kemampuan paket dan jenis repository memungkinkan.
- Secret, token, kredensial, GitHub Actions dan rilis harus dilindungi.

### Larangan klaim keamanan palsu

GitHub repository milik **akun pribadi** hanya memiliki tingkat izin owner dan collaborator. Collaborator memiliki kemampuan menulis ke repository, sehingga **tidak otomatis terkunci hanya pada branch namanya**. Jangan mengklaim `branch-melia` eksklusif untuk Melia atau `branch-hasan` eksklusif untuk Hasan jika kontrol teknis seperti itu tidak bisa benar-benar diterapkan dan diuji. Jangan menyamakan *dilarang menurut SOP* dengan *ditolak oleh GitHub secara teknis*.

Demikian juga, collaborator mungkin masih **dapat membaca** `main` dan `development`, membuka halaman atau PR yang menargetkan `main`, dan berinteraksi dengan branch lain yang tidak diproteksi. Target realistis adalah **mencegah perubahan/merge yang tidak berwenang**, bukan menyembunyikan branch atau memastikan hanya PR ke `development` yang bisa **dibuka**. Jika dibutuhkan, buat pemeriksaan CI untuk **menolak merge** dari pasangan base/head yang tidak sah. Bedakan dengan pencegahan membuat PR.

### Tugas audit security yang wajib dijawab

Verifikasi dengan dokumen GitHub resmi yang terbaru **dan** UI/API akun yang relevan:

1. Apakah repository berada pada akun pribadi atau organisasi? Paket/plan dan visibilitas aktual?
2. Siapa collaborator, role mereka, dan apakah ada akses admin tambahan, deploy key, token, GitHub App, workflow permission, maupun bypass actor?
3. Apakah branch/tag rulesets tersedia dan benar-benar *enforced* pada plan saat ini?
4. Apakah `Restrict updates` pada branch ruleset dapat dipakai untuk menolak update/merge oleh collaborator, dengan bypass yang hanya mencakup pemilik (`Repository admins`), bukan `Write`?
5. Apakah bypass `For pull requests only` tersedia dan bekerja seperti yang dibutuhkan? Dokumentasi menyatakan mode ini tetap memungkinkan pelaku bypass menggabungkan PR tanpa memenuhi aturan pada ruleset tersebut. Karena itu, **jangan anggap PR-only bypass otomatis menjamin review dan CI tetap wajib**.
6. Apakah perlu dua ruleset yang saling melengkapi: satu untuk otorisasi update/merge, satu lagi untuk persyaratan PR, approval, dan CI tanpa bypass? Uji efek kombinasi dengan aman sebelum aktif permanen.
7. Apa yang benar-benar terjadi ketika Melia atau Hasan mencoba melakukan merge PR ke `development` dan `main`? Gunakan pengujian aman dengan akun dan persetujuan yang sah. Jangan melakukan merge tanpa sengaja.
8. Apakah GitHub bisa membatasi update pada `branch-melia` hanya untuk akun Melia dan `branch-hasan` hanya untuk akun Hasan pada konfigurasi personal repo ini? Jika tidak, tulis keterbatasannya secara eksplisit, lalu tawarkan opsi organisasi dengan peran/tim atau model fork sebagai alternatif, **tanpa memigrasikan otomatis**.
9. Apakah CODEOWNERS dengan akun Rafi sebagai code owner membantu persyaratan review, dan apa efeknya pada PR yang dibuat oleh Rafi sendiri? Jangan membuat kebuntuan approval.
10. Apakah GitHub App, PAT, Actions token, atau mekanisme otomatis bisa melewati branch ruleset? Audit jalur bypass ini.

**Jika hanya-owner-merge tidak bisa dijamin pada kondisi aktual, berhenti dan laporkan gap sebelum mengundang anggota atau mengaktifkan aturan.** Jangan menggantinya diam-diam dengan aturan yang hanya bersifat sosial.

## 4. Audit kondisi repository, tanpa perubahan

Baca dan petakan **file yang benar-benar ada**, jangan menganggap nama atau isi file lama masih sama:

- `AGENTS.md` dan setiap AGENTS di subdirektori, instruksi agent, skill, dan kebijakan repo.
- `README.md`, README aplikasi, instruksi setup Windows/Git Bash dan workspace.
- `docs/GITHUB-WORKFLOW.md`, `docs/WORKSPACE.md`, `docs/SESSION-HANDOFF.md`, `docs/DECISIONS.md`, `docs/VERSIONING.md`, `CHANGELOG.md`, dokumen SRS/PRD/FRD/BRD jika terkait.
- `.github/workflows/*.yml` / `*.yaml`, `.github/PULL_REQUEST_TEMPLATE*`, issue templates, CODEOWNERS, dependabot config, konfigurasi keamanan.
- `.gitignore`, `.gitattributes`, `.editorconfig`, konfigurasi package manager, lockfile, struktur `apps/`, `packages/`, docs API.
- Konfigurasi Flutter Android, Flutter Web, backend, database, environment, deployment apabila sudah tersedia.
- Branch list, commit SHA, ahead/behind, open PR, workflow run, required checks, tags, releases, default branch.
- Branch protection klasik yang mungkin tumpang tindih dengan rulesets.
- Permission Actions: `GITHUB_TOKEN`, default workflow permissions, fork policies, secrets, environments, workflow concurrency, auto-merge, delete head branches, allow merge methods.
- Potensi paparan rahasia, file `.env`, sertifikat Android, service-account JSON, token, API keys, data pengguna, credential di histori. **Jangan menyalin isi rahasia ke laporan.**

Dari percakapan sebelumnya ada indikasi bahwa CI hanya menjalankan checks untuk `main` dan dokumentasi masih mengarahkan PR ke `main`. **Perlakukan informasi lama sebagai petunjuk yang harus diverifikasi**, bukan fakta yang boleh langsung ditimpa.

Jika akses UI Settings/API repo privat tidak tersedia, tandai `BELUM DIVERIFIKASI`, berikan instruksi pengambilan bukti kepada pemilik, lalu tunggu. Jangan mengarang hasil audit.

## 5. Matriks keamanan yang harus diwujudkan atau diakui batasnya

Gunakan matriks ini sebagai spesifikasi untuk dievaluasi, bukan klaim kondisi saat ini.

| Aksi | Rafi | Melia | Hasan | Catatan audit |
|---|---|---|---|---|
| Baca `main` dan `development` | Ya | Ya | Ya | Repository bersama bukan branch rahasia |
| Push biasa ke `branch-rafi` | Ya | Dilarang SOP | Dilarang SOP | Uji apakah bisa ditegakkan teknis |
| Push biasa ke `branch-melia` | Dapat diperlukan untuk pemulihan | Ya | Dilarang SOP | Jangan klaim enforcement jika tidak ada |
| Push biasa ke `branch-hasan` | Dapat diperlukan untuk pemulihan | Dilarang SOP | Ya | Jangan klaim enforcement jika tidak ada |
| Direct push ke `development` | Tidak pada alur normal | Blokir teknis | Blokir teknis | Rafi pun prefer PR |
| Direct push ke `main` | Tidak pada alur normal | Blokir teknis | Blokir teknis | PR wajib |
| Buka PR ke `development` | Ya | Ya | Ya | Branch sumber wajib valid |
| Buka PR ke `main` | Hanya alur `development` → `main` | Mungkin bisa membuka | Mungkin bisa membuka | Batasi **merge**, bukan klaim UI pembuatan PR tidak mungkin |
| Merge PR ke `development` | Hanya Rafi | Harus ditolak teknis | Harus ditolak teknis | Verifikasi dengan akun berbeda |
| Merge PR ke `main` | Hanya Rafi | Harus ditolak teknis | Harus ditolak teknis | Verifikasi dengan akun berbeda |
| Force push / hapus `main`, `development` | Blokir kecuali break-glass terkontrol | Blokir | Blokir | Proteksi harus aktif |
| Ubah Settings/rulesets | Rafi | Tidak | Tidak | Verifikasi role dan bypass |
| Buat atau ubah tag rilis resmi | Rafi | Blokir | Blokir | Verifikasi target pola tag |

Jika suatu baris tidak dapat dicapai di paket/akun saat ini, laporkan `TIDAK TERPENUHI` beserta dampak dan opsi mitigasi. Jangan menandai aman hanya karena dokumennya berkata demikian.

## 6. Rancangan Rulesets untuk ditinjau, BUKAN langsung diaktifkan

### 6.1 `protect-main`

- Target **persis** branch `main`.
- Require pull request sebelum perubahan masuk.
- Block force pushes dan restrict deletions.
- Required checks berdasarkan **nama job aktual** GitHub Actions setelah pekerjaan pertama terbukti berhasil.
- Require conversation resolution bila sesuai kebutuhan review.
- Audit required approvals, code owner review, dan efek PR buatan Rafi sendiri.
- Kebijakan sumber PR: hanya `development` dalam repo yang sama yang boleh **di-merge** ke `main`, dilengkapi check verifikasi base/head jika perlu.
- Restrict updates atau pembatasan setara, untuk menolak merge/push collaborator selain maintainer, berdasarkan fitur yang terverifikasi.
- Jangan aktifkan `Require linear history` apabila repo memakai merge commit.
- Jangan membuka bypass bagi peran `Write` bila Melia/Hasan memiliki peran tersebut.

### 6.2 `protect-development`

- Target **persis** branch `development`.
- Require pull request, block force pushes, restrict deletions.
- Required checks yang benar-benar berjalan untuk PR menuju `development`.
- Hanya PR dari `branch-rafi`, `branch-melia`, `branch-hasan` pada repository yang sama yang dianggap sah dalam SOP normal. Pemeriksaan CI boleh menolak merge PR dari branch selain itu, tetapi tidak bisa mencegah orang menekan tombol membuka PR.
- Merge diputuskan Rafi. Validasi apakah ruleset dengan `Restrict updates` dan bypass admin terkontrol dapat menegakkannya.
- Perhatikan: nama `branch-melia` **bukan bukti** pelaku push itu Melia, karena collaborator dengan write access mungkin dapat menyunting branch tidak terproteksi.

### 6.3 `protect-release-tags`

- Periksa pola tag yang dipakai workflow release saat ini (`v*.*.*` atau lainnya).
- Restrict creations, updates, dan deletions sesuai kemampuan GitHub yang sudah diverifikasi.
- Batasi otorisasi pada pemilik. Pastikan pembuatan rilis tidak bisa dilakukan oleh collaborator via tag, workflow dispatch, PAT, atau GitHub App yang terlalu berizin.
- Validasi bahwa tag resmi menunjuk commit yang ada pada `main`; cocokkan workflow release dan dokumentasi versi.

### 6.4 Hindari dua kesalahan berbahaya

1. **Bypass PR-only bukan otomatis semua syarat CI tetap wajib.** Jika maintainer dapat melewati checks melalui bypass, rancang aturan terpisah yang tetap berlaku untuk semua, atau jelaskan batasnya. Jangan mengklaim kontrol kuat tanpa pengujian.
2. **Mengatur CODEOWNERS tidak otomatis menjamin hanya Rafi yang dapat menekan Merge.** Review approval dan hak untuk menjalankan merge adalah dua kontrol berbeda.

Susun aturan dalam bentuk tabel `nama ruleset | target | aturan | bypass actor/mode | kemampuan yang diuji | risiko | status`. Verifikasi UI GitHub aktual karena pilihan ruleset dapat berbeda menurut plan dan konfigurasi.

## 7. Rencana CI GitHub Actions

### Audit dan adaptasi tahap awal

1. Temukan workflow existing beserta job id, job display name, triggers, dan status terakhir.
2. Pertahankan pemeriksaan dokumentasi/kontrak/API/EditorConfig yang sudah valid.
3. Sesuaikan `push` dan `pull_request` untuk `main` **serta** `development`. Jangan ubah release hanya karena menambah branch integrasi.
4. Tambahkan pemeriksaan policy PR bila diperlukan, dengan aturan:
   - PR base `development`: head branch harus salah satu dari tiga branch kerja yang disetujui dan berasal dari repository yang sama.
   - PR base `main`: head branch harus **persis** `development` dan berasal dari repository yang sama.
   - Validasi aturan ini berjalan pada event `pull_request` dan tidak memberikan izin write/secrets tanpa kebutuhan.
   - Perlakukan pemeriksaan sebagai gate untuk **merge**, bukan security boundary untuk hak menulis branch orang lain.
5. Pilih required checks hanya setelah workflow run yang sebenarnya berhasil dan check-name tercatat dengan jelas. Nama job harus unik antarworkflow.
6. Hindari `paths`/`paths-ignore` yang menyebabkan required check tidak muncul pada PR tertentu. Audit `if:` dan `skip` yang dapat membuat check wajib tidak efektif.
7. Gunakan permission minimal, utamanya `contents: read` untuk job yang tidak butuh write. Audit `pull_request_target`, checkout kode PR tak tepercaya, token, secret, action eksternal, dan permission lintas-job.
8. Setelah aplikasi tersedia, bangun pemeriksaan Flutter (format/analyze/test), backend (lint/typecheck/test), dan tes kontrak/integrasi sesuai teknologi yang **benar-benar ada**. Jangan membuat command atau path fiktif.
9. Laporan CI harus membedakan **checks tersedia**, **checks dijalankan**, **checks lulus**, dan **cakupan integrasi belum diuji**.

### Strategi migrasi agar tidak deadlock

- Audit workflow saat ini dan existing ruleset terlebih dahulu.
- Rancang perubahan CI, pertimbangkan PR awal ke `main` apabila `development` belum memiliki workflow yang bisa menangani PR.
- Perbarui dan uji workflow di branch integrasi dengan urutan yang tidak mengunci repository.
- Aktifkan required checks **setelah** check muncul dan sukses untuk targetnya.
- Aktifkan pembatasan merge/push setelah jalur admin dan skenario pemulihan terbukti dapat digunakan.
- Jangan men-disable protections di repo aktif tanpa izin eksplisit dan rencana pemulihan.

## 8. SOP Git Bash Windows untuk pemula

Tulis panduan perintah yang benar, singkat, dan bisa disalin bagi Melia dan Hasan. Jelaskan perbedaan identitas commit dan autentikasi GitHub. Jangan meminta token/password mereka.

### Setup pertama kali

```bash
git --version
git clone https://github.com/muhammadrafifatihulihsan/siagabanjir.git
cd siagabanjir
git remote -v
git config --get user.name
git config --get user.email
git fetch origin
git branch -a
```

Setelah memastikan branch yang ditetapkan ada, anggota boleh menjalankan, misalnya untuk Melia:

```bash
git switch branch-melia
git status
```

Untuk Hasan gunakan `branch-hasan`; Rafi gunakan `branch-rafi`.

### Rutinitas sebelum mengerjakan tugas

```bash
git status
git fetch origin
git switch branch-melia
git pull --ff-only origin branch-melia
```

Sebelum mulai tugas baru, pastikan branch ini sudah tersinkron ke `development` dan PR sebelumnya telah selesai. Cara sinkronisasi perlu mengikuti kebijakan merge dan keadaan histori yang benar. Jangan menganggap `pull` dari branch sendiri sama dengan memperbarui basis dari `development`.

### Selesai satu tugas

```bash
git status
git add -- path/file-yang-benar-benar-diperiksa
git diff --cached
git diff --cached --check
git commit -m "feat: deskripsi singkat yang tepat"
git push origin branch-melia
```

Perintah `git add -- ...` adalah placeholder yang harus diganti file nyata. Jangan menyuruh pemula menjalankan `git add .` tanpa review perubahan, apalagi jika ada file `.env` atau credential.

Kemudian buat PR dengan **base `development`** dan **compare `branch-melia`**, isi deskripsi, bukti pengujian, serta batas pekerjaan. Minta Rafi review. Setelah merge, jangan delete branch permanen. Sinkronkan sesuai panduan yang telah divalidasi.

### Sertakan troubleshooting

Dokumentasikan dengan contoh untuk: branch belum ada secara lokal, belum login GitHub, `non-fast-forward`, unresolved conflict, detached HEAD, belum di-commit, PR tertinggal dari base, salah base branch, pemeriksaan CI gagal, PR ditolak ruleset, salah identitas email Git, dan bagaimana meminta bantuan Rafi.

**Larangan untuk pemula tanpa supervisi:** `git push --force`, `git reset --hard`, `git clean -fd`, rewrite history, delete branch permanen, langsung mengubah `main`/`development`, menyalin secret ke repository.

## 9. Audit dan revisi dokumentasi menyeluruh

Seluruh instruksi repository harus konsisten setelah revisi. Temukan **semua** referensi lama ke `develop`, alur PR ke `main`, branch per fitur/fork yang bertentangan dengan keputusan, lalu kategorikan:

- Teks yang **wajib diubah**.
- Teks yang tetap benar dan **harus dipertahankan**.
- Teks yang ambigu dan perlu konfirmasi.
- Instruksi tidak kompatibel pada agent, CI, dokumentasi, template PR, release, dan onboarding.

Jangan melakukan search-and-replace buta. Kata `development` di dokumen lain bisa bermakna tahap pengembangan, bukan nama branch. Gunakan konteks.

Minimal hasil dokumentasi mencakup:

1. **Sumber kebenaran workflow GitHub**, misalnya `docs/GITHUB-WORKFLOW.md`, memuat bagan alur, seluruh branch, aturan PR, merge, sinkronisasi dan keadaan darurat.
2. **Panduan anggota pemula**, termasuk cloning, Git Bash Windows, login, membuat PR, update branch, dan troubleshooting.
3. **Kebijakan keamanan dan batas teknis**, menjelaskan perbedaan aturan SOP dan enforcement GitHub.
4. **Checklist review & release**, termasuk bukti CI, integrasi, dokumentasi, dan kriteria promosi `development` → `main`.
5. **Dokumentasi AGENTS/skills**, bila relevan, agar agent selalu menggunakan branch dan prosedur terbaru serta memperbarui semua file terdampak setiap perubahan.
6. **`docs/DECISIONS.md`/ADR**, mencatat keputusan branch permanen per anggota, alasan, konsekuensi, mitigasi, dan keterbatasan.
7. **`docs/SESSION-HANDOFF.md`**, memuat status implementasi akurat, open work, risiko, dan langkah berikutnya.
8. **Template PR dan issue**, menuntun kontribusi ke `development`, kecuali PR promosi rilis.

Terapkan prinsip clean code, dokumentasi mutakhir, tidak ada duplikasi aturan yang saling bertentangan, dan tidak ada fitur/tes yang dinyatakan sudah tersedia jika belum dibuat. Jangan memodifikasi ruang lingkup produk aplikasi hanya karena sedang memperbaiki GitHub workflow.

## 10. Rencana security tambahan yang proporsional

Audit dan ajukan prioritas untuk:

- Least-privilege pada GitHub Actions `GITHUB_TOKEN` dan workflow permission.
- Secret scanning dan push protection yang tersedia dalam plan, jangan mengklaim tersedia tanpa verifikasi.
- Dependabot alerts dan dependensi yang dapat dipindai.
- `.gitignore` dan contoh `.env.example` tanpa secret asli.
- Izin deploy key, GitHub Apps, PAT, reusable workflows, dispatch dan manual triggers.
- Review perubahan `.github/workflows/`, CODEOWNERS, konfigurasi CI, Dockerfile, script build, dependency lockfile, dan file berisiko tinggi.
- Keamanan deployment/release, verifikasi commit SHA/tag dan penyimpanan artifact.
- Audit log dan bukti persetujuan perubahan pengaturan, sejauh tersedia.
- Risiko collaborator sengaja/tidak sengaja mengubah branch anggota lain, serta mitigasi berupa audit commit, review dan kebijakan tim.

Tidak perlu menambahkan layanan berbayar, security scanner berlebihan, atau konfigurasi enterprise tanpa analisis manfaat, biaya, dan persetujuan.

## 11. Format laporan audit pertama, sebelum mengubah apa pun

Sampaikan output secara berurutan:

### A. Executive summary

Ringkas keadaan aktual, kesiapan migrasi, dan hal yang menghambat security yang diminta.

### B. Inventory berbukti

Tabel `komponen | kondisi aktual | sumber bukti (file:path:line / URL / konfigurasi) | confidence | dampak`. Jangan menulis status terverifikasi tanpa sumber.

### C. Gap analysis

Tabel `requirement | aktual | target | gap | tingkat risiko | mitigasi | bisa ditegakkan teknis?`. Pisahkan `TERPENUHI`, `BELUM TERPENUHI`, `PERLU PENGUJIAN`, dan `TIDAK DIDUKUNG`.

### D. Security feasibility report

Jelaskan secara eksplisit dan spesifik:

- Apakah Melia dan Hasan tidak dapat direct push atau merge ke `main` dan `development`.
- Apakah hanya Rafi yang dapat melakukan merge.
- Apakah GitHub tetap memungkinkan pembuatan PR ke `main` meski PR tidak dapat di-merge.
- Apakah pembatasan push hanya ke branch nama masing-masing dapat ditegakkan di repo personal.
- Potensi bypass ruleset, termasuk PR-only bypass.
- Peran CODEOWNERS, required review, required checks dan batas masing-masing.

### E. Usulan konfigurasi yang dapat dieksekusi

Tabel rinci tiap ruleset beserta target, aturan, bypass, status penerapan, dan langkah pembuktian. Sertakan draft CI diff, file dokumentasi yang berubah, dan risiko locking-out.

### F. Urutan implementasi aman

Per langkah: prasyarat, tindakan, validasi, rollback, apakah butuh persetujuan GitHub UI, dan perkiraan blast radius. Tidak boleh mengarang hasil uji.

### G. Daftar keputusan yang masih perlu dikonfirmasi

Tanyakan **hanya** keputusan yang memang belum disepakati atau memiliki konsekuensi nyata. Opsi terbaik boleh direkomendasikan, tetapi jangan mengambil alih keputusan owner.

### H. STOP

Tutup laporan dengan kalimat: **"Audit selesai. Belum ada perubahan repository atau GitHub Settings. Menunggu persetujuan Rafi atas langkah implementasi yang dipilih."**

## 12. Ketentuan setelah pemilik menyetujui implementasi

Lakukan perubahan **berurutan dan terpisah berdasarkan persetujuan**, bukan satu operasi besar yang mengaburkan perubahan dan risiko.

1. Catat baseline SHA seluruh lima branch, kondisi ruleset, workflow, PR, dan pemegang izin sebelum mengubah apa pun.
2. Gunakan branch dan PR yang disetujui untuk perubahan kode/dokumen; jangan direct push ke `main` atau `development`.
3. Lakukan pemeriksaan teknis lokal yang relevan dan jalankan CI untuk PR nyata.
4. Aktifkan ruleset secara bertahap, pastikan jalur merge resmi masih bekerja dan tidak ada deadlock.
5. Uji skenario negatif dengan akun yang berizin dan persetujuan eksplisit: direct push collaborator ke branch terlindungi harus ditolak, force push/delete harus ditolak, merge oleh collaborator harus ditolak, PR tak sah harus tidak bisa di-merge. Gunakan **tes non-destruktif**, jangan mengorbankan branch produksi untuk pengujian.
6. Uji skenario positif: anggota boleh push ke branch kerjanya, membuat PR ke `development`, CI berjalan, Rafi dapat merge melalui prosedur resmi, lalu PR `development` ke `main` dapat melewati pemeriksaan.
7. Jika hasil tidak cocok target, tandai FAILED, hentikan tahap lanjut, lakukan rollback **hanya berdasarkan rencana yang telah disetujui**.
8. Dokumentasikan bukti yang benar: URL PR, workflow run, status ruleset, perilaku akun uji, tanggal, SHA, dan siapa yang menyetujui.
9. Pastikan setiap perubahan dokumentasi ikut commit dan mengikuti aturan agent aktif. Hapus kontradiksi agar semua instruksi selalu mutakhir.
10. Akhiri dengan laporan implementasi `SELESAI / PARSIAL / BELUM DITERAPKAN` untuk **setiap** kontrol, bukan satu klaim “aman” secara umum.

## 13. Batasan tindakan dan anti-asumsi

- Jangan hapus, rename, reset, force-push, squash, rebase, atau recreate branch permanen tanpa izin spesifik.
- Jangan mengubah default branch `main`.
- Jangan membuat fork atau memindahkan repository ke organization tanpa keputusan baru.
- Jangan mengundang Melia/Hasan atau menebak username GitHub mereka.
- Jangan mengubah aturan release, credential, secret, tag atau deployment tanpa perubahan yang disetujui.
- Jangan mengira commit author `user.name` sama dengan akun yang sedang autentikasi.
- Jangan mengklaim CODEOWNERS, required review, atau CI bisa membatasi repository write-permission di branch lain.
- Jangan menganggap UI GitHub sama untuk setiap paket atau plan, lakukan verifikasi.
- Jangan membuat file boilerplate fiktif, job CI yang belum memiliki tools, atau test palsu.
- Jangan menuntaskan audit dengan pertanyaan umum bila sumber tersedia; lakukan audit maksimal dahulu, baru ajukan pertanyaan yang belum terjawab.
- Kegagalan akses bukan bukti fitur tidak ada. Tandai dengan jujur dan minta bukti spesifik.

## 14. Referensi resmi GitHub untuk validasi

Periksa lagi relevansi dokumentasi pada tanggal eksekusi:

1. Repository personal account dan collaborator: <https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/repository-access-and-collaboration/permission-levels-for-a-personal-account-repository>
2. Mengelola akses collaborator: <https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/repository-access-and-collaboration>
3. Rulesets dan ketersediaan: <https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/about-rulesets>
4. Membuat rulesets dan bypass modes: <https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/creating-rulesets-for-a-repository>
5. Aturan `Restrict updates`, PR, dan checks: <https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/available-rules-for-rulesets>
6. Branch protection, approval, dan pembatasannya: <https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches>
7. Workflow syntax: <https://docs.github.com/en/actions/reference/workflows-and-actions/workflow-syntax>
8. Secure GitHub Actions: <https://docs.github.com/en/actions/security-for-github-actions/security-guides/security-hardening-for-github-actions>

---

## Instruksi mulai

**Mulai sekarang hanya Tahap Audit READ-ONLY.** Baca semua instruksi agent dan file relevan, inventarisasi repository aktual, cocokkan semua lima branch yang sudah ada, lakukan feasibility check kontrol GitHub personal repository, lalu hasilkan laporan A sampai H. Jangan membuat perubahan apa pun sebelum persetujuan Rafi. Jika tidak memiliki akses langsung ke Settings, berikan daftar bukti spesifik yang perlu pemilik kirimkan dan gunakan label `BELUM DIVERIFIKASI`.
