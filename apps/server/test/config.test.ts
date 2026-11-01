import assert from 'node:assert/strict';
import { test } from 'node:test';
import { readConfig } from '../src/config.js';

void test('konfigurasi default hanya membuka loopback lokal', () => {
  assert.deepEqual(readConfig({}), {
    environment: 'development',
    host: '127.0.0.1',
    port: 3000,
    logLevel: 'info',
  });
  assert.equal(
    readConfig({ HOST: '::1', PORT: '65535', NODE_ENV: 'test' }).port,
    65535,
  );
});

void test('konfigurasi invalid ditolak tanpa mengungkap nilainya', () => {
  for (const port of ['0', '-1', '65536', '3000x', '3e3', '3.5', '', ' 3000']) {
    assert.throws(() => readConfig({ PORT: port }), /PORT wajib/);
  }
  assert.throws(() => readConfig({ HOST: '0.0.0.0' }), /HOST wajib/);
  assert.throws(
    () => readConfig({ NODE_ENV: 'production' }),
    /hanya untuk lokal/,
  );
  assert.throws(
    () => readConfig({ LOG_LEVEL: 'secret-value' }),
    (error: unknown) =>
      error instanceof Error && !error.message.includes('secret-value'),
  );
});
