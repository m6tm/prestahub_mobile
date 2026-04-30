import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../widgets/settings_scaffold.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_tile.dart';

/// Écran "À propos" : version, crédits, liens légaux.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      title: 'À propos',
      subtitle: 'Informations sur l\'application',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 32),
        physics: const BouncingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
            child: Column(
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: PrestaHubTheme.primary,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'P',
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: 44,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  AppConstants.appName,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: PrestaHubTheme.textLight,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: PrestaHubTheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Version ${AppConstants.appVersion}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: PrestaHubTheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'La plateforme qui connecte les clients aux meilleurs prestataires de services.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 13.5,
                    color: PrestaHubTheme.textMutedLight,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          SettingsSection(
            title: 'Informations légales',
            children: [
              SettingsTile(
                icon: Icons.description_outlined,
                label: 'Conditions générales',
                onTap: () => context.push(AppConstants.routeSettingsTerms),
              ),
              SettingsTile(
                icon: Icons.privacy_tip_outlined,
                label: 'Politique de confidentialité',
                onTap: () =>
                    context.push(AppConstants.routeSettingsPrivacyPolicy),
              ),
              SettingsTile(
                icon: Icons.account_balance_outlined,
                label: 'Mentions légales',
                onTap: () =>
                    context.push(AppConstants.routeSettingsLegalMentions),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 28),
            child: Center(
              child: Text(
                '© ${DateTime.now().year} PrestaHub · Tous droits réservés',
                style: GoogleFonts.inter(
                  fontSize: 11.5,
                  color: PrestaHubTheme.textMutedLight,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
