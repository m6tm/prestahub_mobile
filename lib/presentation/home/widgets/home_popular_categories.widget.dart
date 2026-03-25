import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/translations.g.dart';

/// Section affichant les catégories de services les plus populaires.
class HomePopularCategories extends StatelessWidget {
  const HomePopularCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  t.home.popularCategories,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    t.home.viewAll,
                    style: const TextStyle(
                      color: PrestaHubTheme.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _CategoryCard(
                  icon: Icons.plumbing_rounded,
                  label: t.home.categories.plumbing,
                ),
                _CategoryCard(
                  icon: Icons.bolt_rounded,
                  label: t.home.categories.electricity,
                ),
                _CategoryCard(
                  icon: Icons.cleaning_services_rounded,
                  label: t.home.categories.cleaning,
                ),
                _CategoryCard(
                  icon: Icons.format_paint_rounded,
                  label: t.home.categories.painting,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final IconData icon;
  final String label;

  const _CategoryCard({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: PrestaHubTheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: PrestaHubTheme.primary,
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
