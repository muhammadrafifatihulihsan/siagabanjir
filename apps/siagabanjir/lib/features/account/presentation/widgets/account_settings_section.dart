import 'package:flutter/material.dart';

import '../../../../shared/theme/siaga_theme.dart';

class AccountSettingsSection extends StatelessWidget {
  const AccountSettingsSection({
    super.key,
    required this.floodAlertEnabled,
    required this.appVersion,
    required this.onToggleFloodAlert,
    required this.onSecurity,
    required this.onHelpFaq,
    required this.onPrivacy,
    required this.onVersionTap,
  });

  final bool floodAlertEnabled;
  final String appVersion;
  final ValueChanged<bool> onToggleFloodAlert;
  final VoidCallback onSecurity;
  final VoidCallback onHelpFaq;
  final VoidCallback onPrivacy;
  final VoidCallback onVersionTap;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Pengaturan & Akun',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: SiagaTheme.ink,
        ),
      ),
      const SizedBox(height: 12),
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: SiagaTheme.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  _iconBox(Icons.notifications_none_rounded),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Text(
                      'Peringatan Siaga Banjir',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: SiagaTheme.ink,
                      ),
                    ),
                  ),
                  Switch.adaptive(
                    value: floodAlertEnabled,
                    activeTrackColor: SiagaTheme.blue,
                    onChanged: onToggleFloodAlert,
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFF1F5F9), indent: 64),
            _menuTile(
              icon: Icons.lock_outline_rounded,
              title: 'Keamanan & Kata Sandi',
              onTap: onSecurity,
              trailing: const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF94A3B8),
                size: 22,
              ),
            ),
            const Divider(height: 1, color: Color(0xFFF1F5F9), indent: 64),
            _menuTile(
              icon: Icons.help_outline_rounded,
              title: 'Pusat Bantuan & FAQ',
              onTap: onHelpFaq,
              trailing: const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF94A3B8),
                size: 22,
              ),
            ),
            const Divider(height: 1, color: Color(0xFFF1F5F9), indent: 64),
            _menuTile(
              icon: Icons.shield_outlined,
              title: 'Kebijakan Privasi Data',
              onTap: onPrivacy,
              trailing: const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF94A3B8),
                size: 22,
              ),
            ),
            const Divider(height: 1, color: Color(0xFFF1F5F9), indent: 64),
            _menuTile(
              icon: Icons.info_outline_rounded,
              title: 'Versi Aplikasi',
              onTap: onVersionTap,
              trailing: Text(
                appVersion,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: SiagaTheme.muted,
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );

  static Widget _iconBox(IconData icon) => Container(
    width: 36,
    height: 36,
    decoration: BoxDecoration(
      color: const Color(0xFFEFF6FF),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Icon(icon, size: 18, color: SiagaTheme.blue),
  );

  Widget _menuTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required Widget trailing,
  }) => Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            _iconBox(icon),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: SiagaTheme.ink,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Flexible(child: trailing),
          ],
        ),
      ),
    ),
  );
}
