import 'package:flutter/material.dart';

import '../../domain/profil_admin.dart';
import '../../domain/state_admin_siaga.dart';

class TabPengaturanProfil extends StatefulWidget {
  const TabPengaturanProfil({
    super.key,
    required this.state,
  });

  final StateAdminSiaga state;

  @override
  State<TabPengaturanProfil> createState() => _TabPengaturanProfilState();
}

class _TabPengaturanProfilState extends State<TabPengaturanProfil> {
  late final TextEditingController _namaController;
  late final TextEditingController _nipController;
  late final TextEditingController _jabatanController;
  late final TextEditingController _instansiController;
  late final TextEditingController _emailController;
  late final TextEditingController _teleponController;

  final _sandiLamaController = TextEditingController();
  final _sandiBaruController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final p = widget.state.profilAdmin;
    _namaController = TextEditingController(text: p.nama);
    _nipController = TextEditingController(text: p.nip);
    _jabatanController = TextEditingController(text: p.jabatan);
    _instansiController = TextEditingController(text: p.instansi);
    _emailController = TextEditingController(text: p.email);
    _teleponController = TextEditingController(text: p.teleponPosko);
  }

  @override
  void dispose() {
    _namaController.dispose();
    _nipController.dispose();
    _jabatanController.dispose();
    _instansiController.dispose();
    _emailController.dispose();
    _teleponController.dispose();
    _sandiLamaController.dispose();
    _sandiBaruController.dispose();
    super.dispose();
  }

  void _simpanProfil() {
    final baru = ProfilAdmin(
      nama: _namaController.text.trim(),
      nip: _nipController.text.trim(),
      jabatan: _jabatanController.text.trim(),
      instansi: _instansiController.text.trim(),
      email: _emailController.text.trim(),
      teleponPosko: _teleponController.text.trim(),
    );

    widget.state.updateProfilAdmin(baru);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profil petugas BPBD berhasil diperbarui.'),
        backgroundColor: Color(0xFF059669),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _ubahSandi() {
    if (_sandiBaruController.text.trim().length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kata sandi baru minimal 6 karakter.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    _sandiLamaController.clear();
    _sandiBaruController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Kata sandi akun admin berhasil diganti.'),
        backgroundColor: Color(0xFF059669),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Judul
          const Text(
            'Pengaturan Profil & Akun Petugas BPBD',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Kelola identitas resmi petugas Pusdalops yang bertanggung jawab atas penanganan bencana dan verifikasi laporan.',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 24),

          // Kartu Biodata Petugas
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: const Color(0xFF2563EB),
                      child: Text(
                        _namaController.text.isNotEmpty
                            ? _namaController.text[0]
                            : 'A',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _namaController.text,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _jabatanController.text,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2563EB),
                            ),
                          ),
                          Text(
                            _instansiController.text,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Divider(color: Color(0xFFF1F5F9)),
                const SizedBox(height: 16),

                // Form Field Baris 1
                Row(
                  children: [
                    Expanded(
                      child: _buildInput(
                        controller: _namaController,
                        label: 'Nama Lengkap Petugas',
                        icon: Icons.person_outline,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildInput(
                        controller: _nipController,
                        label: 'NIP / Nomor Identitas Pegawai',
                        icon: Icons.badge_outlined,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Form Field Baris 2
                Row(
                  children: [
                    Expanded(
                      child: _buildInput(
                        controller: _jabatanController,
                        label: 'Jabatan Struktural',
                        icon: Icons.work_outline,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildInput(
                        controller: _instansiController,
                        label: 'Instansi Pemerintah',
                        icon: Icons.account_balance_outlined,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Form Field Baris 3
                Row(
                  children: [
                    Expanded(
                      child: _buildInput(
                        controller: _emailController,
                        label: 'Email Dinas Resmi',
                        icon: Icons.email_outlined,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildInput(
                        controller: _teleponController,
                        label: 'Nomor Telepon Hotline / Posko',
                        icon: Icons.phone_outlined,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),

                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _simpanProfil,
                    icon: const Icon(Icons.check_rounded, size: 18),
                    label: const Text(
                      'Simpan Pembaruan Profil',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Kartu Ganti Kata Sandi
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Keamanan & Sandi Akun Admin',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Perbarui kata sandi secara berkala untuk menjaga kerahasiaan akses kontrol siaga bencana.',
                  style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: _buildInput(
                        controller: _sandiLamaController,
                        label: 'Kata Sandi Lama',
                        icon: Icons.lock_outline,
                        obscureText: true,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildInput(
                        controller: _sandiBaruController,
                        label: 'Kata Sandi Baru',
                        icon: Icons.lock_reset_rounded,
                        obscureText: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                Align(
                  alignment: Alignment.centerRight,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF2563EB),
                      side: const BorderSide(color: Color(0xFF93C5FD)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onPressed: _ubahSandi,
                    icon: const Icon(Icons.password_rounded, size: 16),
                    label: const Text('Perbarui Kata Sandi'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscureText,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            isDense: true,
            prefixIcon: Icon(icon, size: 18, color: const Color(0xFF64748B)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }
}
