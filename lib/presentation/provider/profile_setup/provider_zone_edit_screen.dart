import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_theme.dart';
import '../../settings/widgets/settings_scaffold.dart';
import 'models/provider_profile_models.dart';

/// Formulaire d'ajout ou d'édition d'une zone d'intervention.
class ProviderZoneEditScreen extends StatefulWidget {
  final ProviderZone? initial;

  const ProviderZoneEditScreen({super.key, this.initial});

  @override
  State<ProviderZoneEditScreen> createState() =>
      _ProviderZoneEditScreenState();
}

class _ProviderZoneEditScreenState extends State<ProviderZoneEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _city;
  late final TextEditingController _districtInput;
  late List<String> _districts;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    final z = widget.initial;
    _name = TextEditingController(text: z?.name ?? '');
    _city = TextEditingController(text: z?.city ?? '');
    _districtInput = TextEditingController();
    _districts = List<String>.from(z?.districts ?? const []);
  }

  @override
  void dispose() {
    _name.dispose();
    _city.dispose();
    _districtInput.dispose();
    super.dispose();
  }

  void _addDistrict() {
    final v = _districtInput.text.trim();
    if (v.isEmpty) return;
    if (_districts.contains(v)) {
      _districtInput.clear();
      return;
    }
    setState(() {
      _districts.add(v);
      _districtInput.clear();
    });
  }

  void _removeDistrict(String d) {
    setState(() => _districts.remove(d));
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    final result = ProviderZone(
      id: widget.initial?.id ??
          'zone-${DateTime.now().millisecondsSinceEpoch}',
      name: _name.text.trim(),
      city: _city.text.trim(),
      districts: _districts,
      isActive: widget.initial?.isActive ?? true,
    );
    setState(() => _submitting = false);
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initial != null;
    return SettingsScaffold(
      title: isEdit ? 'Modifier la zone' : 'Nouvelle zone',
      subtitle: isEdit
          ? 'Ajustez les détails de votre couverture'
          : 'Ajoutez une ville à votre périmètre',
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
          physics: const BouncingScrollPhysics(),
          children: [
            const _Label('Nom de la zone'),
            _textField(
              controller: _name,
              hint: 'Paris centre, Boulogne, ...',
              validator: _required,
            ),
            const SizedBox(height: 14),
            const _Label('Ville principale'),
            _textField(
              controller: _city,
              hint: 'Paris',
              validator: _required,
            ),
            const SizedBox(height: 18),
            const _Label('Quartiers couverts (optionnel)'),
            _DistrictsInput(
              controller: _districtInput,
              onSubmit: _addDistrict,
            ),
            if (_districts.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: _districts
                    .map(
                      (d) => Chip(
                        label: Text(d,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            )),
                        backgroundColor: PrestaHubTheme.surface2Light,
                        deleteIconColor: PrestaHubTheme.textMutedLight,
                        onDeleted: () => _removeDistrict(d),
                      ),
                    )
                    .toList(),
              ),
            ],
            const SizedBox(height: 28),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _submitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: PrestaHubTheme.primary,
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
                        isEdit ? 'Enregistrer' : 'Ajouter la zone',
                        style: GoogleFonts.inter(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      style: GoogleFonts.inter(fontSize: 14, color: PrestaHubTheme.textLight),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.inter(
          fontSize: 14,
          color: PrestaHubTheme.textMutedLight,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: PrestaHubTheme.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: PrestaHubTheme.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: PrestaHubTheme.danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: PrestaHubTheme.danger, width: 1.5),
        ),
      ),
    );
  }

  String? _required(String? v) {
    if (v == null || v.trim().isEmpty) return 'Champ obligatoire';
    return null;
  }
}

class _DistrictsInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSubmit;

  const _DistrictsInput({required this.controller, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => onSubmit(),
            style: GoogleFonts.inter(
                fontSize: 14, color: PrestaHubTheme.textLight),
            decoration: InputDecoration(
              hintText: '1er, 2e, Montmartre...',
              hintStyle: GoogleFonts.inter(
                fontSize: 14,
                color: PrestaHubTheme.textMutedLight,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
        ),
        const SizedBox(width: 8),
        SizedBox(
          height: 48,
          child: ElevatedButton(
            onPressed: onSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: PrestaHubTheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Icon(Icons.add_rounded, size: 20),
          ),
        ),
      ],
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, left: 2),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 12.5,
          fontWeight: FontWeight.w600,
          color: PrestaHubTheme.textMutedLight,
        ),
      ),
    );
  }
}
