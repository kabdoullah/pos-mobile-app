import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/network/api_exception.dart';
import 'package:mobile/core/network/error_mapper.dart';
import 'package:mobile/core/utils/phone_formatter.dart';

DioException _response422(Object? body) {
  final options = RequestOptions(path: '/auth/register');
  return DioException(
    requestOptions: options,
    type: DioExceptionType.badResponse,
    response: Response<Object?>(
      requestOptions: options,
      statusCode: 422,
      data: body,
    ),
  );
}

void main() {
  group('isValidMobilePhoneCi', () {
    test('accepte les mobiles 01, 05, 07 (avec ou sans espaces)', () {
      expect(isValidMobilePhoneCi('0102030405'), isTrue);
      expect(isValidMobilePhoneCi('05 00 00 00 00'), isTrue);
      expect(isValidMobilePhoneCi('0700000001'), isTrue);
    });

    test('refuse fixes, préfixes inexistants et mauvaises longueurs', () {
      expect(isValidMobilePhoneCi('2721000000'), isFalse);
      expect(isValidMobilePhoneCi('0000000000'), isFalse);
      expect(isValidMobilePhoneCi('0300000000'), isFalse);
      expect(isValidMobilePhoneCi('07000000'), isFalse);
      expect(isValidMobilePhoneCi('07000000011'), isFalse);
    });
  });

  group('erreur 422 numéro inexistant', () {
    test('format plat → message français', () {
      final e = parseException(
        _response422(<String, dynamic>{
          'detail':
              'Phone number does not exist (check the number of digits and prefix).',
          'code': 'VALIDATION_ERROR',
          'field': 'phone_number',
        }),
      );
      expect(e, isA<ApiException>());
      expect((e as ApiException).field, 'phone_number');
      expect(errorToFrench(e), "Ce numéro n'existe pas, vérifiez-le.");
    });

    test('format liste FastAPI → message générique, sans planter', () {
      final e = parseException(
        _response422(<String, dynamic>{
          'detail': <Object>[
            <String, Object>{'msg': 'Value error, ...'},
          ],
        }),
      );
      expect(errorToFrench(e), 'Une erreur est survenue.');
    });
  });
}
