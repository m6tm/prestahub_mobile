import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../settings/widgets/settings_scaffold.dart';
import 'models/provider_profile_models.dart';

/// Liste des zones d'intervention du prestataire.
///
/// La carte interactive (OSM) sera ajoutée dans un ticket dédié ; l'édition
/// se fait pour l'instant par saisie de ville + quartiers.
class ProviderZonesScreen extends StatefulWidget {
  const ProviderZonesScreen({super.key});

  @override
  State<ProviderZonesScreen> createState() => _ProviderZonesScreenState();
}

class _ProviderZonesScreenState extends State<ProviderZonesScreen> {
  final List<ProviderZone> _zones = [
    const ProviderZone(
      id: 'zone-1',
      name: 'Paris intra-muros',
      city: 'Paris',
      districts: ['1er', '2e', '3e', '4e'],
    ),
    const ProviderZone(
      id: 'zone-2',
      name: 'Boulogne-Billancourt',
      city: 'Boulogne-Billancourt',
    ),
  ];

  Future<void> _openEditor({ProviderZone? zone}) async {
    final result = await context.push<ProviderZone>(
      AppConstants.routeProviderZoneEdit,
      extra: zone,
    );
    if (!mounted || result == null) return;
    setState(() {
      final i = _zones.indexWhere((z) => z.id == result.id);
      if (i >= 0) {
        _zones[i] = result;
      } else {
        _zones.add(result);
      }
    });
  }

  void _toggleActive(String id, bool value) {
    setState(() {
      final i = _zones.indexWhere((z) => z.id == id);
      if (i >= 0) _zones[i] = _zones[i].copyWith(isActive: value);
    });
  }

  void _delete(String id) {
    setState(() => _zones.removeWhere((z) => z.id == id));
  }

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      title: 'Zones d\'intervention',
      subtitle: '${_zones.length} zone(s) couverte(s)',
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openEditor,
        backgroundColor: PrestaHubTheme.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_location_alt_rounded),
        label: Text(
          'Ajouter',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
      ),
      child: _zones.isEmpty
          ? _EmptyState(onAdd: _openEditor)
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
              physics: const BouncingScrollPhysics(),
              children: [
                const _MapPlaceholder(),
                const SizedBox(height: 18),
                Text(
                  'ZONES CONFIGURÉES',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: PrestaHubTheme.textMutedLight,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 10),
                ..._zones.map(
                  (zone) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _ZoneCard(
                      zone: zone,
                      onToggleActive: (v) => _toggleActive(zone.id, v),
                      onEdit: () => _openEditor(zone: zone),
                      onDelete: () => _confirmDelete(zone),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> _confirmDelete(ProviderZone zone) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer la zone ?'),
        content: Text('« ${zone.name} » sera retirée de votre couverture.'),
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
    if (confirmed == true) _delete(zone.id);
  }
}

class _MapPlaceholder extends StatelessWidget {
  const _MapPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            PrestaHubTheme.primary.withValues(alpha: 0.08),
            PrestaHubTheme.accent.withValues(alpha: 0.12),
          ],
        ),
        border: Border.all(color: PrestaHubTheme.border),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: PrestaHubTheme.primary.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.map_rounded,
                color: PrestaHubTheme.primary, size: 28),
          ),
          const SizedBox(height: 10),
          Text(
            'Carte des zones',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: PrestaHubTheme.textLight,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Visualisation disponible prochainement',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: PrestaHubTheme.textMutedLight,
            ),
          ),
        ],
      ),
    );
  }
}

class _ZoneCard extends StatelessWidget {
  final ProviderZone zone;
  final ValueChanged<bool> onToggleActive;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ZoneCard({
    required this.zone,
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
        border: Border.all(color: PrestaHubTheme.border),
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
                  Icons.location_on_rounded,
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
                      zone.name,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: PrestaHubTheme.textLight,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      zone.summary,
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
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
          if (zone.districts.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: zone.districts
                  .map(
                    (d) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: PrestaHubTheme.surface2Light,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        d,
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: PrestaHubTheme.textLight,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                zone.isActive ? 'Zone active' : 'Zone désactivée',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: zone.isActive
                      ? PrestaHubTheme.success
                      : PrestaHubTheme.textMutedLight,
                ),
              ),
              const Spacer(),
              Switch(
                value: zone.isActive,
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
              child: const Icon(Icons.map_outlined,
                  color: PrestaHubTheme.primary, size: 36),
            ),
            const SizedBox(height: 16),
            Text(
              'Aucune zone configurée',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: PrestaHubTheme.textLight,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Définissez les villes et quartiers où vous intervenez pour apparaître dans les bonnes recherches.',
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
              label: const Text('Ajouter une zone'),
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
