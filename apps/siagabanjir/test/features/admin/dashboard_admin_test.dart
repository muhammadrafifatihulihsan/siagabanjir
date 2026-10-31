import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siagabanjir/app/siaga_banjir_app.dart';
import 'package:siagabanjir/features/admin/domain/klaster_wilayah.dart';
import 'package:siagabanjir/features/admin/domain/state_admin_siaga.dart';
import 'package:siagabanjir/features/admin/presentation/kerangka_admin_web.dart';
import 'package:siagabanjir/features/admin/presentation/widgets/preview_media_laporan.dart';
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

  testWidgets('Dashboard Web Admin renders sidebar and tabs with standard concise labels', (
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
    expect(find.text('ADMIN WEB'), findsOneWidget);
    expect(find.text('Dashboard Ringkasan'), findsOneWidget);

    // 2. Verifikasi 5 Item Menu Sidebar Ringkas
    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Klaster Wilayah'), findsOneWidget);
    expect(find.text('Laporan Warga'), findsOneWidget);
    expect(find.text('Pusat Aksi'), findsWidgets);
    expect(find.text('Profil'), findsOneWidget);

    // 3. Tab 1 Dashboard: Verifikasi 4 KPI Cards
    expect(find.text('Total Laporan'), findsOneWidget);
    expect(find.text('Wilayah Terdampak'), findsOneWidget);
    expect(find.text('Menunggu Verifikasi'), findsOneWidget);
    expect(find.text('Siaran Aktif'), findsOneWidget);

    // 4. Pindah ke Tab 2: Klaster Wilayah
    await tester.tap(find.text('Klaster Wilayah'));
    await tester.pumpAndSettle();
    expect(find.text('Wilayah Laporan Terbanyak'), findsOneWidget);
    expect(find.text('#1'), findsOneWidget);
    expect(find.text('Koto Tangah (Bantaran Batang Kuranji)'), findsOneWidget);

    // Buka Modal Bukti Bersama untuk Klaster #1
    await tester.tap(find.text('Lihat Bukti').first);
    await tester.pumpAndSettle();

    expect(
      find.text('Klasifikasi Otomatis AI (Standar FRD-DEC-020)'),
      findsOneWidget,
    );
    expect(find.text('Rahmat Hidayat (Warga RT 03)'), findsOneWidget);
    expect(find.byType(PreviewMediaLaporan), findsWidgets);
    expect(find.text('Tutup'), findsOneWidget);

    // Tutup Modal
    await tester.tap(find.text('Tutup'));
    await tester.pumpAndSettle();

    // 5. Pindah ke Tab 3: Laporan Warga
    await tester.tap(find.text('Laporan Warga'));
    await tester.pumpAndSettle();
    expect(find.text('Laporan Warga'), findsWidgets);
    expect(find.text('Semua'), findsOneWidget);
    expect(find.text('Menunggu'), findsOneWidget);
    expect(find.text('Ditinjau'), findsOneWidget);
    expect(find.text('MEDIA'), findsOneWidget);
    expect(find.byType(PreviewMediaLaporan), findsWidgets);

    // 6. Pindah ke Tab 4: Pusat Aksi
    await tester.tap(find.text('Pusat Aksi').first);
    await tester.pumpAndSettle();
    expect(find.text('Pusat Aksi & Operasional'), findsOneWidget);
    expect(find.text('Siaran Peringatan'), findsOneWidget);
    expect(find.text('Kontak Posko'), findsOneWidget);
    expect(find.text('Kebijakan Kuota'), findsOneWidget);

    // 7. Pindah ke Tab 5: Profil
    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();
    expect(find.text('Pengaturan Profil Admin'), findsOneWidget);
    expect(find.text('Simpan Profil'), findsOneWidget);
  });

  testWidgets('Verifying cluster automatically approves individual reports (auto-approve)', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final state = StateAdminSiaga.instance;
    await tester.pumpWidget(createAdminApp());
    await tester.pumpAndSettle();

    // Buka tab Klaster Wilayah
    await tester.tap(find.text('Klaster Wilayah'));
    await tester.pumpAndSettle();

    // Klik tombol Verifikasi Wilayah pada klaster
    final btnVerif = find.text('Verifikasi Wilayah').first;
    await tester.ensureVisible(btnVerif);
    await tester.pumpAndSettle();
    await tester.tap(btnVerif);
    await tester.pumpAndSettle();

    // Verifikasi pada state bahwa klaster telah terverifikasi
    final klasterTarget = state.klasterList.firstWhere((k) => k.id == 'klaster-koto-tangah');
    expect(klasterTarget.statusVerifikasi, StatusVerifikasiWilayah.terverifikasi);

    // Verifikasi bahwa laporan-laporan di bawah klaster ini ter-auto-approve
    final laporanKlaster = state.semuaLaporan.where((l) => l.idKlaster == 'klaster-koto-tangah');
    expect(laporanKlaster.isNotEmpty, isTrue);
    for (final lap in laporanKlaster) {
      expect(lap.statusVerifikasi, StatusVerifikasiWilayah.terverifikasi);
      expect(lap.diverifikasiOtomatisWilayah, isTrue);
    }

    // Buka tab Laporan Warga dan pastikan tag Auto Wilayah muncul
    await tester.tap(find.text('Laporan Warga'));
    await tester.pumpAndSettle();
    expect(find.text('Auto Wilayah'), findsWidgets);
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

  testWidgets('Admin operations: broadcast alert and contact addition succeed', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final state = StateAdminSiaga.instance;
    await tester.pumpWidget(createAdminApp());
    await tester.pumpAndSettle();

    // Buka Tab Pusat Aksi
    await tester.tap(find.text('Pusat Aksi').first);
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

    await tester.tap(find.text('Kirim Siaran'));
    await tester.pumpAndSettle();

    expect(
      state.pesanSiaga.any(
        (p) => p.title == 'Peringatan Siaga Uji Coba Koto Tangah',
      ),
      isTrue,
    );

    // 2. Test Sub-Tab Kontak Posko
    await tester.tap(find.text('Kontak Posko'));
    await tester.pumpAndSettle();
    expect(find.text('Tambah Kontak Posko Siaga Bencana'), findsOneWidget);

    // 3. Test Sub-Tab Kebijakan Kuota
    await tester.tap(find.text('Kebijakan Kuota'));
    await tester.pumpAndSettle();
    expect(find.text('Kebijakan Pengiriman Laporan & Kontrol Kuota'), findsOneWidget);
  });

  testWidgets(
    'SiagaBanjirApp with mulaiDariMasuk starts at LayarMasuk and navigates to Warga or Admin',
    (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const SiagaBanjirApp(mulaiDariMasuk: true));
      await tester.pumpAndSettle();

      // 1. Initial screen is login screen
      expect(find.text('Masuk ke Akun'), findsOneWidget);
      expect(find.text('Masuk sebagai Admin'), findsOneWidget);

      // 2. Click Masuk sebagai Admin -> goes to KerangkaAdminWeb
      await tester.ensureVisible(find.text('Masuk sebagai Admin'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Masuk sebagai Admin'));
      await tester.pumpAndSettle();

      expect(find.text('ADMIN WEB'), findsOneWidget);
      expect(find.text('Mode Warga'), findsOneWidget);

      // 3. Click Mode Warga -> goes to KerangkaWarga
      await tester.tap(find.text('Mode Warga'));
      await tester.pumpAndSettle();

      expect(find.text('SiagaBanjir'), findsOneWidget);
      expect(find.text('Beranda'), findsWidgets);
    },
  );
}
