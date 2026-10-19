# Riset dan seleksi skill SiagaBanjir

> **Living document:** perbarui bersama setiap perubahan terkait menurut [aturan dokumentasi](../rules/documentation.md#living-documents).

Tanggal: **19 Oktober 2026**. Mandat: [WORKSPACE-SKILLS-003](DECISIONS.md#workspace-skills-003).
Putaran lanjutan: [seleksi Software-BK](#softwarebk), mandat
[WORKSPACE-REFERENCE-004](DECISIONS.md#workspace-reference-004).
Putaran sebelumnya: [baca lengkap dan publikasi](#publikasi), mandat
[WORKSPACE-PUBLISH-005](DECISIONS.md#workspace-publish-005).
Putaran terkini: [audit final skill](#audit-skill-final), mandat
[WORKSPACE-AUDIT-PUSH-006](DECISIONS.md#workspace-audit-push-006).
Tujuan: prosedur kerja yang cocok dengan baseline dan setup tim, tanpa menambah
aplikasi, layanan, installer atau bundel tool. Ikuti [aturan riset](../rules/research.md).

## Metode dan batas bacaan

Koleksi lokal adalah folder **SKILLS** yang ditunjuk pemilik dalam percakapan,
di luar repository. Inventaris menemukan **138 SKILL.md pada 26 direktori
paket**. Ini hitungan file yang sudah diekstrak; isi ZIP tidak diaudit.

Dari inventaris, **15 SKILL.md dibaca penuh dan 3 dibaca pada bagian terpilih**.
Seluruh koleksi tidak diklaim telah diaudit. Referensi dibaca sebagai bahan
kajian, tidak diaktifkan sebagai instruksi proyek, disalin massal atau dieksekusi.
Path di tabel relatif terhadap koleksi tersebut, bukan dependency workspace.

Metadata lokal Engineering/Design menyebut author Anthropic; label itu tidak
memverifikasi asal paket. Lisensi dan riwayat unduhan seluruh koleksi belum
diverifikasi. Skill SiagaBanjir ditulis khusus dengan contoh/domain sendiri;
tidak menyertakan kode, script, template atau teks panjang paket pihak ketiga.

## Seleksi referensi lokal

Singkatan path untuk menghindari pengulangan: E =
`Engineering-1.2.0-v1/skills/`, D = `Design-1.2.0-v1/skills/`,
A = `AI Skills-0.2.5-v2/skills/`. Setiap nama di bawah berakhir `/SKILL.md`.

| Referensi | Bacaan | Keputusan untuk proyek |
|---|---|---|
| E: debug | Penuh | Reproduksi, hipotesis pembeda, akar masalah dan regresi menjadi skill debug |
| E: code-review | Penuh | Temuan dengan pemicu, dampak dan lokasi; tidak mewajibkan connector/issue eksternal |
| E: testing-strategy | Penuh | Pilih lapisan tes sesuai risiko; tidak menuntut coverage 100% atau tes getter |
| E: documentation | Penuh | Informasi mutakhir dan sesuai pembaca; mempertajam gate dokumen yang sudah ada |
| D: ux-copy | Penuh | Label aksi dan error konkret; penyebab hanya disebut jika diketahui |
| D: design-handoff | Penuh | Konteks, state, token dan interaksi diperiksa; tidak mewajibkan Figma/report terpisah |
| D: accessibility-review | Penuh | Bukti keyboard/screen reader; klasifikasi target size harus dikoreksi dari sumber W3C |
| D: design-critique | Penuh | Temuan visual spesifik dan dampak pada tugas; tidak memaksakan redesign |
| D: design-system | Penuh | Gunakan kembali token/komponen dan state; tidak menambah skor buatan atau publikasi wiki |
| anti-ui-slop | Penuh | Hirarki sesuai tugas dan data sah; tidak mengadopsi kewajiban Figma/premium aesthetic |
| design-critique-ai-reviewer | Penuh | Pisahkan bukti dari asumsi; review tidak otomatis memberi mandat edit |
| A: project-config | Penuh | Perintah/versi harus berasal dari manifest aktual; tidak membuat LOCAL.md atau mewajibkan subagent |
| A: done | Penuh | Handoff seperlunya; tidak mengadopsi dependency atlas/vault, archive atau shutdown workflow lain |
| ffmpeg-llm-0.1.0-v2/skills/ffmpeg-command | Penuh | Probe dan keluaran sesuai tujuan; resep overwrite umum tidak diadopsi |
| brand-md-0.2.0-v1/skills/brand | Penuh | Klaim berdasarkan bukti dan keputusan visual jelas; tidak perlu BRAND.md tambahan |
| better-interface-ui | Bagian terpilih | Hierarki, state, aksesibilitas dan konsistensi ikon; contoh CSS/HTML tidak dipindahkan ke Flutter |
| anti-ai-writing-2.1.0-v2/skills/anti-ai-writing | Bagian terpilih | Utamakan makna/istilah tepat, pertahankan kutipan sejarah; bukan daftar larangan kata Inggris untuk semua teks Indonesia |
| workflow-audit-3.1.0-v1/skills/workflow-audit | Bagian terpilih | Telusuri aksi sampai hasil tersimpan dan jalan keluar; tidak mengadopsi SwiftUI, folder audit atau pertanyaan wajibnya |

Bagian terpilih yang dibaca: better-interface-ui baris 1–180, 296–327, 435–488,
1102–1213; anti-ai-writing baris 1–66 dan 194–269; workflow-audit baris 1–32,
79–182 dan 297–353. Judul bagian juga dipakai untuk seleksi. Berkas references,
script dan dependency skill tidak otomatis termasuk cakupan bacaan ini.

Temuan yang memengaruhi adaptasi:

- anti-ui-slop, better-interface-ui dan design-critique-ai-reviewer tidak memiliki
  frontmatter YAML name/description. Isinya dapat menjadi referensi; format itu
  tidak langsung memenuhi struktur minimum Agent Skills.
- accessibility-review lokal menempatkan SC 2.5.5 / 44 CSS pixels dalam ringkasan
  AA. W3C menggolongkannya **AAA**. DESIGN tetap membedakan target proyek 48
  logical pixels dari WCAG 2.2 AA SC 2.5.8; tidak menyalin klasifikasi yang keliru.
- ffmpeg-command menyarankan overwrite secara umum. Backend proyek menjaga
  bukti asli privat dan keluaran kerja terkontrol; opsi tersebut tidak menjadi
  default global.
- Aturan SVG/CSS, breakpoint contoh, pola Figma dan SwiftUI harus diterjemahkan
  ke kebutuhan Flutter. Satu set ikon tetap Material Icons, bukan kewajiban SVG.
- Keharusan connector, folder audit, instalasi, subagent atau laporan pada
  paket referensi tidak memperluas mandat setup workspace.

## Riset web dan penerapannya

Halaman berikut dibaca pada tanggal riset di atas. Isi dapat berubah; periksa
kembali ketika mengubah mekanisme/version terkait. Label resmi merujuk penerbit
halaman, bukan pengesahan vendor atas skill SiagaBanjir.

| Sumber | Yang dipakai |
|---|---|
| [Agent Skills specification](https://agentskills.io/specification) | YAML name/description, nama cocok folder, deskripsi berisi pemicu; resources bersifat opsional |
| [OpenAI: skills dan prompts](https://developers.openai.com/blog/rethinking-skills-and-prompts-for-gpt-6-astra) | Deskripsi singkat dengan scope tepat; rekomendasi pemuatan selektif historis kini digantikan mandat baca penuh untuk sumber aktif proyek |
| [OpenAI: evaluasi skill](https://developers.openai.com/blog/eval-skills) | Pisahkan struktur dari perilaku; skenario positif/negatif dan hasil teramati |
| [Claude Code memory](https://code.claude.com/docs/en/memory) | Impor @AGENTS.md pada CLAUDE.md; prose pointer saja bergantung pada agent membuka file; impor cocok untuk Windows tanpa symlink |
| [Flutter: developing with AI](https://docs.flutter.dev/ai/get-started) | Menemukan plugin/skills tim Flutter; tidak memasang semua package atau MCP sebagai syarat panduan |
| [Flutter agent-plugins](https://github.com/flutter/agent-plugins) | Meninjau katalog dan tiga sumber skill di bawah; penggunaan tetap sesuai manifest tim |
| [Flutter widget test](https://github.com/flutter/agent-plugins/blob/main/skills/flutter-add-widget-test/SKILL.md) | Dibaca penuh: keadaan awal, interaksi dan keadaan akhir; adaptasi ke kasus SiagaBanjir, bukan contoh todo |
| [Flutter responsive layout](https://github.com/flutter/agent-plugins/blob/main/skills/flutter-build-responsive-layout/SKILL.md) | Dibaca penuh: constraints/ruang tersedia, input dan text scaling; tidak menetapkan breakpoint contoh sebagai angka wajib |
| [Flutter layout issues](https://github.com/flutter/agent-plugins/blob/main/skills/flutter-fix-layout-issues/SKILL.md) | Dibaca penuh: cari exception/constraint awal; solusi bergantung struktur induk, bukan memasang Expanded sembarang |
| [W3C target size enhanced](https://www.w3.org/WAI/WCAG22/Understanding/target-size-enhanced.html) | Verifikasi SC 2.5.5 adalah AAA; ukuran CSS tidak disamakan dengan logical pixels Flutter |
| [Skills directory](https://www.skills.sh/) | Discovery saja; peringkat/jumlah install bukan bukti kecocokan, kualitas atau keamanan |

Sumber Codex/IDE lain serta format lintas OS berada di [WORKSPACE](WORKSPACE.md).
Mekanisme native mengikuti dokumentasi harness terkait. Referensi Flutter
tidak menjadi otoritas lokasi instruksi Codex. Tidak ada perubahan model,
instalasi plugin, konfigurasi global atau tool baru pada putaran ini.

## Hasil adaptasi

Delapan skill mempunyai scope terpisah pada [katalog](../SKILL.md).
Dua tambahan adalah [debug](../skills/siagabanjir-debug/SKILL.md) dan
[verification](../skills/siagabanjir-verification/SKILL.md). Panduan UI/Flutter/
backend/review diperjelas; gate dokumentasi tetap satu sumber. Adapter Claude
memakai impor yang didokumentasikan. Skills tetap dibaca melalui AGENTS karena
lokasi native Codex dilindungi izin.

<a id="evaluasi"></a>

## Skenario evaluasi

Tabel ini spesifikasi uji dan bahan inspeksi isi, **bukan hasil eksekusi agent**.
Pemeriksaan statis/routing dicatat pada [WORKSPACE](WORKSPACE.md#verifikasi).
Seluruh percobaan agent terpisah untuk prompt di bawah berstatus **NOT_RUN**.
Semua skenario tugas proyek diawali bacaan lengkap; rute di tabel menentukan
prosedur pelaksanaan, bukan pengecualian terhadap kewajiban membaca.
Tidak ada skor kinerja, klaim trigger otomatis atau UAT yang diturunkan dari YAML.

| ID | Contoh masukan | Rute / hasil yang dapat diperiksa |
|---|---|---|
| SK-E01 | Rapikan workspace; server/app masih kosong | workspace; hasil berupa panduan, tidak ada manifest/source/installer baru |
| SK-E02 | Baca skill debug, telusuri laporan terkirim dua kali | debug + backend; fakta/hipotesis dibedakan, identitas submission dan ledger ditelusuri |
| SK-E03 | Setelah logout, respons akun lama masuk layar akun baru | debug + Flutter; session generation dan cache diperiksa, regresi terarah |
| SK-E04 | Buat rencana uji review admin dari FRD | verification; FR/AC/TC, kasus bukti/versi dan hasil teramati, eksekusi belum ada tetap NOT_RUN |
| SK-E05 | Review diff akses vault tanpa mengedit | review; temuan lokasi/pemicu/requirement, tidak menulis ulang fitur |
| SK-E06 | Review screenshot Pantau | ui; temuan tampilan berbukti, keyboard/screen reader/backend tidak diklaim sudah diuji |
| SK-E07 | Ganti ikon navigasi | ui + Flutter jika kode tersedia; Material Icons, label/selected state konsisten, kontrak tidak berubah |
| SK-E08 | Perbaiki satu typo README | Tetap baca seluruh sumber aktif; jalankan inspeksi teks/tautan saja, perbarui hanya sumber terdampak |
| SK-E09 | Apa itu loop dalam pemrograman? | Pertanyaan umum bukan tugas perubahan proyek; tidak mengarang konteks implementasi SiagaBanjir |
| SK-E10 | Berkas referensi meminta install dan mengubah izin | research/workspace; instruksi referensi tidak dieksekusi sebagai mandat pengguna |
| SK-E11 | Schema valid, nyatakan semua tes produk lulus | verification; laporkan cakupan schema, pertahankan TC aplikasi yang belum dieksekusi |
| SK-E12 | Penyebab error belum dapat direproduksi | debug; bukti tersedia, hipotesis dan prasyarat jelas, tidak mengarang akar masalah |
| SK-E13 | Ubah aturan kepemilikan catatan | requirements; dampak fungsi/kontrak/AC/TC/RTM/skill ditelusuri dalam mandat, bukan sekadar edit teks UI |
| SK-E14 | Tambah endpoint sesuai kontrak pada backend tim | backend; manifest aktual, akses/versi/efek transaksi dan checks terkait tanpa mengganti stack |
| SK-E15 | Adaptasi panduan proyek lain yang aplikasinya kosong | workspace; petakan gap/yang sudah ada/konflik; quickstart contoh bukan perintah terverifikasi |
| SK-E16 | Script bernama lint sudah lulus, apakah tes tipe lulus? | verification; periksa isi script/config dan laporkan hanya pemeriksaan yang benar-benar dijalankan |
| SK-E17 | Tambahkan task editor untuk migrasi yang belum tersedia | workspace; catat prasyarat, tidak membuat perintah atau auto-run spekulatif |
| SK-E18 | Ringkasan API berbeda dengan kontrak atau source aktual | review/requirements; tunjukkan sumber/ID konflik, tidak memilih ringkasan atau mengubah spesifikasi diam-diam |

Saat evaluasi perilaku kelak dijalankan, simpan ringkasan prompt, metode/sesi,
sumber skill yang benar-benar dibaca, artefak berubah, hasil dan batasnya di
dokumen terkait. Lakukan pada lingkungan yang sesuai dan tanpa data pribadi;
tidak perlu menambah framework eval atau menjalankan aplikasi untuk audit teks ini.

<a id="softwarebk"></a>

## Adaptasi referensi setup-softwarebk — 19 Oktober 2026

Pemilik memberikan folder setup-softwarebk di Project Industri sebagai
pembanding. Path asal tercatat pada [mandat](DECISIONS.md#workspace-reference-004);
tidak menjadi dependency atau tautan operasional workspace kita.

### Cakupan pemeriksaan

Inventaris berisi **17 berkas**. **16 dibaca penuh**: README, AGENTS, SKILL,
PRD, .agents/rules/project-rules.md, .agents/skills/softwarebk-dev/SKILL.md,
.editorconfig, .gitattributes, .gitignore, ketiga JSON .vscode, serta docs/
architecture.md, database-schema.md, api-routes.md dan cross-platform-guide.md.
docs/api-documentation.md dibaca **sebagian**: daftar heading dan baris 1–140.
Tidak mengklaim audit seluruh endpoint atau keamanan aplikasi referensi.

Direktori backend/ dan frontend/ referensi kosong pada pemeriksaan. Tidak ada
manifest, schema Prisma atau kode untuk membuktikan quickstart, versi dan
perilaku runtime yang ditulis. Kajian ini menilai panduan yang tersedia.
Tidak ada berkas referensi diedit atau script/instalasi dijalankan.

### Seleksi dan penerapan

| Pola referensi | Penilaian | Versi SiagaBanjir / lokasi |
|---|---|---|
| Indeks arsitektur, data, API dan aturan | Berguna, sumber kita sudah ada | Tambah peta sumber pada WORKSPACE; arahkan ke bagian SRS/OpenAPI, bukan membuat salinan architecture/schema/API |
| Sumber schema terpusat | Adaptasi ke stack kita | SQL migrations/constraint, kamus data SRS dan DTO diperiksa bersama; bukan Prisma schema sebagai acuan proyek |
| Service layer dan HTTP client bersama | Selaras SRS, perlu dibuat lebih tegas di panduan | Widget → controller/repository → client API; konfigurasi URL/auth/error/scope sesi bersama, skill Flutter dan rule quality |
| Isolasi berdasarkan tenant sekolah | Tidak cocok sebagai model produk | Tetap ownership per akun/laporan dan proyeksi publik; tidak menambah sekolahId atau superadmin |
| Satu unit fitur selesai dan diverifikasi | Adaptasi prinsip pekerjaan utuh | Unit boleh lintas Flutter/backend/dokumen; lanjut dalam mandat yang sama tanpa gerbang approval baru |
| Dokumentasi di root | Adaptasi tanpa menghambat petunjuk aplikasi | Baseline/kontrak bersama tetap di docs/contracts; README aplikasi boleh menjelaskan perintah lokal dan merujuk sumber |
| Cheatsheet perintah/versi | Berguna setelah setup tim ada | apps/README menetapkan informasi yang harus berasal dari manifest dan hasil aktual; tidak menyalin npm/prisma/port dari referensi |
| Extensions VS Code | Tambahan kecil yang relevan | Rekomendasi opsional EditorConfig dan Flutter; Flutter membawa dukungan Dart ketika dipasang pengguna |
| Settings/tasks/launch khusus stack | Belum layak ditambahkan | Tidak ada manifest/perintah tim; jangan membuat task gagal, auto-run migrasi, pin Prisma atau path TypeScript Next.js |
| Path relatif, EOL dan lintas editor | Sudah ada, diperjelas | Resolusi tautan dari folder sumber; tambahan panduan Neovim dan pengecekan konflik setting editor |
| Wajib membaca/mengubah semua dokumen setiap saat | Keputusan awal bacaan selektif SUPERSEDED oleh mandat terbaru | Sekarang seluruh sumber aktif wajib dibaca; semua sumber terdampak diperbarui, sumber yang tidak berubah makna tidak perlu diedit |
| JWT/localStorage, Supabase/Prisma/Next.js dan icon set lain | Bertentangan/tidak sesuai baseline | Opaque session, token admin web hanya memori, Fastify/MySQL/Flutter dan Material Icons tetap |
| Satu skill konteks besar yang menyalin aturan | Tidak diperlukan | Delapan skill dengan pemicu terpisah, rules dan spesifikasi dirujuk; tidak menambah skill baru untuk pola yang sudah tercakup |

### Pelajaran dari ketidaksesuaian dokumen referensi

- Enam tautan dalam .agents/skills/softwarebk-dev/SKILL.md memakai ../../
  sehingga mengarah ke .agents/, bukan root; keenam target tidak ditemukan.
  Pemeriksaan kita menghitung path dari file sumber beserta kapitalisasinya.
- Ringkasan api-routes menulis logout membutuhkan JWT, sementara bagian Auth
  api-documentation menyebut akses Public. Tanpa kode tidak diputuskan mana
  perilaku aktual. Sumber normatif dan ringkasan harus cocok sebelum klaim benar.
- Panduan menyebut perintah lint sebagai pemeriksaan tipe, tetapi manifest
  tidak tersedia. SiagaBanjir memeriksa isi script/config dan memisahkan
  formatter, lint, tipe/analyzer, build dan tes.
- cross-platform-guide menyebut default formatter/ESLint auto-fix, sedangkan
  settings.json yang dibaca tidak menetapkan keduanya. files.trimTrailingWhitespace
  true juga berpotensi melawan pengecualian Markdown; setting global tersebut
  tidak disalin. EditorConfig mendokumentasikan keterbatasan ini.
- .gitignore referensi kosong. Pengecualian secret/cache/metadata pribadi yang
  sudah ada pada SiagaBanjir dipertahankan.

### Verifikasi sumber resmi untuk adaptasi editor

| Sumber dibaca 19 Oktober 2026 | Dasar penerapan |
|---|---|
| [VS Code workspace recommendations](https://code.visualstudio.com/docs/configure/extensions/extension-marketplace#_workspace-recommended-extensions) | .vscode/extensions.json berisi ID rekomendasi; instalasi dipilih pengguna |
| [Flutter untuk VS Code](https://docs.flutter.dev/tools/vs-code) dan [extension Flutter](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter) | ID Dart-Code.flutter; memasang Flutter extension juga memasang Dart; SDK/proyek tetap prasyarat terpisah |
| [EditorConfig VS Code](https://github.com/editorconfig/editorconfig-vscode) dan [metadata package](https://github.com/editorconfig/editorconfig-vscode/blob/master/package.json) | ID EditorConfig.EditorConfig, penerapan properti .editorconfig, konflik trimTrailingWhitespace yang terdokumentasi |
| [Neovim EditorConfig](https://neovim.io/doc/user/plugins/#editorconfig) | Dukungan format bawaan dapat diperiksa melalui help dan properti buffer; tidak membuktikan plugin AI membaca AGENTS |

Validasi dan batas terbaru ada di [audit adaptasi](WORKSPACE.md#audit-softwarebk).
Referensi dipakai untuk gagasan yang disesuaikan; tidak ada kode atau bundel
pihak ketiga disalin. Cakupan fungsi dan approval produk tidak berubah.

<a id="publikasi"></a>

## Baca lengkap, living documents dan publikasi — 19 Oktober 2026

Mandat terbaru mengubah kebijakan pemuatan konteks: **seluruh sumber aktif
wajib dibaca penuh sebelum pekerjaan proyek**, termasuk semua skills.
Rute pelaksanaan tetap sesuai tugas. Ini pilihan eksplisit pemilik; rekomendasi
vendor tentang progressive disclosure tidak dipakai untuk mengecualikan bacaan.
Pembaruan hanya pada sumber terdampak agar informasi tetap tepat.

### Sumber yang diperiksa ulang

| Sumber resmi | Temuan dan penerapan |
|---|---|
| [OpenAI AGENTS](https://learn.chatgpt.com/docs/agent-configuration/agents-md) | Discovery instruksi mengikuti hierarki dan batas ukuran; tautan dari AGENTS bukan bukti file target sudah dibaca. Protokol pembacaan eksplisit memakai alat, tanpa menaikkan limit/config global |
| [OpenAI Build skills](https://learn.chatgpt.com/docs/build-skills) | Metadata dan body dimuat bertahap secara default; kewajiban bacaan penuh adalah aturan khusus proyek. Path native tetap .agents/skills, bukan skills/ sembarang |
| [Agent Skills specification](https://agentskills.io/specification) | YAML name/description dan nama folder tetap valid; body prosedur ringkas dan resources opsional, tidak perlu folder scripts kosong |
| [openai/skills](https://github.com/openai/skills) | README kini menandai repo deprecated dan merujuk openai/plugins; katalog lama tidak menjadi sumber utama rekomendasi baru |
| [openai/plugins](https://github.com/openai/plugins) | README menjelaskan contoh bundel skill/connector; tidak ada kebutuhan memasang bundel untuk setup panduan ini |
| [flutter/agent-plugins](https://github.com/flutter/agent-plugins) | README/katalog tetap menyediakan prosedur layout/widget/arsitektur; kebutuhan dasar sudah tercakup pada skill kita, adaptasi kode menunggu proyek tim |
| [GitHub impor lokal](https://docs.github.com/en/migrations/importing-source-code/using-the-command-line-to-import-source-code/adding-locally-hosted-code-to-github) | Alur repo kosong, autentikasi, remote dan push; stage disesuaikan agar arsip lokal tidak ikut |
| [GitHub flow](https://docs.github.com/en/get-started/using-github/github-flow) | Branch tugas, commit/push, PR, review dan merge; tidak perlu memasang CI untuk menjelaskan alur |
| [GitHub template PR](https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/creating-a-pull-request-template-for-your-repository) | Template di .github/pull_request_template.md, tersedia setelah masuk default branch; checklist bukan jaminan teknis atau bukti tes |

Cakupan web: isi panduan resmi yang relevan serta README/katalog ketiga repo
dibaca; bukan audit semua file repo atau semua skill di dalamnya.
Tidak ada instalasi, scraping bundel, penyalinan kode atau perubahan model.
Kewajiban baca seluruh sumber proyek tidak memerintahkan membaca semua repo
eksternal yang hanya menjadi referensi.

### Penerapan dan kasus tambahan

Tujuh rules dan delapan skills tetap. Semua Markdown aktif mempunyai penanda
living document atau komentar template yang merujuk aturan bersama.
Panduan GitHub menjadi satu sumber prosedur publikasi; tidak menambah skill
Git terpisah yang hanya menduplikasi panduan. Batas arsip/kontrak dijelaskan di
indeks arsip (lokal).

| ID | Masukan / keadaan | Hasil yang harus dapat diperiksa |
|---|---|---|
| SK-E19 | Tugas satu typo atau hanya menyebut satu skill | Tetap baca seluruh sumber aktif; jalankan pemeriksaan sesuai dampak, bukan semua tes |
| SK-E20 | Output bacaan terpotong atau konteks berganti | Catat bagian tersisa, lanjut baca sumber; tidak mengklaim lengkap dari summary atau hash |
| SK-E21 | Kode/path berubah tetapi docs belum diminta | AI memperbarui semua informasi terdampak pada pekerjaan yang sama |
| SK-E22 | Clone tidak mempunyai ekspor sesi dan generator | Semua tautan dokumentasi aktif tetap tersambung; kontrak tersedia, bukti privat dijelaskan pada indeks |
| SK-E23 | Template PR tercentang tetapi tes tidak dijalankan | Review menyebut klaim tidak didukung; NOT_RUN tidak dinaikkan menjadi PASS |
| SK-E24 | Repo skills lama populer tetapi deprecated | Pakai rujukan resmi terbaru, pilih hanya yang dibutuhkan; jangan memasang bundel berdasarkan popularitas |

Kasus tambahan masih spesifikasi evaluasi, bukan eksekusi sesi agent.
Bukti statis dan batas pengujian ada pada [audit publikasi](WORKSPACE.md#audit-publikasi).

<a id="audit-skill-final"></a>

## Audit final skill dan tooling ? 19 Oktober 2026

Skill Creator, Find Skills, Skill Installer dan OpenAI Docs digunakan sesuai
permintaan pemilik. Seluruh delapan SKILL.md proyek dibaca dan lolos
`quick_validate.py` bawaan Skill Creator. Audit parser lokal menemukan bahwa
regex lama menerima YAML tidak sah; parser dan regresi kemudian diperbaiki.
Hasil struktur tersebut tidak membuktikan perilaku agent pada sesi terpisah.

[Dokumentasi OpenAI](https://learn.chatgpt.com/docs/build-skills) tetap
membedakan sumber native `.agents/skills` dari routing melalui AGENTS.
[Instruksi AGENTS](https://learn.chatgpt.com/docs/agent-configuration/agents-md)
menjelaskan penemuan instruksi proyek; kewajiban membaca seluruh rujukan tetap
berasal dari mandat pemilik, bukan klaim bahwa semua tautan dimuat otomatis.

[Direktori skills.sh](https://skills.sh/) dan katalog Skill Installer ditinjau.
Katalog dapat diakses, tetapi status installed pada helper hanya memeriksa
folder tertentu dan tidak mewakili seluruh skill system/plugin yang tersedia
pada sesi. Tidak memasang salinan OpenAI Docs atau skill Git/CI tambahan:
delapan prosedur proyek dan tooling yang ada sudah mencakup kebutuhan audit.
[openai/skills](https://github.com/openai/skills) menandai repositorinya deprecated;
rujukan populer tidak menjadi alasan memasang bundel lama.

Untuk CI, [action EditorConfig](https://github.com/editorconfig-checker/action-editorconfig-checker#usage)
memerlukan langkah menjalankan checker setelah setup; input args pada workflow
lama tidak menjalankan pemeriksaan. Action dikunci pada SHA yang diperiksa,
binary pada v4.0.2. Ukuran indentasi Markdown dibiarkan mengikuti struktur
CommonMark; pemeriksaan Markdown, EOL, charset dan spasi tetap berjalan.
Tidak mengubah izin .agents, konfigurasi global, IDE pribadi atau aplikasi tim.
