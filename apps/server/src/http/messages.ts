import type { FastifyInstance, FastifyReply, FastifyRequest } from 'fastify';
import type { AuthDependencies } from '../auth/signup.js';
import { requireSession } from '../auth/session.js';
import { withConnection } from '../db/pool.js';
import { HttpProblem } from './problem.js';
import {
  publishMessage,
  listMessagesAdmin,
  getMessageAdmin,
  editMessage,
  revokeMessage,
  expireMessage,
  listInbox,
  markRead,
  type MessageCreate,
  type MessageUpdate,
} from '../messages/inbox.js';

function parseIdempotencyKey(request: FastifyRequest): string {
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

function parseIfMatch(request: FastifyRequest): number {
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

function envelope(request: FastifyRequest, data: unknown) {
  return { data, requestId: request.id, serverTime: new Date().toISOString() };
}

export function registerMessages(
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
      const session = await withConnection(deps.pool, (connection) =>
        requireSession(connection, request.headers.authorization),
      );
      if (session.role !== 'ADMIN') throw new HttpProblem(403, 'FORBIDDEN');

      const clientKey = parseIdempotencyKey(request);
      const data = await publishMessage(
        deps,
        session.id,
        clientKey,
        request.body,
      );
      reply.header('etag', `"${data.version}"`);
      return reply.status(201).send(envelope(request, data));
    },
  );

  // 2. GET /api/v1/admin/messages
  app.get<{
    Querystring: { cursor?: string; q?: string };
  }>(
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
      const session = await withConnection(deps.pool, (connection) =>
        requireSession(connection, request.headers.authorization),
      );
      if (session.role !== 'ADMIN') throw new HttpProblem(403, 'FORBIDDEN');

      const data = await listMessagesAdmin(deps, session.id, request.query);
      return envelope(request, data);
    },
  );

  // 3. GET /api/v1/admin/messages/:messageId
  app.get<{
    Params: { messageId: string };
  }>(
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
      const session = await withConnection(deps.pool, (connection) =>
        requireSession(connection, request.headers.authorization),
      );
      if (session.role !== 'ADMIN') throw new HttpProblem(403, 'FORBIDDEN');

      const data = await getMessageAdmin(deps, request.params.messageId);
      reply.header('etag', `"${data.version}"`);
      return envelope(request, data);
    },
  );

  // 4. PATCH /api/v1/admin/messages/:messageId
  app.patch<{
    Params: { messageId: string };
    Body: MessageUpdate;
  }>(
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
      const session = await withConnection(deps.pool, (connection) =>
        requireSession(connection, request.headers.authorization),
      );
      if (session.role !== 'ADMIN') throw new HttpProblem(403, 'FORBIDDEN');

      const ifMatch = parseIfMatch(request);
      const clientKey = parseIdempotencyKey(request);

      const data = await editMessage(
        deps,
        session.id,
        clientKey,
        request.params.messageId,
        ifMatch,
        request.body,
      );
      reply.header('etag', `"${data.version}"`);
      return envelope(request, data);
    },
  );

  // 5. POST /api/v1/admin/messages/:messageId/revoke
  app.post<{
    Params: { messageId: string };
  }>(
    '/api/v1/admin/messages/:messageId/revoke',
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
      const session = await withConnection(deps.pool, (connection) =>
        requireSession(connection, request.headers.authorization),
      );
      if (session.role !== 'ADMIN') throw new HttpProblem(403, 'FORBIDDEN');

      const ifMatch = parseIfMatch(request);
      const clientKey = parseIdempotencyKey(request);

      const data = await revokeMessage(
        deps,
        session.id,
        clientKey,
        request.params.messageId,
        ifMatch,
      );
      reply.header('etag', `"${data.version}"`);
      return envelope(request, data);
    },
  );

  // 6. POST /api/v1/admin/messages/:messageId/expire
  app.post<{
    Params: { messageId: string };
  }>(
    '/api/v1/admin/messages/:messageId/expire',
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
      const session = await withConnection(deps.pool, (connection) =>
        requireSession(connection, request.headers.authorization),
      );
      if (session.role !== 'ADMIN') throw new HttpProblem(403, 'FORBIDDEN');

      const ifMatch = parseIfMatch(request);
      const clientKey = parseIdempotencyKey(request);

      const data = await expireMessage(
        deps,
        session.id,
        clientKey,
        request.params.messageId,
        ifMatch,
      );
      reply.header('etag', `"${data.version}"`);
      return envelope(request, data);
    },
  );

  // 7. GET /api/v1/me/inbox
  app.get<{
    Querystring: { cursor?: string; q?: string };
  }>(
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
      const session = await withConnection(deps.pool, (connection) =>
        requireSession(connection, request.headers.authorization),
      );
      if (session.role !== 'CITIZEN') throw new HttpProblem(403, 'FORBIDDEN');

      const data = await listInbox(deps, session.id, request.query);
      return envelope(request, data);
    },
  );

  // 8. PUT /api/v1/me/inbox/:messageId/read
  app.put<{
    Params: { messageId: string };
    Body: { contentVersion: number };
  }>(
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
          properties: {
            contentVersion: { type: 'integer', minimum: 1 },
          },
          additionalProperties: false,
        },
      },
    },
    async (request) => {
      const session = await withConnection(deps.pool, (connection) =>
        requireSession(connection, request.headers.authorization),
      );
      if (session.role !== 'CITIZEN') throw new HttpProblem(403, 'FORBIDDEN');

      const clientKey = parseIdempotencyKey(request);
      const data = await markRead(
        deps,
        session.id,
        clientKey,
        request.params.messageId,
        request.body,
      );
      return envelope(request, data);
    },
  );
}
