import 'package:flutter/material.dart';
import 'package:siagabanjir/shared/widgets/local_icon.dart';

import '../../../shared/theme/siaga_theme.dart';
import 'aksi_beranda.dart';

class PanelAksesFitur extends StatelessWidget {
  const PanelAksesFitur({super.key, required this.action});

  final AksiBeranda action;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: BoxConstraints(
      maxHeight: MediaQuery.sizeOf(context).height * .85,
    ),
    child: SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        24,
        0,
        24,
        24 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              LocalIcon(action.icon, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  action.title,
                  style: const TextStyle(
                    fontSize: SiagaTheme.judulHalaman,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                tooltip: 'Tutup daftar fitur',
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'SEMUA FITUR',
            style: TextStyle(
              color: SiagaTheme.blue,
              fontWeight: FontWeight.w700,
              fontSize: SiagaTheme.keterangan,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(action.description),
          const SizedBox(height: 16),
          if (action == AksiBeranda.all)
            for (final destination in AksiBeranda.values.where(
              (item) =>
                  item != AksiBeranda.all && item != AksiBeranda.notifications,
            ))
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: LocalIcon(destination.icon),
                title: Text(destination.title),
                trailing: const LocalIcon('chevron', size: 18),
                onTap: () => Navigator.pop(context, destination),
              ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kembali ke Beranda'),
          ),
        ],
      ),
    ),
  );
}
