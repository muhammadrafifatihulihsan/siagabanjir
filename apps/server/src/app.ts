import { randomUUID } from 'node:crypto';
import Fastify, { LogController } from 'fastify';
import type { Writable } from 'node:stream';
import type { ServerConfig } from './config.js';
import { registerErrors } from './http/errors.js';
import { registerMeta } from './http/meta.js';

export function buildApp(config: ServerConfig, stream?: Writable) {
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
  app.addHook('onRequest', async (_request, reply) => {
    reply.header('Cache-Control', 'no-store');
    reply.header('X-Content-Type-Options', 'nosniff');
  });
  app.addHook('onResponse', async (request, reply) => {
    request.log.info({
      event: 'request_completed',
      statusCode: reply.statusCode,
    });
  });
  registerErrors(app);
  registerMeta(app);
  return app;
}
