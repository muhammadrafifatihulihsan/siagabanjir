CREATE TABLE business_write_guard (
  id TINYINT UNSIGNED NOT NULL PRIMARY KEY,
  CONSTRAINT business_write_guard_singleton CHECK (id = 1)
) ENGINE=InnoDB
