import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/network/api_exception.dart';
import 'package:mobile/core/network/refresh_interceptor.dart';
import 'package:mobile/core/network/store_suspended_interceptor.dart';
import 'package:mobile/core/network/token_storage.dart';
import 'package:mocktail/mocktail.dart';

import 'sync_store_suspended_test.dart' show suspendedError;

class _MockTokenStorage extends Mock implements TokenStorage {}

class _MockDio extends Mock implements Dio {}

class _RecordingHandler extends ErrorInterceptorHandler {
  DioException? passed;

  @override
  void next(DioException err) => passed = err;
}

DioException _forbidden(Object? data) => DioException(
  requestOptions: RequestOptions(),
  response: Response<Object?>(
    requestOptions: RequestOptions(),
    statusCode: 403,
    data: data,
  ),
);

void main() {
  group('parseException', () {
    test('403 STORE_SUSPENDED → StoreSuspendedException avec le contact', () {
      final e = parseException(suspendedError());
      expect(e, isA<StoreSuspendedException>());
      expect((e as StoreSuspendedException).supportContact, '+2250700000000');
      expect(e.statusCode, 403);
    });

    test('contact vide ou absent → null', () {
      final empty = parseException(
        _forbidden({
          'detail': 'Store is suspended.',
          'code': 'STORE_SUSPENDED',
          'details': {'support_contact': ''},
        }),
      );
      final missing = parseException(
        _forbidden({
          'detail': 'Store is suspended.',
          'code': 'STORE_SUSPENDED',
        }),
      );
      expect((empty as StoreSuspendedException).supportContact, isNull);
      expect((missing as StoreSuspendedException).supportContact, isNull);
    });

    test('un autre 403 reste une ApiException ordinaire', () {
      final e = parseException(
        _forbidden({'detail': 'Invalid password.', 'code': 'FORBIDDEN'}),
      );
      expect(e, isNot(isA<StoreSuspendedException>()));
    });
  });

  group('storeSuspensionOf', () {
    test('reconnaît la réponse, l’exception et l’exception enveloppée', () {
      expect(storeSuspensionOf(suspendedError()), isNotNull);
      final parsed = parseException(suspendedError());
      expect(storeSuspensionOf(parsed), same(parsed));
      expect(
        storeSuspensionOf(
          DioException(requestOptions: RequestOptions(), error: parsed),
        ),
        same(parsed),
      );
    });

    test('ignore les autres erreurs, y compris un corps non JSON', () {
      expect(storeSuspensionOf(_forbidden('<html>')), isNull);
      expect(storeSuspensionOf(_forbidden(null)), isNull);
      expect(storeSuspensionOf(Exception('x')), isNull);
    });
  });

  group('StoreSuspendedInterceptor', () {
    test('signale la suspension avec le contact et laisse passer l’erreur', () {
      String? reported;
      var calls = 0;
      final interceptor = StoreSuspendedInterceptor(
        onStoreSuspended: (contact) {
          calls++;
          reported = contact;
        },
      );
      final handler = _RecordingHandler();

      interceptor.onError(suspendedError(), handler);

      expect(calls, 1);
      expect(reported, '+2250700000000');
      expect(handler.passed, isNotNull);
    });

    test('ne signale rien pour une autre erreur', () {
      var calls = 0;
      final interceptor = StoreSuspendedInterceptor(
        onStoreSuspended: (_) => calls++,
      );

      interceptor.onError(
        _forbidden({'detail': 'x', 'code': 'FORBIDDEN'}),
        _RecordingHandler(),
      );

      expect(calls, 0);
    });
  });

  test(
    'refresh refusé pour suspension : la session n’est pas expirée',
    () async {
      final storage = _MockTokenStorage();
      when(storage.getRefreshToken).thenAnswer((_) async => 'refresh');
      var expired = false;
      final interceptor = RefreshInterceptor(
        tokenStorage: storage,
        refreshCall: (_) async => throw parseException(suspendedError()),
        onAuthExpired: () => expired = true,
        dio: _MockDio(),
      );
      final handler = _RecordingHandler();

      await interceptor.onError(
        DioException(
          requestOptions: RequestOptions(path: '/api/v1/products'),
          response: Response<Object?>(
            requestOptions: RequestOptions(path: '/api/v1/products'),
            statusCode: 401,
          ),
        ),
        handler,
      );

      expect(expired, isFalse);
      expect(storeSuspensionOf(handler.passed!), isNotNull);
    },
  );
}
