import type { FastifyInstance, FastifyRequest } from 'fastify';
import type { AuthDependencies } from '../auth/signup.js';
import { requireSession } from '../auth/session.js';
import { withConnection } from '../db/pool.js';
import {
  getReportingStatus,
  getSettings,
  updateReportingSettings,
  resetQuota,
  listQuotaAccounts,
} from '../reporting/quota.js';
import type { SettingsUpdate, QuotaResetInput } from '../reporting/quota.js';
import { HttpProblem } from './problem.js';

function commandKey(request: FastifyRequest): string {
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

export function registerReporting(
  app: FastifyInstance,
  deps: AuthDependencies,
): void {
  // Warga: status pelaporan
  app.get('/api/v1/me/reporting-status', async (request) => {
    const session = await withConnection(deps.pool, (connection) =>
      requireSession(connection, request.headers.authorization),
    );
    if (session.role !== 'CITIZEN') {
      throw new HttpProblem(403, 'FORBIDDEN');
    }
    const status = await getReportingStatus(deps, session.id);
    return envelope(request, status);
  });

  // Admin: baca pengaturan pelaporan
  app.get('/api/v1/admin/reporting-settings', async (request) => {
    const session = await withConnection(deps.pool, (connection) =>
      requireSession(connection, request.headers.authorization),
    );
    if (session.role !== 'ADMIN') {
      throw new HttpProblem(403, 'FORBIDDEN');
    }
    const settings = await withConnection(deps.pool, getSettings);
    return envelope(request, settings);
  });

  // Admin: update pengaturan pelaporan
  app.patch<{ Body: SettingsUpdate }>(
    '/api/v1/admin/reporting-settings',
    {
      schema: {
        body: {
          type: 'object',
          additionalProperties: false,
          minProperties: 1,
          properties: {
            galleryEnabled: { type: 'boolean' },
            quotaCount: { type: 'integer', minimum: 1, maximum: 20 },
            quotaHours: { type: 'integer', minimum: 1, maximum: 24 },
          },
        },
      },
    },
    async (request) => {
      const session = await withConnection(deps.pool, (connection) =>
        requireSession(connection, request.headers.authorization),
      );
      if (session.role !== 'ADMIN') {
        throw new HttpProblem(403, 'FORBIDDEN');
      }
      const expectedVersion = parseIfMatch(request);
      const key = commandKey(request);
      const updated = await updateReportingSettings(
        deps,
        request.body,
        expectedVersion,
        key,
      );
      return envelope(request, updated);
    },
  );

  // Admin: reset kuota
  app.post<{ Body: QuotaResetInput }>(
    '/api/v1/admin/quota-resets',
    {
      schema: {
        body: {
          type: 'object',
          additionalProperties: false,
          required: ['scope'],
          properties: {
            scope: { enum: ['ACCOUNT', 'ALL'] },
            accountId: {
              type: 'string',
              format: 'uuid',
              minLength: 36,
              maxLength: 36,
            },
          },
        },
      },
    },
    async (request) => {
      const session = await withConnection(deps.pool, (connection) =>
        requireSession(connection, request.headers.authorization),
      );
      if (session.role !== 'ADMIN') {
        throw new HttpProblem(403, 'FORBIDDEN');
      }
      const expectedVersion = parseIfMatch(request);
      const key = commandKey(request);
      const settings = await resetQuota(
        deps,
        request.body,
        expectedVersion,
        key,
      );
      return envelope(request, settings);
    },
  );

  // Admin: baca pemakaian kuota akun
  app.get<{ Querystring: { cursor?: string; q?: string } }>(
    '/api/v1/admin/quotas',
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
      if (session.role !== 'ADMIN') {
        throw new HttpProblem(403, 'FORBIDDEN');
      }
      const page = await listQuotaAccounts(deps, session.id, request.query);
      return envelope(request, page);
    },
  );
}
