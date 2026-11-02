import type { PoolConnection, RowDataPacket } from 'mysql2/promise';
import { enqueue } from '../ai/jobs.js';

const levels = ['UNRATED', 'LOW', 'MEDIUM', 'HIGH'] as const;
const levelLabels: Record<string, string> = {
  UNRATED: 'BELUM DINILAI',
  LOW: 'RENDAH',
  MEDIUM: 'SEDANG',
  HIGH: 'TINGGI',
};

interface GroupAssessmentRow extends RowDataPacket {
  level: string;
  relevance: string;
  description_mismatch: number | boolean;
}

interface GroupOwnerRow extends RowDataPacket {
  owner_id: string;
  state: 'ACTIVE' | 'COMPLETED';
}

function rankOf(level: string): number {
  const index = levels.indexOf(level as (typeof levels)[number]);
  return index < 0 ? 0 : index;
}

export async function refreshGroup(c: PoolConnection, groupId: string) {
  const [rows] = await c.execute<GroupAssessmentRow[]>(
    `SELECT a.level,a.relevance,a.description_mismatch FROM reports r JOIN assessments a ON a.id=(SELECT x.id FROM assessments x WHERE x.report_id=r.id ORDER BY (x.source='ADMIN') DESC,x.result_version DESC,x.created_at DESC LIMIT 1) WHERE r.group_id=? AND r.deleted_at IS NULL`,
    [groupId],
  );

  const matched = rows.filter((row) => row.relevance === 'MATCH');
  const mismatch = rows.filter(
    (row) => Number(row.description_mismatch) === 1,
  ).length;
  const insufficient = rows.filter(
    (row) => row.relevance === 'INSUFFICIENT',
  ).length;
  const rank = matched.reduce(
    (highest, row) => Math.max(highest, rankOf(String(row.level))),
    0,
  );
  const level = levels[rank] ?? 'UNRATED';
  const average = matched.length
    ? matched.reduce((total, row) => total + rankOf(String(row.level)), 0) /
      matched.length
    : 0;
  const averageLabel = levelLabels[levels[Math.round(average)] ?? 'UNRATED'];

  let summary = 'Belum ada laporan aktif pada klaster ini.';
  if (rows.length) {
    summary =
      `${rows.length} laporan aktif · ${matched.length} sesuai bukti · ` +
      `${mismatch} deskripsi tidak sesuai · ${insufficient} belum cukup bukti. ` +
      `Rata-rata tingkat: ${averageLabel}. Status klaster: ${levelLabels[level]}.`;
    if (summary.length > 1000) summary = summary.slice(0, 1000);
  }

  const [coords] = await c.execute<RowDataPacket[]>(
    'SELECT AVG(latitude) AS lat, AVG(longitude) AS lon FROM reports WHERE group_id=? AND deleted_at IS NULL',
    [groupId],
  );
  const latitude =
    coords[0]?.lat !== null && coords[0]?.lat !== undefined
      ? Number(coords[0].lat)
      : null;
  const longitude =
    coords[0]?.lon !== null && coords[0]?.lon !== undefined
      ? Number(coords[0].lon)
      : null;

  await c.execute(
    'UPDATE `groups` SET level=?,summary=?,summary_at=UTC_TIMESTAMP(3),latitude=?,longitude=?,version=version+1,updated_at=UTC_TIMESTAMP(3) WHERE id=?',
    [level, summary, latitude, longitude, groupId],
  );

  // Kesimpulan AI bersifat best-effort: hanya dijadwalkan bila ada laporan aktif.
  const [owners] = await c.execute<GroupOwnerRow[]>(
    'SELECT r.owner_id,g.state FROM reports r JOIN `groups` g ON g.id=r.group_id WHERE r.group_id=? AND r.deleted_at IS NULL ORDER BY r.accepted_at DESC LIMIT 1',
    [groupId],
  );
  const owner = owners[0];
  if (owner && owner.state === 'ACTIVE' && rows.length) {
    await enqueue(c, 'CLUSTER_SUMMARY', owner.owner_id, [
      { id: groupId, version: 0 },
    ]);
  }
}
