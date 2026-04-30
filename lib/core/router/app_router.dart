import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prestahub/application/auth/auth_notifier.dart';
import 'package:prestahub/core/constants/app_constants.dart';
import 'package:prestahub/core/enums/user_role.dart';
import 'package:prestahub/presentation/splash/splash_screen.dart';
import 'package:prestahub/presentation/onboarding/onboarding_screen.dart';

import 'package:prestahub/presentation/auth/login/login_screen.dart';
import 'package:prestahub/presentation/auth/signup/signup_screen.dart';
import 'package:prestahub/presentation/auth/forgot_password/forgot_password_screen.dart';
import 'package:prestahub/presentation/auth/otp_verification/otp_verification_screen.dart';
import 'package:prestahub/presentation/auth/new_password/new_password_screen.dart';
import 'package:prestahub/presentation/home/home_screen.dart';
import 'package:prestahub/presentation/discovery/categories/category_selection_screen.dart';
import 'package:prestahub/presentation/discovery/search/search_results_screen.dart';
import 'package:prestahub/presentation/discovery/provider_detail/provider_detail_screen.dart';
import 'package:prestahub/presentation/provider/home/provider_home_screen.dart';
import 'package:prestahub/presentation/requests/create/request_create_screen.dart';
import 'package:prestahub/presentation/requests/review/request_review_screen.dart';
import 'package:prestahub/presentation/requests/confirmation/request_confirmation_screen.dart';
import 'package:prestahub/presentation/requests/list/request_list_screen.dart';
import 'package:prestahub/presentation/requests/detail/request_detail_screen.dart';
import 'package:prestahub/presentation/requests/detail/mission_detail_screen.dart';
import 'package:prestahub/presentation/requests/history/mission_history_screen.dart';
import 'package:prestahub/presentation/requests/models/service_request_models.dart';
import 'package:prestahub/presentation/messages/list/conversation_list_screen.dart';
import 'package:prestahub/presentation/messages/conversation/conversation_screen.dart';
import 'package:prestahub/presentation/messages/call/call_screen.dart';
import 'package:prestahub/presentation/messages/models/conversation_models.dart';
import 'package:prestahub/presentation/settings/settings_screen.dart';
import 'package:prestahub/presentation/settings/profile/profile_screen.dart';
import 'package:prestahub/presentation/settings/profile/profile_edit_screen.dart';
import 'package:prestahub/presentation/settings/profile/addresses_screen.dart';
import 'package:prestahub/presentation/settings/profile/address_edit_screen.dart';
import 'package:prestahub/presentation/settings/models/address_model.dart';
import 'package:prestahub/presentation/settings/security/security_screen.dart';
import 'package:prestahub/presentation/settings/security/change_password_screen.dart';
import 'package:prestahub/presentation/settings/security/otp_settings_screen.dart';
import 'package:prestahub/presentation/settings/security/connected_devices_screen.dart';
import 'package:prestahub/presentation/settings/preferences/language_screen.dart';
import 'package:prestahub/presentation/settings/preferences/notifications_screen.dart';
import 'package:prestahub/presentation/settings/preferences/theme_screen.dart';
import 'package:prestahub/presentation/settings/preferences/privacy_screen.dart';
import 'package:prestahub/presentation/settings/preferences/geolocation_screen.dart';
import 'package:prestahub/presentation/settings/support/help_screen.dart';
import 'package:prestahub/presentation/settings/support/contact_support_screen.dart';
import 'package:prestahub/presentation/settings/support/report_issue_screen.dart';
import 'package:prestahub/presentation/settings/legal/terms_screen.dart';
import 'package:prestahub/presentation/settings/legal/privacy_policy_screen.dart';
import 'package:prestahub/presentation/settings/legal/legal_mentions_screen.dart';
import 'package:prestahub/presentation/settings/legal/about_screen.dart';
import 'package:prestahub/presentation/reviews/mission_review_screen.dart';
import 'package:prestahub/presentation/reviews/report_review_screen.dart';
import 'package:prestahub/presentation/reviews/models/review_context.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(isAuthenticatedProvider);
  final role = ref.watch(userRoleProvider);

  return GoRouter(
    initialLocation: AppConstants.routeSplash,
    redirect: (context, state) {
      final isAuth = authState;
      final location = state.uri.toString();

      final authRoutes = [
        AppConstants.routeLogin,
        AppConstants.routeRegister,
        AppConstants.routeOnboarding,
        AppConstants.routeOtp,
        AppConstants.routeForgotPassword,
        AppConstants.routeNewPassword,
        AppConstants.routeSplash,
      ];

      if (!isAuth && !authRoutes.contains(location)) {
        return AppConstants.routeLogin;
      }

      if (isAuth && authRoutes.contains(location)) {
        switch (role) {
          case UserRole.client:
            return AppConstants.routeClientHome;
          case UserRole.provider:
            return AppConstants.routeProviderHome;
          case UserRole.admin:
            return AppConstants.routeAdminDashboard;
          case UserRole.unknown:
            return AppConstants.routeLogin;
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppConstants.routeSplash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppConstants.routeOnboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppConstants.routeLogin,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppConstants.routeRegister,
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: AppConstants.routeForgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppConstants.routeOtp,
        builder: (context, state) => const OtpVerificationScreen(),
      ),
      GoRoute(
        path: AppConstants.routeNewPassword,
        builder: (context, state) => const NewPasswordScreen(),
      ),

      // ── Client discovery routes ──────────────────────────────────────────
      GoRoute(
        path: AppConstants.routeClientHome,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppConstants.routeProviderHome,
        builder: (context, state) => const ProviderHomeScreen(),
      ),
      GoRoute(
        path: AppConstants.routeClientCategories,
        builder: (context, state) => const CategorySelectionScreen(),
      ),
      GoRoute(
        path: AppConstants.routeClientSearch,
        builder: (context, state) {
          final query = state.uri.queryParameters['q'];
          final category = state.uri.queryParameters['category'];
          return SearchResultsScreen(
            initialQuery: query,
            category: category,
          );
        },
      ),
      GoRoute(
        path: AppConstants.routeClientProviderDetail,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return ProviderDetailScreen(providerId: id);
        },
      ),

      // ── Client service requests ─────────────────────────────────────────
      GoRoute(
        path: AppConstants.routeClientRequestCreate,
        builder: (context, state) => const RequestCreateScreen(),
      ),
      GoRoute(
        path: AppConstants.routeClientRequestReview,
        builder: (context, state) {
          final draft = state.extra is ServiceRequestDraft
              ? state.extra as ServiceRequestDraft
              : ServiceRequestDraft();
          return RequestReviewScreen(draft: draft);
        },
      ),
      GoRoute(
        path: AppConstants.routeClientRequestConfirmation,
        builder: (context, state) {
          final draft = state.extra is ServiceRequestDraft
              ? state.extra as ServiceRequestDraft
              : null;
          return RequestConfirmationScreen(draft: draft);
        },
      ),
      GoRoute(
        path: AppConstants.routeClientRequests,
        builder: (context, state) => const RequestListScreen(),
      ),
      GoRoute(
        path: AppConstants.routeClientRequestDetail,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return RequestDetailScreen(requestId: id);
        },
      ),
      GoRoute(
        path: AppConstants.routeClientMissionHistory,
        builder: (context, state) => const MissionHistoryScreen(),
      ),
      GoRoute(
        path: AppConstants.routeClientMissionDetail,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return MissionDetailScreen(missionId: id);
        },
      ),

      // ── Client messagerie ───────────────────────────────────────────────
      GoRoute(
        path: AppConstants.routeClientMessages,
        builder: (context, state) => const ConversationListScreen(),
      ),
      GoRoute(
        path: AppConstants.routeClientConversation,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          final extra = state.extra is ConversationSummary
              ? state.extra as ConversationSummary
              : null;
          return ConversationScreen(conversationId: id, initial: extra);
        },
      ),
      GoRoute(
        path: AppConstants.routeClientCall,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          final peer = state.extra is ConversationSummary
              ? state.extra as ConversationSummary
              : null;
          return CallScreen(callId: id, peer: peer);
        },
      ),

      // ── Paramètres (partagés client / prestataire) ──────────────────────
      GoRoute(
        path: AppConstants.routeSettings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppConstants.routeSettingsProfile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: AppConstants.routeSettingsProfileEdit,
        builder: (context, state) => const ProfileEditScreen(),
      ),
      GoRoute(
        path: AppConstants.routeSettingsAddresses,
        builder: (context, state) => const AddressesScreen(),
      ),
      GoRoute(
        path: AppConstants.routeSettingsAddressEdit,
        builder: (context, state) {
          final initial = state.extra is AddressModel
              ? state.extra as AddressModel
              : null;
          return AddressEditScreen(initial: initial);
        },
      ),
      GoRoute(
        path: AppConstants.routeSettingsSecurity,
        builder: (context, state) => const SecurityScreen(),
      ),
      GoRoute(
        path: AppConstants.routeSettingsChangePassword,
        builder: (context, state) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: AppConstants.routeSettingsOtp,
        builder: (context, state) => const OtpSettingsScreen(),
      ),
      GoRoute(
        path: AppConstants.routeSettingsDevices,
        builder: (context, state) => const ConnectedDevicesScreen(),
      ),
      GoRoute(
        path: AppConstants.routeSettingsLanguage,
        builder: (context, state) => const LanguageScreen(),
      ),
      GoRoute(
        path: AppConstants.routeSettingsNotifications,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: AppConstants.routeSettingsTheme,
        builder: (context, state) => const ThemeScreen(),
      ),
      GoRoute(
        path: AppConstants.routeSettingsPrivacy,
        builder: (context, state) => const PrivacyScreen(),
      ),
      GoRoute(
        path: AppConstants.routeSettingsGeolocation,
        builder: (context, state) => const GeolocationScreen(),
      ),
      GoRoute(
        path: AppConstants.routeSettingsHelp,
        builder: (context, state) => const HelpScreen(),
      ),
      GoRoute(
        path: AppConstants.routeSettingsContactSupport,
        builder: (context, state) => const ContactSupportScreen(),
      ),
      GoRoute(
        path: AppConstants.routeSettingsReportIssue,
        builder: (context, state) => const ReportIssueScreen(),
      ),
      GoRoute(
        path: AppConstants.routeSettingsTerms,
        builder: (context, state) => const TermsScreen(),
      ),
      GoRoute(
        path: AppConstants.routeSettingsPrivacyPolicy,
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
      GoRoute(
        path: AppConstants.routeSettingsLegalMentions,
        builder: (context, state) => const LegalMentionsScreen(),
      ),
      GoRoute(
        path: AppConstants.routeSettingsAbout,
        builder: (context, state) => const AboutScreen(),
      ),

      // ── Avis / Notation ─────────────────────────────────────────────────
      GoRoute(
        path: AppConstants.routeClientMissionReview,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          final ctx = state.extra is ReviewMissionContext
              ? state.extra as ReviewMissionContext
              : null;
          return MissionReviewScreen(missionId: id, context: ctx);
        },
      ),
      GoRoute(
        path: AppConstants.routeClientReportReview,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          final ctx = state.extra is ReportReviewContext
              ? state.extra as ReportReviewContext
              : null;
          return ReportReviewScreen(reviewId: id, context: ctx);
        },
      ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page non trouvée: ${state.error}'))),
  );
});
