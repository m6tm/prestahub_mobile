import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:prestahub/data/repositories/auth_repository.dart';
import 'package:prestahub/domain/models/user_model.dart';
import 'package:prestahub/core/enums/user_role.dart';

// Auth State Notifier
class AuthNotifier extends AsyncNotifier<UserModel?> {
  @override
  Future<UserModel?> build() async {
    final repo = ref.watch(authRepositoryProvider);

    // Listen to auth changes
    ref.listen(authStateChangesProvider, (_, next) async {
      next.whenData((event) async {
        if (event.event == AuthChangeEvent.signedIn) {
          state = const AsyncLoading();
          state = await AsyncValue.guard(() => repo.getCurrentUserProfile());
        } else if (event.event == AuthChangeEvent.signedOut) {
          state = const AsyncData(null);
        }
      });
    });

    return repo.getCurrentUserProfile();
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    final repo = ref.read(authRepositoryProvider);
    state = await AsyncValue.guard(() async {
      await repo.signInWithEmail(email: email, password: password);
      return repo.getCurrentUserProfile();
    });
  }

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required UserRole role,
    String? phone,
    String? firstName,
    String? lastName,
  }) async {
    state = const AsyncLoading();
    final repo = ref.read(authRepositoryProvider);
    state = await AsyncValue.guard(() async {
      await repo.signUpWithEmail(
        email: email,
        password: password,
        role: role.value,
        phone: phone,
        firstName: firstName,
        lastName: lastName,
      );
      return repo.getCurrentUserProfile();
    });
  }

  Future<void> signOut() async {
    final repo = ref.read(authRepositoryProvider);
    await repo.signOut();
    state = const AsyncData(null);
  }
}

// Providers
final authNotifierProvider =
    AsyncNotifierProvider<AuthNotifier, UserModel?>(() => AuthNotifier());

final authStateChangesProvider = StreamProvider<AuthState>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(authNotifierProvider).valueOrNull;
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(currentUserProvider) != null;
});

final userRoleProvider = Provider<UserRole>((ref) {
  return ref.watch(currentUserProvider)?.role ?? UserRole.unknown;
});
