import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siagabanjir/features/panduan/presentation/pengendali_suara.dart';

import 'mesin_suara_uji.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('Putar, jeda, lanjut, selesai, dan keluar menghentikan mesin', () async {
    final mesin = MesinSuaraUji();
    final suara = PengendaliSuara(mesin);
    await suara.putar('Langkah pertama');
    expect(suara.status, StatusNarasi.berbicara);
    await suara.jeda();
    expect(mesin.dijeda, 1);
    expect(suara.status, StatusNarasi.jeda);
    await suara.lanjut();
    expect(mesin.dibaca, ['Langkah pertama', 'Langkah pertama']);
    mesin.selesai!();
    expect(suara.status, StatusNarasi.diam);
    await suara.putar('Langkah kedua');
    suara.didChangeAppLifecycleState(AppLifecycleState.paused);
    expect(suara.status, StatusNarasi.diam);
    final sebelum = mesin.berhenti;
    suara.dispose();
    expect(mesin.berhenti, sebelum + 1);
    mesin.selesai!(); // Callback terlambat tidak mengakses notifier yang dilepas.
  });
  test(
    'Kegagalan suara memberi pesan dan tidak mengunci percobaan berikut',
    () async {
      final mesin = MesinSuaraUji()..gagal = true;
      final suara = PengendaliSuara(mesin);
      await suara.putar('Panduan');
      expect(suara.status, StatusNarasi.gagal);
      expect(suara.pesan, contains('tetap dapat dibaca'));
      mesin.gagal = false;
      await suara.putar('Panduan');
      expect(suara.status, StatusNarasi.berbicara);
      suara.dispose();
    },
  );
}
