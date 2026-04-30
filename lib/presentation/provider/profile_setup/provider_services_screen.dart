import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../settings/widgets/settings_scaffold.dart';
import 'models/provider_profile_models.dart';

/// Liste des services proposés par le prestataire.
class ProviderServicesScreen extends StatefulWidget {
  const ProviderServicesScreen({super.key});

  @override
  State<ProviderServicesScreen> createState() =>
      _ProviderServicesScreenState();
}

class _ProviderServicesScreenState extends State<ProviderServicesScreen> {
  final List<ProviderService> _services = [
    const ProviderService(
      id: 'svc-1',
      categoryId: 'cat-plumbing',
      categoryName: 'Plomberie',
      name: 'Dépannage fuite d\'eau',
      description: 'Diagnostic et réparation d\'une fuite simple',
      pricingType: PricingType.hourly,
      price: 55,
    ),
    const ProviderService(
      id: 'svc-2',
      categoryId: 'cat-plumbing',
      categoryName: 'Plomberie',
      name: 'Installation chauffe-eau',
      description: 'Pose et raccordement, hors fourniture',
      pricingType: PricingType.fixed,
      price: 320,
    ),
    const ProviderService(
      id: 'svc-3',
      categoryId: 'cat-electricity',
      categoryName: 'Électricité',
      name: 'Mise aux normes tableau',
      description: 'Audit et remplacement du tableau électrique',
      pricingType: PricingType.range,
      priceMin: 600,
      priceMax: 1200,
    ),
  ];

  void _toggleActive(String id, bool value) {
    setState(() {
      final i = _services.indexWhere((s) => s.id == id);
      if (i >= 0) {
        _services[i] = _services[i].copyWith(isActive: value);
      }
    });
  }

  void _delete(String id) {
    setState(() => _services.removeWhere((s) => s.id == id));
  }

  Future<void> _openEditor({ProviderService? service}) async {
    final result = await context.push<ProviderService>(
      AppConstants.routeProviderServiceEdit,
      extra: service,
    );
    if (!mounted || result == null) return;
    setState(() {
      final i = _services.indexWhere((s) => s.id == result.id);
      if (i >= 0) {
        _services[i] = result;
      } else {
        _services.add(result);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      title: 'Mes services',
      subtitle: '${_services.length} service(s) proposé(s)',
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openEditor,
        backgroundColor: PrestaHubTheme.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: Text(
          'Ajouter',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
      ),
      child: _services.isEmpty
          ? _EmptyState(onAdd: _openEditor)
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
              physics: const BouncingScrollPhysics(),
              itemCount: _services.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (_, i) => _ServiceCard(
                service: _services[i],
                onToggleActive: (v) => _toggleActive(_services[i].id, v),
                onEdit: () => _openEditor(service: _services[i]),
                onDelete: () => _confirmDelete(_services[i]),
              ),
            ),
    );
  }

  Future<void> _confirmDelete(ProviderService service) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer le service ?'),
        content: Text('« ${service.name} » sera retiré de votre profil.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: PrestaHubTheme.danger),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      _delete(service.id);
    }
  }
}

class _ServiceCard extends StatelessWidget {
  final ProviderService service;
  final ValueChanged<bool> onToggleActive;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ServiceCard({
    required this.service,
    required this.onToggleActive,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: service.isActive
              ? PrestaHubTheme.border
              : PrestaHubTheme.borderStrong,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: PrestaHubTheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.handyman_rounded,
                  color: PrestaHubTheme.primary,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.name,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: PrestaHubTheme.textLight,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      service.categoryName,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: PrestaHubTheme.textMutedLight,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert_rounded,
                    color: PrestaHubTheme.textMutedLight),
                onSelected: (v) {
                  switch (v) {
                    case 'edit':
                      onEdit();
                      break;
                    case 'delete':
                      onDelete();
                      break;
                  }
                },
                itemBuilder: (_) => [
                  const PopupMenuItem(value: 'edit', child: Text('Modifier')),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Supprimer',
                        style: TextStyle(color: PrestaHubTheme.danger)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            service.description,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: PrestaHubTheme.textMutedLight,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: PrestaHubTheme.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  service.displayPrice,
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: PrestaHubTheme.primary,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                service.isActive ? 'Actif' : 'Désactivé',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: service.isActive
                      ? PrestaHubTheme.success
                      : PrestaHubTheme.textMutedLight,
                ),
              ),
              Switch(
                value: service.isActive,
                onChanged: onToggleActive,
                activeThumbColor: PrestaHubTheme.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;

  const _EmptyState({required this.onAdd});

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
              child: const Icon(Icons.handyman_outlined,
                  color: PrestaHubTheme.primary, size: 36),
            ),
            const SizedBox(height: 16),
            Text(
              'Aucun service ajouté',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: PrestaHubTheme.textLight,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Ajoutez les prestations que vous proposez pour apparaître dans les résultats de recherche.',
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
