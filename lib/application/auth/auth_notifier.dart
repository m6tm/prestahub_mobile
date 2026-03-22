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
final authNotifierProvider =
    AsyncNotifierProvider<AuthNotifier, UserModel?>(() => AuthNotifier());

final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(authNotifierProvider).valueOrNull;
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(currentUserProvider) != null;
});

final userRoleProvider = Provider<UserRole>((ref) {
  return ref.watch(currentUserProvider)?.role ?? UserRole.unknown;
});
