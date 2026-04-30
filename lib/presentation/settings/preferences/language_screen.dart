import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../application/settings/app_preferences_notifier.dart';
import '../../../core/services/app_preferences_service.dart';
import '../../../core/theme/app_theme.dart';
import '../widgets/settings_scaffold.dart';

/// Permet à l'utilisateur de choisir la langue de l'application.
class LanguageScreen extends ConsumerWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(appPreferencesProvider);
    final notifier = ref.read(appPreferencesProvider.notifier);

    return SettingsScaffold(
      title: 'Langue',
      subtitle: 'Choisissez la langue d\'affichage',
      child: prefs.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text(
            'Erreur : $e',
            style: GoogleFonts.inter(color: PrestaHubTheme.danger),
          ),
        ),
        data: (state) => ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
          physics: const BouncingScrollPhysics(),
          children: [
            for (final lang in AppLanguage.values)
              _LanguageOption(
                language: lang,
                selected: state.language == lang,
                onTap: () async {
                  await notifier.updateLanguage(lang);
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Langue : ${lang.label}'),
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

class _LanguageOption extends StatelessWidget {
  final AppLanguage language;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.language,
    required this.selected,
    required this.onTap,
  });

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
            Text(
              language.flag,
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    language.label,
                    style: GoogleFonts.inter(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: PrestaHubTheme.textLight,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    language.code.toUpperCase(),
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      color: PrestaHubTheme.textMutedLight,
                      fontWeight: FontWeight.w500,
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
