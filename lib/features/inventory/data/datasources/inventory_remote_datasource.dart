import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api_models/pagination.dart';
import '../../../../core/network/api_models/stock_movement_dto.dart';

part 'inventory_remote_datasource.g.dart';

/// Data source distante pour les opérations d'inventaire (mouvements de stock).
@RestApi()
abstract class InventoryRemoteDataSource {
  /// Crée une instance InventoryRemoteDataSource.
  factory InventoryRemoteDataSource(Dio dio, {String baseUrl}) =
      _InventoryRemoteDataSource;

  /// Liste les mouvements de stock avec pagination.
  /// Endpoint : GET /api/v1/inventory/movements
  @GET('/api/v1/inventory/movements')
  Future<CursorPageDto<StockMovementDto>> listMovements({
    @Query('product_id') String? productId,
    @Query('cursor') String? cursor,
    @Query('limit') int? limit,
  });

  /// Enregistre un ajustement de stock manuel.
  /// Endpoint : POST /api/v1/inventory/movements
  @POST('/api/v1/inventory/movements')
  Future<StockMovementDto> createAdjustment(
    @Body() ManualStockAdjustmentCreateDto request,
  );
}
