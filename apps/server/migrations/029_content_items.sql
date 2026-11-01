CREATE TABLE content_items (
  id CHAR(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL PRIMARY KEY,
  kind VARCHAR(16) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  draft_json JSON NOT NULL,
  published_json JSON NULL,
  state VARCHAR(16) CHARACTER SET ascii COLLATE ascii_bin NOT NULL DEFAULT 'DRAFT',
  version INT UNSIGNED NOT NULL DEFAULT 1,
  created_at DATETIME(3) NOT NULL,
  updated_at DATETIME(3) NOT NULL,
  KEY content_kind_state (kind, state),
  CONSTRAINT content_kind CHECK (kind IN ('contacts', 'guides', 'catalog')),
  CONSTRAINT content_state CHECK (state IN ('DRAFT', 'PUBLISHED', 'WITHDRAWN'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
