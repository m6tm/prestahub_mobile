/// Classe regroupant tous les points de terminaison (endpoints) de l'API.
class ApiEndpoints {
  // --- AUTHENTIFICATION ---
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String me = '/auth/me';
  static const String resetPassword = '/auth/reset-password';
  static const String refreshToken = '/auth/refresh-token';

  // --- UTILISATEURS / PROFILS ---
  static const String profiles = '/profiles';
  static String profile(String id) => '/profiles/$id';
  static const String updateProfile = '/profiles/me';
  static const String deleteProfile = '/profiles/me';
  
  // --- MISSIONS (Exemple) ---
  static const String missions = '/missions';
  static String missionDetail(String id) => '/missions/$id';
  static const String myMissions = '/missions/me';

  // --- MESSAGES (Exemple) ---
  static const String conversations = '/conversations';
  static String chat(String id) => '/conversations/$id/messages';

  // --- NOTIFICATIONS (Exemple) ---
  static const String notifications = '/notifications';
  
  // --- SERVICES (Exemple) ---
  static const String services = '/services';
  static const String popularServices = '/services/popular';
}
