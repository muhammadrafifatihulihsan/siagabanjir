import type { FastifyInstance, FastifyReply, FastifyRequest } from 'fastify';
import type { AuthDependencies } from '../auth/signup.js';
import { requireSession } from '../auth/session.js';
import { withConnection } from '../db/pool.js';
import { HttpProblem } from './problem.js';
import {
  getJob,
  retryReportAnalysis,
  listAdminReports,
  getAdminReport,
  correctAssessment,
  reviewReport,
  moveReport,
  appendReportNote,
  deleteReport,
  listGroups,
  getGroup,
  listGroupReports,
  completeGroup,
  listReportCleanup,
  retryReportCleanup,
  listAudit,
} from '../reporting/admin.js';

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

export function registerAdminReporting(
  app: FastifyInstance,
  deps: AuthDependencies,
): void {
  // 1. GET /api/v1/jobs/:jobId
  app.get<{ Params: { jobId: string } }>(
    '/api/v1/jobs/:jobId',
    async (request) => {
      const session = await withConnection(deps.pool, (connection) =>
        requireSession(connection, request.headers.authorization),
      );
      const data = await getJob(
        deps,
        session.id,
        session.role,
        request.params.jobId,
      );
      return envelope(request, data);
    },
  );

  // 2. POST /api/v1/reports/:reportId/analysis-retries
  app.post<{ Params: { reportId: string } }>(
    '/api/v1/reports/:reportId/analysis-retries',
    async (request, reply: FastifyReply) => {
      const session = await withConnection(deps.pool, (connection) =>
        requireSession(connection, request.headers.authorization),
      );
      const clientKey = parseIdempotencyKey(request);
      const data = await retryReportAnalysis(
        deps,
        session.id,
        session.role,
        clientKey,
        request.params.reportId,
      );
      return reply.status(202).send(envelope(request, data));
    },
  );

  // 3. GET /api/v1/admin/reports
  app.get<{
    Querystring: {
      cursor?: string;
      q?: string;
      from?: string;
      to?: string;
      status?: string;
    };
  }>('/api/v1/admin/reports', async (request) => {
    const session = await withConnection(deps.pool, (connection) =>
      requireSession(connection, request.headers.authorization),
    );
    if (session.role !== 'ADMIN') throw new HttpProblem(403, 'FORBIDDEN');

    const data = await listAdminReports(deps, session.id, request.query);
    return envelope(request, data);
  });

  // 4. GET /api/v1/admin/reports/:reportId
  app.get<{ Params: { reportId: string } }>(
    '/api/v1/admin/reports/:reportId',
    async (request, reply: FastifyReply) => {
      const session = await withConnection(deps.pool, (connection) =>
        requireSession(connection, request.headers.authorization),
      );
      if (session.role !== 'ADMIN') throw new HttpProblem(403, 'FORBIDDEN');

      const data = await getAdminReport(deps, request.params.reportId);
      reply.header('etag', `"${data.summary.version}"`);
      return envelope(request, data);
    },
  );

  // 5. PATCH /api/v1/admin/reports/:reportId/assessment
  app.patch<{
    Params: { reportId: string };
    Body: {
      relevance: 'MATCH' | 'MISMATCH' | 'INSUFFICIENT';
      level: 'LOW' | 'MEDIUM' | 'HIGH' | 'UNRATED';
      reason: string;
    };
  }>(
    '/api/v1/admin/reports/:reportId/assessment',
    {
      schema: {
        body: {
          type: 'object',
          required: ['relevance', 'level', 'reason'],
          properties: {
            relevance: {
              type: 'string',
              enum: ['MATCH', 'MISMATCH', 'INSUFFICIENT'],
            },
            level: {
              type: 'string',
              enum: ['LOW', 'MEDIUM', 'HIGH', 'UNRATED'],
            },
            reason: { type: 'string', minLength: 1, maxLength: 500 },
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

      const data = await correctAssessment(
        deps,
        session.id,
        clientKey,
        request.params.reportId,
        ifMatch,
        request.body,
      );
      reply.header('etag', `"${data.summary.version}"`);
      return envelope(request, data);
    },
  );

  // 6. PUT /api/v1/admin/reports/:reportId/review
  app.put<{
    Params: { reportId: string };
    Body: { evidenceVersion: number; resultVersion: number };
  }>(
    '/api/v1/admin/reports/:reportId/review',
    {
      schema: {
        body: {
          type: 'object',
          required: ['evidenceVersion', 'resultVersion'],
          properties: {
            evidenceVersion: { type: 'integer', minimum: 1 },
            resultVersion: { type: 'integer', minimum: 1 },
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

      const clientKey = parseIdempotencyKey(request);

      const data = await reviewReport(
        deps,
        session.id,
        clientKey,
        request.params.reportId,
        request.body,
      );
      return envelope(request, data);
    },
  );

  // 7. POST /api/v1/admin/reports/:reportId/moves
  app.post<{
    Params: { reportId: string };
    Body: {
      sourceGroupVersion: number;
      destination:
        | { kind: 'EXISTING'; groupId: string; groupVersion: number }
        | { kind: 'NEW_ACTIVE' };
      reason: string;
    };
  }>(
    '/api/v1/admin/reports/:reportId/moves',
    {
      schema: {
        body: {
          type: 'object',
          required: ['sourceGroupVersion', 'destination', 'reason'],
          properties: {
            sourceGroupVersion: { type: 'integer', minimum: 1 },
            destination: {
              type: 'object',
              required: ['kind'],
              properties: {
                kind: { type: 'string', enum: ['EXISTING', 'NEW_ACTIVE'] },
                groupId: { type: 'string', minLength: 36, maxLength: 36 },
                groupVersion: { type: 'integer', minimum: 1 },
              },
            },
            reason: { type: 'string', minLength: 1, maxLength: 500 },
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

      const data = await moveReport(
        deps,
        session.id,
        clientKey,
        request.params.reportId,
        ifMatch,
        request.body,
      );
      reply.header('etag', `"${data.summary.version}"`);
      return envelope(request, data);
    },
  );

  // 8. POST /api/v1/admin/reports/:reportId/notes
  app.post<{
    Params: { reportId: string };
    Body: {
      body: string;
      correctionOf?: string;
      correctionReason?: string;
    };
  }>(
    '/api/v1/admin/reports/:reportId/notes',
    {
      schema: {
        body: {
          type: 'object',
          required: ['body'],
          properties: {
            body: { type: 'string', minLength: 1, maxLength: 1000 },
            correctionOf: {
              type: 'string',
              minLength: 36,
              maxLength: 36,
            },
            correctionReason: {
              type: 'string',
              minLength: 1,
              maxLength: 500,
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

      const data = await appendReportNote(
        deps,
        session.id,
        clientKey,
        request.params.reportId,
        request.body,
      );
      return reply.status(201).send(envelope(request, data));
    },
  );

  // 9. POST /api/v1/admin/reports/:reportId/deletions
  app.post<{
    Params: { reportId: string };
    Body: { reason: string };
  }>(
    '/api/v1/admin/reports/:reportId/deletions',
    {
      schema: {
        body: {
          type: 'object',
          required: ['reason'],
          properties: {
            reason: { type: 'string', minLength: 1, maxLength: 500 },
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

      const data = await deleteReport(
        deps,
        session.id,
        clientKey,
        request.params.reportId,
        ifMatch,
        request.body,
      );
      return reply.status(202).send(envelope(request, data));
    },
  );

  // 10. GET /api/v1/admin/groups
  app.get<{
    Querystring: {
      cursor?: string;
      q?: string;
      state?: string;
      queue?: string;
    };
  }>('/api/v1/admin/groups', async (request) => {
    const session = await withConnection(deps.pool, (connection) =>
      requireSession(connection, request.headers.authorization),
    );
    if (session.role !== 'ADMIN') throw new HttpProblem(403, 'FORBIDDEN');

    const data = await listGroups(deps, session.id, request.query);
    return envelope(request, data);
  });

  // 11. GET /api/v1/admin/groups/:groupId
  app.get<{ Params: { groupId: string } }>(
    '/api/v1/admin/groups/:groupId',
    async (request, reply: FastifyReply) => {
      const session = await withConnection(deps.pool, (connection) =>
        requireSession(connection, request.headers.authorization),
      );
      if (session.role !== 'ADMIN') throw new HttpProblem(403, 'FORBIDDEN');

      const data = await getGroup(deps, request.params.groupId);
      reply.header('etag', `"${data.group.version}"`);
      return envelope(request, data);
    },
  );

  // 12. GET /api/v1/admin/groups/:groupId/reports
  app.get<{
    Params: { groupId: string };
    Querystring: { cursor?: string; q?: string };
  }>('/api/v1/admin/groups/:groupId/reports', async (request) => {
    const session = await withConnection(deps.pool, (connection) =>
      requireSession(connection, request.headers.authorization),
    );
    if (session.role !== 'ADMIN') throw new HttpProblem(403, 'FORBIDDEN');

    const data = await listGroupReports(
      deps,
      session.id,
      request.params.groupId,
      request.query,
    );
    return envelope(request, data);
  });

  // 13. POST /api/v1/admin/groups/:groupId/complete
  app.post<{ Params: { groupId: string } }>(
    '/api/v1/admin/groups/:groupId/complete',
    async (request, reply: FastifyReply) => {
      const session = await withConnection(deps.pool, (connection) =>
        requireSession(connection, request.headers.authorization),
      );
      if (session.role !== 'ADMIN') throw new HttpProblem(403, 'FORBIDDEN');

      const ifMatch = parseIfMatch(request);
      const clientKey = parseIdempotencyKey(request);

      const data = await completeGroup(
        deps,
        session.id,
        clientKey,
        request.params.groupId,
        ifMatch,
      );
      reply.header('etag', `"${data.version}"`);
      return envelope(request, data);
    },
  );

  // 14. GET /api/v1/admin/cleanup
  app.get<{ Querystring: { cursor?: string; q?: string } }>(
    '/api/v1/admin/cleanup',
    async (request) => {
      const session = await withConnection(deps.pool, (connection) =>
        requireSession(connection, request.headers.authorization),
      );
      if (session.role !== 'ADMIN') throw new HttpProblem(403, 'FORBIDDEN');

      const data = await listReportCleanup(deps, session.id, request.query);
      return envelope(request, data);
    },
  );

  // 15. POST /api/v1/admin/cleanup/:cleanupId/retry
  app.post<{ Params: { cleanupId: string } }>(
    '/api/v1/admin/cleanup/:cleanupId/retry',
    async (request, reply: FastifyReply) => {
      const session = await withConnection(deps.pool, (connection) =>
        requireSession(connection, request.headers.authorization),
      );
      if (session.role !== 'ADMIN') throw new HttpProblem(403, 'FORBIDDEN');

      const clientKey = parseIdempotencyKey(request);

      const data = await retryReportCleanup(
        deps,
        session.id,
        clientKey,
        request.params.cleanupId,
      );
      return reply.status(202).send(envelope(request, data));
    },
  );

  // 16. GET /api/v1/admin/audit
  app.get<{ Querystring: { cursor?: string; q?: string } }>(
    '/api/v1/admin/audit',
    async (request) => {
      const session = await withConnection(deps.pool, (connection) =>
        requireSession(connection, request.headers.authorization),
      );
      if (session.role !== 'ADMIN') throw new HttpProblem(403, 'FORBIDDEN');

      const data = await listAudit(deps, session.id, request.query);
      return envelope(request, data);
    },
  );
}
