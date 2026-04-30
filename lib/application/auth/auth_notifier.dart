import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prestahub/data/repositories/auth_repository.dart';
import 'package:prestahub/domain/models/user_model.dart';
import 'package:prestahub/domain/repositories/auth_repository_interface.dart';
import 'package:prestahub/core/enums/user_role.dart';

/// Notifier pour gérer l'état de l'authentification de l'utilisateur.
class AuthNotifier extends AsyncNotifier<UserModel?> {
  @override
  Future<UserModel?> build() async {
    final IAuthRepository repo = ref.watch(authRepositoryProvider);
    final result = await repo.getCurrentUserProfile();

    return result.fold(
      (failure) => null, // Ou gérer l'erreur autrement
      (user) => user,
    );
  }

  /// Connecte un utilisateur.
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    final IAuthRepository repo = ref.read(authRepositoryProvider);

    final result = await repo.signInWithEmail(email: email, password: password);

    state = result.fold(
      (failure) => AsyncValue.error(failure.message, StackTrace.current),
      (user) => AsyncValue.data(user),
    );
  }

  /// Inscrit un utilisateur.
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required UserRole role,
    String? phone,
    String? firstName,
    String? lastName,
  }) async {
    state = const AsyncLoading();
    final IAuthRepository repo = ref.read(authRepositoryProvider);

    final result = await repo.signUpWithEmail(
      email: email,
      password: password,
      role: role.value,
      phone: phone,
      firstName: firstName,
      lastName: lastName,
    );

    state = result.fold(
      (failure) => AsyncValue.error(failure.message, StackTrace.current),
      (user) => AsyncValue.data(user),
    );
  }

  /// Connexion fictive pour les démonstrations.
  /// Identifiants acceptés :
  ///   client@prestahub.com  / demo1234  → rôle client
  ///   prestataire@prestahub.com / demo1234  → rôle provider
  Future<String?> mockSignIn({
    required String email,
    required String password,
  }) async {
    const clientEmail = 'client@prestahub.com';
    const providerEmail = 'prestataire@prestahub.com';
    const demoPassword = 'demo1234';

    final emailTrimmed = email.trim().toLowerCase();

    if (password != demoPassword) return 'Mot de passe incorrect.';

    late UserModel mock;
    if (emailTrimmed == clientEmail) {
      mock = UserModel(
        id: 'demo-client-001',
        email: clientEmail,
        firstName: 'Alice',
        lastName: 'Martin',
        role: UserRole.client,
        isVerified: true,
        createdAt: DateTime(2024),
      );
    } else if (emailTrimmed == providerEmail) {
      mock = UserModel(
        id: 'demo-provider-001',
        email: providerEmail,
        firstName: 'Jean',
        lastName: 'Dupont',
        role: UserRole.provider,
        isVerified: true,
        createdAt: DateTime(2024),
      );
    } else {
      return 'Identifiant inconnu. Utilisez un compte démo.';
    }

    state = AsyncValue.data(mock);
    return null; // null = succès
  }

  /// Déconnecte l'utilisateur actuel.
  Future<void> signOut() async {
    state = const AsyncLoading();
    final IAuthRepository repo = ref.read(authRepositoryProvider);

    final result = await repo.signOut();

    state = result.fold(
      (failure) => AsyncValue.error(failure.message, StackTrace.current),
      (_) => const AsyncValue.data(null),
    );
  }
}

/// Providers
final authNotifierProvider = AsyncNotifierProvider<AuthNotifier, UserModel?>(
  () => AuthNotifier(),
);

final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(authNotifierProvider).valueOrNull;
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(currentUserProvider) != null;
});

final userRoleProvider = Provider<UserRole>((ref) {
  return ref.watch(currentUserProvider)?.role ?? UserRole.unknown;
});
