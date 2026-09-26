import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../catalog/domain/entities/product.dart';
import '../../../catalog/providers/catalog_di_providers.dart';
import '../../domain/entities/cart_item.dart';
import 'cart_provider.dart';

part 'scan_provider.g.dart';

/// Résultat d'une tentative de scan de code-barres.
enum ScanResult {
  /// Produit ajouté au panier pour la première fois.
  added,

  /// Quantité du produit incrémentée (déjà dans le panier).
  quantityIncremented,

  /// Code-barres introuvable dans le catalogue.
  notFound,

  /// Même code-barres scanné pendant le délai de carence (2 s).
  cooldown,

  /// Produit trouvé mais stock épuisé.
  stockExceeded,
}

/// Résultat d'un scan, avec le produit trouvé quand il existe (pour le retour
/// visuel : nom ajouté, stock disponible).
typedef ScanOutcome = ({ScanResult result, Product? product});

/// Gère le scan de codes-barres : dédoublonnage par délai de carence, recherche
/// dans le catalogue, ajout au panier.
@riverpod
class ScanController extends _$ScanController {
  final Map<String, DateTime> _lastScanTimes = {};
  static const Duration _scanCooldown = Duration(seconds: 2);

  @override
  void build() {}

  /// Traite un code-barres scanné : vérifie le délai de carence, cherche dans
  /// le catalogue, met à jour le panier.
  Future<ScanOutcome> scan(String barcode) async {
    // Normalisation : retire les espaces et les caractères de contrôle GS1
    // avant toute recherche.
    final normalized = barcode.trim().replaceAll(
      RegExp(r'[\x00-\x1F\x7F]'),
      '',
    );
    if (normalized.isEmpty) return (result: ScanResult.notFound, product: null);

    final now = DateTime.now();
    final last = _lastScanTimes[normalized];
    if (last != null && now.difference(last) < _scanCooldown) {
      return (result: ScanResult.cooldown, product: null);
    }
    _lastScanTimes[normalized] = now;
    _lastScanTimes.removeWhere((_, t) => now.difference(t) > _scanCooldown);

    final repo = ref.read(catalogRepositoryProvider);
    final product = await repo.getByBarcode(normalized);
    if (product == null) return (result: ScanResult.notFound, product: null);

    if (!ref.mounted) return (result: ScanResult.notFound, product: null);

    final cartState = ref.read(cartProvider);
    final alreadyInCart = cartState.items.any(
      (CartItem item) => item.productId == product.id,
    );

    final added = ref.read(cartProvider.notifier).addItem(product);
    if (!added) return (result: ScanResult.stockExceeded, product: product);
    return (
      result: alreadyInCart ? ScanResult.quantityIncremented : ScanResult.added,
      product: product,
    );
  }
}
