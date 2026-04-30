import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_theme.dart';
import 'models/review_context.dart';

/// Motifs de signalement proposés à l'utilisateur.
enum _ReportReason {
  offensive,
  spam,
  fake,
  harassment,
  privacy,
  other,
}

extension _ReportReasonX on _ReportReason {
  String get label => switch (this) {
        _ReportReason.offensive => 'Contenu offensant',
        _ReportReason.spam => 'Spam ou publicité',
        _ReportReason.fake => 'Avis mensonger',
        _ReportReason.harassment => 'Harcèlement',
        _ReportReason.privacy => 'Atteinte à la vie privée',
        _ReportReason.other => 'Autre motif',
      };

  String get description => switch (this) {
        _ReportReason.offensive =>
          'Propos insultants, haineux ou discriminatoires',
        _ReportReason.spam => 'Message commercial non sollicité',
        _ReportReason.fake => 'Avis factice ou ne concernant pas la mission',
        _ReportReason.harassment => 'Propos visant à nuire à une personne',
        _ReportReason.privacy =>
          'Informations personnelles divulguées sans accord',
        _ReportReason.other => 'Je souhaite préciser dans les détails',
      };

  IconData get icon => switch (this) {
        _ReportReason.offensive => Icons.report_problem_outlined,
        _ReportReason.spam => Icons.campaign_outlined,
        _ReportReason.fake => Icons.fact_check_outlined,
        _ReportReason.harassment => Icons.block_rounded,
        _ReportReason.privacy => Icons.lock_outline_rounded,
        _ReportReason.other => Icons.more_horiz_rounded,
      };
}

/// Écran de signalement d'un avis : motif + description libre.
class ReportReviewScreen extends StatefulWidget {
  final String reviewId;
  final ReportReviewContext? context;

  const ReportReviewScreen({
    super.key,
    required this.reviewId,
    this.context,
  });

  @override
  State<ReportReviewScreen> createState() => _ReportReviewScreenState();
}

class _ReportReviewScreenState extends State<ReportReviewScreen> {
  _ReportReason? _reason;
  final _detailsCtrl = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _detailsCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_reason == null) return;
    if (_reason == _ReportReason.other &&
        _detailsCtrl.text.trim().length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Précisez le motif (minimum 10 caractères).'),
          backgroundColor: PrestaHubTheme.warning,
        ),
      );
      return;
    }
    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _submitting = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
            'Signalement envoyé. Notre équipe de modération va l\'examiner.'),
        backgroundColor: PrestaHubTheme.success,
      ),
    );
    Navigator.of(context).maybePop(true);
  }

  @override
  Widget build(BuildContext context) {
    final ctx = widget.context;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark
          .copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        backgroundColor: PrestaHubTheme.surfaceLight,
        body: SafeArea(
          child: Column(
            children: [
              _Header(onBack: () => Navigator.of(context).maybePop()),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    if (ctx != null) _ReviewPreview(context: ctx),
                    if (ctx != null) const SizedBox(height: 16),
                    const _Banner(),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 2, bottom: 10),
                      child: Text(
                        'Motif du signalement',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: PrestaHubTheme.textLight,
                        ),
                      ),
                    ),
                    ..._ReportReason.values.map((r) => _ReasonTile(
                          reason: r,
                          selected: _reason == r,
                          onTap: () => setState(() => _reason = r),
                        )),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.only(left: 2, bottom: 10),
                      child: Text(
                        _reason == _ReportReason.other
                            ? 'Détails (obligatoire)'
                            : 'Détails complémentaires (optionnel)',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: PrestaHubTheme.textLight,
                        ),
                      ),
                    ),
                    TextField(
                      controller: _detailsCtrl,
                      maxLines: 5,
                      maxLength: 500,
                      style: GoogleFonts.inter(fontSize: 13.5),
                      decoration: InputDecoration(
                        hintText:
                            'Expliquez-nous pourquoi vous signalez cet avis...',
                        hintStyle: GoogleFonts.inter(
                          fontSize: 13.5,
                          color: PrestaHubTheme.textMutedLight,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: PrestaHubTheme.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: PrestaHubTheme.primary, width: 1.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _BottomBar(
                submitting: _submitting,
                enabled: _reason != null && !_submitting,
                onSubmit: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onBack;

  const _Header({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 20, 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: PrestaHubTheme.surface2Light,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.arrow_back_rounded,
                  color: PrestaHubTheme.textLight, size: 20),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Signaler un avis',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: PrestaHubTheme.textLight,
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  'Notre équipe de modération examinera votre signalement',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: PrestaHubTheme.textMutedLight,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewPreview extends StatelessWidget {
  final ReportReviewContext context;

  const _ReviewPreview({required this.context});

  @override
  Widget build(BuildContext ctx) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: PrestaHubTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.format_quote_rounded,
                  size: 18, color: PrestaHubTheme.primary),
              const SizedBox(width: 6),
              Text(
                'Avis de ${context.authorName}',
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: PrestaHubTheme.textLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            context.excerpt,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: PrestaHubTheme.textMutedLight,
              height: 1.5,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: PrestaHubTheme.info.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: PrestaHubTheme.info.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded,
              size: 18, color: PrestaHubTheme.info),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Les signalements abusifs peuvent entraîner une restriction de votre compte. Merci de n\'utiliser cette fonctionnalité qu\'en cas de problème réel.',
              style: GoogleFonts.inter(
                fontSize: 12.5,
                color: PrestaHubTheme.textLight,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReasonTile extends StatelessWidget {
  final _ReportReason reason;
  final bool selected;
  final VoidCallback onTap;

  const _ReasonTile({
    required this.reason,
    required this.selected,
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
          border: Border.all(
            color:
                selected ? PrestaHubTheme.primary : PrestaHubTheme.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: PrestaHubTheme.danger.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Icon(reason.icon,
                  size: 18, color: PrestaHubTheme.danger),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reason.label,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: PrestaHubTheme.textLight,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    reason.description,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: PrestaHubTheme.textMutedLight,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_unchecked_rounded,
              size: 22,
              color: selected
                  ? PrestaHubTheme.primary
                  : PrestaHubTheme.textMutedLight,
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final bool submitting;
  final bool enabled;
  final VoidCallback onSubmit;

  const _BottomBar({
    required this.submitting,
    required this.enabled,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 12 + bottomPad),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: PrestaHubTheme.border)),
      ),
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: enabled ? onSubmit : null,
          icon: submitting
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2.5),
                )
              : const Icon(Icons.flag_rounded, size: 18),
          label: Text(
            submitting ? 'Envoi...' : 'Envoyer le signalement',
            style: GoogleFonts.inter(
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: PrestaHubTheme.danger,
            foregroundColor: Colors.white,
            disabledBackgroundColor: PrestaHubTheme.borderStrong,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}
