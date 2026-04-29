import 'package:shared_preferences/shared_preferences.dart';

/// Gère la persistance du statut d'onboarding.
///
/// L'onboarding est affiché **une seule fois** au premier lancement.
/// Dès que l'utilisateur le termine ou l'ignore, [markSeen] est appelé
/// et le flag est stocké localement via SharedPreferences.
class OnboardingPrefsService {
  OnboardingPrefsService._();

  static const String _key = 'onboarding_seen';

  /// Retourne `true` si l'onboarding a déjà été vu.
  static Future<bool> hasSeen() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? false;
  }

  /// Marque l'onboarding comme vu (appeler à la fin ou au skip).
  static Future<void> markSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, true);
  }

  /// Remet le flag à zéro (utile en développement / tests).
  static Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
