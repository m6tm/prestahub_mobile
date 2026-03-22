import 'dart:io';
import 'package:flutter/foundation.dart';

/// Énumération des environnements disponibles.
enum AppEnvironment { development, production }

/// Configuration globale de l'API permettant de switcher entre Dev et Prod.
class ApiConfig {
  /// Définit l'environnement actuel.
  /// On peut utiliser --dart-define=ENVIRONMENT=production lors du build.
  static const String _envString = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'development',
  );

  static AppEnvironment get environment {
    if (_envString == 'production' || kReleaseMode) {
      return AppEnvironment.production;
    }
    return AppEnvironment.development;
  }

  /// Durée de timeout pour la connexion.
  static const Duration connectTimeout = Duration(seconds: 15);

  /// Durée de timeout pour la réception des données.
  static const Duration receiveTimeout = Duration(seconds: 15);

  /// URL de base selon l'environnement et la plateforme.
  ///
  /// En développement, supporte dynamiquement `localhost`, `10.0.2.2` (Android)
  /// et peut être surchargé par `--dart-define=API_HOST=192.168.1.1` pour les appareils physiques.
  static String get baseUrl {
    if (isProd) {
      return 'https://api.prestahub.com/api/v1';
    }

    /// On peut surcharger l'hôte pour un appareil physique en utilisant:
    /// flutter run --dart-define=API_HOST=192.168.1.X
    const String customHost = String.fromEnvironment('API_HOST');
    if (customHost.isNotEmpty) {
      return 'http://$customHost:3000/api/v1';
    }

    // Gestion intelligente du localhost par défaut
    if (kIsWeb) return 'http://localhost:3000/api/v1';

    // Sur Android, 10.0.2.2 pointe vers la machine hôte. Sur iOS, localhost.
    final String host = Platform.isAndroid ? '10.0.2.2' : 'localhost';
    return 'http://$host:3000/api/v1';
  }

  /// Indique si nous sommes en mode développement.
  static bool get isDev => environment == AppEnvironment.development;

  /// Indique si nous sommes en mode production.
  static bool get isProd => environment == AppEnvironment.production;
}
