import 'package:flutter/material.dart';

import '../../../../shared/theme/siaga_theme.dart';
import '../../domain/family_document.dart';

// Kartu utama daftar berkas dokumen kependudukan keluarga sesuai desain documents_vault.svg.
class DocumentsVaultCard extends StatelessWidget {
  const DocumentsVaultCard({
    super.key,
    required this.documents,
    required this.onChangeDocument,
  });

  final List<FamilyDocument> documents;
  final ValueChanged<FamilyDocument> onChangeDocument;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: const Color(0xFFE2E8F0)),
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0A0F172A),
          blurRadius: 16,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < documents.length; i++) ...[
          if (i > 0) const SizedBox(height: 18),
          _buildDocumentSection(documents[i]),
        ],
      ],
    ),
  );

  Widget _buildDocumentSection(FamilyDocument doc) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      // Baris judul dokumen dan badge format berkas (Wrap agar adaptif di layar sempit)
      Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8,
        runSpacing: 4,
        children: [
          Text(
            doc.numberTitle,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
              height: 1.25,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              doc.badge,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF64748B),
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 10),

      // Wadah pratinjau berkas tersimpan
      LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 240;
          final iconBox = Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              border: Border.all(color: const Color(0xFFBFDBFE)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Icon(
                doc.icon,
                size: 22,
                color: const Color(0xFF2563EB),
              ),
            ),
          );

          final details = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                doc.fileName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                doc.subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: SiagaTheme.muted,
                  height: 1.3,
                ),
              ),
            ],
          );

          final button = Semantics(
            button: true,
            label: 'Ganti berkas ${doc.numberTitle}',
            child: SizedBox(
              height: 36,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF1D4ED8),
                  side: const BorderSide(color: Color(0xFFE2E8F0)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                ),
                onPressed: () => onChangeDocument(doc),
                child: const Text(
                  'Ganti',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1D4ED8),
                  ),
                ),
              ),
            ),
          );

          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              border: Border.all(color: const Color(0xFFCBD5E1)),
              borderRadius: BorderRadius.circular(14),
            ),
            child: isNarrow
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          iconBox,
                          const SizedBox(width: 10),
                          Expanded(child: details),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: button,
                      ),
                    ],
                  )
                : Row(
                    children: [
                      iconBox,
                      const SizedBox(width: 12),
                      Expanded(child: details),
                      const SizedBox(width: 8),
                      button,
                    ],
                  ),
          );
        },
      ),
    ],
  );
}
