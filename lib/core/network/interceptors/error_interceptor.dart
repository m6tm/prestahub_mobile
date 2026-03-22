import 'package:dio/dio.dart';

/// Intercepteur d'erreur pour Dio (peut être utilisé pour transformer ou loguer des erreurs spécifiques).
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Logique optionnelle ici avant de passer l'erreur à DIO.
    super.onError(err, handler);
  }
}
