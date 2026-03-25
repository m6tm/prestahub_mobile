import 'package:flutter/material.dart';

/// Widget pour afficher une condition de validité d'un mot de passe.
class PasswordRequirementItem extends StatelessWidget {
  /// Texte de la condition.
  final String text;
  /// Indique si la condition est remplie.
  final bool isMet;

  const PasswordRequirementItem({
    super.key,
    required this.text,
    required this.isMet,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_rounded,
            size: 20,
            color: isMet ? Colors.green : (isDark ? Colors.grey[700] : Colors.grey[300]),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: isDark ? Colors.grey[400] : Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
