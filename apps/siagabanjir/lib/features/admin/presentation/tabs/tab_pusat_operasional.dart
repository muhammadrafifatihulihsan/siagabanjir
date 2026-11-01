import 'package:flutter/material.dart';

import '../../../../shared/widgets/dialog_siaga.dart';
import '../../../kontak/presentation/models/entri_kontak.dart';
import '../../../pesan/presentation/models/pesan_siaga.dart';
import '../../domain/state_admin_siaga.dart';
import '../widgets/tata_letak_admin.dart';

class TabPusatOperasional extends StatefulWidget {
  const TabPusatOperasional({super.key, required this.state});

  final StateAdminSiaga state;

  @override
  State<TabPusatOperasional> createState() => _TabPusatOperasionalState();
}

class _TabPusatOperasionalState extends State<TabPusatOperasional> {
  int _activeSubIndex = 0;

  // Controllers untuk Siaran Peringatan
  final _judulPesanController = TextEditingController();
  final _isiPesanController = TextEditingController();
  final _instansiController = TextEditingController(
    text: 'PUSDALOPS BPBD Kota Padang',
  );
  KategoriPesan _kategoriPesanPilihan = KategoriPesan.emergency;

  // Controllers untuk Kontak Posko
  final _namaKontakController = TextEditingController();
  final _nomorKontakController = TextEditingController();
  final _ketKontakController = TextEditingController();

  @override
  void dispose() {
    _judulPesanController.dispose();
    _isiPesanController.dispose();
    _instansiController.dispose();
    _namaKontakController.dispose();
    _nomorKontakController.dispose();
    _ketKontakController.dispose();
    super.dispose();
  }

  void _kirimSiaran() {
    final judul = _judulPesanController.text.trim();
    final isi = _isiPesanController.text.trim();
    final instansi = _instansiController.text.trim();

    if (judul.isEmpty || isi.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Judul dan isi peringatan wajib diisi.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final String badgeLabel;
    final Color badgeBg;
    final Color badgeText;
    final Color? stripe;

    switch (_kategoriPesanPilihan) {
      case KategoriPesan.emergency:
        badgeLabel = 'Darurat • Siaga 2';
        badgeBg = const Color(0xFFFEE2E2);
        badgeText = const Color(0xFFDC2626);
        stripe = const Color(0xFFDC2626);
        break;
      case KategoriPesan.weather:
        badgeLabel = 'Cuaca BMKG';
        badgeBg = const Color(0xFFD7EFFF);
        badgeText = const Color(0xFF0284C7);
        stripe = const Color(0xFFD97706);
        break;
      case KategoriPesan.all:
        badgeLabel = 'Informasi Posko';
        badgeBg = const Color(0xFFF1F5F9);
        badgeText = const Color(0xFF475569);
        stripe = const Color(0xFF2563EB);
        break;
    }

    final waktu =
        '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')} WIB';

    final pesanBaru = PesanSiaga(
      id: 'MSG-${DateTime.now().millisecondsSinceEpoch}',
      category: _kategoriPesanPilihan,
      badgeLabel: badgeLabel,
      badgeBackground: badgeBg,
      badgeTextColor: badgeText,
      leftStripeColor: stripe,
      timestamp: waktu,
      agency: instansi.isEmpty ? 'BPBD Kota Padang' : instansi,
      title: judul,
      body: isi,
      actions: const ['Bagikan'],
      isNew: true,
    );

