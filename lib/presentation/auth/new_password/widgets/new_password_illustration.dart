import 'package:flutter/material.dart';

/// Widget d'illustration pour l'écran de nouveau mot de passe.
/// Affiche une icône de bouclier avec un cadenas dans un cercle pulsant.
class NewPasswordIllustration extends StatefulWidget {
  const NewPasswordIllustration({super.key});

  @override
  State<NewPasswordIllustration> createState() => _NewPasswordIllustrationState();
}

class _NewPasswordIllustrationState extends State<NewPasswordIllustration>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Effet de pulsation
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: 1.0 + (_controller.value * 0.2),
                child: Opacity(
                  opacity: 1.0 - (_controller.value * 0.5),
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              );
            },
          ),
          
          // Arrière-plan extérieur
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
          ),
          
          // Conteneur de l'icône
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.security_rounded,
              size: 48,
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
