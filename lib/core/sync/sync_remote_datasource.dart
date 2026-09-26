import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api_models/sync_changes_dto.dart';
import '../../../../core/network/api_models/sync_responses_dto.dart';

part 'sync_remote_datasource.g.dart';

/// Data source distante pour les opérations de synchro.
@RestApi()
abstract class SyncRemoteDataSource {
  /// Crée une instance SyncRemoteDataSource.
  factory SyncRemoteDataSource(Dio dio, {String baseUrl}) =
      _SyncRemoteDataSource;

  /// Récupère les changements (produits et ventes) depuis un horodatage donné.
  /// Endpoint : GET /api/v1/sync/changes
  @GET('/api/v1/sync/changes')
  Future<SyncChangesDto> getChanges({
    @Query('since') String? since,
    @Query('limit') int? limit,
    @Query('cursor') String? cursor,
  });

  /// Envoie un lot de ventes au serveur (synchro par événements avec
  /// idempotence).
  /// Endpoint : POST /api/v1/sync/sales
  @POST('/api/v1/sync/sales')
  Future<SalesSyncBatchResponseDto> pushSales(
    @Body() SalesSyncBatchRequestDto batch,
  );

  /// Envoie le changement d'un seul produit au serveur (synchro par état).
  /// Endpoint : PUT /api/v1/sync/products
  @PUT('/api/v1/sync/products')
  Future<ProductSyncResponseDto> pushProduct(
    @Body() ProductSyncItemDto product,
  );
}
