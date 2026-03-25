import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prestahub/core/error/exceptions.dart';
import 'package:prestahub/core/network/http_client.dart';
import 'package:prestahub/data/services/auth_local_service.dart';
import 'package:prestahub/domain/repositories/cache_repository_interface.dart';

class MockDio extends Mock implements Dio {
  @override
  Interceptors get interceptors => Interceptors();
}

class MockAuthLocalService extends Mock implements AuthLocalService {}

class MockCacheRepository extends Mock implements ICacheRepository {}

void main() {
  late HttpClient httpClient;
  late MockDio mockDio;
  late MockAuthLocalService mockAuthLocalService;
  late MockCacheRepository mockCacheRepository;

  setUp(() {
    mockDio = MockDio();
    mockAuthLocalService = MockAuthLocalService();
    mockCacheRepository = MockCacheRepository();

    httpClient = HttpClient(
      mockAuthLocalService,
      mockCacheRepository,
      dio: mockDio,
    );
  });

  group('HttpClient Error Handling', () {
    test('should throw NetworkException on timeout', () async {
      // Arrange
      when(() => mockDio.get(any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      // Act & Assert
      expect(() => httpClient.get('/test'), throwsA(isA<NetworkException>()));
    });

    test(
      'should throw ServerException with aggregated messages on 422',
      () async {
        // Arrange
        when(() => mockDio.get(any())).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            response: Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: 422,
              data: {
                'errors': {
                  'email': ['Email invalide'],
                  'password': ['Trop court', 'Doit contenir un chiffre'],
                },
              },
            ),
          ),
        );

        // Act & Assert
        try {
          await httpClient.get('/test');
          fail('Should have thrown ServerException');
        } on ServerException catch (e) {
          expect(e.statusCode, 422);
          expect(e.message, contains('Email invalide'));
          expect(e.message, contains('Trop court'));
          expect(e.message, contains('Doit contenir un chiffre'));
        }
      },
    );

    test('should throw ServerException on 401', () async {
      // Arrange
      when(() => mockDio.get(any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          response: Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 401,
            data: {'message': 'Non autorisé'},
          ),
        ),
      );

      // Act & Assert
      try {
        await httpClient.get('/test');
        fail('Should have thrown ServerException');
      } on ServerException catch (e) {
        expect(e.statusCode, 401);
        expect(e.message, 'Non autorisé');
      }
    });

    test('should throw ServerException on 500 with default message', () async {
      // Arrange
      when(() => mockDio.get(any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          response: Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 500,
          ),
        ),
      );

      // Act & Assert
      try {
        await httpClient.get('/test');
        fail('Should have thrown ServerException');
      } on ServerException catch (e) {
        expect(e.statusCode, 500);
        expect(e.message, 'Une erreur serveur est survenue');
      }
    });
  });
}
