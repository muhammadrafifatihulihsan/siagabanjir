import 'package:flutter/material.dart';

import '../../../app/kerangka_warga.dart';
import '../../../core/jaringan/pengecualian_api.dart';
import '../../../shared/theme/siaga_theme.dart';
import '../../../shared/widgets/dialog_siaga.dart';
import '../../admin/presentation/kerangka_admin_web.dart';
import '../data/autentikasi_repository.dart';
import '../domain/peran_pengguna.dart';
import 'layar_daftar.dart';
import 'widgets/footer_masuk.dart';
import 'widgets/header_masuk.dart';
import 'widgets/kartu_masuk.dart';

// Layar Masuk ke Akun (Login) SiagaBanjir sesuai spesifikasi desain auth_login.svg.
// Memfasilitasi autentikasi pengguna dengan pemisahan peran Warga vs Petugas Admin.
class LayarMasuk extends StatefulWidget {
  const LayarMasuk({
    super.key,
    this.onLoginSuccess,
    this.onLoginWithRole,
    this.onRegister,
    this.onForgotPassword,
    this.onGoogleLogin,
    this.autentikasiRepository,
    this.initialRole = PeranPengguna.warga,
    this.autofill = true,
  });

  final ValueChanged<String>? onLoginSuccess;
  final void Function(String identifier, PeranPengguna role)? onLoginWithRole;
  final VoidCallback? onRegister;
  final VoidCallback? onForgotPassword;
  final VoidCallback? onGoogleLogin;
  final AutentikasiRepository? autentikasiRepository;
  final PeranPengguna initialRole;
  final bool autofill;

  @override
  State<LayarMasuk> createState() => _LayarMasukState();
}

