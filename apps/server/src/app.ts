import { randomUUID } from 'node:crypto';
import Fastify, { LogController } from 'fastify';
import type { Writable } from 'node:stream';
import type { ServerConfig } from './config.js';
import { registerErrors } from './http/errors.js';
import { registerMeta } from './http/meta.js';
import { registerHealth } from './http/health.js';
import { registerDocs } from './http/docs.js';
import { registerSignup } from './http/signup.js';
import { registerLogin } from './http/login.js';
import { registerResetPassword } from './http/reset-password.js';
import { registerSession } from './http/session.js';
import { registerReporting } from './http/reporting.js';
import { registerSubmissions } from './http/submissions.js';
import { registerVault } from './http/vault.js';
import { registerAdminReporting } from './http/admin-reporting.js';
import { registerCms } from './http/cms.js';
import { registerMessages } from './http/messages.js';
import type { AuthDependencies } from './auth/signup.js';

export function buildApp(
  config: ServerConfig,
  stream?: Writable,
  auth?: AuthDependencies,
) {
  const app = Fastify({
    logger: {
      level: config.logLevel,
      ...(stream ? { stream } : {}),
      serializers: {
        req: () => ({}),
        res: () => ({}),
        err: () => ({
          type: 'Error',
          message: 'Detail disembunyikan',
          stack: '',
        }),
      },
    },
    logController: new LogController({ disableRequestLogging: true }),
    requestIdHeader: false,
    genReqId: () => randomUUID(),
    trustProxy: false,
    bodyLimit: 512 * 1024,
    requestTimeout: 30_000,
    connectionTimeout: 10_000,
    forceCloseConnections: 'idle',
    ajv: {
      customOptions: {
        removeAdditional: false,
        coerceTypes: false,
        useDefaults: false,
        allErrors: false,
      },
    },
  });
  app.addHook('onRequest', async (request, reply) => {
    reply.header('Cache-Control', 'no-store');
    reply.header('X-Content-Type-Options', 'nosniff');
    reply.header('Access-Control-Allow-Origin', '*');
    reply.header(
      'Access-Control-Allow-Headers',
      'Content-Type, Authorization, Idempotency-Key, If-Match, Accept',
    );
    reply.header(
      'Access-Control-Allow-Methods',
      'GET, POST, PUT, PATCH, DELETE, OPTIONS',
    );
    if (request.method === 'OPTIONS') {
      reply.header('Access-Control-Max-Age', '86400');
      return reply.status(204).send();
    }
  });
  app.addHook('onResponse', async (request, reply) => {
    request.log.info({
      event: 'request_completed',
      statusCode: reply.statusCode,
    });
  });
  registerErrors(app);
  registerMeta(app);
  registerHealth(app, auth);
  registerDocs(app);
  if (auth) registerSignup(app, auth);
  if (auth) registerLogin(app, auth);
  if (auth) registerResetPassword(app, auth);
  if (auth) registerSession(app, auth);
  if (auth) registerReporting(app, auth);
  if (auth) registerSubmissions(app, auth);
  if (auth) registerVault(app, auth);
  if (auth) registerAdminReporting(app, auth);
  if (auth) registerCms(app, auth);
  if (auth) registerMessages(app, auth);
  return app;
}
