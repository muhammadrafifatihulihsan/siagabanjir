-- Ringkasan klaster wilayah: agregasi deterministik + narasi AI opsional,
-- serta titik pusat (centroid) untuk penanda peta Pantau Wilayah.
ALTER TABLE `groups`
  ADD COLUMN summary VARCHAR(1000) NULL,
  ADD COLUMN summary_at DATETIME(3) NULL,
  ADD COLUMN ai_summary VARCHAR(1000) NULL,
  ADD COLUMN ai_summary_at DATETIME(3) NULL,
  ADD COLUMN latitude DOUBLE NULL,
  ADD COLUMN longitude DOUBLE NULL;
