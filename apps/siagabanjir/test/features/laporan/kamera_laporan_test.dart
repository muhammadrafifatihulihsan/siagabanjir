import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siagabanjir/core/perangkat/layanan_foto.dart';
import 'package:siagabanjir/features/laporan/presentation/layar_buat_laporan.dart';
import 'package:siagabanjir/shared/theme/siaga_theme.dart';

class KameraUji extends LayananFoto {
  FotoPilihan? hasil;
  bool gagal = false;
  int panggilan = 0;
  @override
  Future<FotoPilihan?> ambil() async {
    panggilan++;
    if (gagal) throw StateError('Izin ditolak');
    return hasil;
  }
}

void main() {
  testWidgets('Foto tampil; batal dan gagal tidak menghapus foto sebelumnya', (
    t,
  ) async {
    final kamera = KameraUji()
      ..hasil = FotoPilihan(
        base64Decode(
          'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+jRZkAAAAASUVORK5CYII=',
        ),
        'uji.png',
      );
    await t.pumpWidget(
      MaterialApp(
        theme: SiagaTheme.light,
        home: LayarBuatLaporan(
          layananFoto: kamera,
          onNotifications: () {},
          onHistory: () {},
          onProfile: () {},
        ),
      ),
    );
    await t.tap(find.text('Buka Kamera Ponsel'));
    await t.pumpAndSettle();
    expect(find.bySemanticsLabel('Foto kejadian yang diambil'), findsOneWidget);
    kamera.hasil = null;
    await t.tap(find.text('Ambil Ulang Foto'));
    await t.pumpAndSettle();
    expect(find.bySemanticsLabel('Foto kejadian yang diambil'), findsOneWidget);
    kamera.gagal = true;
    await t.tap(find.text('Ambil Ulang Foto'));
    await t.pumpAndSettle();
    expect(find.text('Kamera belum dapat dibuka'), findsOneWidget);
    await t.tap(find.text('Mengerti'));
    await t.pumpAndSettle();
    expect(find.bySemanticsLabel('Foto kejadian yang diambil'), findsOneWidget);
    expect(kamera.panggilan, 3);
  });
}
