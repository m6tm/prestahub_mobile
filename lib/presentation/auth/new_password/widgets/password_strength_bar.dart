import 'package:flutter/material.dart';

/// Barre de force de mot de passe divisée en quatre segments.
class PasswordStrengthBar extends StatelessWidget {
  /// Score de force (0 à 4).
  final int strength;
  /// Libellé de force (ex: "Fort").
  final String label;
  /// Titre affiché à gauche (ex: "Force du mot de passe").
  final String title;

  const PasswordStrengthBar({
    super.key,
    required this.strength,
    required this.label,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(4, (index) {
            final isFilled = index < strength;
            return Expanded(
              child: Container(
                height: 4,
                margin: EdgeInsets.only(
                  right: index < 3 ? 8.0 : 0.0,
                ),
                decoration: BoxDecoration(
                  color: isFilled ? primaryColor : (isDark ? Colors.grey[800] : Colors.grey[200]),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
