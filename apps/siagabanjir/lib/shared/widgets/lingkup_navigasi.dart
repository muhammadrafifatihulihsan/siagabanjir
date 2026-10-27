import 'package:flutter/widgets.dart';

/// Menandai layar yang memakai header/navbar milik kerangka aplikasi.
class LingkupNavigasi extends InheritedWidget {
  const LingkupNavigasi({super.key, required super.child});

  static bool aktif(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<LingkupNavigasi>() != null;

  @override
  bool updateShouldNotify(LingkupNavigasi oldWidget) => false;
}
