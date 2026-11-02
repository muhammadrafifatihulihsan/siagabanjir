import { randomUUID } from 'node:crypto';
import type { Pool } from 'mysql2/promise';
import { withConnection, withBusinessTransaction } from '../db/pool.js';
import { sourcesValid, type JobRow, type StoredResult } from './jobs.js';
import { reportLevel, type ReportResult } from './results.js';
import { refreshGroup } from '../reporting/group-state.js';

export async function claimJob(pool: Pool): Promise<JobRow | null> {
  return withConnection(pool, async (c) => {
    await c.beginTransaction();
    try {
      const [rows] = await c.query<JobRow[]>(
        "SELECT * FROM jobs WHERE (state='QUEUED' AND (available_at IS NULL OR available_at<=UTC_TIMESTAMP(3))) OR (state='RUNNING' AND lease_until<UTC_TIMESTAMP(3)) ORDER BY created_at LIMIT 1 FOR UPDATE SKIP LOCKED",
      );
      const job = rows[0];
      if (!job) {
        await c.commit();
        return null;
      }
      job.lease_token = randomUUID();
      await c.execute(
        "UPDATE jobs SET state='RUNNING',lease_token=?,lease_until=UTC_TIMESTAMP(3)+INTERVAL 90 SECOND,updated_at=UTC_TIMESTAMP(3) WHERE id=?",
        [job.lease_token, job.id],
      );
      await c.commit();
      return job;
    } catch (error) {
      await c.rollback();
      throw error;
    }
  });
}
export async function heartbeat(pool: Pool, job: JobRow) {
  await pool.execute(
    "UPDATE jobs SET lease_until=UTC_TIMESTAMP(3)+INTERVAL 90 SECOND WHERE id=? AND generation=? AND lease_token=? AND state='RUNNING'",
    [job.id, job.generation, job.lease_token],
  );
}
export async function finishJob(
  pool: Pool,
  job: JobRow,
  result: StoredResult | ReportResult | null,
  error: string | null,
  model: string,
  elapsed: number,
) {
  return withBusinessTransaction(pool, async (c) => {
    const [rows] = await c.execute<JobRow[]>(
      "SELECT * FROM jobs WHERE id=? AND generation=? AND lease_token=? AND state='RUNNING' AND lease_until>UTC_TIMESTAMP(3) FOR UPDATE",
      [job.id, job.generation, job.lease_token],
    );
    if (!rows.length) return false;
    const valid = await sourcesValid(c, job);
    const state = !valid ? 'CANCELLED' : error ? 'FAILED' : 'SUCCEEDED';
    if (valid && !error && job.kind === 'REPORT_ANALYSIS' && result) {
      const analysis = result as ReportResult;
      const [reports] = await c.execute<JobRow[]>(
        'SELECT group_id,result_version FROM reports WHERE id=?',
        [job.source_id],
      );
      const [admins] = await c.execute<JobRow[]>(
        "SELECT id FROM assessments WHERE report_id=? AND source='ADMIN' LIMIT 1",
        [job.source_id],
      );
      const version =
        Number(reports[0]?.result_version) + (admins.length ? 0 : 1);
      await c.execute(
        "INSERT INTO assessments (id,report_id,source,relevance,level,explanation,result_version,eligible,created_at) VALUES (?,?,'AI',?,?,?,?,?,UTC_TIMESTAMP(3))",
        [
          randomUUID(),
          job.source_id,
          analysis.relevance,
          reportLevel(analysis),
          analysis.explanation,
          version,
          analysis.relevance === 'MATCH' ? 1 : 0,
        ],
      );
      if (!admins.length)
        await c.execute(
          'UPDATE reports SET result_version=?,version=version+1,needs_review_since=COALESCE(needs_review_since,UTC_TIMESTAMP(3)),updated_at=UTC_TIMESTAMP(3) WHERE id=?',
          [version, job.source_id],
        );
      await refreshGroup(c, String(reports[0]?.group_id));
    }
    await c.execute(
      "UPDATE jobs SET state=?,result_json=?,safe_error=?,completed_units=?,model_name=?,prompt_version=?,elapsed_ms=?,expires_at=IF(kind='FAMILY_EXTRACTION' AND ?='SUCCEEDED',UTC_TIMESTAMP(3)+INTERVAL 24 HOUR,NULL),lease_token=NULL,lease_until=NULL,updated_at=UTC_TIMESTAMP(3) WHERE id=?",
      [
        state,
        state === 'SUCCEEDED' && job.kind !== 'REPORT_ANALYSIS'
          ? JSON.stringify(result)
          : null,
        valid ? error : 'SOURCE_UNAVAILABLE',
        state === 'SUCCEEDED' ? job.total_units : 0,
        model,
        job.kind === 'KTP_CHECK'
          ? 'ktp-v1'
          : job.kind === 'REPORT_ANALYSIS'
            ? 'report-v1'
            : 'family-v1',
        elapsed,
        state,
        job.id,
      ],
    );
    return true;
  });
}
