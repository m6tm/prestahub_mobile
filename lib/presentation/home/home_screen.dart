import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'widgets/home_header.widget.dart';
import 'widgets/home_search_bar.widget.dart';
import 'widgets/home_popular_categories.widget.dart';
import 'widgets/home_nearby_providers.widget.dart';

/// Écran d'accueil principal de l'application PrestaHub.
/// Affiche le profil utilisateur, une barre de recherche, les catégories et les prestataires à proximité.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? const Color(0xFFF7F6F8)
          : PrestaHubTheme.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            const HomeHeader(),
            const HomeSearchBar(),
            const HomePopularCategories(),
            Expanded(
              child: const HomeNearbyProviders(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827).withOpacity(0.95) : Colors.white.withOpacity(0.95),
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.white10 : Colors.black12,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavBarItem(
            icon: Icons.home_rounded,
            label: "Accueil",
            isActive: true,
            onTap: () {},
          ),
          _NavBarItem(
            icon: Icons.search_rounded,
            label: "Recherche",
            onTap: () {},
          ),
          _NavBarItem(
            icon: Icons.description_outlined,
            label: "Commandes",
            onTap: () {},
          ),
          _NavBarItem(
            icon: Icons.person_outline_rounded,
            label: "Profil",
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.label,
    this.isActive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? PrestaHubTheme.primary : Colors.grey;
    
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
