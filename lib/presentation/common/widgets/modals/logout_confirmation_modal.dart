import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../l10n/translations.g.dart';

/// Modal de confirmation de déconnexion.
///
/// Ce widget affiche une boîte de dialogue demandant à l'utilisateur
/// s'il souhaite réellement se déconnecter de son compte.
class LogoutConfirmationModal extends StatelessWidget {
  /// Callback appelé lorsque l'utilisateur confirme la déconnexion.
  final VoidCallback onConfirm;

  /// Crée une instance du modal de déconnexion.
  const LogoutConfirmationModal({
    super.key,
    required this.onConfirm,
  });

  /// Méthode utilitaire pour afficher le modal.
  ///
  /// Prend en paramètre le [context] et le callback [onConfirm].
  static Future<void> show(BuildContext context, {required VoidCallback onConfirm}) {
    return showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      barrierDismissible: true,
      builder: (context) => LogoutConfirmationModal(onConfirm: onConfirm),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Utilisation de Slang pour les traductions
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          constraints: const BoxConstraints(maxWidth: 340),
          decoration: BoxDecoration(
            color: isDark ? PrestaHubTheme.surfaceDark : PrestaHubTheme.backgroundLight,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.1),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Indicateur visuel (Handle bar) - Présent dans la maquette
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(
                  height: 4,
                  width: 48,
                  decoration: BoxDecoration(
                    color: isDark ? PrestaHubTheme.surface2Dark : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                child: Column(
                  children: [
                    // Icône de déconnexion entourée
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: PrestaHubTheme.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.logout_rounded,
                        color: PrestaHubTheme.primary,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Titre du modal
                    Text(
                      t.auth.logout.confirmTitle,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? PrestaHubTheme.textDark : PrestaHubTheme.textLight,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    
                    // Message de confirmation
                    Text(
                      t.auth.logout.confirmMessage,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark ? PrestaHubTheme.textMutedDark : PrestaHubTheme.textMutedLight,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    
                    // Boutons d'action
                    Column(
                      children: [
                        // Bouton de confirmation (Déconnexion)
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              onConfirm();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: PrestaHubTheme.primary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              t.auth.logout.submitButton,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                        // Bouton d'annulation
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: isDark ? PrestaHubTheme.surface2Dark : Colors.grey.shade100,
                                width: 2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              foregroundColor: isDark ? PrestaHubTheme.textDark : PrestaHubTheme.textLight,
                            ),
                            child: Text(
                              t.common.buttons.cancel,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
