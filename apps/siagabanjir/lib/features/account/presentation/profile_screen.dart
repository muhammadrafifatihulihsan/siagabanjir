import 'package:flutter/material.dart';

import '../../../shared/theme/siaga_theme.dart';
import '../../../shared/widgets/citizen_header.dart';
import '../../auth/presentation/login_screen.dart';
import '../../home/presentation/home_action.dart';
import '../../home/presentation/widgets/home_navigation.dart';
import '../domain/user_profile.dart';
import 'widgets/account_settings_section.dart';
import 'widgets/emergency_contacts_section.dart';
import 'widgets/logout_button.dart';
import 'widgets/profile_header_card.dart';
import 'widgets/profile_info_section.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.onOpen,
    required this.onHome,
    this.initialProfile = UserProfile.defaultMock,
  });

  final ValueChanged<HomeAction> onOpen;
  final VoidCallback onHome;
  final UserProfile initialProfile;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _scroll = ScrollController();
  late bool _floodAlertEnabled;

  @override
  void initState() {
    super.initState();
    _floodAlertEnabled = widget.initialProfile.floodAlertEnabled;
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _backToTop() {
    if (MediaQuery.disableAnimationsOf(context)) {
      _scroll.jumpTo(0);
    } else {
      _scroll.animateTo(
        0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  void _showFeedback(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _confirmLogout() {
    showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Keluar dari Akun?'),
        content: const Text(
          'Anda dapat masuk kembali kapan saja untuk mengakses dokumen siaga dan riwayat laporan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
            ),
            onPressed: () {
              Navigator.of(dialogContext).pop(true);
            },
            child: const Text('Keluar'),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true && mounted) {
        _showFeedback('Berhasil keluar dari akun.');
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (ctx) =>
                LoginScreen(onLoginSuccess: (user) => Navigator.of(ctx).pop()),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            children: [
              CitizenHeader(
                onNotifications: () => widget.onOpen(HomeAction.notifications),
              ),
              Expanded(
                child: SingleChildScrollView(
                  key: const PageStorageKey('profile-scroll'),
                  controller: _scroll,
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Profil Pengguna',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: SiagaTheme.ink,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ProfileHeaderCard(
                        profile: widget.initialProfile,
                        onEdit: () => _showFeedback(
                          'Fitur edit profil siap dihubungkan ke formulir akun.',
                        ),
                      ),
                      const SizedBox(height: 20),
                      ProfileInfoSection(profile: widget.initialProfile),
                      const SizedBox(height: 20),
                      EmergencyContactsSection(
                        contacts: widget.initialProfile.contacts,
                        onAddContact: () =>
                            _showFeedback('Tambah kontak darurat keluarga.'),
                        onCallContact: (contact) => _showFeedback(
                          'Menghubungi ${contact.name} (${contact.phone})...',
                        ),
                      ),
                      const SizedBox(height: 20),
                      AccountSettingsSection(
                        floodAlertEnabled: _floodAlertEnabled,
                        appVersion: widget.initialProfile.appVersion,
                        onToggleFloodAlert: (val) {
                          setState(() => _floodAlertEnabled = val);
                          _showFeedback(
                            val
                                ? 'Peringatan siaga banjir diaktifkan.'
                                : 'Peringatan siaga banjir dinonaktifkan.',
                          );
                        },
                        onSecurity: () =>
                            _showFeedback('Menu keamanan & kata sandi.'),
                        onHelpFaq: () => _showFeedback('Pusat bantuan & FAQ.'),
                        onPrivacy: () =>
                            _showFeedback('Kebijakan privasi data warga.'),
                        onVersionTap: () => _showFeedback(
                          'SiagaBanjir ${widget.initialProfile.appVersion}',
                        ),
                      ),
                      const SizedBox(height: 20),
                      LogoutButton(onLogout: _confirmLogout),
                    ],
                  ),
                ),
              ),
              HomeNavigation(
                currentAction: HomeAction.profile,
                onOpen: (action) {
                  if (action == HomeAction.profile) {
                    _backToTop();
                  } else {
                    widget.onOpen(action);
                  }
                },
                onHome: widget.onHome,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
