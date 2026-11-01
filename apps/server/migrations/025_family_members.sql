CREATE TABLE family_members (
  id CHAR(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL PRIMARY KEY,
  account_id CHAR(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  display_name VARCHAR(80) NOT NULL,
  age_group VARCHAR(16) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  special_needs JSON NOT NULL,
  created_at DATETIME(3) NOT NULL,
  updated_at DATETIME(3) NOT NULL,
  KEY family_members_account (account_id),
  CONSTRAINT family_members_account_fk FOREIGN KEY (account_id) REFERENCES accounts (id),
  CONSTRAINT family_members_age CHECK (age_group IN ('TODDLER', 'CHILD', 'TEEN', 'ADULT', 'OLDER_ADULT', 'UNKNOWN'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
