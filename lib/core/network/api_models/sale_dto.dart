import 'package:freezed_annotation/freezed_annotation.dart';

part 'sale_dto.freezed.dart';
part 'sale_dto.g.dart';

/// Moyens de paiement disponibles.
enum PaymentMethodDto {
  /// Paiement en espèces.
  @JsonValue('cash')
  cash,

  /// Orange Money (mobile money).
  @JsonValue('mobile_money_orange')
  mobileMoneyOrange,

  /// MTN mobile money.
  @JsonValue('mobile_money_mtn')
  mobileMoneyMtn,

  /// Wave mobile money.
  @JsonValue('mobile_money_wave')
  mobileMoneyWave,

  /// Paiement mixte (espèces + mobile money).
  @JsonValue('mixed')
  mixed,
}

/// Article vendu dans une transaction.
@freezed
sealed class SaleItemDto with _$SaleItemDto {
  /// Crée un [SaleItemDto].
  const factory SaleItemDto({
    required String id,
    @JsonKey(name: 'sale_id') required String saleId,
    @JsonKey(name: 'product_id') String? productId,
    @JsonKey(name: 'product_name_at_sale') required String productNameAtSale,
    @JsonKey(name: 'unit_price_at_sale') required String unitPriceAtSale,
    required int quantity,
    @JsonKey(name: 'line_total') required String lineTotal,
  }) = _SaleItemDto;

  factory SaleItemDto.fromJson(Map<String, dynamic> json) =>
      _$SaleItemDtoFromJson(json);
}

/// Objet de transfert vente reçu de l'API.
@freezed
sealed class SaleDto with _$SaleDto {
  /// Crée un [SaleDto].
  const factory SaleDto({
    required String id,
    @JsonKey(name: 'store_id') required String storeId,
    @JsonKey(name: 'receipt_number') int? receiptNumber,
    @JsonKey(name: 'total_amount') required String totalAmount,
    @JsonKey(name: 'vat_amount') required String vatAmount,
    @JsonKey(name: 'payment_method') required String paymentMethod,
    @JsonKey(name: 'cash_amount') String? cashAmount,
    @JsonKey(name: 'mobile_money_amount') String? mobileMoneyAmount,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'synced_at') required String syncedAt,
    required List<SaleItemDto> items,
  }) = _SaleDto;

  factory SaleDto.fromJson(Map<String, dynamic> json) =>
      _$SaleDtoFromJson(json);
}

/// Requête de création d'un article de vente.
@freezed
sealed class SaleItemCreateDto with _$SaleItemCreateDto {
  /// Crée un [SaleItemCreateDto].
  const factory SaleItemCreateDto({
    @JsonKey(name: 'product_id') String? productId,
    @JsonKey(name: 'product_name_at_sale') required String productNameAtSale,
    @JsonKey(name: 'unit_price_at_sale') required String unitPriceAtSale,
    required int quantity,
    @JsonKey(name: 'line_total') required String lineTotal,
  }) = _SaleItemCreateDto;

  factory SaleItemCreateDto.fromJson(Map<String, dynamic> json) =>
      _$SaleItemCreateDtoFromJson(json);
}

/// Requête de création d'une vente.
@freezed
sealed class SaleCreateDto with _$SaleCreateDto {
  /// Crée un [SaleCreateDto].
  const factory SaleCreateDto({
    required String id,
    required List<SaleItemCreateDto> items,
    @JsonKey(name: 'total_amount') required String totalAmount,
    @JsonKey(name: 'vat_amount') required String vatAmount,
    @JsonKey(name: 'payment_method') required PaymentMethodDto paymentMethod,
    @JsonKey(name: 'cash_amount') String? cashAmount,
    @JsonKey(name: 'mobile_money_amount') String? mobileMoneyAmount,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _SaleCreateDto;

  factory SaleCreateDto.fromJson(Map<String, dynamic> json) =>
      _$SaleCreateDtoFromJson(json);
}

/// Récapitulatif des ventes du jour.
@freezed
sealed class DailySalesSummaryDto with _$DailySalesSummaryDto {
  /// Crée un [DailySalesSummaryDto].
  const factory DailySalesSummaryDto({
    required String date,
    @JsonKey(name: 'total_amount') required String totalAmount,
    @JsonKey(name: 'sales_count') required int salesCount,
  }) = _DailySalesSummaryDto;

  factory DailySalesSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$DailySalesSummaryDtoFromJson(json);
}
