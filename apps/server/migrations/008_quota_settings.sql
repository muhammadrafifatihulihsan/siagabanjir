CREATE TABLE quota_settings (
  id TINYINT UNSIGNED NOT NULL PRIMARY KEY DEFAULT 1,
  gallery_enabled BOOLEAN NOT NULL DEFAULT FALSE,
  quota_count INT UNSIGNED NOT NULL DEFAULT 3,
  quota_hours INT UNSIGNED NOT NULL DEFAULT 6,
  global_reset_seq BIGINT UNSIGNED NOT NULL DEFAULT 0,
  version INT UNSIGNED NOT NULL DEFAULT 1,
  updated_at DATETIME(3) NOT NULL,
  CONSTRAINT quota_settings_single_row CHECK (id = 1),
  CONSTRAINT quota_count_range CHECK (quota_count BETWEEN 1 AND 20),
  CONSTRAINT quota_hours_range CHECK (quota_hours BETWEEN 1 AND 24),
  CONSTRAINT quota_version_positive CHECK (version >= 1)
) ENGINE=InnoDB
