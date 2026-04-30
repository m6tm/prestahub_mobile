import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_theme.dart';
import '../models/address_model.dart';
import '../widgets/settings_scaffold.dart';

/// Formulaire d'ajout ou d'édition d'une adresse.
class AddressEditScreen extends StatefulWidget {
  final AddressModel? initial;

  const AddressEditScreen({super.key, this.initial});

  @override
  State<AddressEditScreen> createState() => _AddressEditScreenState();
}

class _AddressEditScreenState extends State<AddressEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _label;
  late final TextEditingController _street;
  late final TextEditingController _postal;
  late final TextEditingController _city;
  late final TextEditingController _additional;
  late bool _isPrimary;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    final a = widget.initial;
    _label = TextEditingController(text: a?.label ?? '');
    _street = TextEditingController(text: a?.street ?? '');
    _postal = TextEditingController(text: a?.postalCode ?? '');
    _city = TextEditingController(text: a?.city ?? '');
    _additional = TextEditingController(text: a?.additionalInfo ?? '');
    _isPrimary = a?.isPrimary ?? false;
  }

  @override
  void dispose() {
    _label.dispose();
    _street.dispose();
    _postal.dispose();
    _city.dispose();
    _additional.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() => _submitting = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(widget.initial == null
            ? 'Adresse ajoutée.'
            : 'Adresse mise à jour.'),
        backgroundColor: PrestaHubTheme.success,
      ),
    );
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initial != null;
    return SettingsScaffold(
      title: isEdit ? 'Modifier l\'adresse' : 'Nouvelle adresse',
      subtitle: isEdit
          ? 'Mettez à jour les informations'
          : 'Ajoutez une nouvelle adresse à votre compte',
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
          physics: const BouncingScrollPhysics(),
          children: [
            _Label('Intitulé'),
            _textField(
              controller: _label,
              hint: 'Domicile, Bureau...',
              validator: _required,
            ),
            const SizedBox(height: 14),
            _Label('Rue'),
            _textField(
              controller: _street,
              hint: '12 rue de la République',
              validator: _required,
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Label('Code postal'),
                      _textField(
                        controller: _postal,
                        hint: '75001',
                        keyboardType: TextInputType.number,
                        validator: _required,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Label('Ville'),
                      _textField(
                        controller: _city,
                        hint: 'Paris',
                        validator: _required,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _Label('Complément (optionnel)'),
            _textField(
              controller: _additional,
              hint: 'Bâtiment, étage, code d\'accès...',
            ),
            const SizedBox(height: 18),
            _PrimarySwitch(
              value: _isPrimary,
              onChanged: (v) => setState(() => _isPrimary = v),
            ),
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
                        isEdit ? 'Enregistrer' : 'Ajouter l\'adresse',
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
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
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

class _PrimarySwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _PrimarySwitch({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: PrestaHubTheme.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Adresse par défaut',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: PrestaHubTheme.textLight,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Utilisée automatiquement pour les nouvelles demandes',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: PrestaHubTheme.textMutedLight,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: PrestaHubTheme.primary,
          ),
        ],
      ),
    );
  }
}
