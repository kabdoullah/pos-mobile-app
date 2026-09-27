import 'package:decimal/decimal.dart';
import 'package:drift/drift.dart' as drift;

import '../../../../core/network/api_models/sale_dto.dart';
import '../../../../database/app_database.dart' as drift_db;
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/discount.dart';
import '../../domain/entities/sale.dart' as domain;

/// Convertit PaymentMethodDto (API) → domain.PaymentMethod.
domain.PaymentMethod _paymentMethodFromString(String method) {
  return switch (method) {
    'cash' => domain.PaymentMethod.cash,
    'mobile_money_orange' => domain.PaymentMethod.orangeMoney,
    'mobile_money_mtn' => domain.PaymentMethod.mtn,
    'mobile_money_wave' => domain.PaymentMethod.wave,
    'mixed' => domain.PaymentMethod.mixed,
    _ => domain.PaymentMethod.cash,
  };
}

/// Convertit domain.PaymentMethod → chaîne (API).
String _paymentMethodToString(domain.PaymentMethod method) {
  return switch (method) {
    domain.PaymentMethod.cash => 'cash',
    domain.PaymentMethod.orangeMoney => 'mobile_money_orange',
    domain.PaymentMethod.mtn => 'mobile_money_mtn',
    domain.PaymentMethod.wave => 'mobile_money_wave',
    domain.PaymentMethod.mixed => 'mixed',
  };
}

/// Valeur API / drift d'un [DiscountType].
String discountTypeToString(DiscountType type) => switch (type) {
  DiscountType.amount => 'amount',
  DiscountType.percentage => 'percentage',
};

/// Reconstruit une réduction enregistrée (API ou drift) ; `null` si aucune.
/// Échoue si le type ou la valeur est malformé (frontière fail-fast).
Discount? discountFromStrings(String? type, String? value) {
  if (type == null || value == null) return null;
  return Discount(
    type: switch (type) {
      'amount' => DiscountType.amount,
      'percentage' => DiscountType.percentage,
      _ => throw FormatException('Type de réduction inconnu : $type'),
    },
    value: Decimal.parse(value),
  );
}

/// Convertit SaleDto (API) → domain.Sale.
extension SaleDtoToDomain on SaleDto {
  /// Convertit le DTO de l'API en entité du domaine.
  domain.Sale toDomain() => domain.Sale(
    id: id,
    receiptNumber: receiptNumber ?? 0,
    totalAmount: Decimal.parse(totalAmount),
    vatAmount: Decimal.parse(vatAmount),
    paymentMethod: _paymentMethodFromString(paymentMethod),
    createdAt: DateTime.parse(createdAt),
    discount: discountFromStrings(discountType, discountValue),
    discountAmount: Decimal.parse(discountAmount),
  );
}

/// Convertit domain.Sale → SalesCompanion drift.
extension DomainSaleToDrift on domain.Sale {
  /// Convertit l'entité du domaine en companion drift.
  drift_db.SalesCompanion toDriftCompanion() => drift_db.SalesCompanion(
    id: drift.Value(id),
    receiptNumber: drift.Value(receiptNumber),
    totalAmount: drift.Value(totalAmount.toString()),
    vatAmount: drift.Value(vatAmount.toString()),
    paymentMethod: drift.Value(_paymentMethodToString(paymentMethod)),
    createdAt: drift.Value(createdAt),
    discountType: drift.Value(
      discount == null ? null : discountTypeToString(discount!.type),
    ),
    discountValue: drift.Value(discount?.value.toString()),
    discountAmount: drift.Value(discountAmount.toString()),
  );
}

/// Convertit une ligne Sale drift → domain.Sale.
extension DriftSaleToDomain on drift_db.Sale {
  /// Convertit la ligne drift en entité du domaine.
  domain.Sale toDomain() => domain.Sale(
    id: id,
    receiptNumber: receiptNumber,
    totalAmount: Decimal.parse(totalAmount),
    vatAmount: Decimal.parse(vatAmount),
    paymentMethod: _paymentMethodFromString(paymentMethod),
    createdAt: createdAt,
    discount: discountFromStrings(discountType, discountValue),
    discountAmount: Decimal.parse(discountAmount),
  );
}

/// Convertit une ligne de vente drift → ligne du domaine (même type que le
/// panier : c'est ce qu'attend l'impression du ticket).
extension DriftSaleItemToDomain on drift_db.SaleItem {
  /// Convertit la ligne drift en [CartItem] (stock non pertinent : `null`).
  ///
  /// Uniquement les valeurs figées à la vente : jamais le produit actuel.
  CartItem toCartItem() => CartItem(
    productId: productId,
    productName: productName,
    unitPrice: Decimal.parse(unitPrice),
    quantity: quantity,
    purchaseUnitPrice: purchaseUnitPrice == null
        ? null
        : Decimal.parse(purchaseUnitPrice!),
    discount: discountFromStrings(discountType, discountValue),
  );
}

/// Convertit domain.Sale → SaleCreateDto (requête API).
extension DomainSaleCreateDtoMapper on domain.Sale {
  /// Convertit l'entité du domaine en DTO de requête de création.
  SaleCreateDto toCreateDto({
    required List<SaleItemCreateDto> items,
    Decimal? cashAmount,
    Decimal? mobileMoneyAmount,
  }) => SaleCreateDto(
    id: id,
    items: items,
    totalAmount: totalAmount.toString(),
    vatAmount: vatAmount.toString(),
    paymentMethod: switch (paymentMethod) {
      domain.PaymentMethod.cash => PaymentMethodDto.cash,
      domain.PaymentMethod.orangeMoney => PaymentMethodDto.mobileMoneyOrange,
      domain.PaymentMethod.mtn => PaymentMethodDto.mobileMoneyMtn,
      domain.PaymentMethod.wave => PaymentMethodDto.mobileMoneyWave,
      domain.PaymentMethod.mixed => PaymentMethodDto.mixed,
    },
    cashAmount: cashAmount?.toString(),
    mobileMoneyAmount: mobileMoneyAmount?.toString(),
    createdAt: createdAt.toIso8601String(),
    discountType: discount == null
        ? null
        : discountTypeToString(discount!.type),
    discountValue: discount?.value.toString(),
    discountAmount: discountAmount.toString(),
  );
}
