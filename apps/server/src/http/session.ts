import type { FastifyInstance, FastifyRequest } from 'fastify';
import type { AuthDependencies } from '../auth/signup.js';
import { requireSession, accountView } from '../auth/session.js';
import { revokeSession } from '../auth/revoke.js';
import {
  updateProfile,
  updateCredentials,
  rotateRecoveryCode,
} from '../auth/profile.js';
import type {
  ProfileUpdateInput,
  CredentialsUpdateInput,
} from '../auth/profile.js';
import { withConnection } from '../db/pool.js';
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

export function registerSession(
  app: FastifyInstance,
  deps: AuthDependencies,
): void {
  app.get('/api/v1/me', async (request) =>
    envelope(
      request,
      await withConnection(deps.pool, async (connection) =>
        accountView(
          await requireSession(connection, request.headers.authorization),
        ),
      ),
    ),
  );

  app.patch<{ Body: ProfileUpdateInput }>(
    '/api/v1/me',
    {
      schema: {
        body: {
          type: 'object',
          additionalProperties: false,
          minProperties: 1,
          properties: {
            displayName: { type: 'string', minLength: 2, maxLength: 80 },
            phone: { type: ['string', 'null'], maxLength: 32 },
            address: { type: ['string', 'null'], maxLength: 200 },
            floodAlertEnabled: { type: 'boolean' },
          },
        },
      },
    },
    async (request) => {
      const expectedVersion = parseIfMatch(request);
      const key = commandKey(request);
      const session = await withConnection(deps.pool, (connection) =>
        requireSession(connection, request.headers.authorization),
      );
      const account = await updateProfile(
        deps,
        session.id,
        request.body,
        expectedVersion,
        key,
      );
      return envelope(request, account);
    },
  );

  app.post<{ Body: CredentialsUpdateInput }>(
    '/api/v1/me/credentials',
    {
      schema: {
        body: {
          type: 'object',
          additionalProperties: false,
          required: ['currentPassword'],
          minProperties: 2,
          properties: {
            currentPassword: { type: 'string', minLength: 1, maxLength: 128 },
            email: {
              type: 'string',
              format: 'email',
              minLength: 3,
              maxLength: 254,
            },
            newPassword: { type: 'string', minLength: 12, maxLength: 128 },
          },
        },
      },
    },
    async (request) => {
      const expectedVersion = parseIfMatch(request);
      const key = commandKey(request);
      const session = await withConnection(deps.pool, (connection) =>
        requireSession(connection, request.headers.authorization),
      );
      const ack = await updateCredentials(
        deps,
        session.id,
        request.body,
        expectedVersion,
        key,
      );
      return envelope(request, ack);
    },
  );

  app.post<{ Body: { currentPassword: string } }>(
    '/api/v1/me/recovery-code',
    {
      schema: {
        body: {
          type: 'object',
          additionalProperties: false,
          required: ['currentPassword'],
          properties: {
            currentPassword: { type: 'string', minLength: 1, maxLength: 128 },
          },
        },
      },
    },
    async (request) => {
      const key = commandKey(request);
      const session = await withConnection(deps.pool, (connection) =>
        requireSession(connection, request.headers.authorization),
      );
      const result = await rotateRecoveryCode(
        deps,
        session.id,
        request.body.currentPassword,
        key,
      );
      return envelope(request, result);
    },
  );

  app.post('/api/v1/auth/logout', async (request) =>
    envelope(
      request,
      await revokeSession(deps, commandKey(request), {
        authorization: request.headers.authorization,
      }),
    ),
  );

  app.post<{ Body: { sessionId: string; revokeSecret: string } }>(
    '/api/v1/auth/revoke',
    {
      schema: {
        body: {
          type: 'object',
          additionalProperties: false,
          required: ['sessionId', 'revokeSecret'],
          properties: {
            sessionId: {
              type: 'string',
              format: 'uuid',
              minLength: 36,
              maxLength: 36,
            },
            revokeSecret: { type: 'string', minLength: 43, maxLength: 43 },
          },
        },
      },
    },
    async (request) =>
      envelope(
        request,
        await revokeSession(deps, commandKey(request), request.body),
      ),
  );
}
