import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prestahub/core/network/api_config.dart';
import 'package:prestahub/core/network/http_client.dart';
import 'package:prestahub/core/network/interceptors/auth_interceptor.dart';
import 'package:prestahub/core/network/sync/sync_manager.dart';
import 'package:prestahub/data/services/service_module.dart';

/// Provider pour une instance de Dio dédiée à la synchronisation.
/// Elle inclut l'authentification mais pas l'intercepteur de synchro pour éviter les boucles.
final syncDioProvider = Provider<Dio>((ref) {
  final authLocalService = ref.watch(authLocalServiceProvider);
  
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: ApiConfig.connectTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
    ),
  );

  dio.interceptors.add(AuthInterceptor(authLocalService));
  
  return dio;
});

/// Provider pour le SyncManager.
final syncManagerProvider = Provider<SyncManager>((ref) {
  final syncRepository = ref.watch(syncRepositoryProvider);
  final connectivityService = ref.watch(connectivityServiceProvider);
  final syncDio = ref.watch(syncDioProvider);
  final notificationService = ref.watch(notificationServiceProvider);
  
  return SyncManager(syncRepository, connectivityService, syncDio, notificationService);
});

/// Provider pour le client HTTP principal.
final httpClientProvider = Provider<HttpClient>((ref) {
  final authLocalService = ref.watch(authLocalServiceProvider);
  final cacheRepository = ref.watch(cacheServiceProvider);
  final syncRepository = ref.watch(syncRepositoryProvider);
  
  // On s'assure que le SyncManager est initialisé
  ref.read(syncManagerProvider);
  
  return HttpClient(
    authLocalService, 
    cacheRepository, 
    syncRepository: syncRepository,
  );
});
