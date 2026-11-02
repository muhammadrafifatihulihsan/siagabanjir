-- Jenis pekerjaan baru untuk narasi ringkasan klaster (best-effort).
-- Agregasi deterministik tetap dihitung sinkron; job ini hanya menambah teks AI.
ALTER TABLE jobs DROP CHECK jobs_kind;
ALTER TABLE jobs
  ADD CONSTRAINT jobs_kind
  CHECK (kind IN ('REPORT_ANALYSIS', 'KTP_CHECK', 'FAMILY_EXTRACTION', 'CLUSTER_SUMMARY'));
