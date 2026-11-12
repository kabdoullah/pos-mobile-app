import 'dart:async';
import 'dart:typed_data';

import 'package:decimal/decimal.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/connectivity_provider.dart';
import '../../../../core/sync/sync_orchestrator.dart';
import '../../../cash_register/domain/repositories/cash_register_repository.dart';
import '../../../cash_register/providers/cash_register_di_providers.dart';
import '../../../catalog/domain/entities/product.dart';
import '../../../catalog/providers/catalog_di_providers.dart';
import '../../providers/sales_di_providers.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/sale.dart' as sale_entity;
import '../../domain/repositories/sales_repository.dart';
import 'cart_provider.dart';
import 'checkout_provider.dart';

part 'sales_providers.g.dart';

/// Vente enregistrée, avec ce que l'écran de confirmation affiche : les lignes
/// (copiées avant le vidage du panier, pour le ticket) et la monnaie à rendre.
typedef CompletedSale = ({
  sale_entity.Sale sale,
  List<CartItem> items,
  Decimal change,
});

/// Encaisse le panier courant avec le brouillon de paiement de la caisse.
///
/// `keepAlive` : l'écriture ne doit pas être interrompue par un dispose
/// pendant l'await (sinon la vente est enregistrée mais le panier n'est pas
/// vidé, et le commerçant la ressaisit). L'état vaut `true` pendant
/// l'encaissement.
@Riverpod(keepAlive: true)
class SaleSubmission extends _$SaleSubmission {
  @override
  bool build() => false;

  /// Enregistre la vente (appelle CreateSaleUseCase), vide le panier et le
  /// brouillon de paiement, puis lance une synchro si l'appareil est en
  /// ligne. La vente est rattachée à la session de caisse ouverte. Retourne
  /// `null` sans rien faire si un encaissement est déjà en cours, si le panier
  /// est vide ou si le paiement est incomplet. Lève
  /// [CashRegisterException] (`no_open_session`) sans session ouverte : rien
  /// n'est enregistré, panier et paiement sont conservés. Lève l'erreur du use
  /// case sinon.
  Future<CompletedSale?> submit() async {
    final cart = ref.read(cartProvider);
    final checkout = ref.read(checkoutProvider);
    final total = cart.total;
    if (state || cart.isEmpty || !checkout.canSubmitFor(total)) return null;

    state = true;
    try {
      final session = await ref
          .read(cashRegisterRepositoryProvider)
          .getActiveSession();
      if (session == null) {
        throw const CashRegisterException(CashRegisterException.noOpenSession);
      }
      final isMixed = checkout.method == sale_entity.PaymentMethod.mixed;
      final sale = await ref.read(createSaleUseCaseProvider)(
        items: cart.items,
        discount: cart.discount,
        totalAmount: total,
        // TVA non appliquée au MVP (pas de taux par produit).
        vatAmount: Decimal.zero,
        paymentMethod: checkout.method,
        cashAmount: isMixed ? checkout.cashReceived : null,
        mobileMoneyAmount: isMixed ? checkout.mobileMoney : null,
        cashSessionId: session.id,
      );

      ref.read(cartProvider.notifier).clear();
      ref.read(checkoutProvider.notifier).reset();

      // Synchro immédiate si en ligne : le serveur attribue le numéro de reçu
      // en quelques secondes au lieu d'attendre le prochain cycle périodique.
      if (ref.read(isOnlineProvider).value ?? false) {
        unawaited(ref.read(syncOrchestratorProvider.notifier).syncNow());
      }
      return (sale: sale, items: cart.items, change: checkout.changeFor(total));
    } finally {
      state = false;
    }
  }
}

/// Observe les ventes d'une plage de dates (incluse) — réémet à chaque
/// changement drift.
@riverpod
Stream<List<sale_entity.Sale>> salesHistory(
  Ref ref, {
  required DateTime startDate,
  required DateTime endDate,
}) {
  return ref
      .watch(salesRepositoryProvider)
      .watchSalesByDateRange(startDate, endDate);
}

