import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siagabanjir/features/admin/domain/state_admin_siaga.dart';
import 'package:siagabanjir/features/admin/presentation/kerangka_admin_web.dart';
import 'package:siagabanjir/features/autentikasi/domain/peran_pengguna.dart';
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

  Widget createAdminApp({VoidCallback? onLogout, VoidCallback? onSwitch}) {
    return MaterialApp(
      theme: SiagaTheme.light,
      home: KerangkaAdminWeb(
        onLogout: onLogout,
        onSwitchToCitizenMode: onSwitch,
      ),
    );
  }

  testWidgets('Dashboard Web Admin renders sidebar and all 5 main tabs smoothly', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(createAdminApp());
    await tester.pumpAndSettle();

    // 1. Verifikasi Header Brand & Portal Admin
    expect(find.text('SiagaBanjir'), findsOneWidget);
    expect(find.text('ADMIN WEB PORTAL'), findsOneWidget);
    expect(find.text('Dashboard Ringkasan Operasional'), findsOneWidget);

    // 2. Verifikasi 5 Item Menu Sidebar
    expect(find.text('Dashboard Ringkasan'), findsOneWidget);
    expect(find.text('Wilayah Terbanyak'), findsOneWidget);
    expect(find.text('Laporan Per-Individu'), findsOneWidget);
    expect(find.text('Pusat Aksi & Operasional'), findsOneWidget);
    expect(find.text('Profil Petugas BPBD'), findsOneWidget);

    // 3. Tab 1 Dashboard: Verifikasi KPI Cards
    expect(find.text('Total Laporan Warga'), findsOneWidget);
    expect(find.text('Wilayah Terdampak'), findsOneWidget);
    expect(find.text('Batang Kuranji'), findsOneWidget);
    expect(find.text('Peringatan Aktif'), findsOneWidget);

    // 4. Pindah ke Tab 2: Wilayah Terbanyak (Klaster AI)
    await tester.tap(find.text('Wilayah Terbanyak'));
    await tester.pumpAndSettle();
    expect(
      find.text('Daftar Wilayah dengan Laporan Terbanyak (Klaster AI)'),
      findsOneWidget,
    );
    expect(find.text('#1'), findsOneWidget);
    expect(find.text('Koto Tangah (Bantaran Batang Kuranji)'), findsOneWidget);

    // Buka Modal Bukti Bersama untuk Klaster #1
    await tester.tap(find.text('Buka Kumpulan Bukti Wilayah').first);
    await tester.pumpAndSettle();

    expect(
      find.text('Klasifikasi Otomatis AI (Standar FRD-DEC-020)'),
      findsOneWidget,
    );
    expect(find.text('Rahmat Hidayat (Warga RT 03)'), findsOneWidget);
    expect(find.text('Tutup'), findsOneWidget);

    // Tutup Modal
    await tester.tap(find.text('Tutup'));
    await tester.pumpAndSettle();

    // 5. Pindah ke Tab 3: Laporan Per-Individu
    await tester.tap(find.text('Laporan Per-Individu'));
    await tester.pumpAndSettle();
    expect(find.text('Laporan Warga Per-Individu'), findsOneWidget);
    expect(find.text('Semua'), findsOneWidget);
    expect(find.text('Menunggu'), findsOneWidget);
    expect(find.text('Ditinjau'), findsOneWidget);

    // 6. Pindah ke Tab 4: Pusat Aksi & Operasional
    await tester.tap(find.text('Pusat Aksi & Operasional'));
    await tester.pumpAndSettle();
    expect(find.text('Pusat Aksi & Pengaturan Operasional'), findsOneWidget);
    expect(find.text('Siaran Peringatan (Broadcast)'), findsOneWidget);
    expect(find.text('Kontak Darurat & Posko'), findsOneWidget);
    expect(find.text('Kontrol Sensor Sungai'), findsOneWidget);
    expect(find.text('Kebijakan Kuota & Galeri'), findsOneWidget);

    // 7. Pindah ke Tab 5: Profil Petugas BPBD
    await tester.tap(find.text('Profil Petugas BPBD'));
    await tester.pumpAndSettle();
    expect(
      find.text('Pengaturan Profil & Akun Petugas BPBD'),
      findsOneWidget,
    );
    expect(find.text('Simpan Pembaruan Profil'), findsOneWidget);
  });

  testWidgets('Role-based separation on LayarMasuk switches between Warga and Admin', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    PeranPengguna? loggedRole;
    String? loggedIdentifier;

    await tester.pumpWidget(
      MaterialApp(
        theme: SiagaTheme.light,
        home: LayarMasuk(
          onLoginWithRole: (id, role) {
            loggedIdentifier = id;
            loggedRole = role;
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Role Warga default
    expect(find.text('Warga'), findsOneWidget);
    expect(find.text('Petugas / Admin'), findsOneWidget);
    expect(find.text('Nomor Ponsel atau Email'), findsOneWidget);
    expect(find.text('Masuk ke SiagaBanjir'), findsOneWidget);

    // 2. Ganti peran ke Petugas / Admin
    await tester.tap(find.text('Petugas / Admin'));
    await tester.pumpAndSettle();

    expect(find.text('Email Dinas Petugas BPBD'), findsOneWidget);
    expect(find.text('Masuk ke Dashboard Admin'), findsOneWidget);

    // 3. Submit login Admin
    await tester.tap(find.text('Masuk ke Dashboard Admin'));
    await tester.pumpAndSettle();

    expect(loggedRole, PeranPengguna.admin);
    expect(loggedIdentifier, 'admin.bpbd@padang.go.id');
  });

  testWidgets('Admin operations: broadcast alert and river sensor updates succeed', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final state = StateAdminSiaga.instance;
    await tester.pumpWidget(createAdminApp());
    await tester.pumpAndSettle();

    // Buka Tab Pusat Operasional
    await tester.tap(find.text('Pusat Aksi & Operasional'));
    await tester.pumpAndSettle();

    // 1. Test Broadcast Peringatan Baru
    final textFields = find.byType(TextField);
    await tester.enterText(
      textFields.first,
      'Peringatan Siaga Uji Coba Koto Tangah',
    );
    await tester.enterText(
      textFields.at(1),
      'Harap evakuasi segera ke posko terdekat.',
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Siarkan Sekarang ke Seluruh Warga'));
    await tester.pumpAndSettle();

    expect(
      state.pesanSiaga.any(
        (p) => p.title == 'Peringatan Siaga Uji Coba Koto Tangah',
      ),
      isTrue,
    );

    // 2. Test Sub-Tab Sensor Sungai
    await tester.tap(find.text('Kontrol Sensor Sungai'));
    await tester.pumpAndSettle();
    expect(
      find.text('Kontrol Sensor Sorotan Utama: Sungai Batang Kuranji'),
      findsOneWidget,
    );

    await tester.tap(find.text('Terapkan Pembaruan Sensor Sungai'));
    await tester.pumpAndSettle();
    expect(find.byType(SnackBar), findsOneWidget);
  });
}
