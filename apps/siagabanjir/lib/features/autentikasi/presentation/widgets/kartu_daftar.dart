import 'package:flutter/material.dart';

import '../../../../shared/theme/siaga_theme.dart';
import 'tombol_masuk_google.dart';

// Kartu formulir putih utama halaman pendaftaran akun baru sesuai desain SVG auth_register.
// Mengelola input nama lengkap KTP, nomor ponsel/email, kata sandi akun,
// persetujuan ketentuan layanan, serta aksi daftar dan pendaftaran via Google.
class KartuDaftar extends StatefulWidget {
  const KartuDaftar({
    super.key,
    required this.nameController,
    required this.identifierController,
    required this.passwordController,
    required this.agreedToTerms,
    required this.onAgreedToTermsChanged,
    required this.onSubmit,
    required this.onTermsAndPrivacy,
    required this.onGoogleSignUp,
  });

  final TextEditingController nameController;
  final TextEditingController identifierController;
  final TextEditingController passwordController;
  final bool agreedToTerms;
  final ValueChanged<bool> onAgreedToTermsChanged;
  final VoidCallback onSubmit;
  final VoidCallback onTermsAndPrivacy;
  final VoidCallback onGoogleSignUp;

  @override
  State<KartuDaftar> createState() => _KartuDaftarState();
}

class _KartuDaftarState extends State<KartuDaftar> {
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
          'Daftar Akun Baru',
          style: TextStyle(
            fontSize: SiagaTheme.judulHalaman,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0F172A),
            height: 1.2,
          ),
        ),
        const SizedBox(height: 6),
        // Subjudul tujuan
        const Text(
          'Daftar untuk pantau air dan lapor banjir cepat.',
          style: TextStyle(
            fontSize: SiagaTheme.isi,
            fontWeight: FontWeight.w400,
            color: SiagaTheme.muted,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 22),

        // Input 1: Nama Lengkap (KTP)
        const Text(
          'Nama Lengkap (KTP)',
          style: TextStyle(
            fontSize: SiagaTheme.isi,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 8),
        _buildTextField(
          controller: widget.nameController,
          hintText: 'Rahmat Hidayat',
          prefixIcon: Icons.person_outline_rounded,
          keyboardType: TextInputType.name,
          semanticLabel: 'Nama Lengkap (KTP)',
        ),
        const SizedBox(height: 16),

        // Input 2: Nomor Ponsel atau Email
        const Text(
          'Nomor Ponsel atau Email',
          style: TextStyle(
            fontSize: SiagaTheme.isi,
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

        // Input 3: Kata Sandi Akun
        const Text(
          'Kata Sandi Akun',
          style: TextStyle(
            fontSize: SiagaTheme.isi,
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
          semanticLabel: 'Kata Sandi Akun',
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
        const SizedBox(height: 16),

        // Persetujuan Ketentuan Layanan & Privasi (Checkbox + Tautan Aksesibel)
        InkWell(
          onTap: () => widget.onAgreedToTermsChanged(!widget.agreedToTerms),
          borderRadius: BorderRadius.circular(6),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 22,
                  height: 22,
                  child: Checkbox(
                    value: widget.agreedToTerms,
                    activeColor: const Color(0xFF2563EB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    side: const BorderSide(
                      color: Color(0xFFCBD5E1),
                      width: 1.5,
                    ),
                    onChanged: (val) {
                      if (val != null) widget.onAgreedToTermsChanged(val);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Text(
                        'Saya setuju ',
                        style: TextStyle(
                          fontSize: SiagaTheme.isi,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF334155),
                        ),
                      ),
                      Semantics(
                        button: true,
                        label: 'Ketentuan Layanan & Privasi, buka dokumen syarat dan privasi',
                        child: InkWell(
                          onTap: widget.onTermsAndPrivacy,
                          borderRadius: BorderRadius.circular(4),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 2,
                              vertical: 2,
                            ),
                            child: Text(
                              'Ketentuan Layanan & Privasi',
                              style: TextStyle(
                                fontSize: SiagaTheme.isi,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF2563EB),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Tombol Utama: Daftar ke SiagaBanjir >
        Semantics(
          button: true,
          label: 'Daftar ke SiagaBanjir',
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
                      'Daftar ke SiagaBanjir',
                      style: TextStyle(
                        fontSize: SiagaTheme.judulBagian,
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
                  fontSize: SiagaTheme.keterangan,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF64748B),
                ),
              ),
            ),
            Expanded(child: Divider(color: Color(0xFFE2E8F0), thickness: 1)),
          ],
        ),
        const SizedBox(height: 18),

        // Tombol Pendaftaran dengan Google
        TombolMasukGoogle(onPressed: widget.onGoogleSignUp),
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
        fontSize: SiagaTheme.isi,
        fontWeight: FontWeight.w600,
        color: Color(0xFF0F172A),
      ),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: SiagaTheme.isi,
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
