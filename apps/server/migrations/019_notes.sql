CREATE TABLE notes (
  id CHAR(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL PRIMARY KEY,
  report_id CHAR(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  author_id CHAR(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  body VARCHAR(1000) NOT NULL,
  correction_of CHAR(36) CHARACTER SET ascii COLLATE ascii_bin NULL,
  correction_reason VARCHAR(500) NULL,
  created_at DATETIME(3) NOT NULL,
  KEY notes_report (report_id, created_at),
  CONSTRAINT notes_report_fk FOREIGN KEY (report_id) REFERENCES reports (id),
  CONSTRAINT notes_author_fk FOREIGN KEY (author_id) REFERENCES accounts (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
