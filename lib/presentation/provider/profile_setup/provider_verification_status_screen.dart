import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../settings/widgets/settings_scaffold.dart';
import 'models/provider_profile_models.dart';

/// Statut de vérification du profil prestataire.
class ProviderVerificationStatusScreen extends StatelessWidget {
  const ProviderVerificationStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // État simulé ; sera remplacé par le repository prestataire.
    final status = ProviderVerificationStatus(
      state: VerificationState.pending,
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    );

    return SettingsScaffold(
      title: 'Statut de vérification',
      subtitle: 'Suivi de la validation de votre profil',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
        physics: const BouncingScrollPhysics(),
        children: [
          _StatusBanner(status: status),
          const SizedBox(height: 22),
          Text(
            'ÉTAPES DE LA VÉRIFICATION',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: PrestaHubTheme.textMutedLight,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 10),
          _StepsTimeline(currentState: status.state),
          const SizedBox(height: 22),
          if (status.state == VerificationState.rejected &&
              status.rejectionReason != null)
            _RejectionCard(reason: status.rejectionReason!),
          if (status.state == VerificationState.unverified ||
              status.state == VerificationState.rejected) ...[
            const SizedBox(height: 12),
            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () =>
                    context.push(AppConstants.routeProviderDocuments),
                icon: const Icon(Icons.folder_copy_rounded, size: 18),
                label: Text(
                  'Gérer mes justificatifs',
                  style: GoogleFonts.inter(
                    fontSize: 14,
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
          ],
          const SizedBox(height: 16),
          _InfoCard(),
        ],
      ),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  final ProviderVerificationStatus status;
  const _StatusBanner({required this.status});

  @override
  Widget build(BuildContext context) {
    final (color, icon, title, desc) = switch (status.state) {
      VerificationState.verified => (
          PrestaHubTheme.success,
          Icons.verified_rounded,
          'Profil vérifié',
          'Votre profil est pleinement actif et visible par les clients.',
        ),
      VerificationState.pending => (
          PrestaHubTheme.warning,
          Icons.hourglass_top_rounded,
          'Vérification en cours',
          'Nos équipes examinent vos documents. Délai habituel : 24 à 72 heures.',
        ),
      VerificationState.rejected => (
          PrestaHubTheme.danger,
          Icons.error_outline_rounded,
          'Vérification refusée',
          'Consultez le motif ci-dessous et renvoyez les documents demandés.',
        ),
      VerificationState.unverified => (
          PrestaHubTheme.textMutedLight,
          Icons.help_outline_rounded,
          'Profil non vérifié',
          'Ajoutez vos justificatifs pour activer votre profil prestataire.',
        ),
    };

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: PrestaHubTheme.textLight,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: PrestaHubTheme.textMutedLight,
                    height: 1.4,
                  ),
                ),
                if (status.updatedAt != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Dernière mise à jour : ${_formatDate(status.updatedAt!)}',
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      color: PrestaHubTheme.textMutedLight,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
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

class _StepsTimeline extends StatelessWidget {
  final VerificationState currentState;
  const _StepsTimeline({required this.currentState});

  @override
  Widget build(BuildContext context) {
    final steps = <_TimelineStep>[
      _TimelineStep(
        title: 'Documents envoyés',
        description: 'Vos justificatifs ont été transmis',
        completed: currentState != VerificationState.unverified,
      ),
      _TimelineStep(
        title: 'Examen par notre équipe',
        description: 'Vérification de l\'authenticité et de la validité',
        completed: currentState == VerificationState.verified ||
            currentState == VerificationState.rejected,
        active: currentState == VerificationState.pending,
      ),
      _TimelineStep(
        title: 'Profil validé',
        description: 'Votre profil apparaît dans les résultats',
        completed: currentState == VerificationState.verified,
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: PrestaHubTheme.border),
      ),
      child: Column(
        children: steps.asMap().entries.map((e) {
          final i = e.key;
          final step = e.value;
          return _TimelineRow(step: step, isLast: i == steps.length - 1);
        }).toList(),
      ),
    );
  }
}

class _TimelineStep {
  final String title;
  final String description;
  final bool completed;
  final bool active;

  const _TimelineStep({
    required this.title,
    required this.description,
    this.completed = false,
    this.active = false,
  });
}

class _TimelineRow extends StatelessWidget {
  final _TimelineStep step;
  final bool isLast;

  const _TimelineRow({required this.step, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final Color indicatorColor;
    final IconData indicatorIcon;
    if (step.completed) {
      indicatorColor = PrestaHubTheme.success;
      indicatorIcon = Icons.check_rounded;
    } else if (step.active) {
      indicatorColor = PrestaHubTheme.warning;
      indicatorIcon = Icons.more_horiz_rounded;
    } else {
      indicatorColor = PrestaHubTheme.borderStrong;
      indicatorIcon = Icons.circle_outlined;
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: indicatorColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: indicatorColor),
                ),
                alignment: Alignment.center,
                child: Icon(indicatorIcon, size: 14, color: indicatorColor),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: PrestaHubTheme.border,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: step.completed || step.active
                          ? PrestaHubTheme.textLight
                          : PrestaHubTheme.textMutedLight,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    step.description,
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      color: PrestaHubTheme.textMutedLight,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RejectionCard extends StatelessWidget {
  final String reason;

  const _RejectionCard({required this.reason});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: PrestaHubTheme.danger.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: PrestaHubTheme.danger.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.error_outline_rounded,
                  color: PrestaHubTheme.danger, size: 18),
              const SizedBox(width: 8),
              Text(
                'Motif du refus',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: PrestaHubTheme.danger,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            reason,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: PrestaHubTheme.textLight,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
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
              color: PrestaHubTheme.info.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.help_outline_rounded,
                color: PrestaHubTheme.info, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Besoin d\'aide ? Contactez notre équipe support depuis l\'écran Aide.',
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
