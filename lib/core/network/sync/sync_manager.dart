import 'dart:async';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:prestahub/domain/entities/sync_request.dart';
import 'package:prestahub/core/services/connectivity_service.dart';
import 'package:prestahub/core/services/notification_service.dart';
import 'package:prestahub/domain/repositories/sync_repository_interface.dart';

/// Orchestrateur robuste pour la synchronisation des requêtes hors ligne.
/// Écoute le changement d'état du réseau et rejoue automatiquement les requêtes en file d'attente.
class SyncManager {
  final ISyncRepository _syncRepository;
  final ConnectivityService _connectivityService;
  final INotificationService _notificationService;
  final Dio
  _syncDio; // On utilise un Dio spécifique pour éviter les boucles infinies d'interception
  final Logger _logger = Logger();

  bool _isSyncing = false;
  StreamSubscription<ConnectionStatus>? _subscription;

  static const int maxAttempts = 5;

  SyncManager(
    this._syncRepository,
    this._connectivityService,
    this._syncDio,
    this._notificationService,
  ) {
    _init();
  }

  /// Initialise l'écouteur de connectivité pour déclencher la synchronisation dès que possible.
  void _init() {
    _subscription = _connectivityService.connectionStream.listen((status) {
      if (status == ConnectionStatus.online) {
        syncNow();
      }
    });

    // Tentative de synchro initiale si on est déjà en ligne
    syncNow();
  }

  /// Déclenche manuellement ou automatiquement la synchronisation.
  Future<void> syncNow() async {
    if (_isSyncing) return;

    final isOnline = await _connectivityService.isConnected();
    if (!isOnline) {
      _logger.i('SyncManager: Toujours hors ligne, synchronisation reportée.');
      return;
    }

    _isSyncing = true;
    _logger.i('SyncManager: Début de la synchronisation des requêtes...');

    try {
      final requests = await _syncRepository.getSyncRequests();

      if (requests.isEmpty) {
        _logger.i('SyncManager: Aucune requête en attente.');
        _isSyncing = false;
        return;
      }

      for (final request in requests) {
        final success = await _replayRequest(request);
        if (success) {
          await _syncRepository.removeSyncRequest(request.id);
          _logger.i(
            'SyncManager: Requête ${request.id} synchronisée avec succès.',
          );
        } else {
          final updatedAttempts = request.attempts + 1;
          if (updatedAttempts >= maxAttempts) {
            // Trop d'échecs, on peut soit supprimer, soit notifier l'utilisateur
            // Ici on choisit de supprimer pour éviter de bloquer la file indéfiniment
            await _syncRepository.removeSyncRequest(request.id);
            _logger.e(
              "SyncManager: Trop d'échecs pour ${request.id}, supprimée de la file.",
            );
            _notificationService.showError(
              "La synchronisation de l'opération ${request.method} ${request.path} a échoué définitivement.",
            );
          } else {
            await _syncRepository.updateAttempts(request.id, updatedAttempts);
          }
        }
      }
    } catch (e) {
      _logger.e('SyncManager: Erreur pendant la synchronisation : $e');
    } finally {
      _isSyncing = false;
      _logger.i('SyncManager: Fin de la synchronisation.');
    }
  }

  /// Rejoue une requête HTTP spécifique.
  Future<bool> _replayRequest(SyncRequest request) async {
    try {
      _logger.d('SyncManager: Rejoue ${request.method} ${request.path}');

      // Filtrage des headers critiques qui pourraient entrer en conflit avec Dio
      final filteredHeaders = Map<String, dynamic>.from(request.headers ?? {});
      filteredHeaders.removeWhere((key, value) {
        final k = key.toLowerCase();
        return k == 'content-type' || k == 'content-length' || k == 'host';
      });

      final options = Options(
        method: request.method,
        headers: {
          ...filteredHeaders,
          'X-Offline-Sync-Replay':
              'true', // Header utile pour le backend si besoin
        },
      );

      final response = await _syncDio.request(
        request.path,
        data: request.data,
        queryParameters: request.queryParameters,
        options: options,
      );

      return response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300;
    } on DioException catch (e) {
      _logger.w(
        'SyncManager: Échec du rejeu pour ${request.id} : ${e.message}',
      );

      // Si c'est une erreur de validation (400-499), on ne réessaie pas car la requête est probablement invalide
      if (e.response != null && e.response!.statusCode != null) {
        if (e.response!.statusCode! >= 400 && e.response!.statusCode! < 500) {
          return false; // On ne réessaiera pas
        }
      }
      return false; // Erreur serveur (500) ou réseau (encore), on réessaiera
    } catch (e) {
      _logger.e('SyncManager: Erreur inconnue lors du rejeu : $e');
      return false;
    }
  }

  /// Dispose des ressources.
  void dispose() {
    _subscription?.cancel();
  }
}
