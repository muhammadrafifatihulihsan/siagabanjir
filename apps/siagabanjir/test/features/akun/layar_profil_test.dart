import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siagabanjir/features/akun/presentation/layar_profil.dart';
import 'package:siagabanjir/features/beranda/presentation/aksi_beranda.dart';
import 'package:siagabanjir/shared/theme/siaga_theme.dart';

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

  Future<void> openProfile(
    WidgetTester tester, {
    Size size = const Size(390, 844),
    double scale = 1,
    ValueChanged<AksiBeranda>? onOpen,
    VoidCallback? onHome,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = scale;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await tester.pumpWidget(
      MaterialApp(
        theme: SiagaTheme.light,
        home: LayarProfil(onOpen: onOpen ?? (_) {}, onHome: onHome ?? () {}),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('Profile screen displays all elements matching SVG design', (
    tester,
  ) async {
    await openProfile(tester);

    // Header title and branding
    expect(find.text('SiagaBanjir'), findsOneWidget);
    expect(find.text('Profil Pengguna'), findsOneWidget);

    // User details
    expect(find.text('RH'), findsOneWidget);
    expect(find.text('Rahmat Hidayat'), findsOneWidget);
    expect(find.text('+62 812-3456-7890'), findsOneWidget);
    expect(find.text('Edit Profil'), findsOneWidget);

    // Data Pribadi & Domisili
    expect(find.text('Data Pribadi & Domisili'), findsOneWidget);
    expect(find.text('137107*********01'), findsOneWidget);
    expect(find.text('rahmat.hidayat@email.com'), findsOneWidget);
    expect(
      find.text('Jl. Adinegoro No. 12, RT 02 / RW 04, Lubuk Buaya'),
      findsOneWidget,
    );
    expect(find.byTooltip('Ambil foto profil'), findsNothing);
    expect(find.text('Kontak Pribadi'), findsNothing);

    // Settings
    await tester.scrollUntilVisible(find.text('Pengaturan & Akun'), 200);
    expect(find.text('Pengaturan & Akun'), findsOneWidget);
    expect(find.text('Peringatan Siaga Banjir'), findsOneWidget);
    expect(find.text('Keamanan & Kata Sandi'), findsOneWidget);
    expect(find.text('Pusat Bantuan & FAQ'), findsOneWidget);
    expect(find.text('Kebijakan Privasi Data'), findsOneWidget);
    expect(find.text('Versi Aplikasi'), findsOneWidget);
    expect(find.text('v1.0.0+1 (Demo)'), findsOneWidget);

    // Logout button
    await tester.scrollUntilVisible(find.text('Keluar dari Akun'), 200);
    expect(find.text('Keluar dari Akun'), findsOneWidget);

    // Profile navigation tab is selected
    expect(
      find.byWidgetPredicate(
        (w) => w is Semantics && w.properties.selected == true,
      ),
      findsOneWidget,
    );
  });

  testWidgets('Interactions on profile trigger feedbacks and dialogs', (
    tester,
  ) async {
    var homeTapped = false;
    await openProfile(tester, onHome: () => homeTapped = true);

    // Test Edit Profil tap
    await tester.tap(find.text('Edit Profil'));
    await tester.pumpAndSettle();
    expect(find.text('Simpan Perubahan'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).first, 'Warga Penguji');
    await tester.tap(find.text('Simpan Perubahan'));
    await tester.pumpAndSettle();
    expect(find.text('Warga Penguji'), findsOneWidget);

    // Test toggle flood alert
    await tester.scrollUntilVisible(find.byType(Switch), 200);
    final switchFinder = find.byType(Switch);
    expect(tester.widget<Switch>(switchFinder).value, isTrue);

    await tester.tap(switchFinder);
    await tester.pumpAndSettle();
    expect(tester.widget<Switch>(switchFinder).value, isFalse);
    expect(
      find.text('Preferensi peringatan dinonaktifkan untuk sesi demo.'),
      findsOneWidget,
    );

    // Test logout dialog
    await tester.scrollUntilVisible(find.text('Keluar dari Akun'), 200);
    await tester.tap(find.text('Keluar dari Akun'));
    await tester.pumpAndSettle();
    expect(find.text('Keluar dari Akun?'), findsOneWidget);

    // Cancel logout
    await tester.tap(find.text('Batal'));
    await tester.pumpAndSettle();
    expect(find.text('Keluar dari Akun?'), findsNothing);

    // Dismiss snackbar and tap Beranda in navigation
    ScaffoldMessenger.of(tester.element(find.byType(LayarProfil)))
        .hideCurrentSnackBar();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Beranda'));
    await tester.pumpAndSettle();
    expect(homeTapped, isTrue);
  });

  for (final scenario in [
    (const Size(320, 640), 1.0),
    (const Size(390, 844), 1.0),
    (const Size(390, 1097), 1.0),
    (const Size(1024, 768), 1.0),
    (const Size(320, 640), 2.0),
    (const Size(390, 844), 2.0),
  ]) {
    testWidgets(
      'No overflow on Profile at ${scenario.$1}, scale ${scenario.$2}',
      (tester) async {
        await openProfile(tester, size: scenario.$1, scale: scenario.$2);
        expect(tester.takeException(), isNull);

        await tester.scrollUntilVisible(find.text('Keluar dari Akun'), 200);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      },
    );
  }
}
