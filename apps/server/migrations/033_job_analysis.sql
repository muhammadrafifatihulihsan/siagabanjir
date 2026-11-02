ALTER TABLE jobs
  ADD COLUMN input_sources JSON NULL,
  ADD COLUMN result_json JSON NULL,
  ADD COLUMN model_name VARCHAR(80) NULL,
  ADD COLUMN prompt_version VARCHAR(32) NULL,
  ADD COLUMN elapsed_ms INT UNSIGNED NULL,
  ADD COLUMN usage_json JSON NULL,
  ADD COLUMN expires_at DATETIME(3) NULL,
  ADD INDEX jobs_poll (state, available_at, lease_until);
