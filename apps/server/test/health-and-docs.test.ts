import assert from 'node:assert/strict';
import { test } from 'node:test';
import { buildApp } from '../src/app.js';
import { readConfig } from '../src/config.js';

void test('health check mengembalikan status UP dan metrik server', async () => {
  const app = buildApp(readConfig({ NODE_ENV: 'test', LOG_LEVEL: 'silent' }));

  const res = await app.inject({
    method: 'GET',
    url: '/health',
  });

  assert.equal(res.statusCode, 200);
  const body = res.json<{
    data: {
      status: string;
      server: { status: string; uptimeSeconds: number; nodeVersion: string };
    };
  }>();

  assert.equal(body.data.status, 'healthy');
  assert.equal(body.data.server.status, 'UP');
  assert.ok(body.data.server.uptimeSeconds >= 0);
  assert.ok(body.data.server.nodeVersion.startsWith('v'));

  const v1Res = await app.inject({
    method: 'GET',
    url: '/api/v1/health',
  });
  assert.equal(v1Res.statusCode, 200);

  await app.close();
});

void test('docs menyajikan Swagger UI HTML dan spesifikasi OpenAPI', async () => {
  const app = buildApp(readConfig({ NODE_ENV: 'test', LOG_LEVEL: 'silent' }));

  // 1. Uji Swagger UI HTML
  const docsRes = await app.inject({
    method: 'GET',
    url: '/docs',
  });
  assert.equal(docsRes.statusCode, 200);
  assert.ok(docsRes.headers['content-type']?.includes('text/html'));
  assert.ok(docsRes.body.includes('SiagaBanjir API Testing Dashboard'));
  assert.ok(docsRes.body.includes('SwaggerUIBundle'));

  const docuRes = await app.inject({
    method: 'GET',
    url: '/documentation',
  });
  assert.equal(docuRes.statusCode, 200);

  // 2. Uji OpenAPI JSON
  const specRes = await app.inject({
    method: 'GET',
    url: '/api/v1/openapi.json',
  });
  assert.equal(specRes.statusCode, 200);
  assert.ok(specRes.headers['content-type']?.includes('application/json'));
  const spec = specRes.json<{ openapi: string; info: { title: string } }>();
  assert.equal(spec.openapi, '3.1.0');
  assert.equal(spec.info.title, 'SiagaBanjir demo API');

  await app.close();
});
