import 'package:equatable/equatable.dart';

/// Classe de base pour toutes les erreurs métier.
abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure(this.message, {this.code});

  @override
  List<Object?> get props => [message, code];
}

/// Erreur lors d'une requête HTTP.
class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.code});
}

/// Erreur de connexion internet.
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// Erreur lors de l'authentification.
class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

/// Erreur inattendue interne.
class InternalFailure extends Failure {
  const InternalFailure(super.message);
}

/// Erreur de validation de formulaire ou de données.
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}
