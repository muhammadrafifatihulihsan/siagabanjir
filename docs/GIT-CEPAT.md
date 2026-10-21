# Git cepat untuk tim

> **Living document:** perbarui bersama setiap perubahan terkait menurut [aturan dokumentasi](../rules/documentation.md#living-documents).

Pilih bagian namamu. Clone cukup sekali; salin per langkah memakai **Git Bash**.
Berhenti jika error. Sebelum `git add .`, periksa semua file perubahan.
Detail: [panduan GitHub](GITHUB-WORKFLOW.md).

## Rafi

**Clone pertama:**

```bash
git clone --branch branch-rafi https://github.com/muhammadrafifatihulihsan/siagabanjir.git
cd siagabanjir
git branch -m main
```

**Ngoding, lalu simpan dan push:**

```bash
git add .
git commit -m "pesan kita"
git push origin main:branch-rafi
```

GitHub -> New pull request: **base `development`**, **compare `branch-rafi`**.

## Hasan

**Clone pertama:**

```bash
git clone --branch branch-hasan https://github.com/muhammadrafifatihulihsan/siagabanjir.git
cd siagabanjir
git branch -m main
```

**Ngoding, lalu simpan dan push:**

```bash
git add .
git commit -m "pesan kita"
git push origin main:branch-hasan
```

GitHub -> New pull request: **base `development`**, **compare `branch-hasan`**.

## Melia

**Clone pertama:**

```bash
git clone --branch branch-melia https://github.com/muhammadrafifatihulihsan/siagabanjir.git
cd siagabanjir
git branch -m main
```

**Ngoding, lalu simpan dan push:**

```bash
git add .
git commit -m "pesan kita"
git push origin main:branch-melia
```

GitHub -> New pull request: **base `development`**, **compare `branch-melia`**.

## Tugas berikutnya (semua anggota)

Setelah **semua pekerjaan masuk main GitHub** lewat PR development dan promosi main,
jalankan dari root folder `siagabanjir`:

**Perubahan lokal dan file untracked akan dihapus.** File ignored seperti `.env`
tetap ada. Jangan jalankan jika masih ada pekerjaan yang perlu disimpan.

```bash
git switch main && git fetch origin && git reset --hard origin/main && git clean -fd
```

Ngoding lagi -> ulangi add, commit, push, dan PR sesuai namamu. Tidak clone lagi.
