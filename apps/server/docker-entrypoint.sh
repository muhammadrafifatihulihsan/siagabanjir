#!/bin/sh
set -e

echo "==> SiagaBanjir Backend Entrypoint"

# 1. Jalankan migrasi database otomatis
echo "==> Menjalankan migrasi database..."
node dist/db/cli.js migrate || {
  echo "==> Gagal menjalankan migrasi database. Pastikan MySQL sudah siap."
  exit 1
}

# 2. Mulai server Fastify
echo "==> Memulai server Fastify..."
exec node dist/server.js
