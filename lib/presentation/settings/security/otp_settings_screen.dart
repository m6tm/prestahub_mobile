import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_theme.dart';
import '../widgets/settings_scaffold.dart';

/// Gestion de la vérification en deux étapes (OTP).
class OtpSettingsScreen extends StatefulWidget {
  const OtpSettingsScreen({super.key});

  @override
  State<OtpSettingsScreen> createState() => _OtpSettingsScreenState();
}

class _OtpSettingsScreenState extends State<OtpSettingsScreen> {
  bool _otpEnabled = false;
  String _channel = 'sms';

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      title: 'Vérification en deux étapes',
      subtitle: 'Sécurisez vos connexions avec un code',
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
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: (_otpEnabled
                            ? PrestaHubTheme.success
                            : PrestaHubTheme.warning)
                        .withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    _otpEnabled
                        ? Icons.verified_user_rounded
                        : Icons.shield_outlined,
                    color: _otpEnabled
                        ? PrestaHubTheme.success
                        : PrestaHubTheme.warning,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _otpEnabled ? 'Protection active' : 'Non activée',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: PrestaHubTheme.textLight,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _otpEnabled
                            ? 'Un code est requis à chaque connexion.'
                            : 'Activez l\'OTP pour renforcer votre sécurité.',
                        style: GoogleFonts.inter(
                          fontSize: 12.5,
                          color: PrestaHubTheme.textMutedLight,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _otpEnabled,
                  onChanged: (v) => setState(() => _otpEnabled = v),
                  activeThumbColor: PrestaHubTheme.primary,
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              'MODE DE RÉCEPTION',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: PrestaHubTheme.textMutedLight,
                letterSpacing: 0.8,
              ),
            ),
          ),
          _ChannelOption(
            icon: Icons.sms_outlined,
            title: 'SMS',
            description: 'Recevez un code sur votre téléphone',
            value: 'sms',
            groupValue: _channel,
            enabled: _otpEnabled,
            onChanged: (v) => setState(() => _channel = v),
          ),
          _ChannelOption(
            icon: Icons.alternate_email_rounded,
            title: 'Email',
            description: 'Recevez un code par email',
            value: 'email',
            groupValue: _channel,
            enabled: _otpEnabled,
            onChanged: (v) => setState(() => _channel = v),
          ),
          _ChannelOption(
            icon: Icons.apps_rounded,
            title: 'Application d\'authentification',
            description: 'Utilisez une app TOTP (Google Authenticator, ...)',
            value: 'app',
            groupValue: _channel,
            enabled: _otpEnabled,
            onChanged: (v) => setState(() => _channel = v),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 50,
            child: ElevatedButton.icon(
              onPressed: _otpEnabled
                  ? () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Reconfiguration en cours...'),
                          backgroundColor: PrestaHubTheme.info,
                        ),
                      );
                    }
                  : null,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Reconfigurer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: PrestaHubTheme.primary,
                foregroundColor: Colors.white,
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

class _ChannelOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String value;
  final String groupValue;
  final bool enabled;
  final ValueChanged<String> onChanged;

  const _ChannelOption({
    required this.icon,
    required this.title,
    required this.description,
    required this.value,
    required this.groupValue,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selected = value == groupValue;
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: GestureDetector(
        onTap: enabled ? () => onChanged(value) : null,
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? PrestaHubTheme.primary
                  : PrestaHubTheme.border,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(icon, size: 22, color: PrestaHubTheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 14,
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
              Icon(
                selected
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_unchecked_rounded,
                color: selected
                    ? PrestaHubTheme.primary
                    : PrestaHubTheme.textMutedLight,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
