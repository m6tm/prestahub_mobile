import 'package:dio/dio.dart';
import 'package:prestahub/data/services/auth_local_service.dart';

/// Intercepteur pour injecter automatiquement le jeton JWT dans les headers.
class AuthInterceptor extends Interceptor {
  final AuthLocalService _authLocalService;

  AuthInterceptor(this._authLocalService);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Récupérer le jeton depuis le stockage local
    final token = _authLocalService.getToken();

    // Si un jeton est présent, l'ajouter au header d'autorisation
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Si l'erreur est un 401 (Non autorisé) et qu'on n'est pas déjà sur un endpoint d'auth
    if (err.response?.statusCode == 401 && 
        !err.requestOptions.path.contains('/auth/')) {
      
      final String? refreshToken = _authLocalService.getRefreshToken();

      if (refreshToken != null && refreshToken.isNotEmpty) {
        try {
          // On tente de rafraîchir le jeton via un client Dio "propre" pour éviter les boucles
          final dio = Dio(BaseOptions(baseUrl: err.requestOptions.baseUrl));
          
          final response = await dio.post(
            '/auth/refresh-token',
            data: {'refresh_token': refreshToken},
          );

          if (response.statusCode == 200 || response.statusCode == 201) {
            final newToken = response.data['token'] as String?;
            final newRefreshToken = response.data['refresh_token'] as String?;

            if (newToken != null) {
              await _authLocalService.saveToken(newToken);
            }
            if (newRefreshToken != null) {
              await _authLocalService.saveRefreshToken(newRefreshToken);
            }

            // Mettre à jour le header de la requête originale
            err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
            
            // Relancer la requête originale
            final opts = Options(
              method: err.requestOptions.method,
              headers: err.requestOptions.headers,
            );
            
            final retryResponse = await dio.request(
              err.requestOptions.path,
              data: err.requestOptions.data,
              queryParameters: err.requestOptions.queryParameters,
              options: opts,
            );

            return handler.resolve(retryResponse);
          }
        } catch (e) {
          // En cas d'échec critique du refresh, on vide tout
          await _authLocalService.clearTokens();
        }
      }
    }
    super.onError(err, handler);
  }
}
