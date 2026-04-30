import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/services/app_preferences_service.dart';
import '../../../core/theme/app_theme.dart';
import '../widgets/settings_scaffold.dart';
import '../widgets/settings_section.dart';

/// Gestion fine des notifications (canaux + catégories).
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  NotificationPrefs? _prefs;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final p = await AppPreferencesService.getNotifications();
    if (!mounted) return;
    setState(() {
      _prefs = p;
      _loading = false;
    });
  }

  Future<void> _update(NotificationPrefs next) async {
    setState(() => _prefs = next);
    await AppPreferencesService.setNotifications(next);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _prefs == null) {
      return const SettingsScaffold(
        title: 'Notifications',
        child: Center(child: CircularProgressIndicator()),
      );
    }
    final p = _prefs!;

    return SettingsScaffold(
      title: 'Notifications',
      subtitle: 'Choisissez ce que vous souhaitez recevoir',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
        physics: const BouncingScrollPhysics(),
        children: [
          SettingsSection(
            title: 'Canaux',
            children: [
              _SwitchTile(
                icon: Icons.notifications_active_rounded,
                label: 'Notifications push',
                description: 'Alertes sur votre appareil',
                value: p.push,
                onChanged: (v) => _update(p.copyWith(push: v)),
              ),
              _SwitchTile(
                icon: Icons.alternate_email_rounded,
                label: 'Emails',
                description: 'Recevoir des récapitulatifs par email',
                value: p.email,
                onChanged: (v) => _update(p.copyWith(email: v)),
              ),
              _SwitchTile(
                icon: Icons.sms_outlined,
                label: 'SMS',
                description: 'Alertes critiques par SMS',
                value: p.sms,
                onChanged: (v) => _update(p.copyWith(sms: v)),
              ),
            ],
          ),
          SettingsSection(
            title: 'Catégories',
            children: [
              _SwitchTile(
                icon: Icons.chat_bubble_outline_rounded,
                label: 'Messages',
                description: 'Nouveaux messages dans vos conversations',
                value: p.messages,
                onChanged: (v) => _update(p.copyWith(messages: v)),
              ),
              _SwitchTile(
                icon: Icons.assignment_outlined,
                label: 'Demandes et missions',
                description: 'Statuts, propositions, rappels',
                value: p.requests,
                onChanged: (v) => _update(p.copyWith(requests: v)),
              ),
              _SwitchTile(
                icon: Icons.local_offer_outlined,
                label: 'Promotions',
                description: 'Offres et actualités PrestaHub',
                value: p.promotions,
                onChanged: (v) => _update(p.copyWith(promotions: v)),
              ),
            ],
          ),
          SettingsSection(
            title: 'Comportement',
            children: [
              _SwitchTile(
                icon: Icons.volume_up_rounded,
                label: 'Son',
                description: 'Jouer un son à chaque notification',
                value: p.sound,
                onChanged: (v) => _update(p.copyWith(sound: v)),
              ),
              _SwitchTile(
                icon: Icons.vibration_rounded,
                label: 'Vibration',
                description: 'Faire vibrer l\'appareil',
                value: p.vibration,
                onChanged: (v) => _update(p.copyWith(vibration: v)),
              ),
            ],
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
