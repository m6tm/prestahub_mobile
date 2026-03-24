import 'package:prestahub/domain/entities/sync_request.dart';

/// Interface pour la gestion du stockage local des requêtes à synchroniser.
/// Cette interface suit les principes de l'architecture hexagonale en isolant
/// la logique métier (domain) des détails de stockage (data).
abstract class ISyncRepository {
  /// Ajoute une requête à la file de synchronisation.
  Future<void> addSyncRequest(SyncRequest request);

  /// Récupère toutes les requêtes en attente de synchronisation.
  Future<List<SyncRequest>> getSyncRequests();

  /// Supprime une requête de la file par son ID unique.
  Future<void> removeSyncRequest(String id);

  /// Efface toutes les requêtes de synchronisation.
  Future<void> clearAll();

  /// Met à jour le nombre de tentatives pour une requête.
  Future<void> updateAttempts(String id, int attempts);
}
