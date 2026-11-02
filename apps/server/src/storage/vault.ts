/**
 * Modul Penyimpanan Berkas Media SiagaBanjir
 * Menyediakan penyimpanan biner lokal, pembacaan rentang bytes (Range 206),
 * serta proteksi penelusuran path (path traversal protection).
 *
 * Struktur folder (agar tidak menumpuk dalam satu direktori datar):
 *   storage/uploads/REPORT/<tahun>/<bulan>/<uploadId>_<sha256>
 *   storage/uploads/DOCUMENT/<tahun>/<bulan>/<uploadId>_<sha256>
 *   storage/working/   (berkas sementara praproses AI, dibersihkan otomatis)
 *
 * `blob_key` di basis data menyimpan path relatif terhadap `storage/uploads`.
 * Kunci lama yang masih datar (`<uploadId>_<sha256>`) tetap dapat dibaca.
 */
import { createHash } from 'node:crypto';
import { mkdir, writeFile, readFile, stat } from 'node:fs/promises';
import { join, resolve, sep } from 'node:path';
import { HttpProblem } from '../http/problem.js';

export * from './media-type.js';
export * from './multipart.js';

export type BlobPurpose = 'REPORT' | 'DOCUMENT';

/**
 * Mendapatkan direktori absolut penyimpanan blob media.
 */
export function getStorageDirectory(): string {
  return process.env.STORAGE_DIR ?? join(process.cwd(), 'storage');
}

/**
 * Mengubah `blob_key` relatif menjadi path absolut di dalam `storage/uploads`.
 * Menolak segmen `..`, path absolut, dan karakter di luar `[A-Za-z0-9_.-]`
 * sehingga tidak ada penelusuran keluar direktori penyimpanan.
 */
export function resolveBlobPath(blobKey: string): string {
  const base = resolve(getStorageDirectory(), 'uploads');
  const normalized = blobKey.replace(/\\/g, '/');
  const segments = normalized.split('/');
  const hostile =
    normalized.startsWith('/') ||
    segments.some(
      (segment) =>
        segment === '' ||
        segment === '.' ||
        segment === '..' ||
        !/^[A-Za-z0-9_.-]+$/.test(segment),
    );
  if (hostile) throw new HttpProblem(400, 'BAD_REQUEST');

  const candidate = resolve(base, normalized);
  if (candidate !== base && !candidate.startsWith(`${base}${sep}`)) {
    throw new HttpProblem(400, 'BAD_REQUEST');
  }
  return candidate;
}

/**
 * Menyimpan buffer media ke disk dengan subfolder menurut tujuan, tahun, dan bulan.
 */
export async function saveMediaBlob(
  uploadId: string,
  data: Buffer,
  purpose: BlobPurpose = 'REPORT',
): Promise<{ digest: string; blobKey: string }> {
  const now = new Date();
  const year = String(now.getUTCFullYear());
  const month = String(now.getUTCMonth() + 1).padStart(2, '0');
  const dir = join(getStorageDirectory(), 'uploads', purpose, year, month);
  await mkdir(dir, { recursive: true });
  const digest = createHash('sha256').update(data).digest('hex');
  const fileName = `${uploadId}_${digest}`;
  const blobKey = `${purpose}/${year}/${month}/${fileName}`;
  await writeFile(join(dir, fileName), data);
  return { digest, blobKey };
}

/**
 * Membaca buffer berkas media dengan dukungan HTTP Range streaming (206 Partial Content).
 * Melindungi dari path traversal dengan validasi path pada blobKey.
 */
export async function readMediaBlob(
  blobKey: string,
  range?: { start: number; end: number },
): Promise<{ data: Buffer; totalSize: number }> {
  const filePath = resolveBlobPath(blobKey);

  let fileStat;
  try {
    fileStat = await stat(filePath);
  } catch {
    throw new HttpProblem(404, 'NOT_FOUND');
  }
  const totalSize = fileStat.size;

  if (range) {
    const full = await readFile(filePath);
    return { data: full.subarray(range.start, range.end + 1), totalSize };
  }

  return { data: await readFile(filePath), totalSize };
}
