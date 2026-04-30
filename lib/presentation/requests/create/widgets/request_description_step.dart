import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_theme.dart';
import '../../models/service_request_models.dart';

class RequestDescriptionStep extends StatefulWidget {
  final ServiceRequestDraft draft;
  final VoidCallback onChanged;

  const RequestDescriptionStep({
    super.key,
    required this.draft,
    required this.onChanged,
  });

  @override
  State<RequestDescriptionStep> createState() =>
      _RequestDescriptionStepState();
}

class _RequestDescriptionStepState extends State<RequestDescriptionStep> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _descCtrl;
  static const _maxDescLength = 500;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.draft.title);
    _descCtrl = TextEditingController(text: widget.draft.description);
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _onAddPhoto() {
    if (widget.draft.photos.length >= 5) return;
    setState(() {
      widget.draft.photos.add('photo_${widget.draft.photos.length + 1}.jpg');
      widget.onChanged();
    });
  }

  void _onRemovePhoto(int i) {
    setState(() {
      widget.draft.photos.removeAt(i);
      widget.onChanged();
    });
  }

  @override
  Widget build(BuildContext context) {
    final primarySoft = PrestaHubTheme.primary.withValues(alpha: 0.10);
    final primarySoftBorder = PrestaHubTheme.primary.withValues(alpha: 0.25);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
      physics: const BouncingScrollPhysics(),
      children: [
        Text(
          'Décrivez votre besoin',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: PrestaHubTheme.textLight,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Plus votre description est claire, plus les prestataires pourront répondre précisément.',
          style: GoogleFonts.inter(
            fontSize: 13,
            color: PrestaHubTheme.textMutedLight,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 22),
        _buildLabel('Titre de la demande'),
        const SizedBox(height: 8),
        _buildField(
          controller: _titleCtrl,
          hint: 'Ex. Fuite sous évier cuisine',
          onChanged: (v) {
            widget.draft.title = v;
            widget.onChanged();
          },
          maxLines: 1,
        ),
        const SizedBox(height: 18),
        _buildLabel('Description détaillée'),
        const SizedBox(height: 8),
        _buildField(
          controller: _descCtrl,
          hint:
              'Décrivez votre problème, les travaux à réaliser ou le contexte…',
          onChanged: (v) {
            widget.draft.description = v;
            widget.onChanged();
          },
          maxLines: 6,
          maxLength: _maxDescLength,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${_descCtrl.text.length}/$_maxDescLength',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: PrestaHubTheme.borderStrong,
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
        _buildLabel('Photos (optionnel)'),
        const SizedBox(height: 8),
        Text(
          'Ajoutez jusqu\'à 5 photos pour illustrer votre demande.',
          style: GoogleFonts.inter(
            fontSize: 12,
            color: PrestaHubTheme.borderStrong,
          ),
        ),
        const SizedBox(height: 10),
        _buildPhotoGrid(primarySoft, primarySoftBorder),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: PrestaHubTheme.textLight,
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required ValueChanged<String> onChanged,
    int maxLines = 1,
    int? maxLength,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: PrestaHubTheme.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: PrestaHubTheme.border),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        maxLines: maxLines,
        maxLength: maxLength,
        style: GoogleFonts.inter(
          fontSize: 14,
          color: PrestaHubTheme.textLight,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.inter(
            fontSize: 14,
            color: PrestaHubTheme.borderStrong,
          ),
          border: InputBorder.none,
          counterText: '',
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoGrid(Color primarySoft, Color primarySoftBorder) {
    final photos = widget.draft.photos;
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        ...List.generate(photos.length, (i) {
          return Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: primarySoft,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: primarySoftBorder),
                ),
                child: const Icon(
                  Icons.image_rounded,
                  color: PrestaHubTheme.primary,
                  size: 26,
                ),
              ),
              Positioned(
                top: -6,
                right: -6,
                child: GestureDetector(
                  onTap: () => _onRemovePhoto(i),
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: PrestaHubTheme.textLight,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: PrestaHubTheme.backgroundLight,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      color: PrestaHubTheme.backgroundLight,
                      size: 12,
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
        if (photos.length < 5)
          GestureDetector(
            onTap: _onAddPhoto,
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: PrestaHubTheme.surfaceLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: PrestaHubTheme.border),
              ),
              child: const Icon(
                Icons.add_rounded,
                color: PrestaHubTheme.borderStrong,
                size: 26,
              ),
            ),
          ),
      ],
    );
  }
}
