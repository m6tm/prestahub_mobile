import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../application/auth/auth_notifier.dart';
import '../../core/constants/app_constants.dart';
import '../../core/enums/user_role.dart';
import '../../core/theme/app_theme.dart';
import 'widgets/settings_scaffold.dart';
import 'widgets/settings_section.dart';
import 'widgets/settings_tile.dart';

/// Écran principal de paramètres accessible depuis la barre de navigation.
///
/// Les entrées sont adaptées au rôle courant :
/// - Client : toutes les sections (profil, adresses, sécurité, préférences,
///   aide, légal).
/// - Prestataire : les sections adresses ne sont pas affichées (gérées depuis
///   le profil professionnel une fois l'écran disponible).
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final role = ref.watch(userRoleProvider);
    final isProvider = role == UserRole.provider;

    return SettingsScaffold(
      title: 'Paramètres',
      showHeader: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 32),
        physics: const BouncingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Text(
              'Paramètres',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: PrestaHubTheme.textLight,
                letterSpacing: -0.5,
              ),
            ),
          ),
          _ProfileHeader(
            name: user?.displayName ?? 'Utilisateur',
            email: user?.email ?? '',
            role: role,
            onTap: () => context.push(AppConstants.routeSettingsProfile),
          ),
          SettingsSection(
            title: 'Compte',
            children: [
              SettingsTile(
                icon: Icons.person_outline_rounded,
                iconColor: PrestaHubTheme.primary,
                label: 'Mon profil',
                value: 'Informations personnelles',
                onTap: () =>
                    context.push(AppConstants.routeSettingsProfile),
              ),
              if (!isProvider)
                SettingsTile(
                  icon: Icons.location_on_outlined,
                  iconColor: PrestaHubTheme.info,
                  label: 'Adresses',
                  value: 'Gérer vos adresses',
                  onTap: () =>
                      context.push(AppConstants.routeSettingsAddresses),
                ),
            ],
          ),
          if (isProvider)
            SettingsSection(
              title: 'Profil professionnel',
              children: [
                SettingsTile(
                  icon: Icons.rocket_launch_rounded,
                  iconColor: PrestaHubTheme.primary,
                  label: 'Configurer mon profil',
                  value: 'Services, zones, tarifs, disponibilités',
                  onTap: () =>
                      context.push(AppConstants.routeProviderSetup),
                ),
                SettingsTile(
                  icon: Icons.star_rounded,
                  iconColor: PrestaHubTheme.warning,
                  label: 'Mes avis',
                  value: 'Retours clients et réponses',
                  onTap: () =>
                      context.push(AppConstants.routeProviderReviews),
                ),
                SettingsTile(
                  icon: Icons.verified_rounded,
                  iconColor: PrestaHubTheme.success,
                  label: 'Statut de vérification',
                  value: 'Suivi de la validation de votre profil',
                  onTap: () =>
                      context.push(AppConstants.routeProviderVerification),
                ),
                SettingsTile(
                  icon: Icons.folder_copy_rounded,
                  iconColor: PrestaHubTheme.warning,
                  label: 'Justificatifs',
                  value: 'Pièce d\'identité, registre du commerce',
                  onTap: () =>
                      context.push(AppConstants.routeProviderDocuments),
                ),
              ],
            ),
          SettingsSection(
            title: 'Sécurité',
            children: [
              SettingsTile(
                icon: Icons.shield_outlined,
                iconColor: PrestaHubTheme.success,
                label: 'Sécurité du compte',
                value: 'Mot de passe, OTP, appareils',
                onTap: () =>
                    context.push(AppConstants.routeSettingsSecurity),
              ),
            ],
          ),
          SettingsSection(
            title: 'Préférences',
            children: [
              SettingsTile(
                icon: Icons.language_rounded,
                iconColor: PrestaHubTheme.info,
                label: 'Langue',
                onTap: () =>
                    context.push(AppConstants.routeSettingsLanguage),
              ),
              SettingsTile(
                icon: Icons.notifications_none_rounded,
                iconColor: PrestaHubTheme.warning,
                label: 'Notifications',
                onTap: () =>
                    context.push(AppConstants.routeSettingsNotifications),
              ),
              SettingsTile(
                icon: Icons.dark_mode_outlined,
                iconColor: PrestaHubTheme.secondary,
                label: 'Thème',
                onTap: () => context.push(AppConstants.routeSettingsTheme),
              ),
              SettingsTile(
                icon: Icons.lock_outline_rounded,
                iconColor: PrestaHubTheme.accent,
                label: 'Confidentialité',
                onTap: () =>
                    context.push(AppConstants.routeSettingsPrivacy),
              ),
              SettingsTile(
                icon: Icons.gps_fixed_rounded,
                iconColor: PrestaHubTheme.primary,
                label: 'Géolocalisation',
                onTap: () =>
                    context.push(AppConstants.routeSettingsGeolocation),
              ),
            ],
          ),
          SettingsSection(
            title: 'Aide & support',
            children: [
              SettingsTile(
                icon: Icons.help_outline_rounded,
                iconColor: PrestaHubTheme.info,
                label: 'Aide et FAQ',
                onTap: () => context.push(AppConstants.routeSettingsHelp),
              ),
              SettingsTile(
                icon: Icons.contact_support_outlined,
                iconColor: PrestaHubTheme.primary,
                label: 'Contacter le support',
                onTap: () =>
                    context.push(AppConstants.routeSettingsContactSupport),
              ),
              SettingsTile(
                icon: Icons.bug_report_outlined,
                iconColor: PrestaHubTheme.warning,
                label: 'Signaler un problème',
                onTap: () =>
                    context.push(AppConstants.routeSettingsReportIssue),
              ),
            ],
          ),
          SettingsSection(
            title: 'Informations légales',
            children: [
              SettingsTile(
                icon: Icons.description_outlined,
                iconColor: PrestaHubTheme.info,
                label: 'Conditions générales',
                onTap: () => context.push(AppConstants.routeSettingsTerms),
              ),
              SettingsTile(
                icon: Icons.privacy_tip_outlined,
                iconColor: PrestaHubTheme.secondary,
                label: 'Politique de confidentialité',
                onTap: () =>
                    context.push(AppConstants.routeSettingsPrivacyPolicy),
              ),
              SettingsTile(
                icon: Icons.account_balance_outlined,
                iconColor: PrestaHubTheme.textMutedLight,
                label: 'Mentions légales',
                onTap: () =>
                    context.push(AppConstants.routeSettingsLegalMentions),
              ),
              SettingsTile(
                icon: Icons.info_outline_rounded,
                iconColor: PrestaHubTheme.primary,
                label: 'À propos',
                value: 'Version ${AppConstants.appVersion}',
                onTap: () => context.push(AppConstants.routeSettingsAbout),
              ),
            ],
          ),
          SettingsSection(
            title: 'Session',
            children: [
              SettingsTile(
                icon: Icons.logout_rounded,
                label: 'Se déconnecter',
                destructive: true,
                showChevron: false,
                onTap: () => _confirmLogout(context, ref),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              'PrestaHub · ${AppConstants.appVersion}',
              style: GoogleFonts.inter(
                fontSize: 11.5,
                color: PrestaHubTheme.textMutedLight,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Déconnexion',
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w700,
              color: PrestaHubTheme.textLight,
            ),
          ),
          content: Text(
            'Voulez-vous vraiment vous déconnecter ?',
            style: GoogleFonts.inter(
              color: PrestaHubTheme.textMutedLight,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: TextButton.styleFrom(
                foregroundColor: PrestaHubTheme.danger,
              ),
              child: const Text('Se déconnecter'),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;
    await ref.read(authNotifierProvider.notifier).signOut();
    if (context.mounted) {
      context.go(AppConstants.routeLogin);
    }
  }
}

class _ProfileHeader extends StatelessWidget {
  final String name;
  final String email;
  final UserRole role;
  final VoidCallback onTap;

  const _ProfileHeader({
    required this.name,
    required this.email,
    required this.role,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final initials = _initials(name);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: PrestaHubTheme.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: PrestaHubTheme.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    initials,
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: PrestaHubTheme.textLight,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        email,
                        style: GoogleFonts.inter(
                          fontSize: 12.5,
                          color: PrestaHubTheme.textMutedLight,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: PrestaHubTheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _roleLabel(role),
                          style: GoogleFonts.inter(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: PrestaHubTheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 24,
                  color: PrestaHubTheme.textMutedLight,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    final first = parts.first[0];
    final second = parts.length > 1 && parts[1].isNotEmpty ? parts[1][0] : '';
    return (first + second).toUpperCase();
  }

  String _roleLabel(UserRole role) {
    return switch (role) {
      UserRole.client => 'Client',
      UserRole.provider => 'Prestataire',
      UserRole.admin => 'Administrateur',
      UserRole.unknown => 'Invité',
    };
  }
}
