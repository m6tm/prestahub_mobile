abstract class ICacheRepository {
  /// Initialise le service de cache (ex: ouverture des boîtes Hive).
  Future<void> init();

  /// Sauvegarde une valeur [value] associée à une [key] dans le cache.
  /// Optionnellement, définit une durée de validité [expiration].
  Future<void> set(String key, dynamic value, {Duration? expiration});

  /// Récupère la valeur associée à la [key].
  /// Retourne `null` si la clé n'existe pas ou si la donnée a expiré.
  Future<dynamic> get(String key);

  /// Vérifie si une [key] existe dans le cache et est toujours valide.
  Future<bool> containsKey(String key);

  /// Supprime la donnée associée à la [key].
  Future<void> remove(String key);

  /// Vide entièrement le cache.
  Future<void> clear();
}
