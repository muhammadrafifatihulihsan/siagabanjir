import type { FastifyInstance, FastifyRequest } from 'fastify';
import type { AuthDependencies } from '../auth/signup.js';
import { requireSession } from '../auth/session.js';
import { withConnection } from '../db/pool.js';
import {
  createDocument,
  listDocuments,
  getDocument,
  deleteDocument,
  listOwnCleanup,
  retryOwnCleanup,
  getKtpState,
  checkKtp,
  confirmKtp,
  retryKtp,
  getFamily,
  updateFamily,
  extractFamily,
  retryFamilyExtraction,
  applyFamilySuggestions,
} from '../vault/documents.js';
import type {
  MemberOperation,
  MemberAdd,
  MemberUpdate,
} from '../vault/documents.js';
import { HttpProblem } from './problem.js';

function validateUuid(id: string): void {
  if (
    !/^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i.test(
      id,
    )
  ) {
    throw new HttpProblem(400, 'BAD_REQUEST');
  }
}

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

export function registerVault(
  app: FastifyInstance,
  deps: AuthDependencies,
): void {
  // 1. GET /api/v1/me/documents
  app.get<{ Querystring: { cursor?: string; q?: string } }>(
    '/api/v1/me/documents',
    {
      schema: {
        querystring: {
          type: 'object',
          additionalProperties: false,
          properties: {
            cursor: { type: 'string', minLength: 1, maxLength: 2048 },
            q: { type: 'string', minLength: 0, maxLength: 100 },
          },
        },
      },
    },
    async (request) => {
      const session = await withConnection(deps.pool, (connection) =>
        requireSession(connection, request.headers.authorization),
      );
      if (session.role !== 'CITIZEN') throw new HttpProblem(403, 'FORBIDDEN');
      const page = await listDocuments(deps, session.id, request.query);
      return envelope(request, page);
    },
  );

  // 2. POST /api/v1/me/documents
  app.post<{ Body: { uploadId: string; displayName: string } }>(
    '/api/v1/me/documents',
    {
      schema: {
        body: {
          type: 'object',
          additionalProperties: false,
          required: ['uploadId', 'displayName'],
          properties: {
            uploadId: {
              type: 'string',
              minLength: 36,
              maxLength: 36,
            },
            displayName: { type: 'string', minLength: 1, maxLength: 120 },
          },
        },
      },
    },
    async (request, reply) => {
      const session = await withConnection(deps.pool, (connection) =>
        requireSession(connection, request.headers.authorization),
      );
      if (session.role !== 'CITIZEN') throw new HttpProblem(403, 'FORBIDDEN');
      const key = parseIdempotencyKey(request);
      const doc = await createDocument(deps, session.id, key, request.body);
      return reply.code(201).send(envelope(request, doc));
    },
  );

  // 3. GET /api/v1/me/documents/:documentId
  app.get<{ Params: { documentId: string } }>(
    '/api/v1/me/documents/:documentId',
    async (request) => {
      const session = await withConnection(deps.pool, (connection) =>
        requireSession(connection, request.headers.authorization),
      );
      if (session.role !== 'CITIZEN') throw new HttpProblem(403, 'FORBIDDEN');
      const documentId = request.params.documentId.toLowerCase();
      validateUuid(documentId);
      const doc = await getDocument(deps, session.id, documentId);
      return envelope(request, doc);
    },
  );

  // 4. POST /api/v1/me/documents/:documentId/deletions
  app.post<{ Params: { documentId: string } }>(
    '/api/v1/me/documents/:documentId/deletions',
    async (request) => {
      const session = await withConnection(deps.pool, (connection) =>
        requireSession(connection, request.headers.authorization),
      );
      if (session.role !== 'CITIZEN') throw new HttpProblem(403, 'FORBIDDEN');
      const documentId = request.params.documentId.toLowerCase();
      validateUuid(documentId);
      const key = parseIdempotencyKey(request);
      const result = await deleteDocument(deps, session.id, documentId, key);
      return envelope(request, result);
    },
  );

  // 5. GET /api/v1/me/cleanup
  app.get<{ Querystring: { cursor?: string; q?: string } }>(
    '/api/v1/me/cleanup',
    async (request) => {
      const session = await withConnection(deps.pool, (connection) =>
        requireSession(connection, request.headers.authorization),
      );
      if (session.role !== 'CITIZEN') throw new HttpProblem(403, 'FORBIDDEN');
      const page = await listOwnCleanup(deps, session.id, request.query);
      return envelope(request, page);
    },
  );

  // 6. POST /api/v1/me/cleanup/:cleanupId/retry
  app.post<{ Params: { cleanupId: string } }>(
    '/api/v1/me/cleanup/:cleanupId/retry',
    async (request) => {
      const session = await withConnection(deps.pool, (connection) =>
        requireSession(connection, request.headers.authorization),
      );
      if (session.role !== 'CITIZEN') throw new HttpProblem(403, 'FORBIDDEN');
      const cleanupId = request.params.cleanupId.toLowerCase();
      validateUuid(cleanupId);
      const item = await retryOwnCleanup(deps, session.id, cleanupId);
      return envelope(request, item);
    },
  );

  // 7. GET /api/v1/me/ktp
  app.get('/api/v1/me/ktp', async (request) => {
    const session = await withConnection(deps.pool, (connection) =>
      requireSession(connection, request.headers.authorization),
    );
    if (session.role !== 'CITIZEN') throw new HttpProblem(403, 'FORBIDDEN');
    const state = await getKtpState(deps, session.id);
    return envelope(request, state);
  });

  // 8. POST /api/v1/me/ktp-checks
  app.post<{
    Body: {
      documentId: string;
      documentVersion: number;
      consentVersion: 'ktp-v1';
    };
  }>(
    '/api/v1/me/ktp-checks',
    {
      schema: {
        body: {
          type: 'object',
          additionalProperties: false,
          required: ['documentId', 'documentVersion', 'consentVersion'],
          properties: {
            documentId: { type: 'string', minLength: 36, maxLength: 36 },
            documentVersion: { type: 'integer', minimum: 1 },
            consentVersion: { const: 'ktp-v1' },
          },
        },
      },
    },
    async (request) => {
      const session = await withConnection(deps.pool, (connection) =>
        requireSession(connection, request.headers.authorization),
      );
      if (session.role !== 'CITIZEN') throw new HttpProblem(403, 'FORBIDDEN');
      const key = parseIdempotencyKey(request);
      const job = await checkKtp(deps, session.id, key, request.body);
      return envelope(request, job);
    },
  );

  // 9. POST /api/v1/me/ktp-confirmations
  app.post<{
    Body: {
      documentId: string;
      documentVersion: number;
      jobId: string;
      nameConfirmed: true;
    };
  }>(
    '/api/v1/me/ktp-confirmations',
    {
      schema: {
        body: {
          type: 'object',
          additionalProperties: false,
          required: ['documentId', 'documentVersion', 'jobId', 'nameConfirmed'],
          properties: {
            documentId: { type: 'string', minLength: 36, maxLength: 36 },
            documentVersion: { type: 'integer', minimum: 1 },
            jobId: { type: 'string', minLength: 36, maxLength: 36 },
            nameConfirmed: { const: true },
          },
        },
      },
    },
    async (request) => {
      const session = await withConnection(deps.pool, (connection) =>
        requireSession(connection, request.headers.authorization),
      );
      if (session.role !== 'CITIZEN') throw new HttpProblem(403, 'FORBIDDEN');
      const expectedVersion = parseIfMatch(request);
      const key = parseIdempotencyKey(request);
      const state = await confirmKtp(
        deps,
        session.id,
        key,
        expectedVersion,
        request.body,
      );
      return envelope(request, state);
    },
  );

  // 10. POST /api/v1/me/ktp-checks/:jobId/retry
  app.post<{ Params: { jobId: string } }>(
    '/api/v1/me/ktp-checks/:jobId/retry',
    async (request) => {
      const session = await withConnection(deps.pool, (connection) =>
        requireSession(connection, request.headers.authorization),
      );
      if (session.role !== 'CITIZEN') throw new HttpProblem(403, 'FORBIDDEN');
      const jobId = request.params.jobId.toLowerCase();
      validateUuid(jobId);
      const job = await retryKtp(deps, session.id, jobId);
      return envelope(request, job);
    },
  );

  // 11. GET /api/v1/me/family
  app.get('/api/v1/me/family', async (request) => {
    const session = await withConnection(deps.pool, (connection) =>
      requireSession(connection, request.headers.authorization),
    );
    if (session.role !== 'CITIZEN') throw new HttpProblem(403, 'FORBIDDEN');
    const family = await getFamily(deps, session.id);
    return envelope(request, family);
  });

  // 12. PATCH /api/v1/me/family
  app.patch<{ Body: { operations: MemberOperation[] } }>(
    '/api/v1/me/family',
    {
      schema: {
        body: {
          type: 'object',
          additionalProperties: false,
          required: ['operations'],
          properties: {
            operations: {
              type: 'array',
              minItems: 1,
              maxItems: 40,
            },
          },
        },
      },
    },
    async (request) => {
      const session = await withConnection(deps.pool, (connection) =>
        requireSession(connection, request.headers.authorization),
      );
      if (session.role !== 'CITIZEN') throw new HttpProblem(403, 'FORBIDDEN');
      const expectedVersion = parseIfMatch(request);
      const key = parseIdempotencyKey(request);
      const family = await updateFamily(
        deps,
        session.id,
        key,
        expectedVersion,
        request.body.operations,
      );
      return envelope(request, family);
    },
  );

  // 13. POST /api/v1/me/family-extractions
  app.post<{
    Body: {
      documents: { id: string; version: number }[];
      consentVersion: 'family-v1';
    };
  }>(
    '/api/v1/me/family-extractions',
    {
      schema: {
        body: {
          type: 'object',
          additionalProperties: false,
          required: ['documents', 'consentVersion'],
          properties: {
            documents: {
              type: 'array',
              minItems: 1,
              maxItems: 20,
              items: {
                type: 'object',
                additionalProperties: false,
                required: ['id', 'version'],
                properties: {
                  id: { type: 'string', minLength: 36, maxLength: 36 },
                  version: { type: 'integer', minimum: 1 },
                },
              },
            },
            consentVersion: { const: 'family-v1' },
          },
        },
      },
    },
    async (request) => {
      const session = await withConnection(deps.pool, (connection) =>
        requireSession(connection, request.headers.authorization),
      );
      if (session.role !== 'CITIZEN') throw new HttpProblem(403, 'FORBIDDEN');
      const key = parseIdempotencyKey(request);
      const job = await extractFamily(deps, session.id, key, request.body);
      return envelope(request, job);
    },
  );

  // 14. POST /api/v1/me/family-extractions/:jobId/retry
  app.post<{ Params: { jobId: string } }>(
    '/api/v1/me/family-extractions/:jobId/retry',
    async (request) => {
      const session = await withConnection(deps.pool, (connection) =>
        requireSession(connection, request.headers.authorization),
      );
      if (session.role !== 'CITIZEN') throw new HttpProblem(403, 'FORBIDDEN');
      const jobId = request.params.jobId.toLowerCase();
      validateUuid(jobId);
      const job = await retryFamilyExtraction(deps, session.id, jobId);
      return envelope(request, job);
    },
  );

  // 15. POST /api/v1/me/family-extractions/:jobId/apply
  app.post<{
    Params: { jobId: string };
    Body: {
      familyVersion: number;
      selections: {
        suggestionId: string;
        operation: MemberAdd | MemberUpdate;
      }[];
    };
  }>(
    '/api/v1/me/family-extractions/:jobId/apply',
    {
      schema: {
        body: {
          type: 'object',
          additionalProperties: false,
          required: ['familyVersion', 'selections'],
          properties: {
            familyVersion: { type: 'integer', minimum: 1 },
            selections: {
              type: 'array',
              minItems: 1,
              maxItems: 20,
            },
          },
        },
      },
    },
    async (request) => {
      const session = await withConnection(deps.pool, (connection) =>
        requireSession(connection, request.headers.authorization),
      );
      if (session.role !== 'CITIZEN') throw new HttpProblem(403, 'FORBIDDEN');
      const jobId = request.params.jobId.toLowerCase();
      validateUuid(jobId);
      const key = parseIdempotencyKey(request);
      const family = await applyFamilySuggestions(
        deps,
        session.id,
        key,
        jobId,
        request.body,
      );
      return envelope(request, family);
    },
  );
}
