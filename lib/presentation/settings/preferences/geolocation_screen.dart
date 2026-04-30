import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/services/app_preferences_service.dart';
import '../../../core/theme/app_theme.dart';
import '../widgets/settings_scaffold.dart';

/// Écran dédié à la gestion de la géolocalisation et de sa précision.
class GeolocationScreen extends StatefulWidget {
  const GeolocationScreen({super.key});

  @override
  State<GeolocationScreen> createState() => _GeolocationScreenState();
}

class _GeolocationScreenState extends State<GeolocationScreen> {
  PrivacyPrefs? _prefs;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final p = await AppPreferencesService.getPrivacy();
    if (!mounted) return;
    setState(() {
      _prefs = p;
      _loading = false;
    });
  }

  Future<void> _update(PrivacyPrefs next) async {
    setState(() => _prefs = next);
    await AppPreferencesService.setPrivacy(next);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _prefs == null) {
      return const SettingsScaffold(
        title: 'Géolocalisation',
        child: Center(child: CircularProgressIndicator()),
      );
    }
    final p = _prefs!;

    return SettingsScaffold(
      title: 'Géolocalisation',
      subtitle: 'Gérez l\'utilisation de votre position',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        physics: const BouncingScrollPhysics(),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: PrestaHubTheme.border),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: PrestaHubTheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.my_location_rounded,
                          color: PrestaHubTheme.primary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Autoriser la localisation',
                            style: GoogleFonts.inter(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600,
                              color: PrestaHubTheme.textLight,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Nécessaire pour trouver les prestataires proches',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: PrestaHubTheme.textMutedLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: p.locationConsent,
                      onChanged: (v) =>
                          _update(p.copyWith(locationConsent: v)),
                      activeThumbColor: PrestaHubTheme.primary,
                    ),
                  ],
                ),
                const Divider(height: 24),
                Opacity(
                  opacity: p.locationConsent ? 1 : 0.5,
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: PrestaHubTheme.info.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(Icons.gps_fixed_rounded,
                            color: PrestaHubTheme.info),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Position précise',
                              style: GoogleFonts.inter(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w600,
                                color: PrestaHubTheme.textLight,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Utilise le GPS au lieu d\'une position approximative',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: PrestaHubTheme.textMutedLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: p.highPrecisionLocation,
                        onChanged: p.locationConsent
                            ? (v) => _update(
                                p.copyWith(highPrecisionLocation: v))
                            : null,
                        activeThumbColor: PrestaHubTheme.primary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: PrestaHubTheme.info.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: PrestaHubTheme.info.withValues(alpha: 0.2)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline_rounded,
                    color: PrestaHubTheme.info, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Vous pouvez également gérer ces autorisations dans les réglages système de votre appareil.',
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      color: PrestaHubTheme.textLight,
                      height: 1.4,
                    ),
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
