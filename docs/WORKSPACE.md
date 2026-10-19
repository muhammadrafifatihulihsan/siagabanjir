# Workspace SiagaBanjir

> **Living document:** perbarui bersama setiap perubahan terkait menurut [aturan dokumentasi](../rules/documentation.md#living-documents).

Kondisi 19 Oktober 2026: panduan kerja lintas OS/IDE dan wadah `apps/`.
Backend/Flutter tetap disiapkan tim. UI mendatang mengikuti
[DESIGN](DESIGN.md); setiap perubahan mengikuti
[sinkronisasi dokumentasi](../rules/documentation.md).

## Cakupan dan sumber bersama

[Mandat terbaru](DECISIONS.md#workspace-audit-push-006) mengotorisasi audit,
perbaikan, commit dan push melalui Git Bash. Bacaan penuh dan living documents
tetap mengikuti [mandat sebelumnya](DECISIONS.md#workspace-publish-005).
[Seleksi sebelumnya](DECISIONS.md#workspace-reference-004) memakai setup-softwarebk. [Riset skill sebelumnya](DECISIONS.md#workspace-skills-003)
tetap menjadi dasar panduan. [Mandat apps/UI](DECISIONS.md#workspace-quality-002),
portabilitas dan pembaruan informasi tetap berlaku. Scope panduan pada
[keputusan sebelumnya](DECISIONS.md#workspace-scope-001) tetap berlaku.

| Artefak | Tanggung jawab |
|---|---|
| [AGENTS](../AGENTS.md) | Sumber instruksi bersama dan routing tugas |
| [SKILL](../SKILL.md) | Katalog delapan skill; prosedur pada sumber masing-masing |
| [Rules](../rules/workflow.md) | Workflow, domain, mutu, UI, portabilitas, dokumentasi dan riset |
| [Riset skill](SKILL-RESEARCH.md) | Referensi terpilih, adaptasi dan skenario evaluasi |
| [DESIGN](DESIGN.md) | Token, ikon Material, hierarki, state, kriteria visual/aksesibilitas |
| [apps](../apps/README.md) | server/app untuk setup tim, saat ini hanya penanda kosong |
| [Rekomendasi VS Code](../.vscode/extensions.json) | EditorConfig dan Flutter, opsional; tidak memasang ekstensi/SDK |
| [.editorconfig](../.editorconfig) | Encoding, indentation dan whitespace lintas editor |
| [.gitattributes](../.gitattributes) | EOL teks bersama dan pengecualian binary |
| [.gitignore](../.gitignore) | Rahasia, artefak lokal dan seluruh archive/ dikecualikan Git; tidak ada indeks arsip publik |
| [GitHub](GITHUB-WORKFLOW.md) dan [notes](GITHUB-NOTES.md) | Commit/push/PR dan identitas repo; bukti pada audit final/handoff |
| [CI](../.github/workflows/ci.yml), [validator](../.github/scripts/) dan [dependensi](../.github/requirements-validation.txt) | Gate dokumentasi, format, kontrak/contoh dan regresi validator |

Scaffold aplikasi lama sudah ditarik. Wadah apps yang sekarang berisi tempat
kosong untuk tim; root tidak berisi tools/reports/database/cache aktif.
Fungsi baseline BRD/PRD/FRD/SRS tetap. Errata kontrak menyelaraskan replay
rahasia dengan SRS-IF-004; tidak menambah endpoint atau fitur produk.
Folder archive/tools/contracts sudah dihapus; kontrak aktif berada di docs.

<a id="sumber-acuan"></a>

## Peta sumber acuan

| Kebutuhan | Sumber bersama | Cara menilai perbedaannya |
|---|---|---|
| Tujuan dan batas produk | [BRD](BRD.md), [PRD](PRD.md), mandat terbaru pada [DECISIONS](DECISIONS.md) | Kutipan/keputusan historis tetap dibaca sesuai tanggal dan statusnya |
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
| Windows | Buka root; path relatif, UTF-8 dan EOL mengikuti konfigurasi repo | Inspeksi/pemeriksaan berkas dilakukan di PowerShell pada Windows |
| macOS | Buka root yang sama; gunakan path dan case yang sama | Runtime/editor pada macOS belum diuji |
| Linux | Buka root yang sama; kapitalisasi file harus persis | Runtime/editor pada Linux belum diuji |

EditorConfig menjaga format ketika editor/plugin mendukungnya; Git attributes
mengatur konversi teks/binary. Tidak perlu mengganti Git global.
LF untuk teks umum; bat/cmd memakai CRLF. Folder arsip lokal, bila dibuat
kembali, diabaikan Git dan dikecualikan pemformatan EditorConfig.
Ukuran indentasi Markdown tidak dipaksa kelipatan dua; markdownlint memeriksa
struktur daftar, heading dan blok kode, sementara pemeriksaan EOL tetap aktif.
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
dibaca langsung melalui AGENTS. Pada sesi ini penulisan `.agents/` ditolak;
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
menjalankan prosedur terpilih. Audit lama di bawah mencatat aturan saat itu;
mandat baca lengkap terbaru menggantikan arahan bacaan selektif terdahulu.

<a id="verifikasi"></a>

## Verifikasi

Catatan audit berikut mempertahankan hasil pada waktu masing-masing.
Jumlah berkas, lokasi arsip dan keadaan Git lama bukan status terkini.
Gunakan [audit final](#audit-final) untuk kondisi publikasi saat ini.

### Riwayat 18 Oktober 2026

Sebelum rename, audit lima skill memeriksa 3.622 tautan. Putaran sesudah rename
menghasilkan tabel berikut; ini bukti versi 18 Oktober, bukan versi terbaru.

| Pemeriksaan | Hasil |
|---|---|
| quick_validate.py dari skill-creator, Python -B -X utf8 | PASS, enam SKILL.md |
| Routing AGENTS/katalog, enam rules dan gate dokumentasi di semua skill | PASS inspeksi struktur/isi; bukan pemilihan runtime |
| Tautan lokal dan anchor di 29 Markdown aktif, termasuk adapter tersembunyi | PASS, 3.697 tautan; kapitalisasi path diperiksa persis |
| Path relatif, nama aman lintas OS dan benturan kapitalisasi | PASS inspeksi; 21 panduan tanpa path mesin tertentu atau rujukan folder lama |
| git check-attr pada path representatif | PASS: LF umum/shell, CRLF bat/cmd; arsip tidak dikonversi |
| git check-ignore pada secret, cache dan metadata IDE pribadi | PASS; AGENTS/CLAUDE/adapter serta sumber panduan tetap terlihat Git |
| SHA-256 dokumen approved, kontrak, ekspor sesi vs awal putaran | PASS, 10 berkas tidak berubah: 4 dokumen, 2 kontrak, 4 sesi |
| Snapshot asli vs ukuran/SHA-256 manifest | PASS, 40 entry |
| Root dan wadah aplikasi | PASS: apps/server dan apps/app hanya .gitkeep; folder lama serta utilitas/cache aktif tidak ada |
| Review arahan UI terhadap sumber resmi | PASS inspeksi panduan dan nama ikon; belum tes visual/aplikasi |

Pemeriksaan 18 Oktober dilakukan melalui perintah sementara sesi tanpa menambah runner,
folder reports atau cache. Pencarian path lokal membedakan URL sumber dari
path drive OS. Tidak ada commit, push, instalasi atau inisialisasi aplikasi.

Dokumentasi: README, AGENTS, katalog/skills, rules terkait, DESIGN, adapter,
WORKSPACE, DECISIONS, TRACEABILITY dan handoff diselaraskan. Baseline fungsi,
kontrak serta rule domain tidak berubah karena scope putaran ini adalah
struktur dan panduan kerja/visual. Riwayat keputusan nama lama tetap tersimpan
sebagai sejarah, sementara tautan aktif mengarah ke lokasi sekarang.

### Audit 19 Oktober 2026 — sebelum adaptasi Software-BK

Riset menemukan 138 SKILL.md di 26 direktori paket lokal; 15 dibaca penuh dan
3 secara terpilih, dilengkapi sumber resmi serta tiga skill tim Flutter.
Keputusan adaptasi ada di [SKILL-RESEARCH](SKILL-RESEARCH.md). Dua skill baru
menutup kebutuhan debugging dan verifikasi; tujuh rules menjaga sumber bersama.
Impor Claude diperbaiki; tidak ada instalasi plugin atau source aplikasi.

<!-- workspace-audit-19:start -->
| Pemeriksaan aktual | Hasil |
|---|---|
| Validator skill-creator, Python -B -X utf8 | PASS untuk delapan SKILL.md; masing-masing 41–58 baris |
| Routing dan isi terhadap SK-E01–SK-E14 | PASS inspeksi: cakupan, keluaran, batas mandat serta pemicu positif/negatif konsisten; bukan eksekusi agent |
| Tautan lokal/anchor pada 33 Markdown aktif | PASS, 3.753 tautan; kapitalisasi path diperiksa persis di dalam workspace |
| Nama/path portabel dan format teks | PASS inspeksi: UTF-8 terbaca, tanpa benturan case/nama terlarang; 25 panduan tanpa path mesin atau rujukan wadah lama |
| Impor CLAUDE | PASS statis: @AGENTS.md merujuk file root yang ada, tanpa impor balik; pemuatan client belum diuji |
| Dokumentasi dan gate bersama | PASS: delapan skill merujuk matriks dokumentasi; katalog/AGENTS/tujuh rules selaras |
| Keutuhan baseline, kontrak dan ekspor sesi | PASS SHA-256 vs sebelum edit: 10 berkas identik |
| Snapshot asli vs manifest | PASS ukuran dan SHA-256 untuk 40 entry |
| Kebersihan root dan apps | PASS: app/server hanya .gitkeep; tidak ada project/tools/reports/cache/database/node_modules aktif |
| Inventaris referensi lokal | PASS hitung file: 138 SKILL.md dalam 26 direktori paket; cakupan bacaan dijelaskan terpisah |

Metode: validator bawaan skill-creator dan pemeriksaan Python inline melalui
PowerShell, tanpa menyimpan runner/cache/report. Inspeksi isi menelusuri
skenario ke instruksi yang relevan; tidak ada percobaan sesi agent baru.
Git belum mempunyai baseline commit; file untracked tidak dipakai sebagai
bukti semua berkas dibuat pada putaran ini. Konfigurasi EOL/ignore tidak diubah;
hasil git attributes/ignore tetap dirujuk sebagai audit 18 Oktober.
<!-- workspace-audit-19:end -->

Dokumentasi terdampak: README, AGENTS, katalog/delapan skills, rules terkait,
CLAUDE, DESIGN, riset, WORKSPACE, keputusan/RTM dan handoff. BRD/PRD/FRD/SRS,
kontrak dan domain tidak berubah: prosedur kerja diperjelas tanpa perubahan
fungsi, payload atau hak akses. Adapter JetBrains tetap menunjuk AGENTS sehingga
tidak perlu salinan perubahan. Apps/README dan format repo tetap sesuai scope.

Pemuatan IDE, macOS/Linux runtime, UI aktual, aplikasi, database, provider AI,
perangkat serta evaluasi perilaku agent terpisah: NOT_RUN.
Penempatan skill native Codex: BLOCKED oleh izin sesi pada .agents/.
Validasi berkas/pembacaan melalui AGENTS tersedia, bukan bukti native loading.

<a id="audit-softwarebk"></a>

### Audit adaptasi Software-BK — 19 Oktober 2026

[Seleksi referensi](SKILL-RESEARCH.md#softwarebk) menghasilkan peta sumber,
penguatan batas client API/data, petunjuk perintah aktual, pemisahan lapisan
pemeriksaan dan rekomendasi editor opsional. Delapan skill/tujuh rules tetap;
tidak ada dokumen arsitektur/API baru yang menggandakan SRS.

<!-- workspace-audit-bk:start -->
| Pemeriksaan | Hasil aktual |
|---|---|
| Validator skill-creator, Python -B -X utf8 | PASS, delapan SKILL.md; tidak menambah skill baru |
| Routing/isi dan SK-E15–SK-E18 | PASS inspeksi: seleksi referensi, arti script, prasyarat task dan konflik sumber tercakup; bukan percobaan agent |
| Tautan lokal dan anchor pada 33 Markdown aktif | PASS, 3.797 tautan; path dan kapitalisasi diperiksa dari lokasi file sumber |
| Path/nama dan encoding | PASS inspeksi, 25 panduan tanpa path mesin atau wadah lama; tidak ada benturan case/nama terlarang |
| extensions.json | PASS parse JSON, dua ID rekomendasi sesuai sumber; tidak ada tasks/settings/launch baru |
| git check-ignore | PASS: rekomendasi editor dapat masuk Git; settings pribadi dan .env aplikasi tetap diabaikan |
| Baseline/kontrak/sesi vs awal putaran | PASS SHA-256, 10 berkas identik |
| Snapshot vs manifest | PASS ukuran/SHA-256, 40 entry |
| Referensi setup-softwarebk vs sebelum edit workspace | PASS SHA-256 dan daftar file, 17 berkas tetap identik |
| Apps dan kebersihan root | PASS, app/server hanya .gitkeep; tidak ada project/tools/reports/cache/database/node_modules aktif |

Metode: pemeriksaan inline melalui Python/PowerShell, validator skill yang sudah
tersedia dan pemeriksaan ignore Git. Tidak menyimpan runner atau report baru.
Source berstatus untracked sejak sebelum pekerjaan; tidak ada klaim diff commit
atau hasil runtime dari keadaan tersebut. Konfigurasi EOL/ignore tidak diubah.
<!-- workspace-audit-bk:end -->

Sumber terdampak diselaraskan: README, AGENTS, katalog, rules workflow/
documentation/quality/portability, lima skill terkait, apps/README,
extensions.json, riset, WORKSPACE, DECISIONS/TRACEABILITY dan handoff.
FRD/SRS/BRD/PRD, kontrak, domain, DESIGN dan adapter Claude/JetBrains tetap:
perubahan ini prosedur engineering/editor, tanpa perubahan fungsi atau visual.

Native skill Codex tetap BLOCKED oleh izin .agents/. Pemuatan IDE, pemasangan
ekstensi, macOS/Linux runtime, tes aplikasi/provider/perangkat dan evaluasi sesi
agent terpisah tetap NOT_RUN. Tidak menjalankan task dari proyek referensi.

<a id="audit-publikasi"></a>

## Persiapan GitHub dan living documents — 19 Oktober 2026

**Checkpoint historis sebelum restrukturisasi:** indeks arsip dan angka 44
berkas di bagian ini sudah tidak menggambarkan workspace saat audit final.
Riwayat hasil tidak ditulis ulang; [audit final](#audit-final) menggantikannya
sebagai status terkini.

[Mandat kelima](DECISIONS.md#workspace-publish-005) menggantikan bacaan selektif:
semua dokumentasi/instruksi aktif wajib dibaca penuh. Prosedur kerja/tes tetap
sesuai dampak. Penanda living document di Markdown menunjuk satu aturan
pemeliharaan; AI wajib memperbarui sumber terdampak tanpa pengingat.

[GitHub workflow](GITHUB-WORKFLOW.md) dan template PR menutup kebutuhan
commit/push/review. [Notes GitHub](GITHUB-NOTES.md) disiapkan setelah pemeriksaan.
.gitignore sekarang mengecualikan seluruh isi arsip selain README; tautan
sumber privat di baseline mengarah ke indeks arsip dengan identitas sumber.
Keputusan ini menjaga riwayat lokal sekaligus membuat clone mandiri.

contracts tetap digunakan SRS: 72 operasi, 166 schema, 41 contoh pada baseline.
Tidak ada alasan menghapusnya sebagai sampah. SRS-PLAN masih merekam rencana
tahap yang telah selesai; tetap diberi status historis, bukan agenda setup baru.
FRD/SRS tidak mendapat perubahan requirement atau approval baru karena perapian.

<!-- workspace-audit-publish:start -->
| Pemeriksaan aktual | Hasil |
|---|---|
| Validator bawaan skill-creator, Python -B -X utf8 | PASS, seluruh delapan SKILL.md |
| Kandidat Git sebelum staging | PASS, 44 berkas; satu-satunya isi archive yang ikut adalah README.md |
| Markdown, tautan lokal dan anchor | PASS, 36 Markdown dan 3.868 tautan; case tepat, target tersedia dalam calon clone, tanpa tautan ke arsip privat |
| Living document dan gate bacaan | PASS statis: 36 marker, delapan skill merujuk protokol baca penuh dan matriks dokumentasi; bukan bukti kepatuhan runtime |
| Format, metadata dan portabilitas | PASS: UTF-8/JSON valid, 28 panduan operasional tanpa path mesin, tidak ada benturan case/nama terlarang; impor Claude tetap @AGENTS.md |
| .gitignore dan .gitattributes | PASS git check-ignore/check-attr: arsip mentah/secret/metadata pribadi diabaikan; indeks arsip LF, byte arsip mentah tidak dikonversi |
| Keutuhan kontrak dan arsip lokal | PASS SHA-256: dua kontrak dan 47 berkas arsip mentah identik dengan sebelum perapian |
| Keutuhan isi baseline/rencana | PASS: lima dokumen cocok dengan hash awal setelah membalik hanya marker/rujukan yang diubah secara sengaja; isi requirement tidak diganti |
| Riwayat DECISIONS/TRACEABILITY | PASS hash bagian awal setelah membalik metadata/rujukan; hanya tambahan keputusan terbaru dan penunjuk kondisi terkini |
| Snapshot pemulihan | PASS, ukuran/SHA-256 seluruh 40 entry sesuai manifest |
| Referensi Software-BK | PASS, daftar dan hash 17 berkas tidak berubah |
| Pemindaian credential terarah pada kandidat | Tidak ditemukan pola private key, token GitHub/provider atau URL bercredential; ini bukan audit keamanan menyeluruh |
| Apps dan kebersihan root | PASS, server/app hanya .gitkeep; tidak ada source aplikasi, installer, runner, tools/reports/cache aktif baru |
| Keadaan Git | main belum memiliki commit, tidak ada remote; tidak dilakukan staging, commit, push, PR atau merge |

Metode: pembacaan panduan, inspeksi isi, validator skill tersedia, pemeriksaan
Python inline dan perintah Git read-only. Tidak menyimpan runner/cache/report.
Karena seluruh sumber masih untracked, pemeriksaan memakai snapshot sebelum
edit serta daftar kandidat Git; git diff kosong tidak dipakai sebagai bukti.
Notes dibuat sesudah pemeriksaan utama lalu disertakan dalam pemeriksaan akhir.
<!-- workspace-audit-publish:end -->

Audit putaran ini berfokus pada panduan kerja/publikasi, keterhubungan seluruh
dokumen dan keutuhan isi baseline. Bukan pengujian ulang semantik seluruh
requirement atau evaluasi kepatuhan AI di setiap harness. Pemuatan IDE,
runtime macOS/Linux, aplikasi/provider/perangkat dan percobaan agent terpisah
tetap NOT_RUN. Native skill Codex tetap BLOCKED oleh izin .agents/.

<a id="audit-final"></a>

## Audit final setup ? 19 Oktober 2026

Mandat [WORKSPACE-AUDIT-PUSH-006](DECISIONS.md#workspace-audit-push-006)
mencakup perbaikan dan push melalui Git Bash. Seluruh 52 sumber aktif awal
sudah dibaca penuh pada rangkaian tugas ini, termasuk tujuh rules, delapan
skills, spesifikasi, kontrak, adapter dan konfigurasi. File baru validator/tes
masuk cakupan inspeksi berikutnya. Snapshot sementara sebelum edit menjadi
pembanding; kondisi untracked tidak dianggap diff yang membuktikan perubahan.

**Temuan sebelum perbaikan:** akar kedua validator menunjuk .github, bukan
repo; link checker memeriksa satu Markdown, skill checker gagal menemukan
skills, dan YAML rusak lolos regex. Markdownlint menghasilkan 287 error,
EditorConfig 103 laporan, dan Redocly 74 warning. Kontrak signup menawarkan
replay recovery code yang bertentangan dengan SRS-IF-004.

Perbaikan menambah gate cakupan, parsing YAML nyata, kasus regresi, respons
error aman, pemeriksaan contoh dan langkah EditorConfig yang benar-benar
berjalan. Baseline 72 operasi/166 schema tetap; corpus menjadi 54 contoh
(41 lama + 11 kredensial + 2 konflik rahasia). Versi tool serta dependensi
pemeriksaan dikunci pada CI/requirements, bukan dipasang ke aplikasi.
Pemeriksa format opsional jsonschema dilengkapi melalui extra format; gate
menolak environment yang belum mendukung tanggal/URI agar tidak melewati
validasi diam-diam. Instalasi audit memakai environment sementara terisolasi.

| Pemeriksaan | Hasil pada checkpoint ini |
|---|---|
| Validator tautan/case dan YAML | PASS pada Windows: 38 Markdown dan delapan skills |
| Schema/contoh/referensi dan SRS-IF-004 | PASS: 166 schema dan 54 contoh, termasuk format date-time/email/URI/UUID; environment Python terisolasi |
| Regresi validator | PASS: 20 tes, Python 3.10.8 Windows; meliputi dependensi format hilang dan tanggal/URI tidak sah |
| Markdownlint, Redocly dan EditorConfig setelah edit final | PASS: Markdownlint 0.17.2, 38 Markdown/0 error; Redocly 2.64.1, 0 error/warning; EditorConfig Checker 4.0.2, seluruh 56 kandidat/0 pelanggaran |
| Review perubahan vs snapshot dan kandidat publikasi | PASS: isi non-whitespace FRD/SRS/SRS-PLAN tetap, riwayat register tetap, 41 contoh asli tetap; 56 file, 38 marker living document, pola credential terarah tidak ditemukan |
| Git Bash / akses remote awal | PASS: Git 2.47.1.windows.2, identitas Git tersedia, remote tujuan dapat diakses tanpa branch |
| Commit/push dan CI remote | PENDING: setelah seluruh gate lokal lulus |
| Aplikasi/provider/perangkat/UAT dan pemuatan IDE | NOT_RUN; apps hanya .gitkeep, native skill masih BLOCKED oleh izin .agents |

Koreksi format pada FRD/SRS tidak mengubah requirement. BRD/PRD hanya mendapat
metadata status terkini selain perapian format. DECISIONS/TRACEABILITY menambah
catatan terbaru dan mempertahankan riwayat lama. README, AGENTS, rules terkait,
skill workspace, panduan GitHub/versioning, riset, konfigurasi dan handoff
mengikuti perubahan. DESIGN, aturan domain, isi fungsi skill lain, adapter
Claude/JetBrains dan wadah apps tidak memerlukan perubahan perilaku.

Arsip privat tidak tersedia dalam workspace saat audit; hasil hash arsip pada
checkpoint lama tidak diulang atau diklaim berlaku sekarang. Format/CI/schema
lulus tidak membuktikan keamanan atau kesiapan runtime aplikasi.
