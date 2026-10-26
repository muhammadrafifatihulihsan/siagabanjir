import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siagabanjir/features/autentikasi/presentation/layar_masuk.dart';
import 'package:siagabanjir/features/autentikasi/presentation/layar_daftar.dart';
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

  Future<void> openRegister(
    WidgetTester tester, {
    Size size = const Size(390, 844),
    double scale = 1,
    double bottomInset = 0,
    ValueChanged<String>? onRegisterSuccess,
    VoidCallback? onLogin,
    VoidCallback? onTermsAndPrivacy,
    VoidCallback? onGoogleSignUp,
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
        home: LayarDaftar(
          onRegisterSuccess: onRegisterSuccess,
          onLogin: onLogin,
          onTermsAndPrivacy: onTermsAndPrivacy,
          onGoogleSignUp: onGoogleSignUp,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('Register screen displays all elements matching SVG design', (
    tester,
  ) async {
    await openRegister(tester);

    // Branding & Header
    expect(find.text('SiagaBanjir'), findsOneWidget);
    expect(find.text('Tanggap Darurat Banjir Warga'), findsOneWidget);

    // Card Header
    expect(find.text('Daftar Akun Baru'), findsOneWidget);
    expect(
      find.text('Daftar untuk pantau air dan lapor banjir cepat.'),
      findsOneWidget,
    );

    // Form Labels
    expect(find.text('Nama Lengkap (KTP)'), findsOneWidget);
    expect(find.text('Nomor Ponsel atau Email'), findsOneWidget);
    expect(find.text('Kata Sandi Akun'), findsOneWidget);

    // Terms & Conditions Checkbox
    expect(find.text('Saya setuju '), findsOneWidget);
    expect(find.text('Ketentuan Layanan & Privasi'), findsOneWidget);

    // Action Buttons
    expect(find.text('Daftar ke SiagaBanjir'), findsOneWidget);
    expect(find.text('atau'), findsOneWidget);
    expect(find.text('Lanjut dengan Google'), findsOneWidget);

    // Footer
    expect(find.text('Sudah punya akun? '), findsOneWidget);
    expect(find.text('Masuk Sekarang'), findsOneWidget);
  });

  testWidgets(
    'Interactions on Register screen trigger validation, callbacks & feedback',
    (tester) async {
      String? registeredUser;
      var loginTapped = false;
      var termsTapped = false;
      var googleTapped = false;

      await openRegister(
        tester,
        onRegisterSuccess: (user) => registeredUser = user,
        onLogin: () => loginTapped = true,
        onTermsAndPrivacy: () => termsTapped = true,
        onGoogleSignUp: () => googleTapped = true,
      );

      // 1. Submit when empty triggers name error feedback
      await tester.tap(find.text('Daftar ke SiagaBanjir'));
      await tester.pumpAndSettle();
      expect(find.text('Nama lengkap (KTP) wajib diisi.'), findsOneWidget);

      // 2. Fill name only, triggers identifier error
      final textFields = find.byType(TextFormField);
      expect(textFields, findsNWidgets(3));

      await tester.enterText(textFields.at(0), 'Rahmat Hidayat');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Daftar ke SiagaBanjir'));
      await tester.pumpAndSettle();
      expect(find.text('Nomor ponsel atau email wajib diisi.'), findsOneWidget);

      // 3. Fill identifier, triggers password error
      await tester.enterText(textFields.at(1), '081234567890');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Daftar ke SiagaBanjir'));
      await tester.pumpAndSettle();
      expect(find.text('Kata sandi akun wajib diisi.'), findsOneWidget);

      // 4. Fill password
      await tester.enterText(textFields.at(2), 'rahasia123');
      await tester.pumpAndSettle();

      // Check toggle obscure text icon
      final toggleFinder = find.byTooltip('Tampilkan kata sandi');
      expect(toggleFinder, findsOneWidget);
      await tester.tap(toggleFinder);
      await tester.pumpAndSettle();
      expect(find.byTooltip('Sembunyikan kata sandi'), findsOneWidget);

      // 5. Uncheck Terms & Conditions -> triggers terms error
      final checkboxFinder = find.byType(Checkbox);
      expect(tester.widget<Checkbox>(checkboxFinder).value, isTrue);
      await tester.tap(find.text('Saya setuju '));
      await tester.pumpAndSettle();
      expect(tester.widget<Checkbox>(checkboxFinder).value, isFalse);

      await tester.tap(find.text('Daftar ke SiagaBanjir'));
      await tester.pumpAndSettle();
      expect(
        find.text('Anda harus menyetujui Ketentuan Layanan & Privasi.'),
        findsOneWidget,
      );

      // 6. Check terms again and submit valid form
      await tester.tap(find.text('Saya setuju '));
      await tester.pumpAndSettle();
      expect(tester.widget<Checkbox>(checkboxFinder).value, isTrue);

      await tester.tap(find.text('Daftar ke SiagaBanjir'));
      await tester.pumpAndSettle();
      expect(registeredUser, 'Rahmat Hidayat');
      expect(
        find.text('Pendaftaran berhasil untuk Rahmat Hidayat.'),
        findsOneWidget,
      );

      // 7. Test Terms & Privacy link tap
      await tester.tap(find.text('Ketentuan Layanan & Privasi'));
      await tester.pumpAndSettle();
      expect(termsTapped, isTrue);

      // 8. Test Google Sign Up tap
      await tester.tap(find.text('Lanjut dengan Google'));
      await tester.pumpAndSettle();
      expect(googleTapped, isTrue);

      // 9. Dismiss floating SnackBar and test Login tap
      ScaffoldMessenger.of(tester.element(find.byType(LayarDaftar)))
          .hideCurrentSnackBar();
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Masuk Sekarang'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Masuk Sekarang'));
      await tester.pumpAndSettle();
      expect(loginTapped, isTrue);
    },
  );

  testWidgets(
    'Bidirectional navigation between LayarMasuk and LayarDaftar works smoothly',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(theme: SiagaTheme.light, home: const LayarMasuk()),
      );
      await tester.pumpAndSettle();

      // On LayarMasuk initially
      expect(find.text('Masuk ke Akun'), findsOneWidget);
      expect(find.text('Daftar Sekarang'), findsOneWidget);

      // Scroll and tap Daftar Sekarang to navigate to LayarDaftar
      await tester.ensureVisible(find.text('Daftar Sekarang'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Daftar Sekarang'));
      await tester.pumpAndSettle();

      // Now on LayarDaftar
      expect(find.text('Daftar Akun Baru'), findsOneWidget);
      expect(find.text('Masuk Sekarang'), findsOneWidget);

      // Scroll and tap Masuk Sekarang to pop back to LayarMasuk
      await tester.ensureVisible(find.text('Masuk Sekarang'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Masuk Sekarang'));
      await tester.pumpAndSettle();

      // Back on LayarMasuk
      expect(find.text('Masuk ke Akun'), findsOneWidget);
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
      'No overflow on Register at ${scenario.$1}, scale ${scenario.$2}, inset ${scenario.$3}',
      (tester) async {
        await openRegister(
          tester,
          size: scenario.$1,
          scale: scenario.$2,
          bottomInset: scenario.$3,
        );
        expect(tester.takeException(), isNull);

        // Ensure bottom content is reached without layout exceptions
        await tester.ensureVisible(find.text('Masuk Sekarang'));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      },
    );
  }
}
