import 'package:flutter/material.dart';

import '../../../../shared/theme/siaga_theme.dart';

// Header atas halaman Dokumen Siaga dengan tombol kembali aksesibel dan judul.
class DocumentsHeader extends StatelessWidget {
  const DocumentsHeader({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
    child: Row(
      children: [
        Semantics(
          button: true,
          label: 'Kembali',
          child: SizedBox(
            width: 48,
            height: 48,
            child: Material(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              child: InkWell(
                onTap: onBack,
                borderRadius: BorderRadius.circular(14),
                child: const Center(
                  child: Icon(
                    Icons.chevron_left_rounded,
                    size: 24,
                    color: SiagaTheme.ink,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        const Expanded(
          child: Text(
            'Dokumen Siaga',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: SiagaTheme.ink,
              height: 1.2,
            ),
          ),
        ),
      ],
    ),
  );
}
