import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import 'models/provider_review_models.dart';

/// Liste des avis reçus par le prestataire avec statistiques globales.
class ProviderReviewsScreen extends StatefulWidget {
  const ProviderReviewsScreen({super.key});

  @override
  State<ProviderReviewsScreen> createState() => _ProviderReviewsScreenState();
}

class _ProviderReviewsScreenState extends State<ProviderReviewsScreen> {
  int _filterStars = 0;

  List<ProviderReview> get _filtered {
    if (_filterStars == 0) return ProviderReviewsMock.reviews;
    return ProviderReviewsMock.reviews
        .where((r) => r.rating.round() == _filterStars)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final items = _filtered;
    final average = ProviderReviewsMock.averageRating();
    final total = ProviderReviewsMock.reviews.length;
    final distribution = ProviderReviewsMock.distribution();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark
          .copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        backgroundColor: PrestaHubTheme.backgroundLight,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _RatingSummary(
                      average: average,
                      total: total,
                      distribution: distribution,
                    ),
                    const SizedBox(height: 18),
                    _FiltersRow(
                      selected: _filterStars,
                      onChanged: (v) => setState(() => _filterStars = v),
                    ),
                    const SizedBox(height: 14),
                    if (items.isEmpty)
                      _EmptyState(filterActive: _filterStars > 0)
                    else
                      ...items.map(
                        (r) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _ReviewCard(
                            review: r,
                            onTap: () => context.push(
                              AppConstants.routeProviderReviewDetail
                                  .replaceFirst(':id', r.id),
                              extra: r,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: PrestaHubTheme.surface2Light,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.arrow_back_rounded,
                  size: 20, color: PrestaHubTheme.textLight),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Avis reçus',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: PrestaHubTheme.textLight,
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  'Retours des clients sur vos missions',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: PrestaHubTheme.textMutedLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RatingSummary extends StatelessWidget {
  final double average;
  final int total;
  final Map<int, int> distribution;

  const _RatingSummary({
    required this.average,
    required this.total,
    required this.distribution,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: PrestaHubTheme.border),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                total > 0 ? average.toStringAsFixed(1) : '—',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 38,
                  fontWeight: FontWeight.w800,
                  color: PrestaHubTheme.textLight,
                  letterSpacing: -1,
                  height: 1,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (i) {
                  return Icon(
                    i < average.round()
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                    color: PrestaHubTheme.warning,
                    size: 14,
                  );
                }),
              ),
              const SizedBox(height: 4),
              Text(
                '$total avis',
                style: GoogleFonts.inter(
                  fontSize: 11.5,
                  color: PrestaHubTheme.textMutedLight,
                ),
              ),
            ],
          ),
          const SizedBox(width: 18),
          Container(
            width: 1,
            height: 96,
            color: PrestaHubTheme.border,
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              children: [5, 4, 3, 2, 1].map((stars) {
                final count = distribution[stars] ?? 0;
                final pct = total == 0 ? 0.0 : count / total;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Text(
                        '$stars',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: PrestaHubTheme.textMutedLight,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.star_rounded,
                          size: 11, color: PrestaHubTheme.warning),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: LinearProgressIndicator(
                            value: pct,
                            minHeight: 5,
                            backgroundColor: PrestaHubTheme.surface2Light,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              PrestaHubTheme.warning,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 18,
                        child: Text(
                          count.toString(),
                          textAlign: TextAlign.end,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: PrestaHubTheme.textMutedLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _FiltersRow extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onChanged;

  const _FiltersRow({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final items = [
      const (0, 'Tous'),
      const (5, '5 étoiles'),
      const (4, '4 étoiles'),
      const (3, '3 étoiles'),
      const (2, '2 étoiles'),
      const (1, '1 étoile'),
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: items.map((entry) {
          final (value, label) = entry;
          final active = value == selected;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onChanged(value),
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: active
                      ? PrestaHubTheme.primary
                      : PrestaHubTheme.surface2Light,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: active
                        ? Colors.white
                        : PrestaHubTheme.textMutedLight,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final ProviderReview review;
  final VoidCallback onTap;

  const _ReviewCard({required this.review, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: PrestaHubTheme.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: PrestaHubTheme.accent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      review.clientInitials,
                      style: GoogleFonts.inter(
                        fontSize: 13,
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
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: PrestaHubTheme.textLight,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          review.missionTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: PrestaHubTheme.textMutedLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    _formatDate(review.createdAt),
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: PrestaHubTheme.textMutedLight,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: List.generate(5, (i) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 2),
                    child: Icon(
                      i < review.rating.round()
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      color: PrestaHubTheme.warning,
                      size: 16,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 8),
              Text(
                review.comment,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: PrestaHubTheme.textLight,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  if (review.hasResponse)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: PrestaHubTheme.success.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.reply_rounded,
                              size: 11, color: PrestaHubTheme.success),
                          const SizedBox(width: 3),
                          Text(
                            'Répondu',
                            style: GoogleFonts.inter(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: PrestaHubTheme.success,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: PrestaHubTheme.warning.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.reply_outlined,
                              size: 11, color: PrestaHubTheme.warning),
                          const SizedBox(width: 3),
                          Text(
                            'À répondre',
                            style: GoogleFonts.inter(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: PrestaHubTheme.warning,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const Spacer(),
                  const Icon(Icons.chevron_right_rounded,
                      size: 20, color: PrestaHubTheme.textMutedLight),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}';
  }
}

class _EmptyState extends StatelessWidget {
  final bool filterActive;
  const _EmptyState({required this.filterActive});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: PrestaHubTheme.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(Icons.reviews_outlined,
                color: PrestaHubTheme.primary, size: 32),
          ),
          const SizedBox(height: 14),
          Text(
            filterActive
                ? 'Aucun avis dans cette catégorie'
                : 'Aucun avis pour l\'instant',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: PrestaHubTheme.textLight,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            filterActive
                ? 'Essayez un autre filtre ou affichez tous les avis.'
                : 'Vos premiers avis apparaîtront ici après vos premières missions terminées.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 12.5,
              color: PrestaHubTheme.textMutedLight,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
