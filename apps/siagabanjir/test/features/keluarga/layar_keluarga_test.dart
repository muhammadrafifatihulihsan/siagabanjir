import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siagabanjir/features/keluarga/presentation/layar_keluarga.dart';
import 'package:siagabanjir/shared/theme/siaga_theme.dart';

void main() {
  testWidgets('Keluarga: validasi, tambah, edit, batal hapus, hapus', (
    t,
  ) async {
    await t.pumpWidget(
      MaterialApp(theme: SiagaTheme.light, home: const LayarKeluarga()),
    );
    await t.tap(find.text('Tambah Anggota'));
    await t.pumpAndSettle();
    await t.tap(find.text('Simpan Anggota'));
    await t.pumpAndSettle();
    expect(find.text('Nama wajib diisi.'), findsOneWidget);
    await t.enterText(find.byType(TextFormField).at(0), 'Warga Uji');
    await t.enterText(find.byType(TextFormField).at(1), 'Anak');
    await t.tap(find.text('Simpan Anggota'));
    await t.pumpAndSettle();
    expect(find.text('Warga Uji'), findsOneWidget);
    await t.tap(find.text('Edit'));
    await t.pumpAndSettle();
    await t.enterText(find.byType(TextFormField).at(0), 'Warga Baru');
    await t.tap(find.text('Simpan Anggota'));
    await t.pumpAndSettle();
    expect(find.text('Warga Baru'), findsOneWidget);
    await t.tap(find.text('Hapus'));
    await t.pumpAndSettle();
    await t.tap(find.text('Batal'));
    await t.pumpAndSettle();
    expect(find.text('Warga Baru'), findsOneWidget);
    await t.tap(find.text('Hapus'));
    await t.pumpAndSettle();
    await t.tap(find.widgetWithText(FilledButton, 'Hapus'));
    await t.pumpAndSettle();
    expect(find.text('Warga Baru'), findsNothing);
  });
}
