/// Exception levée lors d'une erreur serveur (API).
class ServerException implements Exception {
  final String message;
  final String? code;
  final int? statusCode;

  ServerException({required this.message, this.code, this.statusCode});

  @override
  String toString() =>
      'ServerException: $message (code: $code, status: $statusCode)';
}

/// Exception levée lors d'une erreur locale (Storage, File, etc).
class LocalException implements Exception {
  final String message;

  LocalException({required this.message});

  @override
  String toString() => 'LocalException: $message';
}

/// Exception levée lors d'une erreur d'auth.
class AuthException implements Exception {
  final String message;

  AuthException({required this.message});

  @override
  String toString() => 'AuthException: $message';
}

/// Exception levée quand on n'a pas internet.
class NetworkException implements Exception {
  final String message;

  NetworkException({this.message = 'Pas de connexion internet'});

  @override
  String toString() => 'NetworkException: $message';
}
