CREATE TABLE commands (
  action_seq BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  id CHAR(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  actor_scope BINARY(32) NOT NULL,
  client_key CHAR(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  operation VARCHAR(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  fingerprint BINARY(32) NOT NULL,
  state VARCHAR(20) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  object_id CHAR(36) CHARACTER SET ascii COLLATE ascii_bin NULL,
  committed_at DATETIME(3) NOT NULL,
  safe_error VARCHAR(64) CHARACTER SET ascii COLLATE ascii_bin NULL,
  UNIQUE KEY commands_id (id),
  UNIQUE KEY commands_actor_key (actor_scope, client_key),
  CONSTRAINT commands_initial_state CHECK (state = 'COMMITTED'),
  CONSTRAINT commands_initial_error CHECK (safe_error IS NULL)
) ENGINE=InnoDB
