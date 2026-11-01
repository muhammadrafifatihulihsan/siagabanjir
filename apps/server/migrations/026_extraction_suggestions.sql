CREATE TABLE extraction_suggestions (
  id CHAR(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL PRIMARY KEY,
  job_id CHAR(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  source_document_id CHAR(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  source_document_version INT UNSIGNED NOT NULL DEFAULT 1,
  page INT UNSIGNED NOT NULL DEFAULT 1,
  display_name VARCHAR(80) NOT NULL,
  age_group VARCHAR(16) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  special_needs JSON NOT NULL,
  available_at DATETIME(3) NOT NULL,
  expires_at DATETIME(3) NOT NULL,
  KEY suggestions_job (job_id),
  CONSTRAINT suggestions_job_fk FOREIGN KEY (job_id) REFERENCES jobs (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
