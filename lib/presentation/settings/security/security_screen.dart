import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../widgets/settings_scaffold.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_tile.dart';

/// Tableau de bord sécurité : point d'entrée pour toutes les actions
/// relatives à la protection du compte.
class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      title: 'Sécurité du compte',
      subtitle: 'Gérez la sécurité de votre accès',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
        physics: const BouncingScrollPhysics(),
        children: [
          SettingsSection(
            title: 'Authentification',
            children: [
              SettingsTile(
                icon: Icons.lock_outline_rounded,
                iconColor: PrestaHubTheme.primary,
                label: 'Mot de passe',
                value: 'Modifier votre mot de passe',
                onTap: () =>
                    context.push(AppConstants.routeSettingsChangePassword),
              ),
              SettingsTile(
                icon: Icons.sms_outlined,
                iconColor: PrestaHubTheme.info,
                label: 'Vérification en deux étapes',
                value: 'Activer la protection par code OTP',
                onTap: () =>
                    context.push(AppConstants.routeSettingsOtp),
              ),
            ],
          ),
          SettingsSection(
            title: 'Sessions',
            children: [
              SettingsTile(
                icon: Icons.devices_other_rounded,
                iconColor: PrestaHubTheme.warning,
                label: 'Appareils connectés',
                value: 'Consulter et révoquer vos sessions',
                onTap: () =>
                    context.push(AppConstants.routeSettingsDevices),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
