import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siagabanjir/features/panduan/data/mesin_suara_perangkat.dart';
import 'package:siagabanjir/features/panduan/presentation/pengendali_suara.dart';

import 'mesin_suara_uji.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('Adapter menetapkan kecepatan normal sebelum berbicara', () async {
    final calls = <MethodCall>[];
    const channel = MethodChannel('flutter_tts');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          calls.add(call);
          if (call.method == 'isLanguageAvailable') return true;
          if (call.method == 'getVoices') return [];
          return 1;
        });
    addTearDown(
      () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null),
    );
    final mesin = MesinSuaraPerangkat();
    await mesin.siapkan(() {}, () {});
    await mesin.putar('Panduan');
    expect(
      calls.singleWhere((c) => c.method == 'setSpeechRate').arguments,
      1.0,
    );
    expect(calls.singleWhere((c) => c.method == 'setPitch').arguments, 1.0);
    expect(
      calls.indexWhere((c) => c.method == 'setSpeechRate'),
      lessThan(calls.indexWhere((c) => c.method == 'speak')),
    );
  });
  test('Ketukan berulang pada narasi aktif tidak memulai ulang', () async {
    final mesin = MesinSuaraUji();
    final pengendali = PengendaliSuara(mesin);
    await pengendali.putar('Langkah satu');
    await pengendali.putar('Langkah satu');
    expect(mesin.dibaca, ['Langkah satu']);
    await pengendali.putar('Langkah dua');
    expect(mesin.dibaca, ['Langkah satu', 'Langkah dua']);
    pengendali.dispose();
  });
}
