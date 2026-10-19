# SiagaBanjir — handoff workspace

> **Living document:** perbarui bersama setiap perubahan terkait menurut [aturan dokumentasi](../rules/documentation.md#living-documents).

**Kondisi 19 Oktober 2026:** tujuh rules dan delapan skills; perbaikan validator,
CI, kontrak dan dokumentasi menuju publikasi. apps/server dan apps/app masih hanya .gitkeep.
Backend/Flutter tetap diinisialisasi tim, bukan asisten pada tahap ini.

## Mandat terbaru dan hasil

[WORKSPACE-AUDIT-PUSH-006](DECISIONS.md#workspace-audit-push-006) meminta audit,
perbaikan sampai pemeriksaan lulus, lalu commit/push melalui Git Bash ke repo
milik pemilik. Rencana diterima melalui instruksi “Implement the plan.”

- [AGENTS](../AGENTS.md) menetapkan
  [bacaan lengkap](../rules/workflow.md#baca-lengkap): seluruh docs, rules,
  delapan skills, kontrak, adapter dan konfigurasi bersama. Semua ukuran tugas
  proyek tercakup. Checkpoint/summary tidak menggantikan bacaan sumber.
- [Living documents](../rules/documentation.md#living-documents) wajib
  diperbarui AI dalam perubahan yang sama tanpa menunggu pengingat.
  Ini kewajiban kerja, bukan layanan latar belakang atau hook/CI.
- [Panduan GitHub](GITHUB-WORKFLOW.md) memakai repo tujuan aktual, pemeriksaan
  sebelum staging, verifikasi SHA/CI, dan penanganan ownership Git per perintah.
- Folder archive beserta indeksnya sudah tidak tersedia di workspace publik;
  seluruh archive/ diabaikan Git jika dibuat kembali. Audit lama bersifat historis.
- docs/openapi.json dan docs/examples.json tetap sumber aktif dan ikut Git.
  Errata replay rahasia mengikuti SRS-IF-004; 72 operasi/166 schema tetap,
  contoh bertambah dari 41 menjadi 54 untuk regresi.
- Validator memakai akar repo yang benar, parsing YAML, pemeriksaan case path,
  contoh/schema dan invariant replay. CI menjalankan 20 tes regresi serta
  Markdownlint/Redocly/EditorConfig dengan versi yang dikunci.
- [Riset terbaru](SKILL-RESEARCH.md#audit-skill-final) meninjau dokumentasi resmi dan
  repo skill terkini; tidak memasang plugin/bundel atau menambah skill duplikat.

## Acuan yang tetap berlaku

BRD/PRD v0.1.0 APPROVED dan FRD/SRS v1.0.0 APPROVED melalui mandat tercatat.
[SRS-PLAN](SRS-PLAN.md) adalah rencana yang sudah dilaksanakan.
FRD STD-001–012 menutup discovery historis. Keputusan/RTM mempertahankan riwayat;
156 TC FRD dan 24 TC-SRS tetap NOT_RUN pada aplikasi.

[DESIGN](DESIGN.md) mempertahankan Material 3 dan Material Icons.
[Peta sumber](WORKSPACE.md#sumber-acuan) memisahkan spesifikasi dari keadaan kode.
Riset Software-BK tetap referensi selektif; tidak mengadopsi stack/approvalnya.

## Kelanjutan

1. Selesaikan pemeriksaan akhir, staging/commit/push dan verifikasi CI sesuai
   mandat. Hasil pengiriman dicatat setelah SHA remote dan run terkait terverifikasi.
2. Tim menginisialisasi backend di apps/server dan Flutter di apps/app.
3. AI pada tugas berikut menuntaskan bacaan lengkap, memeriksa manifest/kode
   aktual, lalu memperbarui README aplikasi dengan versi/perintah yang nyata.
   Jangan mengarang task, SDK path, port, tes atau kompatibilitas runtime.
4. Lanjutkan milestone PRD sesuai mandat implementasi: akun/dokumen/KTP,
   laporan/AI, admin/Pantau, fitur pendukung dan validasi.
5. Pada setiap perubahan, selaraskan seluruh informasi terdampak termasuk
   AGENTS/rules/skills/adapter dan sumber requirement bila perilaku berubah.

## Bukti dan keterbatasan

Hasil terbaru: [audit final setup](WORKSPACE.md#audit-final).
Audit statis tidak membuktikan agent/harness selalu mematuhi instruksi.
Pemuatan IDE, runtime macOS/Linux, UI/aplikasi, provider/perangkat serta
percobaan agent terpisah masih NOT_RUN.

Sumber skills dapat dibaca langsung dari skills/. Penempatan native Codex
di .agents/skills masih BLOCKED oleh izin sesi; tidak ada pengubahan izin.
Pembacaan manual melalui AGENTS tidak disebut native discovery.
