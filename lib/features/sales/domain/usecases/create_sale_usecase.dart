import 'package:decimal/decimal.dart';

import '../entities/cart_item.dart';
import '../entities/discount.dart';
import '../entities/sale.dart';
import '../repositories/sales_repository.dart';

/// Exception pour les violations des règles métier de création de vente.
class CreateSaleException implements Exception {
  /// Crée une exception avec un message.
  CreateSaleException(this.message);

  /// Message d'erreur.
  final String message;

  @override
  String toString() => 'CreateSaleException: $message';
}

/// Logique métier de création d'une vente.
/// Regroupe toutes les règles : validation, génération de l'UUID, calcul des
/// montants.
class CreateSaleUseCase {
  /// Crée une instance du cas d'usage.
  CreateSaleUseCase({required this.repository});

  /// Repository qui persiste les ventes.
  final SalesRepository repository;

  /// Crée une vente à partir des articles du panier et des détails de paiement.
  ///
  /// Vérifie que :
  /// - le panier n'est pas vide
  /// - les totaux de paiement correspondent au total de la vente (surtout pour
  ///   les paiements mixtes)
  /// - aucun montant n'est négatif
  /// - chaque réduction (ligne et remise globale [discount]) est valide
  ///
  /// Génère un UUID côté client pour une synchro idempotente.
  /// Enregistre la vente et ses articles de façon atomique via le repository.
  Future<Sale> call({
    required List<CartItem> items,
    required Decimal totalAmount,
    required Decimal vatAmount,
    required PaymentMethod paymentMethod,
    Discount? discount,
    Decimal? cashAmount,
    Decimal? mobileMoneyAmount,
  }) async {
    // Validation : panier non vide
    if (items.isEmpty) {
      throw CreateSaleException('Le panier est vide');
    }

    // Validation : montants non négatifs
    if (totalAmount < Decimal.zero) {
      throw CreateSaleException('Montant total invalide');
    }
    if (vatAmount < Decimal.zero) {
      throw CreateSaleException('Montant TVA invalide');
    }

    // Validation : contrôle du stock
    for (final item in items) {
      if (item.availableStock != null && item.quantity > item.availableStock!) {
        throw CreateSaleException(
          'Stock insuffisant pour ${item.productName} : '
          '${item.quantity} demandé(s), ${item.availableStock} disponible(s)',
        );
      }
    }

    // Validation : réductions de ligne (jamais de total de ligne négatif)
    for (final item in items) {
      final error = item.discount?.validate(item.grossTotal);
      if (error != null) {
        throw CreateSaleException('${item.productName} : $error');
      }
    }

    // Recalcule le total depuis les articles, par sécurité
    final subtotal = items.fold<Decimal>(
      Decimal.zero,
      (sum, item) => sum + item.lineTotal,
    );
    final discountError = discount?.validate(subtotal);
    if (discountError != null) {
      throw CreateSaleException('Remise : $discountError');
    }
    final calculatedTotal =
        subtotal - (discount?.amountOn(subtotal) ?? Decimal.zero);
    if (calculatedTotal != totalAmount) {
      throw CreateSaleException(
        'Total panier ($calculatedTotal) ne correspond pas au montant fourni ($totalAmount)',
      );
    }

    // Validation : contrôle du paiement
    if (paymentMethod == PaymentMethod.mixed) {
      final cash = cashAmount ?? Decimal.zero;
      final mobileMoney = mobileMoneyAmount ?? Decimal.zero;
      final paymentTotal = cash + mobileMoney;

      if (paymentTotal != totalAmount) {
        throw CreateSaleException(
          'Total paiement ($paymentTotal) ne correspond pas au montant ($totalAmount)',
        );
      }
    }

    // Création de la vente via le repository (qui gère la persistance + la
    // synchro)
    return repository.createSale(
      items: items,
      totalAmount: totalAmount,
      vatAmount: vatAmount,
      paymentMethod: paymentMethod,
      discount: discount,
      cashAmount: cashAmount,
      mobileMoneyAmount: mobileMoneyAmount,
    );
  }
}
