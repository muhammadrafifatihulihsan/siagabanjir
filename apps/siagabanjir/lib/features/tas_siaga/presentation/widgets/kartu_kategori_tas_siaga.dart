import 'package:flutter/material.dart';

import '../../../../shared/theme/siaga_theme.dart';
import '../models/barang_tas_siaga.dart';

// Kartu kategori barang tas siaga dengan item checklist interaktif.
class KartuKategoriTasSiaga extends StatelessWidget {
  const KartuKategoriTasSiaga({
    super.key,
    required this.category,
    required this.items,
    required this.onToggleItem,
  });

  final KategoriTasSiaga category;
  final List<BarangTasSiaga> items;
  final ValueChanged<String> onToggleItem;

  int get _checkedCount => items.where((i) => i.isChecked).length;
  int get _totalCount => items.length;
  bool get _isAllChecked => _checkedCount == _totalCount;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: SiagaTheme.border),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(category.icon, size: 20, color: category.iconColor),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                category.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: SiagaTheme.ink,
                ),
              ),
            ),
            Text(
              '$_checkedCount/$_totalCount',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: _isAllChecked
                    ? const Color(0xFF64748B)
                    : const Color(0xFFD97706),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) const SizedBox(height: 10),
          _buildItemRow(items[i]),
        ],
      ],
    ),
  );

  Widget _buildItemRow(BarangTasSiaga item) => Semantics(
    label: item.title,
    checked: item.isChecked,
    button: true,
    child: InkWell(
      onTap: () => onToggleItem(item.id),
      borderRadius: BorderRadius.circular(10),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: item.isChecked
                      ? const Color(0xFFECFDF5)
                      : Colors.white,
                  border: Border.all(
                    color: item.isChecked
                        ? const Color(0xFF10B981)
                        : const Color(0xFFCBD5E1),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: item.isChecked
                    ? const Icon(
                        Icons.check_rounded,
                        size: 16,
                        color: Color(0xFF10B981),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.35,
                    color: item.isChecked
                        ? const Color(0xFF334155)
                        : const Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
