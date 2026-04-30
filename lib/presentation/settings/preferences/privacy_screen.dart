import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/services/app_preferences_service.dart';
import '../../../core/theme/app_theme.dart';
import '../widgets/settings_scaffold.dart';
import '../widgets/settings_section.dart';

/// Gestion des consentements de confidentialité.
class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
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
        title: 'Confidentialité',
        child: Center(child: CircularProgressIndicator()),
      );
    }
    final p = _prefs!;

    return SettingsScaffold(
      title: 'Confidentialité',
      subtitle: 'Contrôlez vos données et consentements',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
        physics: const BouncingScrollPhysics(),
        children: [
          _Banner(),
          SettingsSection(
            title: 'Consentements',
            children: [
              _SwitchTile(
                icon: Icons.location_on_outlined,
                label: 'Géolocalisation',
                description: 'Utiliser votre position pour suggérer les prestataires proches',
                value: p.locationConsent,
                onChanged: (v) => _update(p.copyWith(locationConsent: v)),
              ),
              _SwitchTile(
                icon: Icons.analytics_outlined,
                label: 'Analyses d\'usage',
                description: 'Aide à améliorer l\'app (données anonymisées)',
                value: p.analyticsConsent,
                onChanged: (v) => _update(p.copyWith(analyticsConsent: v)),
              ),
              _SwitchTile(
                icon: Icons.campaign_outlined,
                label: 'Communications marketing',
                description: 'Recevoir nos offres et nouveautés',
                value: p.marketingConsent,
                onChanged: (v) => _update(p.copyWith(marketingConsent: v)),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _showExportInfo(context),
                    icon: const Icon(Icons.download_rounded, size: 18),
                    label: const Text('Exporter mes données'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: PrestaHubTheme.primary,
                      side: const BorderSide(color: PrestaHubTheme.border),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _confirmDelete(context),
                    icon: const Icon(Icons.delete_outline_rounded, size: 18),
                    label: const Text('Supprimer mon compte'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: PrestaHubTheme.danger,
                      side: const BorderSide(color: PrestaHubTheme.danger),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
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

  void _showExportInfo(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Une archive vous sera envoyée par email sous 24h.'),
        backgroundColor: PrestaHubTheme.info,
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          'Supprimer votre compte ?',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700,
            color: PrestaHubTheme.textLight,
          ),
        ),
        content: Text(
          'Cette action est irréversible. Vos données, demandes et messages seront définitivement supprimés.',
          style: GoogleFonts.inter(color: PrestaHubTheme.textMutedLight),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            style: TextButton.styleFrom(
              foregroundColor: PrestaHubTheme.danger,
            ),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 18, 16, 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: PrestaHubTheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: PrestaHubTheme.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.privacy_tip_rounded,
              color: PrestaHubTheme.primary, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Vous pouvez à tout moment modifier vos consentements et demander la portabilité de vos données.',
              style: GoogleFonts.inter(
                fontSize: 12.5,
                color: PrestaHubTheme.textLight,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.icon,
    required this.label,
    required this.description,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: PrestaHubTheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(9),
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 18, color: PrestaHubTheme.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: PrestaHubTheme.textLight,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: PrestaHubTheme.textMutedLight,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: PrestaHubTheme.primary,
          ),
        ],
      ),
    );
  }
}
