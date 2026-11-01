CREATE TABLE sessions (
  id CHAR(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL PRIMARY KEY,
  account_id CHAR(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  token_digest BINARY(32) NOT NULL,
  revoke_digest BINARY(32) NOT NULL,
  epoch INT UNSIGNED NOT NULL,
  created_at DATETIME(3) NOT NULL,
  expires_at DATETIME(3) NOT NULL,
  revoked_at DATETIME(3) NULL,
  UNIQUE KEY sessions_token_unique (token_digest),
  UNIQUE KEY sessions_revoke_unique (revoke_digest),
  KEY sessions_account (account_id),
  KEY sessions_expiry (expires_at),
  CONSTRAINT sessions_account_fk FOREIGN KEY (account_id) REFERENCES accounts(id),
  CONSTRAINT sessions_epoch CHECK (epoch >= 1),
  CONSTRAINT sessions_lifetime CHECK (
    expires_at > created_at AND expires_at <= DATE_ADD(created_at, INTERVAL 7 DAY)
  ),
  CONSTRAINT sessions_revocation_time CHECK (revoked_at IS NULL OR revoked_at >= created_at),
  CONSTRAINT sessions_distinct_secrets CHECK (token_digest <> revoke_digest)
) ENGINE=InnoDB
