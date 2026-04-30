import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_theme.dart';

/// Tuile standard d'un écran de paramètres.
///
/// Supporte :
/// - un leading icon (avec fond coloré),
/// - un sous-titre optionnel,
/// - un trailing (valeur courante, switch, badge, chevron auto).
class SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String label;
  final String? value;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool destructive;
  final bool showChevron;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.label,
    this.iconColor,
    this.value,
    this.trailing,
    this.onTap,
    this.destructive = false,
    this.showChevron = true,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = destructive
        ? PrestaHubTheme.danger
        : (iconColor ?? PrestaHubTheme.primary);
    final labelColor = destructive ? PrestaHubTheme.danger : PrestaHubTheme.textLight;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(9),
                ),
                alignment: Alignment.center,
                child: Icon(icon, size: 18, color: primaryColor),
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
                        color: labelColor,
                      ),
                    ),
                    if (value != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        value!,
                        style: GoogleFonts.inter(
                          fontSize: 12.5,
                          color: PrestaHubTheme.textMutedLight,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null)
                trailing!
              else if (showChevron && onTap != null && !destructive)
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 22,
                  color: PrestaHubTheme.textMutedLight,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Trailing "valeur en texte" pour une [SettingsTile].
class SettingsTrailingText extends StatelessWidget {
  final String text;

  const SettingsTrailingText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: PrestaHubTheme.textMutedLight,
          ),
        ),
        const SizedBox(width: 4),
        const Icon(
          Icons.chevron_right_rounded,
          size: 22,
          color: PrestaHubTheme.textMutedLight,
        ),
      ],
    );
  }
}
