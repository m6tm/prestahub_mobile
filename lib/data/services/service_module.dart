import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prestahub/data/services/auth_local_service.dart';
import 'package:prestahub/domain/repositories/cache_repository_interface.dart';

/// Provider pour SharedPreferences (doit être initialisé avant l'utilisation).
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences non initialisé');
});

/// Provider pour AuthLocalService.
final authLocalServiceProvider = Provider<AuthLocalService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return AuthLocalService(prefs);
});

/// Provider pour ICacheRepository (doit être initialisé avant utilisation).
final cacheServiceProvider = Provider<ICacheRepository>((ref) {
  throw UnimplementedError('Service de cache non initialisé');
});
