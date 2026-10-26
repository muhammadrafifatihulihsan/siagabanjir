import 'package:flutter/material.dart';

import '../../../../shared/theme/siaga_theme.dart';
import '../../domain/siaga_message.dart';

// Kartu pesan peringatan siaga dengan aksen garis warna, badge, dan tombol aksi.
class MessageCard extends StatelessWidget {
  const MessageCard({
    super.key,
    required this.message,
    required this.onAction,
    this.onTap,
  });

  final SiagaMessage message;
  final ValueChanged<String> onAction;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    label: '${message.badgeLabel}, ${message.title}, dari ${message.agency}',
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: SiagaTheme.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (message.leftStripeColor != null)
                  Container(
                    width: 4,
                    color: message.leftStripeColor,
                  ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: message.badgeBackground,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                message.badgeLabel,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: message.badgeTextColor,
                                ),
                              ),
                            ),
                            Text(
                              message.timestamp,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: SiagaTheme.muted,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          message.agency,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1D4ED8),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          message.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: SiagaTheme.ink,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          message.body,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF334155),
                            height: 1.4,
                          ),
                        ),
                        if (message.actions.isNotEmpty) ...[
                          const SizedBox(height: 14),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: message.actions.map(_actionButton).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  Widget _actionButton(String actionLabel) {
    final isSecondary = actionLabel == 'Bagikan';
    return Semantics(
      button: true,
      label: actionLabel,
      child: Material(
        color: isSecondary ? const Color(0xFFF1F5F9) : const Color(0xFFEFF6FF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: isSecondary
              ? BorderSide.none
              : const BorderSide(color: Color(0xFFBFDBFE)),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => onAction(actionLabel),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              actionLabel,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSecondary
                    ? SiagaTheme.ink
                    : const Color(0xFF2563EB),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
