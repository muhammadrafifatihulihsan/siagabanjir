CREATE TABLE documents (
  id CHAR(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL PRIMARY KEY,
  owner_id CHAR(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  display_name VARCHAR(120) NOT NULL,
  upload_id CHAR(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  version INT UNSIGNED NOT NULL DEFAULT 1,
  created_at DATETIME(3) NOT NULL,
  deleted_at DATETIME(3) NULL,
  updated_at DATETIME(3) NOT NULL,
  KEY documents_owner (owner_id, created_at),
  CONSTRAINT documents_owner_fk FOREIGN KEY (owner_id) REFERENCES accounts (id),
  CONSTRAINT documents_upload_fk FOREIGN KEY (upload_id) REFERENCES uploads (id),
  CONSTRAINT documents_name_length CHECK (CHAR_LENGTH(display_name) BETWEEN 1 AND 120)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
