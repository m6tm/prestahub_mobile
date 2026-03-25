import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prestahub/data/services/auth_local_service.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late AuthLocalService authLocalService;
  late MockSharedPreferences mockPrefs;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    authLocalService = AuthLocalService(mockPrefs);
  });

  group('AuthLocalService', () {
    const tToken = 'jwt_token_test';

    test('doit appeler SharedPreferences pour sauvegarder le token', () async {
      // Arrange
      when(
        () => mockPrefs.setString(any(), any()),
      ).thenAnswer((_) async => true);

      // Act
      await authLocalService.saveToken(tToken);

      // Assert
      verify(() => mockPrefs.setString('access_token', tToken)).called(1);
    });

    test('doit retourner le token depuis SharedPreferences', () {
      // Arrange
      when(() => mockPrefs.getString(any())).thenReturn(tToken);

      // Act
      final result = authLocalService.getToken();

      // Assert
      expect(result, tToken);
      verify(() => mockPrefs.getString('access_token')).called(1);
    });

    test('doit retourner null si aucun token n\'est en SharedPreferences', () {
      // Arrange
      when(() => mockPrefs.getString(any())).thenReturn(null);

      // Act
      final result = authLocalService.getToken();

      // Assert
      expect(result, isNull);
    });

    test(
      'doit appeler SharedPreferences pour sauvegarder le refresh token',
      () async {
        // Arrange
        when(
          () => mockPrefs.setString(any(), any()),
        ).thenAnswer((_) async => true);

        // Act
        await authLocalService.saveRefreshToken(tToken);

        // Assert
        verify(() => mockPrefs.setString('refresh_token', tToken)).called(1);
      },
    );

    test('doit appeler remove pour supprimer tous les jetons', () async {
      // Arrange
      when(() => mockPrefs.remove(any())).thenAnswer((_) async => true);

      // Act
      await authLocalService.clearTokens();

      // Assert
      verify(() => mockPrefs.remove('access_token')).called(1);
      verify(() => mockPrefs.remove('refresh_token')).called(1);
    });

    test('doit vérifier si le token existe via containsKey', () {
      // Arrange
      when(() => mockPrefs.containsKey(any())).thenReturn(true);

      // Act
      final result = authLocalService.hasToken();

      // Assert
      expect(result, isTrue);
      verify(() => mockPrefs.containsKey('access_token')).called(1);
    });
  });
}
