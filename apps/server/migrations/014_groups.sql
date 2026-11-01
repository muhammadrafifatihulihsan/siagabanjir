CREATE TABLE `groups` (
  id CHAR(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL PRIMARY KEY,
  code VARCHAR(32) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  state VARCHAR(16) CHARACTER SET ascii COLLATE ascii_bin NOT NULL DEFAULT 'ACTIVE',
  location_label VARCHAR(120) NULL,
  source_report_id CHAR(36) CHARACTER SET ascii COLLATE ascii_bin NULL,
  level VARCHAR(16) CHARACTER SET ascii COLLATE ascii_bin NOT NULL DEFAULT 'UNRATED',
  created_at DATETIME(3) NOT NULL,
  completed_at DATETIME(3) NULL,
  updated_at DATETIME(3) NOT NULL,
  version INT UNSIGNED NOT NULL DEFAULT 1,
  UNIQUE KEY groups_code_unique (code),
  CONSTRAINT groups_state CHECK (state IN ('ACTIVE', 'COMPLETED')),
  CONSTRAINT groups_level CHECK (level IN ('LOW', 'MEDIUM', 'HIGH', 'UNRATED'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
