// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SaleItemDto _$SaleItemDtoFromJson(Map<String, dynamic> json) => _SaleItemDto(
  id: json['id'] as String,
  saleId: json['sale_id'] as String,
  productId: json['product_id'] as String?,
  productNameAtSale: json['product_name_at_sale'] as String,
  unitPriceAtSale: json['unit_price_at_sale'] as String,
  quantity: (json['quantity'] as num).toInt(),
  lineTotal: json['line_total'] as String,
  purchasePriceAtSale: json['purchase_price_at_sale'] as String?,
  discountType: json['discount_type'] as String?,
  discountValue: json['discount_value'] as String?,
  discountAmount: json['discount_amount'] as String? ?? '0',
);

Map<String, dynamic> _$SaleItemDtoToJson(_SaleItemDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sale_id': instance.saleId,
      'product_id': instance.productId,
      'product_name_at_sale': instance.productNameAtSale,
      'unit_price_at_sale': instance.unitPriceAtSale,
      'quantity': instance.quantity,
      'line_total': instance.lineTotal,
      'purchase_price_at_sale': instance.purchasePriceAtSale,
      'discount_type': instance.discountType,
      'discount_value': instance.discountValue,
      'discount_amount': instance.discountAmount,
    };

_SaleDto _$SaleDtoFromJson(Map<String, dynamic> json) => _SaleDto(
  id: json['id'] as String,
  storeId: json['store_id'] as String,
  receiptNumber: (json['receipt_number'] as num?)?.toInt(),
  totalAmount: json['total_amount'] as String,
  vatAmount: json['vat_amount'] as String,
  paymentMethod: json['payment_method'] as String,
  cashAmount: json['cash_amount'] as String?,
  mobileMoneyAmount: json['mobile_money_amount'] as String?,
  createdAt: json['created_at'] as String,
  syncedAt: json['synced_at'] as String,
  discountType: json['discount_type'] as String?,
  discountValue: json['discount_value'] as String?,
  discountAmount: json['discount_amount'] as String? ?? '0',
  items: (json['items'] as List<dynamic>)
      .map((e) => SaleItemDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SaleDtoToJson(_SaleDto instance) => <String, dynamic>{
  'id': instance.id,
  'store_id': instance.storeId,
  'receipt_number': instance.receiptNumber,
  'total_amount': instance.totalAmount,
  'vat_amount': instance.vatAmount,
  'payment_method': instance.paymentMethod,
  'cash_amount': instance.cashAmount,
  'mobile_money_amount': instance.mobileMoneyAmount,
  'created_at': instance.createdAt,
  'synced_at': instance.syncedAt,
  'discount_type': instance.discountType,
  'discount_value': instance.discountValue,
  'discount_amount': instance.discountAmount,
  'items': instance.items,
};

_SaleItemCreateDto _$SaleItemCreateDtoFromJson(Map<String, dynamic> json) =>
    _SaleItemCreateDto(
      productId: json['product_id'] as String?,
      productNameAtSale: json['product_name_at_sale'] as String,
      unitPriceAtSale: json['unit_price_at_sale'] as String,
      quantity: (json['quantity'] as num).toInt(),
      lineTotal: json['line_total'] as String,
      purchasePriceAtSale: json['purchase_price_at_sale'] as String?,
      discountType: json['discount_type'] as String?,
      discountValue: json['discount_value'] as String?,
      discountAmount: json['discount_amount'] as String? ?? '0',
    );

Map<String, dynamic> _$SaleItemCreateDtoToJson(_SaleItemCreateDto instance) =>
    <String, dynamic>{
      'product_id': instance.productId,
      'product_name_at_sale': instance.productNameAtSale,
      'unit_price_at_sale': instance.unitPriceAtSale,
      'quantity': instance.quantity,
      'line_total': instance.lineTotal,
      'purchase_price_at_sale': instance.purchasePriceAtSale,
      'discount_type': instance.discountType,
      'discount_value': instance.discountValue,
      'discount_amount': instance.discountAmount,
    };

_SaleCreateDto _$SaleCreateDtoFromJson(Map<String, dynamic> json) =>
    _SaleCreateDto(
      id: json['id'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => SaleItemCreateDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalAmount: json['total_amount'] as String,
      vatAmount: json['vat_amount'] as String,
      paymentMethod: $enumDecode(
        _$PaymentMethodDtoEnumMap,
        json['payment_method'],
      ),
      cashAmount: json['cash_amount'] as String?,
      mobileMoneyAmount: json['mobile_money_amount'] as String?,
      createdAt: json['created_at'] as String,
      discountType: json['discount_type'] as String?,
      discountValue: json['discount_value'] as String?,
      discountAmount: json['discount_amount'] as String? ?? '0',
    );

Map<String, dynamic> _$SaleCreateDtoToJson(_SaleCreateDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'items': instance.items,
      'total_amount': instance.totalAmount,
      'vat_amount': instance.vatAmount,
      'payment_method': _$PaymentMethodDtoEnumMap[instance.paymentMethod]!,
      'cash_amount': instance.cashAmount,
      'mobile_money_amount': instance.mobileMoneyAmount,
      'created_at': instance.createdAt,
      'discount_type': instance.discountType,
      'discount_value': instance.discountValue,
      'discount_amount': instance.discountAmount,
    };

const _$PaymentMethodDtoEnumMap = {
  PaymentMethodDto.cash: 'cash',
  PaymentMethodDto.mobileMoneyOrange: 'mobile_money_orange',
  PaymentMethodDto.mobileMoneyMtn: 'mobile_money_mtn',
  PaymentMethodDto.mobileMoneyWave: 'mobile_money_wave',
  PaymentMethodDto.mixed: 'mixed',
};

_DailySalesSummaryDto _$DailySalesSummaryDtoFromJson(
  Map<String, dynamic> json,
) => _DailySalesSummaryDto(
  date: json['date'] as String,
  totalAmount: json['total_amount'] as String,
  salesCount: (json['sales_count'] as num).toInt(),
);

Map<String, dynamic> _$DailySalesSummaryDtoToJson(
  _DailySalesSummaryDto instance,
) => <String, dynamic>{
  'date': instance.date,
  'total_amount': instance.totalAmount,
  'sales_count': instance.salesCount,
};
