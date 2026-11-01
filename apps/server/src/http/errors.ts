import type { FastifyInstance } from 'fastify';
import { HttpProblem } from './problem.js';
import { CommandConflict } from '../db/secret-command.js';
import { HashCapacityError } from '../security/password.js';

export function errorBody(requestId: string, status: number) {
  const known: Record<number, [string, string]> = {
    400: ['BAD_REQUEST', 'Format permintaan tidak valid.'],
    401: ['INVALID_CREDENTIALS', 'Kredensial atau sesi tidak valid.'],
    403: ['FORBIDDEN', 'Akses tidak diizinkan.'],
    409: ['CONFLICT', 'Aksi berkonflik atau sudah tersimpan.'],
    429: ['AUTH_THROTTLED', 'Terlalu banyak percobaan; coba kembali nanti.'],
    503: ['SERVICE_UNAVAILABLE', 'Layanan sementara belum tersedia.'],
    404: ['NOT_FOUND', 'Sumber tidak ditemukan.'],
    413: ['PAYLOAD_TOO_LARGE', 'Ukuran permintaan melebihi batas.'],
    415: ['UNSUPPORTED_MEDIA_TYPE', 'Format permintaan tidak didukung.'],
    422: ['VALIDATION_FAILED', 'Masukan tidak sesuai aturan.'],
  };
  const [code, message] = known[status] ?? [
    'INTERNAL_ERROR',
    'Permintaan belum dapat diproses.',
  ];
  return {
    code,
    message,
    requestId,
    retryable: status >= 500,
    fields: [],
    currentVersion: null,
    retryAfterSeconds: null,
  };
}

export function registerErrors(app: FastifyInstance): void {
  app.setNotFoundHandler((request, reply) =>
    reply.code(404).send(errorBody(request.id, 404)),
  );
  app.setErrorHandler((error, request, reply) => {
    if (
      error instanceof HttpProblem ||
      error instanceof CommandConflict ||
      error instanceof HashCapacityError
    ) {
      const status =
        error instanceof HttpProblem
          ? error.status
          : error instanceof CommandConflict
            ? 409
            : 503;
      const code =
        error instanceof HashCapacityError ? 'SERVICE_UNAVAILABLE' : error.code;
      return reply.code(status).send({
        ...errorBody(request.id, status),
        code,
        retryAfterSeconds:
          error instanceof HttpProblem ? error.retryAfterSeconds : null,
      });
    }
    // Jangan meneruskan message/stack/validation data yang mungkin memuat input privat.
    const status =
      error instanceof Error && 'validation' in error
        ? 'validationContext' in error &&
          error.validationContext === 'querystring'
          ? 400
          : 422
        : error instanceof Error && 'statusCode' in error
          ? error.statusCode
          : 500;
    const safeStatus =
      typeof status === 'number' && [400, 413, 415, 422].includes(status)
        ? status
        : 500;
    if (safeStatus === 500) request.log.error({ event: 'request_failed' });
    return reply.code(safeStatus).send(errorBody(request.id, safeStatus));
  });
}
