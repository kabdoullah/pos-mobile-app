import 'package:decimal/decimal.dart';
import 'package:drift/drift.dart' as drift;

import '../../../../core/network/api_models/sale_dto.dart';
import '../../../../database/app_database.dart' as drift_db;
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
  );
}
