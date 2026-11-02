import assert from 'node:assert/strict';
import { randomBytes, randomUUID } from 'node:crypto';
import { execFile } from 'node:child_process';
import { promisify } from 'node:util';
import { unlink } from 'node:fs/promises';
import { join } from 'node:path';
import { readAiConfig } from '../src/ai/config.js';
import { enqueue, formatJob, type JobRow } from '../src/ai/jobs.js';
import { claimJob } from '../src/ai/queue.js';
import { processJob } from '../src/ai/process.js';
import { createDatabasePool, withBusinessTransaction } from '../src/db/pool.js';
import { readDatabaseConfig } from '../src/db/config.js';
import { getStorageDirectory, saveMediaBlob } from '../src/storage/vault.js';

// Opt-in: menggunakan kredit provider dan hanya database test/data sintetis.
assert.equal(process.env.NODE_ENV, 'test');
const config = readAiConfig(process.env);
const pool = createDatabasePool(readDatabaseConfig(process.env, 'app'));
const owner = randomUUID(),
  upload = randomUUID(),
  document = randomUUID();
let blob: string | undefined;
try {
  const { stdout } = await promisify(execFile)(
    process.env.FFMPEG_PATH ?? 'ffmpeg',
    [
      '-v',
      'error',
      '-f',
      'lavfi',
      '-i',
      'color=c=blue:s=256x256',
      '-frames:v',
      '1',
      '-f',
      'image2pipe',
      '-vcodec',
      'png',
      'pipe:1',
    ],
    { encoding: 'buffer', windowsHide: true },
  );
  const stored = await saveMediaBlob(upload, stdout);
  blob = stored.blobKey;
  const queued = await withBusinessTransaction(pool, async (c) => {
    await c.execute(
      'INSERT INTO accounts (id,email_normalized,display_name,password_hash,password_salt,created_at) VALUES (?,?,?,?,?,UTC_TIMESTAMP(3))',
      [
        owner,
        `${owner}@example.invalid`,
        'Uji sintetis provider',
        randomBytes(64),
        randomBytes(16),
      ],
    );
    await c.execute(
      "INSERT INTO uploads(id,owner_id,purpose,origin,blob_key,digest,mime,bytes,state,expires_at,created_at,updated_at) VALUES (?,?,'DOCUMENT','FILE',?,?,'image/png',?,'ATTACHED',UTC_TIMESTAMP(3)+INTERVAL 1 DAY,UTC_TIMESTAMP(3),UTC_TIMESTAMP(3))",
      [upload, owner, stored.blobKey, stored.digest, stdout.length],
    );
    await c.execute(
      'INSERT INTO documents(id,owner_id,display_name,upload_id,created_at,updated_at) VALUES (?,?,?,?,UTC_TIMESTAMP(3),UTC_TIMESTAMP(3))',
      [document, owner, 'Gambar biru sintetis', upload],
    );
    return enqueue(c, 'KTP_CHECK', owner, [{ id: document, version: 1 }]);
  });
  const claimed = await claimJob(pool);
  assert.equal(
    claimed?.id,
    queued.id,
    'Gunakan database test tanpa worker lain aktif.',
  );
  await processJob(pool, claimed, config);
  const [rows] = await pool.execute<JobRow[]>('SELECT * FROM jobs WHERE id=?', [
    queued.id,
  ]);
  const result = formatJob(rows[0]!);
  assert.equal(result.state, 'SUCCEEDED', result.errorCode ?? '');
  assert.notEqual(result.ktpResult?.documentType, 'KTP');
  assert.equal(result.ktpResult?.nameReadable, false);
  console.log(
    'PASS: unggahan sintetis → antrean MySQL → FFmpeg → DeepSeek → hasil non-KTP persisten.',
  );
} finally {
  await withBusinessTransaction(pool, async (c) => {
    await c.execute('DELETE FROM jobs WHERE owner_id=?', [owner]);
    await c.execute('DELETE FROM documents WHERE owner_id=?', [owner]);
    await c.execute('DELETE FROM uploads WHERE owner_id=?', [owner]);
    await c.execute('DELETE FROM accounts WHERE id=?', [owner]);
  });
  await pool.end();
  if (blob) await unlink(join(getStorageDirectory(), 'uploads', blob));
}
