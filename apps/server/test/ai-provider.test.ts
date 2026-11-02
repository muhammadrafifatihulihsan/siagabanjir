import assert from 'node:assert/strict';
import { test } from 'node:test';
import { readAiConfig } from '../src/ai/config.js';
import { callDeepSeek } from '../src/ai/provider.js';

const config = readAiConfig({ DEEPSEEKAPI: 'synthetic-test-key' });
const images = [{ mime: 'image/png' as const, data: Buffer.from('synthetic') }];

void test('AI: key lama didukung, konfigurasi hilang ditolak tanpa membocorkan nilai', () => {
  assert.equal(config.model, 'deepseek-flash');
  assert.throws(() => readAiConfig({}), /DEEPSEEK_API_KEY/);
  assert.throws(
    () => readAiConfig({ DEEPSEEKAPI: 'secret invalid' }),
    (error: unknown) =>
      error instanceof Error && !error.message.includes('secret'),
  );
});

void test('AI: request inline, JSON valid dan tidak mengikuti redirect', async () => {
  const request: typeof fetch = (_url, init) => {
    assert.equal(init?.redirect, 'error');
    assert.equal(typeof init?.body, 'string');
    assert.ok((init?.body as string).includes('data:image/png;base64,'));
    return Promise.resolve(
      Response.json({
        choices: [
          {
            finish_reason: 'stop',
            message: { content: '{"documentType":"OTHER"}' },
          },
        ],
      }),
    );
  };
  assert.deepEqual(
    await callDeepSeek(config, 'Return JSON', images, 2048, request),
    { documentType: 'OTHER' },
  );
});

void test('AI: output terpotong, JSON rusak, auth dan retryable dibedakan', async () => {
  for (const [status, payload, code, retryable] of [
    [
      200,
      { choices: [{ finish_reason: 'length', message: { content: '{}' } }] },
      'INVALID_OUTPUT',
      false,
    ],
    [
      200,
      { choices: [{ finish_reason: 'stop', message: { content: 'invalid' } }] },
      'INVALID_OUTPUT',
      false,
    ],
    [401, {}, 'PROVIDER_FAILED', false],
    [429, {}, 'PROVIDER_FAILED', true],
    [503, {}, 'PROVIDER_FAILED', true],
  ] as const) {
    const request: typeof fetch = () =>
      Promise.resolve(Response.json(payload, { status }));
    await assert.rejects(callDeepSeek(config, 'JSON', images, 2048, request), {
      code,
      retryable,
    });
  }
});
