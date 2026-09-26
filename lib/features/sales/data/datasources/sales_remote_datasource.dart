import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api_models/pagination.dart';
import '../../../../core/network/api_models/sale_dto.dart';

part 'sales_remote_datasource.g.dart';

/// Data source distante pour les opérations de vente.
@RestApi()
abstract class SalesRemoteDataSource {
  /// Crée une instance SalesRemoteDataSource.
  factory SalesRemoteDataSource(Dio dio, {String baseUrl}) =
      _SalesRemoteDataSource;

  /// Liste les ventes avec pagination.
  /// Endpoint : GET /api/v1/sales
  @GET('/api/v1/sales')
  Future<CursorPageDto<SaleDto>> listSales({
    @Query('cursor') String? cursor,
    @Query('limit') int? limit,
    @Query('date_from') String? dateFrom,
    @Query('date_to') String? dateTo,
  });

  /// Récupère une vente par ID.
  /// Endpoint : GET /api/v1/sales/{id}
  @GET('/api/v1/sales/{id}')
  Future<SaleDto> getSale(@Path('id') String id);

  /// Récupère le récapitulatif des ventes du jour.
  /// Endpoint : GET /api/v1/sales/today/summary
  @GET('/api/v1/sales/today/summary')
  Future<DailySalesSummaryDto> getTodaySalesSummary();

  /// Crée une vente.
  /// Endpoint : POST /api/v1/sales
  @POST('/api/v1/sales')
  Future<SaleDto> createSale(@Body() SaleCreateDto request);
}
