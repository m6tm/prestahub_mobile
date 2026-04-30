import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_theme.dart';
import '../../requests/models/service_request_models.dart';
import 'models/provider_mission_models.dart';

/// Détail d'une mission passée côté prestataire.
///
/// Affiche le récapitulatif de la prestation et l'avis laissé par le client
/// si disponible.
class ProviderPastMissionDetailScreen extends StatelessWidget {
  final String missionId;
  final ProviderMissionSummary? initial;

  const ProviderPastMissionDetailScreen({
    super.key,
    required this.missionId,
    this.initial,
  });

  @override
  Widget build(BuildContext context) {
    final mission = initial ?? ProviderMissionsMock.missionById(missionId);
    if (mission == null) {
      return const _NotFound();
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark
          .copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        backgroundColor: PrestaHubTheme.surfaceLight,
        body: SafeArea(
          child: Column(
            children: [
              _Header(mission: mission),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Summary(mission: mission),
                      const SizedBox(height: 18),
                      _SectionTitle('Client'),
                      const SizedBox(height: 8),
                      _InfoTile(
                        icon: Icons.person_rounded,
                        label: mission.clientName,
                      ),
                      const SizedBox(height: 14),
                      _SectionTitle('Date'),
                      const SizedBox(height: 8),
                      _InfoTile(
                        icon: Icons.event_rounded,
                        label: mission.completedOn ?? mission.scheduledAt,
                      ),
                      const SizedBox(height: 14),
                      _SectionTitle('Adresse'),
                      const SizedBox(height: 8),
                      _InfoTile(
                        icon: Icons.location_on_rounded,
                        label: mission.address,
                      ),
                      const SizedBox(height: 14),
                      _SectionTitle('Tarif facturé'),
                      const SizedBox(height: 8),
                      _InfoTile(
                        icon: Icons.payments_rounded,
                        label: mission.price,
                      ),
                      const SizedBox(height: 22),
                      _SectionTitle('Avis du client'),
                      const SizedBox(height: 8),
                      if (mission.status == RequestStatus.cancelled)
                        _CancelledCard()
                      else if (mission.clientRating == null)
                        _NoReviewCard()
                      else
                        _ReviewCard(mission: mission),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final ProviderMissionSummary mission;
  const _Header({required this.mission});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: PrestaHubTheme.border),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).maybePop(),
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
                      size: 20, color: PrestaHubTheme.textLight),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: mission.status.softColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(mission.status.icon,
                        size: 13, color: mission.status.color),
                    const SizedBox(width: 5),
                    Text(
                      mission.status.label,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: mission.status.color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: PrestaHubTheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Icon(mission.categoryIcon,
                      color: PrestaHubTheme.primary, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mission.title,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: PrestaHubTheme.textLight,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${mission.category} · ${mission.id}',
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
          ),
        ],
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  final ProviderMissionSummary mission;
  const _Summary({required this.mission});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: PrestaHubTheme.border),
      ),
      child: Row(
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
              mission.clientInitials,
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
                  mission.clientName,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: PrestaHubTheme.textLight,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  mission.completedOn ?? mission.scheduledAt,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: PrestaHubTheme.textMutedLight,
                  ),
                ),
              ],
            ),
          ),
          Text(
            mission.price,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: PrestaHubTheme.primary,
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

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoTile({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: PrestaHubTheme.border),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: PrestaHubTheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: PrestaHubTheme.primary, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: PrestaHubTheme.textLight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final ProviderMissionSummary mission;
  const _ReviewCard({required this.mission});

  @override
  Widget build(BuildContext context) {
    final rating = mission.clientRating ?? 0;
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
            children: List.generate(5, (i) {
              return Padding(
                padding: const EdgeInsets.only(right: 2),
                child: Icon(
                  i < rating
                      ? Icons.star_rounded
                      : Icons.star_border_rounded,
                  color: PrestaHubTheme.warning,
                  size: 20,
                ),
              );
            })
              ..add(
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Text(
                    rating.toStringAsFixed(1),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: PrestaHubTheme.textLight,
                    ),
                  ),
                ),
              ),
          ),
          if (mission.clientReview != null) ...[
            const SizedBox(height: 12),
            Text(
              '« ${mission.clientReview} »',
              style: GoogleFonts.inter(
                fontSize: 13.5,
                fontStyle: FontStyle.italic,
                color: PrestaHubTheme.textLight,
                height: 1.5,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Text(
            'par ${mission.clientName}',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: PrestaHubTheme.textMutedLight,
            ),
          ),
        ],
      ),
    );
  }
}

class _NoReviewCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: PrestaHubTheme.border),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: PrestaHubTheme.textMutedLight.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.sentiment_neutral_rounded,
                color: PrestaHubTheme.textMutedLight, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Le client n\'a pas encore laissé d\'avis sur cette mission.',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: PrestaHubTheme.textMutedLight,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CancelledCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: PrestaHubTheme.surface2Light,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.cancel_outlined,
              color: PrestaHubTheme.textMutedLight, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Mission annulée : aucun avis n\'est demandé dans ce cas.',
              style: GoogleFonts.inter(
                fontSize: 12.5,
                color: PrestaHubTheme.textMutedLight,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotFound extends StatelessWidget {
  const _NotFound();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0),
      body: Center(
        child: Text(
          'Mission introuvable',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: PrestaHubTheme.textMutedLight,
          ),
        ),
      ),
    );
  }
}
