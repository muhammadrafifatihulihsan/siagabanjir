import type { FastifyInstance } from 'fastify';
import { signup } from '../auth/signup.js';
import type { AuthDependencies, SignupInput } from '../auth/signup.js';
import { HttpProblem } from './problem.js';

export function registerSignup(
  app: FastifyInstance,
  deps: AuthDependencies,
): void {
  app.post<{ Body: SignupInput }>(
    '/api/v1/auth/signup',
    {
      schema: {
        body: {
          type: 'object',
          additionalProperties: false,
          required: ['displayName', 'email', 'password'],
          properties: {
            displayName: { type: 'string', minLength: 2, maxLength: 80 },
            email: {
              type: 'string',
              minLength: 3,
              maxLength: 254,
              format: 'email',
            },
            password: { type: 'string', minLength: 12, maxLength: 128 },
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
    async (request, reply) => {
      const data = await signup(
        deps,
        request.body,
        request.headers['idempotency-key'] as string,
      );
      return reply.code(201).send({
        data,
        requestId: request.id,
        serverTime: new Date().toISOString(),
      });
    },
  );
}
