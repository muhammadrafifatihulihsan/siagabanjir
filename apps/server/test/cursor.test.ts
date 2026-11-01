import assert from 'node:assert/strict';
import { randomBytes } from 'node:crypto';
import { test } from 'node:test';
import { encodeCursor, decodeCursor } from '../src/security/cursor.js';
import { HttpProblem } from '../src/http/problem.js';

void test('cursor menghasilkan token ter-HMAC dan menolak manipulasi, kedaluwarsa atau domain salah', () => {
  const key = randomBytes(32);
  const actorId = 'user-123';
  const domain = 'quotas';
  const filter = 'q=';
  const lastId = 'account-xyz';

  const cursor = encodeCursor(key, {
    actorId,
    domain,
    filter,
    lastId,
  });

  const decoded = decodeCursor(key, cursor, actorId, domain, filter);
  assert.equal(decoded.lastId, lastId);

  // Tampered signature
  assert.throws(
    () =>
      decodeCursor(key, cursor.slice(0, -3) + 'abc', actorId, domain, filter),
    (err: unknown) => err instanceof HttpProblem && err.status === 400,
  );

  // Wrong actor
  assert.throws(
    () => decodeCursor(key, cursor, 'other-actor', domain, filter),
    (err: unknown) => err instanceof HttpProblem && err.status === 400,
  );

  // Wrong domain
  assert.throws(
    () => decodeCursor(key, cursor, actorId, 'other-domain', filter),
    (err: unknown) => err instanceof HttpProblem && err.status === 400,
  );

  // Expired cursor
  const expiredCursor = encodeCursor(
    key,
    { actorId, domain, filter, lastId },
    -1000,
  );
  assert.throws(
    () => decodeCursor(key, expiredCursor, actorId, domain, filter),
    (err: unknown) => err instanceof HttpProblem && err.status === 400,
  );

  // Malformed cursor
  assert.throws(
    () => decodeCursor(key, 'not-a-cursor', actorId, domain, filter),
    (err: unknown) => err instanceof HttpProblem && err.status === 400,
  );
});
