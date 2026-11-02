import { randomUUID } from 'node:crypto';
import { setTimeout as delay } from 'node:timers/promises';
import type { Pool, RowDataPacket } from 'mysql2/promise';
import type { AiConfig } from './config.js';
import { callDeepSeek, AnalysisError } from './provider.js';
import {
  prompts,
  parseResult,
  type FamilyResult,
  type KtpResult,
  type ReportResult,
} from './results.js';
import { prepareImages } from './media.js';
import {
  sourcesOf,
  sourcesValid,
  type JobRow,
  type StoredResult,
  type Suggestion,
} from './jobs.js';
import { withConnection } from '../db/pool.js';
import { readMediaBlob } from '../storage/vault.js';
import { finishJob, heartbeat } from './queue.js';

interface Media extends RowDataPacket {
  blob_key: string;
  mime: string;
}
export async function processJob(
  pool: Pool,
  job: JobRow,
  config: AiConfig,
  provider = callDeepSeek,
  prepare = prepareImages,
) {
  const started = Date.now();
  let leaseFailed = false;
  const timer = setInterval(() => {
    void heartbeat(pool, job).catch(() => {
      leaseFailed = true;
    });
  }, 15_000);
  let result: StoredResult | ReportResult | null = null;
  let error: string | null = null;
  try {
    const suggestions: Suggestion[] = [];
    let incomplete = false;
    for (const [index, source] of sourcesOf(job).entries()) {
      const media = await withConnection(pool, async (c) => {
        if (leaseFailed || !(await sourcesValid(c, job)))
          throw new AnalysisError('SOURCE_UNAVAILABLE');
        const sql =
          job.kind === 'REPORT_ANALYSIS'
            ? 'SELECT u.blob_key,u.mime FROM report_media m JOIN uploads u ON u.id=m.upload_id WHERE m.report_id=? AND u.owner_id=? ORDER BY m.order_index'
            : 'SELECT u.blob_key,u.mime FROM documents d JOIN uploads u ON u.id=d.upload_id WHERE d.id=? AND d.owner_id=?';
        const [rows] = await c.execute<Media[]>(sql, [source.id, job.owner_id]);
        return rows;
      });
      const images = [];
      for (const item of media)
        images.push(
          ...(await prepare(
            (await readMediaBlob(item.blob_key)).data,
            item.mime,
            job.kind !== 'REPORT_ANALYSIS',
          )),
        );
      if (!images.length) throw new AnalysisError('PREPROCESS_FAILED');
      let raw: unknown;
      for (let attempt = 1; attempt <= 3; attempt++) {
        if (leaseFailed) throw new AnalysisError('LEASE_LOST');
        await pool.execute(
          "UPDATE jobs SET attempt=?,completed_units=?,updated_at=UTC_TIMESTAMP(3) WHERE id=? AND generation=? AND lease_token=? AND state='RUNNING'",
          [attempt, index, job.id, job.generation, job.lease_token],
        );
        try {
          raw = await provider(
            config,
            prompts[job.kind],
            images,
            job.kind === 'FAMILY_EXTRACTION' ? 4096 : 2048,
          );
          break;
        } catch (e) {
          if (!(e instanceof AnalysisError) || !e.retryable || attempt === 3)
            throw e;
          await delay(attempt === 1 ? 5000 : 15000);
        }
      }
      const parsed = parseResult(job.kind, raw);
      if (job.kind === 'KTP_CHECK') result = { ktpResult: parsed as KtpResult };
      else if (job.kind === 'REPORT_ANALYSIS') result = parsed as ReportResult;
      else {
        const family = parsed as FamilyResult;
        incomplete ||= family.incomplete;
        for (const member of family.members) {
          if (member.page > images.length)
            throw new AnalysisError('INVALID_OUTPUT');
          suggestions.push({
            id: randomUUID(),
            documentId: source.id,
            page: member.page,
            displayName: member.name,
            ageGroup: member.ageGroup,
          });
        }
        result = { suggestions, incomplete };
      }
    }
  } catch (e) {
    error = e instanceof AnalysisError ? e.code : 'PROCESSING_FAILED';
  } finally {
    clearInterval(timer);
  }
  await finishJob(pool, job, result, error, config.model, Date.now() - started);
}
