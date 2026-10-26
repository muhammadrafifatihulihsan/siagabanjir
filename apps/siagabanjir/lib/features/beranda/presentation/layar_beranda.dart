import 'package:flutter/material.dart';
import 'package:siagabanjir/shared/widgets/citizen_header.dart';

import '../../../shared/theme/siaga_theme.dart';
import 'aksi_beranda.dart';
import 'widgets/kartu_fitur_beranda.dart';
import 'widgets/navigasi_beranda.dart';
import 'widgets/akses_cepat_beranda.dart';
import 'widgets/kartu_status_beranda.dart';

class LayarBeranda extends StatefulWidget {
  const LayarBeranda({super.key, required this.onOpen});

  final ValueChanged<AksiBeranda> onOpen;

  @override
  State<LayarBeranda> createState() => _LayarBerandaState();
}

class _LayarBerandaState extends State<LayarBeranda> {
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
              CitizenHeader(
                onNotifications: () => widget.onOpen(AksiBeranda.notifications),
              ),
              Expanded(
                child: SingleChildScrollView(
                  key: const PageStorageKey('home-scroll'),
                  controller: _scroll,
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      KartuStatusBeranda(
                        onMonitor: () => widget.onOpen(AksiBeranda.monitor),
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
                            onPressed: () => widget.onOpen(AksiBeranda.all),
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
                      AksesCepatBeranda(onOpen: widget.onOpen),
                      const SizedBox(height: 16),
                      KartuFiturBeranda(
                        action: AksiBeranda.documents,
                        onTap: () => widget.onOpen(AksiBeranda.documents),
                      ),
                      const SizedBox(height: 16),
                      KartuFiturBeranda(
                        action: AksiBeranda.report,
                        onTap: () => widget.onOpen(AksiBeranda.report),
                      ),
                    ],
                  ),
                ),
              ),
              NavigasiBeranda(onOpen: widget.onOpen, onHome: _backToTop),
            ],
          ),
        ),
      ),
    ),
  );
}
