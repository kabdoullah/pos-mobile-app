import 'dart:typed_data';

import 'package:decimal/decimal.dart';

import '../entities/cart_item.dart';
import '../entities/sale.dart';

/// Totaux agrégés d'une journée — calculés en SQL.
typedef DailyStats = ({
  int saleCount,
  Decimal totalAmount,
  Decimal cashTotal,
  Decimal mobileMoneyTotal,
});

/// Repository abstrait pour les opérations de vente.
abstract class SalesRepository {
  /// Crée et enregistre une nouvelle vente avec ses articles.
  Future<Sale> createSale({
    required List<CartItem> items,
    required Decimal totalAmount,
    required Decimal vatAmount,
    required PaymentMethod paymentMethod,
    Decimal? cashAmount,
    Decimal? mobileMoneyAmount,
  });

  /// Récupère l'historique des ventes, paginé en option.
  Future<List<Sale>> getSales({String? cursor, int limit = 50});

  /// Récupère une vente par ID.
  Future<Sale?> getSale(String id);

  /// Retourne toutes les ventes créées aujourd'hui (fuseau horaire local de
  /// l'appareil).
  Future<List<Sale>> getTodaySales();

  /// Observe les totaux agrégés du jour — réémet à chaque INSERT dans sales.
  Stream<DailyStats> watchTodayStats();

  /// Retourne toutes les ventes créées dans [startDate, endDate] inclus (fuseau
  /// horaire local de l'appareil).
  Future<List<Sale>> getSalesByDateRange(DateTime startDate, DateTime endDate);

  /// Observe toutes les ventes créées dans [startDate, endDate] inclus — réémet
  /// à chaque changement.
  Stream<List<Sale>> watchSalesByDateRange(
    DateTime startDate,
    DateTime endDate,
  );

  /// Télécharge le reçu PDF d'une vente depuis le serveur (ponctuel, pas mis en
  /// cache localement).
  Future<Uint8List> downloadReceiptPdf(String saleId);
}
