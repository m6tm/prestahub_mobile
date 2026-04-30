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
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page non trouvée: ${state.error}'))),
  );
});
