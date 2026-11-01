CREATE TABLE message_reads (
  account_id CHAR(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  message_id CHAR(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  content_version INT UNSIGNED NOT NULL,
  read_at DATETIME(3) NOT NULL,
  PRIMARY KEY (account_id, message_id, content_version),
  KEY message_reads_account (account_id),
  CONSTRAINT message_reads_account_fk FOREIGN KEY (account_id) REFERENCES accounts (id),
  CONSTRAINT message_reads_message_fk FOREIGN KEY (message_id) REFERENCES messages (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
