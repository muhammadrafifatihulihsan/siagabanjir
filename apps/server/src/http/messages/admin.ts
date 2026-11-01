/**
 * Endpoint HTTP Pesan Siaran Admin SiagaBanjir
 * Mendaftarkan rute pembuatan, pembacaan, penyuntingan, pencabutan, dan pengakhiran pesan.
 */
import type { FastifyInstance, FastifyReply } from 'fastify';
import type { AuthDependencies } from '../../auth/signup.js';
import { requireSession } from '../../auth/session.js';
import { withConnection } from '../../db/pool.js';
import { HttpProblem } from '../problem.js';
import {
  publishMessage,
  listMessagesAdmin,
  getMessageAdmin,
  editMessage,
  revokeMessage,
  expireMessage,
  type MessageCreate,
  type MessageUpdate,
} from '../../messages/inbox.js';
import { parseIdempotencyKey, parseIfMatch, envelope } from './common.js';

export function registerAdminMessages(
  app: FastifyInstance,
  deps: AuthDependencies,
): void {
  // 1. POST /api/v1/admin/messages
  app.post<{ Body: MessageCreate }>(
    '/api/v1/admin/messages',
    {
      schema: {
        body: {
          type: 'object',
          required: ['title', 'body', 'endsAt'],
          properties: {
            title: { type: 'string', minLength: 1, maxLength: 120 },
            body: { type: 'string', minLength: 1, maxLength: 3000 },
            endsAt: {
              anyOf: [
                { type: 'string', minLength: 0, format: 'date-time' },
                { type: 'null' },
              ],
            },
          },
          additionalProperties: false,
        },
      },
    },
    async (request, reply: FastifyReply) => {
      const session = await withConnection(deps.pool, (c) =>
        requireSession(c, request.headers.authorization),
      );
      if (session.role !== 'ADMIN') throw new HttpProblem(403, 'FORBIDDEN');
      const data = await publishMessage(
        deps,
        session.id,
        parseIdempotencyKey(request),
        request.body,
      );
      reply.header('etag', `"${data.version}"`);
      return reply.status(201).send(envelope(request, data));
    },
  );

  // 2. GET /api/v1/admin/messages
  app.get<{ Querystring: { cursor?: string; q?: string } }>(
    '/api/v1/admin/messages',
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
      if (session.role !== 'ADMIN') throw new HttpProblem(403, 'FORBIDDEN');
      const data = await listMessagesAdmin(deps, session.id, request.query);
      return envelope(request, data);
    },
  );

  // 3. GET /api/v1/admin/messages/:messageId
  app.get<{ Params: { messageId: string } }>(
    '/api/v1/admin/messages/:messageId',
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
      },
    },
    async (request, reply: FastifyReply) => {
      const session = await withConnection(deps.pool, (c) =>
        requireSession(c, request.headers.authorization),
      );
      if (session.role !== 'ADMIN') throw new HttpProblem(403, 'FORBIDDEN');
      const data = await getMessageAdmin(deps, request.params.messageId);
      reply.header('etag', `"${data.version}"`);
      return envelope(request, data);
    },
  );

  // 4. PATCH /api/v1/admin/messages/:messageId
  app.patch<{ Params: { messageId: string }; Body: MessageUpdate }>(
    '/api/v1/admin/messages/:messageId',
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
          properties: {
            title: { type: 'string', minLength: 1, maxLength: 120 },
            body: { type: 'string', minLength: 1, maxLength: 3000 },
            endsAt: {
              anyOf: [
                { type: 'string', minLength: 0, format: 'date-time' },
                { type: 'null' },
              ],
            },
          },
          additionalProperties: false,
          minProperties: 1,
        },
      },
    },
    async (request, reply: FastifyReply) => {
      const session = await withConnection(deps.pool, (c) =>
        requireSession(c, request.headers.authorization),
      );
      if (session.role !== 'ADMIN') throw new HttpProblem(403, 'FORBIDDEN');
      const data = await editMessage(
        deps,
        session.id,
        parseIdempotencyKey(request),
        request.params.messageId,
        parseIfMatch(request),
        request.body,
      );
      reply.header('etag', `"${data.version}"`);
      return envelope(request, data);
    },
  );

  // 5. POST /api/v1/admin/messages/:messageId/revoke
  app.post<{ Params: { messageId: string } }>(
    '/api/v1/admin/messages/:messageId/revoke',
    async (request, reply: FastifyReply) => {
      const session = await withConnection(deps.pool, (c) =>
        requireSession(c, request.headers.authorization),
      );
      if (session.role !== 'ADMIN') throw new HttpProblem(403, 'FORBIDDEN');
      const data = await revokeMessage(
        deps,
        session.id,
        parseIdempotencyKey(request),
        request.params.messageId,
        parseIfMatch(request),
      );
      reply.header('etag', `"${data.version}"`);
      return envelope(request, data);
    },
  );

  // 6. POST /api/v1/admin/messages/:messageId/expire
  app.post<{ Params: { messageId: string } }>(
    '/api/v1/admin/messages/:messageId/expire',
    async (request, reply: FastifyReply) => {
      const session = await withConnection(deps.pool, (c) =>
        requireSession(c, request.headers.authorization),
      );
      if (session.role !== 'ADMIN') throw new HttpProblem(403, 'FORBIDDEN');
      const data = await expireMessage(
        deps,
        session.id,
        parseIdempotencyKey(request),
        request.params.messageId,
        parseIfMatch(request),
      );
      reply.header('etag', `"${data.version}"`);
      return envelope(request, data);
    },
  );
}
