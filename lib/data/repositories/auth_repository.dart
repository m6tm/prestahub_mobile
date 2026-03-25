import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prestahub/core/error/failures.dart';
import 'package:prestahub/core/network/api_endpoints.dart';
import 'package:prestahub/core/network/http_client.dart';
import 'package:prestahub/core/network/network_module.dart';
import 'package:prestahub/data/services/auth_local_service.dart';
import 'package:prestahub/data/services/service_module.dart';
import 'package:prestahub/domain/models/user_model.dart';
import 'package:prestahub/domain/repositories/auth_repository_interface.dart';

/// Implémentation de IAuthRepository utilisant HttpClient.
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return AuthRepository(
    ref.watch(httpClientProvider),
    ref.watch(authLocalServiceProvider),
  );
});

class AuthRepository implements IAuthRepository {
  final HttpClient _client;
  final AuthLocalService _authLocalService;

  AuthRepository(this._client, this._authLocalService);

  /// Authentifie un utilisateur avec son email et mot de passe.
  @override
  Future<Either<Failure, UserModel>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );

      final user = UserModel.fromMap(response.data['user']);
      final token = response.data['token'];
      final refreshToken = response.data['refresh_token'];

      if (token != null) {
        await _authLocalService.saveToken(token);
      }
      if (refreshToken != null) {
        await _authLocalService.saveRefreshToken(refreshToken);
      }
      return Right(user);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Inscrit un nouvel utilisateur.
  @override
  Future<Either<Failure, UserModel>> signUpWithEmail({
    required String email,
    required String password,
    required String role,
    String? phone,
    String? firstName,
    String? lastName,
  }) async {
    try {
      final response = await _client.post(
        ApiEndpoints.register,
        data: {
          'email': email,
          'password': password,
          'role': role,
          'phone': phone,
          'first_name': firstName,
          'last_name': lastName,
        },
      );

      final user = UserModel.fromMap(response.data['user']);
      final token = response.data['token'];
      final refreshToken = response.data['refresh_token'];

      if (token != null) {
        await _authLocalService.saveToken(token);
      }
      if (refreshToken != null) {
        await _authLocalService.saveRefreshToken(refreshToken);
      }
      return Right(user);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Déconnecte l'utilisateur actuel.
  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _client.post(ApiEndpoints.logout);
      await _authLocalService.clearTokens();
      return const Right(null);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Récupère le profil de l'utilisateur actuel.
  @override
  Future<Either<Failure, UserModel?>> getCurrentUserProfile() async {
    try {
      final response = await _client.get(ApiEndpoints.me);
      if (response.data == null) return const Right(null);

      final user = UserModel.fromMap(response.data['user']);
      return Right(user);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Demande une réinitialisation de mot de passe.
  @override
  Future<Either<Failure, void>> resetPasswordForEmail(String email) async {
    try {
      await _client.post(ApiEndpoints.resetPassword, data: {'email': email});
      return const Right(null);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Rafraîchit le jeton d'accès actuel.
  @override
  Future<Either<Failure, String>> refreshToken() async {
    try {
      final oldRefreshToken = _authLocalService.getRefreshToken();
      if (oldRefreshToken == null) {
        return const Left(AuthFailure('No refresh token available'));
      }

      final response = await _client.post(
        ApiEndpoints.refreshToken,
        data: {'refresh_token': oldRefreshToken},
      );

      final newToken = response.data['token'];
      final newRefreshToken = response.data['refresh_token'];

      if (newToken != null) {
        await _authLocalService.saveToken(newToken);
      }
      if (newRefreshToken != null) {
        await _authLocalService.saveRefreshToken(newRefreshToken);
      }

      return Right(newToken ?? '');
    } on Exception catch (e) {
      // En cas d'échec du rafraîchissement, on vide les jetons
      await _authLocalService.clearTokens();
      return Left(ServerFailure(e.toString()));
    }
  }
}
