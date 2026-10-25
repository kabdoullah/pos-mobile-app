import 'package:clock/clock.dart';
import 'package:dio/dio.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// Téléchargement des images du cache ([CacheManager]) via le [Dio] de l'app :
/// l'URL relative est résolue sur l'API, avec le JWT et son rafraîchissement.
///
/// Le client HTTP par défaut du cache n'a pas le token et échouerait dès
/// l'expiration de l'access token.
class DioFileService extends FileService {
  /// Crée le service autour du [Dio] authentifié.
  DioFileService(this._dio);

  final Dio _dio;

  @override
  Future<FileServiceResponse> get(
    String url, {
    Map<String, String>? headers,
  }) async {
    final response = await _dio.get<ResponseBody>(
      url,
      options: Options(responseType: ResponseType.stream, headers: headers),
    );
    return _DioFileServiceResponse(response);
  }
}

class _DioFileServiceResponse implements FileServiceResponse {
  _DioFileServiceResponse(this._response);

  final Response<ResponseBody> _response;

  @override
  Stream<List<int>> get content => _response.data!.stream;

  @override
  int? get contentLength {
    final length = _response.data!.contentLength;
    return length < 0 ? null : length;
  }

  @override
  int get statusCode => _response.statusCode ?? 0;

  // La version de l'image fait partie de la clé de cache : un fichier en cache
  // ne devient jamais faux, inutile de le revalider (ADR-0008, `immutable`).
  @override
  DateTime get validTill => clock.now().add(const Duration(days: 365));

  @override
  String? get eTag => _response.headers.value('etag');

  // Le serveur ré-encode toutes les images en WebP (ADR-0008).
  @override
  String get fileExtension => '.webp';
}
