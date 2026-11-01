import { createHmac } from 'node:crypto';

export type JsonValue =
  null | boolean | number | string | JsonValue[] | { [key: string]: JsonValue };

export function canonicalJson(value: JsonValue): string {
  if (
    value === null ||
    typeof value === 'boolean' ||
    typeof value === 'string'
  ) {
    return JSON.stringify(value);
  }
  if (typeof value === 'number') {
    if (!Number.isFinite(value)) throw new Error('Angka JSON harus terbatas.');
    return JSON.stringify(value);
  }
  if (Array.isArray(value))
    return `[${Array.from(value, canonicalJson).join(',')}]`;
  if (
    typeof value !== 'object' ||
    Object.getPrototypeOf(value) !== Object.prototype
  ) {
    throw new Error('Payload harus objek JSON biasa.');
  }
  return `{${Object.keys(value)
    .sort()
    .map((key) => {
      const item = value[key];
      if (item === undefined)
        throw new Error('Field JSON tidak boleh undefined.');
      return `${JSON.stringify(key)}:${canonicalJson(item)}`;
    })
    .join(',')}}`;
}

function digest(key: Buffer, domain: string, value: JsonValue): Buffer {
  if (key.length !== 32) throw new Error('Key jurnal harus 32 byte.');
  return createHmac('sha256', key)
    .update(domain)
    .update('\0')
    .update(canonicalJson(value))
    .digest();
}

export function fingerprint(key: Buffer, payload: JsonValue): Buffer {
  return digest(key, 'command-payload-v1', payload);
}

// Principal berasal dari identitas server; email publik sudah dinormalisasi layanan.
export function actorScope(
  key: Buffer,
  kind: 'account' | 'public',
  principal: string,
): Buffer {
  if (!principal) throw new Error('Principal wajib tersedia.');
  return digest(key, 'command-actor-v1', [kind, principal]);
}
