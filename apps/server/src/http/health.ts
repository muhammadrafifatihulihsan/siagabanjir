/**
 * HTTP Handler untuk Health Check SiagaBanjir
 * Menyediakan endpoint /health dan /api/v1/health untuk memantau status aplikasi,
 * konektivitas database MySQL, dan konsistensi server.
 */
import type { FastifyInstance, FastifyReply, FastifyRequest } from 'fastify';
import type { AuthDependencies } from '../auth/signup.js';
import { checkHealth } from '../meta/health.js';

export function registerHealth(
  app: FastifyInstance,
  deps?: AuthDependencies,
): void {
  const handler = async (request: FastifyRequest, reply: FastifyReply) => {
    const result = await checkHealth(deps?.pool);
    const statusCode = result.status === 'healthy' ? 200 : 503;

    return reply.status(statusCode).send({
      data: result,
      requestId: request.id,
      serverTime: new Date().toISOString(),
    });
  };

  // Endpoint root health check untuk load balancer / docker / kubernetes probe
  app.get('/health', handler);

  // Endpoint versi API terstruktur
  app.get('/api/v1/health', handler);
}
