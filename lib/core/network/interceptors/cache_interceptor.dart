import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:prestahub/domain/repositories/cache_repository_interface.dart';

/// Intercepteur pour gérer la mise en cache des requêtes GET (Mode hors-ligne).
class CacheInterceptor extends Interceptor {
  final ICacheRepository _cacheRepository;
  final Duration cacheDuration; // Temps de validité par défaut du cache
  final Logger _logger = Logger(printer: PrettyPrinter(printEmojis: false));

  CacheInterceptor(this._cacheRepository, {this.cacheDuration = const Duration(days: 7)});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // On ne cache rien si ce n'est pas une requête GET
    if (options.method.toUpperCase() != 'GET') {
      return handler.next(options);
    }

    final forceRefresh = options.extra['forceRefresh'] == true;
    
    if (forceRefresh) {
      return handler.next(options);
    }

    // Dans une stratégie Cache-First, on renverrait les données ici
    // Mais pour une stratégie Network-First avec repli hors-ligne, on continue
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    // On met en cache uniquement le succès (200-299) des requêtes GET
    if (response.requestOptions.method.toUpperCase() == 'GET' && 
        response.statusCode != null && 
        response.statusCode! >= 200 && 
        response.statusCode! < 300) {
      
      final key = _generateKey(response.requestOptions);
      
      try {
        await _cacheRepository.set(
          key, 
          response.data, 
          expiration: cacheDuration,
        );
      } catch (e, stackTrace) {
        _logger.e('Échec de la sauvegarde dans le cache pour la clé: $key', error: e, stackTrace: stackTrace);
      }
    }
    
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final isNetworkError = err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.unknown;
        
    // Si erreur réseau sur une requête GET, on tente de récupérer le cache
    if (isNetworkError && err.requestOptions.method.toUpperCase() == 'GET') {
      final key = _generateKey(err.requestOptions);
      final cacheData = await _cacheRepository.get(key);
      
      if (cacheData != null) {
        // Succès depuis le cache, on évite l'erreur
        return handler.resolve(
          Response(
            requestOptions: err.requestOptions,
            data: cacheData,
            statusCode: 200,
            statusMessage: 'OK (Depuis le cache local)',
          ),
        );
      }
    }
    
    return handler.next(err);
  }

  /// Génère une clé unique combinant l'URL complète et les paramètres.
  /// Utilise un hachage SHA-256 pour garantir une longueur fixe et
  /// l'indépendance vis-à-vis de l'ordre des paramètres.
  String _generateKey(RequestOptions options) {
    // 1. Construire l'URL de base
    final url = '${options.baseUrl}${options.path}';

    // 2. Trier les queryParameters
    final sortedParams = options.queryParameters.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    // 3. Créer une chaîne canonique
    final queryString = sortedParams.map((e) => '${e.key}=${e.value}').join('&');
    final canonicalString = queryString.isEmpty ? url : '$url?$queryString';

    // 4. Hacher la chaîne (SHA-256)
    final bytes = utf8.encode(canonicalString);
    final digest = sha256.convert(bytes);

    return digest.toString();
  }
}
