import 'package:flutter/material.dart';
import 'package:prestahub/core/theme/app_theme.dart';

/// Composant représentant une seule page de l'onboarding.
class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color baseColor;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.baseColor = PrestaHubTheme.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Illustration circulaire
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: baseColor.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: baseColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 70, color: baseColor),
              ),
            ],
          ),
          const SizedBox(height: 48),

          // Texte
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: PrestaHubTheme.textLight,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: PrestaHubTheme.textMutedLight,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
