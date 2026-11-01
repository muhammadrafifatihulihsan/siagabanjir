import 'package:flutter/material.dart';

/// Wadah halaman admin dengan lebar baca dan jarak yang konsisten.
class HalamanAdmin extends StatelessWidget {
  const HalamanAdmin({super.key, required this.children, this.maxWidth = 1200});

  final List<Widget> children;
  final double maxWidth;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => SingleChildScrollView(
      primary: false,
      padding: EdgeInsets.all(constraints.maxWidth < 600 ? 16 : 24),
      child: Align(
        alignment: Alignment.topLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
      ),
    ),
  );
}

class JudulAdmin extends StatelessWidget {
  const JudulAdmin(this.title, {super.key, this.description});
  final String title;
  final String? description;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Semantics(
        header: true,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1E3A8A),
          ),
        ),
      ),
      if (description != null) ...[
        const SizedBox(height: 8),
        Text(
          description!,
          style: const TextStyle(
            fontSize: 14,
            height: 1.4,
            color: Color(0xFF475569),
          ),
        ),
      ],
      const SizedBox(height: 24),
    ],
  );
}

/// Pasangan isian menjadi satu kolom saat ruang/ukuran teks memerlukannya.
class KolomAdaptifAdmin extends StatelessWidget {
  const KolomAdaptifAdmin({super.key, required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final scale = MediaQuery.textScalerOf(context).scale(14) / 14;
      final wide = constraints.maxWidth / scale >= 640;
      return Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          for (final child in children)
            SizedBox(
              width: wide
                  ? (constraints.maxWidth - 16) / 2
                  : constraints.maxWidth,
              child: child,
            ),
        ],
      );
    },
  );
}
