import assert from 'node:assert/strict';
import { test } from 'node:test';
import { mkdtemp, rm, writeFile } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { pathToFileURL } from 'node:url';
import { readDatabaseConfig } from '../src/db/config.js';
import { loadMigrations, validateHistory } from '../src/db/migrations.js';

const env = {
  NODE_ENV: 'test',
  DB_HOST: '127.0.0.1',
  DB_NAME: 'siagabanjirtest',
  DB_USER: 'sb_test_app',
  DB_PASSWORD: 'synthetic-password',
  MIGRATION_DB_USER: 'sb_test_migrate',
  MIGRATION_DB_PASSWORD: 'synthetic-migration',
};

void test('migrasi berhenti saat checksum berubah, terputus, hilang atau tersisip', () => {
  const migrations = [
    { name: '001_guard.sql', checksum: 'one' },
    { name: '002_seed.sql', checksum: 'two' },
  ];
  const first = { ...migrations[0]!, state: 'applied' };
  assert.doesNotThrow(() => validateHistory(migrations, []));
  assert.doesNotThrow(() => validateHistory(migrations, [first]));
  for (const history of [
    [{ ...first, checksum: 'edited' }],
    [{ ...first, state: 'applying' }],
    [{ name: '002_seed.sql', checksum: 'two', state: 'applied' }],
    [first, { name: '003_unknown.sql', checksum: 'three', state: 'applied' }],
  ])
    assert.throws(() => validateHistory(migrations, history));
});

void test('konfigurasi memisahkan lingkungan/peran dan menolak root atau target lain', () => {
  assert.equal(readDatabaseConfig(env, 'app').user, 'sb_test_app');
  assert.equal(readDatabaseConfig(env, 'migrate').user, 'sb_test_migrate');
  for (const invalid of [
    { NODE_ENV: undefined },
    { NODE_ENV: 'production' },
    { DB_NAME: 'siagabanjirdev' },
    { DB_USER: 'root' },
    { DB_HOST: '192.168.1.1' },
    { DB_PASSWORD: '' },
    { DB_PORT: '0' },
    { DB_PORT: '65536' },
    { DB_PORT: '3306x' },
  ]) {
    assert.throws(() => readDatabaseConfig({ ...env, ...invalid }, 'app'));
  }
  assert.throws(() =>
    readDatabaseConfig({ ...env, MIGRATION_DB_USER: 'sb_test_app' }, 'migrate'),
  );
});

void test('checksum migrasi stabil lintas EOL; urutan/berkas asing ditolak', async (t) => {
  const directory = await mkdtemp(join(tmpdir(), 'siagabanjir-migration-'));
  t.after(() => rm(directory, { recursive: true, force: true }));
  const url = pathToFileURL(directory + '/');
  const file = join(directory, '001_guard.sql');
  await writeFile(file, 'SELECT\r\n1\r\n');
  const windows = await loadMigrations(url);
  await writeFile(file, 'SELECT\n1\n');
  assert.equal((await loadMigrations(url))[0]?.checksum, windows[0]?.checksum);
  await writeFile(join(directory, '003_gap.sql'), 'SELECT 3');
  await assert.rejects(loadMigrations(url));
});
