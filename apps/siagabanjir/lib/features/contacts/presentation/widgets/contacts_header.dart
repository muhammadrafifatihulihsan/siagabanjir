import 'package:flutter/material.dart';

import '../../../../shared/theme/siaga_theme.dart';

// Header halaman direktori kontak dengan tombol kembali dan judul.
class ContactsHeader extends StatelessWidget {
  const ContactsHeader({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
    child: Row(
      children: [
        Semantics(
          label: 'Kembali',
          button: true,
          child: SizedBox(
            width: 48,
            height: 48,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onBack,
                borderRadius: BorderRadius.circular(14),
                child: Center(
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: SiagaTheme.border),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 16,
                      color: SiagaTheme.ink,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Text(
            'Kontak Darurat',
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