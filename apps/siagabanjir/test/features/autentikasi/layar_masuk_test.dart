import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siagabanjir/features/autentikasi/presentation/layar_masuk.dart';
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

  Future<void> openLogin(
    WidgetTester tester, {
    Size size = const Size(390, 844),
    double scale = 1,
    double bottomInset = 0,
    ValueChanged<String>? onLoginSuccess,
    VoidCallback? onRegister,
    VoidCallback? onForgotPassword,
    VoidCallback? onGoogleLogin,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    tester.view.viewInsets = FakeViewPadding(bottom: bottomInset);
    tester.platformDispatcher.textScaleFactorTestValue = scale;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetViewInsets);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await tester.pumpWidget(
      MaterialApp(
        theme: SiagaTheme.light,
        home: LayarMasuk(
          onLoginSuccess: onLoginSuccess,
          onRegister: onRegister,
          onForgotPassword: onForgotPassword,
          onGoogleLogin: onGoogleLogin,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('Login screen displays all elements matching SVG design', (
    tester,
  ) async {
    await openLogin(tester);

    // Branding & Header
    expect(find.text('SiagaBanjir'), findsOneWidget);
    expect(find.text('Tanggap Darurat Banjir Warga'), findsOneWidget);

    // Card Header
    expect(find.text('Masuk ke Akun'), findsOneWidget);
    expect(
      find.text('Pantau debit sungai dan lapor kondisi banjir.'),
      findsOneWidget,
    );

    // Form Labels
    expect(find.text('Nomor Ponsel atau Email'), findsOneWidget);
    expect(find.text('Kata Sandi atau PIN'), findsOneWidget);

    // Options & Action Buttons
    expect(find.text('Ingat Saya'), findsOneWidget);
    expect(find.text('Lupa Sandi?'), findsOneWidget);
    expect(find.text('Masuk ke SiagaBanjir'), findsOneWidget);
    expect(find.text('atau'), findsOneWidget);
    expect(find.text('Lanjut dengan Google'), findsOneWidget);

    // Footer
    expect(find.text('Belum punya akun? '), findsOneWidget);
    expect(find.text('Daftar Sekarang'), findsOneWidget);
  });

  testWidgets(
    'Interactions on Login screen trigger expected callbacks & feedbacks',
    (tester) async {
      String? loggedInUser;
      var forgotTapped = false;
      var googleTapped = false;
      var registerTapped = false;

      await openLogin(
        tester,
        onLoginSuccess: (user) => loggedInUser = user,
        onForgotPassword: () => forgotTapped = true,
        onGoogleLogin: () => googleTapped = true,
        onRegister: () => registerTapped = true,
      );

      // 1. Submit when empty triggers error feedback
      await tester.tap(find.text('Masuk ke SiagaBanjir'));
      await tester.pumpAndSettle();
      expect(find.text('Nomor ponsel atau email wajib diisi.'), findsOneWidget);

      // 2. Fill identifier only, empty password triggers error
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.first, '081234567890');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Masuk ke SiagaBanjir'));
      await tester.pumpAndSettle();
      expect(find.text('Kata sandi atau PIN wajib diisi.'), findsOneWidget);

      // 3. Fill password and toggle obscure text
      await tester.enterText(textFields.last, 'rahasia123');
      await tester.pumpAndSettle();

      // Check toggle obscure text icon
      final toggleFinder = find.byTooltip('Tampilkan kata sandi');
      expect(toggleFinder, findsOneWidget);
      await tester.tap(toggleFinder);
      await tester.pumpAndSettle();
      expect(find.byTooltip('Sembunyikan kata sandi'), findsOneWidget);

      // 4. Toggle Remember Me
      final checkboxFinder = find.byType(Checkbox);
      expect(tester.widget<Checkbox>(checkboxFinder).value, isTrue);
      await tester.tap(find.text('Ingat Saya'));
      await tester.pumpAndSettle();
      expect(tester.widget<Checkbox>(checkboxFinder).value, isFalse);

      // 5. Submit valid form
      await tester.tap(find.text('Masuk ke SiagaBanjir'));
      await tester.pumpAndSettle();
      expect(loggedInUser, '081234567890');
      expect(find.text('Berhasil masuk sebagai 081234567890.'), findsOneWidget);

      // 6. Test Forgot Password tap
      await tester.tap(find.text('Lupa Sandi?'));
      await tester.pumpAndSettle();
      expect(forgotTapped, isTrue);

      // 7. Test Google Sign In tap
      await tester.tap(find.text('Lanjut dengan Google'));
      await tester.pumpAndSettle();
      expect(googleTapped, isTrue);

      // 8. Test Register tap
      await tester.tap(find.text('Daftar Sekarang'));
      await tester.pumpAndSettle();
      expect(registerTapped, isTrue);
    },
  );

  for (final scenario in [
    (const Size(320, 640), 1.0, 0.0),
    (const Size(390, 844), 1.0, 0.0),
    (const Size(390, 1097), 1.0, 0.0),
    (const Size(1024, 768), 1.0, 0.0),
    (const Size(320, 640), 2.0, 0.0),
    (const Size(390, 844), 2.0, 0.0),
    (const Size(390, 844), 1.0, 250.0), // Keyboard open simulation
  ]) {
    testWidgets(
      'No overflow on Login at ${scenario.$1}, scale ${scenario.$2}, inset ${scenario.$3}',
      (tester) async {
        await openLogin(
          tester,
          size: scenario.$1,
          scale: scenario.$2,
          bottomInset: scenario.$3,
        );
        expect(tester.takeException(), isNull);

        // Ensure bottom content is reached without layout exceptions
        await tester.ensureVisible(find.text('Daftar Sekarang'));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      },
    );
  }
}
