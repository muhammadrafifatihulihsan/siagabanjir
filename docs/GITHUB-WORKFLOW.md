# Commit, push dan pull request SiagaBanjir

> **Living document:** perbarui bersama setiap perubahan terkait menurut [aturan dokumentasi](../rules/documentation.md#living-documents).

Panduan ini dijalankan oleh anggota tim dari **root repository** menggunakan
Git pada PowerShell, Git Bash, terminal macOS atau Linux. Perintah tidak memakai
path mesin, shell script khusus atau GitHub CLI sebagai syarat. Repo tujuan:
[muhammadrafifatihulihsan/siagabanjir](https://github.com/muhammadrafifatihulihsan/siagabanjir).
Identitas dan deskripsi ada pada [notes GitHub](GITHUB-NOTES.md).

## Sebelum pengiriman pertama

Audit awal 19 Oktober 2026: branch lokal main belum mempunyai commit/remote;
repo tujuan dapat diakses dan belum mempunyai branch. Itu checkpoint awal,
bukan status permanen. Periksa keadaan aktual sebelum menjalankan:

```text
git --version
git status --short --untracked-files=all
git branch --show-current
git remote -v
git config user.name
git config user.email
```

Jika ini salinan folder tanpa .git, jalankan `git init -b main` sekali.
Jika identitas belum benar, isi dengan identitas milikmu melalui
`git config --local user.name "Nama Kamu"` dan
`git config --local user.email "email-pilihan-kamu"`.
Gunakan alamat noreply GitHub bila itu pilihanmu. Jangan mengganti identitas
anggota lain atau konfigurasi global sebagai bagian perapian workspace.

Repository tujuan sudah tersedia; tidak perlu membuat repo kedua atau menambahkan
README/.gitignore/LICENSE dari formulir. Pertahankan visibilitas milik pemilik
dan lisensi [All Rights Reserved](../LICENSE). Autentikasi melalui metode GitHub yang
tersedia, misalnya credential manager untuk HTTPS atau SSH. Jangan menaruh token
di remote URL, Markdown atau command yang disimpan.

Jalankan seluruh [pemeriksaan lokal](../README.md#otomatisasi-cicd) dan tinjau
hasil sebelum staging/push. CI juga menjalankan pemeriksaan pada Ubuntu;
kelulusan Windows saja tidak membuktikan hasil CI.

Untuk mandat memakai Git Bash di Windows, jalankan binary Git Bash yang
terpasang (bukan `bash.exe` milik WSL). Bila Git menolak repository karena
akun sandbox dan akun Windows berbeda, pastikan path dan pemiliknya benar.
Hanya pada workspace yang sudah diverifikasi, bentuk Git Bash
`git -c safe.directory="$PWD" status` memberi pengecualian per perintah.
Gunakan opsi yang sama pada perintah Git terkait bila perlu; jangan menambahkan
`safe.directory=*`, mengubah ownership, atau mengubah konfigurasi global.

## Commit dan push pertama

Periksa daftar file yang akan masuk. Arsip mentah lokal tidak diperlukan untuk
clone; Kontrak API berada di docs/openapi.json dan ikut Git.

```text
git ls-files --cached --others --exclude-standard
git check-ignore -v .env
git ls-files archive
```

Folder archive beserta indeksnya sudah dihapus dari workspace publik;
`.gitignore` mengecualikan seluruh `archive/` jika dibuat kembali secara lokal.
`git ls-files archive` harus kosong, termasuk setelah staging.
.gitignore tidak mengeluarkan file yang sudah telanjur tracked; jika daftar
berisi arsip dari riwayat lain, hentikan publikasi dan telaah index/riwayat.
Jangan menganggap menambahkan ignore sudah menghapus isi commit lama.

Setelah memeriksa isi kandidat, stage sumber secara eksplisit:

```text
git add -- .editorconfig .gitattributes .gitignore .markdownlint.json .redocly.yaml .aiassistant .github .vscode/extensions.json AGENTS.md CHANGELOG.md CLAUDE.md LICENSE README.md SKILL.md apps docs rules skills
git diff --cached --name-status
git diff --cached --check
git diff --cached
```

Pastikan isi staged tidak memuat data pribadi, credential, percakapan mentah,
cache atau generator lama. Baseline dan contoh menggunakan data yang memang
layak dibagikan; jangan hanya mengandalkan nama file atau .gitignore.
Pemeriksaan harus mencakup file baru: `git diff` tanpa --cached tidak
menampilkan isi untracked. Jika salah stage sebelum commit pertama,
`git rm --cached -- "path/file"` mengeluarkan file itu dari index sambil
mempertahankan berkas lokal. Jangan tambahkan -f/-r tanpa memeriksa scope.

```text
git commit -m "docs: prepare SiagaBanjir specifications and workspace"
git remote add origin https://github.com/muhammadrafifatihulihsan/siagabanjir.git
git remote -v
git ls-remote --symref origin HEAD refs/heads/main
git push -u origin main
git rev-parse HEAD
git ls-remote origin refs/heads/main
```

Jalankan remote add hanya jika origin belum ada. Jika sudah ada, cocokkan URL;
jangan otomatis mengganti remote. Jika push ditolak karena remote berisi commit,
gunakan `git fetch origin` lalu periksa riwayat dengan
`git log --oneline --graph --all`; jangan force-push atau menyatukan riwayat
yang belum dipahami. Setelah berhasil, cocokkan SHA lokal/remote dan periksa
[GitHub Actions](https://github.com/muhammadrafifatihulihsan/siagabanjir/actions/workflows/ci.yml)
pada SHA yang sama. Perbaikan CI dibuat sebagai commit lanjutan tanpa force-push.
Push branch tidak otomatis meminta tag, release atau deploy.

Alur pertama ini mengikuti
[panduan impor lokal GitHub](https://docs.github.com/en/migrations/importing-source-code/using-the-command-line-to-import-source-code/adding-locally-hosted-code-to-github),
disesuaikan dengan sumber yang boleh dipublikasikan pada workspace ini.

## Perubahan berikutnya melalui PR

Mulai dari working tree bersih. Jika ada pekerjaan belum selesai, selesaikan
commit terkait atau pertahankan pekerjaannya; jangan reset/clean untuk memaksa.

```text
git switch main
git pull --ff-only origin main
git switch -c docs/perbarui-panduan
```

Nama branch menjelaskan tugas, misalnya docs/perbarui-panduan atau
fix/review-laporan. Jangan menjalankan contoh branch yang sama berulang jika
branch tersebut sudah ada. AI menuntaskan
[bacaan lengkap](../rules/workflow.md#baca-lengkap) sebelum perubahan,
lalu memperbarui seluruh
[living documents terdampak](../rules/documentation.md#living-documents).

Sesudah perubahan dan pemeriksaan sesuai dampak:

```text
git status --short
git diff
git add -- docs/WORKSPACE.md
git diff --cached --name-status
git diff --cached --check
git diff --cached
git commit -m "docs: clarify workspace guidance"
git push -u origin docs/perbarui-panduan
```

Ganti daftar path pada git add dengan **semua berkas perubahan terkait** yang
telah diperiksa, termasuk dokumentasi/instruksi. Setelah commit pertama ada,
gunakan `git restore --staged -- "path/file"` untuk membatalkan staging file
tertentu tanpa membuang editnya.

Di GitHub pilih **Compare & pull request**, base main dan compare branch tugas.
Isi [template PR](../.github/pull_request_template.md): masalah/perilaku akhir,
scope/FR terkait, perubahan dokumentasi, metode/hasil pemeriksaan dan batas bukti.
Gunakan Draft bila belum siap direview. Perbaikan review dibuat sebagai commit
lanjutan dan di-push ke branch yang sama; PR ikut diperbarui.

Merge setelah review yang disepakati tim dan pemeriksaan relevan selesai.
Jika GitHub menunjukkan konflik, selesaikan pada branch tugas, review ulang diff
dan jalankan kembali checks terdampak. Workflow CI sudah tersedia; klaim lulus
harus didukung run pada commit terkait. Keberadaan workflow tidak membuktikan
branch protection terpasang; pengaturan tersebut tidak diubah dalam audit ini.

Setelah PR merged:

```text
git switch main
git pull --ff-only origin main
```

Branch tugas boleh dihapus di GitHub setelah merged. Penghapusan lokal bersifat
opsional; bila memakai git branch -d dan ditolak setelah squash merge, periksa
dulu riwayat/diff, jangan langsung memakai -D. Untuk undo perubahan yang sudah
dibagikan, buat perubahan pembalik melalui branch/PR; hindari rewrite main.

Dasar alur:
[GitHub flow](https://docs.github.com/en/get-started/using-github/github-flow).
Template tersedia otomatis setelah berada pada default branch menurut
[dokumentasi template PR](https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/creating-a-pull-request-template-for-your-repository).
Sumber diperiksa 19 Oktober 2026. Perintah mutasi di atas adalah petunjuk, bukan
catatan bahwa commit, push, PR atau merge telah dijalankan oleh asisten.
