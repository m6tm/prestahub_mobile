import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../reviews/models/review_context.dart';

class MissionDetailScreen extends StatelessWidget {
  final String missionId;
  const MissionDetailScreen({super.key, required this.missionId});

  static const _review = _ReviewData(
    rating: 5.0,
    date: '16 avril 2026',
    comment:
        'Intervention parfaite, travail soigné et propre. Jean a été très professionnel et a pris le temps d\'expliquer le fonctionnement du chauffe-eau. Je recommande sans hésitation.',
  );

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark
          .copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        backgroundColor: PrestaHubTheme.backgroundLight,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildStatusBadge(),
                    const SizedBox(height: 14),
                    _buildProviderCard(),
                    const SizedBox(height: 14),
                    _buildInvoiceCard(),
                    const SizedBox(height: 14),
                    _buildSection(
                      title: 'Détails',
                      icon: Icons.description_outlined,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _kv('Catégorie', 'Plomberie'),
                          const SizedBox(height: 8),
                          _kv('Date d\'intervention', '15 avr. 2026, 9h-12h'),
                          const SizedBox(height: 8),
                          _kv(
                            'Lieu',
                            '12 rue de la République\n75011 Paris',
                          ),
                          const SizedBox(height: 8),
                          _kv('Durée', '2h 45'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    _buildReviewCard(),
                  ],
                ),
              ),
              _buildBottomBar(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: PrestaHubTheme.surfaceLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: PrestaHubTheme.border),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  size: 16, color: PrestaHubTheme.textMutedLight),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Installation chauffe-eau',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: PrestaHubTheme.textLight,
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  missionId,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: PrestaHubTheme.textMutedLight,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: PrestaHubTheme.surfaceLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: PrestaHubTheme.border),
              ),
              child: const Icon(Icons.file_download_outlined,
                  size: 18, color: PrestaHubTheme.textMutedLight),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: PrestaHubTheme.success.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: PrestaHubTheme.success.withValues(alpha: 0.30),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: PrestaHubTheme.success,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.task_alt_rounded,
                color: PrestaHubTheme.primaryContent, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mission terminée',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: PrestaHubTheme.success,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Clôturée le 15 avril 2026',
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

  Widget _buildProviderCard() {
    final primarySoft = PrestaHubTheme.primary.withValues(alpha: 0.10);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: PrestaHubTheme.backgroundLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: PrestaHubTheme.border),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: primarySoft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Center(
              child: Text(
                'JD',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: PrestaHubTheme.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Jean Dupont',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: PrestaHubTheme.textLight,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.verified_rounded,
                        size: 13, color: PrestaHubTheme.primary),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Plombier expert · Paris',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: PrestaHubTheme.textMutedLight,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.star_rounded,
                        size: 13, color: PrestaHubTheme.warning),
                    const SizedBox(width: 3),
                    Text(
                      '4.9',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: PrestaHubTheme.textMutedLight,
                      ),
                    ),
                    Text(
                      '  (127 avis)',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: PrestaHubTheme.borderStrong,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: primarySoft,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.arrow_forward_ios_rounded,
                color: PrestaHubTheme.primary, size: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: PrestaHubTheme.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: PrestaHubTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.receipt_long_outlined,
                  size: 15, color: PrestaHubTheme.primary),
              const SizedBox(width: 7),
              Text(
                'Facturation',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: PrestaHubTheme.textLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _lineItem('Installation chauffe-eau', '180 €'),
          const SizedBox(height: 6),
          _lineItem('Fournitures', '30 €'),
          const SizedBox(height: 10),
          Container(height: 1, color: PrestaHubTheme.border),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total payé',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: PrestaHubTheme.textLight,
                ),
              ),
              Text(
                '210 €',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: PrestaHubTheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _lineItem(String label, String price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12.5,
            color: PrestaHubTheme.textMutedLight,
          ),
        ),
        Text(
          price,
          style: GoogleFonts.inter(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: PrestaHubTheme.textLight,
          ),
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: PrestaHubTheme.backgroundLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: PrestaHubTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 15, color: PrestaHubTheme.primary),
              const SizedBox(width: 7),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: PrestaHubTheme.textLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _kv(String k, String v) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(
            k,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: PrestaHubTheme.borderStrong,
            ),
          ),
        ),
        Expanded(
          child: Text(
            v,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: PrestaHubTheme.textLight,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: PrestaHubTheme.backgroundLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: PrestaHubTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.rate_review_outlined,
                  size: 15, color: PrestaHubTheme.primary),
              const SizedBox(width: 7),
              Text(
                'Votre avis',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: PrestaHubTheme.textLight,
                ),
              ),
              const Spacer(),
              Text(
                _review.date,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: PrestaHubTheme.borderStrong,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              ...List.generate(
                5,
                (i) => Padding(
                  padding: const EdgeInsets.only(right: 2),
                  child: Icon(
                    i < _review.rating.round()
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    size: 18,
                    color: PrestaHubTheme.warning,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _review.rating.toStringAsFixed(1),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: PrestaHubTheme.textLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            _review.comment,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: PrestaHubTheme.textMutedLight,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 12 + bottomPad),
      decoration: const BoxDecoration(
        color: PrestaHubTheme.backgroundLight,
        border: Border(top: BorderSide(color: PrestaHubTheme.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: PrestaHubTheme.backgroundLight,
                  border: Border.all(color: PrestaHubTheme.border),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.file_download_outlined,
                        size: 16, color: PrestaHubTheme.textMutedLight),
                    const SizedBox(width: 6),
                    Text(
                      'Facture',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: PrestaHubTheme.textMutedLight,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              onTap: () => context.push(
                AppConstants.routeClientMissionReview
                    .replaceFirst(':id', missionId),
                extra: ReviewMissionContext(
                  missionId: missionId,
                  missionTitle: 'Installation chauffe-eau',
                  providerName: 'Jean Dupont',
                  providerInitials: 'JD',
                  completedOn: '15 avril 2026',
                ),
              ),
              child: Container(
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: PrestaHubTheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.star_rounded,
                        size: 16, color: PrestaHubTheme.primaryContent),
                    const SizedBox(width: 6),
                    Text(
                      'Modifier mon avis',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: PrestaHubTheme.primaryContent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewData {
  final double rating;
  final String date;
  final String comment;
  const _ReviewData({
    required this.rating,
    required this.date,
    required this.comment,
  });
}
