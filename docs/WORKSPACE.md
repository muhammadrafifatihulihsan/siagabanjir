# Workspace SiagaBanjir

> **Living document:** perbarui bersama setiap perubahan terkait menurut [aturan dokumentasi](../rules/documentation.md#living-documents).

Kondisi 23 Oktober 2026: panduan kerja lintas OS/IDE dan wadah `apps/`.
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
| Backend / Flutter | Backend kosong; 15 folder fitur produk dan satu mockup beranda warga dengan aset lokal |
| Pengujian | Widget mockup dan build Web diperiksa; TC produk, provider, perangkat, dan UAT tetap NOT_RUN |

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
| [apps](../apps/README.md) | Backend kosong; [Flutter](../apps/siagabanjir/README.md) memiliki struktur fitur dan mockup beranda; [aset](../apps/siagabanjir/design/README.md) merujuk SVG pemilik |
| [Rekomendasi VS Code](../.vscode/extensions.json) | EditorConfig dan Flutter, opsional; tidak memasang ekstensi/SDK |
| [.editorconfig](../.editorconfig) | Encoding, indentation dan whitespace lintas editor |
| [.gitattributes](../.gitattributes) | EOL teks bersama dan pengecualian binary |
| [.gitignore](../.gitignore) | Rahasia, artefak lokal dan seluruh archive/ dikecualikan Git; tidak ada indeks arsip publik |
| [GitHub](GITHUB-WORKFLOW.md) dan [versioning](VERSIONING.md) | Commit/push/PR dan identitas repo; bukti pada audit final/handoff |
| [.github](../.github/) | CI, rilis, validator, dan template pull request |
| [CI](../.github/workflows/ci.yml), [validator](../.github/scripts/) dan [dependensi](../.github/requirements-validation.txt) | Gate dokumentasi, format, kontrak/contoh dan regresi validator |

Scaffold aplikasi lama sudah ditarik. Tim kemudian membuat scaffold Flutter
di apps/siagabanjir; apps/server masih kosong. Root tidak berisi tools/reports/database/cache aktif.
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
| Struktur Flutter dan pembagian fitur | [README Flutter](../apps/siagabanjir/README.md) | Folder tersedia tidak berarti fitur atau kontrak repository sudah diimplementasikan |
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
XML di apps/siagabanjir/android juga memakai indent_size unset untuk menerima alignment
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

<a id="flutter-feature-first"></a>

## Struktur Flutter Feature-First - 23 Oktober 2026

[WS-DEC-051](DECISIONS.md#flutter-feature-first-051) menambahkan 53 placeholder:
45 layer pada 15 fitur, tujuh lokasi app/core/shared, dan satu test/features.
[README Flutter](../apps/siagabanjir/README.md) menjadi panduan struktur dan pembagian
kerja. Counter, tes bawaan, manifest, lockfile, platform dan backend tetap.

Pemeriksaan lokal Windows PASS: 53 placeholder kosong dan cakupan 15 fitur,
Markdownlint 0.17.2 pada 41 Markdown tracked, tautan internal pada 41 Markdown,
EditorConfig Checker 4.0.2, serta git diff --check. Hanya tujuh Markdown dan
53 penanda kosong berubah. Lint awal dengan glob luas ikut memeriksa dokumentasi
vendor dalam cache lokal; pemeriksaan akhir memakai daftar Markdown tracked
dari git ls-files, tanpa mengubah aturan lint/CI atau ignore repository.
Runtime Flutter, provider/perangkat, lintas OS dan CI remote NOT_RUN.

Dokumentasi terdampak: README aplikasi/indeks apps, WORKSPACE, DECISIONS,
TRACEABILITY, handoff dan CHANGELOG. README publik, spesifikasi/kontrak, DESIGN,
AGENTS, rules, skills dan adapter tetap sesuai: tidak ada perubahan perilaku,
path panduan lama, atau cara pemuatan instruksi. Baseline dan TC produk tetap.

<a id="home-mockup"></a>

## Mockup beranda warga - 23 Oktober 2026

Mandat [WS-DEC-052](DECISIONS.md#home-mockup-052): satu layar berdasarkan SVG
pemilik dan panel pratinjau lokal. Source SVG dan 17 slice vector dipelihara
untuk regenerasi; hanya PNG ikon 24.295 byte masuk bundle runtime.
Tidak menambah package Flutter, backend, akses perangkat atau persistensi.

Bukti lokal Windows, Flutter 3.47.7 stable / Dart 3.13.5:

- PASS flutter analyze dan delapan widget test: aset lokal, seluruh pintu masuk
  panel/kembali, notifikasi/menu Lengkap, scroll Beranda, lebar 320/390/1024,
  text scale 2 pada 320, label aksesibel, target sentuh Android dan kontras teks
  pada viewport tes. Temuan wrap badge dan kontras diperbaiki sebelum hasil akhir.
- PASS build Web dengan no-web-resources-cdn dan no-wasm-dry-run. Browser Chrome
  headless memblokir seluruh URL eksternal: nol permintaan eksternal dan nol
  page error pada beranda/panel. Aktivasi dan kembali dengan keyboard lulus.
- Inspeksi visual membandingkan SVG dengan render 390 x 1097 serta viewport
  320 x 640 dan 1024 x 768. [Pratinjau](../apps/siagabanjir/design/beranda-preview.png)
  disimpan; perubahan dari SVG terbatas adaptasi layout, label contoh, target
  sentuh, font bawaan dan kontras. Bukan klaim kesamaan setiap piksel.
- PASS Markdownlint 0.17.2 dan tautan internal pada 42 Markdown, metadata delapan
  skill, EditorConfig Checker 4.0.2 dan git diff --check. Skrip slicing dijalankan
  ulang setelah perbaikan indentasi/EOL; 17 PNG RGBA berukuran 3x sesuai mask,
  SVG mandiri tanpa referensi eksternal, dan salinan SVG identik dengan sumber.

Android build/perangkat, TalkBack, integrasi API, provider, TC produk/UAT dan
CI remote NOT_RUN. Tidak mengklaim aksesibilitas penuh dari tes widget/browser.

README aplikasi/apps, DESIGN, rule UI, skill UI, keputusan, RTM, handoff dan
CHANGELOG diselaraskan. FRD/SRS/kontrak dan TC produk tidak berubah karena
mockup belum mengimplementasikan perilaku bisnis; AGENTS/adapter/README publik
tetap sesuai cakupan dan tidak perlu perubahan mekanisme instruksi.

<a id="home-local-font"></a>

## Revisi font lokal beranda - 23 Oktober 2026

[WS-DEC-053](DECISIONS.md#home-font-053) mengganti font bawaan dengan Inter 4.1
lokal, lima weight asli, serta menghapus dua label development dari beranda.
[Aset dan lisensi](../apps/siagabanjir/design/README.md#font-inter-lokal) menjadi acuan.
Screenshot beranda yang ditautkan pada bukti sebelumnya kini mengikuti revisi
ini; bukti sebelumnya mencatat hasil implementasi pertama.

PASS analyzer dan delapan tes widget yang memuat aset font Inter, termasuk
layout 320/390/1024, skala teks 2, label, target sentuh dan kontras pada viewport
tes. Build Web tanpa CDN lulus. Chrome headless memuat kelima font Inter dari
aset lokal, tanpa permintaan eksternal atau page error; dua label tidak ada
di layar, panel tetap dapat dibuka/ditutup. Screenshot diperbarui dan diperiksa
pada 390 x 1097; viewport 320 x 640 juga direkam untuk pemeriksaan layout.
PASS Markdownlint 0.17.2 dan tautan internal pada 42 Markdown, EditorConfig
Checker 4.0.2 serta git diff --check. Tidak menambah package atau mengubah lockfile.
Android/perangkat, TalkBack, TC bisnis dan CI remote tetap NOT_RUN.

README aplikasi, catatan aset, DESIGN, keputusan, RTM, handoff dan CHANGELOG
diperbarui; lisensi font dicakup pada LICENSE dan OTF ditandai binary.
FRD/SRS/kontrak, backend, AGENTS/rules/skills/adapter tetap karena revisi ini
hanya font dan dua label pada satu mockup. Tidak mengganti nama aplikasi/folder.

<a id="home-layout-name"></a>

## Layout beranda dan penamaan - 23 Oktober 2026

[WS-DEC-054](DECISIONS.md#home-layout-name-054) memindahkan Flutter ke
apps/siagabanjir, mengganti package Dart/import ke siagabanjir serta label
Android, judul/manifest Web ke SiagaBanjir. ApplicationId Android tetap.
Folder lama sempat terkunci Windows; pemindahan isi berhasil dan folder lama
sudah tidak ada. Tidak mengubah konfigurasi global/izin atau backend.

Temuan: Flexible/Expanded pada header kartu menyisakan ruang kanan dan
membatasi badge; ikon menyempitkan deskripsi pada layar kecil. Header kini
memakai lebar alami dengan wrap, deskripsi memakai seluruh lebar saat sempit.
Label pendukung/navigasi 12, judul kartu 16, isi 14 dan tinggi baris 1.4 memakai
Inter lokal. Inspeksi lanjutan menemukan badge akses cepat pecah di tengah
kata pada 320; wrap utuh diperbaiki dan dimasukkan ke regresi.

Bukti lokal Windows, Flutter 3.47.7 / Dart 3.13.5:

- PASS pub get offline setelah rename; lockfile/dependensi tetap.
- PASS analyzer dan 12 widget test: navigasi/kembali, aset lokal, layar
  320/360/390/1024, skala teks 1/1.3/2, perataan status kanan dan deskripsi
  lebar pada 320. Label, target sentuh Android dan kontras diperiksa sebelum
  dan sesudah scroll ke kartu bawah dengan font Inter asli.
- PASS build Web tanpa CDN. Chrome headless pada 320/360/390/1024 memblokir
  URL eksternal: nol permintaan eksternal dan nol page error, judul SiagaBanjir.
  Screenshot awal dan [kartu bawah](../apps/siagabanjir/design/beranda-cards-preview.png)
  diperbarui. Inspeksi visual pada 320 dan 390 memeriksa wrap badge, perataan
  kartu dan ruang deskripsi; tidak mengklaim kesamaan setiap piksel Figma.
- PASS Markdownlint 0.17.2 dan tautan pada 42 Markdown, YAML delapan skill,
  EditorConfig Checker 4.0.2 serta diff whitespace. Seluruh 139 file proyek
  lama tersedia di folder baru; font, ikon, SVG sumber dan lockfile identik.
- Nama Android diverifikasi pada manifest sumber; build APK, perangkat Android,
  TalkBack, TC bisnis dan CI remote NOT_RUN.

Referensi aktif pada AGENTS, workflow, skill workspace/Flutter, README apps,
DESIGN, panduan CI, LICENSE, keputusan, RTM dan handoff mengikuti path baru.
Uraian historis tetap mencatat nama saat itu; tautannya menuju sumber saat ini.
Adapter IDE dan katalog tetap merujuk sumber bersama tanpa path aplikasi,
sehingga tidak memerlukan perubahan. FRD/SRS/kontrak/backend tetap karena
perubahan hanya layout dan penamaan, tanpa perubahan fungsi atau data produk.

### Perapian ikon dua kartu

Revisi berikutnya atas permintaan pemilik hanya mengubah HomeFeatureAction:
ikon utama dan chevron rata tengah terhadap blok teks; padding atas chevron
dihapus. Lingkaran 44 tetap; widget dokumen 24 dan kamera 22 menyeimbangkan
bentang glyph terlihat sekitar 21 berdasarkan alpha bounds aset slice.
Aset asli, font, header kartu, akses cepat dan navbar tidak berubah.

PASS analyzer, 12 tes widget dan build Web tanpa CDN. Screenshot diperbarui;
inspeksi browser pada 320 dan 390 memeriksa perataan ikon/chevron. Nol request
eksternal dan page error. Android fisik/TalkBack tetap NOT_RUN.
DESIGN, catatan aset, handoff dan changelog diperbarui; requirement, kontrak,
struktur, penamaan, rules/skills/adapter tidak terdampak oleh perapian ini.

<a id="branding-startup"></a>

## Ikon dan splash SiagaBanjir - 23 Oktober 2026

[WS-DEC-055](DECISIONS.md#branding-startup-055) memakai path logo tetes air
pemilik untuk mengganti seluruh ikon Flutter bawaan yang direferensikan
launcher Android dan Web. Generator lokal menghasilkan bitmap/vector;
Android mendukung adaptive/monochrome dan splash API 31 serta sebelumnya.
Web memakai logo dan Inter lokal hingga runApp selesai, tanpa delay paksa.

Bukti aktual Windows:

- PASS build APK debug; aapt dump badging membaca label SiagaBanjir dan
  resource launcher baru. APK lokal di build/app/outputs/flutter-apk.
- PASS build Web tanpa CDN. Chrome headless menahan main.dart.js untuk
  merekam [splash](../apps/siagabanjir/design/splash-web-preview.png), lalu
  melepasnya dan memastikan splash dihapus serta flutter-view tersedia.
- PASS simulasi unduhan engine gagal: pesan/retry muncul, muat ulang setelah
  koneksi dipulihkan berhasil masuk aplikasi. Temuan awal error preload belum
  tertangkap diperbaiki dengan handler startup sebelum hasil PASS.
- Browser normal: nol permintaan eksternal dan nol page error.
- PASS XML resource, dimensi seluruh ikon dan area aman maskable Web.
  Regenerasi aset berhasil; Markdownlint/tautan 42 Markdown, EditorConfig
  Checker 4.0.2 dan pemeriksaan diff lulus setelah koreksi format.
- Android fisik, masking launcher aktual, cold start light/night dan TalkBack
  NOT_RUN. ADB menemukan perangkat tetapi tidak melakukan install/launch.
  Build tidak membuktikan tampilan semua versi Android.

DESIGN, README aplikasi/aset, keputusan, RTM, changelog dan handoff diperbarui.
AGENTS/rules/skills/adapter, requirement/kontrak dan backend tidak berubah:
mandat hanya identitas visual startup, tanpa perubahan fitur, struktur atau
cara pemuatan instruksi. Source Dart dan dependensi Flutter tetap.

<a id="report-create-ui"></a>

## Halaman buat laporan Flutter - 25 Oktober 2026

Mandat [WS-DEC-056](DECISIONS.md#report-create-ui-056) menghasilkan halaman
buat laporan dari SVG pemilik, route dari dua tombol beranda, state pilihan
lokal dan konfirmasi keluar. Header/ikon lintas fitur berada di shared/widgets.

| Pemeriksaan lokal Windows | Hasil dan cakupan |
|---|---|
| Dart format lib/test | PASS, formatter SDK lokal |
| flutter analyze --no-pub | PASS, tanpa isu |
| flutter test --no-pub | PASS, 18 tes; regresi beranda dan 6 tes laporan |
| Responsivitas laporan | PASS widget 320 x 640, teks 1x/2x, inset keyboard 250 |
| Interaksi laporan | PASS dua route, pilihan, kamera/GPS/kirim belum tersedia, panel riwayat, batal/konfirmasi keluar |
| Aksesibilitas otomatis | PASS label, target Android 48 dan kontras; kontrol laporan pada viewport penuh 390 x 1600 |
| flutter build web --no-pub --no-web-resources-cdn --no-wasm-dry-run | PASS, build lokal |
| Inspeksi Chrome headless | PASS, route Lapor dan screenshot 390 x 1421, scale 2 |
| Markdownlint 0.17.2 | PASS, 10 dokumen terdampak |
| Link internal dan skill | PASS, 42 Markdown dan 8 skill |
| EditorConfig checker 4.0.2 / git diff --check | PASS |
| Android fisik, TalkBack, kamera, GPS, API, provider, offline | NOT_RUN, integrasi belum tersedia |

[Pratinjau laporan](../apps/siagabanjir/design/reports-create-preview.png)
adalah hasil build Web, bukan screenshot Android. Kategori/kebutuhan hanya
state desain; deskripsi tidak ditandai opsional. Alamat contoh dan dialog
keterbatasan tidak menyatakan aksi bisnis berhasil. Tidak ada perubahan status
TC bisnis atau kontrak. BRD/PRD/FRD/SRS, AGENTS, rules, skills dan adapter tidak
memerlukan perubahan aturan; perubahan status/keputusan dicatat di README,
DESIGN, keputusan, RTM, handoff dan changelog.

Flutter pada sandbox sempat tertahan mengakses lock cache SDK di luar workspace;
analisis, tes dan build berhasil dengan izin eksekusi SDK. Temuan awal tes
(import semantics, cleanup handle, kontrol terpotong viewport tes) diperbaiki
sebelum hasil PASS di atas. Validator EditorConfig 4.0.2 diunduh ke folder
sementara sesuai versi CI; Markdownlint berjalan melalui npx.cmd. Tidak ada
instalasi dependency aplikasi baru, perubahan global config atau push.

<a id="report-uiux-refinement"></a>

## Revisi UI/UX dan slicing laporan - 25 Oktober 2026

Mandat [WS-DEC-057](DECISIONS.md#report-uiux-057) melanjutkan desain laporan
agar prinsip UI/UX dan pemisahan widget mengikuti home. Temuan inspeksi:
navbar terduplikasi dan berbeda ikon/jarak, kategori 12 hanya ditandai warna,
pilihan kebutuhan terisi otomatis, label deskripsi hilang ketika mengetik,
dan perisai hijau berpotensi terbaca sebagai verifikasi. Revisi mengatasi
hal tersebut melalui navbar bersama, teks 14, radio/checkbox, pilihan kosong,
label menetap, fokus jelas dan informasi kamera netral.

ReportCreateScreen turun dari 568 menjadi sekitar 158 baris; layar tetap
mengelola lifecycle/state/navigasi. Enam widget/helper di presentation/widgets
memisahkan susunan form, foto/lokasi, pilihan, deskripsi, section dan dialog.
Masing-masing sekitar 43-150 baris, mengikuti tanggung jawab widget home.
Komentar `// ...` berbahasa Indonesia menjelaskan bagian dan alasan interaksi.
Tes dipecah menjadi alur route, input, layout dan helper setup bersama.

| Pemeriksaan Windows | Hasil dan cakupan |
|---|---|
| flutter analyze --no-pub | PASS, tanpa isu setelah koreksi format tes |
| flutter test --no-pub | PASS, 23 tes (12 home dan 11 laporan) |
| Input/navigasi | PASS pilihan kosong, batal pilihan/isian, kategori eksklusif, Tab/Space, retensi teks, pemulihan fokus, tab aktif kembali ke atas |
| Layout | PASS widget 320 x 640 teks 1x/2x dan keyboard 250, 844 x 390, 1024 x 768 |
| Aksesibilitas otomatis | PASS label, target 48 dan kontras; seluruh kontrol laporan pada 390 x 1900 |
| Build Web lokal | PASS --no-pub --no-web-resources-cdn --no-wasm-dry-run |
| Inspeksi visual Chrome | PASS screenshot 390 x 1700 dan 320 x 640, scale 2 |
| Dokumentasi/format | PASS Markdownlint 0.17.2 (8 dokumen), link (42 Markdown), 8 skill, EditorConfig 4.0.2 dan git diff --check |
| Android fisik/TalkBack/API/perangkat | NOT_RUN; kamera, GPS, penyimpanan dan kirim belum terintegrasi |

[Screenshot penuh](../apps/siagabanjir/design/reports-create-preview.png) dan
[layar sempit](../apps/siagabanjir/design/reports-create-mobile-preview.png)
memakai build Web lokal. Tidak ada klaim pixel-perfect atau penerimaan TC bisnis.
Pemeriksaan awal memperbaiki constructor Semantics, format kode dan traversal
fokus tes Android sebelum hasil akhir. Tidak ada perubahan dependency aplikasi.

Dokumentasi terdampak: README Flutter/desain, DESIGN, DECISIONS, TRACEABILITY,
handoff dan changelog. README root/apps tetap menggambarkan status pratinjau
secara akurat; AGENTS/rules/skills/adapter tidak berubah karena prosedur/lokasi
sumber bersama tetap. FRD/SRS/kontrak tidak berubah: revisi hanya UI lokal.

<a id="auth-login-ui"></a>

## Halaman Masuk ke Akun (Login) - 26 Oktober 2026

Mandat [WS-DEC-058](DECISIONS.md#auth-login-058) menghasilkan halaman masuk ke akun
(login) pada fitur `auth` sesuai SVG pemilik (`auth_login.svg`).

| Pemeriksaan Windows | Hasil dan cakupan |
|---|---|
| flutter analyze --no-pub | PASS, 0 issue (bersih) |
| flutter test --no-pub | PASS, 40 tes (12 home, 11 reports, 8 account, 9 auth) |
| Input dan interaksi login | PASS validasi input kosong, toggle sandi/PIN, checkbox Ingat Saya, link Lupa Sandi, tombol submit dan tombol Google |
| Responsivitas login | PASS widget 320 x 640 teks 1.0x dan 2.0x, 390 x 844 teks 1.0x dan 2.0x, 390 x 1097, 1024 x 768, keyboard inset 250 |
| Perbaikan sisa conflict | PASS membersihkan conflict markers pada HomeNavigation dan memperbaiki import CitizenHeader pada ProfileScreen |
| API/perangkat/OAuth nyata | NOT_RUN; integrasi backend dan OAuth Google belum tersedia |

<a id="messages-inbox-ui"></a>

## Kotak masuk pesan peringatan siaga - 25 Oktober 2026

Mandat [WS-DEC-058](DECISIONS.md#messages-inbox-ui-058) menghasilkan halaman
kotak masuk peringatan siaga warga dari acuan messages_inbox.svg yang diserahkan pemilik.
Layar diakses melalui tombol notifikasi pada CitizenHeader di beranda maupun laporan.

Struktur dan widget di lib/features/messages/presentation:

- MessagesHeader: tombol kembali (rounded 14, border #E2E8F0, touch target 48),
  judul "Peringatan Siaga" 20/700, dan badge status "3 Baru" 14/700 #DC2626.
- MessagesFilterTabs: pill tabs horizontal (Semua, Darurat, Cuaca BMKG, Posko).
- MessageCard: kartu pesan dengan aksen garis semantik 4 px (merah untuk Siaga 2,
  oranye untuk Potensi Banjir, biru untuk Posko, netral untuk Normal), instansi pengirim,
  judul, deskripsi, dan tombol aksi (Rute Evakuasi, Bagikan, Hubungi Posko).
- Dialog penjelasan aksi demo (message_dialogs.dart).
- Navigasi bawah menggunakan CitizenNavigation bersama.
- Render SVG ke PNG pada viewport 390 x 1094 tersimpan di
  [messages-inbox-preview.png](../apps/siagabanjir/design/messages-inbox-preview.png).
- Android fisik, push notification, backend, TC bisnis dan CI remote NOT_RUN.

Dokumentasi terdampak: README Flutter/desain/apps, DESIGN, DECISIONS, TRACEABILITY,
handoff, dan CHANGELOG.

<a id="emergency-bag-ui"></a>

## Checklist tas siaga bencana - 26 Oktober 2026

Mandat [WS-DEC-059](DECISIONS.md#emergency-bag-ui-059) menghasilkan halaman
checklist tas siaga bencana warga dari acuan `emergency_bag_checklist.svg` yang diserahkan pemilik.
Layar diakses melalui tombol akses cepat "Tas Siaga" di beranda dan rute aplikasi.

Struktur dan widget di lib/features/emergency_bag:

- Domain `EmergencyBagItem` dan `EmergencyBagCategory` di `domain/emergency_bag_item.dart`
  memuat 14 item default pada 4 kategori (Dokumen Berharga, Obat & P3K Keluarga, Logistik & Komunikasi,
  Pakaian & Perlengkapan) dengan 12 item awal tercentang (85%).
- `EmergencyBagHeader`: tombol kembali (rounded 14, border #E2E8F0, touch target 48),
  dan judul "Tas Siaga Bencana" 20/700.
- `EmergencyBagSummaryCard`: kartu ringkasan kesiapan logistik keluarga dengan badge persentase dinamis,
  penghitung barang tercentang "$checkedCount dari $totalCount Barang" 24/800, progress bar biru,
  dan deskripsi kesiapan 3 hari. Menggunakan Expanded pada judul baris atas agar aman pada layar sempit dan pembesaran teks.
- `EmergencyBagCategoryCard`: kartu per kategori dengan ikon semantik, penghitung status kategori
  (misal 3/3, 2/4 dengan warna oranye saat belum lengkap), dan item checklist interaktif dengan
  checkbox rounded kustom (status centang hijau emerald #10B981, belum tercentang border #CBD5E1)
  serta touch target minimal 48 px.
- `EmergencyBagInfoBanner`: banner himbauan penempatan tas siaga di dekat pintu utama.
- Navigasi bawah menggunakan `CitizenNavigation` bersama.
- Render SVG acuan ke PNG pada viewport 390 x 1300 tersimpan di
  [emergency-bag-preview.png](../apps/siagabanjir/design/emergency-bag-preview.png).

| Pemeriksaan | Hasil dan cakupan |
|---|---|
| flutter analyze | PASS (No issues found) |
| flutter test | PASS (32 pengujian: 4 emergency bag, 13 home, 3 messages, 12 reports) |
| Interaktivitas checklist | PASS (toggle item memperbarui persentase, penghitung total, dan status per kategori secara reaktif) |
| Layout & Responsivitas | PASS (bebas overflow pada ukuran 320x640, 390x844, 844x390, 1024x768, dan text scaling 2.0) |
| Aksesibilitas | PASS (target sentuh >= 48x48, Semantics checked/label pada checkbox dan tombol kembali) |
| Android fisik / Backend cloud | NOT_RUN (implementasi UI lokal; sinkronisasi backend di luar mandat) |

Dokumentasi terdampak: README Flutter/desain/apps, DESIGN, DECISIONS, TRACEABILITY,
handoff, dan CHANGELOG.

<a id="auth-register-ui"></a>

## Layar pendaftaran akun baru (register) - 26 Oktober 2026

Mandat [WS-DEC-060](DECISIONS.md#auth-register-ui-060) menghasilkan layar
pendaftaran akun baru warga dari acuan `auth_register.svg` yang diserahkan pemilik.
Layar terhubung secara dua arah dengan `LoginScreen`.

Struktur dan widget di `lib/features/auth/presentation`:

- `RegisterScreen`: layar utama formulir pendaftaran, menampung logo identitas SiagaBanjir,
  kartu formulir, serta footer tautan kembali ke halaman masuk.
- `RegisterCard`: kartu formulir putih bertepi (radius 22, border #E2E8F0, padding 22)
  dengan judul 'Daftar Akun Baru', subjudul 'Daftar untuk pantau air dan lapor banjir cepat.',
  input nama lengkap KTP, input nomor ponsel/email, input kata sandi akun dengan toggle
  visibilitas, checkbox kustom persetujuan Ketentuan Layanan & Privasi, tombol submit primer
  'Daftar ke SiagaBanjir >', garis pemisah 'atau', serta tombol pendaftaran Google dengan
  logo 4 warna kurva SVG.
- `RegisterFooter`: tautan 'Sudah punya akun? Masuk Sekarang'.
- Integrasi alur: `LoginScreen` membuka `RegisterScreen` via navigasi saat 'Daftar Sekarang'
  ditekan, dan `RegisterScreen` kembali ke `LoginScreen` saat 'Masuk Sekarang' ditekan.

| Pemeriksaan | Hasil dan cakupan |
|---|---|
| flutter analyze | PASS (No issues found, 0 warnings/lints) |
| flutter test | PASS (59 pengujian total, termasuk 10 tes spesifik RegisterScreen) |
| Validasi form & error | PASS (validasi nama kosong, nomor/email kosong, sandi kosong, dan syarat ketentuan) |
| Layout & Responsivitas | PASS (bebas overflow pada ukuran 320x640, 390x844, 390x1097, 1024x768, keyboard inset 250, dan text scaling 2.0x) |
| Aksesibilitas | PASS (target sentuh >= 48x48, Semantics pada input/tombol/tautan/checkbox) |
| Navigasi dua arah | PASS (LoginScreen <-> RegisterScreen transisi mulus) |
| Android fisik / Backend cloud | NOT_RUN (implementasi UI lokal; API server di luar mandat) |

Dokumentasi terdampak: README Flutter/apps, DESIGN, DECISIONS, SESSION-HANDOFF,
dan CHANGELOG.
