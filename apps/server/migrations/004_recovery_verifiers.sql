CREATE TABLE recovery_verifiers (
  account_id CHAR(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL PRIMARY KEY,
  verifier BINARY(32) NOT NULL,
  generation INT UNSIGNED NOT NULL DEFAULT 1,
  used_at DATETIME(3) NULL,
  CONSTRAINT recovery_account FOREIGN KEY (account_id) REFERENCES accounts(id),
  CONSTRAINT recovery_generation CHECK (generation >= 1)
) ENGINE=InnoDB
