import 'package:logger/logger.dart';

/// Interface pour un service de notification universel (UI ou Système).
abstract class INotificationService {
  /// Affiche une notification à l'utilisateur.
  void showNotification(String title, String message);
  
  /// Affiche une erreur critique.
  void showError(String message);
}

/// Implémentation par défaut utilisant les logs en attendant une intégration UI.
class LoggerNotificationService implements INotificationService {
  final Logger _logger = Logger();

  @override
  void showNotification(String title, String message) {
    _logger.i('USER NOTIFICATION: [$title] $message');
  }

  @override
  void showError(String message) {
    _logger.e('USER ERROR: $message');
  }
}
