/**
 * Swagger UI & OpenAPI Specification Handler SiagaBanjir
 * Menyediakan endpoint dokumentasi interaktif untuk pengujian API secara langsung
 * melalui peramban web (/docs, /documentation, /api/docs) dan penyajian spesifikasi
 * OpenAPI kanonik (/api/v1/openapi.json, /openapi.json).
 */
import { readFile } from 'node:fs/promises';
import { resolve } from 'node:path';
import type { FastifyInstance, FastifyReply, FastifyRequest } from 'fastify';

let cachedSpec: string | null = null;

async function getOpenApiSpec(): Promise<string> {
  if (cachedSpec) return cachedSpec;
  const candidates = [
    resolve(process.cwd(), 'docs', 'openapi.json'),
    resolve(process.cwd(), '..', '..', 'docs', 'openapi.json'),
    resolve(
      import.meta.dirname,
      '..',
      '..',
      '..',
      '..',
      'docs',
      'openapi.json',
    ),
  ];

  for (const candidate of candidates) {
    try {
      cachedSpec = await readFile(candidate, 'utf8');
      return cachedSpec;
    } catch {
      // Coba path berikutnya jika kandidat pertama tidak ditemukan
    }
  }
  return JSON.stringify({
    openapi: '3.1.0',
    info: { title: 'SiagaBanjir API', version: '1.0.0' },
    paths: {},
  });
}

function renderSwaggerUiHtml(): string {
  return `<!DOCTYPE html>
<html lang="id">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>SiagaBanjir API Documentation & Interactive Testing</title>
  <link rel="stylesheet" href="https://unpkg.com/swagger-ui-dist@5.11.0/swagger-ui.css" />
  <link rel="icon" type="image/svg+xml" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='%230284c7'><path d='M12 2L2 7l10 5 10-5-10-5zm0 9l-8-4 8-4 8 4-8 4zm0 4l-10-5 10-5 10 5-10 5z'/></svg>">
  <style>
    body { margin: 0; padding: 0; background-color: #f8fafc; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; }
    .topbar { display: none !important; }
    .siaga-header { background: linear-gradient(135deg, #0284c7 0%, #0369a1 100%); color: white; padding: 20px 32px; box-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1); }
    .siaga-header h1 { margin: 0; font-size: 22px; font-weight: 700; letter-spacing: -0.025em; display: flex; align-items: center; gap: 10px; }
    .siaga-header p { margin: 6px 0 0; font-size: 13px; opacity: 0.9; }
    .swagger-ui .info { margin: 24px 0 !important; }
    .swagger-ui .info .title { font-size: 28px !important; color: #0f172a !important; }
    .swagger-ui .scheme-container { background: #ffffff !important; box-shadow: 0 1px 3px 0 rgb(0 0 0 / 0.05); padding: 16px 0 !important; }
    .swagger-ui .btn.authorize { background-color: #0284c7; color: white; border-color: #0284c7; }
    .swagger-ui .btn.authorize svg { fill: white; }
  </style>
</head>
<body>
  <div class="siaga-header">
    <h1>🌊 SiagaBanjir API Testing Dashboard</h1>
    <p>Dokumentasi resmi dan lingkungan pengujian interaktif untuk 72 endpoint Fastify SiagaBanjir.</p>
  </div>
  <div id="swagger-ui"></div>
  <script src="https://unpkg.com/swagger-ui-dist@5.11.0/swagger-ui-bundle.js"></script>
  <script src="https://unpkg.com/swagger-ui-dist@5.11.0/swagger-ui-standalone-preset.js"></script>
  <script>
    window.onload = function() {
      window.ui = SwaggerUIBundle({
        url: "/api/v1/openapi.json",
        dom_id: '#swagger-ui',
        deepLinking: true,
        presets: [
          SwaggerUIBundle.presets.apis,
          SwaggerUIStandalonePreset
        ],
        layout: "BaseLayout",
        defaultModelsExpandDepth: 1,
        defaultModelExpandDepth: 1,
        docExpansion: "list",
        filter: true,
        showExtensions: true,
        showCommonExtensions: true
      });
    };
  </script>
</body>
</html>`;
}

export function registerDocs(app: FastifyInstance): void {
  // 1. Endpoint OpenAPI JSON Specification
  const specHandler = async (_request: FastifyRequest, reply: FastifyReply) => {
    const spec = await getOpenApiSpec();
    reply.header('content-type', 'application/json; charset=utf-8');
    return reply.send(spec);
  };
  app.get('/api/v1/openapi.json', specHandler);
  app.get('/openapi.json', specHandler);

  // 2. Endpoint Swagger UI Interactive Testing
  const uiHandler = async (_request: FastifyRequest, reply: FastifyReply) => {
    const html = renderSwaggerUiHtml();
    reply.header('content-type', 'text/html; charset=utf-8');
    return reply.send(html);
  };
  app.get('/docs', uiHandler);
  app.get('/documentation', uiHandler);
  app.get('/api/docs', uiHandler);
}
