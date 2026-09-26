import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/network/api_exception.dart';
import 'package:mobile/core/network/refresh_interceptor.dart';
import 'package:mobile/core/network/token_storage.dart';
import 'package:mocktail/mocktail.dart';

// ignore: unnecessary_lambdas
class MockTokenStorage extends Mock implements TokenStorage {}

// ignore: unnecessary_lambdas
class MockDio extends Mock implements Dio {}

void main() {
  setUpAll(() {
    registerFallbackValue(RequestOptions(path: ''));
  });
  group('RefreshInterceptor', () {
    test('single 401 → calls refreshCall once, new tokens saved', () async {
      final tokenStorage = MockTokenStorage();
      var refreshCallCount = 0;

      when(
        tokenStorage.getRefreshToken,
      ).thenAnswer((_) async => 'old_refresh_token');
      when(
        () => tokenStorage.saveTokens(
          accessToken: any(named: 'accessToken'),
          refreshToken: any(named: 'refreshToken'),
        ),
      ).thenAnswer((_) async {});

      Future<({String accessToken, String refreshToken})> refreshCall(
        String refreshToken,
      ) async {
        refreshCallCount++;
        return (accessToken: 'new_access', refreshToken: 'new_refresh');
      }

      var onAuthExpiredCalled = false;

      final mockDio = MockDio();
      when(() => mockDio.fetch<dynamic>(any())).thenAnswer(
        (_) async => Response(
          data: {'id': 1},
          statusCode: 200,
          requestOptions: RequestOptions(path: '/api/v1/products'),
        ),
      );

      final interceptor = RefreshInterceptor(
        tokenStorage: tokenStorage,
        refreshCall: refreshCall,
        onAuthExpired: () => onAuthExpiredCalled = true,
        dio: mockDio,
      );

      // Simule une réponse 401.
      final errorResponse = Response(
        data: {'code': 'TOKEN_EXPIRED', 'detail': 'Token expired.'},
        statusCode: 401,
        requestOptions: RequestOptions(path: '/api/v1/products'),
      );
      final dioException = DioException(
        requestOptions: errorResponse.requestOptions,
        response: errorResponse,
        type: DioExceptionType.badResponse,
      );

      // Crée le handler et intercepte.
      final handler = _TestErrorInterceptorHandler();
      await interceptor.onError(dioException, handler);

      // Vérifie que le rafraîchissement a été appelé une fois.
      expect(refreshCallCount, 1);

      // Vérifie que l'expiration d'auth n'a PAS été appelée.
      expect(onAuthExpiredCalled, false);

      // Vérifie que les nouveaux tokens ont été enregistrés.
      verify(
        () => tokenStorage.saveTokens(
          accessToken: 'new_access',
          refreshToken: 'new_refresh',
        ),
      ).called(1);

      // Vérifie que la réponse a été résolue (et non passée en erreur).
      expect(handler.resolvedResponse, isNotNull);
      expect(handler.erroredError, isNull);
    });

    test('refresh fails → calls onAuthExpired, forwards error', () async {
      final tokenStorage = MockTokenStorage();
      var refreshCallCount = 0;

      when(
        tokenStorage.getRefreshToken,
      ).thenAnswer((_) async => 'expired_refresh_token');

      Future<({String accessToken, String refreshToken})> refreshCall(
        String refreshToken,
      ) async {
        refreshCallCount++;
        throw ApiException(
          statusCode: 401,
          code: 'REFRESH_TOKEN_EXPIRED',
          detail: 'Refresh token expired.',
        );
      }

      var onAuthExpiredCalled = false;

      final interceptor = RefreshInterceptor(
        tokenStorage: tokenStorage,
        refreshCall: refreshCall,
        onAuthExpired: () => onAuthExpiredCalled = true,
        dio: MockDio(),
      );

      final errorResponse = Response(
        data: {'code': 'TOKEN_EXPIRED', 'detail': 'Token expired.'},
        statusCode: 401,
        requestOptions: RequestOptions(path: '/api/v1/products'),
      );
      final dioException = DioException(
        requestOptions: errorResponse.requestOptions,
        response: errorResponse,
        type: DioExceptionType.badResponse,
      );

      final handler = _TestErrorInterceptorHandler();
      await interceptor.onError(dioException, handler);

      // Vérifie qu'une seule tentative de rafraîchissement a eu lieu.
      expect(refreshCallCount, 1);

      // Vérifie que onAuthExpired a été appelé.
      expect(onAuthExpiredCalled, true);

      // Vérifie que l'erreur a été transmise.
      expect(handler.erroredError, isNotNull);
      expect(handler.resolvedResponse, isNull);
    });

    test('concurrent 401s → refreshCall invoked only once', () async {
      final tokenStorage = MockTokenStorage();
      var refreshCallCount = 0;
      final refreshCompleter = Completer<void>();

      when(
        tokenStorage.getRefreshToken,
      ).thenAnswer((_) async => 'refresh_token');
      when(
        () => tokenStorage.saveTokens(
          accessToken: any(named: 'accessToken'),
          refreshToken: any(named: 'refreshToken'),
        ),
      ).thenAnswer((_) async {});

      Future<({String accessToken, String refreshToken})> refreshCall(
        String refreshToken,
      ) async {
        refreshCallCount++;
        // Bloque jusqu'à ce que le test signale la fin.
        await refreshCompleter.future;
        return (accessToken: 'new_access', refreshToken: 'new_refresh');
      }

      var onAuthExpiredCallCount = 0;

      final mockDio = MockDio();
      when(() => mockDio.fetch<dynamic>(any())).thenAnswer(
        (_) async => Response(
          data: {'id': 1},
          statusCode: 200,
          requestOptions: RequestOptions(path: '/api/v1/products'),
        ),
      );

      final interceptor = RefreshInterceptor(
        tokenStorage: tokenStorage,
        refreshCall: refreshCall,
        onAuthExpired: () => onAuthExpiredCallCount++,
        dio: mockDio,
      );

      // Crée 3 erreurs 401 concurrentes.
      final errorResponse = Response(
        data: {'code': 'TOKEN_EXPIRED', 'detail': 'Token expired.'},
        statusCode: 401,
        requestOptions: RequestOptions(path: '/api/v1/products'),
      );

      final handlers = <_TestErrorInterceptorHandler>[];
      final futures = <Future<void>>[];

      for (var i = 0; i < 3; i++) {
        final dioException = DioException(
          requestOptions: errorResponse.requestOptions,
          response: errorResponse,
          type: DioExceptionType.badResponse,
        );

        final handler = _TestErrorInterceptorHandler();
        handlers.add(handler);

        futures.add(interceptor.onError(dioException, handler));
      }

      // Rend la main pour laisser les tâches démarrer.
      await Future<void>.delayed(Duration.zero);

      // À ce stade, les 3 devraient attendre le rafraîchissement.
      expect(refreshCallCount, 1);

      // Débloque le rafraîchissement.
      refreshCompleter.complete();

      // Attend la fin de tous les handlers.
      await Future.wait(futures);

      // Vérifie que le rafraîchissement n'a toujours été appelé qu'une fois (le
      // verrou a fonctionné).
      expect(refreshCallCount, 1);

      // Vérifie que onAuthExpired n'a PAS été appelé (le rafraîchissement a
      // réussi).
      expect(onAuthExpiredCallCount, 0);

      // Vérifie que tous les handlers ont soit résolu, soit passé une erreur.
      for (final handler in handlers) {
        final hasResult =
            handler.resolvedResponse != null || handler.erroredError != null;
        expect(
          hasResult,
          true,
          reason: 'Handler should have resolved or errored',
        );
      }
    });

    test(
      'no refresh token available → calls onAuthExpired immediately',
      () async {
        final tokenStorage = MockTokenStorage();

        when(tokenStorage.getRefreshToken).thenAnswer((_) async => null);

        var onAuthExpiredCalled = false;

        final interceptor = RefreshInterceptor(
          tokenStorage: tokenStorage,
          refreshCall: (_) async => throw Exception('should not be called'),
          onAuthExpired: () => onAuthExpiredCalled = true,
          dio: MockDio(),
        );

        final errorResponse = Response(
          data: {'code': 'TOKEN_EXPIRED', 'detail': 'Token expired.'},
          statusCode: 401,
          requestOptions: RequestOptions(path: '/api/v1/products'),
        );
        final dioException = DioException(
          requestOptions: errorResponse.requestOptions,
          response: errorResponse,
          type: DioExceptionType.badResponse,
        );

        final handler = _TestErrorInterceptorHandler();
        await interceptor.onError(dioException, handler);

        // Vérifie que onAuthExpired a été appelé.
        expect(onAuthExpiredCalled, true);

        // Vérifie que l'erreur a été transmise.
        expect(handler.erroredError, isNotNull);
      },
    );

    test('non-401 error → passed through unchanged', () async {
      final tokenStorage = MockTokenStorage();

      var onAuthExpiredCalled = false;

      final interceptor = RefreshInterceptor(
        tokenStorage: tokenStorage,
        refreshCall: (_) async => throw Exception('should not be called'),
        onAuthExpired: () => onAuthExpiredCalled = true,
        dio: MockDio(),
      );

      final errorResponse = Response(
        data: {'code': 'VALIDATION_ERROR', 'detail': 'Invalid data.'},
        statusCode: 422,
        requestOptions: RequestOptions(path: '/api/v1/products'),
      );
      final dioException = DioException(
        requestOptions: errorResponse.requestOptions,
        response: errorResponse,
        type: DioExceptionType.badResponse,
      );

      final handler = _TestErrorInterceptorHandler();
      await interceptor.onError(dioException, handler);

      // Vérifie que onAuthExpired n'a PAS été appelé.
      expect(onAuthExpiredCalled, false);

      // Vérifie que l'erreur a été transmise telle quelle (non résolue).
      expect(handler.erroredError, dioException);
      expect(handler.resolvedResponse, isNull);
    });
  });
}

/// Double de test pour ErrorInterceptorHandler qui suit les appels
/// resolve/error.
class _TestErrorInterceptorHandler extends ErrorInterceptorHandler {
  Response<dynamic>? resolvedResponse;
  DioException? erroredError;

  @override
  void resolve(Response<dynamic> response) => resolvedResponse = response;

  @override
  void next(DioException err) => erroredError = err;
}
