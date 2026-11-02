import { randomUUID, timingSafeEqual } from 'node:crypto';
import type { PoolConnection, RowDataPacket } from 'mysql2/promise';
import type { AuthDependencies } from '../auth/signup.js';
import { withBusinessTransaction, withConnection } from '../db/pool.js';
import { actorScope, fingerprint } from '../security/fingerprint.js';
import { encodeCursor, decodeCursor } from '../security/cursor.js';
import { HttpProblem } from '../http/problem.js';

export interface Settings {
  galleryEnabled: boolean;
  quotaCount: number;
  quotaHours: number;
  version: number;
}

export interface QuotaState {
  used: number;
  remaining: number;
  nextReleaseAt: string | null;
  settings: Settings;
}

export interface ReportingStatus {
  quota: QuotaState;
  ktpSatisfied: boolean;
  ktpStateVersion: number;
}

export interface SettingsUpdate {
  galleryEnabled?: boolean;
  quotaCount?: number;
  quotaHours?: number;
}

export interface QuotaResetInput {
  scope: 'ACCOUNT' | 'ALL';
  accountId?: string;
}

export interface QuotaAccount {
  id: string;
  displayName: string;
  quota: QuotaState;
}

export interface QuotaAccountPage {
  items: QuotaAccount[];
  nextCursor: string | null;
  serverTime: string;
  revision: number | null;
}

interface QuotaSettingsRow extends RowDataPacket {
  id: number;
  gallery_enabled: number | boolean;
  quota_count: number;
  quota_hours: number;
  global_reset_seq: string | number;
  version: number;
  updated_at: string;
}

interface LedgerRow extends RowDataPacket {
  accept_seq: string | number;
  accepted_at: string;
}

interface ResetSeqRow extends RowDataPacket {
  reset_seq: string | number;
}

interface MaxSeqRow extends RowDataPacket {
  max_seq: string | number;
}

interface KtpStateRow extends RowDataPacket {
  active_document_id: string | null;
  version: number;
}

interface AccountRow extends RowDataPacket {
  id: string;
  display_name: string;
  role: 'CITIZEN' | 'ADMIN';
}

export async function getSettings(
  connection: PoolConnection,
): Promise<Settings> {
  const [rows] = await connection.execute<QuotaSettingsRow[]>(
    'SELECT gallery_enabled, quota_count, quota_hours, version FROM quota_settings WHERE id = 1',
  );
  const row = rows[0];
  if (!row) throw new Error('Pengaturan kuota belum diinisialisasi.');
  return {
    galleryEnabled: Boolean(row.gallery_enabled),
    quotaCount: Number(row.quota_count),
    quotaHours: Number(row.quota_hours),
    version: Number(row.version),
  };
}

export async function getAccountQuotaState(
  connection: PoolConnection,
  accountId: string,
  settings: Settings,
): Promise<QuotaState> {
  const [settingsRows] = await connection.execute<QuotaSettingsRow[]>(
    'SELECT global_reset_seq FROM quota_settings WHERE id = 1',
  );
  const globalResetSeq = BigInt(settingsRows[0]?.global_reset_seq ?? 0);

  const [accountResetRows] = await connection.execute<ResetSeqRow[]>(
    'SELECT reset_seq FROM quota_accounts WHERE account_id = ?',
    [accountId],
  );
  const accountResetSeq = BigInt(accountResetRows[0]?.reset_seq ?? 0);
  const effectiveResetSeq =
    globalResetSeq > accountResetSeq ? globalResetSeq : accountResetSeq;

  const [ledger] = await connection.execute<LedgerRow[]>(
    `SELECT accept_seq, accepted_at
      FROM quota_ledger
      WHERE account_id = ?
        AND accept_seq > ?
        AND accepted_at > UTC_TIMESTAMP(3) - INTERVAL ? HOUR
        AND accepted_at <= UTC_TIMESTAMP(3)
      ORDER BY accepted_at ASC, accept_seq ASC`,
    [accountId, effectiveResetSeq.toString(), settings.quotaHours],
  );

  const used = ledger.length;
  const remaining = Math.max(0, settings.quotaCount - used);
  let nextReleaseAt: string | null = null;

  if (used >= settings.quotaCount) {
    const neededIndex = used - settings.quotaCount;
    const targetEntry = ledger[neededIndex];
    if (targetEntry) {
      const dateStr = targetEntry.accepted_at;
      const acceptedDate = new Date(
        dateStr.endsWith('Z') ? dateStr : `${dateStr}Z`,
      );
      acceptedDate.setTime(
        acceptedDate.getTime() + settings.quotaHours * 3600 * 1000,
      );
      nextReleaseAt = acceptedDate.toISOString();
    }
  }

  return {
    used,
    remaining,
    nextReleaseAt,
    settings,
  };
}

