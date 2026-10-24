import 'package:flutter/material.dart';
import 'package:siagabanjir/shared/widgets/citizen_header.dart';
import 'package:siagabanjir/shared/widgets/local_icon.dart';

import '../../../shared/theme/siaga_theme.dart';

/// Local design preview; no device, account, or submission service is attached.
class ReportCreateScreen extends StatefulWidget {
  const ReportCreateScreen({
    super.key,
    required this.onNotifications,
    required this.onHistory,
    required this.onProfile,
  });

  final VoidCallback onNotifications;
  final VoidCallback onHistory;
  final VoidCallback onProfile;

  @override
  State<ReportCreateScreen> createState() => _ReportCreateScreenState();
}

class _ReportCreateScreenState extends State<ReportCreateScreen> {
  final _description = TextEditingController();
  String _category = 'Luapan Sungai';
  final _needs = <String>{'Perahu Karet', 'Evakuasi Balita'};
  bool _dirty = false;

  @override
  void dispose() {
    _description.dispose();
    super.dispose();
  }

  Future<void> _explain(String title, String message) => showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Mengerti'),
        ),
      ],
    ),
  );

  Future<void> _leave() async {
    if (_dirty) {
      final discard = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Keluar dari laporan?'),
          content: const Text(
            'Isian pratinjau ini belum disimpan. Jika keluar, isian akan dihapus.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Lanjut mengisi'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Keluar'),
            ),
          ],
        ),
      );
      if (discard != true || !mounted) return;
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !_dirty,
    onPopInvokedWithResult: (didPop, result) {
      if (!didPop) _leave();
    },
    child: Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: [
                CitizenHeader(onNotifications: widget.onNotifications),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Lapor Kejadian Banjir',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Foto kondisi air untuk membantu peninjauan laporan.',
                          style: TextStyle(
                            fontSize: 14,
                            color: SiagaTheme.mutedOnTint,
                          ),
                        ),
                        const SizedBox(height: 18),
                        _card([
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 22,
                            ),
                            decoration: BoxDecoration(
                              color: SiagaTheme.background,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFFBFDBFE),
                              ),
                            ),
                            child: const Column(
                              children: [
                                CircleAvatar(
                                  radius: 26,
                                  backgroundColor: Color(0xFFDBEAFE),
                                  child: Icon(
                                    Icons.camera_alt_outlined,
                                    color: SiagaTheme.blue,
                                    size: 28,
                                  ),
                                ),
                                SizedBox(height: 14),
                                Text(
                                  'Ambil Foto Langsung di Lokasi',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Ambil foto kondisi di tempat kejadian untuk melengkapi laporan.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: SiagaTheme.mutedOnTint,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          _outline(
                            'Buka Kamera Ponsel',
                            Icons.camera_alt_outlined,
                            () => _explain(
                              'Kamera belum tersedia',
                              'Halaman ini masih pratinjau desain. Kamera dan lampiran foto belum dihubungkan.',
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFECFDF5),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: const Color(0xFFA7F3D0),
                              ),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.shield_outlined,
                                  size: 20,
                                  color: Color(0xFF047857),
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Gunakan foto langsung dari lokasi. Pemilihan galeri belum tersedia.',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF065F46),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]),
                        _card([
                          _title('Titik Lokasi Kejadian'),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: SiagaTheme.border),
                            ),
                            child: const Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  color: Color(0xFFDC2626),
                                  size: 22,
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Jl. Dr. Moh. Hatta No. 42, Koto Tangah, Padang',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(height: 6),
                                      Text(
                                        'Lokasi contoh • GPS belum diambil',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: SiagaTheme.mutedOnTint,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          _outline(
                            'Sinkronisasi Lokasi GPS',
                            Icons.sync,
                            () => _explain(
                              'GPS belum tersedia',
                              'Alamat yang tampil adalah contoh desain. Lokasi perangkat belum dibaca.',
                            ),
                          ),
                        ]),
                        _card([
                          _title('Kategori Luapan Banjir'),
                          const SizedBox(height: 8),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final stacked =
                                  constraints.maxWidth /
                                      MediaQuery.textScalerOf(context)
                                          .scale(1) <
                                  270;
                              final choices = [
                                'Luapan Sungai',
                                'Banjir Bandang',
                                'Genangan Hujan',
                              ];
                              return Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  for (final value in choices)
                                    SizedBox(
                                      width: stacked
                                          ? constraints.maxWidth
                                          : (constraints.maxWidth - 16) / 3,
                                      child: _choice(
                                        value,
                                        _category == value,
                                        () => setState(() {
                                          _category = value;
                                          _dirty = true;
                                        }),
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                        ]),
                        _card([
                          _title('Kebutuhan Evakuasi Mendesak'),
                          const SizedBox(height: 8),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final stacked =
                                  constraints.maxWidth /
                                      MediaQuery.textScalerOf(context)
                                          .scale(1) <
                                  250;
                              return Wrap(
                                spacing: 10,
                                runSpacing: 8,
                                children: [
                                  for (final value in [
                                    'Perahu Karet',
                                    'Evakuasi Balita',
                                    'Bantuan Logistik',
                                    'Medis Darurat',
                                  ])
                                    SizedBox(
                                      width: stacked
                                          ? constraints.maxWidth
                                          : (constraints.maxWidth - 10) / 2,
                                      child: _choice(
                                        value,
                                        _needs.contains(value),
                                        () => setState(() {
                                          if (!_needs.add(value)) {
                                            _needs.remove(value);
                                          }
                                          _dirty = true;
                                        }),
                                        checkbox: true,
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                        ]),
                        _card([
                          _title('Deskripsi Tambahan'),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _description,
                            onChanged: (_) => setState(() => _dirty = true),
                            minLines: 3,
                            maxLines: 6,
                            maxLength: 2000,
                            decoration: InputDecoration(
                              hintText:
                                  'Ceritakan kondisi di lokasi kejadian...',
                              hintStyle: const TextStyle(
                                fontSize: 14,
                                color: SiagaTheme.mutedOnTint,
                              ),
                              filled: true,
                              fillColor: const Color(0xFFF1F5F9),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(
                                  color: SiagaTheme.border,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(
                                  color: SiagaTheme.border,
                                ),
                              ),
                            ),
                          ),
                        ]),
                        FilledButton.icon(
                          onPressed: () => _explain(
                            'Laporan belum dikirim',
                            'Ini pratinjau desain. Pengiriman dan penyimpanan draf belum tersedia. Isian hanya ada selama halaman ini terbuka.',
                          ),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          icon: const Icon(Icons.send_outlined, size: 20),
                          label: const Text(
                            'Kirim Laporan Banjir',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Pratinjau desain. Laporan belum disimpan atau dikirim.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: SiagaTheme.mutedOnTint,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 4, 18, 12),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE1EDFF),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _nav('Beranda', 'home', _leave),
                        _nav('Lapor', 'camera', () {}, selected: true),
                        _nav('Riwayat', 'history', widget.onHistory),
                        _nav('Profil', 'profile', widget.onProfile),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  Widget _title(String text) => Text(
    text,
    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
  );

  Widget _card(List<Widget> children) => Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: SiagaTheme.border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    ),
  );

  Widget _outline(String label, IconData icon, VoidCallback onPressed) =>
      OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(48, 48),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          backgroundColor: const Color(0xFFEFF6FF),
          foregroundColor: const Color(0xFF1D4ED8),
          side: const BorderSide(color: Color(0xFFBFDBFE)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      );

  Widget _choice(
    String label,
    bool selected,
    VoidCallback onTap, {
    bool checkbox = false,
  }) => Semantics(
    selected: checkbox ? null : selected,
    checked: checkbox ? selected : null,
    button: !checkbox,
    label: label,
    onTap: onTap,
    child: ExcludeSemantics(
      child: Material(
        color: selected ? const Color(0xFFEFF6FF) : const Color(0xFFF1F5F9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(
            color: selected ? const Color(0xFF93C5FD) : SiagaTheme.border,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 54),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  if (checkbox) ...[
                    Icon(
                      selected
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      size: 22,
                      color: selected ? SiagaTheme.blue : SiagaTheme.muted,
                    ),
                    const SizedBox(width: 6),
                  ],
                  Expanded(
                    child: Text(
                      label,
                      textAlign: checkbox ? TextAlign.start : TextAlign.center,
                      style: TextStyle(
                        fontSize: checkbox ? 14 : 12,
                        fontWeight: FontWeight.w700,
                        color: selected
                            ? const Color(0xFF1D4ED8)
                            : SiagaTheme.ink,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );

  Widget _nav(
    String label,
    String icon,
    VoidCallback onTap, {
    bool selected = false,
  }) => Expanded(
    child: Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: selected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LocalIcon(icon),
                const SizedBox(height: 5),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: selected ? SiagaTheme.blue : SiagaTheme.mutedOnTint,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
