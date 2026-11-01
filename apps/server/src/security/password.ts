import { randomBytes, scrypt, timingSafeEqual } from 'node:crypto';

let active = 0;

export class HashCapacityError extends Error {
  constructor() {
    super('Kapasitas hashing sementara penuh.');
  }
}

async function derive(password: string, salt: Buffer): Promise<Buffer> {
  if (active >= 2) throw new HashCapacityError();
  active++;
  try {
    return await new Promise<Buffer>((resolve, reject) => {
      scrypt(
        password,
        salt,
        64,
        { N: 131072, r: 8, p: 1, maxmem: 256 * 1024 * 1024 },
        (error, key) => {
          if (error) reject(error);
          else resolve(key);
        },
      );
    });
  } finally {
    active--;
  }
}

export async function hashPassword(password: string) {
  const length = [...password].length;
  if (length < 12 || length > 128)
    throw new Error('Panjang sandi tidak valid.');
  const salt = randomBytes(16);
  return { salt, hash: await derive(password, salt) };
}

export async function verifyPassword(
  password: string,
  salt: Buffer,
  hash: Buffer,
): Promise<boolean> {
  if (salt.length !== 16 || hash.length !== 64)
    throw new Error('Verifier sandi tidak valid.');
  if ([...password].length > 128) return false;
  const candidate = await derive(password, salt);
  try {
    return timingSafeEqual(candidate, hash);
  } finally {
    candidate.fill(0);
  }
}
