import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_theme.dart';
import '../../models/service_request_models.dart';

class RequestAddressStep extends StatefulWidget {
  final ServiceRequestDraft draft;
  final VoidCallback onChanged;

  const RequestAddressStep({
    super.key,
    required this.draft,
    required this.onChanged,
  });

  @override
  State<RequestAddressStep> createState() => _RequestAddressStepState();
}

class _RequestAddressStepState extends State<RequestAddressStep> {
  late final TextEditingController _addrCtrl;
  late final TextEditingController _compCtrl;

  static const _suggestions = [
    _AddressSuggestion('Domicile', '12 rue de la République, 75011 Paris'),
    _AddressSuggestion('Bureau', '25 avenue des Champs-Élysées, 75008 Paris'),
  ];

  @override
  void initState() {
    super.initState();
    _addrCtrl = TextEditingController(text: widget.draft.address);
    _compCtrl = TextEditingController(text: widget.draft.addressComplement);
  }

  @override
  void dispose() {
    _addrCtrl.dispose();
    _compCtrl.dispose();
    super.dispose();
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
          'Où intervenir ?',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: PrestaHubTheme.textLight,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Indiquez l\'adresse exacte du lieu d\'intervention.',
          style: GoogleFonts.inter(
            fontSize: 13,
            color: PrestaHubTheme.textMutedLight,
          ),
        ),
        const SizedBox(height: 22),
        _buildLabel('Adresse'),
        const SizedBox(height: 8),
        _buildField(
          controller: _addrCtrl,
          hint: 'Numéro, rue, code postal, ville',
          icon: Icons.location_on_outlined,
          onChanged: (v) {
            widget.draft.address = v;
            widget.onChanged();
          },
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: primarySoft,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: primarySoftBorder),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.my_location_rounded,
                  color: PrestaHubTheme.primary,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'Utiliser ma position actuelle',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: PrestaHubTheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        _buildLabel('Complément (optionnel)'),
        const SizedBox(height: 8),
        _buildField(
          controller: _compCtrl,
          hint: 'Bâtiment, étage, code d\'entrée, indications…',
          icon: Icons.notes_outlined,
          onChanged: (v) {
            widget.draft.addressComplement = v;
            widget.onChanged();
          },
        ),
        const SizedBox(height: 22),
        _buildLabel('Adresses enregistrées'),
        const SizedBox(height: 10),
        ..._suggestions.map(
          (s) => GestureDetector(
            onTap: () {
              setState(() {
                _addrCtrl.text = s.address;
                widget.draft.address = s.address;
                widget.onChanged();
              });
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: PrestaHubTheme.backgroundLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: PrestaHubTheme.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: primarySoft,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      s.label == 'Domicile'
                          ? Icons.home_outlined
                          : Icons.work_outline_rounded,
                      color: PrestaHubTheme.primary,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s.label,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: PrestaHubTheme.textLight,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          s.address,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: PrestaHubTheme.textMutedLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: PrestaHubTheme.borderStrong,
                    size: 13,
                  ),
                ],
              ),
            ),
          ),
        ),
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
    required IconData icon,
    required ValueChanged<String> onChanged,
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
          prefixIcon: Icon(
            icon,
            color: PrestaHubTheme.borderStrong,
            size: 18,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 13),
        ),
      ),
    );
  }
}

class _AddressSuggestion {
  final String label;
  final String address;
  const _AddressSuggestion(this.label, this.address);
}
