-- Profil akun yang dapat disinkronkan dari aplikasi: telepon, alamat,
-- dan preferensi peringatan banjir. Semua kolom opsional/berdefault aman.
ALTER TABLE accounts
  ADD COLUMN phone VARCHAR(32) NULL,
  ADD COLUMN address VARCHAR(200) NULL,
  ADD COLUMN flood_alert_enabled TINYINT(1) NOT NULL DEFAULT 1;
