import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/theme/app_theme.dart';

/// Source depuis laquelle l'utilisateur a fourni une image (ou demande
/// la suppression de sa photo actuelle).
enum AvatarPickResult {
  /// L'utilisateur a sélectionné une image (voir [AvatarSelection.file]).
  picked,

  /// L'utilisateur a demandé la suppression de sa photo actuelle.
  removed,
}

/// Résultat d'un appel à [showAvatarPicker].
class AvatarSelection {
  final AvatarPickResult type;
  final File? file;

  const AvatarSelection._(this.type, this.file);

  factory AvatarSelection.picked(File file) =>
      AvatarSelection._(AvatarPickResult.picked, file);

  factory AvatarSelection.removed() =>
      const AvatarSelection._(AvatarPickResult.removed, null);
}

/// Ouvre une bottom sheet permettant à l'utilisateur de choisir sa photo
/// de profil (galerie, appareil photo) ou de supprimer celle existante.
///
/// Retourne `null` si l'utilisateur ferme la sheet sans action, sinon un
/// [AvatarSelection] portant soit un [File] soit un ordre de suppression.
Future<AvatarSelection?> showAvatarPicker(
  BuildContext context, {
  bool canRemove = false,
}) {
  return showModalBottomSheet<AvatarSelection>(
    context: context,
    backgroundColor: Colors.white,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => _AvatarPickerSheet(canRemove: canRemove),
  );
}

class _AvatarPickerSheet extends StatefulWidget {
  final bool canRemove;

  const _AvatarPickerSheet({required this.canRemove});

  @override
  State<_AvatarPickerSheet> createState() => _AvatarPickerSheetState();
}

class _AvatarPickerSheetState extends State<_AvatarPickerSheet> {
  final ImagePicker _picker = ImagePicker();
  bool _busy = false;

  Future<void> _pickFrom(ImageSource source) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final file = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1200,
        maxHeight: 1200,
      );
      if (!mounted) return;
      if (file == null) {
        setState(() => _busy = false);
        return;
      }
      Navigator.of(context).pop(AvatarSelection.picked(File(file.path)));
    } catch (e) {
      if (!mounted) return;
      setState(() => _busy = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Impossible de sélectionner l\'image : $e'),
          backgroundColor: PrestaHubTheme.danger,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 16 + bottomPad),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: PrestaHubTheme.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Photo de profil',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: PrestaHubTheme.textLight,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Choisissez une source pour votre photo',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 12.5,
              color: PrestaHubTheme.textMutedLight,
            ),
          ),
          const SizedBox(height: 20),
          _Option(
            icon: Icons.photo_camera_rounded,
            label: 'Prendre une photo',
            description: 'Utiliser l\'appareil photo',
            enabled: !_busy,
            onTap: () => _pickFrom(ImageSource.camera),
          ),
          const SizedBox(height: 10),
          _Option(
            icon: Icons.photo_library_rounded,
            label: 'Choisir dans la galerie',
            description: 'Sélectionner une image existante',
            enabled: !_busy,
            onTap: () => _pickFrom(ImageSource.gallery),
          ),
          if (widget.canRemove) ...[
            const SizedBox(height: 10),
            _Option(
              icon: Icons.delete_outline_rounded,
              label: 'Supprimer la photo',
              description: 'Revenir à vos initiales',
              enabled: !_busy,
              destructive: true,
              onTap: () =>
                  Navigator.of(context).pop(AvatarSelection.removed()),
            ),
          ],
          const SizedBox(height: 12),
          TextButton(
            onPressed: _busy ? null : () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              foregroundColor: PrestaHubTheme.textMutedLight,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: Text(
              'Annuler',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Option extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final VoidCallback onTap;
  final bool enabled;
  final bool destructive;

  const _Option({
    required this.icon,
    required this.label,
    required this.description,
    required this.onTap,
    this.enabled = true,
    this.destructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = destructive ? PrestaHubTheme.danger : PrestaHubTheme.primary;
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: PrestaHubTheme.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  alignment: Alignment.center,
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: GoogleFonts.inter(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                          color: destructive
                              ? PrestaHubTheme.danger
                              : PrestaHubTheme.textLight,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        description,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: PrestaHubTheme.textMutedLight,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!destructive)
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: PrestaHubTheme.textMutedLight,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
