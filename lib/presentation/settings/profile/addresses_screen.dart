import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../models/address_model.dart';
import '../widgets/settings_scaffold.dart';

/// Liste des adresses enregistrées par l'utilisateur.
class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  final List<AddressModel> _addresses = [
    const AddressModel(
      id: 'addr-1',
      label: 'Domicile',
      street: '12 rue de la République',
      postalCode: '75001',
      city: 'Paris',
      additionalInfo: 'Bâtiment A, 3e étage',
      isPrimary: true,
    ),
    const AddressModel(
      id: 'addr-2',
      label: 'Bureau',
      street: '25 avenue des Champs-Élysées',
      postalCode: '75008',
      city: 'Paris',
    ),
  ];

  void _removeAddress(String id) {
    setState(() => _addresses.removeWhere((a) => a.id == id));
  }

  void _markPrimary(String id) {
    setState(() {
      for (var i = 0; i < _addresses.length; i++) {
        _addresses[i] = _addresses[i].copyWith(
          isPrimary: _addresses[i].id == id,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      title: 'Mes adresses',
      subtitle: '${_addresses.length} adresse(s) enregistrée(s)',
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppConstants.routeSettingsAddressEdit),
        backgroundColor: PrestaHubTheme.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: Text(
          'Ajouter',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
      ),
      child: _addresses.isEmpty
          ? _EmptyState(
              onAdd: () =>
                  context.push(AppConstants.routeSettingsAddressEdit),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
              physics: const BouncingScrollPhysics(),
              itemCount: _addresses.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (_, i) => _AddressCard(
                address: _addresses[i],
                onMarkPrimary: () => _markPrimary(_addresses[i].id),
                onDelete: () => _removeAddress(_addresses[i].id),
                onEdit: () => context.push(
                  AppConstants.routeSettingsAddressEdit,
                  extra: _addresses[i],
                ),
              ),
            ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  final AddressModel address;
  final VoidCallback onEdit;
  final VoidCallback onMarkPrimary;
  final VoidCallback onDelete;

  const _AddressCard({
    required this.address,
    required this.onEdit,
    required this.onMarkPrimary,
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
          color: address.isPrimary
              ? PrestaHubTheme.primary
              : PrestaHubTheme.border,
          width: address.isPrimary ? 1.5 : 1,
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
                  color: PrestaHubTheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.location_on_rounded,
                    color: PrestaHubTheme.primary, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Row(
                  children: [
                    Text(
                      address.label,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: PrestaHubTheme.textLight,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (address.isPrimary)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: PrestaHubTheme.primary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Par défaut',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
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
                    case 'primary':
                      onMarkPrimary();
                      break;
                    case 'delete':
                      onDelete();
                      break;
                  }
                },
                itemBuilder: (_) => [
                  const PopupMenuItem(value: 'edit', child: Text('Modifier')),
                  if (!address.isPrimary)
                    const PopupMenuItem(
                        value: 'primary',
                        child: Text('Définir par défaut')),
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
            address.singleLine,
            style: GoogleFonts.inter(
              fontSize: 13.5,
              color: PrestaHubTheme.textMutedLight,
              height: 1.4,
            ),
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
              child: const Icon(Icons.location_on_outlined,
                  color: PrestaHubTheme.primary, size: 36),
            ),
            const SizedBox(height: 16),
            Text(
              'Aucune adresse enregistrée',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: PrestaHubTheme.textLight,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Ajoutez une adresse pour faciliter vos demandes de service.',
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
              label: const Text('Ajouter une adresse'),
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
