CREATE TABLE submissions (
  id CHAR(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL PRIMARY KEY,
  owner_id CHAR(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  report_id CHAR(36) CHARACTER SET ascii COLLATE ascii_bin NULL,
  state VARCHAR(20) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  accepted_at DATETIME(3) NULL,
  error_code VARCHAR(80) NULL,
  created_at DATETIME(3) NOT NULL,
  updated_at DATETIME(3) NOT NULL,
  KEY submissions_owner (owner_id),
  CONSTRAINT submissions_owner_fk FOREIGN KEY (owner_id) REFERENCES accounts (id),
  CONSTRAINT submissions_report_fk FOREIGN KEY (report_id) REFERENCES reports (id),
  CONSTRAINT submissions_state CHECK (state IN ('ACCEPTED', 'REJECTED_CLOSED', 'CLOSED', 'DELETED'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
