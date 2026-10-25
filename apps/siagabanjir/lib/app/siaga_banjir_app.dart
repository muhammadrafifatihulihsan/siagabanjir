import 'package:flutter/material.dart';

import '../features/home/presentation/home_action.dart';
import '../features/home/presentation/home_preview_sheet.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/messages/presentation/messages_inbox_screen.dart';
import '../features/reports/presentation/report_create_screen.dart';
import '../shared/theme/siaga_theme.dart';

class SiagaBanjirApp extends StatelessWidget {
  const SiagaBanjirApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'SiagaBanjir',
    debugShowCheckedModeBanner: false,
    theme: SiagaTheme.light,
    home: Builder(
      builder: (context) =>
          HomeScreen(onOpen: (action) => _openPreview(context, action)),
    ),
  );

  Future<void> _openPreview(BuildContext context, HomeAction action) async {
    if (action == HomeAction.report) {
      await Navigator.push<void>(
        context,
        MaterialPageRoute(
          builder: (routeContext) => ReportCreateScreen(
            onNotifications: () =>
                _openPreview(routeContext, HomeAction.notifications),
            onHistory: () => _openPreview(routeContext, HomeAction.history),
            onProfile: () => _openPreview(routeContext, HomeAction.profile),
          ),
        ),
      );
      return;
    }
    if (action == HomeAction.notifications) {
      await Navigator.push<void>(
        context,
        MaterialPageRoute(
          builder: (routeContext) => MessagesInboxScreen(
            onReport: () => _openPreview(routeContext, HomeAction.report),
            onHistory: () => _openPreview(routeContext, HomeAction.history),
            onProfile: () => _openPreview(routeContext, HomeAction.profile),
          ),
        ),
      );
      return;
    }
    final next = await showModalBottomSheet<HomeAction>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) => HomePreviewSheet(action: action),
    );
    if (next != null && context.mounted) {
      await _openPreview(context, next);
    }
  }
}
