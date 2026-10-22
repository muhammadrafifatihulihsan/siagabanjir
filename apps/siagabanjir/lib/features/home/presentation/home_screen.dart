import 'package:flutter/material.dart';

import '../../../shared/theme/siaga_theme.dart';
import 'home_action.dart';
import 'widgets/home_feature_card.dart';
import 'widgets/home_header.dart';
import 'widgets/home_navigation.dart';
import 'widgets/home_quick_access.dart';
import 'widgets/home_status_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.onOpen});

  final ValueChanged<HomeAction> onOpen;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scroll = ScrollController();

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _backToTop() {
    if (MediaQuery.disableAnimationsOf(context)) {
      _scroll.jumpTo(0);
    } else {
      _scroll.animateTo(
        0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            children: [
              HomeHeader(
                onNotifications: () => widget.onOpen(HomeAction.notifications),
              ),
              Expanded(
                child: SingleChildScrollView(
                  key: const PageStorageKey('home-scroll'),
                  controller: _scroll,
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      HomeStatusCard(
                        onMonitor: () => widget.onOpen(HomeAction.monitor),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Akses Kesiapsiagaan',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => widget.onOpen(HomeAction.all),
                            style: TextButton.styleFrom(
                              foregroundColor: SiagaTheme.blue,
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(60, 48),
                            ),
                            child: const Text(
                              'Lengkap',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      HomeQuickAccess(onOpen: widget.onOpen),
                      const SizedBox(height: 16),
                      HomeFeatureCard(
                        action: HomeAction.documents,
                        onTap: () => widget.onOpen(HomeAction.documents),
                      ),
                      const SizedBox(height: 16),
                      HomeFeatureCard(
                        action: HomeAction.report,
                        onTap: () => widget.onOpen(HomeAction.report),
                      ),
                    ],
                  ),
                ),
              ),
              HomeNavigation(onOpen: widget.onOpen, onHome: _backToTop),
            ],
          ),
        ),
      ),
    ),
  );
}
