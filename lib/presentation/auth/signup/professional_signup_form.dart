import 'package:flutter/material.dart';
import 'package:prestahub/core/theme/app_theme.dart';
import 'package:prestahub/l10n/translations.g.dart';

/// Formulaire d'inscription pour les prestataires professionnels.
///
/// Affiche les champs spécifiques au profil prestataire : raison sociale,
/// SIRET, catégorie métier, ainsi que les champs communs (nom, email,
/// téléphone, mot de passe). Reprend fidèlement la maquette Stitch
/// "Inscription Professionnelle (Épurée)".
class ProfessionalSignupForm extends StatefulWidget {
  /// Crée une instance de [ProfessionalSignupForm].
  const ProfessionalSignupForm({super.key});

  @override
  State<ProfessionalSignupForm> createState() => _ProfessionalSignupFormState();
}

class _ProfessionalSignupFormState extends State<ProfessionalSignupForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final s = t.auth.signup;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SignupField(
            label: s.fullnameLabel,
            hint: s.fullnamePlaceholder,
            icon: Icons.person_outline,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 20),
          _SignupField(
            label: s.companyLabel,
            hint: s.companyPlaceholder,
            icon: Icons.business_outlined,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 20),
          _SignupField(
            label: s.emailLabel,
            hint: s.emailPlaceholder,
            icon: Icons.mail_outline,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 20),
          _SignupField(
            label: s.phoneLabel,
            hint: s.phonePlaceholder,
            icon: Icons.phone_iphone_outlined,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 20),
          _SignupField(
            label: s.siretLabel,
            hint: s.siretPlaceholder,
            icon: Icons.assignment_ind_outlined,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 20),
          _CategoryDropdownField(
            label: s.categoryLabel,
            placeholder: s.categoryPlaceholder,
            categories: [
              _CategoryItem(
                value: 'construction',
                label: s.categories.construction,
              ),
              _CategoryItem(value: 'cleaning', label: s.categories.cleaning),
              _CategoryItem(value: 'it', label: s.categories.it),
              _CategoryItem(value: 'events', label: s.categories.events),
              _CategoryItem(value: 'health', label: s.categories.health),
            ],
            selectedValue: _selectedCategory,
            onChanged: (value) => setState(() => _selectedCategory = value),
          ),
          const SizedBox(height: 20),
          _SignupField(
            label: s.passwordLabel,
            hint: s.passwordPlaceholder,
            icon: Icons.lock_outline,
            isPassword: true,
            isPasswordVisible: _isPasswordVisible,
            onToggleVisibility: () =>
                setState(() => _isPasswordVisible = !_isPasswordVisible),
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: 20),
          _SignupTermsText(
            prefix: s.termsPrefix,
            cguLabel: s.termsCgu,
            andText: s.termsAnd,
            privacyLabel: s.termsPrivacy,
          ),
          const SizedBox(height: 28),
          _SubmitButton(label: s.submitProfessional),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Widgets atomiques internes
// ---------------------------------------------------------------------------

/// Champ de saisie standard avec icône préfixe et label flottant.
class _SignupField extends StatelessWidget {
  const _SignupField({
    required this.label,
    required this.hint,
    required this.icon,
    this.isPassword = false,
    this.isPasswordVisible = false,
    this.onToggleVisibility,
    this.keyboardType,
    this.textInputAction,
  });

  final String label;
  final String hint;
  final IconData icon;
  final bool isPassword;
  final bool isPasswordVisible;
  final VoidCallback? onToggleVisibility;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF334155),
            ),
          ),
        ),
        TextField(
          obscureText: isPassword && !isPasswordVisible,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey, size: 20),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: Colors.grey,
                      size: 20,
                    ),
                    onPressed: onToggleVisibility,
                  )
                : null,
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: PrestaHubTheme.primary.withValues(alpha: 0.5),
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 16,
            ),
          ),
        ),
      ],
    );
  }
}

/// Modèle de données pour une option de catégorie.
class _CategoryItem {
  const _CategoryItem({required this.value, required this.label});

  final String value;
  final String label;
}

/// Sélecteur déroulant pour la catégorie professionnelle.
class _CategoryDropdownField extends StatelessWidget {
  const _CategoryDropdownField({
    required this.label,
    required this.placeholder,
    required this.categories,
    required this.selectedValue,
    required this.onChanged,
  });

  final String label;
  final String placeholder;
  final List<_CategoryItem> categories;
  final String? selectedValue;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF334155),
            ),
          ),
        ),
        DropdownButtonFormField<String>(
          initialValue: selectedValue,
          hint: Row(
            children: [
              const SizedBox(width: 8),
              Text(
                placeholder,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
          icon: const Icon(Icons.expand_more, color: Colors.grey),
          decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.category_outlined,
              color: Colors.grey,
              size: 20,
            ),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: PrestaHubTheme.primary.withValues(alpha: 0.5),
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 0,
            ),
          ),
          items: categories
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item.value,
                  child: Text(item.label, style: const TextStyle(fontSize: 14)),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

/// Texte des conditions générales avec liens cliquables.
class _SignupTermsText extends StatelessWidget {
  const _SignupTermsText({
    required this.prefix,
    required this.cguLabel,
    required this.andText,
    required this.privacyLabel,
  });

  final String prefix;
  final String cguLabel;
  final String andText;
  final String privacyLabel;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
        children: [
          TextSpan(text: prefix),
          TextSpan(
            text: cguLabel,
            style: const TextStyle(
              color: PrestaHubTheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(text: andText),
          TextSpan(
            text: privacyLabel,
            style: const TextStyle(
              color: PrestaHubTheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const TextSpan(text: '.'),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}

/// Bouton de soumission principal.
class _SubmitButton extends StatelessWidget {
  const _SubmitButton({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: PrestaHubTheme.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 6,
          shadowColor: PrestaHubTheme.primary.withValues(alpha: 0.4),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
