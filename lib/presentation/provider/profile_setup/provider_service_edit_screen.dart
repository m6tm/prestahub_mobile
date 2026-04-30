import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_theme.dart';
import '../../settings/widgets/settings_scaffold.dart';
import 'models/provider_profile_models.dart';

/// Formulaire d'ajout ou d'édition d'un service proposé.
class ProviderServiceEditScreen extends StatefulWidget {
  final ProviderService? initial;

  const ProviderServiceEditScreen({super.key, this.initial});

  @override
  State<ProviderServiceEditScreen> createState() =>
      _ProviderServiceEditScreenState();
}

class _ProviderServiceEditScreenState
    extends State<ProviderServiceEditScreen> {
  static const _categories = [
    ServiceCategoryOption(id: 'cat-plumbing', name: 'Plomberie'),
    ServiceCategoryOption(id: 'cat-electricity', name: 'Électricité'),
    ServiceCategoryOption(id: 'cat-painting', name: 'Peinture'),
    ServiceCategoryOption(id: 'cat-cleaning', name: 'Nettoyage'),
    ServiceCategoryOption(id: 'cat-moving', name: 'Déménagement'),
    ServiceCategoryOption(id: 'cat-handyman', name: 'Bricolage'),
  ];

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _description;
  late final TextEditingController _price;
  late final TextEditingController _priceMin;
  late final TextEditingController _priceMax;
  late ServiceCategoryOption _category;
  late PricingType _pricingType;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    final s = widget.initial;
    _name = TextEditingController(text: s?.name ?? '');
    _description = TextEditingController(text: s?.description ?? '');
    _price = TextEditingController(text: s?.price?.toStringAsFixed(0) ?? '');
    _priceMin =
        TextEditingController(text: s?.priceMin?.toStringAsFixed(0) ?? '');
    _priceMax =
        TextEditingController(text: s?.priceMax?.toStringAsFixed(0) ?? '');
    _pricingType = s?.pricingType ?? PricingType.hourly;
    _category = _categories.firstWhere(
      (c) => c.id == s?.categoryId,
      orElse: () => _categories.first,
    );
  }

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _price.dispose();
    _priceMin.dispose();
    _priceMax.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    final result = ProviderService(
      id: widget.initial?.id ??
          'svc-${DateTime.now().millisecondsSinceEpoch}',
      categoryId: _category.id,
      categoryName: _category.name,
      name: _name.text.trim(),
      description: _description.text.trim(),
      pricingType: _pricingType,
      price: _pricingType == PricingType.range ? null : _parseDouble(_price),
      priceMin:
          _pricingType == PricingType.range ? _parseDouble(_priceMin) : null,
      priceMax:
          _pricingType == PricingType.range ? _parseDouble(_priceMax) : null,
      isActive: widget.initial?.isActive ?? true,
    );
    setState(() => _submitting = false);
    Navigator.of(context).pop(result);
  }

  double? _parseDouble(TextEditingController c) {
    final v = c.text.trim().replaceAll(',', '.');
    if (v.isEmpty) return null;
    return double.tryParse(v);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initial != null;
    return SettingsScaffold(
      title: isEdit ? 'Modifier le service' : 'Nouveau service',
      subtitle: isEdit
          ? 'Mettez à jour les informations'
          : 'Ajoutez une prestation à votre profil',
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
          physics: const BouncingScrollPhysics(),
          children: [
            const _Label('Catégorie'),
            _CategoryDropdown(
              value: _category,
              options: _categories,
              onChanged: (v) => setState(() => _category = v),
            ),
            const SizedBox(height: 14),
            const _Label('Nom du service'),
            _textField(
              controller: _name,
              hint: 'Ex. Dépannage fuite d\'eau',
              validator: _required,
            ),
            const SizedBox(height: 14),
            const _Label('Description'),
            _textField(
              controller: _description,
              hint: 'Décrivez la prestation, ses limites, fournitures incluses...',
              maxLines: 4,
              validator: _required,
            ),
            const SizedBox(height: 18),
            const _Label('Mode de facturation'),
            _PricingTypeSelector(
              value: _pricingType,
              onChanged: (v) => setState(() => _pricingType = v),
            ),
            const SizedBox(height: 14),
            if (_pricingType == PricingType.range) ...[
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _Label('Prix minimum (€)'),
                        _priceField(_priceMin, hint: '100'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _Label('Prix maximum (€)'),
                        _priceField(_priceMax, hint: '500'),
                      ],
                    ),
                  ),
                ],
              ),
            ] else ...[
              _Label(_pricingType == PricingType.hourly
                  ? 'Tarif horaire (€ / h)'
                  : 'Prix forfaitaire (€)'),
              _priceField(_price,
                  hint: _pricingType == PricingType.hourly ? '50' : '250'),
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
                        isEdit ? 'Enregistrer' : 'Ajouter le service',
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

  Widget _priceField(TextEditingController c, {required String hint}) {
    return TextFormField(
      controller: c,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
      ],
      validator: _priceValidator,
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

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
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

  String? _priceValidator(String? v) {
    if (v == null || v.trim().isEmpty) return 'Prix obligatoire';
    final parsed = double.tryParse(v.replaceAll(',', '.'));
    if (parsed == null || parsed < 0) return 'Prix invalide';
    return null;
  }
}

class _CategoryDropdown extends StatelessWidget {
  final ServiceCategoryOption value;
  final List<ServiceCategoryOption> options;
  final ValueChanged<ServiceCategoryOption> onChanged;

  const _CategoryDropdown({
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: PrestaHubTheme.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ServiceCategoryOption>(
          isExpanded: true,
          value: value,
          items: options
              .map(
                (opt) => DropdownMenuItem(
                  value: opt,
                  child: Text(
                    opt.name,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: PrestaHubTheme.textLight,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}

class _PricingTypeSelector extends StatelessWidget {
  final PricingType value;
  final ValueChanged<PricingType> onChanged;

  const _PricingTypeSelector({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: PrestaHubTheme.surface2Light,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: PricingType.values.map((type) {
          final selected = type == value;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(type),
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  type.label,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: selected
                        ? PrestaHubTheme.primary
                        : PrestaHubTheme.textMutedLight,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
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
