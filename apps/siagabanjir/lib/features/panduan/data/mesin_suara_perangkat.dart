import 'package:flutter_tts/flutter_tts.dart';

import '../domain/mesin_suara.dart';

class MesinSuaraPerangkat implements MesinSuara {
  MesinSuaraPerangkat({FlutterTts? tts}) : _tts = tts ?? FlutterTts();
  final FlutterTts _tts;

  @override
  Future<InfoSuara> siapkan(
    void Function() selesai,
    void Function() gagal,
  ) async {
    _tts.setCompletionHandler(selesai);
    _tts.setErrorHandler((_) => gagal());
    if (await _tts.isLanguageAvailable('id-ID') != true) {
      throw StateError('Suara bahasa Indonesia belum tersedia pada perangkat.');
    }
    await _tts.setLanguage('id-ID');
    // flutter_tts 4.x: skala 1.0 = kecepatan normal pada Android dan Web.
    // Nilai 0.5 pada versi ini berarti setengah kecepatan (bukan normal).
    await _tts.setSpeechRate(0.5);
    await _tts.setPitch(1.0);
    // awaitSpeakCompletion(true) memastikan setiap speak() selesai sebelum
    // permintaan berikutnya, mencegah narasi bertumpuk (suara ganda/cepat).
    await _tts.awaitSpeakCompletion(true);
    final voices = await _tts.getVoices;
    if (voices is List) {
      final indonesia = voices
          .whereType<Map>()
          .where(
            (v) => '${v['locale']}'
                .replaceAll('_', '-')
                .toLowerCase()
                .startsWith('id-'),
          )
          .toList();
      indonesia.sort(
        (a, b) => ('${a['network_required']}' == 'false' ? 0 : 1).compareTo(
          '${b['network_required']}' == 'false' ? 0 : 1,
        ),
      );
      if (indonesia.isNotEmpty) {
        final suara = indonesia.first;
        await _tts.setVoice({
          'name': '${suara['name']}',
          'locale': '${suara['locale']}',
        });
        return InfoSuara(
          perluJaringan: suara.containsKey('network_required')
              ? '${suara['network_required']}' == 'true'
              : null,
        );
      }
    }
    return const InfoSuara();
  }

  @override
  Future<void> putar(String teks) async {
    if (await _tts.speak(teks) != 1) {
      throw StateError('Suara tidak dapat dimulai.');
    }
  }

  @override
  Future<void> jeda() async {
    await _tts.pause();
  }

  @override
  Future<void> hentikan() async {
    await _tts.stop();
  }
}
