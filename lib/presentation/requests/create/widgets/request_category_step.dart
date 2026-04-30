import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_theme.dart';
import '../../models/service_request_models.dart';

class RequestCategoryStep extends StatelessWidget {
  final ServiceRequestDraft draft;
  final VoidCallback onChanged;

  const RequestCategoryStep({
    super.key,
    required this.draft,
    required this.onChanged,
  });

  static const _categories = [
    _CategoryOption('Plomberie', Icons.plumbing_rounded),
    _CategoryOption('Électricité', Icons.bolt_rounded),
    _CategoryOption('Ménage', Icons.cleaning_services_rounded),
    _CategoryOption('Peinture', Icons.format_paint_rounded),
    _CategoryOption('Jardinage', Icons.yard_rounded),
    _CategoryOption('Déménagement', Icons.local_shipping_rounded),
    _CategoryOption('Rénovation', Icons.construction_rounded),
    _CategoryOption('Serrurerie', Icons.lock_rounded),
    _CategoryOption('Climatisation', Icons.ac_unit_rounded),
    _CategoryOption('Informatique', Icons.computer_rounded),
    _CategoryOption('Cuisine', Icons.restaurant_rounded),
    _CategoryOption('Livraison', Icons.delivery_dining_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final primarySoft = PrestaHubTheme.primary.withValues(alpha: 0.10);
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
      physics: const BouncingScrollPhysics(),
      children: [
        Text(
          'Choisissez une catégorie',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: PrestaHubTheme.textLight,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Sélectionnez le type de service dont vous avez besoin.',
          style: GoogleFonts.inter(
            fontSize: 13,
            color: PrestaHubTheme.textMutedLight,
          ),
        ),
        const SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.95,
          ),
          itemCount: _categories.length,
          itemBuilder: (context, i) {
            final cat = _categories[i];
            final isSelected = draft.categoryLabel == cat.label;
            return GestureDetector(
              onTap: () {
                draft.categoryLabel = cat.label;
                draft.categoryIcon = cat.icon;
                onChanged();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                decoration: BoxDecoration(
                  color: isSelected
                      ? primarySoft
                      : PrestaHubTheme.backgroundLight,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected
                        ? PrestaHubTheme.primary
                        : PrestaHubTheme.border,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? PrestaHubTheme.primary
                            : primarySoft,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Icon(
                        cat.icon,
                        color: isSelected
                            ? PrestaHubTheme.primaryContent
                            : PrestaHubTheme.primary,
                        size: 22,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Text(
                        cat.label,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? PrestaHubTheme.primary
                              : PrestaHubTheme.textLight,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _CategoryOption {
  final String label;
  final IconData icon;
  const _CategoryOption(this.label, this.icon);
}
