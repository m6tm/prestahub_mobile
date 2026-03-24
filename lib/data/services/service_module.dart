import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prestahub/core/services/notification_service.dart';
import 'package:prestahub/core/services/connectivity_service.dart';
import 'package:prestahub/data/repositories/hive_sync_repository.dart';
import 'package:prestahub/data/services/auth_local_service.dart';
import 'package:prestahub/domain/repositories/cache_repository_interface.dart';
import 'package:prestahub/domain/repositories/sync_repository_interface.dart';

/// Provider pour SharedPreferences.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences non initialisé');
});

/// Provider pour AuthLocalService.
final authLocalServiceProvider = Provider<AuthLocalService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return AuthLocalService(prefs);
});

/// Provider pour ICacheRepository.
final cacheServiceProvider = Provider<ICacheRepository>((ref) {
  throw UnimplementedError('Service de cache non initialisé');
});

/// Provider pour ISyncRepository.
final syncRepositoryProvider = Provider<ISyncRepository>((ref) {
  return HiveSyncRepository();
});

/// Provider pour ConnectivityService.
final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  final service = ConnectivityService();
  ref.onDispose(() => service.dispose());
  return service;
});

/// Provider pour INotificationService.
final notificationServiceProvider = Provider<INotificationService>((ref) {
  return LoggerNotificationService();
});