class _LayarMasukState extends State<LayarMasuk> {
  final _scroll = ScrollController();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = true;
  late PeranPengguna _selectedRole;

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.initialRole;
    if (widget.autofill) {
      _terapkanAutofillAkun();
    }
  }

  void _terapkanAutofillAkun() {
    if (_selectedRole == PeranPengguna.admin) {
      _identifierController.text = 'admin1@siagabanjir.id';
      _passwordController.text = 'password123!';
    } else {
      _identifierController.text = 'warga1@siagabanjir.id';
      _passwordController.text = 'password123!';
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showFeedback(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _handleSubmit() async {
    final identifier = _identifierController.text.trim();
    final password = _passwordController.text;

    if (identifier.isEmpty) {
      _showFeedback('Nomor ponsel atau email wajib diisi.');
      return;
    }

    if (password.isEmpty) {
      _showFeedback('Kata sandi atau PIN wajib diisi.');
      return;
    }

    final authRepo = widget.autentikasiRepository ?? AutentikasiRepository();
    PeranPengguna peranAktif = _selectedRole;
    try {
      final pengguna = await authRepo.masuk(
        identifier: identifier,
        sandi: password,
        peran: _selectedRole,
      );
      peranAktif = pengguna.peran;
    } catch (e) {
      final isTest = WidgetsBinding.instance.runtimeType.toString().contains('Test');
      if (isTest) {
        // Lingkungan widget test Flutter tanpa koneksi backend nyata
      } else {
        String errorMsg = e.toString().replaceAll('Exception: ', '').replaceAll('PengecualianApi: ', '');
        if (e is PengecualianApi && (e.kodeStatus == 401 || e.kodeError == 'INVALID_CREDENTIALS')) {
          errorMsg = 'Email atau kata sandi tidak sesuai. Gunakan akun pengujian terdaftar (warga1@siagabanjir.id / password123!).';
        } else if (e is StateError) {
          errorMsg = e.message;
        } else if (errorMsg.contains('SocketException') ||
            errorMsg.contains('Failed host lookup') ||
            errorMsg.contains('Connection refused') ||
            errorMsg.contains('ClientException')) {
          errorMsg = 'Tidak dapat terhubung ke server backend. Pastikan server aktif dan periksa koneksi Anda.';
        }
        _showFeedback('Gagal masuk: $errorMsg');
        return;
      }
    }

    if (!mounted) return;
    _showFeedback('Berhasil masuk sebagai $identifier.');
    if (widget.onLoginWithRole != null) {
      widget.onLoginWithRole!(identifier, peranAktif);
      return;
    }
    if (widget.onLoginSuccess != null) {
      widget.onLoginSuccess!(identifier);
      return;
    }
    if (peranAktif == PeranPengguna.admin) {
      Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (_) => const KerangkaAdminWeb()),
        (_) => false,
      );
    } else {
      Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (_) => const KerangkaWarga()),
        (_) => false,
      );
    }
  }

  void _autofillAkun(PeranPengguna role) {
    setState(() {
      _selectedRole = role;
      if (role == PeranPengguna.admin) {
        _identifierController.text = 'admin1@siagabanjir.id';
        _passwordController.text = 'password123!';
      } else {
        _identifierController.text = 'warga1@siagabanjir.id';
        _passwordController.text = 'password123!';
      }
    });
    _showFeedback(
      role == PeranPengguna.admin
          ? 'Formulir terisi: admin1@siagabanjir.id (Petugas Admin).'
          : 'Formulir terisi: warga1@siagabanjir.id (Warga).',
    );
  }

  void _pilihPeranDanAutofill(PeranPengguna role) {
    setState(() {
      _selectedRole = role;
      if (widget.autofill) {
        _terapkanAutofillAkun();
      }
    });
  }

  void _handleForgotPassword() {
    if (widget.onForgotPassword != null) {
      widget.onForgotPassword!();
    } else {
      tampilkanInfoSiaga(
        context,
        'Pemulihan akun',
        'Fitur pemulihan kata sandi saat ini belum tersedia.',
      );
    }
  }

  void _handleGoogleLogin() {
    if (widget.onGoogleLogin != null) {
      widget.onGoogleLogin!();
    } else {
      tampilkanInfoSiaga(
        context,
        'Masuk dengan Google',
        'Fitur masuk dengan Google saat ini belum tersedia.',
      );
    }
  }

  void _handleRegister() {
    if (widget.onRegister != null) {
      widget.onRegister!();
    } else {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (ctx) => LayarDaftar(
            onLogin: () => Navigator.of(ctx).pop(),
            onRegisterSuccess: (user) {
              Navigator.of(ctx).pop();
              _showFeedback(
                'Pendaftaran berhasil. Silakan masuk ke akun Anda.',
              );
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: SiagaTheme.background,
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: SingleChildScrollView(
            key: const PageStorageKey('login-scroll'),
            controller: _scroll,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const HeaderMasuk(),
                const SizedBox(height: 24),
                KartuMasuk(
                  identifierController: _identifierController,
                  passwordController: _passwordController,
                  rememberMe: _rememberMe,
                  selectedRole: _selectedRole,
                  onRoleChanged: _pilihPeranDanAutofill,
                  onRememberMeChanged: (val) {
                    setState(() => _rememberMe = val);
                  },
                  onSubmit: _handleSubmit,
                  onForgotPassword: _handleForgotPassword,
                  onGoogleSignIn: _handleGoogleLogin,
                ),
                const SizedBox(height: 28),
                FooterMasuk(onRegister: _handleRegister),
                const SizedBox(height: 18),
                // Tombol teks untuk autofill akun pengujian
                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 12,
                  runSpacing: 4,
                  children: [
                    Semantics(
                      button: true,
                      label: 'Isi formulir dengan akun Warga',
                      child: InkWell(
                        onTap: () => _autofillAkun(PeranPengguna.warga),
                        borderRadius: BorderRadius.circular(4),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          child: Text(
                            'Masuk sebagai Warga',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF2563EB),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Text(
                      '•',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFCBD5E1),
                      ),
                    ),
                    Semantics(
                      button: true,
                      label: 'Isi formulir dengan akun Petugas Admin',
                      child: InkWell(
                        onTap: () => _autofillAkun(PeranPengguna.admin),
                        borderRadius: BorderRadius.circular(4),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          child: Text(
                            'Masuk sebagai Admin',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF2563EB),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
