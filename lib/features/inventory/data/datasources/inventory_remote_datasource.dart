import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api_models/pagination.dart';
import '../../../../core/network/api_models/stock_movement_dto.dart';

part 'inventory_remote_datasource.g.dart';

/// Remote data source for inventory (stock movement) operations.
@RestApi()
abstract class InventoryRemoteDataSource {
  /// Creates an InventoryRemoteDataSource instance.
  factory InventoryRemoteDataSource(Dio dio, {String baseUrl}) =
      _InventoryRemoteDataSource;

  /// Lists stock movements with pagination.
  /// Endpoint: GET /api/v1/inventory/movements
  @GET('/api/v1/inventory/movements')
  Future<CursorPageDto<StockMovementDto>> listMovements({
    @Query('product_id') String? productId,
    @Query('cursor') String? cursor,
    @Query('limit') int? limit,
  });

  /// Records a manual stock adjustment.
  /// Endpoint: POST /api/v1/inventory/movements
  @POST('/api/v1/inventory/movements')
  Future<StockMovementDto> createAdjustment(
    @Body() ManualStockAdjustmentCreateDto request,
  );
}
