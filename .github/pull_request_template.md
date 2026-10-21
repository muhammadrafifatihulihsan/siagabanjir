<!-- Living document: pemeliharaan template mengikuti rules/documentation.md.
Isi fakta hasil kerja; jangan mencentang bacaan atau tes yang belum dilakukan.
-->

## Arah kontribusi

Base: development / main. Head: branch anggota / development.
Keduanya dari repository ini; satu PR aktif per branch anggota.
Promosi ke main menyertakan bukti integrasi atau batas NOT_RUN yang relevan.

## Masalah dan hasil perubahan

Jelaskan masalah, perilaku akhir, dan alasan perubahan. Cantumkan FR/AC/TC atau
keputusan terkait bila relevan; untuk panduan, sebut scope workspace.

## Dokumentasi dan instruksi

- Diperbarui:
- Tidak terdampak beserta alasan:
- Tertunda atau konflik yang masih ada:

## Verifikasi

Tuliskan perintah/metode, cakupan dan hasil aktual. Bedakan PASS, FAIL, BLOCKED,
dan NOT_RUN. Dokumen/schema valid tidak membuktikan aplikasi atau provider lulus.
Cantumkan branch, SHA commit terbaru, hasil git status, serta status push/CI.

## Pemeriksaan sebelum merge

- [ ] Jika memakai AI: seluruh dokumen/instruksi aktif sudah dibaca penuh menurut AGENTS; cakupan atau kendala dicatat. Jika tanpa AI, jelaskan N/A.
- [ ] Living documents terdampak sudah diselaraskan dalam perubahan ini.
- [ ] File staged/diff, tautan, dan pemeriksaan sesuai dampak sudah ditinjau.
- [ ] Setiap unit perubahan sudah dicommit; perintah git status --porcelain=v1 --untracked-files=all berhasil tanpa keluaran pada penutupan lokal.
- [ ] Commit yang dipush dan CI cocok dengan SHA terbaru; checkpoint WIP yang belum tuntas tidak dinyatakan siap merge.
- [ ] Batas bukti/prasyarat tersisa disebutkan; tidak ada klaim tes atau approval rekaan.
- [ ] Arsip percakapan, secret/data pribadi, cache dan artefak sementara tidak ikut perubahan.

- [ ] Pasangan base/head sah; Rafi memutuskan merge setelah review dan CI.
- [ ] Gunakan merge commit; jangan hapus branch permanen setelah merge.
