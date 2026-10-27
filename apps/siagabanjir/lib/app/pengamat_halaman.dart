import 'package:flutter/material.dart';

class PengamatHalaman extends NavigatorObserver {
  final detailTerbuka = ValueNotifier(false);
  bool _disposed = false;

  void _perbarui(Route<dynamic>? route) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_disposed) {
        detailTerbuka.value = route != null && route.settings.name != '/';
      }
    });
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      _perbarui(route);

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      _perbarui(previousRoute);

  void dispose() {
    _disposed = true;
    detailTerbuka.dispose();
  }
}
