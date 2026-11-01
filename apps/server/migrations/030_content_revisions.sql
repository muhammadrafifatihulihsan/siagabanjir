CREATE TABLE content_revisions (
  revision INT UNSIGNED NOT NULL PRIMARY KEY,
  published_at DATETIME(3) NOT NULL,
  manifest_json JSON NOT NULL,
  snapshot_json JSON NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
