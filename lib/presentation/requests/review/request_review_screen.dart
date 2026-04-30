import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../models/service_request_models.dart';

class RequestReviewScreen extends StatelessWidget {
  final ServiceRequestDraft draft;
  const RequestReviewScreen({super.key, required this.draft});

  String _formatDate(DateTime? d) {
    if (d == null) return '—';
    const months = [
      'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
      'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final primarySoft = PrestaHubTheme.primary.withValues(alpha: 0.10);
    final primarySoftBorder = PrestaHubTheme.primary.withValues(alpha: 0.25);

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
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildHero(primarySoft, primarySoftBorder),
                    const SizedBox(height: 20),
                    _buildSection(
                      title: 'Description',
                      icon: Icons.description_outlined,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            draft.title,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: PrestaHubTheme.textLight,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            draft.description,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: PrestaHubTheme.textMutedLight,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (draft.photos.isNotEmpty) ...[
                      _buildSection(
                        title: 'Photos (${draft.photos.length})',
                        icon: Icons.image_outlined,
                        child: SizedBox(
                          height: 72,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: draft.photos.length,
                            itemBuilder: (context, i) => Container(
                              width: 72,
                              margin: EdgeInsets.only(
                                right: i == draft.photos.length - 1 ? 0 : 10,
                              ),
                              decoration: BoxDecoration(
                                color: primarySoft,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: primarySoftBorder),
                              ),
                              child: const Icon(
                                Icons.image_rounded,
                                color: PrestaHubTheme.primary,
                                size: 26,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    _buildSection(
                      title: 'Adresse',
                      icon: Icons.location_on_outlined,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            draft.address,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: PrestaHubTheme.textLight,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (draft.addressComplement.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              draft.addressComplement,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: PrestaHubTheme.textMutedLight,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildSection(
                      title: 'Créneau souhaité',
                      icon: Icons.event_outlined,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _kv('Date', _formatDate(draft.preferredDate)),
                          const SizedBox(height: 6),
                          _kv('Horaire', draft.preferredSlot),
                          const SizedBox(height: 6),
                          _kv('Urgence', draft.urgency),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildNotice(),
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
                  'Récapitulatif',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: PrestaHubTheme.textLight,
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  'Vérifiez avant d\'envoyer',
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

  Widget _buildHero(Color primarySoft, Color primarySoftBorder) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primarySoft,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: primarySoftBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: PrestaHubTheme.primary,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              draft.categoryIcon ?? Icons.handyman_rounded,
              color: PrestaHubTheme.primaryContent,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  draft.categoryLabel ?? 'Catégorie',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: PrestaHubTheme.textLight,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Demande envoyée aux prestataires de cette catégorie',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: PrestaHubTheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
          width: 70,
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
              color: PrestaHubTheme.textLight,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotice() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: PrestaHubTheme.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: PrestaHubTheme.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: PrestaHubTheme.textMutedLight,
            size: 16,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Une fois envoyée, votre demande est partagée avec les prestataires disponibles. Vous recevrez les premières propositions sous 15 min en moyenne.',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: PrestaHubTheme.textMutedLight,
                height: 1.5,
              ),
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
              onTap: () => Navigator.pop(context),
              child: Container(
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: PrestaHubTheme.backgroundLight,
                  border: Border.all(color: PrestaHubTheme.border),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Modifier',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: PrestaHubTheme.textMutedLight,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              onTap: () => context.go(
                AppConstants.routeClientRequestConfirmation,
                extra: draft,
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
                    const Icon(
                      Icons.send_rounded,
                      color: PrestaHubTheme.primaryContent,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Envoyer la demande',
                      style: GoogleFonts.inter(
                        fontSize: 14,
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
