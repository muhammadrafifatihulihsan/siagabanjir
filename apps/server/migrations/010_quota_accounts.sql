CREATE TABLE quota_accounts (
  account_id CHAR(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL PRIMARY KEY,
  reset_seq BIGINT UNSIGNED NOT NULL DEFAULT 0,
  updated_at DATETIME(3) NOT NULL,
  CONSTRAINT quota_accounts_account_fk FOREIGN KEY (account_id) REFERENCES accounts(id)
) ENGINE=InnoDB
