# Katalog skill SiagaBanjir

> **Living document:** perbarui bersama setiap perubahan terkait menurut [aturan dokumentasi](rules/documentation.md#living-documents).

Sumber prosedur berada pada delapan berkas SKILL.md di bawah. File ini adalah
indeks untuk manusia dan routing agent. **Seluruh delapan sumber SKILL.md wajib
dibaca penuh** melalui [protokol AGENTS](AGENTS.md), sebelum memilih prosedur
yang dijalankan. Metadata atau katalog ini tidak menggantikan isi sumber.

| Skill | Gunakan untuk | Batas |
|---|---|---|
| [siagabanjir-workspace](skills/siagabanjir-workspace/SKILL.md) | Folder, AGENTS, rules, skills dan dokumentasi kerja | Tidak menginisialisasi aplikasi |
| [siagabanjir-requirements](skills/siagabanjir-requirements/SKILL.md) | FRD/SRS, keputusan, AC/TC, kontrak dan RTM | Tidak mengarang approval atau hasil UAT |
| [siagabanjir-backend](skills/siagabanjir-backend/SKILL.md) | API, transaksi, worker, data dan AI pada backend tim | Tidak membuat backend awal tanpa mandat baru |
| [siagabanjir-flutter](skills/siagabanjir-flutter/SKILL.md) | Alur warga/admin, offline, konflik dan akses pada Flutter tim | Tidak membuat proyek Flutter awal |
| [siagabanjir-ui](skills/siagabanjir-ui/SKILL.md) | Desain/review layar, ikon standar, konten dan aksesibilitas | Tidak membuat proyek atau menambah fungsi di luar FRD |
| [siagabanjir-review](skills/siagabanjir-review/SKILL.md) | Review berbasis requirement dan bukti konkret | Tidak mengubah fitur saat hanya diminta review |
| [siagabanjir-debug](skills/siagabanjir-debug/SKILL.md) | Reproduksi bug, isolasi penyebab dan regresi terarah | Hipotesis bukan akar masalah terbukti |
| [siagabanjir-verification](skills/siagabanjir-verification/SKILL.md) | Rencana tes, paket regresi dan bukti penerimaan | Tidak menyatakan UAT/provider lulus dari inspeksi atau mock |

Contoh pemakaian saat ini: “Baca skills/siagabanjir-review/SKILL.md, lalu
review perubahan antrean admin.” Kewajiban baca seluruh dokumen aktif tetap
berlaku; menyebut satu skill tidak mengecualikan sumber lainnya. Pengguna tidak
perlu mengingatkan pembacaan maupun sinkronisasi dokumentasi.

Diagnosis masalah memakai debug; perubahan kode tetap mengikuti backend/Flutter.
Review memeriksa perubahan; verification dipakai jika tugasnya merancang atau
menjalankan paket tes/penerimaan. Edit teks kecil cukup pemeriksaan terarah.
Semua prosedur mengikuti [commit lokal wajib dan gerbang tree bersih](rules/workflow.md#commit-lokal).
Perubahan kecil tetap dicommit tanpa konfirmasi; tugas baca tanpa diff tidak
memerlukan commit kosong. Push mengikuti mandat yang tersedia.
[Riset pemilihan](docs/SKILL-RESEARCH.md) dan [aturan sumber](rules/research.md)
menjaga cakupan skill tetap sesuai proyek. [Seleksi Software-BK](docs/SKILL-RESEARCH.md#softwarebk)
memperkuat prosedur yang ada; tidak memerlukan skill baru atau penggantian stack.

## Lokasi dan penemuan

Codex mendukung skill repositori di `.agents/skills/<nama>/SKILL.md`.
Penulisan `.agents/` ditolak saat penyusunan oleh izin sesi. Sumber disiapkan
di `skills/` dan dibaca langsung, bukan diklaim terdaftar otomatis.

Jika penempatan native kelak tersedia, pindahkan seluruh folder skill ke
`.agents/skills/`, sesuaikan semua tautan relatif serta rujukan AGENTS/katalog,
lalu validasi kembali. Jangan menduplikasi sumber atau memperluas izin sesi
untuk memaksakan pendaftaran. Detail riset ada pada
[catatan workspace](docs/WORKSPACE.md).

Setiap skill mengikuti [sinkronisasi dokumentasi](rules/documentation.md).
Desain visual memakai [DESIGN](docs/DESIGN.md); perubahan OS/IDE memakai
[portabilitas](rules/portability.md). Nama/path skill, katalog dan routing
AGENTS harus diperbarui bersama jika cakupan skill berubah.
