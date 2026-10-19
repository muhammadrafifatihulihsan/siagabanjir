# Mutu dan verifikasi

> **Living document:** perbarui bersama setiap perubahan terkait menurut [aturan dokumentasi](documentation.md#living-documents).

## Perubahan kode setelah setup tim tersedia

- Periksa manifest, struktur dan kebiasaan proyek aktual sebelum mengubah kode.
  Gunakan perintah yang memang tersedia; jangan mengarang script atau lockfile.
- Pertahankan batas UI/controller/repository dan API/domain/data sesuai SRS,
  tanpa menambahkan framework hanya untuk membentuk lapisan.
- Fungsi/modul punya tanggung jawab jelas. Target source baru sekitar 100 baris,
  evaluasi pemecahan di atas 150; jangan meminify atau memecah artifisial.
  Jangan merombak file generated/vendor demi angka baris.
- Validasi input di batas API, gunakan SQL berparameter dan serializer publik
  yang eksplisit. Detail error/log tidak membuka data privat.
- Fixture memakai data sintetis. Jangan menyimpan credential atau dokumen asli
  di repository, screenshot, log atau hasil pemeriksaan.

## Batas implementasi bersama

- Widget memanggil controller/repository. Panggilan API SiagaBanjir memakai
  client bersama dengan scope sesi sesuai SRS; URL, header autentikasi dan
  penanganan error tidak dirakit ulang per layar.
- Alamat layanan dibaca dari konfigurasi aplikasi yang didokumentasikan.
  Kunci provider/database tetap di backend, tidak di Flutter atau konfigurasi
  editor bersama. Ikuti kontrak respons/akses, bukan meniru stack referensi.
- Untuk data, cocokkan migrasi SQL, constraint dan pemetaan DTO dengan SRS
  serta OpenAPI. Struktur yang ada di kode tidak otomatis membuktikan bahwa
  perubahan perilakunya sudah disetujui.

## Pemeriksaan sesuai dampak

| Perubahan | Bukti yang diperlukan |
|---|---|
| Instruksi/folder | Path/tautan, YAML skill, kecocokan scope dan kondisi aktual |
| Requirement/kontrak | ID/anchor/RTM, referensi schema, contoh dan konflik semantik |
| Logic/data/API | Kasus normal, batas, akses terlarang, konflik/retry yang relevan |
| Flutter/UI | State, isolasi akun, ikon standar, aksesibilitas dan kriteria [DESIGN](../docs/DESIGN.md) |
| Path/tooling lintas OS/IDE | Case path, format berkas dan bukti pemuatan sesuai [portabilitas](portability.md) |
| AI/perangkat | Bukti provider/perangkat nyata sebelum klaim kompatibilitas atau mutu |

Tes harus menangkap risiko perilaku, bukan menyalin implementasi. Untuk edit
teks sederhana cukup inspeksi/tautan; jangan menambah test harness atau folder
reports/tools hanya agar terlihat lengkap. Jalankan checks yang sesuai sekali,
ulang jika ada perubahan atau kegagalan yang membuat hasil sebelumnya tidak berlaku.

Untuk diagnosis gunakan [skill debug](../skills/siagabanjir-debug/SKILL.md).
Untuk rencana tes atau paket bukti penerimaan gunakan
[skill verification](../skills/siagabanjir-verification/SKILL.md). Keduanya
memakai tooling yang sudah tersedia dan tidak menginisialisasi aplikasi.

## Arti perintah pemeriksaan

Gate workspace dan perintah lokal ada pada [README](../README.md#otomatisasi-cicd).
Validator harus gagal bila akar/cakupan sumber keliru. Tes regresi validator
menangkap YAML rusak, tautan/case, contoh tidak sesuai, serta replay rahasia
SRS-IF-004. Hasil tersebut tidak menggantikan tes API atau perangkat.

Periksa isi script dan konfigurasi aktual, bukan namanya saja. Formatter
memeriksa bentuk kode; lint memeriksa aturan yang dikonfigurasi; pemeriksaan
tipe/analyzer menilai program secara statis; build menghasilkan target;
tes menguji kasus tertentu. Satu script boleh menjalankan beberapa tahap,
tetapi laporkan hanya tahap yang benar-benar dijalankannya. Lint atau build
berhasil tidak otomatis membuktikan type-check, tes perilaku maupun UAT.

## Cara mencatat hasil

- PASS berarti pemeriksaan benar-benar dijalankan dan memenuhi ekspektasi.
- FAIL berarti dijalankan dan menemukan masalah.
- BLOCKED berarti pemeriksaan yang diperlukan terhalang prasyarat nyata.
- NOT_RUN berarti belum dieksekusi. Selalu sebut cakupannya.
- Mock membuktikan logika dalam skenario mock; schema membuktikan bentuk data.
  Keduanya tidak membuktikan provider, perangkat, keamanan penuh atau UAT.
- Tuliskan perintah/metode dan hasil singkat pada handoff/PR/dokumen terdampak;
  jangan menyimpan cache atau log sensitif sebagai bukti.

## Kelengkapan perubahan

Gunakan [matriks dampak dokumentasi](documentation.md) untuk setiap perubahan.
Instruksi yang masih menunjuk path, perilaku atau perintah lama belum selesai
meskipun kode sudah benar. Nilai “clean” melalui kriteria UI yang terukur pada
DESIGN, struktur yang diperlukan, dan keterbacaan; jangan menambah abstraksi,
komentar dekoratif, dependency atau file contoh yang tidak dipakai.
