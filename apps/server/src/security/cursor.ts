import { createHmac, timingSafeEqual } from 'node:crypto';
import { HttpProblem } from '../http/problem.js';

export interface CursorPayload {
  actorId: string;
  domain: string;
  filter: string;
  lastId: string;
  lastSortValue?: string | number | null;
  expiresAt: number;
}

export function encodeCursor(
  key: Buffer,
  payload: Omit<CursorPayload, 'expiresAt'>,
  ttlMs = 15 * 60 * 1000,
): string {
  if (key.length !== 32) throw new Error('Key cursor harus 32 byte.');
  const fullPayload: CursorPayload = {
    ...payload,
    expiresAt: Date.now() + ttlMs,
  };
  const body = Buffer.from(JSON.stringify(fullPayload), 'utf8').toString(
    'base64url',
  );
  const signature = createHmac('sha256', key)
    .update('cursor-v1\0')
    .update(body)
    .digest('base64url');
  return `${body}.${signature}`;
}

export function decodeCursor(
  key: Buffer,
  cursor: string,
  expectedActorId: string,
  expectedDomain: string,
  expectedFilter: string,
): { lastId: string; lastSortValue?: string | number | null } {
  if (key.length !== 32) throw new Error('Key cursor harus 32 byte.');
  if (typeof cursor !== 'string' || !cursor.includes('.')) {
    throw new HttpProblem(400, 'BAD_REQUEST');
  }
  const [body, signature] = cursor.split('.');
  if (!body || !signature) throw new HttpProblem(400, 'BAD_REQUEST');

  const expectedSig = createHmac('sha256', key)
    .update('cursor-v1\0')
    .update(body)
    .digest();
  let candidateSig: Buffer;
  try {
    candidateSig = Buffer.from(signature, 'base64url');
  } catch {
    throw new HttpProblem(400, 'BAD_REQUEST');
  }

  if (
    candidateSig.length !== 32 ||
    !timingSafeEqual(candidateSig, expectedSig)
  ) {
    throw new HttpProblem(400, 'BAD_REQUEST');
  }

  let parsed: CursorPayload;
  try {
    parsed = JSON.parse(
      Buffer.from(body, 'base64url').toString('utf8'),
    ) as CursorPayload;
  } catch {
    throw new HttpProblem(400, 'BAD_REQUEST');
  }

  if (
    !parsed ||
    typeof parsed !== 'object' ||
    typeof parsed.expiresAt !== 'number' ||
    parsed.expiresAt < Date.now() ||
    parsed.actorId !== expectedActorId ||
    parsed.domain !== expectedDomain ||
    parsed.filter !== expectedFilter ||
    typeof parsed.lastId !== 'string'
  ) {
    throw new HttpProblem(400, 'BAD_REQUEST');
  }

  return parsed.lastSortValue !== undefined
    ? { lastId: parsed.lastId, lastSortValue: parsed.lastSortValue }
    : { lastId: parsed.lastId };
}
