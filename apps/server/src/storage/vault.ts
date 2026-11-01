/**
 * Modul Penyimpanan Berkas Media SiagaBanjir
 * Menyediakan penyimpanan biner lokal, pembacaan rentang bytes (Range 206),
 * serta proteksi penelusuran path (path traversal protection).
 */
import { createHash } from 'node:crypto';
import { mkdir, writeFile, readFile, stat } from 'node:fs/promises';
import { join } from 'node:path';
import { HttpProblem } from '../http/problem.js';

export * from './media-type.js';
export * from './multipart.js';

/**
 * Mendapatkan direktori absolut penyimpanan blob media.
 */
export function getStorageDirectory(): string {
  return process.env.STORAGE_DIR ?? join(process.cwd(), 'storage');
}

/**
 * Menyimpan buffer media ke disk dengan penamaan kunci berbasis SHA-256 dan upload ID.
 */
export async function saveMediaBlob(
  uploadId: string,
  data: Buffer,
): Promise<{ digest: string; blobKey: string }> {
  const dir = join(getStorageDirectory(), 'uploads');
  await mkdir(dir, { recursive: true });
  const digest = createHash('sha256').update(data).digest('hex');
  const blobKey = `${uploadId}_${digest}`;
  const filePath = join(dir, blobKey);
  await writeFile(filePath, data);
  return { digest, blobKey };
}

/**
 * Membaca buffer berkas media dengan dukungan HTTP Range streaming (206 Partial Content).
 * Melindungi dari path traversal dengan validasi format alfanumerik pada blobKey.
 */
export async function readMediaBlob(
  blobKey: string,
  range?: { start: number; end: number },
): Promise<{ data: Buffer; totalSize: number }> {
  if (!/^[a-z0-9_-]+$/i.test(blobKey)) {
    throw new HttpProblem(400, 'BAD_REQUEST');
  }

  const filePath = join(getStorageDirectory(), 'uploads', blobKey);
  try {
    const fileStat = await stat(filePath);
    const totalSize = fileStat.size;

    if (range) {
      const full = await readFile(filePath);
      const slice = full.subarray(range.start, range.end + 1);
      return { data: slice, totalSize };
    }

    const data = await readFile(filePath);
    return { data, totalSize };
  } catch {
    throw new HttpProblem(404, 'NOT_FOUND');
  }
}
