# Workspace SiagaBanjir

> **Living document:** perbarui bersama setiap perubahan terkait menurut [aturan dokumentasi](../rules/documentation.md#living-documents).

Kondisi 21 Oktober 2026: panduan kerja lintas OS/IDE dan wadah `apps/`.
Backend/Flutter tetap disiapkan tim. UI mendatang mengikuti
[DESIGN](DESIGN.md); setiap perubahan mengikuti
[sinkronisasi dokumentasi](../rules/documentation.md).

## Cakupan dan sumber bersama

[Mandat pemeliharaan](DECISIONS.md#workspace-local-commit-009) mencakup
commit lokal AI, gerbang tree bersih, panduan tim, dan publikasi pembaruan. Backend dan Flutter
disiapkan tim. Bacaan lengkap dan living documents mengikuti aturan bersama.

README utama memperkenalkan aplikasi kepada pembaca umum. Navigasi spesifikasi
dan panduan kerja berada di [indeks dokumentasi](INDEX.md); perintah pemeriksaan
dipelihara pada [panduan pengembangan](GITHUB-WORKFLOW.md#otomatisasi-cicd).
Perintah singkat dengan main lokal tersedia di [GIT-CEPAT.md](GIT-CEPAT.md);
branch remote dan kebijakan PR tetap sama.
Urutan praktik anggota baru tersedia dalam [panduan Git pemula](GIT-UNTUK-PEMULA.md).

## Status dan versi

| Komponen | Baseline |
|---|---|
| BRD / PRD | v0.1.0 APPROVED |
| FRD / SRS / kontrak API | v1.0.0 APPROVED |
| Workspace | v0.1.0; perubahan sesudah rilis dicatat pada bagian Unreleased di CHANGELOG |
| Backend / Flutter | Backend masih penanda kosong; scaffold Flutter Android/Web sudah dibuat tim |
| Pengujian aplikasi, provider, perangkat, dan UAT | NOT_RUN |

Rancangan produk memakai Flutter Android untuk warga, Flutter Web untuk admin,
dan backend bersama. Persetujuan spesifikasi berbeda dari penerimaan implementasi.
Baseline v0.1.0 tidak menyediakan APK atau aplikasi siap pakai.
[CHANGELOG](../CHANGELOG.md) mencatat perubahan sesuai [versioning](VERSIONING.md);
[GitHub Releases](https://github.com/muhammadrafifatihulihsan/siagabanjir/releases)
menyediakan catatan rilis dan arsip repository pada tag terkait.

## Struktur dan panduan workspace

| Artefak | Tanggung jawab |
|---|---|
| [docs](INDEX.md) | Spesifikasi, kontrak API, desain, keputusan, dan panduan kerja |
| [AGENTS](../AGENTS.md) | Sumber instruksi bersama dan routing tugas |
| [SKILL](../SKILL.md) | Katalog delapan skill; prosedur pada sumber masing-masing |
| [skills](../skills/) | Delapan prosedur tugas yang dirujuk AGENTS |
| [Rules](../rules/workflow.md) | Workflow, domain, mutu, UI, portabilitas, dokumentasi dan riset |
| [Riset skill](SKILL-RESEARCH.md) | Referensi terpilih, adaptasi dan skenario evaluasi |
| [DESIGN](DESIGN.md) | Token, ikon Material, hierarki, state, kriteria visual/aksesibilitas |
| [apps](../apps/README.md) | apps/server masih kosong; apps/app berisi scaffold Flutter tim |
| [Rekomendasi VS Code](../.vscode/extensions.json) | EditorConfig dan Flutter, opsional; tidak memasang ekstensi/SDK |
| [.editorconfig](../.editorconfig) | Encoding, indentation dan whitespace lintas editor |
| [.gitattributes](../.gitattributes) | EOL teks bersama dan pengecualian binary |
| [.gitignore](../.gitignore) | Rahasia, artefak lokal dan seluruh archive/ dikecualikan Git; tidak ada indeks arsip publik |
| [GitHub](GITHUB-WORKFLOW.md) dan [versioning](VERSIONING.md) | Commit/push/PR dan identitas repo; bukti pada audit final/handoff |
| [.github](../.github/) | CI, rilis, validator, dan template pull request |
| [CI](../.github/workflows/ci.yml), [validator](../.github/scripts/) dan [dependensi](../.github/requirements-validation.txt) | Gate dokumentasi, format, kontrak/contoh dan regresi validator |

Scaffold aplikasi lama sudah ditarik. Tim kemudian membuat scaffold Flutter
di apps/app; apps/server masih kosong. Root tidak berisi tools/reports/database/cache aktif.
Fungsi baseline BRD/PRD/FRD/SRS tetap. Errata kontrak menyelaraskan replay
rahasia dengan SRS-IF-004; tidak menambah endpoint atau fitur produk.
Folder archive/tools/contracts sudah dihapus; kontrak aktif berada di docs.

<a id="sumber-acuan"></a>

## Peta sumber acuan

| Kebutuhan | Sumber bersama | Cara menilai perbedaannya |
|---|---|---|
| Tujuan dan batas produk | [BRD](BRD.md), [PRD](PRD.md), mandat terbaru pada [DECISIONS](DECISIONS.md) | Keputusan historis tetap dibaca sesuai tanggal dan statusnya |
| Fungsi dan penerimaan | [FRD](FRD.md), AC/TC | Approval spesifikasi tidak membuktikan implementasi lulus |
| Arsitektur/stack dan batas lapisan | [SRS konteks](SRS.md#srs-context) | Manifest/kode aktual menunjukkan yang sudah dibuat; perbedaan perlu ditelusuri |
| Model data/integritas | [SRS data](SRS.md#srs-data) | Cocokkan dengan migrasi SQL/constraint setelah tim membuatnya |
| Wire API dan semantik | [OpenAPI](openapi.json), [contoh](examples.json), [SRS antarmuka](SRS.md#srs-interfaces) | Schema dan aturan akses/transaksi saling melengkapi; contoh/ringkasan tidak mengalahkan kontrak |
| UI/ikon dan interaksi | [DESIGN](DESIGN.md), FRD | Token visual tidak mengubah hak akses atau arti status bisnis |
| Cara kerja agent | [AGENTS](../AGENTS.md), [rules](../rules/workflow.md), [katalog skill](../SKILL.md) | Seluruh sumber aktif wajib dibaca; prosedur yang dijalankan tetap sesuai tugas |
| Perintah, versi dan konfigurasi aktual | [README apps](../apps/README.md), manifest/README tim ketika tersedia | Rancangan versi/command dalam dokumen bukan bukti sudah terpasang atau bisa dijalankan |
| Bukti dan kelanjutan | [TRACEABILITY](TRACEABILITY.md), [handoff](SESSION-HANDOFF.md), hasil pemeriksaan | Catat metode, cakupan dan status; ringkasan tidak boleh menaikkan NOT_RUN menjadi PASS |

Jika dua sumber normatif tidak cocok, tunjukkan ID/bagian dan dampaknya.
Selesaikan dalam mandat yang tersedia serta selaraskan sumber terkait; jangan
diam-diam memilih contoh, kode yang salah atau dokumen yang paling baru diedit.
Informasi operasional per aplikasi boleh dekat proyeknya, sedangkan baseline
bersama tetap dirujuk dari root sesuai [aturan dokumentasi](../rules/documentation.md).

## OS dan format berkas

| Lingkungan | Cara memakai workspace | Batas bukti saat ini |
|---|---|---|
| Windows | Buka root; path relatif, UTF-8 dan EOL mengikuti konfigurasi repo | Validator lokal PASS; commit/push melalui Git Bash terverifikasi |
| macOS | Buka root yang sama; gunakan path dan case yang sama | Runtime/editor pada macOS belum diuji |
| Linux | Buka root yang sama; kapitalisasi file harus persis | Validator CI pada Ubuntu PASS; runtime aplikasi/editor Linux belum diuji |

EditorConfig menjaga format ketika editor/plugin mendukungnya; Git attributes
mengatur konversi teks/binary. Tidak perlu mengganti Git global.
LF untuk teks umum; bat/cmd memakai CRLF. Folder arsip lokal, bila dibuat
kembali, diabaikan Git dan dikecualikan pemformatan EditorConfig.
Ukuran indentasi Markdown tidak dipaksa kelipatan dua; markdownlint memeriksa
struktur daftar, heading dan blok kode, sementara pemeriksaan EOL tetap aktif.
XML di apps/app/android juga memakai indent_size unset untuk menerima alignment
komentar template Flutter. Encoding, EOL, newline akhir, indentasi spasi dan
trailing whitespace tetap diperiksa; detail pada [panduan CI](GITHUB-WORKFLOW.md#otomatisasi-cicd).
Sumber: [EditorConfig](https://spec.editorconfig.org/) dan
[Git attributes](https://git-scm.com/docs/gitattributes).

Portabilitas workspace tidak memperluas target produk ke desktop/iOS.
Perintah build, versi SDK, konfigurasi database dan dependensi lintas OS baru
dicatat setelah setup tim ada. Laragon pada baseline adalah lingkungan Windows;
kesesuaian MySQL dan tool runtime OS lain harus dibuktikan tersendiri.
Detail aturan: [portabilitas](../rules/portability.md).

<a id="ide"></a>

## IDE dan pemuatan instruksi

Buka root repository, bukan hanya subfolder aplikasi. Sumber bersama tetap
AGENTS, rules dan skills; adapter menunjuk sumber tersebut.

| IDE / harness | Jalur instruksi | Cara memeriksa saat dipakai |
|---|---|---|
| Codex CLI/app/IDE | AGENTS.md pada hierarki proyek | Sesi baru, periksa sumber instruksi yang terbaca |
| VS Code dengan Copilot/Codex yang mendukung AGENTS | AGENTS.md | Periksa customization/diagnostics; Local harness memiliki opsi chat.useAgentsMdFile |
| Cursor | AGENTS.md | Pastikan instruksi root terbaca pada konteks proyek |
| Claude Code | [CLAUDE.md](../CLAUDE.md) mengimpor @AGENTS.md | Periksa /context pada sesi baru; dukungan harness lain diverifikasi tersendiri |
| JetBrains AI Assistant | [.aiassistant/rules/siagabanjir.md](../.aiassistant/rules/siagabanjir.md) | Periksa Rules, gunakan Always, periksa attachments jawaban |
| Neovim | EditorConfig bawaan; AGENTS/skill sebagai konteks eksplisit plugin AI | Periksa :help editorconfig dan b:editorconfig; dukungan format terpisah dari pemuatan instruksi AI |
| Android Studio / editor lain | EditorConfig bila didukung; buka/lampirkan AGENTS dan skill secara manual bila agent tidak membacanya | Periksa dukungan plugin/editor aktual; jangan mengasumsikan native loading |

Dukungan tiap agent/harness berbeda meskipun IDE sama. Tabel ini berdasarkan
dokumentasi resmi, bukan klaim semua IDE telah dijalankan pada sesi ini.
Sumber: [Codex AGENTS](https://learn.chatgpt.com/docs/agent-configuration/agents-md),
[VS Code](https://code.visualstudio.com/docs/agent-customization/custom-instructions),
[Cursor](https://prod.cursor.com/help/customization/rules),
[Claude Code](https://code.claude.com/docs/en/memory), dan
[JetBrains AI Assistant](https://www.jetbrains.com/help/ai-assistant/configure-project-rules.html).

Untuk agent yang tidak memuat rujukan otomatis, baca AGENTS lalu tuntaskan
[seluruh sumber aktif](../rules/workflow.md#baca-lengkap) melalui alat pembaca.
Membuka AGENTS tidak membuktikan semua tautannya sudah dibaca. Jangan menyalin
seluruh rules ke file setiap editor.
Konfigurasi pribadi IDE/SDK diabaikan Git; konfigurasi bersama baru harus
portable dan ditinjau.

### Rekomendasi editor yang tersedia

[extensions.json](../.vscode/extensions.json) hanya merekomendasikan
EditorConfig.EditorConfig dan Dart-Code.flutter. VS Code menampilkan rekomendasi;
pengguna memilih instalasinya. Flutter extension juga membawa Dart. Lihat
[mekanisme VS Code](https://code.visualstudio.com/docs/configure/extensions/extension-marketplace#_workspace-recommended-extensions)
dan [panduan Flutter](https://docs.flutter.dev/tools/vs-code).

Format tetap berasal dari .editorconfig, termasuk pengecualian Markdown,
bat/cmd dan arsip. Hindari setting pribadi yang menimpa pengecualian itu.
[EditorConfig VS Code](https://github.com/editorconfig/editorconfig-vscode)
mencatat keterbatasan trimTrailingWhitespace; settings pemformatan paksa tidak
ditambahkan. [Neovim](https://neovim.io/doc/user/plugins/#editorconfig) menyediakan
dukungan format bawaan; plugin AI tetap diperiksa sendiri.

Tasks/launch serta rekomendasi linter backend menunggu manifest/perintah tim.
Belum ada SDK path, debug port atau auto-run migrasi yang bisa ditetapkan dari
folder kosong. Editor lain tetap dapat memakai panduan bersama tanpa .vscode.

## Skill dan aturan izin

Delapan skill menggunakan metadata YAML name/description. Skills di `skills/`
dibaca langsung melalui AGENTS. Penempatan native belum tersedia pada lingkungan yang diperiksa;
penemuan native Codex di `.agents/skills/` tetap BLOCKED.
Sumber: [Skills Codex](https://learn.chatgpt.com/docs/build-skills).

Rules Markdown adalah panduan kerja, berbeda dari berkas `.rules` untuk izin
command. Tidak ada allowlist, perubahan sandbox atau konfigurasi global.
Sumber: [Rules Codex](https://learn.chatgpt.com/docs/agent-configuration/rules).

## Skenario inspeksi routing

| Contoh tugas | Rute yang diharapkan |
|---|---|
| Rename folder dan benahi instruksi OS/IDE | workspace, portabilitas, dokumentasi |
| Ubah requirement review laporan | requirements; domain/kontrak/RTM sesuai dampak |
| Telusuri bug penerimaan ganda pada backend tim | debug, lalu backend untuk perbaikan |
| Implementasikan state offline/logout Flutter tim | flutter; debug bila penyebab bug belum diketahui |
| Review visual Pantau dan pilih ikon | ui; DESIGN |
| Review akses vault pada perubahan kode | review; domain |
| Susun/jalankan paket tes penerimaan | verification; FR/AC/TC dan batas lapisan bukti |
| Rapikan panduan ketika app/server kosong | Tetap workspace, tidak membuat aplikasi |
| Ubah ikon tanpa perubahan perilaku | DESIGN/UI/skill terkait; tidak mengganti kontrak API |
| Ubah nama path | Semua rujukan aktif disinkronkan; kutipan sejarah tetap |
| Pertanyaan umum di luar proyek | Tidak perlu skill SiagaBanjir |

Kesesuaian tabel dinilai dari isi instruksi; pemilihan runtime belum diuji.
[Skenario rinci](SKILL-RESEARCH.md#evaluasi) memuat contoh positif, negatif,
ambiguitas dan batas bukti. **Seluruh delapan skill wajib dibaca penuh** sebelum
menjalankan prosedur terpilih. Prosedur pelaksanaan dipilih sesuai keluaran tugas.

<a id="verifikasi"></a>

## Verifikasi workspace

Bukti dibedakan menurut lapisannya. Validasi dokumen dan kontrak tidak
membuktikan perilaku aplikasi atau kepatuhan runtime agent.

<a id="audit-softwarebk"></a>

### Riwayat adaptasi referensi — 19 Oktober 2026

Referensi setup-softwarebk digunakan untuk memperjelas peta sumber,
unit perubahan, API client bersama, dan README aplikasi berdasarkan manifest.
Stack dan aturan persetujuannya tidak diadopsi. Keputusan tersimpan pada
[WORKSPACE-REFERENCE-004](DECISIONS.md#workspace-reference-004) dan
[riset skill](SKILL-RESEARCH.md#softwarebk).

<a id="audit-publikasi"></a>

### Riwayat persiapan publikasi — 19 Oktober 2026

WORKSPACE-PUBLISH-005 menetapkan bacaan lengkap, living documents, dan panduan
GitHub. Publikasi awal kemudian diotorisasi melalui WORKSPACE-AUDIT-PUSH-006.
[CI publikasi awal](https://github.com/muhammadrafifatihulihsan/siagabanjir/actions/runs/39273616792)
berhasil pada commit 71459a6. Catatan ini merupakan bukti historis untuk commit
tersebut, bukan hasil otomatis bagi commit berikutnya.

<a id="audit-final"></a>

## Pemeriksaan baseline v0.1.0 — 19 Oktober 2026

Cakupan: dokumentasi aktif, tujuh rules, delapan skill, kontrak, konfigurasi,
adapter, validator, dan workflow. Hasil pemeriksaan lokal setelah penyuntingan tercatat pada tabel berikut.

| Pemeriksaan | Status |
|---|---|
| Markdown, tautan/case, YAML delapan skill, EditorConfig | PASS: 36 Markdown, delapan skill, 56 berkas kandidat |
| 165 skema, 54 contoh dan invariant kontrak | PASS: validator kontrak dan Redocly tanpa error |
| Regresi validator dan ekstraksi catatan rilis | PASS: 24 tes, termasuk versi hilang/ganda, entri kosong, tag tidak sah dan isolasi catatan versi |
| Konsistensi ID/anchor dan struktur kontrak terhadap baseline Git | PASS: seluruh anchor BRD/PRD/FRD/SRS/keputusan/RTM lama tetap; 144 perubahan teks API dan penghapusan satu skema tak terpakai, struktur wire tetap |
| Pemilihan skill oleh agent terpisah dan pemuatan IDE | NOT_RUN |
| Backend, Flutter, provider, perangkat, aksesibilitas perangkat, dan UAT | NOT_RUN |

[CI](https://github.com/muhammadrafifatihulihsan/siagabanjir/actions/workflows/ci.yml)
dan [workflow rilis](https://github.com/muhammadrafifatihulihsan/siagabanjir/actions/workflows/release.yml)
menyimpan status per commit/tag. Prosedur publikasi mensyaratkan seluruh
pekerjaan CI berhasil pada SHA yang akan diberi tag.
Status publikasi baseline dokumentasi dan workspace v0.1.0 tercatat pada
[audit penutupan](#audit-release-close).

Konfigurasi EditorConfig, Git attributes/ignore, Markdownlint, Redocly,
CI, dan adapter IDE dipertahankan karena masih dipakai atau mendukung target
workspace. Rencana SRS yang telah selesai dan notes pembuatan repository
digabung ke sumber aktif; kontrak tetap dipelihara dalam docs.
Tidak ada perubahan izin, konfigurasi global, SDK, atau inisialisasi aplikasi.

<a id="audit-release-close"></a>

## Penutupan verifikasi dan rilis — 20 Oktober 2026

Mandat: [WORKSPACE-RELEASE-CLOSE-008](DECISIONS.md#workspace-release-close-008).
Seluruh sumber aktif dibaca pada rangkaian tugas ini. Ekspor sesi lokal dan
catatan sesi terakhir digunakan sebagai konteks kelanjutan, bukan sumber
normatif baru. Ekspor lokal tersedia saat audit awal. Pada pemeriksaan
penutupan setelah publikasi, ekspor tersebut sudah tidak ditemukan; tidak
ada perintah penghapusan ekspor yang dijalankan pada tahap implementasi ini.

Temuan awal: ekspor codex-session-*.md yang diabaikan Git ikut dipindai,
menyebabkan 7.057 laporan tautan, 318 laporan Markdown, dan satu kegagalan
regresi. Pemeriksaan terisolasi terhadap 36 Markdown aktif tidak menemukan
kesalahan tersebut. Validator dan perintah lint kini mengecualikan ekspor;
regresi baru memastikan handoff aktif tetap diperiksa.

| Pemeriksaan perubahan | Hasil lokal, 20 Oktober 2026 |
|---|---|
| Markdown dan tautan internal | PASS: 36 Markdown aktif, tanpa error; pengecualian ekspor dan cakupan handoff juga diuji melalui fixture regresi |
| YAML skill | PASS: seluruh delapan skill |
| Kontrak dan Redocly 2.64.1 | PASS: 165 skema, 54 contoh, referensi dan invariant replay rahasia; Redocly tanpa error |
| Regresi validator dan ekstraksi catatan rilis | PASS: 25 tes, termasuk pengecualian ekspor dan deteksi tautan rusak pada handoff aktif |
| EditorConfig Checker 4.0.2 dan git diff --check | PASS |

Eksekusi lokal memakai Python 3.10.8 dengan dependensi validator terisolasi;
versi CI tetap Python 3.12. Saat pemeriksaan awal belum ada tag atau Release.
Tiga pekerjaan
[CI commit 3c727fc](https://github.com/muhammadrafifatihulihsan/siagabanjir/actions/runs/39281672439)
sudah berhasil. Perbaikan kemudian dipush melalui Git Bash dengan hasil berikut.

| Bukti publikasi | Hasil terverifikasi |
|---|---|
| Commit rilis | e1e11194b20cad9335901fabeb90d4f7e736f2b1 |
| CI commit rilis | [Run 39296073413](https://github.com/muhammadrafifatihulihsan/siagabanjir/actions/runs/39296073413): ketiga pekerjaan SUCCESS |
| Tag | v0.1.0, tag beranotasi pada commit rilis setelah CI berhasil |
| Workflow Release | [Run 39296208857](https://github.com/muhammadrafifatihulihsan/siagabanjir/actions/runs/39296208857): SUCCESS pada SHA yang sama |
| GitHub Release | [SiagaBanjir v0.1.0](https://github.com/muhammadrafifatihulihsan/siagabanjir/releases/tag/v0.1.0), Latest, bukan draft/prerelease; terbit 20 Oktober 2026 pukul 00.41 WIB |
| Catatan dan unduhan | Isi Release cocok dengan ekstraksi CHANGELOG; arsip source ZIP/tar tersedia, tanpa aset aplikasi |
| Ekspor session lokal | Tidak ditemukan pada pemeriksaan penutupan; handoff aktif tetap tersedia |

Catatan penutupan ini merupakan perubahan dokumentasi sesudah rilis; tag
v0.1.0 tetap menunjuk commit rilis. Hasil CI commit penutupan dapat diperiksa
melalui [Actions main](https://github.com/muhammadrafifatihulihsan/siagabanjir/actions/workflows/ci.yml?query=branch%3Amain).

Dampak living documents: README, CHANGELOG, keputusan, keterlacakan, handoff,
dan catatan ini diperbarui bersama validator serta CI. BRD/PRD/FRD/SRS,
OpenAPI/contoh, DESIGN, AGENTS, rules, delapan skill, adapter IDE, README
aplikasi, dan kebijakan versioning tidak terdampak karena requirement,
kontrak, prosedur persetujuan serta target implementasi tidak berubah.
Pengujian aplikasi/provider/perangkat/UAT dan pemuatan IDE tetap NOT_RUN;
penempatan skill native Codex tetap terhalang izin lokasi yang dicatat sebelumnya.

<a id="readme-publik"></a>

## README untuk pembaca umum — 20 Oktober 2026

Pemilik meminta README utama menjelaskan aplikasi dan manfaatnya dengan bahasa
umum. Isi pengembangan dipindahkan ke panduan yang sudah ada: validasi/CI ke
GITHUB-WORKFLOW, status versi dan struktur ke WORKSPACE, serta navigasi melalui
INDEX. Penanda living document README memakai komentar HTML sesuai aturan
dokumentasi. Rujukan aktif mengikuti lokasi baru.

Pemeriksaan lokal PASS: 36 Markdown dan tautan internal, delapan skill,
EditorConfig, diff, 25 tes regresi, serta validasi 165 skema/54 contoh dan
Redocly. Blok perintah validasi cocok dengan README sebelumnya; pencarian
rujukan aktif tidak menemukan tautan ke bagian teknis README yang telah dipindahkan.
Spesifikasi, kontrak/contoh, DESIGN, AGENTS, adapter IDE, dan README aplikasi
tidak memerlukan perubahan karena fungsi, akses data, platform, dan setup tim
tetap. Riwayat persetujuan serta hasil TC produk tidak berubah.

<a id="commit-lokal-tim"></a>

## Commit lokal dan panduan tim — 20 Oktober 2026

Mandat [WORKSPACE-LOCAL-COMMIT-009](DECISIONS.md#workspace-local-commit-009)
diterapkan melalui AGENTS, workflow, aturan dokumentasi, katalog/skill workspace,
adapter Claude/JetBrains, template PR, dan panduan GitHub. Semua perubahan AI
dicommit lokal per unit utuh tanpa konfirmasi; tree bersih diperiksa sebelum
unit berikut atau penutupan. Push, merge dan rilis tetap mengikuti mandat.

Panduan untuk pemula mencakup istilah, clone/branch, identitas, bantuan AI,
validasi, commit, push/PR, dan kondisi gagal. Kendala data/izin dilaporkan
tanpa memaksa clean dengan kehilangan pekerjaan. SK-E25–SK-E32 mencatat
skenario positif/negatif. Tidak ada hook auto-commit atau perubahan konfigurasi
global/identitas/remote/proteksi branch; instruksi tidak membuktikan kepatuhan
semua harness. Pengujian agent terpisah dan pemuatan IDE tetap NOT_RUN.

Pemeriksaan lokal PASS: 36 Markdown dan tautan, delapan skill, EditorConfig,
diff, 25 tes regresi, 165 skema/54 contoh serta Redocly. Inspeksi statis
SK-E25–SK-E32 memeriksa konsistensi mandat commit, kondisi clean, perlindungan
perubahan awal, checkpoint dan batas push. Ini tidak menaikkan evaluasi perilaku
agent terpisah menjadi PASS. SHA commit, status tree, hasil push dan CI terbaru
diverifikasi saat penutupan; riwayat tersedia di Git dan GitHub Actions.
README publik, spesifikasi/kontrak/contoh, DESIGN, README aplikasi dan workflow
CI/rilis tidak terdampak; perilaku produk serta pemicu otomatisasi tetap.
Keputusan, keterlacakan, indeks, changelog dan handoff diperbarui bersama.

<a id="github-workflow-audit"></a>

## Audit GitHub dan implementasi CI/dokumentasi — 21 Oktober 2026

[Mandat terbaru](DECISIONS.md#workspace-github-workflow-010) menerapkan alur
branch anggota → development → main. [Audit A–H](GITHUB-AUDIT.md) mencatat
metadata GitHub awal, gap dan rancangan kontrol yang belum diterapkan.
Branch implementasi branch-rafi; main/development tidak diperbarui langsung.

Gate lokal PASS: tautan dalam 39 Markdown, delapan skill, 165 skema/54 contoh,
31 tes regresi, Redocly 2.64.1, Markdownlint 0.17.2 dan EditorConfig Checker 4.0.2.
Pemeriksaan diff tidak menemukan whitespace error. Validasi dilakukan dengan
Python 3.10 pada Windows; CI memakai Python 3.12/Linux. Status publikasi
diperiksa melalui SHA remote dan GitHub Actions setelah push.

Commit implementasi dcf9d998f28aa6862f1dbe890441d67407236c06 telah dipush ke
branch-rafi; SHA remote cocok dan working tree bersih sesudah commit.
[CI push](https://github.com/muhammadrafifatihulihsan/siagabanjir/actions/runs/39567181260)
dan [CI PR](https://github.com/muhammadrafifatihulihsan/siagabanjir/actions/runs/39567306249)
berhasil pada SHA tersebut: Validasi Arah PR, Validasi Dokumentasi,
Validasi Kontrak API dan Cek Format EditorConfig semuanya SUCCESS.
[PR #1](https://github.com/muhammadrafifatihulihsan/siagabanjir/pull/1)
adalah draft branch-rafi → development, belum merged. Catatan bukti ini dicommit
sesudah run tersebut; CI pada commit penutupan diperiksa kembali saat publikasi.

Dampak dokumentasi: AGENTS, workflow rule/skill, BRD/PRD aspek Git, keputusan,
RTM, panduan Git/versioning, indeks, handoff, CHANGELOG serta template diperbarui.
README publik, FRD/SRS, OpenAPI/contoh, DESIGN, aturan domain dan adapter IDE
masih sesuai: tidak ada perubahan fitur, arsitektur, routing adapter atau aplikasi.
Tes aplikasi/provider/perangkat/UAT tetap NOT_RUN. Settings/rulesets, merge,
undangan, tag/release dan deploy tidak dilaksanakan. Arsip session mentah tetap
lokal dan ignored; prompt audit aktif menjadi sumber mandat yang dipelihara.

<a id="panduan-git-pemula"></a>

## Panduan praktik Git pemula — 21 Oktober 2026

Mandat pemilik: satu dokumen terpisah di docs dengan langkah salin-tempel dari
clone pertama, kebiasaan harian, hingga PR dan clone pada perangkat lain.
[GIT-UNTUK-PEMULA](GIT-UNTUK-PEMULA.md) menerapkan kebijakan yang sudah ada;
GITHUB-WORKFLOW tetap sumber aturan branch/merge dan versi alat validasi.
README, indeks, panduan GitHub, CHANGELOG dan handoff diperbarui bersama.

Pemeriksaan lokal PASS: tautan dan Markdownlint 0.17.2 pada 40 Markdown,
YAML delapan skill, EditorConfig Checker 4.0.2 pada tujuh file tugas,
31 tes regresi validator, serta 165 skema/54 contoh kontrak. Sintaks 29 blok
contoh diperiksa dengan Git Bash `bash -n`; ini tidak mengeksekusi perintah
clone/push/merge contoh atau membuktikan autentikasi anggota. Review isi
memeriksa arah PR, pilihan branch, status bersih, dan batas fast-forward.
Python bawaan sempat gagal pada tiga assertion karena dependensi format
date-time/URI tidak tersedia; pengulangan memakai environment validator
terisolasi yang sudah tersedia lulus. Markdownlint lulus setelah akses npm
di luar sandbox diizinkan; tidak ada perubahan konfigurasi global.
Contoh perintah membedakan Git Bash/Bash dari PowerShell, memakai pilihan branch
per sesi, dan menghentikan sinkronisasi bila ada commit yang belum terintegrasi.
Login, push, PR dan merge GitHub tidak dijalankan pada tugas dokumentasi ini.

Kelanjutan atas permintaan eksplisit pemilik untuk push: commit panduan
0a01ed68299123eb159b13d5e16c205c767816e3 dipush melalui Git Bash ke branch-rafi,
SHA remote sesuai. Gate Redocly 2.64.1 juga PASS sebelum publikasi.
[CI push panduan](https://github.com/muhammadrafifatihulihsan/siagabanjir/actions/runs/39574964786)
menyelesaikan keempat job dengan SUCCESS. Check arah PR pada event push tidak
menguji pasangan PR. Catatan ini dicommit sesudah run tersebut; hasil CI pada
commit penutupan diverifikasi saat serah hasil, tanpa membuat PR atau merge.

BRD/PRD/FRD/SRS, kontrak/contoh, DESIGN, AGENTS, rules, delapan skill, adapter IDE,
README aplikasi dan CI/rilis tidak terdampak: tidak ada perubahan kebijakan,
produk, perintah aplikasi, atau mekanisme agent. DECISIONS/RTM mempertahankan
keputusan lima branch yang sudah berlaku; mandat editorial dan bukti tugas ini
dicatat di bagian ini. Pengujian aplikasi/provider/perangkat/UAT tetap NOT_RUN.

## Verifikasi perintah main lokal - 21 Oktober 2026

GIT-CEPAT.md lulus pemeriksaan sintaks Bash. Simulasi repository bare lokal
membuktikan clone anggota, rename ke main dengan upstream tetap, pull, commit,
push ke anggota, simulasi merge PR, dan fast-forward dari development. Remote
main tidak berubah; tree fixture bersih. Simulasi tidak mengirim ke GitHub.
Lint 40 Markdown, link internal, delapan skill, EditorConfig pada file berubah,
dan git diff --check lulus. Ini dokumentasi; tes aplikasi tetap NOT_RUN.

Penyederhanaan TXT berikutnya memakai dua siklus dan mengambil pembaruan dari
origin/main setelah kedua PR selesai digabung. Sintaks Bash dan simulasi dua
siklus dengan merge anggota ke development lalu development ke main lulus.
Link internal, lint Markdown, EditorConfig dan diff whitespace lulus.
Perubahan editorial ini tidak mengubah aturan PR, produk, kontrak, skill atau
adapter; sumber tersebut tetap berlaku. Tidak melakukan push pada repo tim.

Versi per anggota menambahkan blok Rafi, Hasan dan Melia serta satu pembaruan
main bersama. Sintaks Bash, kecocokan clone/push/compare ketiga anggota, link
internal, lint Markdown, EditorConfig dan diff whitespace diperiksa lulus.
Alur Git sama dengan simulasi sebelumnya; tidak mengulang tes aplikasi atau
push. Perubahan awal pemilik pada contoh staging/pesan commit dipertahankan.

Pembaruan WS-DEC-050 pada TXT mengganti fast-forward dengan reset hard dan
clean -fd atas mandat pemilik. Simulasi di repo sementara memeriksa isi tracked
kembali sesuai origin/main, untracked terhapus, ignored tetap, serta kegagalan
fetch menghentikan reset/clean. Sintaks Bash, link, lint Markdown, format dan
diff whitespace lulus. Reset/clean tidak dijalankan pada workspace tim.

Konversi Git cepat ke Markdown mempertahankan seluruh perintah secara identik
dengan TXT sebelumnya. Blok Bash, lint Markdown, link internal, skill YAML,
EditorConfig dan diff whitespace diperiksa lulus. Referensi aktif diperbarui;
kontrak, produk, desain, adapter dan CI tidak berubah. Mandat mencakup commit
dan push branch-rafi; SHA serta hasil CI dilaporkan saat serah hasil.
