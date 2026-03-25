import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// En-tête de l'écran d'accueil affichant le profil et les notifications.
class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: PrestaHubTheme.primary.withOpacity(0.2),
                    width: 2,
                  ),
                ),
                padding: const EdgeInsets.all(2),
                child: const CircleAvatar(
                  backgroundImage: NetworkImage(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuBi7IVwGCPfKI_Mzjff-sk6-QwX-ro2IlQvD8X2FNgM8vvSunr5AIy3CGxb4_cy5Ci5Kr44tw4fw5NZQ3XjP8ZX8HUrItkmpEk0QlROJ2u_rEx-kcZjQij8Mki5m53jhhCe-Q0PLGi4Bomk2N8txCe2vRfcrigI3uvHGUtF8j0TyNSszUblfhXxrY_I8kO4M1321vAMOq36SDHqIojMUokCcd1pw1EWoO4EOVgZ19cHjee45qzRWnfpIWUfM9f7SnuO-GImlewAGCoI',
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bon retour,',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? PrestaHubTheme.textMutedDark : PrestaHubTheme.textMutedLight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Text(
                    'Bonjour, Alex',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
          _NotificationButton(isDark: isDark),
        ],
      ),
    );
  }
}

class _NotificationButton extends StatelessWidget {
  final bool isDark;

  const _NotificationButton({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        Icons.notifications_none_rounded,
        color: isDark ? Colors.white70 : Colors.black54,
        size: 24,
      ),
    );
  }
}
