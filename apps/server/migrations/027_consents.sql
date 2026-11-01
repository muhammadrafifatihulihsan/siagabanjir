CREATE TABLE consents (
  id CHAR(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL PRIMARY KEY,
  owner_id CHAR(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  purpose VARCHAR(16) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  source_id CHAR(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  source_version INT UNSIGNED NOT NULL DEFAULT 1,
  text_version VARCHAR(32) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  granted_at DATETIME(3) NOT NULL,
  KEY consents_owner (owner_id, purpose),
  CONSTRAINT consents_owner_fk FOREIGN KEY (owner_id) REFERENCES accounts (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
