CREATE TABLE cleanup_jobs (
  id CHAR(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL PRIMARY KEY,
  object_type VARCHAR(16) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  object_id CHAR(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  owner_id CHAR(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  protected_paths TEXT NULL,
  state VARCHAR(16) CHARACTER SET ascii COLLATE ascii_bin NOT NULL DEFAULT 'PENDING',
  attempt INT UNSIGNED NOT NULL DEFAULT 0,
  error_code VARCHAR(80) NULL,
  created_at DATETIME(3) NOT NULL,
  updated_at DATETIME(3) NOT NULL,
  KEY cleanup_owner (owner_id),
  CONSTRAINT cleanup_owner_fk FOREIGN KEY (owner_id) REFERENCES accounts (id),
  CONSTRAINT cleanup_state CHECK (state IN ('PENDING', 'RUNNING', 'FAILED', 'SUCCEEDED'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
