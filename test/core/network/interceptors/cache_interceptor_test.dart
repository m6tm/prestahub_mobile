import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:prestahub/domain/repositories/cache_repository_interface.dart';
import 'package:prestahub/core/network/interceptors/cache_interceptor.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class MockCacheRepository extends Mock implements ICacheRepository {}
class MockResponseInterceptorHandler extends Mock implements ResponseInterceptorHandler {}

void main() {
  late MockCacheRepository mockCacheRepository;
  late CacheInterceptor cacheInterceptor;
  late MockResponseInterceptorHandler mockHandler;

  setUp(() {
    mockCacheRepository = MockCacheRepository();
    cacheInterceptor = CacheInterceptor(mockCacheRepository);
    mockHandler = MockResponseInterceptorHandler();
    
    when(() => mockCacheRepository.set(any(), any(), expiration: any(named: 'expiration')))
        .thenAnswer((_) async {});
  });

  String calculateExpectedHash(String url, Map<String, dynamic> params) {
    final sortedParams = params.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    final queryString = sortedParams.map((e) => '${e.key}=${e.value}').join('&');
    final canonicalString = queryString.isEmpty ? url : '$url?$queryString';
    final bytes = utf8.encode(canonicalString);
    return sha256.convert(bytes).toString();
  }

  group('CacheInterceptor - Génération de clé de cache (_generateKey)', () {
    test('La clé de cache ne dépasse jamais 255 caractères (Hive limit)', () async {
      final longString = List.generate(500, (index) => 'a').join();
      
      final requestOptions = RequestOptions(
        baseUrl: 'https://api.example.com',
        path: '/huge-endpoint',
        method: 'GET',
        queryParameters: {'long_param': longString},
      );

      final response = Response(
        requestOptions: requestOptions,
        statusCode: 200,
        data: {'success': true},
      );

      // Le comportement est asynchrone dans CacheInterceptor (void async)
      // mais onResponse ne bloque pas sur await _cacheRepository.set() 
      // si on n'a pas await la méthode elle-même. Pour un test simple, l'appel synchrone suffit car mock est synchrone.
      cacheInterceptor.onResponse(response, mockHandler);

      final expectedHash = calculateExpectedHash(
          'https://api.example.com/huge-endpoint', 
          {'long_param': longString}
      );

      expect(expectedHash.length, equals(64));
      expect(expectedHash.length, lessThan(255));

      // Laisse un léger délai pour que la fonction asynchrone ait le temps d'exécuter `set`
      await Future.delayed(Duration.zero);

      verify(() => mockCacheRepository.set(expectedHash, response.data, expiration: any(named: 'expiration'))).called(1);
      verify(() => mockHandler.next(response)).called(1);
    });

    test('La génération de clé est indépendante de lactordre des paramètres', () async {
      final requestOptions1 = RequestOptions(
        baseUrl: 'https://api.example.com',
        path: '/data',
        method: 'GET',
        queryParameters: {'a': '1', 'z': '2', 'm': '3'},
      );

      final requestOptions2 = RequestOptions(
        baseUrl: 'https://api.example.com',
        path: '/data',
        method: 'GET',
        queryParameters: {'z': '2', 'm': '3', 'a': '1'},
      );

      final response1 = Response(requestOptions: requestOptions1, statusCode: 200, data: {});
      final response2 = Response(requestOptions: requestOptions2, statusCode: 200, data: {});

      cacheInterceptor.onResponse(response1, mockHandler);
      cacheInterceptor.onResponse(response2, mockHandler);

      final expectedHash = calculateExpectedHash('https://api.example.com/data', {'a': '1', 'z': '2', 'm': '3'});

      await Future.delayed(Duration.zero);

      verify(() => mockCacheRepository.set(expectedHash, any(), expiration: any(named: 'expiration'))).called(2);
    });
  });
}
