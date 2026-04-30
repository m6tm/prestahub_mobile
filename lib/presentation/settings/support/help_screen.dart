import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../widgets/settings_scaffold.dart';

class _FaqEntry {
  final String question;
  final String answer;
  final String category;

  const _FaqEntry({
    required this.question,
    required this.answer,
    required this.category,
  });
}

/// Centre d'aide : FAQ + entrées support.
class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';
  int? _expanded;

  static const _faq = [
    _FaqEntry(
      category: 'Compte',
      question: 'Comment modifier mon mot de passe ?',
      answer:
          'Rendez-vous dans Paramètres > Sécurité > Mot de passe. Vous aurez besoin de votre mot de passe actuel pour en définir un nouveau.',
    ),
    _FaqEntry(
      category: 'Compte',
      question: 'Comment vérifier mon email ?',
      answer:
          'Un email est envoyé à votre inscription. Cliquez sur le lien qu\'il contient. Vous pouvez en renvoyer un depuis votre profil.',
    ),
    _FaqEntry(
      category: 'Demandes',
      question: 'Comment créer une demande de service ?',
      answer:
          'Depuis l\'accueil, appuyez sur "Nouvelle demande", choisissez une catégorie, remplissez le formulaire et validez.',
    ),
    _FaqEntry(
      category: 'Demandes',
      question: 'Puis-je annuler une demande ?',
      answer:
          'Oui, tant que la mission n\'a pas été acceptée par un prestataire. Ouvrez la demande et sélectionnez "Annuler".',
    ),
    _FaqEntry(
      category: 'Paiement',
      question: 'Quels moyens de paiement sont acceptés ?',
      answer:
          'Cartes Visa, Mastercard et virement instantané selon la disponibilité du prestataire.',
    ),
    _FaqEntry(
      category: 'Prestataire',
      question: 'Comment devenir prestataire ?',
      answer:
          'Inscrivez-vous avec le rôle Prestataire, puis complétez votre profil professionnel et soumettez vos justificatifs.',
    ),
  ];

  List<_FaqEntry> get _filtered {
    if (_query.trim().isEmpty) return _faq;
    final q = _query.toLowerCase();
    return _faq
        .where((e) =>
            e.question.toLowerCase().contains(q) ||
            e.answer.toLowerCase().contains(q) ||
            e.category.toLowerCase().contains(q))
        .toList();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final entries = _filtered;
    return SettingsScaffold(
      title: 'Aide & FAQ',
      subtitle: 'Trouvez des réponses à vos questions',
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _query = v),
              style: GoogleFonts.inter(
                  fontSize: 14, color: PrestaHubTheme.textLight),
              decoration: InputDecoration(
                hintText: 'Rechercher une question...',
                hintStyle: GoogleFonts.inter(
                    fontSize: 13.5, color: PrestaHubTheme.textMutedLight),
                prefixIcon: const Icon(Icons.search_rounded,
                    color: PrestaHubTheme.textMutedLight),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: PrestaHubTheme.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                      color: PrestaHubTheme.primary, width: 1.5),
                ),
              ),
            ),
          ),
          Expanded(
            child: entries.isEmpty
                ? _Empty(query: _query)
                : ListView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      ...entries.asMap().entries.map((e) => _FaqTile(
                            entry: e.value,
                            expanded: _expanded == e.key,
                            onTap: () => setState(() {
                              _expanded = _expanded == e.key ? null : e.key;
                            }),
                          )),
                      const SizedBox(height: 18),
                      _ContactCard(
                        onTap: () => context.push(
                            AppConstants.routeSettingsContactSupport),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _FaqTile extends StatelessWidget {
  final _FaqEntry entry;
  final bool expanded;
  final VoidCallback onTap;

  const _FaqTile({
    required this.entry,
    required this.expanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: PrestaHubTheme.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: PrestaHubTheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    entry.category,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: PrestaHubTheme.primary,
                    ),
                  ),
                ),
                const Spacer(),
                AnimatedRotation(
                  duration: const Duration(milliseconds: 200),
                  turns: expanded ? 0.5 : 0,
                  child: const Icon(Icons.keyboard_arrow_down_rounded,
                      color: PrestaHubTheme.textMutedLight),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              entry.question,
              style: GoogleFonts.inter(
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                color: PrestaHubTheme.textLight,
              ),
            ),
            if (expanded) ...[
              const SizedBox(height: 8),
              Text(
                entry.answer,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: PrestaHubTheme.textMutedLight,
                  height: 1.5,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final VoidCallback onTap;

  const _ContactCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: PrestaHubTheme.primary,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.support_agent_rounded,
                  color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Besoin d\'aide supplémentaire ?',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Contactez notre équipe support',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  final String query;

  const _Empty({required this.query});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off_rounded,
                size: 48, color: PrestaHubTheme.textMutedLight),
            const SizedBox(height: 12),
            Text(
              'Aucun résultat pour "$query"',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: PrestaHubTheme.textMutedLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
