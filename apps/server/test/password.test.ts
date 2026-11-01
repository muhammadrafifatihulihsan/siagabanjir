import assert from 'node:assert/strict';
import { test } from 'node:test';
import {
  hashPassword,
  verifyPassword,
  HashCapacityError,
} from '../src/security/password.js';

void test('scrypt memakai salt unik, mempertahankan spasi dan membatasi concurrency', async () => {
  const password = '  sandi sintetis aman  ';
  const first = hashPassword(password);
  const second = hashPassword(password);
  await assert.rejects(hashPassword(password), HashCapacityError);
  const [a, b] = await Promise.all([first, second]);
  assert.equal(a.salt.length, 16);
  assert.equal(a.hash.length, 64);
  assert.notDeepEqual(a.salt, b.salt);
  assert.notDeepEqual(a.hash, b.hash);
  assert.equal(await verifyPassword(password, a.salt, a.hash), true);
  assert.equal(await verifyPassword(password.trim(), a.salt, a.hash), false);
  await assert.rejects(hashPassword('pendek'));
  await assert.rejects(verifyPassword(password, Buffer.alloc(0), a.hash));
});
