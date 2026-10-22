import 'package:flutter/material.dart';

import '../../../../shared/theme/siaga_theme.dart';
import '../home_action.dart';
import 'home_icon.dart';

class HomeQuickAccess extends StatelessWidget {
  const HomeQuickAccess({super.key, required this.onOpen});

  final ValueChanged<HomeAction> onOpen;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final columns =
          constraints.maxWidth / MediaQuery.textScalerOf(context).scale(1) >=
              260
          ? 2
          : 1;
      final tiles = [
        _tile(
          HomeAction.monitor,
          'Pos Air',
          'Cek genangan & tinggi air',
          const Color(0xFFD6F0FF),
          const Color(0xFFBAE6FD),
          const Color(0xFF0369A1),
        ),
        _tile(
          HomeAction.contacts,
          '24 Jam',
          'Posko BPBD & SAR 24 jam',
          const Color(0xFFFFEEEE),
          const Color(0xFFFECACA),
          const Color(0xFFB91C1C),
        ),
        _tile(
          HomeAction.bag,
          'Checklist',
          'Checklist logistik darurat',
          const Color(0xFFEDE9FE),
          const Color(0xFFDDD6FE),
          const Color(0xFF5145CD),
        ),
        _tile(
          HomeAction.guides,
          'Panduan',
          'Panduan evakuasi warga',
          const Color(0xFFDCF0E2),
          const Color(0xFFBBE5C9),
          const Color(0xFF15803D),
        ),
      ];
      return Column(
        children: [
          for (var i = 0; i < tiles.length; i += columns) ...[
            if (i > 0) const SizedBox(height: 12),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: tiles[i]),
                  if (columns == 2) ...[
                    const SizedBox(width: 12),
                    Expanded(child: tiles[i + 1]),
                  ],
                ],
              ),
            ),
          ],
        ],
      );
    },
  );

  Widget _tile(
    HomeAction action,
    String badge,
    String description,
    Color background,
    Color border,
    Color accent,
  ) => Semantics(
    button: true,
    child: Material(
      color: background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: BorderSide(color: border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => onOpen(action),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 128),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(child: HomeIcon(action.icon)),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: border,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            badge,
                            style: TextStyle(
                              fontSize: 11,
                              height: 1.2,
                              fontWeight: FontWeight.w700,
                              color: accent,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Text(
                  action.title,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.2,
                    fontWeight: FontWeight.w700,
                    color: SiagaTheme.ink,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.35,
                    color: Color(0xFF475569),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
