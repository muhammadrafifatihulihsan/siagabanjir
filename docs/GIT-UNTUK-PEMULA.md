# Panduan Git tim: dari clone pertama sampai PR berikutnya

> **Living document:** perbarui bersama setiap perubahan terkait menurut [aturan dokumentasi](../rules/documentation.md#living-documents).

Untuk perintah ringkas dengan **main lokal**, gunakan [GIT-CEPAT.txt](GIT-CEPAT.txt).
Clone branch anggota lalu rename lokal menjadi main; upstream tetap
`origin/branch-melia`, `origin/branch-hasan`, atau `origin/branch-rafi`.
Push memakai refspec eksplisit, misalnya `git push origin main:branch-melia`.
Nama branch dalam alur PR merujuk branch **GitHub**; main/development remote
tetap menerima perubahan melalui PR. Langkah panjang di bawah adalah alternatif
dengan nama branch lokal sama dengan branch anggota; pilih satu alur, jangan campur.

Panduan ini untuk Rafi, Melia, dan Hasan yang sudah punya Git dan akun GitHub.
Ikuti langkah sesuai keadaanmu. **Clone cukup sekali per folder kerja. Besoknya
gunakan folder yang sama dan ambil pembaruan dengan Git.**

Aturan tim tetap bersumber pada [GITHUB-WORKFLOW](GITHUB-WORKFLOW.md).
Dokumen ini menyajikan urutan praktiknya dalam satu tempat. Jika aturan branch,
merge, atau versi alat berubah, contoh di sini harus ikut diperbarui.

## 1. Cara memakai panduan

Gunakan **Git Bash di Windows**, atau Bash di macOS/Linux. Blok `bash` di sini
tidak untuk ditempel langsung ke PowerShell/CMD. Di Windows, buka folder lewat
File Explorer lalu pilih **Open Git Bash here** (bisa berada di Show more options).
Di VS Code, pilih profil terminal Git Bash dan buka folder root proyek.

Salin perintah satu per satu, tekan Enter, dan baca hasilnya sebelum lanjut.
Jika ada error, berhenti di langkah itu dan lihat [penanganan masalah](#masalah).
Teks contoh nama, email, path file, dan pesan commit perlu diganti sesuai tugas;
URL repository sudah benar dan bisa langsung dipakai. Jika tampilan diff/log
memenuhi layar, tekan `q` untuk kembali ke terminal.

| Keadaanmu | Mulai dari |
|---|---|
| Belum ada folder proyek di komputer | [Clone pertama](#clone-pertama) |
| Folder proyek sudah ada, ingin kerja lagi | [Rutinitas harian](#harian) |
| Perubahan sudah selesai | [Periksa dan commit](#commit), lalu [push dan PR](#pull-request) |
| Rafi meminta revisi PR | [Revisi PR](#revisi) |
| PR sudah merged | [Sesudah merge](#sesudah-merge) |
| Pindah laptop atau perlu folder clone baru | [Clone lagi](#clone-lagi) |

Alur tim:

```text
branch-rafi  ─┐
branch-melia ─┼─ PR → development ─ PR promosi oleh Rafi → main
branch-hasan ─┘
```

| Orang | Branch kerja | Tujuan PR pekerjaan |
|---|---|---|
| Rafi | branch-rafi | development |
| Melia | branch-melia | development |
| Hasan | branch-hasan | development |

Semua memakai repository yang sama; tidak perlu fork atau branch fitur baru.
Satu PR aktif per branch anggota. Rafi memutuskan merge dengan **Create a merge
commit**. Kelima branch permanen tidak dihapus. Nama branch adalah pembagian
kerja tim; bukan jaminan GitHub membatasi akses setiap orang ke branch itu saja.

| Istilah | Artinya |
|---|---|
| Clone | Membuat salinan repository beserta riwayatnya di folder baru |
| Origin | Nama remote GitHub yang dibuat saat clone |
| Fetch | Mengambil informasi/commit remote tanpa mengubah file kerja |
| Pull | Mengambil pembaruan dan memasukkannya ke branch yang sedang dibuka |
| Stage / add | Memilih perubahan yang akan dicatat dalam commit |
| Commit | Menyimpan riwayat perubahan secara lokal; belum mengirim ke GitHub |
| Push | Mengirim commit ke branch di GitHub; belum menggabungkannya ke development |
| Pull request / PR | Meminta review dan penggabungan perubahan ke branch tujuan |
| Merge | Menggabungkan riwayat; pada PR tim dilakukan Rafi sesudah review |

<a id="clone-pertama"></a>

## 2. Pertama kali: ambil proyek dan pilih branch

### 2.1 Pastikan akses dan lokasi

Login GitHub di browser dengan akun sendiri. Untuk push ke repository bersama,
akunmu harus diberi akses oleh Rafi dan undangannya sudah diterima. Berhasil
membaca atau clone repository publik belum membuktikan kamu punya akses push.

Buka Git Bash pada **folder induk** tempat proyek akan disimpan. Contoh berikut
membuat folder induk `proyek-kuliah` di home pengguna pada ketiga OS:

```bash
git --version
mkdir -p ~/proyek-kuliah
cd ~/proyek-kuliah
pwd
ls
```

Jika sudah ada `siagabanjir`, jangan menimpanya. Periksa apakah itu clone yang
akan dipakai melalui [rutinitas harian](#harian). Jika belum ada, jalankan:

```bash
git clone https://github.com/muhammadrafifatihulihsan/siagabanjir.git
cd siagabanjir
git rev-parse --show-toplevel
git remote -v
```

Hasil root harus menunjuk folder `siagabanjir` yang baru dibuat. Remote `origin`
untuk fetch/push harus mengarah ke `muhammadrafifatihulihsan/siagabanjir`.
Jangan menjalankan `git init` lagi atau memakai unduhan ZIP sebagai pengganti clone.

### 2.2 Periksa identitas commit

```bash
git config --get user.name
git config --get user.email
```

Jika hasil sudah milikmu dan benar, lanjut. Jika kosong atau salah, **kamu sebagai
pemilik komputer** mengisi identitas untuk clone ini. Ganti kedua contoh sebelum
menjalankan:

```bash
git config --local user.name "Nama Kamu"
git config --local user.email "email-kamu-di-github@example.com"
git config --get user.name
git config --get user.email
```

Gunakan email yang kamu pilih untuk commit, misalnya email GitHub atau alamat
noreply yang ditampilkan pada pengaturan email akunmu. `--local` hanya berlaku
pada clone ini. **Identitas commit bukan login GitHub**; mengganti nama/email
tidak memberikan izin push. AI tidak boleh mengarang identitasmu.

### 2.3 Pilih branch milikmu

```bash
git fetch origin
git branch -a
```

Pastikan `remotes/origin/branch-melia`, `branch-hasan`, atau `branch-rafi` milikmu
terlihat. Salin **hanya satu** pilihan berikut sesuai orangnya:

Melia:

```bash
BRANCH=branch-melia
```

Hasan:

```bash
BRANCH=branch-hasan
```

Rafi:

```bash
BRANCH=branch-rafi
```

`BRANCH` adalah variabel terminal agar perintah berikutnya sama bagi semua orang.
**Ulangi pilihan ini setiap membuka terminal baru.** Selanjutnya:

```bash
git switch "${BRANCH:?Pilih BRANCH milikmu dahulu}"
git branch --show-current
git status --short --branch
```

Hasil branch harus sesuai namamu. Git biasanya langsung membuat branch lokal
yang mengikuti branch remote tersebut. Jika tidak, dan branch lokal memang belum
ada tetapi `origin/branch-...` milikmu terlihat, jalankan:

```bash
git switch --track "origin/${BRANCH:?Pilih BRANCH milikmu dahulu}"
```

Jika branch remote tidak ditemukan, berhenti dan hubungi Rafi; jangan membuat
branch pengganti dengan nama berbeda. Sebelum tugas pertama, jalankan langkah
[harian](#harian) untuk memeriksa basis development.

<a id="harian"></a>

## 3. Setiap mulai kerja: buka clone lama dan ambil pembaruan

Kalau mengikuti lokasi contoh tadi:

```bash
cd ~/proyek-kuliah/siagabanjir
git rev-parse --show-toplevel
git status --short --branch
git status --porcelain=v1 --untracked-files=all
```

Jika lokasi berbeda, buka Git Bash langsung dari folder clone milikmu.
Perintah status terakhir harus berhasil **tanpa keluaran** sebelum pindah branch
atau sinkronisasi. `M`, `A`, `D`, dan `??` menandakan perubahan/file baru yang
perlu diperiksa. Selesaikan perubahan tugasmu lewat [commit](#commit); jangan
membuang atau memasukkan pekerjaan orang lain agar status terlihat bersih.

Pilih lagi satu baris `BRANCH=...` milikmu dari §2.3, lalu:

```bash
git fetch origin
git switch "${BRANCH:?Pilih BRANCH milikmu dahulu}"
git branch --show-current
git pull --ff-only origin "${BRANCH:?Pilih BRANCH milikmu dahulu}"
```

`Already up to date` berarti tidak ada pembaruan dari **branch sendiri**.
Itu belum berarti perubahan teman di `development` ikut masuk.

**Jika melanjutkan revisi PR aktif:** lanjutkan tugas PR tersebut; jangan campurkan
tugas baru yang tidak terkait. Bila butuh perubahan development saat PR masih
aktif, koordinasikan penggabungannya dengan Rafi.

**Jika memulai tugas baru:** pastikan tidak ada PR aktif dari branch sendiri dan
seluruh commit pekerjaan sebelumnya sudah masuk development. Periksa:

```bash
git log --oneline origin/development..HEAD
```

Tidak boleh ada commit yang tercetak. Jika ada, periksa PR/commit tersebut dengan
Rafi; jangan menganggapnya hilang hanya karena PR berstatus Closed. Jika kosong:

```bash
git merge --ff-only origin/development
git status --porcelain=v1 --untracked-files=all
```

Fast-forward memajukan branchmu ke basis tim tanpa membuat ulang riwayat.
Jika ditolak, berhenti dan lihat [masalah](#masalah). Setelah berhasil, buka root
proyek di editor, baca tugas dan dokumentasi terkait, lalu kerjakan satu tujuan.
Pembaruan basis ini dapat dipush bersama commit tugas setelah pemeriksaan.

Backend dan Flutter saat panduan ini dibuat masih kosong. Setup/run aplikasi
mengikuti [README apps](../apps/README.md) dan README proyek aktual setelah tim
menginisialisasinya; clone sendiri tidak memasang SDK atau menjalankan aplikasi.

<a id="commit"></a>

## 4. Selesai satu perubahan: periksa, pilih file, lalu commit

Simpan file di editor. Periksa branch dan isi perubahan:

```bash
git branch --show-current
git status --short
git diff --stat
git diff
git diff --cached
```

Pastikan branch milikmu. Buka juga file `??` di editor karena file baru belum
terlihat dalam `git diff`. Perbarui dokumentasi terdampak dan CHANGELOG sesuai
aturan proyek. Jangan ikutkan `.env`, token, data pribadi, arsip percakapan,
dependensi, atau hasil build.

Jalankan pemeriksaan sesuai perubahan. Sebelum push, seluruh gate pada
[§5](#validasi) harus lulus, beserta pemeriksaan aplikasi terdampak yang tersedia.
Sesudah itu pilih file **yang benar-benar kamu ubah dan tinjau**. Contoh berikut
hanya untuk tugas yang mengubah README dan CHANGELOG; ganti path sesuai hasil
`git status`, jangan menambahkan file contoh yang tidak terkait:

```bash
git add -- README.md CHANGELOG.md
git diff --cached --stat
git diff --cached
git diff --cached --check
```

Jika salah memilih file, keluarkan dari staging tanpa menghapus isi kerjanya
dengan `git restore --staged -- nama-file`, setelah mengganti nama-file yang tepat.
Jangan gunakan `git add .` atau `git add -A` sebagai kebiasaan tanpa review.

Jika seluruh isi staged benar, ganti pesan contoh sesuai perubahan nyata:

```bash
git commit -m "docs: perjelas petunjuk memulai proyek"
git status --porcelain=v1 --untracked-files=all
git log -1 --oneline
```

Status terakhir harus kosong. Jika masih ada perubahan tugas, tinjau dan commit
perubahan tersisa; jangan menyebut pekerjaan selesai saat masih kotor. Jika
`nothing to commit`, periksa `git log -1`: AI mungkin sudah membuat commit.
Tidak perlu commit kosong. Commit menyimpan pekerjaan lokal dan bisa dilakukan
tanpa internet; **belum berarti pekerjaan sudah masuk GitHub**.

AI pada proyek ini wajib commit lokal tiap unit selesai tanpa menunggu diminta
lagi. Push tetap memerlukan mandat. Jika memakai AI, contoh permintaan:

> Baca AGENTS.md dan semua sumber wajib. Kerjakan tugas yang saya jelaskan,
> perbarui dokumentasi terdampak, jalankan pemeriksaan, lalu commit lokal dan
> pastikan tree bersih. Laporkan branch, SHA, dan hasil tes. Jangan push dulu.

<a id="validasi"></a>

## 5. Pemeriksaan sebelum push

### 5.1 Persiapan alat pada setiap clone baru

Gate workspace menggunakan Python 3.10+ (CI 3.12), Node 24, dan EditorConfig
Checker 4.0.2. Periksa ketersediaan:

```bash
python --version
node --version
npx --version
editorconfig-checker --version
```

Jika belum tersedia, siapkan alat tersebut bersama Rafi sebelum melanjutkan
gate. EditorConfig Checker tersedia pada [rilis resmi 4.0.2](https://github.com/editorconfig-checker/editorconfig-checker/releases/tag/v4.0.2);
pilih binary OS/arsitektur yang sesuai dan pastikan perintahnya tersedia.
Jangan memasukkan binary alat ke commit. Pada macOS/Linux yang memakai nama
`python3`, gunakan `python3 -m venv .venv` pada langkah pembuatan berikut.

Dari root clone, buat environment Python **sekali**, jika `.venv` belum ada:

```bash
python -m venv .venv
```

Aktifkan pada setiap terminal yang akan dipakai memvalidasi. **Pilih satu**:

Windows Git Bash:

```bash
source .venv/Scripts/activate
```

macOS/Linux Bash:

```bash
source .venv/bin/activate
```

Pasang dependensi terisolasi setelah pembuatan environment, dan ulangi jika
file requirements berubah setelah pull:

```bash
python -m pip install -r .github/requirements-validation.txt
```

### 5.2 Gate berulang

Jalankan dari root repository dengan environment aktif. `npx` dapat mengunduh
versi alat yang dikunci pada pemakaian pertama dan membutuhkan internet.

```bash
python -B -X utf8 .github/scripts/validate_links.py
python -B -X utf8 .github/scripts/validate_skills.py
python -B -X utf8 .github/scripts/validate_contracts.py
python -B -X utf8 -m unittest discover -s .github/scripts -p 'test_*.py'
npx -y markdownlint-cli2@0.17.2 --config .markdownlint.json '**/*.md' '#**/codex-session-*.md' '#archive/**'
npx -y @redocly/cli@2.64.1 lint docs/openapi.json --config .redocly.yaml
editorconfig-checker
git diff --check
```

EditorConfig memeriksa file tracked; jalankan sesudah file baru distage atau
dicommit agar tercakup. Jika menjalankan sebelumnya, berikan path file baru
secara eksplisit. Perbaiki setiap kegagalan, periksa ulang bagian terdampak,
dan commit koreksi sebelum push. Hasil yang belum dijalankan ditulis NOT_RUN.
Gate dokumen tidak menggantikan tes backend/Flutter, provider, atau perangkat.
Perintah aplikasi mengikuti README aktual tim. Acuan versi/perintah kanonis:
[validasi workspace](GITHUB-WORKFLOW.md#otomatisasi-cicd).

<a id="pull-request"></a>

## 6. Kirim commit ke GitHub dan buat pull request

### 6.1 Push branch sendiri

Pastikan gate lulus dan branch saat ini sama dengan nilai `BRANCH` milikmu:

```bash
git branch --show-current
printf '%s\n' "${BRANCH:?Pilih BRANCH milikmu dahulu}"
git status --porcelain=v1 --untracked-files=all
git push origin "${BRANCH:?Pilih BRANCH milikmu dahulu}"
git rev-parse HEAD
git ls-remote origin "refs/heads/${BRANCH:?Pilih BRANCH milikmu dahulu}"
```

Status harus kosong sebelum push. Setelah push berhasil, SHA dari dua perintah
terakhir harus sama. `Everything up-to-date` berarti tidak ada commit baru untuk
dikirim. Jika push gagal, commit lokal tetap ada; jangan commit ulang untuk
mencoba memperbaiki login/jaringan.

Saat Git meminta autentikasi HTTPS, selesaikan login akunmu melalui Git
Credential Manager yang tersedia. Pada Windows, GCM disertakan Git for Windows
dan dapat membuka browser untuk login/2FA. Login browser biasa belum tentu
menjadi login terminal. Jika mekanismenya belum tersedia, ikuti
[panduan autentikasi resmi GitHub](https://docs.github.com/en/get-started/git-basics/caching-your-github-credentials-in-git)
bersama Rafi; jangan menempelkan token/password ke URL, chat, atau file proyek.

### 6.2 Buat PR lewat browser

1. Buka [daftar PR repository](https://github.com/muhammadrafifatihulihsan/siagabanjir/pulls).
   Jika sudah ada PR Open/Draft dari branchmu, gunakan PR itu; push tadi otomatis
   memperbaruinya. Jangan buat PR kedua untuk branch yang sama.
2. Jika belum ada, buka tautan sesuai namamu di bawah. Bisa juga memakai
   **Compare & pull request** setelah push.
3. Pastikan repository tujuan dan sumber sama, **base `development`**,
   **compare branch milikmu**. Base adalah tujuan; compare adalah asal perubahan.
4. Periksa daftar commit dan Files changed. Jika ada tugas lain atau perubahan
   yang tidak kamu kenali, berhenti dan koordinasikan dengan Rafi.
5. Isi judul yang konkret dan seluruh bagian template PR: masalah/hasil,
   dokumentasi, pemeriksaan aktual, branch/SHA, dan keterbatasan. Jika template
   tidak muncul, salin [template repository](../.github/pull_request_template.md).
   Jangan mencentang tes atau bacaan yang belum dilakukan.
6. Klik **Create pull request** bila siap direview; gunakan **Create draft pull
   request** bila belum siap dan jelaskan yang tersisa. Minta review Rafi melalui
   pilihan Reviewers bila tersedia, atau bagikan URL PR kepada Rafi.

| Anggota | Tautan membuat PR ke development |
|---|---|
| Melia | [development ← branch-melia](https://github.com/muhammadrafifatihulihsan/siagabanjir/compare/development...branch-melia?expand=1) |
| Hasan | [development ← branch-hasan](https://github.com/muhammadrafifatihulihsan/siagabanjir/compare/development...branch-hasan?expand=1) |
| Rafi | [development ← branch-rafi](https://github.com/muhammadrafifatihulihsan/siagabanjir/compare/development...branch-rafi?expand=1) |

Tunggu checks pada revisi terbaru: **Validasi Arah PR**, **Validasi Dokumentasi**,
**Validasi Kontrak API**, dan **Cek Format EditorConfig**. Jika gagal, buka Details
atau tab Checks, baca langkah error, perbaiki lokal, lalu commit dan push lagi.
Jangan menganggap checks hijau menggantikan review Rafi atau tes aplikasi.

Rafi yang memutuskan dan melakukan merge; anggota tidak menekan Merge sendiri.
SOP ini tidak menyatakan proteksi Settings sudah aktif. Bukti terakhir dan gap
kontrol tersedia pada [audit GitHub](GITHUB-AUDIT.md). Alur UI dan pembaruan PR
dari commit tambahan mengikuti [dokumentasi resmi pembuatan PR](https://docs.github.com/en/pull-requests/how-tos/create-pull-requests/creating-a-pull-request),
ditinjau 21 Oktober 2026.

<a id="revisi"></a>

## 7. Jika PR diminta diperbaiki

Gunakan folder dan branch yang sama. Jalankan [rutinitas harian](#harian) untuk
melanjutkan PR aktif, baca komentar Rafi, perbaiki, jalankan pemeriksaan, lalu
ikuti [commit](#commit) dan [push](#pull-request). **Tidak perlu clone lagi atau
membuat PR baru.** Commit baru masuk ke PR yang masih terbuka secara otomatis.

Balas komentar dengan perubahan yang dilakukan dan hasil pemeriksaan. Periksa
checks SHA terbaru. Jangan mulai tugas lain di branch itu selama PR masih aktif
karena push tugas baru akan ikut mengubah PR tersebut.

<a id="sesudah-merge"></a>

## 8. Setelah PR merged: siapkan branch untuk tugas berikutnya

Pastikan halaman PR benar-benar menunjukkan **Merged**, bukan sekadar Closed.
**Jangan klik Delete branch.** Tidak perlu clone lagi. Dengan tree bersih, pilih
`BRANCH=...` milikmu dan jalankan:

```bash
git fetch origin
git switch "${BRANCH:?Pilih BRANCH milikmu dahulu}"
git pull --ff-only origin "${BRANCH:?Pilih BRANCH milikmu dahulu}"
git log --oneline origin/development..HEAD
```

Log terakhir harus kosong: seluruh commit branchmu sudah masuk development.
Jika masih ada commit, jangan lanjut; mungkin ada pekerjaan baru, PR belum
merged, atau metode merge berbeda. Minta Rafi memeriksa riwayat. Jika kosong:

```bash
git merge --ff-only origin/development
git status --porcelain=v1 --untracked-files=all
```

Jalankan [gate](#validasi) pada hasil sinkronisasi jika belum ada hasil yang masih
berlaku, lalu kirim pembaruan branch sendiri:

```bash
git push origin "${BRANCH:?Pilih BRANCH milikmu dahulu}"
git rev-parse HEAD
git ls-remote origin "refs/heads/${BRANCH:?Pilih BRANCH milikmu dahulu}"
```

SHA harus sama. Sinkronisasi ini tidak memerlukan PR baru bila belum ada
pekerjaan baru untuk digabung. Ulangi siklus harian → kerja → periksa → commit →
push → PR untuk tugas berikutnya.

Promosi **development → main** dilakukan Rafi melalui PR setelah integrasi dan
review. Anggota mengambil basis kerja dari development; jangan direct push ke
main/development. Tag, release, dan deploy adalah pekerjaan terpisah.

<a id="clone-lagi"></a>

## 9. Kapan dan bagaimana clone lagi

Clone lagi diperlukan bila memakai komputer lain atau sengaja membuat folder
kerja baru. **Commit lokal yang belum dipush, file belum dicommit, `.env`, SDK,
dan `.venv` tidak otomatis ikut ke clone baru.**

Sebelum pindah komputer, selesaikan unit pekerjaan di clone lama, jalankan
pemeriksaan, commit, lalu push branch sendiri sesuai mandat. Cocokkan SHA lokal
dan remote seperti §6. Jangan hapus clone lama jika masih ada pekerjaan lokal
yang belum aman. Rahasia/config lokal ditangani terpisah bersama Rafi.

Pada komputer baru, ikuti §2 dari awal, termasuk identitas dan autentikasi
komputer tersebut. Jika membutuhkan clone kedua pada komputer yang sama,
gunakan nama folder lain yang **belum ada**, dari folder induk:

```bash
cd ~/proyek-kuliah
ls
git clone https://github.com/muhammadrafifatihulihsan/siagabanjir.git siagabanjir-baru
cd siagabanjir-baru
git remote -v
```

Lanjutkan §2.2–2.3, §3, dan persiapan alat §5.1. Pilih satu clone sebagai tempat
kerja aktif; jangan mengedit dua clone pada branch yang sama bersamaan tanpa
koordinasi. Jika folder lama masih benar dan hanya tertinggal pembaruan,
gunakan §3 saja.

<a id="masalah"></a>

## 10. Jika ada masalah, lakukan ini

| Pesan/keadaan | Langkah berikut |
|---|---|
| `not a git repository` | Periksa `pwd`; masuk folder clone yang berisi root proyek. Jangan langsung `git init`. |
| Folder clone tujuan sudah ada | Buka/periksa folder lama atau pilih folder baru yang belum ada. Jangan hapus folder lama untuk memaksa clone. |
| `Pilih BRANCH milikmu dahulu` | Isi satu `BRANCH=branch-...` sesuai §2.3 pada terminal yang sama. |
| Branch lokal belum ada | Fetch, periksa `git branch -a`; gunakan `git switch --track origin/branch-...` hanya jika remote-nya ada. |
| `Your local changes would be overwritten` | Berhenti; periksa dan selesaikan perubahan lokal pada branch yang benar. Jangan reset/stash untuk menyembunyikannya. |
| Status bersih tetapi `ahead` | Ada commit lokal yang belum ada di upstream terakhir diketahui. Periksa log, gate, lalu push; tidak perlu commit ulang. |
| `non-fast-forward`, `diverged`, atau `Not possible to fast-forward` | Fetch dan simpan output status/graph untuk Rafi. Jangan force push atau rebase riwayat bersama. |
| `CONFLICT` / `unmerged paths` | Jangan lanjut pull/switch. Baca kedua perubahan bersama Rafi, selesaikan konflik, uji, lalu commit hasil merge. Jangan pilih semua ours/theirs tanpa review. |
| Branch kosong dari `--show-current` / detached HEAD | Berhenti; minta Rafi membantu mempertahankan commit/perubahan sebelum pindah branch. |
| `403`, `Permission denied`, atau gagal login | Periksa akun autentikasi dan akses repo bersama Rafi. Mengubah user.name tidak memperbaiki izin. |
| Jaringan gagal saat push | Commit masih lokal. Perbaiki koneksi lalu ulang push; periksa SHA remote untuk memastikan hasil. |
| PR salah base | Edit base menjadi development untuk pekerjaan anggota; tinjau diff dan checks ulang. |
| PR tertinggal development / tidak bisa merge | Rafi membantu memeriksa graph dan merge development ke branch anggota bila perlu; selesaikan konflik dan uji sebelum push. |
| PR Closed tanpa Merged | Konfirmasi alasan ke Rafi; jangan menganggap perubahan sudah masuk development. |
| `There isn't anything to compare` | Pastikan sudah commit/push dan pasangan base/compare benar. Jika commit sudah masuk development, tidak perlu PR kosong. |
| CI gagal / alat validasi tidak ditemukan | Baca error langkah yang gagal, siapkan alat atau perbaiki perubahan. Jangan menulis PASS atau siap merge sebelum beres. |
| Salah email commit | Perbaiki konfigurasi lokal untuk commit berikut bersama pemilik akun; jangan rewrite commit bersama. |
| Hook/signing/aturan GitHub menolak | Minta Rafi memeriksa prasyarat. Jangan memakai `--no-verify` atau mematikan proteksi. |

Untuk meminta bantuan, jalankan perintah baca berikut dan bagikan hasil yang
relevan beserta error, langkah terakhir, dan URL PR. Jangan sertakan rahasia:

```bash
git status --short --branch
git branch --show-current
git log --graph --oneline --decorate -20
git rev-parse HEAD
```

Jangan menggunakan `git reset --hard`, `git clean -fd`, `git push --force`, atau
menghapus branch permanen sebagai jalan pintas. Jika PR terlanjur memakai
squash/rebase, Rafi perlu memeriksa graph/diff dan penggabungan biasa; prosedur
fast-forward di atas tidak dijamin berlaku. Rincian pemulihan tetap mengikuti
[kondisi Git](GITHUB-WORKFLOW.md#kondisi-git).

## 11. Kebiasaan yang diulang

1. Buka clone yang sama; pilih branch sendiri; pastikan pekerjaan lokal aman.
2. Fetch dan pull branch sendiri; sebelum tugas baru, sinkronkan development
   setelah PR sebelumnya merged dan tidak ada commit yang tertinggal.
3. Kerjakan satu tugas, perbarui dokumentasi, dan periksa hasilnya.
4. Stage file yang ditinjau, commit, lalu pastikan working tree bersih.
5. Tuntaskan gate sebelum push, cocokkan SHA, dan buat/perbarui PR ke development.
6. Tanggapi review; setelah merged, sinkronkan branch dan ulangi dari awal.

**Clone pertama menyiapkan folder. Rutinitas berikutnya menggunakan folder itu.**
