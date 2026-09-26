import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_dto.freezed.dart';
part 'product_dto.g.dart';

/// Objet de transfert produit reçu de l'API.
@freezed
sealed class ProductDto with _$ProductDto {
  /// Crée un [ProductDto].
  const factory ProductDto({
    required String id,
    @JsonKey(name: 'store_id') required String storeId,
    required String name,
    String? barcode,

    /// Prix en FCFA, reçu sous forme de chaîne depuis l'API.
    @JsonKey(name: 'unit_price') required String unitPrice,
    @JsonKey(name: 'current_stock') int? currentStock,
    @JsonKey(name: 'min_stock') int? minStock,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') required String updatedAt,
    @JsonKey(name: 'deleted_at') String? deletedAt,
  }) = _ProductDto;

  factory ProductDto.fromJson(Map<String, dynamic> json) =>
      _$ProductDtoFromJson(json);
}

/// Requête de création d'un produit.
@freezed
sealed class ProductCreateDto with _$ProductCreateDto {
  /// Crée un [ProductCreateDto].
  const factory ProductCreateDto({
    required String name,
    String? barcode,

    /// Prix en FCFA.
    @JsonKey(name: 'unit_price') required String unitPrice,
    @JsonKey(name: 'current_stock') int? currentStock,
    @JsonKey(name: 'min_stock') int? minStock,
  }) = _ProductCreateDto;

  factory ProductCreateDto.fromJson(Map<String, dynamic> json) =>
      _$ProductCreateDtoFromJson(json);
}

/// Requête de mise à jour d'un produit (PATCH).
@freezed
sealed class ProductUpdateDto with _$ProductUpdateDto {
  /// Crée un [ProductUpdateDto].
  const factory ProductUpdateDto({
    String? name,
    String? barcode,
    @JsonKey(name: 'unit_price') String? unitPrice,
    @JsonKey(name: 'current_stock') int? currentStock,
    @JsonKey(name: 'min_stock') int? minStock,
  }) = _ProductUpdateDto;

  factory ProductUpdateDto.fromJson(Map<String, dynamic> json) =>
      _$ProductUpdateDtoFromJson(json);
}
