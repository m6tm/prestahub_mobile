import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_theme.dart';
import '../widgets/settings_scaffold.dart';

/// Représente une section d'un document légal (titre + paragraphes).
class LegalSection {
  final String title;
  final List<String> paragraphs;

  const LegalSection({required this.title, required this.paragraphs});
}

/// Rendu générique d'un document légal (CGU, politique, mentions).
class LegalDocumentView extends StatelessWidget {
  final String title;
  final String subtitle;
  final String lastUpdated;
  final List<LegalSection> sections;

  const LegalDocumentView({
    super.key,
    required this.title,
    required this.subtitle,
    required this.lastUpdated,
    required this.sections,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      title: title,
      subtitle: subtitle,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        physics: const BouncingScrollPhysics(),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: PrestaHubTheme.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.update_rounded,
                    size: 14, color: PrestaHubTheme.primary),
                const SizedBox(width: 6),
                Text(
                  'Dernière mise à jour : $lastUpdated',
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: PrestaHubTheme.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ...sections.asMap().entries.map((e) {
            final index = e.key + 1;
            final s = e.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$index. ${s.title}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: PrestaHubTheme.textLight,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...s.paragraphs.map((p) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          p,
                          style: GoogleFonts.inter(
                            fontSize: 13.5,
                            color: PrestaHubTheme.textMutedLight,
                            height: 1.55,
                          ),
                        ),
                      )),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
