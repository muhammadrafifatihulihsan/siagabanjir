CREATE TABLE auth_failures (
  principal_digest BINARY(32) NOT NULL,
  source_digest BINARY(32) NOT NULL,
  window_start DATETIME(3) NOT NULL,
  count INT UNSIGNED NOT NULL DEFAULT 0,
  blocked_until DATETIME(3) NULL,
  PRIMARY KEY (principal_digest, source_digest),
  KEY auth_failures_window (window_start),
  KEY auth_failures_blocked (blocked_until),
  CONSTRAINT auth_failures_block_time CHECK (
    blocked_until IS NULL OR blocked_until >= window_start
  )
) ENGINE=InnoDB
