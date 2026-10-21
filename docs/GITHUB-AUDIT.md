# Audit workflow GitHub — 21 Oktober 2026

> **Living document:** perbarui bersama setiap perubahan terkait menurut [aturan dokumentasi](../rules/documentation.md#living-documents).

## A. Ringkasan dan mandat

Audit awal disampaikan sebelum perubahan. Pemilik kemudian mengizinkan
implementasi CI/dokumentasi dan push ke branch-rafi. Settings/rulesets, undangan,
merge, tag/release dan deploy belum diotorisasi. Sumber:
[prompt audit historis](https://github.com/muhammadrafifatihulihsan/siagabanjir/blob/1afcedda3e78d094bcd88850b9757d01abf829d7/prompt-audit-dan-perbaikan.md) dan
[keputusan terbaru](DECISIONS.md#workspace-github-workflow-010).

Repository publik milik akun pribadi, default main. Lima branch sudah ada;
seluruhnya pada d6e1c88e26f8915e624bfcdb234449b506807cb5 saat audit awal,
sehingga ahead/behind antarbranch 0/0. CI dasar tersedia, tetapi target
hanya-owner-merge belum terlindungi. Implementasi berkas tidak mengaktifkan
kontrol GitHub tersebut.

## B. Inventaris berbukti sebelum perubahan

API GET diperiksa melalui autentikasi Git yang tersedia; credential hanya
dipakai di memori ke api.github.com, tidak disimpan atau ditampilkan.
Hasil kosong/HTTP dibedakan dari fitur tidak didukung.

| Komponen | Kondisi aktual awal | Bukti | Confidence / dampak |
|---|---|---|---|
| Owner/visibility/default | muhammadrafifatihulihsan, User, public, main | GET /repos/muhammadrafifatihulihsan/siagabanjir | Tinggi; repo personal |
| Lima branch | main, development, branch-rafi, branch-melia, branch-hasan; SHA sama di atas; protected=false | GET /branches; git ls-remote dan fetch origin | Tinggi; tidak membuat ulang branch |
| Rulesets/protection | Daftar rulesets kosong; GET protection main/development terautentikasi 404 | GET /rulesets dan /branches/{branch}/protection | Tinggi bersama protected=false; belum ada proteksi teramati |
| Collaborator | Hanya muhammadrafifatihulihsan, role admin | GET /collaborators | Tinggi pada waktu audit; Melia/Hasan belum tercatat |
| PR aktif | Daftar kosong | GET /pulls?state=open | Tinggi pada waktu audit |
| CI terakhir | Tiga job SUCCESS pada d6e1c88 | [Run 39301428222](https://github.com/muhammadrafifatihulihsan/siagabanjir/actions/runs/39301428222), GET jobs | Tinggi; bukan bukti perubahan baru |
| Job lama | validate-docs: Validasi Dokumentasi; validate-contracts: Validasi Kontrak API; check-format: Cek Format EditorConfig | .github/workflows/ci.yml pada baseline, GET jobs | Tinggi; trigger awal hanya main |
| Merge | Merge commit, squash, rebase tersedia; auto-merge=false; delete_branch_on_merge=false | GET metadata repo terautentikasi | Tinggi; SOP memilih merge commit, Settings tidak diubah |
| Actions | Default token read; can_approve_pull_request_reviews=false | GET /actions/permissions/workflow | Tinggi; CI contents:read, release contents:write |
| Secrets/keys/environments | 0 secret Actions, tidak ada deploy key, 0 environment | GET /actions/secrets, /keys, /environments | Tinggi untuk metadata endpoint itu; bukan inventaris semua PAT |
| Secret protection | Secret scanning dan push protection enabled; security updates Dependabot disabled | security_and_analysis pada GET repo | Tinggi; alerts/dependency graph tidak disimpulkan dari flag updates |
| Plan/Apps/PAT | Plan null; GET /installation 401; cakupan seluruh PAT/App belum diketahui | GET /user, /installation | BELUM DIVERIFIKASI; bukan bukti tidak ada |
| Rilis | v0.1.0 menunjuk e1e11194b20cad9335901fabeb90d4f7e736f2b1 | [Release](https://github.com/muhammadrafifatihulihsan/siagabanjir/releases/tag/v0.1.0), GET tags/releases | Tinggi; terbit 19 Oktober 17:41 UTC / 20 Oktober WIB |
| Release workflow | Tag v*.*.*, ekstraksi CHANGELOG lalu publikasi; tidak memeriksa main/CI otomatis | [release.yml](../.github/workflows/release.yml), [release_notes.py](../.github/scripts/release_notes.py) | Tinggi; penguatan terpisah |
| Aplikasi | server/app hanya .gitkeep, belum package/lockfile/source/migrasi | [apps](../apps/README.md), inventaris tracked | Tinggi; tidak menambah job aplikasi fiktif |
| Panduan lama | Fork/branch tugas/PR main pada BR-036, PRD-NF-008, workflow, onboarding | Baseline Git d6e1c88; BRD/PRD/rules/GITHUB-WORKFLOW | Tinggi; diganti eksplisit tanpa menghapus riwayat |
| File awal lokal | Prompt audit untracked, ekspor session ignored; diff/index kosong | git status/diff awal | Prompt bagian tugas disertakan; ekspor mentah tetap lokal |

CODEOWNERS, issue template, Dependabot config dan konfigurasi deployment belum
ada saat audit awal. CI tidak memakai pull_request_target, secret eksplisit,
reusable workflow atau dispatch. Release memiliki izin write untuk penerbitan.
Action pihak ketiga EditorConfig dipin SHA; actions resmi/release memakai tag
versi yang dapat berubah. Pinning menyeluruh dapat menjadi penguatan berikutnya.
Inspeksi source dan nama file tidak menemukan berkas credential aplikasi aktif;
ini bukan audit rahasia lengkap seluruh histori, reflog, PAT atau provider.
Jangan menerbitkan credential, nilai .env, identitas nyata atau arsip percakapan.

## C. Gap dan mitigasi

| Requirement | Aktual awal → target | Status / risiko | Mitigasi / teknis |
|---|---|---|---|
| Lima branch exact | Sudah ada → tetap | TERPENUHI | Hindari recreate/rename/delete |
| CI development | Main saja → kedua base | BELUM TERPENUHI / sedang | Perubahan workflow dan tes arah PR |
| Kontribusi sama repo | Belum ada check → pasangan sah | BELUM TERPENUHI / sedang | Check CI; efektif menahan merge hanya jika required dan dipercaya |
| Hanya Rafi merge | Tidak ada proteksi → otorisasi update | BELUM TERPENUHI / tinggi | Ruleset berlapis, perlu Settings dan uji akun |
| Direct/force push/hapus | Tidak terlindungi → ditolak | BELUM TERPENUHI / tinggi | Ruleset tanpa bypass kualitas; belum diterapkan |
| Branch eksklusif per orang | Nama branch/SOP → akses per akun | TIDAK DIDUKUNG oleh pembagian nama saja / tinggi | Tidak mengklaim isolasi; opsi organisasi/tim atau fork hanya keputusan baru |
| Review PR Rafi | Belum required review → tanpa deadlock | PERLU PENGUJIAN / sedang | Jangan wajibkan Rafi satu-satunya code owner; tentukan reviewer sah atau 0 approval dengan owner-only merge dan review SOP |
| Tag resmi | Workflow tag tanpa ancestry/CI → hanya main teruji | BELUM TERPENUHI / tinggi | Proteksi tag + guard release terpisah, tetap periksa manual |
| Integrasi produk | Apps kosong → hasil uji aktual | NOT_RUN | Implementasi dan tes setelah proyek tim tersedia |

## D. Kelayakan keamanan dan matriks akses

Dokumentasi [izin personal repository](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/repository-access-and-collaboration/permission-levels-for-a-personal-account-repository)
membedakan owner dan collaborator. Write tidak otomatis terikat nama branch.
Karena belum ada ruleset/protection, belum dapat dinyatakan bahwa Melia/Hasan
akan ditolak saat push atau merge setelah diberi akses. Saat audit mereka belum
tercatat, dan akun uji tidak digunakan.

| Aksi | Rafi menurut SOP | Melia / Hasan menurut SOP setelah diberi akses | Enforcement saat audit |
|---|---|---|---|
| Baca main/development | Ya | Ya | Public, bukan branch rahasia |
| Push branch sendiri | branch-rafi | branch-melia / branch-hasan | Hak per branch belum dibatasi |
| Push branch orang lain | Hanya pemulihan terkoordinasi | Dilarang | Larangan SOP saja |
| Direct push main/development | Tidak | Tidak | Belum diblokir ruleset |
| Buka PR development | Dari branch anggota | Dari branch sendiri | Check memvalidasi arah, bukan identitas pusher |
| Buka PR main | Promosi development | Jangan untuk kontribusi biasa | UI masih dapat menerima PR salah; check akan gagal |
| Merge main/development | Hanya Rafi setelah review | Dilarang | Target belum ditegakkan |
| Force push/hapus branch permanen | Dilarang | Dilarang | Target belum ditegakkan |
| Settings/rulesets | Pemilik dalam mandat terpisah | Tidak | Role saat audit hanya owner/admin |
| Tag rilis | Rafi dengan mandat rilis | Dilarang | Proteksi tag belum ada |

[Rulesets](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/about-rulesets)
tersedia untuk repo publik termasuk GitHub Free; paket akun aktual tetap belum
diketahui. Layering dapat menggabungkan beberapa aturan. Ini dukungan dokumentasi,
bukan bukti konfigurasi sudah bekerja di repo ini.

[Restrict updates](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/available-rules-for-rulesets)
membatasi update pada aktor bypass. Rancangan memisahkannya dari ruleset kualitas.
[Bypass PR-only](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/creating-rulesets-for-a-repository)
tetap memungkinkan bypass aturan pada ruleset yang sama; jangan menyamakan
PR-only dengan CI wajib. Hindari bypass Write/App/token yang terlalu luas.

[CODEOWNERS](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners)
memilih reviewer dan dapat menjadi syarat review; tidak memberikan hak merge
eksklusif. Rafi tidak dapat menjadi approval independen bagi PR miliknya sendiri.
File CODEOWNERS tidak ditambahkan sebelum model review disepakati.

[Keamanan Actions](https://docs.github.com/en/actions/reference/security/secure-use)
menekankan izin minimum dan risiko code/workflow yang dapat diubah pemegang write.
Check arah PR juga dapat diedit dalam PR: owner wajib meninjau workflow/script,
bukan hanya mempercayai nama check hijau. Nama branch bukan autentikasi penulis.
Seluruh sumber resmi di atas diperiksa 21 Oktober 2026.

## E. Rancangan Settings untuk review

Semua baris berikut **BELUM DITERAPKAN**, bukan file konfigurasi yang sudah aktif.

| Ruleset usulan | Target exact | Aturan | Bypass | Pembuktian / risiko |
|---|---|---|---|---|
| authorize-integration | main dan development | Restrict updates | Repository admins, PR-only; bukan Write | Pastikan hanya owner admin; collaborator merge ditolak dan owner PR diterima |
| protect-main | main | PR, empat checks aktual, conversation resolution, block force push, restrict deletion | Tidak ada | Sumber development diperiksa CI; jangan linear history; pilih approval tanpa deadlock |
| protect-development | development | PR, empat checks aktual, conversation resolution, block force push, restrict deletion | Tidak ada | PR tiga branch anggota sah; semua checks harus pernah muncul sukses |
| protect-member-history | Tiga branch anggota | Block force push, restrict deletion | Tidak ada | Tidak membatasi push biasa per akun; uji tanpa merusak branch |
| authorize-release-tags | v*.*.* | Restrict creations | Repository admins, always untuk pembuatan tag | Verifikasi aktor dan token; tag tidak otomatis menunjuk main |
| protect-release-tags | v*.*.* | Restrict updates/deletions | Tidak ada | Mencegah pemindahan/penghapusan tag; guard ancestry/CI masih usulan |

Empat kandidat required check adalah Validasi Arah PR, Validasi Dokumentasi,
Validasi Kontrak API dan Cek Format EditorConfig. Pilih sumber GitHub Actions
setelah run baru sukses; jangan aktifkan nama yang belum muncul. Usulan 0 approval
dengan review SOP menghindari owner self-approval, tetapi tidak menegakkan review
independen. Bila review independen wajib, pilih reviewer selain penulis sebelum
mengaktifkan requirement. Ini keputusan Settings tersendiri.

Diff CI yang disetujui: perluas push ke lima branch, PR ke main/development,
tambahkan edited untuk retarget, check arah dengan contents:read, dan matikan
persistensi credential checkout. Tidak ada paths filter atau job aplikasi baru.
Push branch anggota sengaja ikut divalidasi agar pekerjaan sebelum PR mendapat
bukti CI; check arah PR sebenarnya tetap memerlukan event PR.

## F. Urutan implementasi dan pemulihan

| Tahap | Prasyarat / tindakan | Validasi | Pemulihan / izin / dampak |
|---|---|---|---|
| Audit | Baca seluruh sumber; rekam SHA/metadata | Tabel B | Read-only, tidak mengubah Settings |
| Berkas | Persetujuan diterima; checkout branch-rafi, perbaiki CI/docs | Tes lokal dan review diff | Commit koreksi/revert pada branch anggota; tidak rewrite |
| Publikasi | Gate lokal lulus; commit/push branch-rafi | SHA remote dan run push | Tidak merge; branch utama tetap baseline |
| Bootstrap PR | PR branch-rafi → development setelah cek PR aktif | Run PR dari workflow hasil perubahan, empat job | Bila trigger tidak berjalan, investigasi workflow; tidak direct push main sebagai jalan pintas |
| Promosi | Owner menyetujui merge development, memeriksa integrasi | PR development → main dan CI hasil merge | Tetap PR; jangan mengaktifkan checks yang belum tersedia |
| Settings | Approval terpisah, ekspor kondisi sebelum perubahan, reviewer tersedia | Uji positif/negatif dengan akun sah di lingkungan disetujui | Owner menyetujui rollback spesifik; jangan menonaktifkan proteksi otomatis |
| Anggota/rilis | Owner-only merge dan jalur pemulihan terbukti | Identitas, PR/checks, tag ancestry dan CI | Jangan undang/migrasi/rilis sampai gap relevan diselesaikan |

Uji lintas akun harus mencakup push sah branch sendiri, penolakan direct/force
push/deletion/merge collaborator ke target, PR salah/fork, owner PR sah,
PR buatan owner, dan token/App yang relevan. Dry-run Git saja tidak membuktikan
seluruh gate server. Tidak menjalankan percobaan destruktif pada branch produksi.

## G. Keputusan dan bukti tersisa

Implementasi berkas/push telah disetujui, tidak diminta ulang. Sebelum Settings:
konfirmasi model approval PR milik Rafi, aktor bypass dan rencana uji aman.
Pemilik dapat menyediakan metadata halaman Billing plan, installed GitHub Apps
dan izin repository, PAT yang punya akses (nama/izin/expiry saja), Actions allowed
actions/fork policies, serta status Dependabot alerts/dependency graph.
Jangan mengirim nilai token/secret. Metadata yang tidak tersedia tetap UNKNOWN.

## H. Status setelah persetujuan

Gate tunggu implementasi berkas telah dipenuhi oleh persetujuan pemilik;
tidak ada klaim Settings sudah diterapkan. Hasil verifikasi/publikasi terbaru
dicatat pada [WORKSPACE](WORKSPACE.md#github-workflow-audit) dan
[handoff](SESSION-HANDOFF.md). Kontrol owner-only merge, proteksi branch/tag,
review wajib dan uji lintas akun masih BELUM DITERAPKAN/NOT_RUN.
