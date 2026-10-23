import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:mobile/core/network/dio_file_service.dart';

class _MockDio extends Mock implements Dio {}

void main() {
  setUpAll(() => registerFallbackValue(Options()));

  late _MockDio dio;
  late DioFileService service;

  setUp(() {
    dio = _MockDio();
    service = DioFileService(dio);
  });

  test('transmet le statut, la taille et les octets de la réponse', () async {
    when(
      () => dio.get<ResponseBody>(any(), options: any(named: 'options')),
    ).thenAnswer(
      (_) async => Response<ResponseBody>(
        data: ResponseBody.fromBytes(
          [1, 2, 3],
          200,
          headers: {
            Headers.contentLengthHeader: ['3'],
          },
        ),
        statusCode: 200,
        headers: Headers.fromMap({
          'etag': ['sha-v1'],
        }),
        requestOptions: RequestOptions(),
      ),
    );

    final response = await service.get('/api/v1/products/p1/image');

    expect(response.statusCode, 200);
    expect(response.contentLength, 3);
    expect(response.eTag, 'sha-v1');
    expect(response.fileExtension, '.webp');
    expect(await response.content.expand((chunk) => chunk).toList(), [1, 2, 3]);
    final options =
        verify(
              () => dio.get<ResponseBody>(
                '/api/v1/products/p1/image',
                options: captureAny(named: 'options'),
              ),
            ).captured.single
            as Options;
    expect(options.responseType, ResponseType.stream);
  });

  test('une erreur réseau remonte (pictogramme affiché)', () {
    when(
      () => dio.get<ResponseBody>(any(), options: any(named: 'options')),
    ).thenThrow(DioException(requestOptions: RequestOptions()));

    expect(
      () => service.get('/api/v1/products/p1/image'),
      throwsA(isA<DioException>()),
    );
  });

  test('taille inconnue : null', () async {
    when(
      () => dio.get<ResponseBody>(any(), options: any(named: 'options')),
    ).thenAnswer(
      (_) async => Response<ResponseBody>(
        data: ResponseBody(Stream.value(utf8.encode('x')), 200),
        statusCode: 200,
        requestOptions: RequestOptions(),
      ),
    );

    expect((await service.get('/x')).contentLength, isNull);
  });
}
