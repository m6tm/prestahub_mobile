import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_theme.dart';
import '../../settings/widgets/avatar_picker.dart';
import '../../settings/widgets/settings_scaffold.dart';
import 'models/provider_profile_models.dart';

/// Édition des informations professionnelles du prestataire.
///
/// Supporte la modification du nom commercial, de la description, du téléphone,
/// de l'email, du SIRET et de la photo de profil. L'appel au repository
/// prestataire sera branché lorsque `IProviderRepository.updateBusinessProfile`
/// sera disponible.
class ProviderProfileEditScreen extends StatefulWidget {
  const ProviderProfileEditScreen({super.key});

  @override
  State<ProviderProfileEditScreen> createState() =>
      _ProviderProfileEditScreenState();
}

class _ProviderProfileEditScreenState extends State<ProviderProfileEditScreen> {
  static const _initial = ProviderBusinessProfile(
    businessName: 'Atelier Dubois & Fils',
    description:
        'Plombier certifié avec 15 ans d\'expérience. Interventions rapides sur Paris et petite couronne.',
    phone: '+33 6 12 34 56 78',
    email: 'contact@atelier-dubois.fr',
    siret: '824 567 890 00012',
  );

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _businessName;
  late final TextEditingController _description;
  late final TextEditingController _phone;
  late final TextEditingController _email;
  late final TextEditingController _siret;
  File? _pickedAvatar;
  String? _currentAvatarUrl;
  bool _removeAvatar = false;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _businessName = TextEditingController(text: _initial.businessName);
    _description = TextEditingController(text: _initial.description);
    _phone = TextEditingController(text: _initial.phone);
    _email = TextEditingController(text: _initial.email);
    _siret = TextEditingController(text: _initial.siret);
    _currentAvatarUrl = _initial.avatarUrl;
  }

  @override
  void dispose() {
    _businessName.dispose();
    _description.dispose();
    _phone.dispose();
    _email.dispose();
    _siret.dispose();
    super.dispose();
  }

  Future<void> _openAvatarPicker() async {
    final hasAvatar = _pickedAvatar != null ||
        (!_removeAvatar && (_currentAvatarUrl?.isNotEmpty ?? false));
    final result = await showAvatarPicker(context, canRemove: hasAvatar);
    if (!mounted || result == null) return;
    setState(() {
      switch (result.type) {
        case AvatarPickResult.picked:
          _pickedAvatar = result.file;
          _removeAvatar = false;
          break;
        case AvatarPickResult.removed:
          _pickedAvatar = null;
          _removeAvatar = true;
          break;
      }
    });
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _submitting = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profil professionnel mis à jour.'),
        backgroundColor: PrestaHubTheme.success,
      ),
    );
    Navigator.of(context).maybePop();
  }

  String _initials() {
    final name = _businessName.text.trim();
    if (name.isEmpty) return '?';
    final parts = name.split(RegExp(r'\s+'));
    final first = parts.first.isNotEmpty ? parts.first[0] : '';
    final second = parts.length > 1 && parts[1].isNotEmpty ? parts[1][0] : '';
    return (first + second).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      title: 'Profil professionnel',
      subtitle: 'Informations visibles par les clients',
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
          physics: const BouncingScrollPhysics(),
          children: [
            Center(
              child: _AvatarEditor(
                pickedFile: _pickedAvatar,
                remoteUrl: _removeAvatar ? null : _currentAvatarUrl,
                initials: _initials(),
                onTap: _openAvatarPicker,
              ),
            ),
            const SizedBox(height: 28),
            const _Label('Nom commercial'),
            _textField(
              controller: _businessName,
              hint: 'Ex. Atelier Dubois & Fils',
              validator: _required,
            ),
            const SizedBox(height: 14),
            const _Label('Description'),
            _textField(
              controller: _description,
              hint: 'Présentez votre activité aux clients',
              maxLines: 5,
              validator: _required,
            ),
            const SizedBox(height: 14),
            const _Label('Téléphone professionnel'),
            _textField(
              controller: _phone,
              hint: '+33 6 00 00 00 00',
              keyboardType: TextInputType.phone,
              validator: _required,
            ),
            const SizedBox(height: 14),
            const _Label('Email professionnel'),
            _textField(
              controller: _email,
              hint: 'contact@entreprise.fr',
              keyboardType: TextInputType.emailAddress,
              validator: _emailValidator,
            ),
            const SizedBox(height: 14),
            const _Label('SIRET / Identifiant professionnel'),
            _textField(
              controller: _siret,
              hint: '000 000 000 00000',
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9 ]')),
              ],
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
                        'Enregistrer les modifications',
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
    int maxLines = 1,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      inputFormatters: inputFormatters,
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

  String? _emailValidator(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email obligatoire';
    final regex = RegExp(r'^[\w\.\-+]+@[\w\-]+\.[a-zA-Z]{2,}$');
    if (!regex.hasMatch(v.trim())) return 'Format d\'email invalide';
    return null;
  }
}

class _AvatarEditor extends StatelessWidget {
  final File? pickedFile;
  final String? remoteUrl;
  final String initials;
  final VoidCallback onTap;

  const _AvatarEditor({
    required this.pickedFile,
    required this.remoteUrl,
    required this.initials,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = pickedFile != null ||
        (remoteUrl != null && remoteUrl!.isNotEmpty);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 104,
            height: 104,
            decoration: BoxDecoration(
              color: PrestaHubTheme.primary,
              borderRadius: BorderRadius.circular(26),
              image: pickedFile != null
                  ? DecorationImage(
                      image: FileImage(pickedFile!),
                      fit: BoxFit.cover,
                    )
                  : (remoteUrl != null && remoteUrl!.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(remoteUrl!),
                          fit: BoxFit.cover,
                        )
                      : null),
            ),
            alignment: Alignment.center,
            child: hasImage
                ? null
                : Text(
                    initials,
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
          Positioned(
            bottom: -4,
            right: -4,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: PrestaHubTheme.primary,
                borderRadius: BorderRadius.circular(11),
                border: Border.all(color: Colors.white, width: 2),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.photo_camera_rounded,
                color: Colors.white,
                size: 17,
              ),
            ),
          ),
        ],
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
