-- SiagaBanjir - Inisialisasi Database & Hak Akses MySQL Docker
-- Otomatis dieksekusi saat container MySQL pertama kali dibuat

CREATE DATABASE IF NOT EXISTS siagabanjirdev
  CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

CREATE DATABASE IF NOT EXISTS siagabanjirtest
  CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

-- Buat akun runtime dan migrasi untuk development (akses container & host)
CREATE USER IF NOT EXISTS 'sb_dev_app'@'%' IDENTIFIED BY 'devappsecret';
CREATE USER IF NOT EXISTS 'sb_dev_migrate'@'%' IDENTIFIED BY 'devmigratesecret';

CREATE USER IF NOT EXISTS 'sb_dev_app'@'127.0.0.1' IDENTIFIED BY 'devappsecret';
CREATE USER IF NOT EXISTS 'sb_dev_migrate'@'127.0.0.1' IDENTIFIED BY 'devmigratesecret';

-- Buat akun runtime dan migrasi untuk test/integrasi
CREATE USER IF NOT EXISTS 'sb_test_app'@'%' IDENTIFIED BY 'testappsecret';
CREATE USER IF NOT EXISTS 'sb_test_migrate'@'%' IDENTIFIED BY 'testmigratesecret';

CREATE USER IF NOT EXISTS 'sb_test_app'@'127.0.0.1' IDENTIFIED BY 'testappsecret';
CREATE USER IF NOT EXISTS 'sb_test_migrate'@'127.0.0.1' IDENTIFIED BY 'testmigratesecret';

-- Berikan hak akses runtime (DML saja)
GRANT SELECT, INSERT, UPDATE, DELETE ON siagabanjirdev.* TO 'sb_dev_app'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE ON siagabanjirdev.* TO 'sb_dev_app'@'127.0.0.1';

-- Berikan hak akses migrator (DML + DDL)
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, ALTER, INDEX, REFERENCES ON siagabanjirdev.* TO 'sb_dev_migrate'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, ALTER, INDEX, REFERENCES ON siagabanjirdev.* TO 'sb_dev_migrate'@'127.0.0.1';

-- Hak akses lingkungan test
GRANT SELECT, INSERT, UPDATE, DELETE ON siagabanjirtest.* TO 'sb_test_app'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE ON siagabanjirtest.* TO 'sb_test_app'@'127.0.0.1';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, ALTER, INDEX, REFERENCES ON siagabanjirtest.* TO 'sb_test_migrate'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, ALTER, INDEX, REFERENCES ON siagabanjirtest.* TO 'sb_test_migrate'@'127.0.0.1';

FLUSH PRIVILEGES;
