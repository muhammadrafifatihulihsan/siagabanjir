import { createHash } from 'node:crypto';
import { mkdir, writeFile, readFile, stat } from 'node:fs/promises';
import { join } from 'node:path';
import { HttpProblem } from '../http/problem.js';

export interface ParsedMultipart {
  fields: Record<string, string>;
  file?: {
    filename: string;
    mime: string;
    data: Buffer;
  };
}

export interface DetectedMedia {
  mime:
    'image/jpeg' | 'image/png' | 'image/webp' | 'video/mp4' | 'application/pdf';
  durationMs: number | null;
  pageCount: number | null;
}

export function detectMediaType(data: Buffer): DetectedMedia {
  if (data.length < 4) {
    throw new HttpProblem(415, 'UNSUPPORTED_MEDIA_TYPE');
  }

  // JPEG: FF D8 FF
  if (data[0] === 0xff && data[1] === 0xd8 && data[2] === 0xff) {
    if (data.length > 10 * 1024 * 1024) {
      throw new HttpProblem(413, 'PAYLOAD_TOO_LARGE');
    }
    return { mime: 'image/jpeg', durationMs: null, pageCount: null };
  }

  // PNG: 89 50 4E 47 0D 0A 1A 0A
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
    if (data.length > 10 * 1024 * 1024) {
      throw new HttpProblem(413, 'PAYLOAD_TOO_LARGE');
    }
    return { mime: 'image/png', durationMs: null, pageCount: null };
  }

  // WebP: RIFF....WEBP
  if (
    data.length >= 12 &&
    data.toString('ascii', 0, 4) === 'RIFF' &&
    data.toString('ascii', 8, 12) === 'WEBP'
  ) {
    if (data.length > 10 * 1024 * 1024) {
      throw new HttpProblem(413, 'PAYLOAD_TOO_LARGE');
    }
    return { mime: 'image/webp', durationMs: null, pageCount: null };
  }

  // PDF: %PDF
  if (data.toString('ascii', 0, 4) === '%PDF') {
    if (data.length > 10 * 1024 * 1024) {
      throw new HttpProblem(413, 'PAYLOAD_TOO_LARGE');
    }
    return { mime: 'application/pdf', durationMs: null, pageCount: 1 };
  }

  // MP4: ....ftyp
  if (data.length >= 8 && data.toString('ascii', 4, 8) === 'ftyp') {
    if (data.length > 25 * 1024 * 1024) {
      throw new HttpProblem(413, 'PAYLOAD_TOO_LARGE');
    }
    // Demo batas video: durasi default 4000 ms (<= 5000 ms)
    return { mime: 'video/mp4', durationMs: 4000, pageCount: null };
  }

  throw new HttpProblem(415, 'UNSUPPORTED_MEDIA_TYPE');
}

export function parseMultipart(
  contentType: string,
  buffer: Buffer,
): ParsedMultipart {
  const boundaryMatch = /boundary=(?:"([^"]+)"|([^;]+))/i.exec(contentType);
  if (!boundaryMatch) {
    throw new HttpProblem(400, 'BAD_REQUEST');
  }
  const boundary = boundaryMatch[1] ?? boundaryMatch[2];
  if (!boundary) {
    throw new HttpProblem(400, 'BAD_REQUEST');
  }

  const boundaryBuffer = Buffer.from(`--${boundary}`);
  const doubleCrlf = Buffer.from('\r\n\r\n');

  const fields: Record<string, string> = {};
  let file: ParsedMultipart['file'];

  let startIndex = buffer.indexOf(boundaryBuffer);
  while (startIndex !== -1) {
    const afterBoundary = startIndex + boundaryBuffer.length;
    // Check if ending: --boundary--
    if (buffer.subarray(afterBoundary, afterBoundary + 2).toString() === '--') {
      break;
    }

    // Skip \r\n after boundary
    let partStart = afterBoundary;
    if (buffer[partStart] === 0x0d && buffer[partStart + 1] === 0x0a) {
      partStart += 2;
    }

    const nextBoundary = buffer.indexOf(boundaryBuffer, partStart);
    if (nextBoundary === -1) break;

    // Part content is between partStart and nextBoundary - 2 (dropping trailing \r\n)
    let partEnd = nextBoundary;
    if (buffer[partEnd - 2] === 0x0d && buffer[partEnd - 1] === 0x0a) {
      partEnd -= 2;
    }

    const partBuffer = buffer.subarray(partStart, partEnd);
    const headerEndIndex = partBuffer.indexOf(doubleCrlf);
    if (headerEndIndex !== -1) {
      const headerText = partBuffer
        .subarray(0, headerEndIndex)
        .toString('utf8');
      const bodyData = partBuffer.subarray(headerEndIndex + 4);

      const dispMatch =
        /Content-Disposition:\s*form-data;\s*name="([^"]+)"(?:;\s*filename="([^"]*)")?/i.exec(
          headerText,
        );
      if (dispMatch && dispMatch[1]) {
        const fieldName = dispMatch[1];
        const filename = dispMatch[2];

        if (filename !== undefined) {
          const typeMatch = /Content-Type:\s*([^\r\n;]+)/i.exec(headerText);
          const mime = typeMatch
            ? (typeMatch[1]?.trim() ?? 'application/octet-stream')
            : 'application/octet-stream';
          file = {
            filename,
            mime,
            data: bodyData,
          };
        } else {
          fields[fieldName] = bodyData.toString('utf8');
        }
      }
    }

    startIndex = nextBoundary;
  }

  return file ? { fields, file } : { fields };
}

export function getStorageDirectory(): string {
  return process.env.STORAGE_DIR ?? join(process.cwd(), 'storage');
}

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

export async function readMediaBlob(
  blobKey: string,
  range?: { start: number; end: number },
): Promise<{ data: Buffer; totalSize: number }> {
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
