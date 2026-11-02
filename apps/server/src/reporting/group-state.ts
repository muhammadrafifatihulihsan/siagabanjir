import type { PoolConnection, RowDataPacket } from 'mysql2/promise';

export async function refreshGroup(c: PoolConnection, groupId: string) {
  const [rows] = await c.execute<RowDataPacket[]>(
    `SELECT a.level,a.relevance FROM reports r JOIN assessments a ON a.id=(SELECT x.id FROM assessments x WHERE x.report_id=r.id ORDER BY (x.source='ADMIN') DESC,x.result_version DESC,x.created_at DESC LIMIT 1) WHERE r.group_id=? AND r.deleted_at IS NULL`,
    [groupId],
  );
  const levels = ['UNRATED', 'LOW', 'MEDIUM', 'HIGH'];
  const rank = rows.reduce(
    (highest, row) =>
      row.relevance === 'MATCH'
        ? Math.max(highest, levels.indexOf(String(row.level)))
        : highest,
    0,
  );
  await c.execute(
    'UPDATE `groups` SET level=?,version=version+1,updated_at=UTC_TIMESTAMP(3) WHERE id=?',
    [levels[rank] ?? 'UNRATED', groupId],
  );
}
