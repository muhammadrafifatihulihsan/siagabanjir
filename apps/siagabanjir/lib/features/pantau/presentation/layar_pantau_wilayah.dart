import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/perangkat/buka_peta.dart';
import '../../../shared/theme/siaga_theme.dart';
import '../../../shared/widgets/citizen_navigation.dart';
import '../../../shared/widgets/header_halaman.dart';
import '../../../shared/widgets/lingkup_navigasi.dart';
import '../data/pantau_repository.dart';
import 'widgets/kartu_pantau_wilayah.dart';

/// Umpan peringatan banjir warga: daftar klaster wilayah aktif beserta
/// kesimpulan agregasi, narasi AI (bila tersedia), dan tautan peta.
///
/// Data disegarkan otomatis setiap [selangPembaruan] (default 20 detik) dan
/// dapat ditarik manual lewat pull-to-refresh.
class LayarPantauWilayah extends StatefulWidget {
  const LayarPantauWilayah({
    super.key,
    this.onHome,
    this.onReport,
    this.onHistory,
    this.onProfile,
    this.pantauRepository,
    this.selangPembaruan = const Duration(seconds: 20),
    this.bukaPeta,
  });

  final VoidCallback? onHome;
  final VoidCallback? onReport;
  final VoidCallback? onHistory;
  final VoidCallback? onProfile;
  final PantauRepository? pantauRepository;
  final Duration selangPembaruan;
  final Future<bool> Function(double latitude, double longitude)? bukaPeta;

  @override
  State<LayarPantauWilayah> createState() => _LayarPantauWilayahState();
}

class _LayarPantauWilayahState extends State<LayarPantauWilayah> {
  late bool _isTest;
  Timer? _timer;
  bool _memuat = false;
  String? _galat;
  List<ItemPantauPublik> _items = const [];
  DateTime? _diperbarui;

  PantauRepository get _repo => widget.pantauRepository ?? PantauRepository();

  @override
  void initState() {
    super.initState();
    _isTest = WidgetsBinding.instance.runtimeType.toString().contains('Test');
    final bolehMemuat = !_isTest || widget.pantauRepository != null;
    if (bolehMemuat) {
      _memuat = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _muat());
    }
    // Polling dimatikan pada widget test agar tidak ada timer menggantung.
    if (!_isTest) {
      _timer = Timer.periodic(widget.selangPembaruan, (_) => _muat());
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _muat() async {
    if (!mounted) return;
    try {
      final hasil = await _repo.ambilRingkasanPantau();
      if (!mounted) return;
      setState(() {
        _items = hasil.items;
        _diperbarui = hasil.serverTime;
        _galat = null;
        _memuat = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _galat = 'Umpan peringatan belum dapat dimuat. Periksa koneksi lalu tarik untuk menyegarkan.';
        _memuat = false;
      });
    }
  }

  Future<void> _bukaPeta(ItemPantauPublik item) async {
    final latitude = item.latitude;
    final longitude = item.longitude;
    if (latitude == null || longitude == null) return;
    final buka = widget.bukaPeta ?? bukaPetaGoogle;
    final berhasil = await buka(latitude, longitude);
    if (!berhasil && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tautan peta tidak dapat dibuka pada perangkat ini.'),
        ),
      );
    }
  }

  void _onNavigationSelect(
    BuildContext context,
    CitizenDestination destination,
  ) {
    switch (destination) {
      case CitizenDestination.home:
        if (widget.onHome != null) {
          widget.onHome!();
        } else if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      case CitizenDestination.report:
        widget.onReport?.call();
      case CitizenDestination.history:
        widget.onHistory?.call();
      case CitizenDestination.profile:
        widget.onProfile?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SiagaTheme.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: [
                HeaderHalaman(
                  judul: 'Pantau Wilayah',
                  onBack: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    } else if (widget.onHome != null) {
                      widget.onHome!();
                    }
                  },
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _muat,
                    child: ListView(
                      key: const PageStorageKey('region-monitor-scroll'),
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      children: [
                        _ringkasanUmpan(),
                        const SizedBox(height: 16),
                        if (_memuat && _items.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 48),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        else if (_items.isEmpty)
                          _pesanKosong()
                        else ...[
                          if (_galat != null) _bannerGalat(),
                          for (final item in _items)
                            KartuPantauWilayah(
                              item: item,
                              sekarang: _diperbarui,
                              onBukaPeta: item.punyaKoordinat
                                  ? () => _bukaPeta(item)
                                  : null,
                            ),
                        ],
                      ],
                    ),
                  ),
                ),
                if (!LingkupNavigasi.aktif(context))
                  CitizenNavigation(
                    selected: CitizenDestination.home,
                    onSelect: (dest) => _onNavigationSelect(context, dest),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _ringkasanUmpan() {
    final jumlah = _items.length;
    final tinggi = _items.where((item) => item.tingkat == 'HIGH').length;
    final keterangan = _diperbarui == null
        ? 'Menghubungkan ke umpan peringatan…'
        : 'Diperbarui ${labelWaktuRelatif(_diperbarui!)} · otomatis setiap '
              '${widget.selangPembaruan.inSeconds} detik';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$jumlah klaster terpantau${tinggi > 0 ? ' · $tinggi berstatus TINGGI' : ''}',
            style: const TextStyle(
              fontSize: SiagaTheme.judulBagian,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E3A8A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            keterangan,
            style: const TextStyle(
              fontSize: SiagaTheme.keterangan,
              height: 1.4,
              color: Color(0xFF1D4ED8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bannerGalat() => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: const Color(0xFFFEF3C7),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      _galat!,
      style: const TextStyle(
        fontSize: SiagaTheme.keterangan,
        color: Color(0xFF92400E),
      ),
    ),
  );

  Widget _pesanKosong() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
    child: Column(
      children: [
        const Icon(Icons.waves_outlined, size: 64, color: Color(0xFF94A3B8)),
        const SizedBox(height: 16),
        Text(
          _galat == null
              ? 'Belum Ada Peringatan Aktif'
              : 'Umpan Belum Tersedia',
          style: const TextStyle(
            fontSize: SiagaTheme.judulHalaman,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E293B),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          _galat ??
              'Belum ada klaster banjir aktif yang dilaporkan warga. '
                  'Tarik ke bawah untuk menyegarkan.',
          style: const TextStyle(
            fontSize: SiagaTheme.isi,
            color: Color(0xFF64748B),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
