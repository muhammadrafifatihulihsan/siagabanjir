import '../../bantuan_sesi.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siagabanjir/features/beranda/presentation/panel_akses_fitur.dart';
import 'package:siagabanjir/features/pantau/data/pantau_repository.dart';
import 'package:siagabanjir/features/pantau/presentation/layar_pantau_wilayah.dart';
import 'package:siagabanjir/features/pantau/presentation/widgets/kartu_pantau_wilayah.dart';
import 'package:siagabanjir/shared/widgets/header_halaman.dart';

class _RepoPantauPalsu extends PantauRepository {
  _RepoPantauPalsu(this.items, {this.galat, DateTime? serverTime})
    : serverTime = serverTime ?? DateTime(2026, 11, 3, 10);

  final List<ItemPantauPublik> items;
  final Object? galat;
  final DateTime serverTime;
  int panggilan = 0;

  @override
  Future<HasilPantauPublik> ambilRingkasanPantau({
    String? query,
    String? section,
    String? cursor,
  }) async {
    panggilan++;
    if (galat != null) throw galat!;
    return HasilPantauPublik(
      items: items,
      nextCursor: null,
      serverTime: serverTime,
    );
  }
}

ItemPantauPublik _klaster({
  String id = 'g-1',
  String nama = 'Kecamatan Kuranji',
  String tingkat = 'HIGH',
  int jumlah = 3,
  String? ringkasan = '3 laporan aktif · 2 sesuai bukti.',
  String? ringkasanAi = 'Sebagian besar laporan menyebut jalan utama terendam.',
  double? latitude = -0.924,
  double? longitude = 100.362,
}) => ItemPantauPublik(
  id: id,
  namaLokasi: nama,
  tingkat: tingkat,
  waktuPembaruan: DateTime(2026, 11, 3, 9, 55),
  statusReview: 'NEEDS_REVIEW',
  jumlahLaporan: jumlah,
  ringkasan: ringkasan,
  ringkasanAi: ringkasanAi,
  latitude: latitude,
  longitude: longitude,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    final fonts = FontLoader('Inter');
    for (final weight in [
      'Regular',
      'Medium',
      'SemiBold',
      'Bold',
      'ExtraBold',
    ]) {
      fonts.addFont(rootBundle.load('assets/fonts/inter/Inter-$weight.otf'));
    }
    await fonts.load();
  });

  Future<void> pumpScreen(
    WidgetTester tester, {
    required PantauRepository repository,
    Size size = const Size(390, 844),
    double textScale = 1.0,
    VoidCallback? onHome,
    VoidCallback? onReport,
    VoidCallback? onHistory,
    VoidCallback? onProfile,
    Future<bool> Function(double, double)? bukaPeta,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    tester.platformDispatcher.textScaleFactorTestValue = textScale;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await tester.pumpWidget(
      MaterialApp(
        home: LayarPantauWilayah(
          pantauRepository: repository,
          onHome: onHome,
          onReport: onReport,
          onHistory: onHistory,
          onProfile: onProfile,
          bukaPeta: bukaPeta,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('LayarPantauWilayah sebagai umpan peringatan banjir', () {
    testWidgets('menampilkan klaster, ringkasan agregasi, dan narasi AI', (
      tester,
    ) async {
      await pumpScreen(tester, repository: _RepoPantauPalsu([_klaster()]));

      expect(find.byType(HeaderHalaman), findsOneWidget);
      expect(find.text('Pantau Wilayah'), findsOneWidget);
      expect(find.byType(KartuPantauWilayah), findsOneWidget);
      expect(find.text('Kecamatan Kuranji'), findsOneWidget);
      expect(find.text('TINGGI'), findsOneWidget);
      expect(find.textContaining('3 laporan aktif'), findsOneWidget);
      expect(find.textContaining('perlu tinjauan petugas'), findsOneWidget);
      expect(find.text('Kesimpulan AI'), findsOneWidget);
      expect(
        find.textContaining('Sebagian besar laporan menyebut'),
        findsOneWidget,
      );
      expect(find.textContaining('1 klaster terpantau'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('menyembunyikan blok AI jika ringkasan AI belum tersedia', (
      tester,
    ) async {
      await pumpScreen(
        tester,
        repository: _RepoPantauPalsu([_klaster(ringkasanAi: null)]),
      );

      expect(find.byType(KartuPantauWilayah), findsOneWidget);
      expect(find.text('Kesimpulan AI'), findsNothing);
    });

    testWidgets('tautan peta memakai koordinat klaster', (tester) async {
      var dipanggil = 0;
      double? latDiterima;
      double? lonDiterima;
      await pumpScreen(
        tester,
        repository: _RepoPantauPalsu([_klaster()]),
        bukaPeta: (lat, lon) async {
          dipanggil++;
          latDiterima = lat;
          lonDiterima = lon;
          return true;
        },
      );

      await tester.tap(find.text('Buka di Google Maps'));
      await tester.pumpAndSettle();

      expect(dipanggil, 1);
      expect(latDiterima, -0.924);
      expect(lonDiterima, 100.362);
    });

    testWidgets('klaster tanpa koordinat tidak menampilkan tautan peta', (
      tester,
    ) async {
      await pumpScreen(
        tester,
        repository: _RepoPantauPalsu([
          _klaster(latitude: null, longitude: null),
        ]),
      );

      expect(find.byType(KartuPantauWilayah), findsOneWidget);
      expect(find.text('Buka di Google Maps'), findsNothing);
    });

    testWidgets('kegagalan jaringan menampilkan pesan jujur', (tester) async {
      await pumpScreen(
        tester,
        repository: _RepoPantauPalsu(const [], galat: Exception('offline')),
      );

      expect(find.text('Umpan Belum Tersedia'), findsOneWidget);
      expect(find.textContaining('Periksa koneksi'), findsOneWidget);
      expect(find.byType(KartuPantauWilayah), findsNothing);
    });

    testWidgets('tanpa klaster aktif menampilkan keadaan kosong', (
      tester,
    ) async {
      await pumpScreen(tester, repository: _RepoPantauPalsu(const []));

      expect(find.text('Belum Ada Peringatan Aktif'), findsOneWidget);
      expect(find.textContaining('0 klaster terpantau'), findsOneWidget);
    });

    testWidgets('pull-to-refresh memuat ulang umpan', (tester) async {
      final repo = _RepoPantauPalsu([_klaster()]);
      await pumpScreen(tester, repository: repo);
      expect(repo.panggilan, 1);

      await tester.fling(find.byType(ListView), const Offset(0, 320), 1200);
      await tester.pumpAndSettle();

      expect(repo.panggilan, greaterThan(1));
    });

    testWidgets('navigasi bawah memicu callback yang sesuai', (tester) async {
      var reportTapped = false;
      var historyTapped = false;
      var profileTapped = false;
      var homeTapped = false;

      await pumpScreen(
        tester,
        repository: _RepoPantauPalsu([_klaster()]),
        onHome: () => homeTapped = true,
        onReport: () => reportTapped = true,
        onHistory: () => historyTapped = true,
        onProfile: () => profileTapped = true,
      );

      await tester.tap(find.text('Lapor'));
      await tester.pumpAndSettle();
      expect(reportTapped, isTrue);

      await tester.tap(find.text('Riwayat'));
      await tester.pumpAndSettle();
      expect(historyTapped, isTrue);

      await tester.tap(find.text('Profil'));
      await tester.pumpAndSettle();
      expect(profileTapped, isTrue);

      await tester.tap(find.text('Beranda'));
      await tester.pumpAndSettle();
      expect(homeTapped, isTrue);
    });

    testWidgets('tombol kembali memicu onHome', (tester) async {
      var backTapped = false;
      await pumpScreen(
        tester,
        repository: _RepoPantauPalsu([_klaster()]),
        onHome: () => backTapped = true,
      );

      await tester.tap(find.bySemanticsLabel('Kembali'));
      await tester.pumpAndSettle();

      expect(backTapped, isTrue);
    });

    testWidgets('tidak overflow pada layar sempit dengan teks 2.0x', (
      tester,
    ) async {
      await pumpScreen(
        tester,
        repository: _RepoPantauPalsu([_klaster()]),
        size: const Size(320, 640),
        textScale: 2.0,
      );

      expect(find.byType(LayarPantauWilayah), findsOneWidget);
      expect(find.text('Pantau Wilayah'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Pantau Wilayah terbuka tanpa pratinjau dari beranda', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(aplikasiWargaTerautentikasi());
      await tester.pumpAndSettle();

      final target = find.text('Pantau Wilayah');
      await tester.ensureVisible(target);
      await tester.pumpAndSettle();
      await tester.tap(target);
      await tester.pumpAndSettle();

      expect(find.byType(PanelAksesFitur), findsNothing);
      expect(find.byType(LayarPantauWilayah), findsOneWidget);
      expect(find.text('Belum Ada Peringatan Aktif'), findsOneWidget);

      await tester.tap(find.bySemanticsLabel('Kembali'));
      await tester.pumpAndSettle();

      expect(find.byType(LayarPantauWilayah), findsNothing);
      expect(find.text('SiagaBanjir'), findsOneWidget);
    });
  });

  group('ItemPantauPublik.fromJson', () {
    test('memetakan atribut umpan dan menolak koordinat mustahil', () {
      final item = ItemPantauPublik.fromJson({
        'id': 'g-9',
        'locationName': 'Koto Tangah',
        'level': 'MEDIUM',
        'updatedAt': '2026-11-03T03:00:00.000Z',
        'reviewState': 'REVIEWED',
        'reportCount': 4,
        'summary': 'ringkasan agregasi',
        'aiSummary': null,
        'latitude': -0.95,
        'longitude': 100.36,
      });

      expect(item.id, 'g-9');
      expect(item.jumlahLaporan, 4);
      expect(item.ringkasan, 'ringkasan agregasi');
      expect(item.ringkasanAi, isNull);
      expect(item.punyaKoordinat, isTrue);
      expect(item.latitude, -0.95);
    });

    test('koordinat di luar rentang diabaikan agar peta tidak salah titik', () {
      final item = ItemPantauPublik.fromJson({
        'id': 'g-10',
        'locationName': 'Klaster Uji',
        'level': 'LOW',
        'updatedAt': '2026-11-03T03:00:00.000Z',
        'reviewState': 'REVIEWED',
        'latitude': 190,
        'longitude': -400,
      });

      expect(item.punyaKoordinat, isFalse);
      expect(item.latitude, isNull);
      expect(item.longitude, isNull);
    });

    test('label waktu relatif memakai bahasa Indonesia', () {
      final sekarang = DateTime(2026, 11, 3, 10);
      String label(Duration mundur) =>
          labelWaktuRelatif(sekarang.subtract(mundur), sekarang: sekarang);

      expect(label(const Duration(seconds: 20)), 'baru saja');
      expect(label(const Duration(minutes: 5)), '5 mnt lalu');
      expect(label(const Duration(hours: 3)), '3 jam lalu');
      expect(label(const Duration(days: 2)), '2 hari lalu');
    });
  });
}
