import 'package:decimal/decimal.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/cart_item.dart';
import '../../../catalog/domain/entities/product.dart';

part 'cart_provider.g.dart';

/// CartState contient les articles du panier courant.
class CartState {
  /// Crée un nouveau CartState avec la liste d'articles donnée.
  const CartState({required this.items});

  /// Articles actuellement dans le panier.
  final List<CartItem> items;

  /// Montant total en FCFA (somme des totaux de ligne).
  Decimal get total =>
      items.fold(Decimal.zero, (sum, item) => sum + item.lineTotal);

  /// Nombre d'articles (produits distincts).
  int get itemCount => items.length;

  /// Nombre d'unités (somme des quantités).
  int get unitCount => items.fold(0, (sum, item) => sum + item.quantity);

  /// Indique si le panier est vide.
  bool get isEmpty => items.isEmpty;

  /// Retourne une copie de cet état avec les valeurs mises à jour.
  CartState copyWith({List<CartItem>? items}) {
    return CartState(items: items ?? this.items);
  }
}

/// CartNotifier gère l'état du panier.
@riverpod
class Cart extends _$Cart {
  @override
  CartState build() => const CartState(items: []);

  /// Quantité de [productId] déjà dans le panier (0 s'il n'y est pas).
  int quantityOf(String productId) {
    for (final item in state.items) {
      if (item.productId == productId) return item.quantity;
    }
    return 0;
  }

  /// Ajoute [quantity] unités d'un produit au panier (ou les ajoute à la ligne
  /// existante). Retourne false si le stock serait dépassé, true sinon.
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
      final updated = CartItem(
        productId: existing.productId,
        productName: existing.productName,
        unitPrice: existing.unitPrice,
        quantity: newQty,
        availableStock: product.currentStock ?? existing.availableStock,
      );
      final newItems = [...state.items];
      newItems[existingIndex] = updated;
      state = state.copyWith(items: newItems);
    } else {
      if (product.currentStock != null && product.currentStock! < quantity) {
        return false;
      }
      final newItem = CartItem(
        productId: product.id,
        productName: product.name,
        unitPrice: product.unitPrice,
        quantity: quantity,
        availableStock: product.currentStock,
      );
      state = state.copyWith(items: [...state.items, newItem]);
    }
    return true;
  }

  /// Retire un produit du panier par son ID.
  void removeItem(String productId) {
    final newItems = state.items
        .where((item) => item.productId != productId)
        .toList();
    state = state.copyWith(items: newItems);
  }

  /// Met à jour la quantité d'un produit (retiré si qté ≤ 0, plafonnée au stock
  /// disponible).
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
      final updated = CartItem(
        productId: item.productId,
        productName: item.productName,
        unitPrice: item.unitPrice,
        quantity: clamped,
        availableStock: item.availableStock,
      );
      final newItems = [...state.items];
      newItems[itemIndex] = updated;
      state = state.copyWith(items: newItems);
    }
  }

  /// Vide le panier.
  void clear() {
    state = const CartState(items: []);
  }
}
