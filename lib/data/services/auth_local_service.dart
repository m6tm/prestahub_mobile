import 'package:shared_preferences/shared_preferences.dart';

/// Service de stockage local pour le jeton d'authentification (JWT).
class AuthLocalService {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  final SharedPreferences _prefs;

  AuthLocalService(this._prefs);

  /// Sauvegarde le jeton d'accès [token] dans le stockage persistant.
  Future<void> saveToken(String token) async {
    await _prefs.setString(_accessTokenKey, token);
  }

  /// Récupère le jeton d'accès. Retourne `null` si aucun jeton n'est trouvé.
  String? getToken() {
    return _prefs.getString(_accessTokenKey);
  }

  /// Sauvegarde le jeton de rafraîchissement [token].
  Future<void> saveRefreshToken(String token) async {
    await _prefs.setString(_refreshTokenKey, token);
  }

  /// Récupère le jeton de rafraîchissement.
  String? getRefreshToken() {
    return _prefs.getString(_refreshTokenKey);
  }

  /// Supprime définitivement tous les jetons du stockage local.
  Future<void> clearTokens() async {
    await _prefs.remove(_accessTokenKey);
    await _prefs.remove(_refreshTokenKey);
  }

  /// Indique si un jeton d'accès est actuellement présent en local.
  bool hasToken() {
    return _prefs.containsKey(_accessTokenKey);
  }
}
