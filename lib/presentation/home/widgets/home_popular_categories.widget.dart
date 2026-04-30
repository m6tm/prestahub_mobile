import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_constants.dart';

class HomePopularCategories extends StatelessWidget {
  const HomePopularCategories({super.key});

  static const _categories = [
    _Category('Plomberie', Icons.plumbing_rounded),
    _Category('Électricité', Icons.bolt_rounded),
    _Category('Ménage', Icons.cleaning_services_rounded),
    _Category('Peinture', Icons.format_paint_rounded),
    _Category('Jardinage', Icons.yard_rounded),
    _Category('Déménagement', Icons.local_shipping_rounded),
    _Category('Rénovation', Icons.construction_rounded),
    _Category('Serrurerie', Icons.lock_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Catégories',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF111827),
                  letterSpacing: -0.2,
                ),
              ),
              GestureDetector(
                onTap: () =>
                    context.push(AppConstants.routeClientCategories),
                child: Text(
                  'Voir tout',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: const Color(0xFF7C3AED),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, i) =>
                _CategoryTile(category: _categories[i]),
          ),
        ),
      ],
    );
  }
}

class _Category {
  final String label;
  final IconData icon;
  const _Category(this.label, this.icon);
}

class _CategoryTile extends StatelessWidget {
  final _Category category;
  const _CategoryTile({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(
        AppConstants.routeClientSearch,
        extra: {'category': category.label},
      ),
      child: SizedBox(
        width: 72,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F0FF),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE9D5FF)),
              ),
              child: Icon(category.icon,
                  color: const Color(0xFF7C3AED), size: 24),
            ),
            const SizedBox(height: 6),
            Text(
              category.label,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF374151),
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