    widget.state.terbitkanPeringatanBaru(pesanBaru);
    _judulPesanController.clear();
    _isiPesanController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Peringatan siaga berhasil disiarkan.'),
        backgroundColor: Color(0xFF1D4ED8),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _tambahKontakPosko() {
    final nama = _namaKontakController.text.trim();
    final nomor = _nomorKontakController.text.trim();
    final ket = _ketKontakController.text.trim();

    if (nama.isEmpty || nomor.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nama posko dan nomor telepon wajib diisi.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    widget.state.tambahKontakPosko(
      EntriKontak(
        name: nama,
        agency: 'Posko Siaga Bencana Lapangan',
        phone: nomor,
        description: ket.isEmpty ? 'Posko Siaga Lapangan' : ket,
        category: KategoriKontak.emergency,
        accentColor: const Color(0xFFDC2626),
      ),
    );

    _namaKontakController.clear();
    _nomorKontakController.clear();
    _ketKontakController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Kontak posko berhasil ditambahkan.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return HalamanAdmin(
      maxWidth: 960,
      children: [
        const JudulAdmin('Pusat Aksi'),
        // Sub-Tab Segmented Selector
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildSubTabItem(0, 'Siaran Peringatan', Icons.campaign_outlined),
            const SizedBox(width: 8),
            _buildSubTabItem(1, 'Kontak Posko', Icons.phone_in_talk_outlined),
            const SizedBox(width: 8),
            _buildSubTabItem(2, 'Kebijakan Kuota', Icons.tune_rounded),
          ],
        ),
        const SizedBox(height: 24),

        // Content Pane berdasarkan Sub-Tab Terpilih
        if (_activeSubIndex == 0) _buildSubTabSiaranPeringatan(),
        if (_activeSubIndex == 1) _buildSubTabKontakPosko(),
        if (_activeSubIndex == 2) _buildSubTabKebijakanKuota(),
      ],
    );
  }

  Widget _buildSubTabItem(int index, String label, IconData icon) {
    final isSelected = _activeSubIndex == index;
    const palette = [
      (Color(0xFFD6F0FF), Color(0xFFBAE6FD), Color(0xFF0369A1)),
      (Color(0xFFDCF0E2), Color(0xFFBBE5C9), Color(0xFF15803D)),
      (Color(0xFFEDE9FE), Color(0xFFDDD6FE), Color(0xFF5145CD)),
    ];
    final colors = palette[index];
    return ChoiceChip(
      label: Text(label),
      avatar: Icon(icon, size: 20, color: colors.$3),
      showCheckmark: false,
      labelStyle: TextStyle(color: colors.$3, fontWeight: FontWeight.w600),
      side: BorderSide(color: isSelected ? colors.$3 : colors.$2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      backgroundColor: Colors.white,
      selectedColor: colors.$1,
      checkmarkColor: const Color(0xFF1D4ED8),
      selected: isSelected,
      onSelected: (_) => setState(() => _activeSubIndex = index),
    );
  }

  // --- SUB-TAB 1: SIARAN PERINGATAN DARURAT ---
  Widget _buildSubTabSiaranPeringatan() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Form Terbitkan Siaran
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Siaran Baru',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E3A8A),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Kirim peringatan ke kotak masuk warga.',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 16),

              // Pilihan Kategori Peringatan
              const Text(
                'Kategori',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildRadioKategori(
                    KategoriPesan.emergency,
                    'Darurat',
                    const Color(0xFFDC2626),
                  ),
                  _buildRadioKategori(
                    KategoriPesan.weather,
                    'Cuaca BMKG',
                    const Color(0xFF0284C7),
                  ),
                  _buildRadioKategori(
                    KategoriPesan.all,
                    'Informasi Posko',
                    const Color(0xFF475569),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Input Judul
              TextField(
                controller: _judulPesanController,
                decoration: InputDecoration(
                  labelText: 'Judul peringatan',
                  hintText: 'Contoh: Banjir di Koto Tangah',
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Input Isi Pesan
              TextField(
                controller: _isiPesanController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Isi peringatan',
                  hintText: 'Tuliskan kondisi dan arahan untuk warga.',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

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
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: _kirimSiaran,
                  icon: const Icon(Icons.send_outlined, size: 18),
                  label: const Text(
                    'Kirim Siaran',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Daftar Peringatan yang Sedang Mengudara
        const Text(
          'Siaran Aktif',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1E3A8A),
          ),
        ),
        const SizedBox(height: 12),
        ...widget.state.pesanSiaga.map((msg) => _buildPesanItem(msg)),
      ],
    );
  }

  Widget _buildRadioKategori(KategoriPesan kat, String label, Color color) {
    final isSelected = _kategoriPesanPilihan == kat;
    return ChoiceChip(
      label: Text(label),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      selectedColor: const Color(0xFFEFF6FF),
      checkmarkColor: const Color(0xFF1D4ED8),
      selected: isSelected,
      onSelected: (_) => setState(() => _kategoriPesanPilihan = kat),
    );
  }

  Widget _buildPesanItem(PesanSiaga msg) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  msg.title,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E3A8A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${msg.agency} • ${msg.timestamp}',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  msg.body,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: Color(0xFF334155),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFDC2626),
              side: const BorderSide(color: Color(0xFFFECACA)),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            ),
            onPressed: () {
              widget.state.cabutPeringatan(msg.id);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Peringatan telah dicabut.')),
              );
            },
            child: const Text(
              'Cabut',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- SUB-TAB 2: KONTAK DARURAT & POSKO ---
  Widget _buildSubTabKontakPosko() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Form Tambah Kontak Posko
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tambah Kontak Posko',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E3A8A),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Nomor ini akan terdaftar di direktori kontak darurat warga Kota Padang.',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 16),
              KolomAdaptifAdmin(
                children: [
                  TextField(
                    controller: _namaKontakController,
                    decoration: InputDecoration(
                      isDense: true,
                      labelText: 'Nama Posko / Instansi',
                      hintText: 'Contoh: Posko Evakuasi SMPN 13 Koto Tangah',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  TextField(
                    controller: _nomorKontakController,
                    decoration: InputDecoration(
                      isDense: true,
                      labelText: 'Nomor Telepon / WhatsApp',
                      hintText: 'Contoh: 0812-9988-7766',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _ketKontakController,
                decoration: InputDecoration(
                  isDense: true,
                  labelText: 'Keterangan Wilayah Layanan',
                  hintText: 'Contoh: Melayani evakuasi dan logistik wilayah Lubuk Buaya sekitarnya',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: _tambahKontakPosko,
                  icon: const Icon(Icons.add_call, size: 16),
                  label: const Text(
                    'Simpan Kontak',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // List Kontak Terdaftar
        const Text(
          'Kontak Publik',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1E3A8A),
          ),
        ),
        const SizedBox(height: 12),
        ...widget.state.kontakDarurat.map(
          (k) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.phone_rounded,
                    color: Color(0xFF2563EB),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        k.name,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E3A8A),
                        ),
                      ),
                      Text(
                        '${k.phone} • ${k.agency}',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Hapus kontak',
                  icon: const Icon(
                    Icons.delete_outline,
                    size: 18,
                    color: Color(0xFFDC2626),
                  ),
                  onPressed: () {
                    widget.state.hapusKontakPosko(k.name);
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- SUB-TAB 3: KEBIJAKAN KUOTA & SAKELAR GALERI ---
  Widget _buildSubTabKebijakanKuota() {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pengaturan Laporan',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E3A8A),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Atur sumber foto dan batas pengiriman per akun.',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 20),

            // Sakelar Galeri
            SwitchListTile(
              title: const Text(
                'Izinkan Foto dari Galeri HP',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: const Text(
                'Jika nonaktif, foto laporan harus diambil melalui kamera.',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: Color(0xFF64748B),
                ),
              ),
              value: widget.state.izinkanGaleri,
              activeTrackColor: const Color(0xFF2563EB),
              onChanged: (val) {
                widget.state.setIzinkanGaleri(val);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Kebijakan galeri diubah ke: ${val ? "Boleh Galeri" : "Wajib Kamera"}',
                    ),
                  ),
                );
              },
            ),
            const Divider(height: 24),

            // Batas Kuota Warga
            ListTile(
              title: const Text(
                'Batas Kuota Laporan Warga',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Text(
                'Saat ini: ${widget.state.kuotaMaksimal} laporan per ${widget.state.kuotaRentangJam} jam per akun.',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: Color(0xFF64748B),
                ),
              ),
              trailing: FilledButton.tonal(
                onPressed: () {
                  final kuotaCtrl = TextEditingController(
                    text: widget.state.kuotaMaksimal.toString(),
                  );
                  final jamCtrl = TextEditingController(
                    text: widget.state.kuotaRentangJam.toString(),
                  );
                  showDialog<void>(
                    context: context,
                    builder: (ctx) => DialogSiaga(
                      title: const Text(
                        'Ubah Parameter Kuota',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: kuotaCtrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Maks Laporan',
                            ),
                          ),
                          TextField(
                            controller: jamCtrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Rentang Jam',
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text(
                            'Batal',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        FilledButton(
                          onPressed: () {
                            widget.state.setKuotaPengaturan(
                              int.tryParse(kuotaCtrl.text) ?? 3,
                              int.tryParse(jamCtrl.text) ?? 6,
                            );
                            Navigator.pop(ctx);
                          },
                          child: const Text(
                            'Simpan',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text(
                  'Ubah Kuota',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const Divider(height: 24),

            // Tombol Reset Kuota Darurat
            ListTile(
              title: const Text(
                'Reset Kuota Darurat',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFDC2626),
                ),
              ),
              subtitle: const Text(
                'Gunakan jika bencana meluas agar warga dapat melapor kembali tanpa hambatan kuota.',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: Color(0xFF64748B),
                ),
              ),
              trailing: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFDC2626),
                  side: const BorderSide(color: Color(0xFFFECACA)),
                ),
                onPressed: () {
                  widget.state.resetSemuaKuota();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Semua kuota akun warga telah direset.'),
                    ),
                  );
                },
                child: const Text(
                  'Reset Kuota',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
