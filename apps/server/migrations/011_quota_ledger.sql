CREATE TABLE quota_ledger (
  accept_seq BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  account_id CHAR(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  report_id CHAR(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  accepted_at DATETIME(3) NOT NULL,
  UNIQUE KEY quota_ledger_report_unique (report_id),
  INDEX quota_ledger_account_accepted (account_id, accepted_at),
  CONSTRAINT quota_ledger_account_fk FOREIGN KEY (account_id) REFERENCES accounts(id)
) ENGINE=InnoDB
