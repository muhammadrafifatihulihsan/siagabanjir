import type { FastifyInstance } from 'fastify';

export function errorBody(requestId: string, status: number) {
  const known: Record<number, [string, string]> = {
    400: ['BAD_REQUEST', 'Format permintaan tidak valid.'],
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
