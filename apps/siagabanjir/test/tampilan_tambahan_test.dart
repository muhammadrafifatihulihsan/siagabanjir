import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:siagabanjir/features/pesan/presentation/widgets/dialog_pesan.dart';
import 'package:siagabanjir/features/pesan/presentation/models/pesan_siaga.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siagabanjir/features/keluarga/presentation/layar_keluarga.dart';
import 'package:siagabanjir/features/kontak/presentation/layar_direktori_kontak.dart';
import 'package:siagabanjir/shared/theme/siaga_theme.dart';

import 'features/laporan/bantuan_tes_laporan.dart';

void main() {
  setUpAll(loadReportFonts);
  testWidgets(
    'Dialog pesan mendukung teks besar dan menyalin pesan bertanda contoh',
    (t) async {
      t.view.physicalSize = const Size(320, 640);
      t.view.devicePixelRatio = 1;
      t.platformDispatcher.textScaleFactorTestValue = 2;
      addTearDown(t.view.resetPhysicalSize);
      addTearDown(t.view.resetDevicePixelRatio);
      addTearDown(t.platformDispatcher.clearTextScaleFactorTestValue);
      String? salinan;
      t.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async {
          if (call.method == 'Clipboard.setData') {
            salinan = (call.arguments as Map)['text'] as String;
          }
          return null;
        },
      );
      addTearDown(
        () => t.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          null,
        ),
      );
      await t.pumpWidget(
        MaterialApp(
          theme: SiagaTheme.light,
          home: Builder(
            builder: (c) => Scaffold(
              body: Column(
                children: [
                  TextButton(
                    onPressed: () =>
                        showMessageDetail(c, kSampleSiagaMessages.first),
                    child: const Text('Detail'),
                  ),
                  TextButton(
                    onPressed: () => showMessageActionExplanation(
                      c,
                      'Bagikan',
                      kSampleSiagaMessages.first,
                    ),
                    child: const Text('Bagikan'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await t.tap(find.text('Detail'));
      await t.pumpAndSettle();
      expect(t.takeException(), isNull);
      await t.tap(find.text('Tutup'));
      await t.pumpAndSettle();
      await t.tap(find.text('Bagikan'));
      await t.pumpAndSettle();
      await t.tap(find.text('Salin Teks Contoh'));
      await t.pumpAndSettle();
      expect(salinan, startsWith('CONTOH DEMO'));
      expect(salinan, contains(kSampleSiagaMessages.first.body));
      expect(t.takeException(), isNull);
    },
  );
  testWidgets(
    'Kontak dan formulir keluarga dapat digunakan pada 320 px dengan teks 200%',
    (t) async {
      t.view.physicalSize = const Size(320, 640);
      t.view.devicePixelRatio = 1;
      t.platformDispatcher.textScaleFactorTestValue = 2;
      addTearDown(t.view.resetPhysicalSize);
      addTearDown(t.view.resetDevicePixelRatio);
      addTearDown(t.platformDispatcher.clearTextScaleFactorTestValue);
      await t.pumpWidget(
        MaterialApp(
          theme: SiagaTheme.light,
          home: LayarDirektoriKontak(
            onReport: () {},
            onHistory: () {},
            onProfile: () {},
          ),
        ),
      );
      await t.pumpAndSettle();
      await t.scrollUntilVisible(
        find.text('BPBD Kota Padang'),
        150,
        scrollable: find.byType(Scrollable).first,
      );
      expect(t.takeException(), isNull);
      await t.pumpWidget(
        MaterialApp(theme: SiagaTheme.light, home: const LayarKeluarga()),
      );
      await t.pumpAndSettle();
      await t.ensureVisible(find.text('Tambah Anggota'));
      await t.tap(find.text('Tambah Anggota'));
      await t.pumpAndSettle();
      expect(find.text('Simpan Anggota').hitTestable(), findsOneWidget);
      expect(t.takeException(), isNull);
    },
  );
}
