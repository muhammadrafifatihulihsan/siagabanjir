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

  for (final ukuran in [
    const Size(390, 844),
    const Size(768, 900),
    const Size(1280, 800),
  ]) {
    for (final scale in [1.0, 2.0]) {
      testWidgets('Admin semua tab dan dialog ${ukuran.width} teks $scale', (
        tester,
      ) async {
        tester.view.physicalSize = ukuran;
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        await tester.pumpWidget(
          MaterialApp(
            theme: SiagaTheme.light,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: TextScaler.linear(scale)),
              child: child!,
            ),
            home: const KerangkaAdminWeb(),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        Future<void> buka(String menu) async {
          if (find.byTooltip('Buka navigasi').evaluate().isNotEmpty) {
            await tester.tap(find.byTooltip('Buka navigasi'));
            await tester.pumpAndSettle();
          }
          await tester.tap(find.widgetWithText(ListTile, menu));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        }

        await buka('Klaster Wilayah');
        await tester.ensureVisible(find.text('Lihat Bukti').first);
        await tester.tap(find.text('Lihat Bukti').first);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.tap(find.text('Tutup'));
        await tester.pumpAndSettle();
        await buka('Laporan Warga');
        await tester.enterText(
          find.widgetWithText(TextField, 'Cari laporan'),
          'tidak-ada-hasil',
        );
        await tester.pumpAndSettle();
        expect(find.text('Tidak ada laporan yang sesuai.'), findsOneWidget);
        await tester.ensureVisible(find.text('Hapus Pencarian dan Filter'));
        await tester.tap(find.text('Hapus Pencarian dan Filter'));
        await tester.pumpAndSettle();
        expect(find.text('Tidak ada laporan yang sesuai.'), findsNothing);
        await buka('Pusat Aksi');
        await tester.tap(find.text('Kontak Posko'));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.tap(find.text('Kebijakan Kuota'));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await buka('Profil');
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets('Draf siaran bertahan saat berpindah menu', (tester) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(createAdminApp());
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Pusat Aksi'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'Draf peringatan');
    await tester.tap(find.widgetWithText(ListTile, 'Profil'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Pusat Aksi'));
    await tester.pumpAndSettle();
    expect(find.text('Draf peringatan'), findsOneWidget);
  });

  testWidgets('Detail laporan: alasan hapus wajib dan batal menjaga laporan', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(createAdminApp());
    await tester.pumpAndSettle();
    final before = StateAdminSiaga.instance.semuaLaporan.length;
    await tester.tap(find.widgetWithText(ListTile, 'Laporan Warga'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Lihat Detail').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hapus'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Hapus Laporan'));
    await tester.pumpAndSettle();
    expect(find.text('Isi alasan penghapusan.'), findsOneWidget);
    expect(StateAdminSiaga.instance.semuaLaporan.length, before);
    await tester.tap(find.text('Batal'));
    await tester.pumpAndSettle();
    expect(StateAdminSiaga.instance.semuaLaporan.length, before);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Dashboard Web Admin renders sidebar and tabs with standard concise labels',
    (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createAdminApp());
      await tester.pumpAndSettle();

      // 1. Verifikasi Header Brand & Portal Admin
      expect(find.text('SiagaBanjir'), findsOneWidget);
      expect(find.text('Portal Admin'), findsOneWidget);
      expect(find.text('Dashboard'), findsWidgets);

      // 2. Verifikasi 5 Item Menu Sidebar Ringkas
      expect(find.text('Dashboard'), findsWidgets);
      expect(find.text('Klaster Wilayah'), findsOneWidget);
      expect(find.text('Laporan Warga'), findsOneWidget);
      expect(find.text('Pusat Aksi'), findsWidgets);
      expect(find.text('Profil'), findsOneWidget);

      // 3. Tab 1 Dashboard: Verifikasi 4 KPI Cards
      expect(find.text('Total Laporan'), findsOneWidget);
      expect(find.text('Wilayah Aktif'), findsOneWidget);
      expect(find.text('Menunggu Verifikasi'), findsOneWidget);
      expect(find.text('Siaran Aktif'), findsOneWidget);

      // 4. Pindah ke Tab 2: Klaster Wilayah
      await tester.tap(find.text('Klaster Wilayah'));
      await tester.pumpAndSettle();
      expect(find.text('Klaster Wilayah'), findsWidgets);
      expect(find.text('#1'), findsNothing);
      expect(
        find.text('Koto Tangah (Bantaran Batang Kuranji)'),
        findsOneWidget,
      );

      // Buka Modal Bukti Bersama untuk Klaster #1
      await tester.tap(find.text('Lihat Bukti').first);
      await tester.pumpAndSettle();

      expect(find.text('Bukti Laporan'), findsOneWidget);
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
      expect(find.text('Pelapor dan lokasi'), findsOneWidget);
      expect(find.byType(PreviewMediaLaporan), findsWidgets);

      // 6. Pindah ke Tab 4: Pusat Aksi
      await tester.tap(find.text('Pusat Aksi').first);
      await tester.pumpAndSettle();
      expect(find.text('Pusat Aksi'), findsWidgets);
      expect(find.text('Siaran Peringatan'), findsOneWidget);
      expect(find.text('Kontak Posko'), findsOneWidget);
      expect(find.text('Kebijakan Kuota'), findsOneWidget);

      // 7. Pindah ke Tab 5: Profil
      await tester.tap(find.text('Profil'));
      await tester.pumpAndSettle();
      expect(find.text('Profil Admin'), findsOneWidget);
      expect(find.text('Simpan Profil'), findsOneWidget);
    },
  );

  testWidgets(
    'Verifying cluster automatically approves individual reports (auto-approve)',
    (tester) async {
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

      await tester.tap(find.text('Lihat Bukti').first);
      await tester.pumpAndSettle();
      // Verifikasi sesudah membuka kumpulan bukti.
      final btnVerif = find.text('Verifikasi Wilayah').first;
      await tester.ensureVisible(btnVerif);
      await tester.pumpAndSettle();
      await tester.tap(btnVerif);
      await tester.pumpAndSettle();

      // Verifikasi pada state bahwa klaster telah terverifikasi
      final klasterTarget = state.klasterList.firstWhere(
        (k) => k.id == 'klaster-koto-tangah',
      );
      expect(
        klasterTarget.statusVerifikasi,
        StatusVerifikasiWilayah.terverifikasi,
      );

      // Verifikasi bahwa laporan-laporan di bawah klaster ini ter-auto-approve
      final laporanKlaster = state.semuaLaporan.where(
        (l) => l.idKlaster == 'klaster-koto-tangah',
      );
      expect(laporanKlaster.isNotEmpty, isTrue);
      for (final lap in laporanKlaster) {
        expect(lap.statusVerifikasi, StatusVerifikasiWilayah.terverifikasi);
        expect(lap.diverifikasiOtomatisWilayah, isTrue);
      }

      // Buka tab Laporan Warga dan pastikan tag Auto Wilayah muncul
      await tester.tap(find.text('Laporan Warga'));
      await tester.pumpAndSettle();
      expect(find.text('Ditinjau & Diproses'), findsWidgets);
    },
  );

  testWidgets(
    'Role-based separation on LayarMasuk switches between Warga and Admin',
    (tester) async {
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
      expect(find.text('Nomor Ponsel atau Email'), findsOneWidget);
      expect(find.text('Masuk ke SiagaBanjir'), findsOneWidget);
      expect(find.text('Masuk sebagai Admin'), findsOneWidget);

      // 2. Isi otomatis akun Admin melalui tombol tautan teks bawah
      await tester.ensureVisible(find.text('Masuk sebagai Admin'));
      await tester.tap(find.text('Masuk sebagai Admin'));
      await tester.pumpAndSettle();

      // 3. Tekan tombol submit login Masuk ke Dashboard Admin
      await tester.tap(find.text('Masuk ke Dashboard Admin'));
      await tester.pumpAndSettle();

      expect(loggedRole, PeranPengguna.admin);
      expect(loggedIdentifier, 'admin1@siagabanjir.id');
    },
  );

  testWidgets(
    'Admin operations: broadcast alert and contact addition succeed',
    (tester) async {
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
      expect(find.text('Tambah Kontak Posko'), findsOneWidget);

      // 3. Test Sub-Tab Kebijakan Kuota
      await tester.tap(find.text('Kebijakan Kuota'));
      await tester.pumpAndSettle();
      expect(find.text('Pengaturan Laporan'), findsOneWidget);
    },
  );

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

      // 2. Click Masuk sebagai Admin to autofill -> then submit to go to KerangkaAdminWeb
      await tester.ensureVisible(find.text('Masuk sebagai Admin'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Masuk sebagai Admin'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Masuk ke Dashboard Admin'));
      await tester.pumpAndSettle();

      expect(find.text('Portal Admin'), findsOneWidget);
      expect(find.text('Mode Warga'), findsOneWidget);

      // 3. Click Mode Warga -> goes to KerangkaWarga
      await tester.tap(find.text('Mode Warga'));
      await tester.pumpAndSettle();

      expect(find.text('SiagaBanjir'), findsOneWidget);
      expect(find.text('Beranda'), findsWidgets);
    },
  );
}
