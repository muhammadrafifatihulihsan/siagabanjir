import 'package:flutter/material.dart';
import 'package:siagabanjir/shared/widgets/local_icon.dart';

import '../../../shared/theme/siaga_theme.dart';
import 'home_action.dart';

class HomePreviewSheet extends StatelessWidget {
  const HomePreviewSheet({super.key, required this.action});

  final HomeAction action;

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
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                tooltip: 'Tutup pratinjau',
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'PRATINJAU FITUR',
            style: TextStyle(
              color: SiagaTheme.blue,
              fontWeight: FontWeight.w700,
              fontSize: 12,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(action.description),
          const SizedBox(height: 16),
          if (action == HomeAction.profile) ...[
            FilledButton.icon(
              onPressed: () => Navigator.pop(context, HomeAction.profile),
              icon: const Icon(Icons.person_outline),
              label: const Text('Buka Halaman Profil Lengkap'),
            ),
            const SizedBox(height: 12),
          ],
          if (action == HomeAction.all)
            for (final destination in HomeAction.values.where(
              (item) =>
                  item != HomeAction.all && item != HomeAction.notifications,
            ))
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: LocalIcon(destination.icon),
                title: Text(destination.title),
                trailing: const LocalIcon('chevron', size: 18),
                onTap: () => Navigator.pop(context, destination),
              ),
          if (action == HomeAction.notifications) ...[
            const ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('Contoh pembaruan wilayah'),
              subtitle: Text(
                'Informasi Sungai Batang Kuranji pada kartu adalah data sintetis.',
              ),
            ),
            const ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('Contoh pengingat tas siaga'),
              subtitle: Text(
                'Periksa kembali kebutuhan perlengkapan keluarga.',
              ),
            ),
            const ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('Contoh pengingat dokumen'),
              subtitle: Text(
                'Angka 3/3 hanya ilustrasi, bukan berkas yang tersimpan.',
              ),
            ),
          ],
          const Text(
            'Demo tampilan lokal. Belum terhubung ke layanan atau data akun.',
            style: TextStyle(fontSize: 12, color: SiagaTheme.muted),
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
