/**
 * Endpoint HTTP Kotak Masuk Warga SiagaBanjir
 * Mendaftarkan rute pembacaan inbox dan penandaan pesan dibaca oleh warga.
 */
import type { FastifyInstance } from 'fastify';
import type { AuthDependencies } from '../../auth/signup.js';
import { requireSession } from '../../auth/session.js';
import { withConnection } from '../../db/pool.js';
import { HttpProblem } from '../problem.js';
import { listInbox, markRead } from '../../messages/inbox.js';
import { parseIdempotencyKey, envelope } from './common.js';

export function registerCitizenMessages(
  app: FastifyInstance,
  deps: AuthDependencies,
): void {
  // 1. GET /api/v1/me/inbox
  app.get<{ Querystring: { cursor?: string; q?: string } }>(
    '/api/v1/me/inbox',
    {
      schema: {
        querystring: {
          type: 'object',
          properties: {
            cursor: { type: 'string', minLength: 1, maxLength: 2048 },
            q: { type: 'string', minLength: 0, maxLength: 100 },
          },
          additionalProperties: false,
        },
      },
    },
    async (request) => {
      const session = await withConnection(deps.pool, (c) =>
        requireSession(c, request.headers.authorization),
      );
      if (session.role !== 'CITIZEN') throw new HttpProblem(403, 'FORBIDDEN');
      const data = await listInbox(deps, session.id, request.query);
      return envelope(request, data);
    },
  );

  // 2. PUT /api/v1/me/inbox/:messageId/read
  app.put<{ Params: { messageId: string }; Body: { contentVersion: number } }>(
    '/api/v1/me/inbox/:messageId/read',
    {
      schema: {
        params: {
          type: 'object',
          required: ['messageId'],
          properties: {
            messageId: {
              type: 'string',
              format: 'uuid',
              minLength: 36,
              maxLength: 36,
            },
          },
          additionalProperties: false,
        },
        body: {
          type: 'object',
          required: ['contentVersion'],
          properties: { contentVersion: { type: 'integer', minimum: 1 } },
          additionalProperties: false,
        },
      },
    },
    async (request) => {
      const session = await withConnection(deps.pool, (c) =>
        requireSession(c, request.headers.authorization),
      );
      if (session.role !== 'CITIZEN') throw new HttpProblem(403, 'FORBIDDEN');
      const data = await markRead(
        deps,
        session.id,
        parseIdempotencyKey(request),
        request.params.messageId,
        request.body,
      );
      return envelope(request, data);
    },
  );
}
