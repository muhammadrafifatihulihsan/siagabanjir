import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { Writable } from 'node:stream';
import { test } from 'node:test';
import { Ajv2020 } from 'ajv/dist/2020.js';
import addFormats from 'ajv-formats';
import { buildApp } from '../src/app.js';
import { readConfig } from '../src/config.js';

const config = readConfig({ NODE_ENV: 'test', LOG_LEVEL: 'silent' });
const contract = JSON.parse(
  readFileSync(new URL('../../../docs/openapi.json', import.meta.url), 'utf8'),
) as { components: { schemas: Record<string, object> } };
const ajv = new Ajv2020({ strict: false });
addFormats.default(ajv);
ajv.addSchema({ $id: 'contract', components: contract.components });
const validateMeta = ajv.compile({
  $ref: 'contract#/components/schemas/getMetaResponse',
});
const validateError = ajv.compile({
  $ref: 'contract#/components/schemas/Error',
});

void test('metadata mengikuti OpenAPI dan requestId tidak dapat dipilih klien', async (t) => {
  const app = buildApp(config);
  t.after(() => app.close());
  const response = await app.inject({
    url: '/api/v1/meta',
    headers: { 'request-id': 'forged', 'x-request-id': 'forged' },
  });
  const body: unknown = response.json();
  assert.equal(response.statusCode, 200);
  assert.ok(validateMeta(body), JSON.stringify(validateMeta.errors));
  assert.equal(response.headers['cache-control'], 'no-store');
  assert.equal(response.headers['x-content-type-options'], 'nosniff');
  assert.notEqual(response.body, (await app.inject('/api/v1/meta')).body);
  assert.ok(!response.body.includes('forged'));
});

void test('error input, route, ukuran, format dan exception tidak membocorkan rahasia', async (t) => {
  const records: string[] = [];
  const stream = new Writable({
    write(chunk: Buffer, _encoding, callback) {
      records.push(chunk.toString());
      callback();
    },
  });
  const app = buildApp({ ...config, logLevel: 'info' }, stream);
  t.after(() => app.close());
  app.post(
    '/test/body',
    {
      schema: {
        body: {
          type: 'object',
          required: ['name'],
          properties: { name: { type: 'string' } },
          additionalProperties: false,
        },
      },
    },
    () => ({ ok: true }),
  );
  app.get('/test/fail', () => {
    throw new Error('private-sentinel database-password');
  });
  const cases = [
    {
      method: 'GET' as const,
      url: '/missing/private-sentinel?token=private-sentinel',
      expected: 404,
    },
    {
      method: 'GET' as const,
      url: '/api/v1/meta?unknown=private-sentinel',
      expected: 400,
    },
    { method: 'GET' as const, url: '/test/fail', expected: 500 },
    {
      method: 'POST' as const,
      url: '/test/body',
      payload: '{"name":"private-sentinel",',
      expected: 400,
    },
    {
      method: 'POST' as const,
      url: '/test/body',
      payload: JSON.stringify({ name: 'private-sentinel', extra: true }),
      expected: 422,
    },
    {
      method: 'POST' as const,
      url: '/test/body',
      payload: JSON.stringify({ name: 'x'.repeat(512 * 1024) }),
      expected: 413,
    },
  ];
  for (const { expected, ...request } of cases) {
    const response = await app.inject({
      ...request,
      headers: {
        'content-type': 'application/json',
        authorization: 'Bearer private-sentinel',
        cookie: 'private-sentinel',
      },
    });
    assert.equal(response.statusCode, expected, response.body);
    assert.ok(
      validateError(response.json()),
      JSON.stringify(validateError.errors),
    );
    assert.ok(!response.body.includes('private-sentinel'));
  }
  const unsupported = await app.inject({
    method: 'POST',
    url: '/test/body',
    headers: { 'content-type': 'application/xml' },
    payload: '<secret>private-sentinel</secret>',
  });
  assert.equal(unsupported.statusCode, 415);
  assert.ok(validateError(unsupported.json()));
  assert.ok(!records.join('').includes('private-sentinel'));
  assert.ok(records.join('').includes('request_failed'));
});

void test('server membuka socket nyata dan menutupnya tanpa resource tertinggal', async () => {
  const app = buildApp(config);
  try {
    const address = await app.listen({ host: '127.0.0.1', port: 0 });
    const response = await fetch(`${address}/api/v1/meta`);
    assert.equal(response.status, 200);
    assert.ok(validateMeta(await response.json()));
  } finally {
    await app.close();
  }
  assert.equal(app.server.listening, false);
});
