CREATE TABLE ktp_states (
  account_id CHAR(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL PRIMARY KEY,
  active_document_id CHAR(36) CHARACTER SET ascii COLLATE ascii_bin NULL,
  version INT UNSIGNED NOT NULL DEFAULT 1,
  updated_at DATETIME(3) NOT NULL,
  CONSTRAINT ktp_states_account_fk FOREIGN KEY (account_id) REFERENCES accounts(id),
  CONSTRAINT ktp_states_version_positive CHECK (version >= 1)
) ENGINE=InnoDB
