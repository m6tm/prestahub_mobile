import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_theme.dart';
import '../../settings/widgets/settings_scaffold.dart';
import 'models/provider_mission_models.dart';

/// Écran de refus d'une demande avec saisie d'un motif.
class ProviderRefusalScreen extends StatefulWidget {
  final ProviderRequestSummary? summary;

  const ProviderRefusalScreen({super.key, this.summary});

  @override
  State<ProviderRefusalScreen> createState() => _ProviderRefusalScreenState();
}

class _ProviderRefusalScreenState extends State<ProviderRefusalScreen> {
  RefusalReason _reason = RefusalReason.unavailable;
  final _noteCtrl = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() => _submitting = false);
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      title: 'Refuser la demande',
      subtitle: widget.summary != null
          ? 'Demande « ${widget.summary!.title} »'
          : 'Indiquez un motif',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        physics: const BouncingScrollPhysics(),
        children: [
          _Hint(),
          const SizedBox(height: 16),
          Text(
            'MOTIF DU REFUS',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: PrestaHubTheme.textMutedLight,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: PrestaHubTheme.border),
            ),
            child: Column(
              children: RefusalReason.values.asMap().entries.map((e) {
                final i = e.key;
                final r = e.value;
                final selected = r == _reason;
                return Column(
                  children: [
                    InkWell(
                      onTap: () => setState(() => _reason = r),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        child: Row(
                          children: [
                            Icon(
                              selected
                                  ? Icons.radio_button_checked_rounded
                                  : Icons.radio_button_unchecked_rounded,
                              color: selected
                                  ? PrestaHubTheme.primary
                                  : PrestaHubTheme.borderStrong,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                r.label,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: PrestaHubTheme.textLight,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (i < RefusalReason.values.length - 1)
                      const Padding(
                        padding: EdgeInsets.only(left: 44),
                        child: Divider(
                          height: 1,
                          thickness: 1,
                          color: PrestaHubTheme.border,
                        ),
                      ),
                  ],
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'COMMENTAIRE (OPTIONNEL)',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: PrestaHubTheme.textMutedLight,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _noteCtrl,
            maxLines: 4,
            style: GoogleFonts.inter(
                fontSize: 14, color: PrestaHubTheme.textLight),
            decoration: InputDecoration(
              hintText:
                  'Précisez votre motif pour aider le client à trouver un autre prestataire.',
              hintStyle: GoogleFonts.inter(
                fontSize: 13,
                color: PrestaHubTheme.textMutedLight,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.all(14),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: PrestaHubTheme.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                    color: PrestaHubTheme.primary, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: _submitting ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: PrestaHubTheme.danger,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _submitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : Text(
                      'Confirmer le refus',
                      style: GoogleFonts.inter(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 44,
            child: TextButton(
              onPressed: _submitting ? null : () => Navigator.of(context).pop(),
              child: Text(
                'Annuler',
                style: GoogleFonts.inter(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: PrestaHubTheme.textMutedLight,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Hint extends StatelessWidget {
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
              color: PrestaHubTheme.info, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Le client verra votre motif. Restez courtois pour préserver votre réputation.',
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
