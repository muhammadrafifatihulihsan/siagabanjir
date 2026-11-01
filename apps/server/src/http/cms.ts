import type { FastifyInstance, FastifyReply, FastifyRequest } from 'fastify';
import type { AuthDependencies } from '../auth/signup.js';
import { requireSession } from '../auth/session.js';
import { withConnection } from '../db/pool.js';
import { HttpProblem } from './problem.js';
import {
  listMonitor,
  getContentManifest,
  getContentPart,
  listContentAdmin,
  createContentDraft,
  updateContentDraft,
  deleteContentDraft,
  publishContent,
  withdrawContent,
} from '../content/cms.js';
import type { ContentInput } from '../content/cms.js';

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

export function registerCms(
  app: FastifyInstance,
  deps: AuthDependencies,
): void {
  // 1. GET /api/v1/public/monitor
  app.get<{
    Querystring: { cursor?: string; q?: string; section?: string };
  }>('/api/v1/public/monitor', async (request) => {
    const data = await listMonitor(deps, request.query);
    return envelope(request, data);
  });

  // 2. GET /api/v1/public/content/manifest
  app.get('/api/v1/public/content/manifest', async (request) => {
    const data = await getContentManifest(deps);
    return envelope(request, data);
  });

  // 3. GET /api/v1/public/content/:revision/:kind
  app.get<{
    Params: { revision: string; kind: string };
    Querystring: { cursor?: string; q?: string };
  }>('/api/v1/public/content/:revision/:kind', async (request) => {
    const rev = Number.parseInt(request.params.revision, 10);
    if (Number.isNaN(rev) || rev < 1) {
      throw new HttpProblem(400, 'BAD_REQUEST');
    }
    const data = await getContentPart(
      deps,
      rev,
      request.params.kind,
      request.query,
    );
    return envelope(request, data);
  });

  // 4. GET /api/v1/admin/content/:kind
  app.get<{
    Params: { kind: string };
    Querystring: { cursor?: string; q?: string };
  }>('/api/v1/admin/content/:kind', async (request) => {
    const session = await withConnection(deps.pool, (connection) =>
      requireSession(connection, request.headers.authorization),
    );
    if (session.role !== 'ADMIN') throw new HttpProblem(403, 'FORBIDDEN');

    const data = await listContentAdmin(
      deps,
      session.id,
      request.params.kind,
      request.query,
    );
    return envelope(request, data);
  });

  // 5. POST /api/v1/admin/content/:kind
  app.post<{
    Params: { kind: string };
    Body: ContentInput;
  }>('/api/v1/admin/content/:kind', async (request, reply: FastifyReply) => {
    const session = await withConnection(deps.pool, (connection) =>
      requireSession(connection, request.headers.authorization),
    );
    if (session.role !== 'ADMIN') throw new HttpProblem(403, 'FORBIDDEN');

    const clientKey = parseIdempotencyKey(request);
    const data = await createContentDraft(
      deps,
      session.id,
      clientKey,
      request.params.kind,
      request.body,
    );
    reply.header('etag', `"${data.version}"`);
    return reply.status(201).send(envelope(request, data));
  });

  // 6. PUT /api/v1/admin/content/:kind/:contentId
  app.put<{
    Params: { kind: string; contentId: string };
    Body: ContentInput;
  }>(
    '/api/v1/admin/content/:kind/:contentId',
    async (request, reply: FastifyReply) => {
      const session = await withConnection(deps.pool, (connection) =>
        requireSession(connection, request.headers.authorization),
      );
      if (session.role !== 'ADMIN') throw new HttpProblem(403, 'FORBIDDEN');

      const ifMatch = parseIfMatch(request);
      const clientKey = parseIdempotencyKey(request);

      const data = await updateContentDraft(
        deps,
        session.id,
        clientKey,
        request.params.kind,
        request.params.contentId,
        ifMatch,
        request.body,
      );
      reply.header('etag', `"${data.version}"`);
      return envelope(request, data);
    },
  );

  // 7. DELETE /api/v1/admin/content/:kind/:contentId
  app.delete<{
    Params: { kind: string; contentId: string };
  }>(
    '/api/v1/admin/content/:kind/:contentId',
    async (request, reply: FastifyReply) => {
      const session = await withConnection(deps.pool, (connection) =>
        requireSession(connection, request.headers.authorization),
      );
      if (session.role !== 'ADMIN') throw new HttpProblem(403, 'FORBIDDEN');

      const ifMatch = parseIfMatch(request);
      const clientKey = parseIdempotencyKey(request);

      const data = await deleteContentDraft(
        deps,
        session.id,
        clientKey,
        request.params.kind,
        request.params.contentId,
        ifMatch,
      );
      return reply.status(200).send(envelope(request, data));
    },
  );

  // 8. POST /api/v1/admin/content/:kind/:contentId/publish
  app.post<{
    Params: { kind: string; contentId: string };
  }>(
    '/api/v1/admin/content/:kind/:contentId/publish',
    async (request, reply: FastifyReply) => {
      const session = await withConnection(deps.pool, (connection) =>
        requireSession(connection, request.headers.authorization),
      );
      if (session.role !== 'ADMIN') throw new HttpProblem(403, 'FORBIDDEN');

      const ifMatch = parseIfMatch(request);
      const clientKey = parseIdempotencyKey(request);

      const data = await publishContent(
        deps,
        session.id,
        clientKey,
        request.params.kind,
        request.params.contentId,
        ifMatch,
      );
      reply.header('etag', `"${data.version}"`);
      return envelope(request, data);
    },
  );

  // 9. POST /api/v1/admin/content/:kind/:contentId/withdraw
  app.post<{
    Params: { kind: string; contentId: string };
  }>(
    '/api/v1/admin/content/:kind/:contentId/withdraw',
    async (request, reply: FastifyReply) => {
      const session = await withConnection(deps.pool, (connection) =>
        requireSession(connection, request.headers.authorization),
      );
      if (session.role !== 'ADMIN') throw new HttpProblem(403, 'FORBIDDEN');

      const ifMatch = parseIfMatch(request);
      const clientKey = parseIdempotencyKey(request);

      const data = await withdrawContent(
        deps,
        session.id,
        clientKey,
        request.params.kind,
        request.params.contentId,
        ifMatch,
      );
      reply.header('etag', `"${data.version}"`);
      return envelope(request, data);
    },
  );
}