/// Observe les lignes des ventes d'une plage de dates (incluse), par vente.
@riverpod
Stream<Map<String, List<SaleLinePreview>>> salesHistoryLines(
  Ref ref, {
  required DateTime startDate,
  required DateTime endDate,
}) {
  return ref
      .watch(salesRepositoryProvider)
      .watchSaleLinesByDateRange(startDate, endDate);
}

/// Observe une vente — permet aux écrans ouverts d'afficher le numéro de reçu
/// dès que la synchro l'attribue.
@riverpod
Stream<sale_entity.Sale?> saleById(Ref ref, String id) {
  return ref.watch(salesRepositoryProvider).watchSale(id);
}

/// Observe les lignes d'une vente (vide si la vente vient du serveur).
@riverpod
Stream<List<CartItem>> saleItems(Ref ref, String saleId) {
  return ref.watch(salesRepositoryProvider).watchSaleItems(saleId);
}

/// Nombre de ventes et chiffre d'affaires d'une liste de ventes.
({int count, Decimal total}) salesTotals(List<sale_entity.Sale> sales) => (
  count: sales.length,
  total: sales.fold(Decimal.zero, (sum, sale) => sum + sale.totalAmount),
);

/// Regroupe des ventes triées (plus récente d'abord) par jour local, dans le
/// même ordre — en-têtes de jour de l'historique sur plusieurs jours.
List<({DateTime day, List<sale_entity.Sale> sales})> groupSalesByDay(
  List<sale_entity.Sale> sales,
) {
  final groups = <({DateTime day, List<sale_entity.Sale> sales})>[];
  for (final sale in sales) {
    final local = sale.createdAt.toLocal();
    final day = DateTime(local.year, local.month, local.day);
    if (groups.isNotEmpty && groups.last.day == day) {
      groups.last.sales.add(sale);
    } else {
      groups.add((day: day, sales: [sale]));
    }
  }
  return groups;
}

/// Aperçu des articles d'une vente : « Riz ×21, Lotus ×2 » jusqu'à trois
/// lignes, sinon « Huile ×4 + 3 autres ». Vide sans ligne connue.
String saleLinesPreview(List<SaleLinePreview> lines) {
  String label(SaleLinePreview line) => line.quantity == 1
      ? line.productName
      : '${line.productName} ×${line.quantity}';
  if (lines.length <= 3) return lines.map(label).join(', ');
  return '${label(lines.first)} + ${lines.length - 1} autres';
}

/// Recherche dans l'historique : par produit vendu (nom, sans tenir compte
/// de la casse) ou, pour une saisie numérique, par n° de reçu (préfixe « # »
/// accepté) ou montant. Une vente pas encore synchronisée n'a pas de numéro.
List<sale_entity.Sale> searchSales(
  List<sale_entity.Sale> sales,
  String query, {
  Map<String, List<SaleLinePreview>> lines = const {},
}) {
  final text = query.trim().toLowerCase();
  if (text.isEmpty || text == '#') return sales;
  final isNumeric = RegExp(r'^[#\s  0-9]+$').hasMatch(text);
  final digits = text.replaceAll(RegExp('[^0-9]'), '');
  return sales.where((sale) {
    if (isNumeric) {
      return (sale.receiptNumber > 0 &&
              sale.receiptNumber.toString().contains(digits)) ||
          sale.totalAmount.toString().contains(digits);
    }
    return (lines[sale.id] ?? const []).any(
      (line) => line.productName.toLowerCase().contains(text),
    );
  }).toList();
}

/// Télécharge le reçu PDF d'une vente.
@riverpod
Future<Uint8List> downloadSaleReceiptPdf(Ref ref, String saleId) {
  return ref.read(salesRepositoryProvider).downloadReceiptPdf(saleId);
}

/// Recherche de produits pour la caisse (nom ou code-barres, catalogue local).
///
/// Distincte de `catalogListProvider` : une recherche en caisse ne filtre pas
/// l'onglet Catalogue.
@riverpod
Future<List<Product>> saleProductSearch(Ref ref, String query) async {
  final page = await ref
      .watch(catalogRepositoryProvider)
      .getProducts(query: query, limit: 30);
  return page.items;
}
