import type { FastifyInstance } from 'fastify';
import type { AuthDependencies } from '../auth/signup.js';
import { login } from '../auth/login.js';
import type { LoginInput } from '../auth/login.js';
import { HttpProblem } from './problem.js';

export function registerLogin(
  app: FastifyInstance,
  deps: AuthDependencies,
): void {
  app.post<{ Body: LoginInput }>(
    '/api/v1/auth/login',
    {
      schema: {
        body: {
          type: 'object',
          additionalProperties: false,
          required: ['email', 'password', 'client'],
          properties: {
            email: { type: 'string', format: 'email', maxLength: 254 },
            password: { type: 'string', minLength: 1, maxLength: 128 },
            client: { enum: ['ANDROID', 'ADMIN_WEB'] },
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
        if (request.body && typeof request.body.email === 'string')
          request.body.email = request.body.email.trim();
        done();
      },
    },
    async (request) => ({
      data: await login(
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
