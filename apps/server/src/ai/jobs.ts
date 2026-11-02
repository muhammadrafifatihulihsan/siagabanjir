import { createHash, randomUUID } from 'node:crypto';
import type { PoolConnection, RowDataPacket } from 'mysql2/promise';
import type { Kind, KtpResult } from './results.js';
import { HttpProblem } from '../http/problem.js';

export interface Source {
  id: string;
  version: number;
}
export interface Suggestion {
  id: string;
  documentId: string;
  page: number;
  displayName: string | null;
  ageGroup: string;
}
export interface StoredResult {
  ktpResult?: KtpResult;
  suggestions?: Suggestion[];
  incomplete?: boolean;
}
export interface JobRow extends RowDataPacket {
  id: string;
  kind: Kind;
  owner_id: string;
  source_id: string;
  source_version: number;
  state:
    'QUEUED' | 'RUNNING' | 'SUCCEEDED' | 'FAILED' | 'CANCELLED' | 'EXPIRED';
  attempt: number;
  completed_units: number;
  total_units: number;
  updated_at: string | Date;
  safe_error: string | null;
  input_sources: Source[] | string | null;
  result_json: StoredResult | string | null;
  expires_at: string | Date | null;
  generation: number;
  lease_token: string | null;
}
export function sourcesOf(job: JobRow): Source[] {
  const value =
    typeof job.input_sources === 'string'
      ? (JSON.parse(job.input_sources) as Source[])
      : job.input_sources;
  return value ?? [{ id: job.source_id, version: job.source_version }];
}
export function resultOf(job: JobRow): StoredResult | null {
  return typeof job.result_json === 'string'
    ? (JSON.parse(job.result_json) as StoredResult)
    : job.result_json;
}
export function formatJob(job: JobRow) {
  const expired =
    job.expires_at !== null && new Date(job.expires_at).getTime() <= Date.now();
  const result = job.state === 'SUCCEEDED' && !expired ? resultOf(job) : null;
  return {
    id: job.id,
    kind: job.kind,
    state: expired ? ('EXPIRED' as const) : job.state,
    sourceId: job.kind === 'FAMILY_EXTRACTION' ? job.id : job.source_id,
    attempt: Number(job.attempt),
    completedUnits: Number(job.completed_units),
    totalUnits: Number(job.total_units),
    updatedAt: new Date(job.updated_at).toISOString(),
    errorCode: job.safe_error,
    expiresAt: job.expires_at ? new Date(job.expires_at).toISOString() : null,
    ktpResult: result?.ktpResult ?? null,
    suggestions: result?.suggestions ?? null,
    incomplete: result?.incomplete ?? null,
  };
}
export async function sourcesValid(
  connection: PoolConnection,
  job: JobRow,
): Promise<boolean> {
  for (const source of sourcesOf(job)) {
    const table = job.kind === 'REPORT_ANALYSIS' ? 'reports' : 'documents';
    const version =
      job.kind === 'REPORT_ANALYSIS' ? 'evidence_version' : 'version';
    const [rows] = await connection.execute<RowDataPacket[]>(
      `SELECT id FROM ${table} WHERE id = ? AND owner_id = ? AND ${version} = ? AND deleted_at IS NULL`,
      [source.id, job.owner_id, source.version],
    );
    if (!rows.length) return false;
  }
  return true;
}
export async function enqueue(
  connection: PoolConnection,
  kind: Kind,
  owner: string,
  sources: Source[],
): Promise<JobRow> {
  const workKey = createHash('sha256')
    .update(
      JSON.stringify([
        kind,
        owner,
        [...sources].sort((a, b) => a.id.localeCompare(b.id)),
      ]),
    )
    .digest('hex');
  const [active] = await connection.execute<JobRow[]>(
    "SELECT * FROM jobs WHERE active_work_key = ? AND state IN ('QUEUED','RUNNING')",
    [workKey],
  );
  if (active[0]) return active[0];
  const first = sources[0];
  if (!first) throw new HttpProblem(422, 'VALIDATION_FAILED');
  const id = randomUUID();
  await connection.execute(
    `INSERT INTO jobs (id,kind,owner_id,source_id,source_version,input_sources,state,attempt,completed_units,total_units,active_work_key,created_at,updated_at) VALUES (?,?,?,?,?,?,'QUEUED',0,0,?,?,UTC_TIMESTAMP(3),UTC_TIMESTAMP(3))`,
    [
      id,
      kind,
      owner,
      first.id,
      first.version,
      JSON.stringify(sources),
      sources.length,
      workKey,
    ],
  );
  const [rows] = await connection.execute<JobRow[]>(
    'SELECT * FROM jobs WHERE id = ?',
    [id],
  );
  return rows[0]!;
}
export async function retryJob(
  connection: PoolConnection,
  owner: string,
  id: string,
  kind: Kind,
) {
  const [rows] = await connection.execute<JobRow[]>(
    'SELECT * FROM jobs WHERE id = ? AND owner_id = ? AND kind = ? FOR UPDATE',
    [id, owner, kind],
  );
  const job = rows[0];
  if (!job) throw new HttpProblem(404, 'NOT_FOUND');
  if (!(await sourcesValid(connection, job)))
    throw new HttpProblem(410, 'GONE');
  if (job.state === 'QUEUED' || job.state === 'RUNNING') return formatJob(job);
  if (job.state !== 'FAILED') throw new HttpProblem(409, 'CONFLICT');
  await connection.execute(
    "UPDATE jobs SET state='QUEUED',generation=generation+1,attempt=0,completed_units=0,result_json=NULL,safe_error=NULL,available_at=NULL,lease_token=NULL,lease_until=NULL,updated_at=UTC_TIMESTAMP(3) WHERE id=?",
    [id],
  );
  const [updated] = await connection.execute<JobRow[]>(
    'SELECT * FROM jobs WHERE id=?',
    [id],
  );
  return formatJob(updated[0]!);
}
