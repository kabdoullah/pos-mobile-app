import 'package:freezed_annotation/freezed_annotation.dart';

part 'store_dto.freezed.dart';
part 'store_dto.g.dart';

/// Objet de transfert boutique reçu de l'API.
@freezed
sealed class StoreDto with _$StoreDto {
  /// Crée un [StoreDto].
  const factory StoreDto({
    required String id,
    @JsonKey(name: 'owner_id') required String ownerId,
    required String name,
    String? address,
    String? ncc,
    @JsonKey(name: 'vat_subject') required bool vatSubject,
    @JsonKey(name: 'receipt_footer_text') String? receiptFooterText,
    String? phone,
    @JsonKey(name: 'logo_version') String? logoVersion,
    @JsonKey(name: 'next_receipt_number') required int nextReceiptNumber,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') required String updatedAt,
  }) = _StoreDto;

  factory StoreDto.fromJson(Map<String, dynamic> json) =>
      _$StoreDtoFromJson(json);
}

/// Requête de création d'une boutique.
@freezed
sealed class StoreCreateDto with _$StoreCreateDto {
  /// Crée un [StoreCreateDto].
  const factory StoreCreateDto({
    required String name,
    String? address,
    String? ncc,
    @JsonKey(name: 'vat_subject') bool? vatSubject,
    @JsonKey(name: 'receipt_footer_text') String? receiptFooterText,
    String? phone,
  }) = _StoreCreateDto;

  factory StoreCreateDto.fromJson(Map<String, dynamic> json) =>
      _$StoreCreateDtoFromJson(json);
}

/// Requête de mise à jour d'une boutique (PATCH).
@freezed
sealed class StoreUpdateDto with _$StoreUpdateDto {
  /// Crée un [StoreUpdateDto].
  const factory StoreUpdateDto({
    String? name,
    String? address,
    String? ncc,
    @JsonKey(name: 'vat_subject') bool? vatSubject,
    @JsonKey(name: 'receipt_footer_text') String? receiptFooterText,
    String? phone,
  }) = _StoreUpdateDto;

  factory StoreUpdateDto.fromJson(Map<String, dynamic> json) =>
      _$StoreUpdateDtoFromJson(json);
}
