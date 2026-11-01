CREATE TABLE accounts (
  id CHAR(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL PRIMARY KEY,
  email_normalized VARCHAR(254) COLLATE utf8mb4_0900_bin NOT NULL,
  display_name VARCHAR(80) NOT NULL,
  role VARCHAR(16) CHARACTER SET ascii COLLATE ascii_bin NOT NULL DEFAULT 'CITIZEN',
  password_hash VARBINARY(64) NOT NULL,
  password_salt VARBINARY(16) NOT NULL,
  password_n INT UNSIGNED NOT NULL DEFAULT 131072,
  password_r INT UNSIGNED NOT NULL DEFAULT 8,
  password_p INT UNSIGNED NOT NULL DEFAULT 1,
  credential_epoch INT UNSIGNED NOT NULL DEFAULT 1,
  version INT UNSIGNED NOT NULL DEFAULT 1,
  created_at DATETIME(3) NOT NULL,
  UNIQUE KEY accounts_email_unique (email_normalized),
  CONSTRAINT accounts_email_normalized CHECK (
    CHAR_LENGTH(email_normalized) BETWEEN 3 AND 254
    AND email_normalized = LOWER(TRIM(email_normalized))
  ),
  CONSTRAINT accounts_name_length CHECK (CHAR_LENGTH(display_name) BETWEEN 2 AND 80),
  CONSTRAINT accounts_role CHECK (role IN ('CITIZEN', 'ADMIN')),
  CONSTRAINT accounts_hash_length CHECK (OCTET_LENGTH(password_hash) = 64),
  CONSTRAINT accounts_salt_length CHECK (OCTET_LENGTH(password_salt) = 16),
  CONSTRAINT accounts_scrypt_parameters CHECK (password_n = 131072 AND password_r = 8 AND password_p = 1),
  CONSTRAINT accounts_versions CHECK (credential_epoch >= 1 AND version >= 1)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
