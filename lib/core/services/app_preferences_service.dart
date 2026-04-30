import 'package:shared_preferences/shared_preferences.dart';

/// Modes de thème supportés par l'application.
enum AppThemeMode { system, light, dark }

/// Langues supportées par l'application.
enum AppLanguage { fr, en, ar, es }

extension AppThemeModeX on AppThemeMode {
  String get storageValue => switch (this) {
        AppThemeMode.system => 'system',
        AppThemeMode.light => 'light',
        AppThemeMode.dark => 'dark',
      };

  String get label => switch (this) {
        AppThemeMode.system => 'Système',
        AppThemeMode.light => 'Clair',
        AppThemeMode.dark => 'Sombre',
      };

  static AppThemeMode fromStorage(String? value) {
    return switch (value) {
      'light' => AppThemeMode.light,
      'dark' => AppThemeMode.dark,
      _ => AppThemeMode.system,
    };
  }
}

extension AppLanguageX on AppLanguage {
  String get code => switch (this) {
        AppLanguage.fr => 'fr',
        AppLanguage.en => 'en',
        AppLanguage.ar => 'ar',
        AppLanguage.es => 'es',
      };

  String get label => switch (this) {
        AppLanguage.fr => 'Français',
        AppLanguage.en => 'English',
        AppLanguage.ar => 'العربية',
        AppLanguage.es => 'Español',
      };

  String get flag => switch (this) {
        AppLanguage.fr => '🇫🇷',
        AppLanguage.en => '🇬🇧',
        AppLanguage.ar => '🇸🇦',
        AppLanguage.es => '🇪🇸',
      };

  static AppLanguage fromCode(String? code) {
    return switch (code) {
      'en' => AppLanguage.en,
      'ar' => AppLanguage.ar,
      'es' => AppLanguage.es,
      _ => AppLanguage.fr,
    };
  }
}

/// Service centralisé de persistance des préférences utilisateur.
///
/// Stocke localement les choix d'UI (langue, thème, notifications,
/// consentements) sans dépendance externe au backend.
class AppPreferencesService {
  AppPreferencesService._();

  static const String _keyThemeMode = 'app_theme_mode';
  static const String _keyLanguage = 'app_language';
  static const String _keyNotifPush = 'app_notif_push';
  static const String _keyNotifEmail = 'app_notif_email';
  static const String _keyNotifSms = 'app_notif_sms';
  static const String _keyNotifSound = 'app_notif_sound';
  static const String _keyNotifVibration = 'app_notif_vibration';
  static const String _keyNotifMessages = 'app_notif_messages';
  static const String _keyNotifRequests = 'app_notif_requests';
  static const String _keyNotifPromotions = 'app_notif_promotions';
  static const String _keyLocationConsent = 'app_location_consent';
  static const String _keyAnalyticsConsent = 'app_analytics_consent';
  static const String _keyMarketingConsent = 'app_marketing_consent';
  static const String _keyHighPrecisionLocation = 'app_high_precision_location';

