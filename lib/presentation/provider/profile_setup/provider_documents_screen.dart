import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/theme/app_theme.dart';
import '../../settings/widgets/settings_scaffold.dart';
import 'models/provider_profile_models.dart';

/// Upload et suivi des documents justificatifs du prestataire.
class ProviderDocumentsScreen extends StatefulWidget {
  const ProviderDocumentsScreen({super.key});

  @override
  State<ProviderDocumentsScreen> createState() =>
      _ProviderDocumentsScreenState();
}

class _ProviderDocumentsScreenState extends State<ProviderDocumentsScreen> {
  final List<ProviderDocument> _documents = [
    ProviderDocument(
      id: 'doc-1',
      type: ProviderDocumentType.idCard,
      fileName: 'cni-recto-verso.pdf',
      status: VerificationState.verified,
      uploadedAt: DateTime.now().subtract(const Duration(days: 12)),
    ),
    ProviderDocument(
      id: 'doc-2',
      type: ProviderDocumentType.businessRegistration,
      fileName: 'kbis-2026.pdf',
      status: VerificationState.pending,
      uploadedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  Future<void> _pickFile(ProviderDocumentType type) async {
    final source = await _chooseSource();
    if (source == null || !mounted) return;
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1800,
        maxHeight: 1800,
      );
      if (picked == null || !mounted) return;
      setState(() {
        _documents.removeWhere((d) => d.type == type);
        _documents.add(
          ProviderDocument(
            id: 'doc-${DateTime.now().millisecondsSinceEpoch}',
            type: type,
            fileName: picked.name,
            status: VerificationState.pending,
            uploadedAt: DateTime.now(),
          ),
        );
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Document envoyé. Vérification en cours.'),
          backgroundColor: PrestaHubTheme.success,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Impossible de charger le fichier : $e'),
          backgroundColor: PrestaHubTheme.danger,
        ),
      );
    }
  }

  Future<ImageSource?> _chooseSource() {
    return showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 14),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: PrestaHubTheme.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.photo_camera_rounded,
                  color: PrestaHubTheme.primary),
              title: Text(
                'Prendre une photo',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () => Navigator.of(ctx).pop(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_rounded,
                  color: PrestaHubTheme.primary),
              title: Text(
                'Choisir dans la galerie',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () => Navigator.of(ctx).pop(ImageSource.gallery),
            ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }

  void _deleteDocument(String id) {
    setState(() => _documents.removeWhere((d) => d.id == id));
  }

  ProviderDocument? _documentFor(ProviderDocumentType type) {
    try {
      return _documents.firstWhere((d) => d.type == type);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      title: 'Justificatifs',
      subtitle: 'Documents nécessaires à la vérification',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
        physics: const BouncingScrollPhysics(),
        children: [
          const _Hint(),
          const SizedBox(height: 16),
          ...ProviderDocumentType.values.map((type) {
            final doc = _documentFor(type);
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _DocumentCard(
                type: type,
                document: doc,
                onUpload: () => _pickFile(type),
                onDelete: doc == null ? null : () => _deleteDocument(doc.id),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _Hint extends StatelessWidget {
  const _Hint();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: PrestaHubTheme.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: PrestaHubTheme.primary.withValues(alpha: 0.18)),
      ),
      child: Row(
        children: [
          const Icon(Icons.shield_moon_rounded,
              color: PrestaHubTheme.primary, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Formats acceptés : PDF, JPG, PNG. Vos documents ne sont visibles que par notre équipe.',
              style: GoogleFonts.inter(
                fontSize: 12.5,
                color: PrestaHubTheme.textLight,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DocumentCard extends StatelessWidget {
  final ProviderDocumentType type;
  final ProviderDocument? document;
  final VoidCallback onUpload;
  final VoidCallback? onDelete;

  const _DocumentCard({
    required this.type,
    required this.document,
    required this.onUpload,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final hasDoc = document != null;
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
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: PrestaHubTheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(11),
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.description_rounded,
                    color: PrestaHubTheme.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      type.label,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: PrestaHubTheme.textLight,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      type.description,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: PrestaHubTheme.textMutedLight,
                      ),
                    ),
                  ],
                ),
              ),
              if (hasDoc) _StatusBadge(status: document!.status),
            ],
          ),
          if (hasDoc) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: PrestaHubTheme.surface2Light,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.insert_drive_file_rounded,
                      size: 18, color: PrestaHubTheme.textMutedLight),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      document!.fileName,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: PrestaHubTheme.textLight,
                      ),
                    ),
                  ),
                  if (onDelete != null)
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(Icons.close_rounded,
                          size: 18, color: PrestaHubTheme.textMutedLight),
                      onPressed: onDelete,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  'Envoyé le ${_formatDate(document!.uploadedAt)}',
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    color: PrestaHubTheme.textMutedLight,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: onUpload,
                  icon: const Icon(Icons.refresh_rounded, size: 16),
                  label: Text(
                    'Remplacer',
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: PrestaHubTheme.primary,
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
          ] else ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onUpload,
                icon: const Icon(Icons.upload_file_rounded, size: 18),
                label: Text(
                  'Ajouter le document',
                  style: GoogleFonts.inter(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: PrestaHubTheme.primary,
                  side: const BorderSide(color: PrestaHubTheme.primary),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }
}

class _StatusBadge extends StatelessWidget {
  final VerificationState status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (color, icon) = switch (status) {
      VerificationState.verified => (PrestaHubTheme.success, Icons.check_circle),
      VerificationState.pending => (PrestaHubTheme.warning, Icons.schedule),
      VerificationState.rejected => (PrestaHubTheme.danger, Icons.cancel),
      VerificationState.unverified => (
          PrestaHubTheme.textMutedLight,
          Icons.help_outline
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            status.label,
            style: GoogleFonts.inter(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
