-- Penanda ketidaksesuaian antara deskripsi warga dan bukti gambar
-- yang dilaporkan oleh analisis AI (anti-laporan palsu).
ALTER TABLE assessments
  ADD COLUMN description_mismatch TINYINT(1) NOT NULL DEFAULT 0;
