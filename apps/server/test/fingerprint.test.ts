import assert from 'node:assert/strict';
import { test } from 'node:test';
import {
  actorScope,
  canonicalJson,
  fingerprint,
} from '../src/security/fingerprint.js';

void test('JSON kanonik mengurutkan key termasuk angka, menjaga Unicode/array dan menolak angka invalid', () => {
  assert.equal(
    canonicalJson({ z: -0, a: ['banjir 🌊', { '2': 2, '10': 10 }] }),
    '{"a":["banjir 🌊",{"10":10,"2":2}],"z":0}',
  );
  assert.throws(() => canonicalJson(NaN));
  assert.throws(() => canonicalJson(Infinity));
  const key = Buffer.alloc(32, 1);
  assert.deepEqual(
    fingerprint(key, { b: 2, a: 1 }),
    fingerprint(key, { a: 1, b: 2 }),
  );
  assert.notDeepEqual(fingerprint(key, [1, 2]), fingerprint(key, [2, 1]));
  assert.notDeepEqual(
    actorScope(key, 'account', 'same'),
    actorScope(key, 'public', 'same'),
  );
  assert.notDeepEqual(
    actorScope(key, 'public', 'one'),
    actorScope(key, 'public', 'two'),
  );
  assert.throws(() => fingerprint(Buffer.alloc(0), {}));
});
