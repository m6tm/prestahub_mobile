import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:prestahub/domain/entities/sync_request.dart';
import 'package:prestahub/domain/repositories/sync_repository_interface.dart';

/// Implémentation Hive du repository de synchronisation.
/// Gère le stockage persistant de la file d'attente des requêtes hors ligne.
class HiveSyncRepository implements ISyncRepository {
  static const String _boxName = 'sync_queue_box';
  Box<Map>? _box;

  /// Initialise la boîte Hive pour la synchronisation avec chiffrement.
  Future<void> init() async {
    if (Hive.isBoxOpen(_boxName)) {
      _box = Hive.box<Map>(_boxName);
      return;
    }

    const secureStorage = FlutterSecureStorage();
    const secureKeyName = 'hive_encryption_key';

    // 1. Lire ou générer la clé sécurisée de 256 bits
    final containsEncryptionKey = await secureStorage.containsKey(
      key: secureKeyName,
    );

    if (!containsEncryptionKey) {
      final key = Hive.generateSecureKey();
      await secureStorage.write(
        key: secureKeyName,
        value: base64UrlEncode(key),
      );
    }

    final encryptionKeyString = await secureStorage.read(key: secureKeyName);
    if (encryptionKeyString == null) {
      throw Exception(
        'Impossible de récupérer la clé de chiffrement pour la synchronisation.',
      );
    }

    final encryptionKeyUint8List = base64Url.decode(encryptionKeyString);

    // 2. Ouvrir la boîte Hive avec chiffrement AES
    _box = await Hive.openBox<Map>(
      _boxName,
      encryptionCipher: HiveAesCipher(encryptionKeyUint8List),
    );
  }

  @override
  Future<void> addSyncRequest(SyncRequest request) async {
    await _ensureInitialized();
    await _box?.put(request.id, request.toJson());
  }

  @override
  Future<List<SyncRequest>> getSyncRequests() async {
    await _ensureInitialized();
    final List<SyncRequest> requests =
        _box?.values
            .map((e) => SyncRequest.fromJson(Map<String, dynamic>.from(e)))
            .toList() ??
        [];

    // Trier par priorité (plus petit d'abord) puis par date de création
    requests.sort((a, b) {
      final priorityComparison = a.priority.compareTo(b.priority);
      if (priorityComparison != 0) return priorityComparison;
      return a.createdAt.compareTo(b.createdAt);
    });

    return requests;
  }

  @override
  Future<void> removeSyncRequest(String id) async {
    await _ensureInitialized();
    await _box?.delete(id);
  }

  @override
  Future<void> clearAll() async {
    await _ensureInitialized();
    await _box?.clear();
  }

  @override
  Future<void> updateAttempts(String id, int attempts) async {
    await _ensureInitialized();
    final data = _box?.get(id);
    if (data != null) {
      final request = SyncRequest.fromJson(Map<String, dynamic>.from(data));
      final updatedRequest = request.copyWith(attempts: attempts);
      await _box?.put(id, updatedRequest.toJson());
    }
  }

  /// S'assure que la boîte Hive est bien ouverte avant toute opération.
  Future<void> _ensureInitialized() async {
    if (_box == null || !_box!.isOpen) {
      await init();
    }
  }
}
