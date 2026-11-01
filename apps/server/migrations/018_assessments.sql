CREATE TABLE assessments (
  id CHAR(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL PRIMARY KEY,
  report_id CHAR(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  source VARCHAR(16) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  relevance VARCHAR(16) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  level VARCHAR(16) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  explanation VARCHAR(1000) NOT NULL,
  result_version INT UNSIGNED NOT NULL DEFAULT 1,
  eligible TINYINT(1) NOT NULL DEFAULT 1,
  created_at DATETIME(3) NOT NULL,
  KEY assessments_report (report_id, result_version),
  CONSTRAINT assessments_report_fk FOREIGN KEY (report_id) REFERENCES reports (id),
  CONSTRAINT assessments_source CHECK (source IN ('AI', 'ADMIN', 'NONE')),
  CONSTRAINT assessments_relevance CHECK (relevance IN ('MATCH', 'MISMATCH', 'INSUFFICIENT', 'UNASSESSED')),
  CONSTRAINT assessments_level CHECK (level IN ('LOW', 'MEDIUM', 'HIGH', 'UNRATED'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
