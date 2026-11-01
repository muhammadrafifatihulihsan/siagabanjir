import assert from 'node:assert/strict';
import { test } from 'node:test';
import {
  generateSessionSecrets,
  tokenDigest,
  generateRecoveryCode,
  recoveryVerifier,
  matchesVerifier,
} from '../src/security/secrets.js';
import { readSecurityKeys } from '../src/security/keys.js';

void test('token dan recovery memenuhi format, verifier menolak rahasia/key berbeda', () => {
  const { accessToken, revokeSecret } = generateSessionSecrets();
  assert.notEqual(accessToken, revokeSecret);
  assert.equal(Buffer.from(accessToken, 'base64url').length, 32);
  assert.equal(tokenDigest(accessToken).length, 32);
  assert.equal(
    matchesVerifier(tokenDigest(accessToken), tokenDigest(revokeSecret)),
    false,
  );
  assert.throws(() => tokenDigest(accessToken + '='));
  const code = generateRecoveryCode();
  assert.match(code, /^[A-Z2-7]{32}$/);
  const key = Buffer.alloc(32, 1);
  const verifier = recoveryVerifier(code, key);
  assert.ok(matchesVerifier(verifier, recoveryVerifier(code, key)));
  assert.ok(
    !matchesVerifier(verifier, recoveryVerifier(code, Buffer.alloc(32, 2))),
  );
  assert.ok(!matchesVerifier(verifier, Buffer.alloc(0)));
  assert.throws(() => recoveryVerifier(code.toLowerCase(), key));
});

void test('key config menolak kosong, malformed dan key tujuan yang sama', () => {
  const env = {
    RECOVERY_HMAC_KEY: '01'.repeat(32),
    JOURNAL_HMAC_KEY: '02'.repeat(32),
    CURSOR_HMAC_KEY: '03'.repeat(32),
  };
  assert.equal(readSecurityKeys(env).recovery.length, 32);
  assert.throws(() => readSecurityKeys({}));
  assert.throws(() =>
    readSecurityKeys({ ...env, RECOVERY_HMAC_KEY: 'invalid' }),
  );
  assert.throws(() =>
    readSecurityKeys({ ...env, JOURNAL_HMAC_KEY: env.RECOVERY_HMAC_KEY }),
  );
});
