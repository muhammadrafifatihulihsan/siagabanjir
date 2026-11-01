export function readSecurityKeys(env: NodeJS.ProcessEnv) {
  const names = [
    'RECOVERY_HMAC_KEY',
    'JOURNAL_HMAC_KEY',
    'CURSOR_HMAC_KEY',
  ] as const;
  const keys = names.map((name) => {
    const value = env[name];
    if (!value || !/^[0-9a-f]{64}$/i.test(value))
      throw new Error('Konfigurasi key keamanan tidak valid.');
    return Buffer.from(value, 'hex');
  });
  const [recovery, journal, cursor] = keys;
  if (
    !recovery ||
    !journal ||
    !cursor ||
    recovery.equals(journal) ||
    recovery.equals(cursor) ||
    journal.equals(cursor)
  ) {
    throw new Error('Key keamanan harus terpisah per tujuan.');
  }
  return { recovery, journal, cursor };
}
