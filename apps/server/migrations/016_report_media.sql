CREATE TABLE report_media (
  report_id CHAR(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  upload_id CHAR(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  order_index TINYINT UNSIGNED NOT NULL,
  PRIMARY KEY (report_id, order_index),
  UNIQUE KEY report_media_upload_unique (upload_id),
  CONSTRAINT report_media_report_fk FOREIGN KEY (report_id) REFERENCES reports (id),
  CONSTRAINT report_media_upload_fk FOREIGN KEY (upload_id) REFERENCES uploads (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
