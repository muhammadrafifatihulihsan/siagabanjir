import 'package:flutter/material.dart';

import '../../../../shared/theme/siaga_theme.dart';

// Mengelompokkan satu tugas form dengan tipografi dan jarak setara kartu home.
class BagianLaporan extends StatelessWidget {
  const BagianLaporan({
    super.key,
    required this.title,
    this.hint,
    required this.child,
  });

  final String title;
  final String? hint;
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: SiagaTheme.border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Heading membantu pembaca layar melompat antarbagian form.
        Semantics(
          header: true,
          child: Text(title, style: Theme.of(context).textTheme.titleMedium),
        ),
        if (hint != null) ...[
          const SizedBox(height: 4),
          Text(
            hint!,
            style: const TextStyle(
              fontSize: 14,
              height: 1.4,
              color: SiagaTheme.mutedOnTint,
            ),
          ),
        ],
        const SizedBox(height: 12),
        child,
      ],
    ),
  );
}
