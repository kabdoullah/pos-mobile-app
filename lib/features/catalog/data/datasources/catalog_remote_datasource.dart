import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api_models/pagination.dart';
import '../../../../core/network/api_models/product_bulk_dto.dart';
import '../../../../core/network/api_models/product_dto.dart';

part 'catalog_remote_datasource.g.dart';

/// Data source distante pour les opérations du catalogue.
@RestApi()
abstract class CatalogRemoteDataSource {
  /// Crée une instance CatalogRemoteDataSource.
  factory CatalogRemoteDataSource(Dio dio, {String baseUrl}) =
      _CatalogRemoteDataSource;

  /// Liste les produits avec pagination.
  /// Endpoint : GET /api/v1/products
  @GET('/api/v1/products')
  Future<CursorPageDto<ProductDto>> listProducts({
    @Query('cursor') String? cursor,
    @Query('limit') int? limit,
    @Query('search') String? search,
  });

  /// Récupère un produit par ID.
  /// Endpoint : GET /api/v1/products/{id}
  @GET('/api/v1/products/{id}')
  Future<ProductDto> getProduct(@Path('id') String id);

  /// Récupère un produit par code-barres.
  /// Endpoint : GET /api/v1/products/by-barcode/{barcode}
  @GET('/api/v1/products/by-barcode/{barcode}')
  Future<ProductDto> getProductByBarcode(@Path('barcode') String barcode);

  /// Crée un nouveau produit.
  /// Endpoint : POST /api/v1/products
  @POST('/api/v1/products')
  Future<ProductDto> createProduct(@Body() ProductCreateDto request);

  /// Met à jour un produit (PATCH).
  /// Endpoint : PATCH /api/v1/products/{id}
  @PATCH('/api/v1/products/{id}')
  Future<ProductDto> updateProduct(
    @Path('id') String id,
    @Body() ProductUpdateDto request,
  );

  /// Supprime un produit (suppression logique).
  /// Endpoint : DELETE /api/v1/products/{id}
  @DELETE('/api/v1/products/{id}')
  Future<void> deleteProduct(@Path('id') String id);

  /// Importe des produits en masse depuis un fichier CSV ou Excel.
  /// Endpoint : POST /api/v1/products/bulk/file
  @POST('/api/v1/products/bulk/file')
  @MultiPart()
  Future<ProductBulkCreateResponseDto> importProductsFromFile(
    @Part(name: 'file') File file,
  );
}
