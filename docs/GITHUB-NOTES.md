# Notes repository GitHub SiagaBanjir

> **Living document:** perbarui bersama setiap perubahan terkait menurut [aturan dokumentasi](../rules/documentation.md#living-documents).

Repo tujuan sudah ditentukan pemilik:
[muhammadrafifatihulihsan/siagabanjir](https://github.com/muhammadrafifatihulihsan/siagabanjir).
Pada audit awal 19 Oktober 2026, akses Git Bash berhasil dan remote belum
mempunyai branch. Hasil publikasi terbaru dicatat pada [handoff](SESSION-HANDOFF.md).

## Identitas repository

| Field | Isi yang disarankan |
|---|---|
| Repository name | `siagabanjir` |
| Nama tampilan proyek | SiagaBanjir |
| Description | Demo akademik pelaporan dan pemantauan banjir berbantuan AI, dengan Flutter untuk warga/admin dan backend bersama. |
| Topics opsional | `flood-monitoring`, `flutter`, `typescript`, `academic-project`, `indonesia` |

Deskripsi siap salin:

```text
Demo akademik pelaporan dan pemantauan banjir berbantuan AI, dengan Flutter untuk warga/admin dan backend bersama.
```

## Kondisi isi awal

Spesifikasi BRD/PRD/FRD/SRS dan panduan kerja tersedia. Kontrak API ikut repo.
apps/server dan apps/app merupakan wadah kosong untuk inisialisasi tim;
deskripsi proyek tidak menyatakan aplikasinya sudah berjalan atau teruji.

Kontrak API dan spesifikasi lengkap ikut Git. Percakapan mentah dan cache tidak.

Repository tidak perlu dibuat ulang. Visibilitas mengikuti pengaturan pemilik;
lisensi yang sudah tersedia adalah [All Rights Reserved](../LICENSE).
Ikuti [panduan commit, push dan PR](GITHUB-WORKFLOW.md), periksa staged diff,
lalu gunakan pesan commit awal yang disarankan:

```text
docs: prepare SiagaBanjir specifications and workspace
```

Hasil pemeriksaan dan batas bukti ada pada
[audit final setup](WORKSPACE.md#audit-final).
