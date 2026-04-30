import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../application/settings/app_preferences_notifier.dart';
import '../../../core/services/app_preferences_service.dart';
import '../../../core/theme/app_theme.dart';
import '../widgets/settings_scaffold.dart';

/// Sélecteur du mode de thème (système / clair / sombre).
class ThemeScreen extends ConsumerWidget {
  const ThemeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(appPreferencesProvider);
    final notifier = ref.read(appPreferencesProvider.notifier);

    return SettingsScaffold(
      title: 'Thème',
      subtitle: 'Personnalisez l\'apparence de l\'app',
      child: prefs.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text('Erreur : $e',
              style: GoogleFonts.inter(color: PrestaHubTheme.danger)),
        ),
        data: (state) => ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
          physics: const BouncingScrollPhysics(),
          children: [
            for (final mode in AppThemeMode.values)
              _ThemeOption(
                mode: mode,
                selected: state.themeMode == mode,
                onTap: () async {
                  await notifier.updateTheme(mode);
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Thème : ${mode.label}'),
                      backgroundColor: PrestaHubTheme.success,
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final AppThemeMode mode;
  final bool selected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.mode,
    required this.selected,
    required this.onTap,
  });

  IconData get _icon => switch (mode) {
        AppThemeMode.system => Icons.brightness_auto_rounded,
        AppThemeMode.light => Icons.light_mode_rounded,
        AppThemeMode.dark => Icons.dark_mode_rounded,
      };

  String get _description => switch (mode) {
        AppThemeMode.system => 'Suit automatiquement les réglages de votre appareil',
        AppThemeMode.light => 'Interface claire, adaptée aux environnements lumineux',
        AppThemeMode.dark => 'Interface sombre, réduit la fatigue visuelle',
      };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? PrestaHubTheme.primary : PrestaHubTheme.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: PrestaHubTheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Icon(_icon, color: PrestaHubTheme.primary, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mode.label,
                    style: GoogleFonts.inter(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: PrestaHubTheme.textLight,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _description,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: PrestaHubTheme.textMutedLight,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              selected
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: selected
                  ? PrestaHubTheme.primary
                  : PrestaHubTheme.textMutedLight,
            ),
          ],
        ),
      ),
    );
  }
}