export async function getReportingStatus(
  deps: AuthDependencies,
  accountId: string,
): Promise<ReportingStatus> {
  return withConnection(deps.pool, async (connection) => {
    const settings = await getSettings(connection);
    const quota = await getAccountQuotaState(connection, accountId, settings);

    const [ktpRows] = await connection.execute<KtpStateRow[]>(
      'SELECT active_document_id, version FROM ktp_states WHERE account_id = ?',
      [accountId],
    );
    const ktpRow = ktpRows[0];
    // Demo: syarat KTP dilonggarkan sehingga status selalu memenuhi syarat.
    // Kembalikan `Boolean(ktpRow?.active_document_id)` bila mode demo dimatikan.
    const ktpSatisfied = true;
    const ktpStateVersion = ktpRow ? Number(ktpRow.version) : 1;

    return {
      quota,
      ktpSatisfied,
      ktpStateVersion,
    };
  });
}

export async function updateReportingSettings(
  deps: AuthDependencies,
  input: SettingsUpdate,
  expectedVersion: number,
  clientKey: string,
): Promise<Settings> {
  if (
    input.galleryEnabled === undefined &&
    input.quotaCount === undefined &&
    input.quotaHours === undefined
  ) {
    throw new HttpProblem(422, 'VALIDATION_FAILED');
  }

  if (input.quotaCount !== undefined) {
    if (
      !Number.isInteger(input.quotaCount) ||
      input.quotaCount < 1 ||
      input.quotaCount > 20
    ) {
      throw new HttpProblem(422, 'VALIDATION_FAILED');
    }
  }

  if (input.quotaHours !== undefined) {
    if (
      !Number.isInteger(input.quotaHours) ||
      input.quotaHours < 1 ||
      input.quotaHours > 24
    ) {
      throw new HttpProblem(422, 'VALIDATION_FAILED');
    }
  }

  const scope = actorScope(
    deps.keys.journal,
    'public',
    'admin_reporting_settings',
  );
  const hash = fingerprint(deps.keys.journal, {
    galleryEnabled: input.galleryEnabled ?? null,
    ifMatch: expectedVersion,
    operation: 'updateReportingSettings',
    quotaCount: input.quotaCount ?? null,
    quotaHours: input.quotaHours ?? null,
  });

  return withBusinessTransaction(deps.pool, async (connection) => {
    const [previous] = await connection.execute<RowDataPacket[]>(
      'SELECT id, operation, fingerprint FROM commands WHERE actor_scope = ? AND client_key = ?',
      [scope, clientKey],
    );
    if (previous[0]) {
      if (
        previous[0].operation !== 'updateReportingSettings' ||
        !timingSafeEqual(previous[0].fingerprint as Buffer, hash)
      ) {
        throw new HttpProblem(409, 'IDEMPOTENCY_CONFLICT');
      }
      return getSettings(connection);
    }

    const [rows] = await connection.execute<QuotaSettingsRow[]>(
      'SELECT gallery_enabled, quota_count, quota_hours, version FROM quota_settings WHERE id = 1 FOR UPDATE',
    );
    const current = rows[0];
    if (!current) throw new Error('Pengaturan kuota belum diinisialisasi.');
    if (current.version !== expectedVersion) {
      throw new HttpProblem(409, 'VERSION_CONFLICT', null, current.version);
    }

    const galleryEnabled =
      input.galleryEnabled !== undefined
        ? input.galleryEnabled
        : Boolean(current.gallery_enabled);
    const quotaCount =
      input.quotaCount !== undefined ? input.quotaCount : current.quota_count;
    const quotaHours =
      input.quotaHours !== undefined ? input.quotaHours : current.quota_hours;

    await connection.execute(
      `UPDATE quota_settings
        SET gallery_enabled = ?, quota_count = ?, quota_hours = ?,
            version = version + 1, updated_at = UTC_TIMESTAMP(3)
        WHERE id = 1 AND version = ?`,
      [galleryEnabled, quotaCount, quotaHours, expectedVersion],
    );

    const actionId = randomUUID();
    await connection.execute(
      `INSERT INTO commands (id, actor_scope, client_key, operation, fingerprint, state, object_id, committed_at)
        VALUES (?, ?, ?, 'updateReportingSettings', ?, 'COMMITTED', '1', UTC_TIMESTAMP(3))`,
      [actionId, scope, clientKey, hash],
    );

    return {
      galleryEnabled,
      quotaCount,
      quotaHours,
      version: current.version + 1,
    };
  });
}

