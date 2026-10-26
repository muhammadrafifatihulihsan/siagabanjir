import 'package:flutter/material.dart';

import '../../../../shared/theme/siaga_theme.dart';
import 'tombol_masuk_google.dart';

// Kartu formulir putih utama halaman login sesuai desain SVG auth_login.
// Mengelola input nomor ponsel/email, kata sandi, toggle sembunyikan sandi,
// checkbox ingat saya, serta aksi submit dan opsi pihak ketiga.
class KartuMasuk extends StatefulWidget {
  const KartuMasuk({
    super.key,
    required this.identifierController,
    required this.passwordController,
    required this.rememberMe,
    required this.onRememberMeChanged,
    required this.onSubmit,
    required this.onForgotPassword,
    required this.onGoogleSignIn,
  });

  final TextEditingController identifierController;
  final TextEditingController passwordController;
  final bool rememberMe;
  final ValueChanged<bool> onRememberMeChanged;
  final VoidCallback onSubmit;
  final VoidCallback onForgotPassword;
  final VoidCallback onGoogleSignIn;

  @override
  State<KartuMasuk> createState() => _KartuMasukState();
}

class _KartuMasukState extends State<KartuMasuk> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: const Color(0xFFE2E8F0)),
      borderRadius: BorderRadius.circular(22),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0A0F172A),
          blurRadius: 16,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Judul section formulir
        const Text(
          'Masuk ke Akun',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0F172A),
            height: 1.2,
          ),
        ),
        const SizedBox(height: 6),
        // Subjudul tujuan
        const Text(
          'Pantau debit sungai dan lapor kondisi banjir.',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: SiagaTheme.muted,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 22),

        // Input 1: Nomor Ponsel atau Email
        const Text(
          'Nomor Ponsel atau Email',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 8),
        _buildTextField(
          controller: widget.identifierController,
          hintText: '081234567890',
          prefixIcon: Icons.phone_outlined,
          keyboardType: TextInputType.emailAddress,
          semanticLabel: 'Nomor Ponsel atau Email',
        ),
        const SizedBox(height: 16),

        // Input 2: Kata Sandi atau PIN
        const Text(
          'Kata Sandi atau PIN',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 8),
        _buildTextField(
          controller: widget.passwordController,
          hintText: 'rahasia123',
          prefixIcon: Icons.lock_outline_rounded,
          obscureText: _obscurePassword,
          semanticLabel: 'Kata Sandi atau PIN',
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              size: 20,
              color: const Color(0xFF64748B),
            ),
            tooltip: _obscurePassword
                ? 'Tampilkan kata sandi'
                : 'Sembunyikan kata sandi',
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
        ),
        const SizedBox(height: 14),

        // Baris Ingat Saya & Lupa Sandi? (Wrap agar adaptif saat teks membesar 2.0x)
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          runSpacing: 8,
          children: [
            // Checkbox Ingat Saya
            InkWell(
              onTap: () => widget.onRememberMeChanged(!widget.rememberMe),
              borderRadius: BorderRadius.circular(6),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 22,
                      height: 22,
                      child: Checkbox(
                        value: widget.rememberMe,
                        activeColor: const Color(0xFF2563EB),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        side: const BorderSide(
                          color: Color(0xFFCBD5E1),
                          width: 1.5,
                        ),
                        onChanged: (val) {
                          if (val != null) widget.onRememberMeChanged(val);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Ingat Saya',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Tautan Lupa Sandi?
            Semantics(
              button: true,
              label: 'Lupa Sandi, buka pemulihan akun',
              child: InkWell(
                onTap: widget.onForgotPassword,
                borderRadius: BorderRadius.circular(4),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: Text(
                    'Lupa Sandi?',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2563EB),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),

        // Tombol Utama: Masuk ke SiagaBanjir >
        Semantics(
          button: true,
          label: 'Masuk ke SiagaBanjir',
          child: SizedBox(
            height: 48,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onPressed: widget.onSubmit,
              child: const FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Masuk ke SiagaBanjir',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 20,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),

        // Pemisah: 'atau'
        const Row(
          children: [
            Expanded(child: Divider(color: Color(0xFFE2E8F0), thickness: 1)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'atau',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF64748B),
                ),
              ),
            ),
            Expanded(child: Divider(color: Color(0xFFE2E8F0), thickness: 1)),
          ],
        ),
        const SizedBox(height: 18),

        // Tombol Google
        TombolMasukGoogle(onPressed: widget.onGoogleSignIn),
      ],
    ),
  );

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    required String semanticLabel,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
  }) => Semantics(
    textField: true,
    label: semanticLabel,
    child: TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF0F172A),
      ),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xFF94A3B8),
        ),
        prefixIcon: Icon(prefixIcon, size: 20, color: const Color(0xFF64748B)),
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
        ),
      ),
    ),
  );
}
