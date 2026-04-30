import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_theme.dart';
import '../widgets/settings_scaffold.dart';

class _Device {
  final String id;
  final String name;
  final String platform;
  final String location;
  final String lastActive;
  final IconData icon;
  final bool isCurrent;

  const _Device({
    required this.id,
    required this.name,
    required this.platform,
    required this.location,
    required this.lastActive,
    required this.icon,
    this.isCurrent = false,
  });
}

/// Liste des sessions actives avec possibilité de révocation.
class ConnectedDevicesScreen extends StatefulWidget {
  const ConnectedDevicesScreen({super.key});

  @override
  State<ConnectedDevicesScreen> createState() => _ConnectedDevicesScreenState();
}

class _ConnectedDevicesScreenState extends State<ConnectedDevicesScreen> {
  final List<_Device> _devices = [
    const _Device(
      id: 'dev-1',
      name: 'iPhone 15 Pro',
      platform: 'iOS 17.3',
      location: 'Paris, France',
      lastActive: 'Actif maintenant',
      icon: Icons.phone_iphone_rounded,
      isCurrent: true,
    ),
    const _Device(
      id: 'dev-2',
      name: 'MacBook Pro',
      platform: 'macOS · Safari',
      location: 'Paris, France',
      lastActive: 'Il y a 2 heures',
      icon: Icons.laptop_mac_rounded,
    ),
    const _Device(
      id: 'dev-3',
      name: 'Samsung Galaxy S23',
      platform: 'Android 14',
      location: 'Lyon, France',
      lastActive: 'Hier, 18:42',
      icon: Icons.phone_android_rounded,
    ),
  ];

  void _revoke(_Device device) {
    setState(() => _devices.removeWhere((d) => d.id == device.id));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${device.name} déconnecté.'),
        backgroundColor: PrestaHubTheme.danger,
      ),
    );
  }

  void _revokeAll() {
    setState(() => _devices.removeWhere((d) => !d.isCurrent));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Toutes les autres sessions ont été déconnectées.'),
        backgroundColor: PrestaHubTheme.danger,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      title: 'Appareils connectés',
      subtitle: '${_devices.length} session(s) active(s)',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        physics: const BouncingScrollPhysics(),
        children: [
          ..._devices.map((d) => _DeviceCard(
                device: d,
                onRevoke: d.isCurrent ? null : () => _revoke(d),
              )),
          const SizedBox(height: 12),
          if (_devices.any((d) => !d.isCurrent))
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: _revokeAll,
                icon: const Icon(Icons.logout_rounded, size: 18),
                label: const Text('Déconnecter toutes les autres sessions'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: PrestaHubTheme.danger,
                  side: const BorderSide(color: PrestaHubTheme.danger),
                  textStyle: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 13.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DeviceCard extends StatelessWidget {
  final _Device device;
  final VoidCallback? onRevoke;

  const _DeviceCard({required this.device, this.onRevoke});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: device.isCurrent
              ? PrestaHubTheme.success
              : PrestaHubTheme.border,
          width: device.isCurrent ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: PrestaHubTheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Icon(device.icon,
                    color: PrestaHubTheme.primary, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          device.name,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            color: PrestaHubTheme.textLight,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (device.isCurrent)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: PrestaHubTheme.success,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Actuel',
                              style: GoogleFonts.inter(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      device.platform,
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        color: PrestaHubTheme.textMutedLight,
                      ),
                    ),
                  ],
                ),
              ),
              if (onRevoke != null)
                TextButton(
                  onPressed: onRevoke,
                  style: TextButton.styleFrom(
                    foregroundColor: PrestaHubTheme.danger,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Révoquer',
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.location_on_outlined,
                  size: 14, color: PrestaHubTheme.textMutedLight),
              const SizedBox(width: 4),
              Text(
                device.location,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: PrestaHubTheme.textMutedLight,
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.schedule_rounded,
                  size: 14, color: PrestaHubTheme.textMutedLight),
              const SizedBox(width: 4),
              Text(
                device.lastActive,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: PrestaHubTheme.textMutedLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
