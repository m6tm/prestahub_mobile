import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_theme.dart';
import '../../settings/widgets/settings_scaffold.dart';
import 'models/provider_review_models.dart';

/// Détail d'un avis reçu avec possibilité d'y répondre publiquement.
class ProviderReviewDetailScreen extends StatefulWidget {
  final String reviewId;
  final ProviderReview? initial;

  const ProviderReviewDetailScreen({
    super.key,
    required this.reviewId,
    this.initial,
  });

  @override
  State<ProviderReviewDetailScreen> createState() =>
      _ProviderReviewDetailScreenState();
}

class _ProviderReviewDetailScreenState
    extends State<ProviderReviewDetailScreen> {
  late ProviderReview? _review;
  final _replyCtrl = TextEditingController();
  bool _submitting = false;
  bool _editing = false;

  @override
  void initState() {
    super.initState();
    _review = widget.initial ?? ProviderReviewsMock.byId(widget.reviewId);
    _replyCtrl.text = _review?.providerResponse ?? '';
    _editing = _review != null && !_review!.hasResponse;
  }

  @override
  void dispose() {
    _replyCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final text = _replyCtrl.text.trim();
    if (text.isEmpty) return;
    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() {
      _review = _review!.copyWith(
        providerResponse: text,
        respondedAt: DateTime.now(),
      );
      _submitting = false;
      _editing = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Votre réponse a été publiée.'),
        backgroundColor: PrestaHubTheme.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final review = _review;
    if (review == null) {
      return SettingsScaffold(
        title: 'Avis',
        child: Center(
          child: Text(
            'Avis introuvable',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: PrestaHubTheme.textMutedLight,
            ),
          ),
        ),
      );
    }

    return SettingsScaffold(
      title: 'Détail de l\'avis',
      subtitle: review.missionTitle,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
        physics: const BouncingScrollPhysics(),
        children: [
          _ClientReviewCard(review: review),
          const SizedBox(height: 18),
          _SectionTitle('Votre réponse'),
          const SizedBox(height: 8),
          if (review.hasResponse && !_editing)
            _ExistingResponseCard(
              review: review,
              onEdit: () => setState(() => _editing = true),
            )
          else
            _ReplyForm(
              controller: _replyCtrl,
              submitting: _submitting,
              canCancel: review.hasResponse,
              onSubmit: _submit,
              onCancel: () {
                setState(() {
                  _replyCtrl.text = review.providerResponse ?? '';
                  _editing = false;
                });
              },
            ),
          const SizedBox(height: 16),
          _GuidanceCard(),
        ],
      ),
    );
  }
}

class _ClientReviewCard extends StatelessWidget {
  final ProviderReview review;
  const _ClientReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: PrestaHubTheme.accent,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  review.clientInitials,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.clientName,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: PrestaHubTheme.textLight,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatDate(review.createdAt),
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        color: PrestaHubTheme.textMutedLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              ...List.generate(5, (i) {
                return Padding(
                  padding: const EdgeInsets.only(right: 2),
                  child: Icon(
                    i < review.rating.round()
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                    color: PrestaHubTheme.warning,
                    size: 18,
                  ),
                );
              }),
              const SizedBox(width: 6),
              Text(
                review.rating.toStringAsFixed(1),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: PrestaHubTheme.textLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '« ${review.comment} »',
            style: GoogleFonts.inter(
              fontSize: 13.5,
              fontStyle: FontStyle.italic,
              color: PrestaHubTheme.textLight,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }
}

class _ExistingResponseCard extends StatelessWidget {
  final ProviderReview review;
  final VoidCallback onEdit;

  const _ExistingResponseCard({required this.review, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: PrestaHubTheme.success.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: PrestaHubTheme.success.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.reply_rounded,
                  color: PrestaHubTheme.success, size: 16),
              const SizedBox(width: 6),
              Text(
                'Réponse publiée',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: PrestaHubTheme.success,
                ),
              ),
              const Spacer(),
              if (review.respondedAt != null)
                Text(
                  _formatDate(review.respondedAt!),
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: PrestaHubTheme.textMutedLight,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            review.providerResponse!,
            style: GoogleFonts.inter(
              fontSize: 13.5,
              color: PrestaHubTheme.textLight,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: onEdit,
              icon: const Icon(Icons.edit_rounded, size: 14),
              label: Text(
                'Modifier',
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: TextButton.styleFrom(
                foregroundColor: PrestaHubTheme.primary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: const Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }
}

class _ReplyForm extends StatelessWidget {
  final TextEditingController controller;
  final bool submitting;
  final bool canCancel;
  final VoidCallback onSubmit;
  final VoidCallback onCancel;

  const _ReplyForm({
    required this.controller,
    required this.submitting,
    required this.canCancel,
    required this.onSubmit,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: controller,
          maxLines: 5,
          maxLength: 500,
          enabled: !submitting,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: PrestaHubTheme.textLight,
          ),
          decoration: InputDecoration(
            hintText:
                'Remerciez le client ou apportez un complément sur la mission.',
            hintStyle: GoogleFonts.inter(
              fontSize: 13.5,
              color: PrestaHubTheme.textMutedLight,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(14),
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
        const SizedBox(height: 12),
        Row(
          children: [
            if (canCancel)
              Expanded(
                child: SizedBox(
                  height: 46,
                  child: OutlinedButton(
                    onPressed: submitting ? null : onCancel,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: PrestaHubTheme.textMutedLight,
                      side: const BorderSide(color: PrestaHubTheme.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Annuler',
                      style: GoogleFonts.inter(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            if (canCancel) const SizedBox(width: 10),
            Expanded(
              flex: canCancel ? 1 : 1,
              child: SizedBox(
                height: 46,
                child: ElevatedButton.icon(
                  onPressed: submitting ? null : onSubmit,
                  icon: submitting
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.2,
                          ),
                        )
                      : const Icon(Icons.send_rounded, size: 16),
                  label: Text(
                    submitting ? 'Publication...' : 'Publier la réponse',
                    style: GoogleFonts.inter(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PrestaHubTheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _GuidanceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: PrestaHubTheme.info.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: PrestaHubTheme.info.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.tips_and_updates_rounded,
              color: PrestaHubTheme.info, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Votre réponse est publique. Restez courtois et professionnel, même face à une critique.',
              style: GoogleFonts.inter(
                fontSize: 12.5,
                color: PrestaHubTheme.textLight,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String label;
  const _SectionTitle(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: PrestaHubTheme.textMutedLight,
        letterSpacing: 0.8,
      ),
    );
  }
}
