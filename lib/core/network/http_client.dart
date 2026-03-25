import 'package:dio/dio.dart';
import 'package:prestahub/core/error/exceptions.dart';
import 'package:prestahub/core/network/api_config.dart';
import 'package:prestahub/core/network/interceptors/auth_interceptor.dart';
import 'package:prestahub/core/network/interceptors/cache_interceptor.dart';
import 'package:prestahub/core/network/interceptors/error_interceptor.dart';
import 'package:prestahub/core/network/interceptors/logging_interceptor.dart';
import 'package:prestahub/core/network/interceptors/sync_interceptor.dart';
import 'package:prestahub/data/services/auth_local_service.dart';
import 'package:prestahub/domain/repositories/cache_repository_interface.dart';
import 'package:prestahub/domain/repositories/sync_repository_interface.dart';

/// Client HTTP robuste basé sur Dio.
class HttpClient {
  late final Dio _dio;
  final AuthLocalService _authLocalService;
  final ICacheRepository _cacheRepository;
  final ISyncRepository? _syncRepository;

  HttpClient(
    this._authLocalService,
    this._cacheRepository, {
    ISyncRepository? syncRepository,
    Dio? dio,
  }) : _syncRepository = syncRepository {
    _dio =
        dio ??
        Dio(
          BaseOptions(
            baseUrl: ApiConfig
                .baseUrl, // Utilisation de ApiConfig au lieu de AppConstants
            connectTimeout: ApiConfig.connectTimeout,
            receiveTimeout: ApiConfig.receiveTimeout,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        );

    // Ajout d'intercepteurs seulement si on n'a pas passé un Dio custom
    if (dio == null) {
      _dio.interceptors.addAll([
        AuthInterceptor(_authLocalService),
        CacheInterceptor(_cacheRepository),
        if (_syncRepository != null) SyncInterceptor(_syncRepository),
        LoggingInterceptor(),
        ErrorInterceptor(),
      ]);
    }
  }

  /// Exécute une requête GET.
  ///
  /// [path] : Le chemin relatif de l'endpoint.
  /// [queryParameters] : Les paramètres d'URL optionnels.
  /// [options] : Options de configuration Dio specifiques.
  /// [cancelToken] : Token pour annuler la requête.
  ///
  /// Retourne un [Future<Response>] contenant les données.
  /// Lance une [ServerException] ou [NetworkException] en cas d'erreur.
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(message: 'Une erreur inconnue est survenue: $e');
    }
  }

  /// Exécute une requête POST.
  ///
  /// [path] : Le chemin relatif de l'endpoint.
  /// [data] : Le corps de la requête (Map, FormData, etc.).
  /// [queryParameters] : Les paramètres d'URL optionnels.
  /// [options] : Options de configuration Dio specifiques.
  /// [cancelToken] : Token pour annuler la requête.
  ///
  /// Retourne un [Future<Response>].
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(message: 'Une erreur inconnue est survenue: $e');
    }
  }

  /// Exécute une requête PUT.
  ///
  /// [path] : Le chemin relatif de l'endpoint.
  /// [data] : Le corps de la requête.
  ///
  /// Retourne un [Future<Response>].
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(message: 'Une erreur inconnue est survenue: $e');
    }
  }

  /// Exécute une requête PATCH.
  ///
  /// [path] : Le chemin relatif de l'endpoint.
  /// [data] : Le corps de la requête.
  ///
  /// Retourne un [Future<Response>].
  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(message: 'Une erreur inconnue est survenue: $e');
    }
  }

  /// Exécute une requête DELETE.
  ///
  /// [path] : Le chemin relatif de l'endpoint.
  ///
  /// Retourne un [Future<Response>].
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(message: 'Une erreur inconnue est survenue: $e');
    }
  }

  /// Gère les erreurs Dio et les transforme en ServerException ou NetworkException.
  ///
  /// Cette méthode extrait les messages d'erreur les plus précis possibles,
  /// notamment en gérant les structures de validation complexes (ex: 422).
  Exception _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.connectionError) {
      return NetworkException();
    }

    if (e.response != null) {
      final data = e.response!.data;
      String message = 'Une erreur serveur est survenue';
      String? code;

      if (data is Map<String, dynamic>) {
        // 1. Priorité au message explicite
        if (data['message'] != null) {
          message = data['message'];
        }
        // 2. Erreur simple
        else if (data['error'] != null) {
          message = data['error'].toString();
        }
        // 3. Gestion des erreurs de validation (ex: API Laravel, NestJS, etc.)
        else if (data['errors'] != null) {
          final errors = data['errors'];
          if (errors is Map) {
            // Agréger tous les messages d'erreur de validation
            final List<String> errorMessages = [];
            errors.forEach((key, value) {
              if (value is List) {
                errorMessages.addAll(value.map((e) => e.toString()));
              } else {
                errorMessages.add(value.toString());
              }
            });
            if (errorMessages.isNotEmpty) {
              message = errorMessages.join('\n');
            }
          } else if (errors is List) {
            message = errors.join('\n');
          }
        }
        code = data['code']?.toString();
      }

      return ServerException(
        message: message,
        code: code,
        statusCode: e.response!.statusCode,
      );
    }

    return ServerException(message: e.message ?? 'Erreur inconnue');
  }
}
