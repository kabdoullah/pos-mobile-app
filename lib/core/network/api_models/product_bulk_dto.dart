import 'package:freezed_annotation/freezed_annotation.dart';

import 'product_dto.dart';

part 'product_bulk_dto.freezed.dart';
part 'product_bulk_dto.g.dart';

/// Résultat d'une ligne dans un import produits en masse.
enum ProductBulkItemStatusDto {
  /// La ligne a été créée avec succès.
  @JsonValue('created')
  created,

  /// L'import de la ligne a échoué.
  @JsonValue('failed')
  failed,
}

/// Résultat du traitement d'une ligne d'un import produits en masse.
@freezed
sealed class ProductBulkItemResultDto with _$ProductBulkItemResultDto {
  /// Crée un [ProductBulkItemResultDto].
  const factory ProductBulkItemResultDto({
    required int index,
    required ProductBulkItemStatusDto status,
    ProductDto? product,
    String? error,
    String? field,
  }) = _ProductBulkItemResultDto;

  /// Crée un [ProductBulkItemResultDto] depuis du JSON.
  factory ProductBulkItemResultDto.fromJson(Map<String, dynamic> json) =>
      _$ProductBulkItemResultDtoFromJson(json);
}

/// Réponse récapitulative d'un import produits en masse (au mieux, ligne par
/// ligne).
@freezed
sealed class ProductBulkCreateResponseDto with _$ProductBulkCreateResponseDto {
  /// Crée un [ProductBulkCreateResponseDto].
  const factory ProductBulkCreateResponseDto({
    required int processed,
    @JsonKey(name: 'created_count') required int createdCount,
    @JsonKey(name: 'failed_count') required int failedCount,
    required List<ProductBulkItemResultDto> results,
  }) = _ProductBulkCreateResponseDto;

  /// Crée un [ProductBulkCreateResponseDto] depuis du JSON.
  factory ProductBulkCreateResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ProductBulkCreateResponseDtoFromJson(json);
}
