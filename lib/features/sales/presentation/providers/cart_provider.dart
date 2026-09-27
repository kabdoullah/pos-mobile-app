import 'package:decimal/decimal.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/discount.dart';
import '../../../catalog/domain/entities/product.dart';

part 'cart_provider.g.dart';

/// CartState contient les articles du panier courant et la remise globale.
class CartState {
  /// Crée un nouveau CartState avec la liste d'articles donnée.
  const CartState({required this.items, this.discount});

  /// Articles actuellement dans le panier.
  final List<CartItem> items;

  /// Remise globale sur la vente (null = aucune), distincte des réductions de
  /// ligne portées par chaque [CartItem].
  final Discount? discount;

  /// Sous-total en FCFA : somme des totaux nets des lignes.
  Decimal get subtotal =>
      items.fold(Decimal.zero, (sum, item) => sum + item.lineTotal);

  /// Montant de la remise globale (0 sans remise).
  Decimal get discountAmount => discount?.amountOn(subtotal) ?? Decimal.zero;

  /// Montant total à encaisser en FCFA (sous-total − remise globale).
  Decimal get total => subtotal - discountAmount;

  /// Nombre d'articles (produits distincts).
  int get itemCount => items.length;

  /// Nombre d'unités (somme des quantités).
  int get unitCount => items.fold(0, (sum, item) => sum + item.quantity);

  /// Indique si le panier est vide.
  bool get isEmpty => items.isEmpty;
}

/// CartNotifier gère l'état du panier.
@riverpod
class Cart extends _$Cart {
  @override
  CartState build() => const CartState(items: []);

  /// Remplace les lignes en ajustant la remise globale au nouveau sous-total
  /// (un montant ne peut dépasser le sous-total).
  void _setItems(List<CartItem> items) {
    final next = CartState(items: items);
    state = CartState(
      items: items,
      discount: state.discount?.fitTo(next.subtotal),
    );
  }

  /// Quantité de [productId] déjà dans le panier (0 s'il n'y est pas).
  int quantityOf(String productId) {
    for (final item in state.items) {
      if (item.productId == productId) return item.quantity;
    }
    return 0;
  }

  /// Ajoute [quantity] unités d'un produit au panier (ou les ajoute à la ligne
  /// existante). Retourne false si le stock serait dépassé, true sinon.
  ///
  /// Les prix de vente et d'achat sont figés à l'ajout (ADR-0009).
  bool addItem(Product product, {int quantity = 1}) {
    assert(quantity > 0, 'La quantité ajoutée doit être positive');
    final existingIndex = state.items.indexWhere(
      (item) => item.productId == product.id,
    );

    if (existingIndex >= 0) {
      final existing = state.items[existingIndex];
      final newQty = existing.quantity + quantity;
      if (product.currentStock != null && newQty > product.currentStock!) {
        return false;
      }
      final updated = existing
          .withQuantity(newQty)
          .copyWith(
            availableStock: product.currentStock ?? existing.availableStock,
          );
      final newItems = [...state.items];
      newItems[existingIndex] = updated;
      _setItems(newItems);
    } else {
      if (product.currentStock != null && product.currentStock! < quantity) {
        return false;
      }
      final newItem = CartItem(
        productId: product.id,
        productName: product.name,
        unitPrice: product.sellingPrice,
        purchaseUnitPrice: product.purchasePrice,
        quantity: quantity,
        availableStock: product.currentStock,
      );
      _setItems([...state.items, newItem]);
    }
    return true;
  }

  /// Retire un produit du panier par son ID.
  void removeItem(String productId) {
    _setItems(
      state.items.where((item) => item.productId != productId).toList(),
    );
  }

  /// Met à jour la quantité d'un produit (retiré si qté ≤ 0, plafonnée au stock
  /// disponible). Une réduction en montant est ajustée au nouveau total brut.
  void updateQuantity(String productId, int qty) {
    if (qty <= 0) {
      removeItem(productId);
      return;
    }

    final itemIndex = state.items.indexWhere(
      (item) => item.productId == productId,
    );
    if (itemIndex >= 0) {
      final item = state.items[itemIndex];
      final clamped = item.availableStock != null
          ? qty.clamp(1, item.availableStock!)
          : qty;
      final newItems = [...state.items];
      newItems[itemIndex] = item.withQuantity(clamped);
      _setItems(newItems);
    }
  }

  /// Applique (ou retire, avec `null`) la réduction d'une ligne.
  ///
  /// [discount] doit avoir été validée par `Discount.validate` sur le total
  /// brut de la ligne.
  void setItemDiscount(String productId, Discount? discount) {
    final itemIndex = state.items.indexWhere(
      (item) => item.productId == productId,
    );
    if (itemIndex < 0) return;
    final newItems = [...state.items];
    newItems[itemIndex] = newItems[itemIndex].copyWith(discount: discount);
    _setItems(newItems);
  }

  /// Applique (ou retire, avec `null`) la remise globale.
  ///
  /// [discount] doit avoir été validée sur le sous-total du panier.
  void setDiscount(Discount? discount) {
    state = CartState(items: state.items, discount: discount);
  }

  /// Vide le panier (lignes et remise globale).
  void clear() {
    state = const CartState(items: []);
  }
}
