import 'package:dartz/dartz.dart';
import 'package:prestahub/core/error/failures.dart';
import 'package:prestahub/domain/models/user_model.dart';

/// Interface abstraite définissant le contrat pour l'authentification.
/// Suivant les principes de l'architecture hexagonale.
abstract class IAuthRepository {
  /// Authentifie un utilisateur avec son email et mot de passe.
  Future<Either<Failure, UserModel>> signInWithEmail({
    required String email,
    required String password,
  });

  /// Inscrit un nouvel utilisateur.
  Future<Either<Failure, UserModel>> signUpWithEmail({
    required String email,
    required String password,
    required String role,
    String? phone,
    String? firstName,
    String? lastName,
  });

  /// Déconnecte l'utilisateur actuel.
  Future<Either<Failure, void>> signOut();

  /// Récupère le profil de l'utilisateur actuel.
  Future<Either<Failure, UserModel?>> getCurrentUserProfile();

  /// Demande une réinitialisation de mot de passe.
  Future<Either<Failure, void>> resetPasswordForEmail(String email);

  /// Rafraîchit le jeton d'accès actuel en utilisant un jeton de rafraîchissement.
  /// Si le rafraîchissement échoue, l'utilisateur devra se reconnecter.
  Future<Either<Failure, String>> refreshToken();
}
