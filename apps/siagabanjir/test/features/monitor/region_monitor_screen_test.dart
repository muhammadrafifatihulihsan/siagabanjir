import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siagabanjir/app/siaga_banjir_app.dart';
import 'package:siagabanjir/features/home/presentation/home_preview_sheet.dart';
import 'package:siagabanjir/features/monitor/presentation/region_monitor_screen.dart';
import 'package:siagabanjir/features/monitor/presentation/widgets/monitor_featured_card.dart';
import 'package:siagabanjir/features/monitor/presentation/widgets/monitor_header.dart';
import 'package:siagabanjir/features/monitor/presentation/widgets/monitor_infrastructure_card.dart';
import 'package:siagabanjir/features/monitor/presentation/widgets/monitor_river_posts_section.dart';
import 'package:siagabanjir/shared/widgets/citizen_navigation.dart';

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
    Size size = const Size(390, 844),
    double textScale = 1.0,
    VoidCallback? onHome,
    VoidCallback? onReport,
    VoidCallback? onHistory,
    VoidCallback? onProfile,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    tester.platformDispatcher.textScaleFactorTestValue = textScale;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await tester.pumpWidget(
      MaterialApp(
        home: RegionMonitorScreen(
          onHome: onHome,
          onReport: onReport,
          onHistory: onHistory,
          onProfile: onProfile,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('RegionMonitorScreen Unit & Widget Tests', () {
    testWidgets('Renders all main sections and components according to monitor_public.svg', (
      tester,
    ) async {
      await pumpScreen(tester);

      // 1. Header
      expect(find.byType(MonitorHeader), findsOneWidget);
      expect(find.text('Pantau Wilayah'), findsOneWidget);
      expect(find.byIcon(Icons.chevron_left), findsOneWidget);

      // 2. Featured card (Sungai Batang Kuranji)
      expect(find.byType(MonitorFeaturedCard), findsOneWidget);
      expect(find.text('Sungai Batang Kuranji'), findsNWidgets(2)); // featured + list item
      expect(find.text('Siaga 2'), findsNWidgets(2)); // featured + list item
      expect(find.text('140'), findsOneWidget);
      expect(find.text('cm Tinggi Air'), findsOneWidget);
      expect(find.text('▲ +20 cm'), findsOneWidget);
      expect(find.text('Normal: 0–99 cm'), findsOneWidget);
      expect(find.text('Waspada: 100–149 cm'), findsOneWidget);
      expect(find.text('Bahaya: 150+ cm'), findsOneWidget);
      expect(find.text('Batas luapan tanggul: 150 cm'), findsOneWidget);
      expect(find.text('Sisa 10 cm'), findsOneWidget);

      // 3. River posts section
      expect(find.byType(MonitorRiverPostsSection), findsOneWidget);
      expect(find.text('Pos Pantau Sungai'), findsOneWidget);
      expect(find.text('5 mnt lalu'), findsOneWidget);
      expect(find.text('Pos Kuranji • Sekitar Koto Tangah'), findsOneWidget);
      expect(find.text('Sungai Lubuk Kilangan'), findsOneWidget);
      expect(find.text('Pos Gadut • Tren naik lambat'), findsOneWidget);
      expect(find.text('110 cm'), findsOneWidget);
      expect(find.text('Siaga 3'), findsOneWidget);
      expect(find.text('Sungai Batang Arau'), findsOneWidget);
      expect(find.text('Pos Muaro • Aliran normal terkendali'), findsOneWidget);
      expect(find.text('95 cm'), findsOneWidget);
      expect(find.text('Normal'), findsOneWidget);

      // 4. Infrastructure section
      expect(find.byType(MonitorInfrastructureCard), findsOneWidget);
      expect(find.text('Status Pompa & Pintu Air'), findsOneWidget);
      expect(find.text('Pintu Air Pintu 3'), findsOneWidget);
      expect(find.text('Buka 60%'), findsOneWidget);
      expect(find.text('Pompa Mobile Kuranji'), findsOneWidget);
      expect(find.text('2 Unit Siap'), findsOneWidget);

      // 5. Citizen navigation bar
      expect(find.byType(CitizenNavigation), findsOneWidget);
      expect(find.text('Beranda'), findsOneWidget);
      expect(find.text('Lapor'), findsOneWidget);
      expect(find.text('Riwayat'), findsOneWidget);
      expect(find.text('Profil'), findsOneWidget);

      expect(tester.takeException(), isNull);
    });

    testWidgets('Header back button triggers onHome callback', (tester) async {
      var backTapped = false;
      await pumpScreen(
        tester,
        onHome: () {
          backTapped = true;
        },
      );

      final backButton = find.bySemanticsLabel('Kembali');
      expect(backButton, findsOneWidget);
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      expect(backTapped, isTrue);
    });

    testWidgets('CitizenNavigation triggers respective callbacks', (tester) async {
      var homeTapped = false;
      var reportTapped = false;
      var historyTapped = false;
      var profileTapped = false;

      await pumpScreen(
        tester,
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

    testWidgets('Home preview sheet opens RegionMonitorScreen via Buka Pantau Wilayah', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const SiagaBanjirApp());
      await tester.pumpAndSettle();

      // Tap "Pantau Wilayah" to open preview sheet
      final target = find.text('Pantau Wilayah');
      await tester.ensureVisible(target);
      await tester.pumpAndSettle();
      await tester.tap(target);
      await tester.pumpAndSettle();

      expect(find.byType(HomePreviewSheet), findsOneWidget);

      // Verify action button to open full monitor screen
      final openButton = find.text('Buka Pantau Wilayah');
      expect(openButton, findsOneWidget);

      await tester.tap(openButton);
      await tester.pumpAndSettle();

      // Screen RegionMonitorScreen should now be open
      expect(find.byType(RegionMonitorScreen), findsOneWidget);
      expect(find.text('Batas luapan tanggul: 150 cm'), findsOneWidget);

      // Pressing back returns to home
      final backBtn = find.bySemanticsLabel('Kembali');
      await tester.tap(backBtn);
      await tester.pumpAndSettle();

      expect(find.byType(RegionMonitorScreen), findsNothing);
      expect(find.text('SiagaBanjir'), findsOneWidget);
    });

    testWidgets('Responsive & overflow-free on narrow screen (320x640) with 2.0x text scale', (
      tester,
    ) async {
      await pumpScreen(
        tester,
        size: const Size(320, 640),
        textScale: 2.0,
      );

      expect(find.byType(RegionMonitorScreen), findsOneWidget);
      expect(find.text('Pantau Wilayah'), findsOneWidget);
      expect(find.text('Pos Pantau Sungai'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Responsive & overflow-free on large screen (1024x768)', (
      tester,
    ) async {
      await pumpScreen(
        tester,
        size: const Size(1024, 768),
      );

      expect(find.byType(RegionMonitorScreen), findsOneWidget);
      expect(find.text('Pantau Wilayah'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
