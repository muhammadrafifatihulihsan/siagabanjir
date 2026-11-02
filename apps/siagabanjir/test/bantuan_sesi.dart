import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siagabanjir/app/siaga_banjir_app.dart';
import 'package:siagabanjir/core/sesi/pengelola_sesi.dart';
import 'package:siagabanjir/features/autentikasi/domain/peran_pengguna.dart';

/// Fixture sesi khusus tes tampilan setelah autentikasi; produksi tetap melalui login.
Widget aplikasiWargaTerautentikasi() {
  PengelolaSesi.instance.setSesi(token: 'fixture-widget-token', pengguna: const PenggunaSesi(
    id: 'fixture-warga', nama: 'Warga Uji', email: 'warga@example.invalid', peran: PeranPengguna.warga,
  ));
  addTearDown(PengelolaSesi.instance.hapusSesi);
  return const SiagaBanjirApp();
}
