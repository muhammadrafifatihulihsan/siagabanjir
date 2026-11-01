import {
  createHash,
  createHmac,
  randomBytes,
  timingSafeEqual,
} from 'node:crypto';

export function generateSessionSecrets() {
  const accessToken = randomBytes(32).toString('base64url');
  const revokeSecret = randomBytes(32).toString('base64url');
  return { accessToken, revokeSecret };
}

export function tokenDigest(token: string): Buffer {
  if (
    !/^[A-Za-z0-9_-]{43}$/.test(token) ||
    Buffer.from(token, 'base64url').toString('base64url') !== token
  ) {
    throw new Error('Format token tidak valid.');
  }
  return createHash('sha256').update(token, 'utf8').digest();
}

export function generateRecoveryCode(): string {
  const alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';
  let bits = 0;
  let accumulator = 0;
  let output = '';
  for (const byte of randomBytes(20)) {
    accumulator = (accumulator << 8) | byte;
    bits += 8;
    while (bits >= 5) {
      bits -= 5;
      output += alphabet[(accumulator >>> bits) & 31];
    }
    accumulator &= (1 << bits) - 1;
  }
  return output;
}

export function recoveryVerifier(code: string, key: Buffer): Buffer {
  if (!/^[A-Z2-7]{32}$/.test(code) || key.length !== 32) {
    throw new Error('Format kode/key pemulihan tidak valid.');
  }
  return createHmac('sha256', key)
    .update('recovery-v1\0')
    .update(code)
    .digest();
}

export function matchesVerifier(candidate: Buffer, stored: Buffer): boolean {
  return (
    candidate.length === 32 &&
    stored.length === 32 &&
    timingSafeEqual(candidate, stored)
  );
}
