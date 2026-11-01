CREATE TABLE family_profiles (
  account_id CHAR(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL PRIMARY KEY,
  version INT UNSIGNED NOT NULL DEFAULT 1,
  updated_at DATETIME(3) NOT NULL,
  CONSTRAINT family_profiles_account_fk FOREIGN KEY (account_id) REFERENCES accounts (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
