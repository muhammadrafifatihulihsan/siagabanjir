import 'package:flutter/material.dart';

import '../theme/siaga_theme.dart';

class HeaderHalaman extends StatelessWidget {
  const HeaderHalaman({
    super.key,
    required this.judul,
    required this.onBack,
    this.keterangan,
  });
  final String judul;
  final VoidCallback onBack;
  final String? keterangan;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
    child: Row(
      children: [
        Semantics(
          label: 'Kembali',
          button: true,
          onTap: onBack,
          excludeSemantics: true,
          child: IconButton.outlined(
            onPressed: onBack,
            tooltip: 'Kembali',
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              minimumSize: const Size(48, 48),
              side: const BorderSide(color: SiagaTheme.border),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            icon: const Icon(Icons.arrow_back_rounded, size: 24),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                header: true,
                child: Text(
                  judul,
                  style: const TextStyle(
                    fontSize: SiagaTheme.judulHalaman,
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                  ),
                ),
              ),
              if (keterangan != null)
                Text(
                  keterangan!,
                  style: const TextStyle(
                    fontSize: SiagaTheme.keterangan,
                    color: SiagaTheme.muted,
                  ),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}