  // ── Thème ──────────────────────────────────────────────────────────────
  static Future<AppThemeMode> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return AppThemeModeX.fromStorage(prefs.getString(_keyThemeMode));
  }

  static Future<void> setThemeMode(AppThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyThemeMode, mode.storageValue);
  }

  // ── Langue ─────────────────────────────────────────────────────────────
  static Future<AppLanguage> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return AppLanguageX.fromCode(prefs.getString(_keyLanguage));
  }

  static Future<void> setLanguage(AppLanguage language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLanguage, language.code);
  }

  // ── Notifications ──────────────────────────────────────────────────────
  static Future<NotificationPrefs> getNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    return NotificationPrefs(
      push: prefs.getBool(_keyNotifPush) ?? true,
      email: prefs.getBool(_keyNotifEmail) ?? true,
      sms: prefs.getBool(_keyNotifSms) ?? false,
      sound: prefs.getBool(_keyNotifSound) ?? true,
      vibration: prefs.getBool(_keyNotifVibration) ?? true,
      messages: prefs.getBool(_keyNotifMessages) ?? true,
      requests: prefs.getBool(_keyNotifRequests) ?? true,
      promotions: prefs.getBool(_keyNotifPromotions) ?? false,
    );
  }

  static Future<void> setNotifications(NotificationPrefs p) async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setBool(_keyNotifPush, p.push),
      prefs.setBool(_keyNotifEmail, p.email),
      prefs.setBool(_keyNotifSms, p.sms),
      prefs.setBool(_keyNotifSound, p.sound),
      prefs.setBool(_keyNotifVibration, p.vibration),
      prefs.setBool(_keyNotifMessages, p.messages),
      prefs.setBool(_keyNotifRequests, p.requests),
      prefs.setBool(_keyNotifPromotions, p.promotions),
    ]);
  }

  // ── Confidentialité ────────────────────────────────────────────────────
  static Future<PrivacyPrefs> getPrivacy() async {
    final prefs = await SharedPreferences.getInstance();
    return PrivacyPrefs(
      locationConsent: prefs.getBool(_keyLocationConsent) ?? true,
      analyticsConsent: prefs.getBool(_keyAnalyticsConsent) ?? true,
      marketingConsent: prefs.getBool(_keyMarketingConsent) ?? false,
      highPrecisionLocation: prefs.getBool(_keyHighPrecisionLocation) ?? true,
    );
  }

  static Future<void> setPrivacy(PrivacyPrefs p) async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setBool(_keyLocationConsent, p.locationConsent),
      prefs.setBool(_keyAnalyticsConsent, p.analyticsConsent),
      prefs.setBool(_keyMarketingConsent, p.marketingConsent),
      prefs.setBool(_keyHighPrecisionLocation, p.highPrecisionLocation),
    ]);
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    for (final key in [
      _keyThemeMode,
      _keyLanguage,
      _keyNotifPush,
      _keyNotifEmail,
      _keyNotifSms,
      _keyNotifSound,
      _keyNotifVibration,
      _keyNotifMessages,
      _keyNotifRequests,
      _keyNotifPromotions,
      _keyLocationConsent,
      _keyAnalyticsConsent,
      _keyMarketingConsent,
      _keyHighPrecisionLocation,
    ]) {
      await prefs.remove(key);
    }
  }
}

class NotificationPrefs {
  final bool push;
  final bool email;
  final bool sms;
  final bool sound;
  final bool vibration;
  final bool messages;
  final bool requests;
  final bool promotions;

  const NotificationPrefs({
    required this.push,
    required this.email,
    required this.sms,
    required this.sound,
    required this.vibration,
    required this.messages,
    required this.requests,
    required this.promotions,
  });

  NotificationPrefs copyWith({
    bool? push,
    bool? email,
    bool? sms,
    bool? sound,
    bool? vibration,
    bool? messages,
    bool? requests,
    bool? promotions,
  }) {
    return NotificationPrefs(
      push: push ?? this.push,
      email: email ?? this.email,
      sms: sms ?? this.sms,
      sound: sound ?? this.sound,
      vibration: vibration ?? this.vibration,
      messages: messages ?? this.messages,
      requests: requests ?? this.requests,
      promotions: promotions ?? this.promotions,
    );
  }
}

class PrivacyPrefs {
  final bool locationConsent;
  final bool analyticsConsent;
  final bool marketingConsent;
  final bool highPrecisionLocation;

  const PrivacyPrefs({
    required this.locationConsent,
    required this.analyticsConsent,
    required this.marketingConsent,
    required this.highPrecisionLocation,
  });

  PrivacyPrefs copyWith({
    bool? locationConsent,
    bool? analyticsConsent,
    bool? marketingConsent,
    bool? highPrecisionLocation,
  }) {
    return PrivacyPrefs(
      locationConsent: locationConsent ?? this.locationConsent,
      analyticsConsent: analyticsConsent ?? this.analyticsConsent,
      marketingConsent: marketingConsent ?? this.marketingConsent,
      highPrecisionLocation:
          highPrecisionLocation ?? this.highPrecisionLocation,
    );
  }
}
