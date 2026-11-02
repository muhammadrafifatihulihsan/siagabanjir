-- Jenis pekerjaan baru untuk narasi ringkasan klaster (best-effort).
-- Agregasi deterministik tetap dihitung sinkron; job ini hanya menambah teks AI.
-- Runner migrasi mengirim satu pernyataan per berkas, jadi drop+add digabung
-- dalam satu ALTER.
ALTER TABLE jobs
  DROP CHECK jobs_kind,
  ADD CONSTRAINT jobs_kind
  CHECK (kind IN ('REPORT_ANALYSIS', 'KTP_CHECK', 'FAMILY_EXTRACTION', 'CLUSTER_SUMMARY'));
