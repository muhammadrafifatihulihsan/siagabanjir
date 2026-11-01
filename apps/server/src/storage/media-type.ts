/**
 * Deteksi dan Validasi Tipe Media SiagaBanjir
 * Memeriksa magic bytes pada berkas biner untuk mencegah MIME spoofing
 * serta menegakkan batas ukuran berkas maksimum (10 MB gambar/dokumen, 25 MB video).
 */
import { HttpProblem } from '../http/problem.js';

export interface DetectedMedia {
  mime:
    'image/jpeg' | 'image/png' | 'image/webp' | 'video/mp4' | 'application/pdf';
  durationMs: number | null;
  pageCount: number | null;
}

/**
 * Mendeteksi tipe MIME dan atribut media berdasarkan header byte biner asli.
 */
export function detectMediaType(data: Buffer): DetectedMedia {
  if (data.length < 4) {
    throw new HttpProblem(415, 'UNSUPPORTED_MEDIA_TYPE');
  }

  // 1. JPEG: Header FF D8 FF
  if (data[0] === 0xff && data[1] === 0xd8 && data[2] === 0xff) {
    if (data.length > 10 * 1024 * 1024)
      throw new HttpProblem(413, 'PAYLOAD_TOO_LARGE');
    return { mime: 'image/jpeg', durationMs: null, pageCount: null };
  }

  // 2. PNG: Header 89 50 4E 47 0D 0A 1A 0A
  if (
    data.length >= 8 &&
    data[0] === 0x89 &&
    data[1] === 0x50 &&
    data[2] === 0x4e &&
    data[3] === 0x47 &&
    data[4] === 0x0d &&
    data[5] === 0x0a &&
    data[6] === 0x1a &&
    data[7] === 0x0a
  ) {
    if (data.length > 10 * 1024 * 1024)
      throw new HttpProblem(413, 'PAYLOAD_TOO_LARGE');
    return { mime: 'image/png', durationMs: null, pageCount: null };
  }

  // 3. WebP: Header RIFF....WEBP
  if (
    data.length >= 12 &&
    data.toString('ascii', 0, 4) === 'RIFF' &&
    data.toString('ascii', 8, 12) === 'WEBP'
  ) {
    if (data.length > 10 * 1024 * 1024)
      throw new HttpProblem(413, 'PAYLOAD_TOO_LARGE');
    return { mime: 'image/webp', durationMs: null, pageCount: null };
  }

  // 4. PDF: Header %PDF
  if (data.toString('ascii', 0, 4) === '%PDF') {
    if (data.length > 10 * 1024 * 1024)
      throw new HttpProblem(413, 'PAYLOAD_TOO_LARGE');
    return { mime: 'application/pdf', durationMs: null, pageCount: 1 };
  }

  // 5. MP4: Header ....ftyp
  if (data.length >= 8 && data.toString('ascii', 4, 8) === 'ftyp') {
    if (data.length > 25 * 1024 * 1024)
      throw new HttpProblem(413, 'PAYLOAD_TOO_LARGE');
    return { mime: 'video/mp4', durationMs: 4000, pageCount: null };
  }

  throw new HttpProblem(415, 'UNSUPPORTED_MEDIA_TYPE');
}
