import 'dart:async';

import 'package:flutter/widgets.dart';

import '../domain/mesin_suara.dart';

enum StatusNarasi { diam, menyiapkan, berbicara, jeda, gagal }

class PengendaliSuara extends ChangeNotifier with WidgetsBindingObserver {
  PengendaliSuara(this.mesin) {
    WidgetsBinding.instance.addObserver(this);
  }
  final MesinSuara mesin;
  StatusNarasi status = StatusNarasi.diam;
  String? pesan;
  InfoSuara? info;
  String _teks = '';
  int _generasi = 0;
  bool _disposed = false;

  bool get sibuk => status == StatusNarasi.menyiapkan;

  void _ubah(StatusNarasi nilai, [String? error]) {
    if (_disposed) return;
    status = nilai;
    pesan = error;
    notifyListeners();
  }

  Future<void> putar(String teks) async {
    if (sibuk) return;
    final generasi = ++_generasi;
    final lanjut = status == StatusNarasi.jeda && teks == _teks;
    _teks = teks;
    _ubah(StatusNarasi.menyiapkan);
    try {
      if (!lanjut) await mesin.hentikan();
      if (_disposed || generasi != _generasi) return;
      info ??= await mesin.siapkan(
        () => _ubah(StatusNarasi.diam),
        () => _ubah(
          StatusNarasi.gagal,
          'Suara terhenti. Periksa mesin suara atau koneksi, lalu coba lagi.',
        ),
      );
      if (_disposed || generasi != _generasi) return;
      await mesin.putar(teks);
      if (!_disposed &&
          generasi == _generasi &&
          status == StatusNarasi.menyiapkan) {
        _ubah(StatusNarasi.berbicara);
      }
    } catch (_) {
      if (!_disposed && generasi == _generasi) {
        _ubah(
          StatusNarasi.gagal,
          'Suara bahasa Indonesia belum dapat diputar. Periksa pengaturan Teks ke Ucapan dan koneksi perangkat. Panduan tetap dapat dibaca.',
        );
      }
    }
  }

  Future<void> jeda() async {
    if (status != StatusNarasi.berbicara) return;
    ++_generasi;
    try {
      await mesin.jeda();
      _ubah(StatusNarasi.jeda);
    } catch (_) {
      await hentikan();
    }
  }

  Future<void> lanjut() => putar(_teks);

  Future<void> hentikan() async {
    ++_generasi;
    _ubah(StatusNarasi.diam);
    try {
      await mesin.hentikan();
    } catch (_) {
      /* Teks tetap tersedia. */
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) unawaited(hentikan());
  }

  @override
  void dispose() {
    _disposed = true;
    ++_generasi;
    WidgetsBinding.instance.removeObserver(this);
    unawaited(mesin.hentikan().catchError((Object _) {}));
    super.dispose();
  }
}
