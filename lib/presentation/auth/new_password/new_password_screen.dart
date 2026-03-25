import 'package:flutter/material.dart';
import 'package:prestahub/l10n/translations.g.dart';
import 'package:go_router/go_router.dart';
import 'package:prestahub/core/constants/app_constants.dart';
import 'widgets/new_password_illustration.dart';
import 'widgets/password_requirement_item.dart';
import 'widgets/password_strength_bar.dart';

/// Écran permettant à l'utilisateur de définir un nouveau mot de passe.
class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // États des conditions (exemples)
  final bool _hasMinChars = true;
  final bool _hasUpperNum = true;
  final bool _hasSpecialChar = false;
  final int _strength = 3;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;
    final surfaceColor = isDark ? const Color(0xFF171121) : Colors.white;

    return Scaffold(
      backgroundColor: surfaceColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const NewPasswordIllustration(),
              
              const SizedBox(height: 16),
              
              Text(
                t.auth.newPasswordScreen.headline,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              
              const SizedBox(height: 12),
              
              Text(
                t.auth.newPasswordScreen.subheadline,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  height: 1.5,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Champ Nouveau mot de passe
              _buildLabel(t.auth.newPasswordScreen.newPasswordLabel, isDark),
              const SizedBox(height: 8),
              _buildPasswordField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                onToggleVisibility: () => setState(() => _obscurePassword = !_obscurePassword),
                prefixIcon: Icons.lock_outline_rounded,
                isDark: isDark,
              ),
              
              const SizedBox(height: 16),
              
              // Barre de force du mot de passe
              PasswordStrengthBar(
                strength: _strength,
                title: t.auth.newPasswordScreen.strengthLabel,
                label: t.auth.newPasswordScreen.strengthStrong,
              ),
              
              const SizedBox(height: 32),
              
              // Champ Confirmer le mot de passe
              _buildLabel(t.auth.newPasswordScreen.confirmPasswordLabel, isDark),
              const SizedBox(height: 8),
              _buildPasswordField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                onToggleVisibility: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                prefixIcon: Icons.refresh_rounded,
                isDark: isDark,
              ),
              
              const SizedBox(height: 24),
              
              // Liste des conditions
              PasswordRequirementItem(
                text: t.auth.newPasswordScreen.requirementChars,
                isMet: _hasMinChars,
              ),
              PasswordRequirementItem(
                text: t.auth.newPasswordScreen.requirementCaseNum,
                isMet: _hasUpperNum,
              ),
              PasswordRequirementItem(
                text: t.auth.newPasswordScreen.requirementSpecial,
                isMet: _hasSpecialChar,
              ),
              
              const SizedBox(height: 48),
              
              // Bouton Enregistrer
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    context.go(AppConstants.routeLogin);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 5,
                    shadowColor: primaryColor.withValues(alpha: 0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    t.auth.newPasswordScreen.submitButton,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label, bool isDark) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
    required IconData prefixIcon,
    required bool isDark,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(color: isDark ? Colors.white : Colors.black),
        decoration: InputDecoration(
          prefixIcon: Icon(prefixIcon, color: isDark ? Colors.grey[400] : Colors.grey[400]),
          suffixIcon: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              color: isDark ? Colors.grey[400] : Colors.grey[400],
            ),
            onPressed: onToggleVisibility,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
      ),
    );
  }
}
