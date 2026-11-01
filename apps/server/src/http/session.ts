import type { FastifyInstance, FastifyRequest } from 'fastify';
import type { AuthDependencies } from '../auth/signup.js';
import { requireSession, accountView } from '../auth/session.js';
import { revokeSession } from '../auth/revoke.js';
import { withConnection } from '../db/pool.js';
import { HttpProblem } from './problem.js';

function commandKey(request: FastifyRequest): string {
  const key = request.headers['idempotency-key'];
  if (
    typeof key !== 'string' ||
    !/^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i.test(
      key,
    )
  )
    throw new HttpProblem(400, 'BAD_REQUEST');
  return key.toLowerCase();
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
