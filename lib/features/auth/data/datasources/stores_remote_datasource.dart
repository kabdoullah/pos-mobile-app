import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api_models/store_dto.dart';

part 'stores_remote_datasource.g.dart';

/// Data source distante pour les opérations sur la boutique.
@RestApi()
abstract class StoresRemoteDataSource {
  /// Crée une instance StoresRemoteDataSource.
  factory StoresRemoteDataSource(Dio dio, {String baseUrl}) =
      _StoresRemoteDataSource;

  /// Récupère la boutique de l'utilisateur courant.
  /// Endpoint : GET /api/v1/stores/me
  @GET('/api/v1/stores/me')
  Future<StoreDto> getCurrentStore();

  /// Met à jour la boutique de l'utilisateur courant.
  /// Endpoint : PATCH /api/v1/stores/me
  @PATCH('/api/v1/stores/me')
  Future<StoreDto> updateStore(@Body() StoreUpdateDto request);

  /// Crée une nouvelle boutique.
  /// Endpoint : POST /api/v1/stores
  @POST('/api/v1/stores')
  Future<StoreDto> createStore(@Body() StoreCreateDto request);
}
