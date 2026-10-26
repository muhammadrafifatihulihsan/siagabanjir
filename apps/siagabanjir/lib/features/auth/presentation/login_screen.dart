import 'package:flutter/material.dart';

import '../../../shared/theme/siaga_theme.dart';
import 'register_screen.dart';
import 'widgets/login_card.dart';
import 'widgets/login_footer.dart';
import 'widgets/login_header.dart';

// Layar Masuk ke Akun (Login) SiagaBanjir sesuai spesifikasi desain auth_login.svg.
// Memfasilitasi autentikasi warga untuk mengakses fitur pelaporan dan dokumen siaga.
class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    this.onLoginSuccess,
    this.onRegister,
    this.onForgotPassword,
    this.onGoogleLogin,
  });

  final ValueChanged<String>? onLoginSuccess;
  final VoidCallback? onRegister;
  final VoidCallback? onForgotPassword;
  final VoidCallback? onGoogleLogin;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _scroll = ScrollController();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = true;

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
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleSubmit() {
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

    _showFeedback('Berhasil masuk sebagai $identifier.');
    widget.onLoginSuccess?.call(identifier);
  }

  void _handleForgotPassword() {
    if (widget.onForgotPassword != null) {
      widget.onForgotPassword!();
    } else {
      _showFeedback('Fitur pemulihan kata sandi atau PIN.');
    }
  }

  void _handleGoogleLogin() {
    if (widget.onGoogleLogin != null) {
      widget.onGoogleLogin!();
    } else {
      _showFeedback('Autentikasi dengan akun Google.');
    }
  }

  void _handleRegister() {
    if (widget.onRegister != null) {
      widget.onRegister!();
    } else {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (ctx) => RegisterScreen(
            onLogin: () => Navigator.of(ctx).pop(),
            onRegisterSuccess: (user) {
              Navigator.of(ctx).pop();
              _showFeedback('Akun $user berhasil didaftarkan. Silakan masuk.');
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
                const LoginHeader(),
                const SizedBox(height: 24),
                LoginCard(
                  identifierController: _identifierController,
                  passwordController: _passwordController,
                  rememberMe: _rememberMe,
                  onRememberMeChanged: (val) {
                    setState(() => _rememberMe = val);
                  },
                  onSubmit: _handleSubmit,
                  onForgotPassword: _handleForgotPassword,
                  onGoogleSignIn: _handleGoogleLogin,
                ),
                const SizedBox(height: 28),
                LoginFooter(onRegister: _handleRegister),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