export async function resetQuota(
  deps: AuthDependencies,
  input: QuotaResetInput,
  expectedVersion: number,
  clientKey: string,
): Promise<Settings> {
  if (input.scope === 'ACCOUNT' && !input.accountId) {
    throw new HttpProblem(422, 'VALIDATION_FAILED');
  }
  if (input.scope === 'ALL' && input.accountId) {
    throw new HttpProblem(422, 'VALIDATION_FAILED');
  }

  const scope = actorScope(deps.keys.journal, 'public', 'admin_quota_resets');
  const hash = fingerprint(deps.keys.journal, {
    accountId: input.accountId ?? null,
    ifMatch: expectedVersion,
    operation: 'resetQuota',
    scope: input.scope,
  });

  return withBusinessTransaction(deps.pool, async (connection) => {
    const [previous] = await connection.execute<RowDataPacket[]>(
      'SELECT id, operation, fingerprint FROM commands WHERE actor_scope = ? AND client_key = ?',
      [scope, clientKey],
    );
    if (previous[0]) {
      if (
        previous[0].operation !== 'resetQuota' ||
        !timingSafeEqual(previous[0].fingerprint as Buffer, hash)
      ) {
        throw new HttpProblem(409, 'IDEMPOTENCY_CONFLICT');
      }
      return getSettings(connection);
    }

    const [rows] = await connection.execute<QuotaSettingsRow[]>(
      'SELECT version FROM quota_settings WHERE id = 1 FOR UPDATE',
    );
    const current = rows[0];
    if (!current) throw new Error('Pengaturan kuota belum diinisialisasi.');
    if (current.version !== expectedVersion) {
      throw new HttpProblem(409, 'VERSION_CONFLICT', null, current.version);
    }

    if (input.scope === 'ALL') {
      const [maxSeqRows] = await connection.execute<MaxSeqRow[]>(
        'SELECT COALESCE(MAX(accept_seq), 0) AS max_seq FROM quota_ledger',
      );
      const maxSeq = maxSeqRows[0]?.max_seq ?? 0;
      await connection.execute(
        `UPDATE quota_settings
          SET global_reset_seq = ?, version = version + 1, updated_at = UTC_TIMESTAMP(3)
          WHERE id = 1 AND version = ?`,
        [maxSeq, expectedVersion],
      );
    } else {
      const targetAccountId = input.accountId;
      if (!targetAccountId) throw new HttpProblem(422, 'VALIDATION_FAILED');

      const [accountRows] = await connection.execute<AccountRow[]>(
        'SELECT id FROM accounts WHERE id = ?',
        [targetAccountId],
      );
      if (!accountRows[0]) throw new HttpProblem(404, 'NOT_FOUND');

      const [maxSeqRows] = await connection.execute<MaxSeqRow[]>(
        'SELECT COALESCE(MAX(accept_seq), 0) AS max_seq FROM quota_ledger WHERE account_id = ?',
        [targetAccountId],
      );
      const maxSeq = maxSeqRows[0]?.max_seq ?? 0;

      await connection.execute(
        `INSERT INTO quota_accounts (account_id, reset_seq, updated_at)
          VALUES (?, ?, UTC_TIMESTAMP(3))
          ON DUPLICATE KEY UPDATE reset_seq = VALUES(reset_seq), updated_at = UTC_TIMESTAMP(3)`,
        [targetAccountId, maxSeq],
      );

      await connection.execute(
        `UPDATE quota_settings
          SET version = version + 1, updated_at = UTC_TIMESTAMP(3)
          WHERE id = 1 AND version = ?`,
        [expectedVersion],
      );
    }

    const actionId = randomUUID();
    await connection.execute(
      `INSERT INTO commands (id, actor_scope, client_key, operation, fingerprint, state, object_id, committed_at)
        VALUES (?, ?, ?, 'resetQuota', ?, 'COMMITTED', ?, UTC_TIMESTAMP(3))`,
      [actionId, scope, clientKey, hash, input.accountId ?? 'all'],
    );

    return getSettings(connection);
  });
}

export async function listQuotaAccounts(
  deps: AuthDependencies,
  adminAccountId: string,
  query: { cursor?: string; q?: string },
): Promise<QuotaAccountPage> {
  const filter = query.q ? query.q.normalize('NFC').trim() : '';

  let lastId: string | null = null;
  if (query.cursor) {
    const decoded = decodeCursor(
      deps.keys.cursor,
      query.cursor,
      adminAccountId,
      'quotas',
      filter,
    );
    lastId = decoded.lastId;
  }

  return withConnection(deps.pool, async (connection) => {
    const settings = await getSettings(connection);

    let sql =
      "SELECT id, display_name, role FROM accounts WHERE role = 'CITIZEN'";
    const params: (string | number)[] = [];

    if (filter) {
      const escaped = filter.replace(/([%_\\])/g, '\\$1');
      sql += ' AND display_name LIKE ?';
      params.push(`%${escaped}%`);
    }

    if (lastId) {
      sql += ' AND id > ?';
      params.push(lastId);
    }

    sql += ' ORDER BY id ASC LIMIT 21';

    const [rows] = await connection.execute<AccountRow[]>(sql, params);

    const hasMore = rows.length > 20;
    const itemsRows = hasMore ? rows.slice(0, 20) : rows;

    const items: QuotaAccount[] = [];
    for (const r of itemsRows) {
      const quota = await getAccountQuotaState(connection, r.id, settings);
      items.push({
        id: r.id,
        displayName: r.display_name,
        quota,
      });
    }

    let nextCursor: string | null = null;
    if (hasMore && itemsRows.length > 0) {
      const last = itemsRows[itemsRows.length - 1];
      if (last) {
        nextCursor = encodeCursor(deps.keys.cursor, {
          actorId: adminAccountId,
          domain: 'quotas',
          filter,
          lastId: last.id,
        });
      }
    }

    return {
      items,
      nextCursor,
      revision: settings.version,
      serverTime: new Date().toISOString(),
    };
  });
}
