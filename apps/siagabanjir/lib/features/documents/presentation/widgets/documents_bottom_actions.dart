import 'package:flutter/material.dart';

import '../../../../shared/theme/siaga_theme.dart';

// Tombol aksi bawah (Simpan & Enkripsi serta Unduh ZIP) sesuai desain referensi documents_vault.svg.
class DocumentsBottomActions extends StatelessWidget {
  const DocumentsBottomActions({
    super.key,
    required this.onSaveAndEncrypt,
    required this.onDownloadZip,
  });

  final VoidCallback onSaveAndEncrypt;
  final VoidCallback onDownloadZip;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Semantics(
        button: true,
        label: 'Simpan dan enkripsi dokumen siaga',
        child: SizedBox(
          height: 48,
          child: ElevatedButton.icon(
            onPressed: onSaveAndEncrypt,
            icon: const Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 20,
            ),
            label: const Text(
              'Simpan & Enkripsi Dokumen Siaga',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: SiagaTheme.blue,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
      ),
      const SizedBox(height: 10),
      Semantics(
        button: true,
        label: 'Unduh semua berkas digital dalam format ZIP',
        child: SizedBox(
          height: 44,
          child: OutlinedButton.icon(
            onPressed: onDownloadZip,
            icon: const Icon(
              Icons.download_rounded,
              color: Color(0xFF1D4ED8),
              size: 18,
            ),
            label: const Text(
              'Unduh Semua Berkas Digital (ZIP)',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1D4ED8),
              ),
            ),
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF1D4ED8),
              side: const BorderSide(color: Color(0xFFE2E8F0)),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}
