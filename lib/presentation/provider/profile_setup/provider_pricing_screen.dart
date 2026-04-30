import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../settings/widgets/settings_scaffold.dart';
import 'models/provider_profile_models.dart';

/// Vue consolidée des tarifs par service.
///
/// Affiche, regroupé par catégorie, le mode de facturation et le prix défini.
/// L'édition redirige vers le formulaire d'un service pour garder une seule
/// source de vérité.
class ProviderPricingScreen extends StatelessWidget {
  const ProviderPricingScreen({super.key});

  static const _services = <ProviderService>[
    ProviderService(
      id: 'svc-1',
      categoryId: 'cat-plumbing',
      categoryName: 'Plomberie',
      name: 'Dépannage fuite d\'eau',
      description: '',
      pricingType: PricingType.hourly,
      price: 55,
    ),
    ProviderService(
      id: 'svc-2',
      categoryId: 'cat-plumbing',
      categoryName: 'Plomberie',
      name: 'Installation chauffe-eau',
      description: '',
      pricingType: PricingType.fixed,
      price: 320,
    ),
    ProviderService(
      id: 'svc-3',
      categoryId: 'cat-electricity',
      categoryName: 'Électricité',
      name: 'Mise aux normes tableau',
      description: '',
      pricingType: PricingType.range,
      priceMin: 600,
      priceMax: 1200,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final byCategory = <String, List<ProviderService>>{};
    for (final s in _services) {
      byCategory.putIfAbsent(s.categoryName, () => []).add(s);
    }

    return SettingsScaffold(
      title: 'Tarifs',
      subtitle: 'Vue d\'ensemble de vos prix affichés',
      child: _services.isEmpty
          ? _EmptyPricingState(
              onAdd: () => context.push(AppConstants.routeProviderServices),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
              physics: const BouncingScrollPhysics(),
              children: [
                _Hint(
                  onOpenServices: () =>
                      context.push(AppConstants.routeProviderServices),
                ),
                const SizedBox(height: 18),
                ...byCategory.entries.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _CategoryPricingCard(
                      categoryName: entry.key,
                      services: entry.value,
                      onEdit: (service) => context.push(
                        AppConstants.routeProviderServiceEdit,
                        extra: service,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _CategoryPricingCard extends StatelessWidget {
  final String categoryName;
  final List<ProviderService> services;
  final ValueChanged<ProviderService> onEdit;

  const _CategoryPricingCard({
    required this.categoryName,
    required this.services,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: PrestaHubTheme.border),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
            child: Row(
              children: [
                const Icon(Icons.folder_rounded,
                    size: 16, color: PrestaHubTheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    categoryName,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: PrestaHubTheme.textLight,
                    ),
                  ),
                ),
                Text(
                  '${services.length} service(s)',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: PrestaHubTheme.textMutedLight,
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            height: 1,
            thickness: 1,
            color: PrestaHubTheme.border,
          ),
          ...services.asMap().entries.map((e) {
            final i = e.key;
            final s = e.value;
            return Column(
              children: [
                _PricingRow(
                  service: s,
                  onEdit: () => onEdit(s),
                ),
                if (i < services.length - 1)
                  const Padding(
                    padding: EdgeInsets.only(left: 14),
                    child: Divider(
                      height: 1,
                      thickness: 1,
                      color: PrestaHubTheme.border,
                    ),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _PricingRow extends StatelessWidget {
  final ProviderService service;
  final VoidCallback onEdit;

  const _PricingRow({required this.service, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onEdit,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.name,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: PrestaHubTheme.textLight,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: PrestaHubTheme.surface2Light,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          service.pricingType.label,
                          style: GoogleFonts.inter(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: PrestaHubTheme.textMutedLight,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        service.displayPrice,
                        style: GoogleFonts.inter(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: PrestaHubTheme.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.edit_rounded,
              size: 16,
              color: PrestaHubTheme.textMutedLight,
            ),
          ],
        ),
      ),
    );
  }
}

class _Hint extends StatelessWidget {
  final VoidCallback onOpenServices;
  const _Hint({required this.onOpenServices});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: PrestaHubTheme.info.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: PrestaHubTheme.info.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded,
              size: 18, color: PrestaHubTheme.info),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Les tarifs sont définis directement dans chaque service. Touchez un service pour modifier son prix.',
              style: GoogleFonts.inter(
                fontSize: 12.5,
                color: PrestaHubTheme.textLight,
                height: 1.4,
              ),
            ),
          ),
          TextButton(
            onPressed: onOpenServices,
            style: TextButton.styleFrom(
              foregroundColor: PrestaHubTheme.primary,
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Services',
              style: GoogleFonts.inter(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyPricingState extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyPricingState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: PrestaHubTheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.payments_outlined,
                  color: PrestaHubTheme.primary, size: 36),
            ),
            const SizedBox(height: 16),
            Text(
              'Aucun tarif à afficher',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: PrestaHubTheme.textLight,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Ajoutez d\'abord vos services pour définir vos tarifs indicatifs.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: PrestaHubTheme.textMutedLight,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('Ajouter un service'),
              style: ElevatedButton.styleFrom(
                backgroundColor: PrestaHubTheme.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
