import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../settings/widgets/settings_scaffold.dart';

/// Écran d'accueil après inscription prestataire.
///
/// Présente la checklist de configuration du profil professionnel et permet
/// d'accéder à chacune des étapes depuis un point d'entrée unique.
class ProviderSetupGuideScreen extends StatelessWidget {
  const ProviderSetupGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Progression fictive le temps du branchement du repository prestataire.
    const steps = <_SetupStep>[
      _SetupStep(
        icon: Icons.badge_rounded,
        title: 'Profil professionnel',
        description: 'Nom commercial, description, coordonnées',
        route: AppConstants.routeProviderProfileEdit,
        completed: true,
      ),
      _SetupStep(
        icon: Icons.handyman_rounded,
        title: 'Services proposés',
        description: 'Sélectionnez les prestations que vous réalisez',
        route: AppConstants.routeProviderServices,
        completed: true,
      ),
      _SetupStep(
        icon: Icons.map_rounded,
        title: 'Zones d\'intervention',
        description: 'Villes et quartiers que vous couvrez',
        route: AppConstants.routeProviderZones,
        completed: false,
      ),
      _SetupStep(
        icon: Icons.payments_rounded,
        title: 'Tarifs indicatifs',
        description: 'Prix horaire, forfait ou fourchette par service',
        route: AppConstants.routeProviderPricing,
        completed: false,
      ),
      _SetupStep(
        icon: Icons.schedule_rounded,
        title: 'Disponibilités',
        description: 'Créneaux récurrents et absences',
        route: AppConstants.routeProviderAvailability,
        completed: false,
      ),
      _SetupStep(
        icon: Icons.folder_copy_rounded,
        title: 'Justificatifs',
        description: 'Pièce d\'identité, registre du commerce',
        route: AppConstants.routeProviderDocuments,
        completed: false,
      ),
      _SetupStep(
        icon: Icons.verified_rounded,
        title: 'Statut de vérification',
        description: 'Suivi de la validation par notre équipe',
        route: AppConstants.routeProviderVerification,
        completed: false,
      ),
    ];

    final completed = steps.where((s) => s.completed).length;
    final progress = completed / steps.length;

    return SettingsScaffold(
      title: 'Configurer mon profil',
      subtitle: 'Activez votre compte prestataire en quelques étapes',
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _ProgressBanner(completed: completed, total: steps.length, progress: progress),
            const SizedBox(height: 20),
            ...steps.map(
              (step) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _SetupStepCard(
                  step: step,
                  onTap: () => context.push(step.route),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SetupStep {
  final IconData icon;
  final String title;
  final String description;
  final String route;
  final bool completed;

  const _SetupStep({
    required this.icon,
    required this.title,
    required this.description,
    required this.route,
    required this.completed,
  });
}

class _ProgressBanner extends StatelessWidget {
  final int completed;
  final int total;
  final double progress;

  const _ProgressBanner({
    required this.completed,
    required this.total,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [PrestaHubTheme.primary, PrestaHubTheme.accent],
        ),
        borderRadius: BorderRadius.circular(18),
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
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.rocket_launch_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Progression du profil',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$completed étape(s) sur $total complétée(s)',
                      style: GoogleFonts.inter(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: Colors.white.withValues(alpha: 0.25),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _SetupStepCard extends StatelessWidget {
  final _SetupStep step;
  final VoidCallback onTap;

  const _SetupStepCard({required this.step, required this.onTap});

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
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: PrestaHubTheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(11),
                ),
                alignment: Alignment.center,
                child: Icon(step.icon, color: PrestaHubTheme.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            step.title,
                            style: GoogleFonts.inter(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600,
                              color: PrestaHubTheme.textLight,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (step.completed) const _DoneBadge(),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      step.description,
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        color: PrestaHubTheme.textMutedLight,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: PrestaHubTheme.textMutedLight,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DoneBadge extends StatelessWidget {
  const _DoneBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: PrestaHubTheme.success.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_rounded,
              size: 11, color: PrestaHubTheme.success),
          const SizedBox(width: 3),
          Text(
            'Fait',
            style: GoogleFonts.inter(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: PrestaHubTheme.success,
            ),
          ),
        ],
      ),
    );
  }
}
