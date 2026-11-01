import type { FastifyInstance } from 'fastify';

export function registerMeta(app: FastifyInstance): void {
  app.get(
    '/api/v1/meta',
    {
      schema: {
        querystring: {
          type: 'object',
          properties: {},
          additionalProperties: false,
        },
        response: {
          200: {
            type: 'object',
            additionalProperties: false,
            required: ['data', 'requestId', 'serverTime'],
            properties: {
              data: {
                type: 'object',
                additionalProperties: false,
                required: ['apiVersion', 'privacyVersion', 'serverTime'],
                properties: {
                  apiVersion: { type: 'string', const: 'v1' },
                  privacyVersion: { type: 'string', const: 'demo-v1' },
                  serverTime: { type: 'string', format: 'date-time' },
                },
              },
              requestId: { type: 'string', format: 'uuid' },
              serverTime: { type: 'string', format: 'date-time' },
            },
          },
        },
      },
    },
    (request) => {
      const serverTime = new Date().toISOString();
      return {
        data: { apiVersion: 'v1', privacyVersion: 'demo-v1', serverTime },
        requestId: request.id,
        serverTime,
      };
    },
  );
}
