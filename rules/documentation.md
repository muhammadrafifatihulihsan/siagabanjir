# Sinkronisasi dokumentasi pada setiap perubahan

> **Living document:** perbarui bersama setiap perubahan terkait menurut [aturan dokumentasi](documentation.md#living-documents).

Ini syarat selesai untuk kode, kontrak, UI, struktur folder, konfigurasi dan
panduan kerja. Instruksi pengguna terbaru menjadi dasar perubahan; riwayat
keputusan lama tidak dihapus untuk membuat keadaan baru terlihat selalu ada.

<a id="living-documents"></a>

## Living documents

Dokumentasi aktif adalah **living documents (dokumen hidup)**: isinya dipelihara
bersama perubahan proyek. AI wajib memperbarui sumber terdampak **secara otomatis
dalam pekerjaan yang sama, tanpa menunggu pengguna meminta atau mengingatkan**.
Kewajiban ini mencakup AGENTS, rules, semua skills, README, spesifikasi/kontrak,
desain, adapter, panduan GitHub, keputusan, keterlacakan dan handoff.

“Wajib membaca semua” mengikuti [protokol baca lengkap](workflow.md#baca-lengkap).
“Wajib memperbarui” berarti menyelaraskan setiap sumber yang terdampak; tidak
mengganti isi yang benar atau menyentuh semua file demi jumlah perubahan.
Perubahan manusia juga diperiksa dampaknya ketika AI melanjutkan tugas.

Setiap Markdown aktif mencantumkan penanda living document yang merujuk aturan
ini; SKILL mempertahankan YAML sebagai bagian pertama, template PR boleh memakai
komentar HTML. JSON/config mengikuti aturan yang sama tanpa menyisipkan Markdown.
Sumber baru wajib masuk inventaris bacaan, navigasi dan matriks dampak.

Status approved tidak dibatalkan oleh perbaikan metadata/tautan. Perubahan makna
requirement harus dicatat beserta dasar mandat serta dampak ke AC/TC/kontrak;
jangan mengubah riwayat menjadi seolah keputusan baru sudah berlaku sejak dulu.
Arsip mentah adalah rekaman tetap, bukan living document yang ditulis ulang.

## Matriks dampak

Periksa seluruh kelompok berikut, lalu perbarui semua yang terdampak dalam
pekerjaan/PR yang sama. “Tidak terdampak” harus punya alasan singkat.

| Yang berubah | Sumber yang wajib diperiksa dan diselaraskan |
|---|---|
| Nama/path/struktur | README, AGENTS, katalog SKILL, rules/skills pemakai path, adapter IDE, tautan docs, handoff |
| Fungsi/peran/state/data | FRD/AC/TC, SRS, kontrak/contoh, domain, DECISIONS, TRACEABILITY, skill terkait |
| UI/ikon/token/teks/interaksi | DESIGN, rule UI, skill UI/Flutter/review, AC/TC terkait; FRD bila perilaku ikut berubah |
| Versi/perintah/OS/IDE | README aplikasi aktual, WORKSPACE, portabilitas, konfigurasi bersama, AGENTS/skill terkait |
| Cara kerja agent/skill | AGENTS, SKILL, sumber skill/rules, pengarah IDE, WORKSPACE serta skenario/sumber pada SKILL-RESEARCH jika terdampak |
| Git, publikasi dan pengecualian arsip | .gitignore, tautan baseline, GITHUB-WORKFLOW, VERSIONING, template PR, WORKSPACE dan handoff; indeks arsip hanya bila memang tersedia |
| Hasil pemeriksaan/keterbatasan | Bukti pada dokumen terkait, handoff; RTM jika hasil requirement berubah |
| Koreksi teks tanpa perubahan makna | Dokumen sumber dan rujukan terdampak; cukup alasan singkat untuk kelompok lain |

## Lokasi sumber

Spesifikasi, desain, keputusan dan bukti bersama berada di docs/ termasuk
pada root. [Peta sumber](../docs/WORKSPACE.md#sumber-acuan) menentukan rujukannya.
README aplikasi boleh memuat perintah dan prasyarat lokal setelah setup tim ada;
rujuk spesifikasi bersama, jangan menyalin FRD/SRS atau membuat katalog API lain
yang dipelihara manual. Perbedaan implementasi dan spesifikasi harus dijelaskan,
bukan diselesaikan dengan mengganti dokumen agar sesuai bug.

## Pelaksanaan

1. Sebelum edit, tentukan kelompok terdampak dan sumber kebenarannya.
   Gunakan satu tempat untuk setiap aturan; berkas lain merujuknya.
2. Bersamaan dengan perubahan, perbaiki instruksi/path/perilaku yang menjadi
   usang. Jika keputusan berubah, tambahkan catatan dengan asal mandat,
   alasan dan dampak. Penyuntingan editorial boleh memparafrasakan catatan
   percakapan menjadi keputusan formal, dengan mempertahankan ID, tanggal,
   otoritas, cakupan dan urutan keputusan. Jangan menyajikan parafrasa sebagai
   kutipan langsung atau membuat persetujuan baru.
3. Cari referensi lama di berkas aktif, termasuk file tersembunyi adapter.
   Periksa tautan dengan kapitalisasi nama persis agar berfungsi di Linux.
4. Pastikan contoh, matriks dan langkah berikut menggambarkan hasil aktual.
   Versi/pengujian/approval tidak boleh dinaikkan karena dokumen terlihat rapi.
5. Ringkas hasil dalam penutupan: “Dokumentasi: diperbarui [berkas]; tidak
   terdampak [kelompok + alasan]; tertunda [jika ada]”. Gunakan bentuk ringkas,
   bukan checklist panjang yang disalin ke setiap file.
6. Pekerjaan substantif memperbarui handoff. Edit kecil boleh cukup memperbarui
   sumber dan menyebut dampaknya pada hasil akhir. Jangan menambah changelog
   atau salinan audit untuk setiap typo.

## Review dan keterbatasan

Review memeriksa kesesuaian informasi, bukan hanya jumlah file yang berubah.
Dokumentasi/instruksi yang masih bertentangan membuat perubahan belum lengkap.
Jika sumber tidak bisa diperbarui karena izin, catat path, alasan dan dampaknya;
jangan mengklaim sudah sinkron penuh.

Pembaruan otomatis di sini dilakukan AI saat mengerjakan perubahan, bukan
pemantauan file di latar belakang. CI memeriksa format, tautan, metadata dan
kontrak/contoh; belum menilai seluruh konsistensi makna atau menjamin semua harness
mematuhi Markdown. [Template PR](../.github/pull_request_template.md) meminta
bukti bacaan, sinkronisasi dan verifikasi; checklist juga bukan enforcement
teknis. Jangan menyatakan sinkronisasi selesai jika sumber masih bertentangan.
