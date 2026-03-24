import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:prestahub/domain/repositories/cache_repository_interface.dart';

/// Implémentation du service de cache hors ligne à l'aide de Hive.
class HiveCacheService implements ICacheRepository {
  static const String _boxName = 'prestahub_cache_box';
  Box<dynamic>? _box;

  @override
  Future<void> init() async {
    await Hive.initFlutter();

    const secureStorage = FlutterSecureStorage();
    const secureKeyName = 'hive_encryption_key';

    // 1. Lire ou générer la clé sécurisée de 256 bits
    final containsEncryptionKey = await secureStorage.containsKey(key: secureKeyName);
    
    if (!containsEncryptionKey) {
      final key = Hive.generateSecureKey();
      await secureStorage.write(
        key: secureKeyName,
        value: base64UrlEncode(key),
      );
    }

    final encryptionKeyString = await secureStorage.read(key: secureKeyName);
    if (encryptionKeyString == null) {
      throw Exception('Impossible de récupérer la clé de chiffrement du cache.');
    }
    
    final encryptionKeyUint8List = base64Url.decode(encryptionKeyString);

    // 2. Ouvrir la boîte Hive avec chiffrement AES
    _box = await Hive.openBox<dynamic>(
      _boxName,
      encryptionCipher: HiveAesCipher(encryptionKeyUint8List),
    );
  }

  @override
  Future<void> set(String key, dynamic value, {Duration? expiration}) async {
    final expiresAt = expiration != null 
        ? DateTime.now().add(expiration).millisecondsSinceEpoch 
        : null;
        
    final Map<String, dynamic> wrapper = {
      'value': value,
      'expires_at': expiresAt,
    };
    
    await _box?.put(key, wrapper);
  }

  @override
  Future<dynamic> get(String key) async {
    final data = _box?.get(key);
    
    // Si la donnée n'est pas trouvée ou n'est pas un Map
    if (data == null || data is! Map) return null;

    final expiresAt = data['expires_at'] as int?;
    
    // Vérification de l'expiration
    // Si le timestamp actuel dépasse le temps d'expiration, le cache est invalide.
    if (expiresAt != null) {
      final now = DateTime.now().millisecondsSinceEpoch;
      if (now > expiresAt) {
        await remove(key);
        return null;
      }
    }

    return data['value'];
  }

  @override
  Future<bool> containsKey(String key) async {
    final value = await get(key);
    return value != null;
  }

  @override
  Future<void> remove(String key) async {
    await _box?.delete(key);
  }

  @override
  Future<void> clear() async {
    await _box?.clear();
  }
}
