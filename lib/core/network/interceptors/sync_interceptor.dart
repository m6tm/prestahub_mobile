import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:prestahub/domain/entities/sync_request.dart';
import 'package:prestahub/domain/repositories/sync_repository_interface.dart';
import 'package:uuid/uuid.dart';

/// Intercepteur Dio qui capture les échecs réseau et les met en file d'attente.
/// Cible uniquement les méthodes de type modification (POST, PUT, DELETE, PATCH).
class SyncInterceptor extends Interceptor {
  final ISyncRepository _syncRepository;
  final Logger _logger = Logger();
  final Uuid _uuid = const Uuid();

  SyncInterceptor(this._syncRepository);

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Si c'est une erreur de connexion/réseau
    if (_isNetworkError(err)) {
      final method = err.requestOptions.method.toUpperCase();

      // On ne synchronise QUE les modifications (POST, PUT, PATCH, DELETE)
      // On évite les GET qui sont de la simple lecture.
      if (['POST', 'PUT', 'PATCH', 'DELETE'].contains(method)) {
        // On vérifie si la requête n'est pas déjà un rejeu (pour éviter les boucles)
        if (err.requestOptions.headers.containsKey('X-Offline-Sync-Replay')) {
          return handler.next(err);
        }

        _logger.w(
          "SyncInterceptor: Échec réseau détecté pour ${err.requestOptions.path}. Mise en file d'attente.",
        );

        try {
          final syncReq = SyncRequest(
            id: _uuid.v4(),
            path: err.requestOptions.path,
            method: method,
            data: err.requestOptions.data is Map<String, dynamic>
                ? Map<String, dynamic>.from(err.requestOptions.data)
                : null,
            queryParameters: Map<String, dynamic>.from(
              err.requestOptions.queryParameters,
            ),
            headers: Map<String, dynamic>.from(err.requestOptions.headers),
            createdAt: DateTime.now(),
            priority: _calculatePriority(err.requestOptions.path),
          );

          await _syncRepository.addSyncRequest(syncReq);

          // On peut retourner une réponse "fictive" ou laisser l'erreur remonter
          // Ici on laisse l'erreur remonter mais marquée différemment si besoin
          // ou on simule un succès 202 accepted ?
          // Dans une architecture robuste, on laisse l'UI gérer le fait que c'est "En cours/Offline".
        } catch (e) {
          _logger.e(
            "SyncInterceptor: Erreur lors de l'ajout à la file de synchro: $e",
          );
        }
      }
    }

    return handler.next(err);
  }

  /// Détermine si l'erreur Dio est liée à la connectivité.
  bool _isNetworkError(DioException err) {
    return err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout;
  }

  /// Calcule la priorité selon l'endpoint (optionnel).
  int _calculatePriority(String path) {
    if (path.contains('/critical')) return 10;
    if (path.contains('/auth/')) return 50;
    return 100;
  }
}
