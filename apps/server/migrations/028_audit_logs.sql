CREATE TABLE audit_logs (
  id CHAR(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL PRIMARY KEY,
  actor_id CHAR(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  action VARCHAR(80) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  object_id CHAR(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  created_at DATETIME(3) NOT NULL,
  reason VARCHAR(500) NULL,
  outcome VARCHAR(40) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  version INT UNSIGNED NULL,
  cleanup_state VARCHAR(16) CHARACTER SET ascii COLLATE ascii_bin NULL,
  KEY audit_created (created_at),
  KEY audit_actor (actor_id, created_at),
  CONSTRAINT audit_actor_fk FOREIGN KEY (actor_id) REFERENCES accounts (id),
  CONSTRAINT audit_cleanup_state CHECK (cleanup_state IS NULL OR cleanup_state IN ('PENDING', 'RUNNING', 'FAILED', 'SUCCEEDED'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
