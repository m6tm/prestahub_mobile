import 'package:flutter/material.dart';

class OtpIllustration extends StatefulWidget {
  const OtpIllustration({super.key});

  @override
  State<OtpIllustration> createState() => _OtpIllustrationState();
}

class _OtpIllustrationState extends State<OtpIllustration>
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
          // Pulse effect
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: 1.0 + (_controller.value * 0.2),
                child: Opacity(
                  opacity: 1.0 - (_controller.value * 0.5),
                  child: Container(
                    width: 192,
                    height: 192,
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              );
            },
          ),
          
          // Outer background
          Container(
            width: 192,
            height: 192,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
          ),
          
          // Inner icon container
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              Icons.shield_rounded, // fallback icon since shield_person isn't directly available in Icons sometimes
              size: 72,
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
