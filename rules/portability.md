# Portabilitas OS dan IDE

> **Living document:** perbarui bersama setiap perubahan terkait menurut [aturan dokumentasi](documentation.md#living-documents).

Sasaran workspace: Windows, macOS, Linux; panduan dapat dipakai lintas editor.
Target produk tetap Flutter Android warga dan Web admin sesuai SRS.
Baca [matriks IDE dan sumber](../docs/WORKSPACE.md#ide) saat mengubah integrasi.

## Berkas dan path

- Pakai path relatif dengan `/` pada Markdown/konfigurasi bersama; jangan
  hardcode drive, direktori pengguna, alamat mesin, SDK atau binary lokal.
- Ikuti kapitalisasi file persis. Hindari nama yang hanya berbeda kapitalisasi,
  karakter terlarang Windows, titik/spasi di akhir, dan nama CON/AUX/NUL/COM1.
- Gunakan UTF-8 dan aturan [.editorconfig](../.editorconfig). Markdown boleh
  mempertahankan dua spasi hard break.
- [.gitattributes](../.gitattributes) menentukan LF untuk teks umum,
  CRLF untuk bat/cmd. Arsip mentah dikecualikan Git. Tidak mengubah Git global.
- Jangan melakukan normalisasi massal pada baseline approved hanya untuk
  merapikan line ending tanpa kebutuhan. Normalisasi untuk gate CI mengikuti
  mandat audit; periksa diff agar isi requirement dan bukti historis tetap.
- Konfigurasi pribadi IDE/SDK tetap lokal. Konfigurasi bersama baru harus
  relatif, tanpa rahasia, bisa dipakai tim, dan terdokumentasi.

## Perintah setelah aplikasi tim tersedia

- Periksa shell/OS dan manifest aktual sebelum memberi perintah.
  Tulis working directory, prasyarat dan bentuk khusus OS jika berbeda.
- Hindari menjadikan Bash, PowerShell, WSL, symlink, chmod atau utilitas OS
  tertentu syarat tersembunyi bagi semua tim. Gunakan runtime proyek yang
  sudah disepakati bila kelak memang perlu script lintas platform.
- Kutip path yang mengandung spasi; jangan merangkai operasi hapus/pindah
  melewati shell lain. Validasi target dan pilih operasi yang paling terarah.
- Laragon adalah lingkungan Windows pada baseline. Di macOS/Linux, tim perlu
  lingkungan MySQL kompatibel SRS dan verifikasi runtime tersendiri;
  panduan portabel tidak membuktikan binary/SDK/driver sudah kompatibel.
- CI/validator workspace mengikuti mandat audit publikasi; jangan menambah
  installer aplikasi, container atau layanan yang tidak diminta.

## IDE dan agent

Buka root repository, gunakan EditorConfig bila didukung editor/plugin.
AGENTS adalah sumber instruksi bersama; adapter hanya menunjukkan path sumber.
Editor yang belum membaca instruksi otomatis dapat membuka/melampirkan AGENTS
lalu menuntaskan [seluruh bacaan aktif](workflow.md#baca-lengkap) secara manual.
Jangan menyalin kumpulan skill ke setiap IDE.
Claude Code memakai impor `@AGENTS.md` di CLAUDE.md; periksa `/context` pada sesi
aktual. Jangan menjadikan symlink atau setting global prasyarat workspace.

Periksa file yang benar-benar dimuat melalui fitur diagnostics/attachments
IDE sebelum mengklaim integrasi berhasil. Bedakan PASS inspeksi berkas pada OS
sesi ini dari tes macOS/Linux atau pemuatan IDE yang belum dijalankan.
Rekomendasi VS Code berada di [extensions.json](../.vscode/extensions.json);
bersifat opsional, tidak memasang SDK atau menjalankan perintah. Tambahkan
settings/tasks/launch hanya bila kebutuhan dan perintah proyek aktual ada.
Jangan menyalin path SDK/node_modules, formatter paksa, atau task migrasi dari
proyek lain. Format bersama tetap mengikuti EditorConfig termasuk pengecualian
Markdown, bat/cmd dan arsip; periksa konflik dengan setting pribadi editor.
Setiap perubahan mengikuti [sinkronisasi dokumentasi](documentation.md).
