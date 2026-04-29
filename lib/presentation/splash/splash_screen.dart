import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prestahub/core/constants/app_constants.dart';
import 'package:prestahub/core/services/onboarding_prefs_service.dart';
import 'package:prestahub/core/theme/app_theme.dart';

/// Écran de Splash affiché au démarrage de l'application.
/// Affiche le logo PrestaHub et simule une connexion sécurisée.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  /// Chargement initial : vérifie si l'onboarding a déjà été vu.
  /// - Premier lancement → onboarding
  /// - Lancements suivants → login directement
  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    final seen = await OnboardingPrefsService.hasSeen();
    if (!mounted) return;

    context.go(
      seen ? AppConstants.routeLogin : AppConstants.routeOnboarding,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PrestaHubTheme.backgroundLight,
      body: Stack(
        children: [
          // Logo central
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: PrestaHubTheme.primary,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: PrestaHubTheme.primary.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.shield_rounded,
                    color: Colors.white,
                    size: 60,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'PrestaHub',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: PrestaHubTheme.textLight,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'SECURE SYSTEMS ARCHITECTURE',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: PrestaHubTheme.textMutedLight,
                    letterSpacing: 4.0,
                  ),
                ),
              ],
            ),
          ),

          // État de connexion en bas
          Positioned(
            bottom: 60,
            left: 40,
            right: 40,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.lock_outline_rounded,
                      size: 14,
                      color: PrestaHubTheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'ENCRYPTED CONNECTION',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: PrestaHubTheme.primary.withValues(alpha: 0.8),
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: const LinearProgressIndicator(
                    backgroundColor: PrestaHubTheme.surface2Light,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      PrestaHubTheme.primary,
                    ),
                    minHeight: 4,
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
