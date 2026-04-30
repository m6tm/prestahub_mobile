import 'package:prestahub/core/network/api_config.dart';

class AppConstants {
  // App Info
  static const String appName = 'PrestaHub';
  static const String appVersion = '1.0.0';

  // API
  static String get apiBaseUrl => ApiConfig.baseUrl;

  // Environnement
  static bool get isDev => ApiConfig.isDev;
  static bool get isProd => ApiConfig.isProd;

  // Routes
  static const String routeSplash = '/';
  static const String routeOnboarding = '/onboarding';
  static const String routeLogin = '/login';
  static const String routeRegister = '/register';
  static const String routeOtp = '/otp';
  static const String routeForgotPassword = '/forgot-password';
  static const String routeNewPassword = '/new-password';

  // Client routes
  static const String routeClientHome = '/client/home';
  static const String routeClientSearch = '/client/search';
  static const String routeClientCategories = '/client/categories';
  static const String routeClientProviderDetail = '/client/provider/:id';
  static const String routeClientRequests = '/client/requests';
  static const String routeClientMessages = '/client/messages';
  static const String routeClientConversation = '/client/messages/:id';
  static const String routeClientCall = '/client/call/:id';

  // Client — demandes de service
  static const String routeClientRequestCreate = '/client/request/create';
  static const String routeClientRequestReview = '/client/request/review';
  static const String routeClientRequestConfirmation = '/client/request/confirmation';
  static const String routeClientRequestDetail = '/client/request/:id';
  static const String routeClientMissionHistory = '/client/missions/history';
  static const String routeClientMissionDetail = '/client/mission/:id';
  static const String routeClientMissionReview = '/client/mission/:id/review';
  static const String routeClientReportReview = '/client/review/:id/report';

  // Provider routes
  static const String routeProviderHome = '/provider/home';
  static const String routeProviderRequests = '/provider/requests';
  static const String routeProviderMissions = '/provider/missions';
  static const String routeProviderMessages = '/provider/messages';

  // Provider — configuration du profil professionnel
  static const String routeProviderSetup = '/provider/setup';
  static const String routeProviderProfileEdit = '/provider/setup/profile';
  static const String routeProviderServices = '/provider/setup/services';
  static const String routeProviderServiceEdit = '/provider/setup/services/edit';
  static const String routeProviderZones = '/provider/setup/zones';
  static const String routeProviderZoneEdit = '/provider/setup/zones/edit';
  static const String routeProviderPricing = '/provider/setup/pricing';
  static const String routeProviderAvailability = '/provider/setup/availability';
  static const String routeProviderDocuments = '/provider/setup/documents';
  static const String routeProviderVerification = '/provider/setup/verification';

  // Admin routes
  static const String routeAdminDashboard = '/admin/dashboard';

  // Paramètres — partagés client / prestataire
  static const String routeSettings = '/settings';

  // Profil personnel
  static const String routeSettingsProfile = '/settings/profile';
  static const String routeSettingsProfileEdit = '/settings/profile/edit';
  static const String routeSettingsAddresses = '/settings/addresses';
  static const String routeSettingsAddressEdit = '/settings/addresses/edit';

  // Sécurité
  static const String routeSettingsSecurity = '/settings/security';
  static const String routeSettingsChangePassword = '/settings/security/password';
  static const String routeSettingsOtp = '/settings/security/otp';
  static const String routeSettingsDevices = '/settings/security/devices';

  // Préférences
  static const String routeSettingsLanguage = '/settings/preferences/language';
  static const String routeSettingsNotifications = '/settings/preferences/notifications';
  static const String routeSettingsTheme = '/settings/preferences/theme';
  static const String routeSettingsPrivacy = '/settings/preferences/privacy';
  static const String routeSettingsGeolocation = '/settings/preferences/geolocation';

  // Aide et support
  static const String routeSettingsHelp = '/settings/help';
  static const String routeSettingsContactSupport = '/settings/help/contact';
  static const String routeSettingsReportIssue = '/settings/help/report';

  // Légal
  static const String routeSettingsTerms = '/settings/legal/terms';
  static const String routeSettingsPrivacyPolicy = '/settings/legal/privacy';
  static const String routeSettingsLegalMentions = '/settings/legal/mentions';
  static const String routeSettingsAbout = '/settings/legal/about';
}
