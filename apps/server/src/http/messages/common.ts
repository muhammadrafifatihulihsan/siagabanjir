/**
 * Utilitas dan Helper HTTP untuk Modul Pesan SiagaBanjir
 * Menyediakan fungsi parsing header Idempotency-Key, If-Match ETag, dan pembungkus envelope JSON.
 */
import type { FastifyRequest } from 'fastify';
import { HttpProblem } from '../problem.js';

/**
 * Memvalidasi dan mengekstrak UUID dari header Idempotency-Key.
 */
export function parseIdempotencyKey(request: FastifyRequest): string {
  const key = request.headers['idempotency-key'];
  if (
    typeof key !== 'string' ||
    !/^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i.test(
      key,
    )
  ) {
    throw new HttpProblem(400, 'BAD_REQUEST');
  }
  return key.toLowerCase();
}

/**
 * Mengekstrak nilai versi numerik dari header If-Match ("<version>").
 */
export function parseIfMatch(request: FastifyRequest): number {
  const header = request.headers['if-match'];
  if (header === undefined) {
    throw new HttpProblem(428, 'PRECONDITION_REQUIRED');
  }
  if (typeof header !== 'string') {
    throw new HttpProblem(400, 'BAD_REQUEST');
  }
  const match = /^"([1-9][0-9]*)"$/.exec(header);
  if (!match || !match[1]) {
    throw new HttpProblem(400, 'BAD_REQUEST');
  }
  return Number.parseInt(match[1], 10);
}

/**
 * Membungkus data hasil menjadi format envelope standar respons API SiagaBanjir.
 */
export function envelope(request: FastifyRequest, data: unknown) {
  return { data, requestId: request.id, serverTime: new Date().toISOString() };
}
