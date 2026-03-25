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
  static const String routeClientRequests = '/client/requests';
  static const String routeClientMessages = '/client/messages';
  static const String routeClientProfile = '/client/profile';

  // Provider routes
  static const String routeProviderHome = '/provider/home';
  static const String routeProviderRequests = '/provider/requests';
  static const String routeProviderMissions = '/provider/missions';
  static const String routeProviderMessages = '/provider/messages';
  static const String routeProviderProfile = '/provider/profile';

  // Admin routes
  static const String routeAdminDashboard = '/admin/dashboard';
}
