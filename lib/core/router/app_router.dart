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
        AppConstants.routeForgotPassword,
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
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page non trouvée: ${state.error}'))),
  );
});
