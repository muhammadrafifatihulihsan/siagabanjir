import 'package:flutter/material.dart';

import '../../../shared/widgets/citizen_navigation.dart';
import '../domain/siaga_message.dart';
import 'widgets/message_card.dart';
import 'widgets/message_dialogs.dart';
import 'widgets/messages_filter_tabs.dart';
import 'widgets/messages_header.dart';

// Layar Kotak Masuk Pesan Peringatan Siaga sesuai SVG messages_inbox.
class MessagesInboxScreen extends StatefulWidget {
  const MessagesInboxScreen({
    super.key,
    required this.onReport,
    required this.onHistory,
    required this.onProfile,
  });

  final VoidCallback onReport;
  final VoidCallback onHistory;
  final VoidCallback onProfile;

  @override
  State<MessagesInboxScreen> createState() => _MessagesInboxScreenState();
}

class _MessagesInboxScreenState extends State<MessagesInboxScreen> {
  MessageCategory _selectedCategory = MessageCategory.all;

  // Filter daftar pesan berdasarkan kategori tab terpilih.
  List<SiagaMessage> get _filteredMessages {
    if (_selectedCategory == MessageCategory.all) {
      return kSampleSiagaMessages;
    }
    return kSampleSiagaMessages
        .where((msg) => msg.category == _selectedCategory)
        .toList();
  }

  // Hitung pesan dengan status baru untuk indikator header.
  int get _unreadCount =>
      kSampleSiagaMessages.where((msg) => msg.isNew).length;

  void _onNavigationSelect(CitizenDestination destination) {
    switch (destination) {
      case CitizenDestination.home:
        Navigator.pop(context);
      case CitizenDestination.report:
        widget.onReport();
      case CitizenDestination.history:
        widget.onHistory();
      case CitizenDestination.profile:
        widget.onProfile();
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
              MessagesHeader(
                onBack: () => Navigator.pop(context),
                unreadCount: _unreadCount,
              ),
              MessagesFilterTabs(
                selected: _selectedCategory,
                onSelect: (category) =>
                    setState(() => _selectedCategory = category),
                totalCount: kSampleSiagaMessages.length,
                emergencyCount: kSampleSiagaMessages
                    .where((m) => m.category == MessageCategory.emergency)
                    .length,
                weatherCount: kSampleSiagaMessages
                    .where((m) => m.category == MessageCategory.weather)
                    .length,
                shelterCount: kSampleSiagaMessages
                    .where((m) => m.category == MessageCategory.shelter)
                    .length,
              ),
              Expanded(
                child: _filteredMessages.isEmpty
                    ? const Center(
                        child: Text(
                          'Tidak ada pesan pada kategori ini.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                        itemCount: _filteredMessages.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final msg = _filteredMessages[index];
                          return MessageCard(
                            message: msg,
                            onAction: (action) =>
                                showMessageActionExplanation(
                              context,
                              action,
                              msg,
                            ),
                            onTap: () => showMessageDetail(context, msg),
                          );
                        },
                      ),
              ),
              CitizenNavigation(
                selected: CitizenDestination.home,
                onSelect: _onNavigationSelect,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
