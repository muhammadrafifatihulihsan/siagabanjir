<!-- Living document: pemeliharaan template mengikuti rules/documentation.md.
Isi fakta hasil kerja; jangan mencentang bacaan atau tes yang belum dilakukan.
-->

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
