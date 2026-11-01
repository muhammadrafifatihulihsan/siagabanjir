import type { FastifyInstance } from 'fastify';
import type { AuthDependencies } from '../auth/signup.js';
import { resetPassword } from '../auth/reset-password.js';
import type { ResetPasswordInput } from '../auth/reset-password.js';
import { HttpProblem } from './problem.js';

export function registerResetPassword(
  app: FastifyInstance,
  deps: AuthDependencies,
): void {
  app.post<{ Body: ResetPasswordInput }>(
    '/api/v1/auth/reset-password',
    {
      schema: {
        body: {
          type: 'object',
          additionalProperties: false,
          required: ['email', 'code', 'newPassword'],
          properties: {
            email: {
              type: 'string',
              format: 'email',
              minLength: 3,
              maxLength: 254,
            },
            code: { type: 'string', minLength: 32, maxLength: 40 },
            newPassword: { type: 'string', minLength: 12, maxLength: 128 },
          },
        },
      },
      preValidation: (request, _reply, done) => {
        const key = request.headers['idempotency-key'];
        if (
          typeof key !== 'string' ||
          !/^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i.test(
            key,
          )
        ) {
          done(new HttpProblem(400, 'BAD_REQUEST'));
          return;
        }
        if (request.body && typeof request.body.email === 'string') {
          request.body.email = request.body.email.trim();
        }
        done();
      },
    },
    async (request) => ({
      data: await resetPassword(
        deps,
        request.body,
        request.headers['idempotency-key'] as string,
        request.ip,
      ),
      requestId: request.id,
      serverTime: new Date().toISOString(),
    }),
  );
}
