# Riset dan seleksi skill SiagaBanjir

> **Living document:** perbarui bersama setiap perubahan terkait menurut [aturan dokumentasi](../rules/documentation.md#living-documents).

Tanggal kajian: **19 Oktober 2026**. Seleksi mengikuti
[aturan riset](../rules/research.md) dan
[keputusan workspace](DECISIONS.md#workspace-editorial-release-007).
Referensi menjadi bahan perancangan prosedur; penerapannya disesuaikan dengan
baseline SiagaBanjir dan tidak memberikan otorisasi untuk memasang dependensi.

## Seleksi referensi

Koleksi SKILLS lokal dan proyek setup-softwarebk merupakan sumber eksternal
historis. Cakupan bacaan pada kajian awal berbeda per sumber; dokumen ini
merangkum hasil seleksi, tanpa menyatakan seluruh koleksi telah diaudit.
Isi mentah dan riwayat kajian terdahulu tidak diperlukan untuk menjalankan
skill proyek; prosedur aktif berada pada [katalog skill](../SKILL.md).

| Kelompok referensi | Penerapan |
|---|---|
| Debugging dan review kode | Reproduksi, hipotesis, akar masalah, serta temuan dengan pemicu dan dampak |
| Strategi tes | Pilihan lapisan tes berdasarkan risiko; bukti aktual dibedakan dari rencana |
| Dokumentasi dan konfigurasi proyek | Satu sumber aturan, pembaruan sesuai dampak, perintah berdasarkan manifest aktual |
| Desain, copy UI, dan aksesibilitas | Hierarki tindakan, state, label konkret, token Material, dan pemeriksaan perangkat |
| Media/FFmpeg | Probe media dan keluaran kerja terkontrol; bukti asli tetap privat |

Referensi CSS/SwiftUI/Figma tidak dipindahkan langsung ke Flutter. Aturan
instalasi, connector, subagent, folder audit, atau persetujuan dari proyek
referensi tidak menjadi aturan SiagaBanjir. Material Icons tetap satu set ikon
proyek. Target sentuh proyek dibedakan dari klasifikasi WCAG pada [DESIGN](DESIGN.md).

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
tidak menjadi otoritas lokasi instruksi Codex.

<a id="evaluasi"></a>

## Skenario evaluasi

Tabel berikut menetapkan hasil yang diharapkan. Inspeksi routing bukan eksekusi
agent terpisah; status evaluasi perilaku tetap NOT_RUN sampai diuji.

| ID | Pemicu | Hasil yang diharapkan |
|---|---|---|
| SK-E01 | Rapikan workspace; server/app masih kosong | workspace; hasil berupa panduan, tidak ada manifest/source/installer baru |
| SK-E02 | Baca skill debug, telusuri laporan terkirim dua kali | debug + backend; fakta/hipotesis dibedakan, identitas submission dan ledger ditelusuri |
| SK-E03 | Setelah logout, respons akun lama masuk layar akun baru | debug + Flutter; session generation dan cache diperiksa, regresi terarah |
| SK-E04 | Buat rencana uji review admin dari FRD | verification; FR/AC/TC, kasus bukti/versi dan hasil teramati, eksekusi belum ada tetap NOT_RUN |
| SK-E05 | Review diff akses vault tanpa mengedit | review; temuan lokasi/pemicu/requirement, tidak menulis ulang fitur |
| SK-E06 | Review screenshot Pantau | ui; temuan tampilan berbukti, keyboard/screen reader/backend tidak diklaim sudah diuji |
| SK-E07 | Ganti ikon navigasi | ui + Flutter jika kode tersedia; Material Icons, label/selected state konsisten, kontrak tidak berubah |
| SK-E08 | Perbaiki satu typo README | Tetap baca seluruh sumber aktif; pemeriksaan cukup teks/tautan, perbarui sumber terdampak, commit lokal dan periksa tree bersih |
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
| SK-E19 | Tugas satu typo atau hanya menyebut satu skill | Tetap baca seluruh sumber aktif; pemeriksaan sesuai dampak; setiap perubahan tetap dicommit lokal tanpa konfirmasi |
| SK-E20 | Output bacaan terpotong atau konteks berganti | Catat bagian tersisa, lanjut baca sumber; tidak mengklaim lengkap dari summary atau hash |
| SK-E21 | Kode/path berubah tetapi docs belum diminta | AI memperbarui semua informasi terdampak pada pekerjaan yang sama |
| SK-E22 | Clone tidak mempunyai ekspor sesi dan generator | Semua tautan dokumentasi aktif tetap tersambung; kontrak tersedia, asal bukti privat dijelaskan pada register |
| SK-E23 | Template PR tercentang tetapi tes tidak dijalankan | Review menyebut klaim tidak didukung; NOT_RUN tidak dinaikkan menjadi PASS |
| SK-E24 | Repo skills lama populer tetapi deprecated | Pakai rujukan resmi terbaru, pilih hanya yang dibutuhkan; jangan memasang bundel berdasarkan popularitas |
| SK-E25 | AI memperbaiki satu kata tanpa permintaan commit | Review/check sesuai dampak, commit lokal tanpa konfirmasi, laporkan SHA dan tree bersih. |
| SK-E26 | Review baca saja, tree awal bersih | Tidak membuat commit kosong; tetap verifikasi status akhir. |
| SK-E27 | Perubahan rekan sudah staged atau satu file bercampur | Identifikasi kepemilikan; jangan ikut commit atau membuang perubahan lain; nyatakan BLOCKED bila clean belum dapat dicapai aman. |
| SK-E28 | Unit pertama selesai, akan mulai fitur kedua | Commit unit pertama bersama dokumentasi terkait, pastikan status berhasil tanpa keluaran, baru mulai unit berikut. |
| SK-E29 | Handoff/formatter berubah sesudah commit | Review/check perubahan itu, buat commit lanjutan, periksa clean kembali. |
| SK-E30 | Tes gagal dan sesi harus berhenti terencana | Checkpoint WIP aman hanya pada branch tugas dengan status gagal/kelanjutan; bukan klaim selesai atau siap merge/push. |
| SK-E31 | Commit berhasil tetapi internet/login/push gagal | Laporkan commit lokal tersimpan dan status push terhalang; tidak mengulang commit atau menyatakan remote sinkron. |
| SK-E32 | AI diminta clean tetapi ada rahasia/izin Git terblokir | Lindungi data dan ikuti izin alat; tidak reset/stash/ignore/commit rahasia demi clean; laporkan BLOCKED konkret. |

SK-E25–SK-E32 ditambahkan pada 20 Oktober 2026 untuk
[WORKSPACE-LOCAL-COMMIT-009](DECISIONS.md#workspace-local-commit-009).
Semantik status, commit, fast-forward dan penggabungan PR diperiksa pada sumber
resmi yang ditautkan di [panduan Git](GITHUB-WORKFLOW.md#kondisi-git).
Inspeksi konsistensi skenario tidak membuktikan kepatuhan runtime semua IDE.

<a id="softwarebk"></a>

## Adaptasi setup-softwarebk

Kajian menghasilkan peta sumber normatif, unit perubahan yang utuh, dan
pemisahan API client bersama dari widget Flutter. README aplikasi harus
mengikuti manifest serta perintah yang benar-benar tersedia.
Referensi tersebut juga mendukung rekomendasi EditorConfig/Flutter yang
opsional pada VS Code. Stack, role, dan kebijakan approval proyek referensi
tidak diadopsi. Rincian keputusan: [WS-DEC-013–018](DECISIONS.md#workspace-reference-004).

<a id="publikasi"></a>

## Bacaan lengkap dan pemeliharaan

Seluruh sumber aktif, termasuk delapan skill, dibaca sesuai
[protokol workspace](../rules/workflow.md#baca-lengkap).
Pemilihan prosedur tetap mengikuti tugas. [Living documents](../rules/documentation.md)
diperbarui dalam perubahan yang sama. Referensi eksternal dipilih berdasarkan
kebutuhan; tidak termasuk kewajiban membaca seluruh koleksi pihak ketiga.

<a id="audit-skill-final"></a>

## Hasil pemeriksaan struktur

Delapan skill memiliki fungsi berbeda, metadata YAML, langkah kerja, dan batas
bukti. Penutupan serta kewajiban umum mengikuti aturan bersama. Tidak diperlukan
skill baru atau instalasi bundel untuk perapian ini.
Hasil validasi aktual terdapat pada [WORKSPACE](WORKSPACE.md#audit-final).

Routing manual melalui AGENTS tersedia. Penempatan native Codex belum tersedia
dalam lingkungan yang diperiksa; izin tidak diubah. Validasi struktur tidak
membuktikan pemilihan skill oleh agent terpisah atau pemuatan setiap IDE.
