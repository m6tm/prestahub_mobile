import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prestahub/core/error/failures.dart';
import 'package:prestahub/core/network/api_endpoints.dart';
import 'package:prestahub/core/network/http_client.dart';
import 'package:prestahub/data/repositories/auth_repository.dart';
import 'package:prestahub/data/services/auth_local_service.dart';
import 'package:prestahub/domain/models/user_model.dart';
import 'package:prestahub/core/enums/user_role.dart';

class MockHttpClient extends Mock implements HttpClient {}

class MockAuthLocalService extends Mock implements AuthLocalService {}

void main() {
  late AuthRepository authRepository;
  late MockHttpClient mockHttpClient;
  late MockAuthLocalService mockAuthLocalService;

  setUp(() {
    mockHttpClient = MockHttpClient();
    mockAuthLocalService = MockAuthLocalService();
    authRepository = AuthRepository(mockHttpClient, mockAuthLocalService);
  });

  final tUserModel = UserModel(
    id: '1',
    email: 'test@example.com',
    role: UserRole.client,
    createdAt: DateTime.now(),
  );

  final tSuccessResponse = Response(
    data: {
      'user': {
        'id': '1',
        'email': 'test@example.com',
        'role': 'client',
        'created_at': DateTime.now().toIso8601String(),
      },
      'token': 'jwt_token',
      'refresh_token': 'refresh_token',
    },
    statusCode: 200,
    requestOptions: RequestOptions(path: ApiEndpoints.login),
  );

  group('AuthRepository', () {
    test(
      'signInWithEmail doit retourner UserModel et sauver le token en cas de succès',
      () async {
        // Arrange
        when(
          () => mockHttpClient.post(any(), data: any(named: 'data')),
        ).thenAnswer((_) async => tSuccessResponse);
        when(
          () => mockAuthLocalService.saveToken(any()),
        ).thenAnswer((_) async => {});
        when(
          () => mockAuthLocalService.saveRefreshToken(any()),
        ).thenAnswer((_) async => {});

        // Act
        final result = await authRepository.signInWithEmail(
          email: 'test@example.com',
          password: 'password123',
        );

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (_) => fail('Devrait être un succès'),
          (user) => expect(user.id, tUserModel.id),
        );
        verify(() => mockAuthLocalService.saveToken('jwt_token')).called(1);
        verify(() => mockAuthLocalService.saveRefreshToken('refresh_token')).called(1);
      },
    );

    test(
      'signInWithEmail doit retourner ServerFailure en cas d\'exception',
      () async {
        // Arrange
        when(
          () => mockHttpClient.post(any(), data: any(named: 'data')),
        ).thenThrow(Exception('Erreur serveur'));

        // Act
        final result = await authRepository.signInWithEmail(
          email: 'test@example.com',
          password: 'password123',
        );

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<ServerFailure>()),
          (_) => fail('Devrait être une erreur'),
        );
      },
    );

    test(
      'signOut doit déconnecter via l\'API et supprimer le token localement',
      () async {
        // Arrange
        when(() => mockHttpClient.post(any())).thenAnswer(
          (_) async => Response(
            statusCode: 200,
            requestOptions: RequestOptions(path: ApiEndpoints.logout),
          ),
        );
        when(
          () => mockAuthLocalService.clearTokens(),
        ).thenAnswer((_) async => {});

        // Act
        final result = await authRepository.signOut();

        // Assert
        expect(result.isRight(), true);
        verify(() => mockAuthLocalService.clearTokens()).called(1);
      },
    );
  });
}
