import 'package:flutter/material.dart';

import '../../../shared/theme/siaga_theme.dart';
import 'login_screen.dart';
import 'widgets/login_header.dart';
import 'widgets/register_card.dart';
import 'widgets/register_footer.dart';

// Layar Pendaftaran Akun Baru (Register) SiagaBanjir sesuai spesifikasi desain auth_register.svg.
// Memfasilitasi pendaftaran warga baru untuk memantau debit air dan melaporkan kondisi banjir secara cepat.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    super.key,
    this.onRegisterSuccess,
    this.onLogin,
    this.onTermsAndPrivacy,
    this.onGoogleSignUp,
  });

  final ValueChanged<String>? onRegisterSuccess;
  final VoidCallback? onLogin;
  final VoidCallback? onTermsAndPrivacy;
  final VoidCallback? onGoogleSignUp;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _scroll = ScrollController();
  final _nameController = TextEditingController();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _agreedToTerms = true;

  @override
  void dispose() {
    _scroll.dispose();
    _nameController.dispose();
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
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

  void _handleSubmit() {
    final name = _nameController.text.trim();
    final identifier = _identifierController.text.trim();
    final password = _passwordController.text;

    if (name.isEmpty) {
      _showFeedback('Nama lengkap (KTP) wajib diisi.');
      return;
    }

    if (identifier.isEmpty) {
      _showFeedback('Nomor ponsel atau email wajib diisi.');
      return;
    }

    if (password.isEmpty) {
      _showFeedback('Kata sandi akun wajib diisi.');
      return;
    }

    if (!_agreedToTerms) {
      _showFeedback('Anda harus menyetujui Ketentuan Layanan & Privasi.');
      return;
    }

    _showFeedback('Pendaftaran berhasil untuk $name.');
    widget.onRegisterSuccess?.call(name);
  }

  void _handleLogin() {
    if (widget.onLogin != null) {
      widget.onLogin!();
    } else if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (ctx) => const LoginScreen(),
        ),
      );
    }
  }

  void _handleTermsAndPrivacy() {
    if (widget.onTermsAndPrivacy != null) {
      widget.onTermsAndPrivacy!();
    } else {
      showDialog<void>(
        context: context,
        builder: (dialogCtx) => AlertDialog(
          title: const Text('Ketentuan Layanan & Privasi'),
          content: const SingleChildScrollView(
            child: Text(
              'Dengan mendaftar SiagaBanjir, Anda menyetujui penggunaan data pribadi '
              'secara aman untuk koordinasi kesiapsiagaan darurat banjir dan pelaporan warga.',
            ),
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(dialogCtx).pop(),
              child: const Text('Tutup'),
            ),
          ],
        ),
      );
    }
  }

  void _handleGoogleSignUp() {
    if (widget.onGoogleSignUp != null) {
      widget.onGoogleSignUp!();
    } else {
      _showFeedback('Pendaftaran akun dengan akun Google.');
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
            key: const PageStorageKey('register-scroll'),
            controller: _scroll,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const LoginHeader(),
                const SizedBox(height: 24),
                RegisterCard(
                  nameController: _nameController,
                  identifierController: _identifierController,
                  passwordController: _passwordController,
                  agreedToTerms: _agreedToTerms,
                  onAgreedToTermsChanged: (val) {
                    setState(() => _agreedToTerms = val);
                  },
                  onSubmit: _handleSubmit,
                  onTermsAndPrivacy: _handleTermsAndPrivacy,
                  onGoogleSignUp: _handleGoogleSignUp,
                ),
                const SizedBox(height: 28),
                RegisterFooter(onLogin: _handleLogin),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
