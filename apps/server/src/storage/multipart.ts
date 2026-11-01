/**
 * Parser Multipart/form-data Ringan SiagaBanjir
 * Mengekstrak field teks dan berkas biner tanpa dependensi eksternal berat.
 */
import { HttpProblem } from '../http/problem.js';

export interface ParsedMultipart {
  fields: Record<string, string>;
  file?: {
    filename: string;
    mime: string;
    data: Buffer;
  };
}

/**
 * Mem-parsing isi body multipart/form-data berdasarkan boundary header Content-Type.
 */
export function parseMultipart(
  contentType: string,
  buffer: Buffer,
): ParsedMultipart {
  const boundaryMatch = /boundary=(?:"([^"]+)"|([^;]+))/i.exec(contentType);
  if (!boundaryMatch) throw new HttpProblem(400, 'BAD_REQUEST');

  const boundary = boundaryMatch[1] ?? boundaryMatch[2];
  if (!boundary) throw new HttpProblem(400, 'BAD_REQUEST');

  const boundaryBuffer = Buffer.from(`--${boundary}`);
  const doubleCrlf = Buffer.from('\r\n\r\n');

  const fields: Record<string, string> = {};
  let file: ParsedMultipart['file'];

  let startIndex = buffer.indexOf(boundaryBuffer);
  while (startIndex !== -1) {
    const afterBoundary = startIndex + boundaryBuffer.length;
    if (buffer.subarray(afterBoundary, afterBoundary + 2).toString() === '--')
      break;

    let partStart = afterBoundary;
    if (buffer[partStart] === 0x0d && buffer[partStart + 1] === 0x0a)
      partStart += 2;

    const nextBoundary = buffer.indexOf(boundaryBuffer, partStart);
    if (nextBoundary === -1) break;

    let partEnd = nextBoundary;
    if (buffer[partEnd - 2] === 0x0d && buffer[partEnd - 1] === 0x0a)
      partEnd -= 2;

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
          file = { filename, mime, data: bodyData };
        } else {
          fields[fieldName] = bodyData.toString('utf8');
        }
      }
    }

    startIndex = nextBoundary;
  }

  return file ? { fields, file } : { fields };
}
