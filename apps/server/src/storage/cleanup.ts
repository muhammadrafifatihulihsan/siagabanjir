import { unlink } from 'node:fs/promises';
import type { Pool, RowDataPacket } from 'mysql2/promise';
import { withBusinessTransaction } from '../db/pool.js';
import { resolveBlobPath } from './vault.js';

// Satu worker menjalankan cleanup; akses HTTP telah dicabut melalui deleted_at.
export async function cleanupOne(pool: Pool): Promise<boolean> {
  const [jobs] = await pool.query<RowDataPacket[]>(
    "SELECT * FROM cleanup_jobs WHERE state IN ('PENDING','RUNNING') OR (state='FAILED' AND attempt<3 AND updated_at<UTC_TIMESTAMP(3)-INTERVAL 15 SECOND) ORDER BY created_at LIMIT 1",
  );
  const job = jobs[0];
  if (!job) return false;
  const id = String(job.id),
    objectId = String(job.object_id);
  try {
    const sql =
      job.object_type === 'DOCUMENT'
        ? 'SELECT u.id,u.blob_key FROM documents d JOIN uploads u ON u.id=d.upload_id WHERE d.id=? AND d.deleted_at IS NOT NULL'
        : 'SELECT u.id,u.blob_key FROM reports r JOIN report_media m ON m.report_id=r.id JOIN uploads u ON u.id=m.upload_id WHERE r.id=? AND r.deleted_at IS NOT NULL';
    const [media] = await pool.execute<RowDataPacket[]>(sql, [objectId]);
    for (const item of media) {
      const key = String(item.blob_key);
      try {
        await unlink(resolveBlobPath(key));
      } catch (e) {
        if (!(e && typeof e === 'object' && 'code' in e && e.code === 'ENOENT'))
          throw e;
      }
    }
    await withBusinessTransaction(pool, async (c) => {
      for (const item of media)
        await c.execute(
          "UPDATE uploads SET state='DELETED',updated_at=UTC_TIMESTAMP(3) WHERE id=?",
          [String(item.id)],
        );
      await c.execute(
        "UPDATE cleanup_jobs SET state='SUCCEEDED',attempt=LEAST(attempt+1,3),error_code=NULL,updated_at=UTC_TIMESTAMP(3) WHERE id=?",
        [id],
      );
    });
  } catch {
    await pool.execute(
      "UPDATE cleanup_jobs SET state='FAILED',attempt=LEAST(attempt+1,3),error_code='CLEANUP_FAILED',updated_at=UTC_TIMESTAMP(3) WHERE id=?",
      [id],
    );
  }
  return true;
}
