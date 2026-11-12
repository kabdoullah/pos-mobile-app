import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/index.dart';
import '../../../cash_register/presentation/widgets/open_cash_session_sheet.dart';
import '../../../catalog/domain/entities/category.dart';
import '../../../catalog/domain/entities/product.dart';
import '../../../cash_register/presentation/providers/cash_register_providers.dart';
import '../../../catalog/presentation/pages/product_form_page.dart';
import '../../../catalog/presentation/providers/category_providers.dart';
import '../../../inventory/presentation/providers/inventory_providers.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/discount.dart';
import '../providers/cart_provider.dart';
import '../providers/checkout_provider.dart';
import '../providers/scan_provider.dart';
import 'sale_scanner_page.dart';
import '../widgets/discount_sheet.dart';
import '../widgets/product_browser.dart';
import '../widgets/product_search_results.dart';
import '../widgets/quantity_sheet.dart';
import '../widgets/sale_cart_sheet.dart';
import '../widgets/sale_checkout_bar.dart';
import '../widgets/sale_confirmation_sheet.dart';
import '../widgets/sale_search_bar.dart';
import '../widgets/sale_toast.dart';
import 'sale_payment_page.dart';

/// Écran « Vendre » : recherche/scan et catégories en haut, catalogue (toucher
/// une ligne = +1), puis une seule barre fixe « N articles ▴ · Encaisser ».
/// Le panier s'ouvre en bottom sheet, « Encaisser » ouvre l'écran Paiement ;
/// la confirmation s'affiche en bottom sheet et la caisse est aussitôt prête
/// pour la vente suivante.
///
/// Caisse fermée : annoncée par un bandeau avant d'encaisser, panier gardé.
/// La page reste montée quand on change d'onglet : le panier est conservé.
class NewSalePage extends ConsumerStatefulWidget {
  /// Crée l'écran de caisse.
  const NewSalePage({super.key});

  @override
  ConsumerState<NewSalePage> createState() => _NewSalePageState();
}

class _NewSalePageState extends ConsumerState<NewSalePage> {
  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();
  Timer? _searchDebounce;
  String _query = '';
  String? _categoryId;

  SaleToastData? _toast;
  Timer? _toastTimer;

  @override
  void initState() {
    super.initState();
    // La barre d'encaissement se masque pendant la saisie d'une recherche.
    _searchFocus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _toastTimer?.cancel();
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Scanner
  // ---------------------------------------------------------------------------

  /// Scanner plein écran en continu ; un code inconnu revient ici pour créer
  /// le produit, code-barres pré-rempli.
  Future<void> _openScanner() async {
    _searchFocus.unfocus();
    final code = await showSaleScannerPage(context);
    if (code != null && mounted) {
      await context.push(Routes.productNew, extra: code);
    }
  }

  // ---------------------------------------------------------------------------
  // Retours visuels
  // ---------------------------------------------------------------------------

  void _showToast(
    SaleToastData toast, {
    Duration duration = const Duration(milliseconds: 1400),
  }) {
    _toastTimer?.cancel();
    setState(() => _toast = toast);
    _toastTimer = Timer(duration, _dismissToast);
  }

  void _dismissToast() {
    _toastTimer?.cancel();
    if (mounted && _toast != null) setState(() => _toast = null);
  }

  void _showStockExceeded(Product? product) {
    final stock = product?.currentStock;
    _showToast(
      SaleToastData(
        message: stock == null
            ? 'Stock insuffisant'
            : 'Stock insuffisant · Stock disponible : $stock',
        kind: SaleToastKind.error,
      ),
      duration: const Duration(milliseconds: 2500),
    );
  }

  // ---------------------------------------------------------------------------
  // Recherche et panier
  // ---------------------------------------------------------------------------

  void _onSearchChanged(String text) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 250), () {
      if (mounted) setState(() => _query = text.trim());
    });
  }

  void _clearSearch() {
    _searchDebounce?.cancel();
    _searchController.clear();
    _searchFocus.unfocus();
    setState(() => _query = '');
  }

  void _addProduct(Product product, {int quantity = 1}) {
    final added = ref
        .read(cartProvider.notifier)
        .addItem(product, quantity: quantity);
    if (!added) {
      _showStockExceeded(product);
      return;
    }
    unawaited(HapticFeedback.lightImpact());
    // Après un ajout depuis la recherche, retour immédiat à la vue courante.
    _clearSearch();
    _showToast(
      SaleToastData(
        message: quantity > 1
            ? '${product.name} ×$quantity ajouté'
            : '${product.name} ajouté',
        kind: SaleToastKind.success,
      ),
    );
  }

  /// Retire une ligne sans confirmation (croix, glissement, « − » à 1) et
  /// propose de l'annuler : un geste involontaire ne coûte pas la ligne.
  void _removeCartItem(String productId) {
    final items = ref.read(cartProvider).items;
    final index = items.indexWhere((item) => item.productId == productId);
    if (index < 0) return;
    final item = items[index];
    ref.read(cartProvider.notifier).removeItem(productId);
    _showToast(
      SaleToastData(
        message: '${item.productName} retiré',
        kind: SaleToastKind.success,
        actionLabel: 'Annuler',
        showDismiss: false,
        onAction: () =>
            ref.read(cartProvider.notifier).restoreItem(item, index),
      ),
      duration: const Duration(seconds: 4),
    );
  }

  Future<void> _openProduct(Product product) async {
    final stock = product.currentStock;
    final inCart = ref.read(cartProvider.notifier).quantityOf(product.id);
    final remaining = stock == null ? null : stock - inCart;
    if (remaining != null && remaining <= 0) {
      _showStockExceeded(product);
      return;
    }
    final result = await showQuantitySheet(
      context,
      productName: product.name,
      unitPrice: product.sellingPrice,
      stock: stock,
      maxQuantity: remaining,
      confirmLabel: 'Ajouter',
    );
    if (result case QuantityChosen(:final quantity) when mounted) {
      _addProduct(product, quantity: quantity);
    }
  }

  /// Ligne du panier : quantité, puis réduction si demandée.
  Future<void> _editCartItem(CartItem item) async {
    final result = await showQuantitySheet(
      context,
      productName: item.productName,
      unitPrice: item.unitPrice,
      stock: item.availableStock,
      initialQuantity: item.quantity,
      maxQuantity: item.availableStock,
      confirmLabel: 'Mettre à jour',
      offerDiscount: true,
      discount: item.discount,
    );
    if (!mounted) return;
    switch (result) {
      case QuantityChosen(:final quantity):
        ref
            .read(cartProvider.notifier)
            .updateQuantity(item.productId, quantity);
      case DiscountRequested():
        await _editItemDiscount(item);
      case null:
        break;
    }
  }

  Future<void> _editItemDiscount(CartItem item) async {
    final result = await showDiscountSheet(
      context,
      title: 'Réduction · ${item.productName}',
      gross: item.grossTotal,
      initial: item.discount,
    );
    if (result == null || !mounted) return;
    ref
        .read(cartProvider.notifier)
        .setItemDiscount(item.productId, result.discount);
    _showDiscountToast(result.discount);
  }

  /// Remise globale sur le sous-total du panier.
  Future<void> _editCartDiscount() async {
    final cart = ref.read(cartProvider);
    final result = await showDiscountSheet(
      context,
      title: 'Remise sur la vente',
      gross: cart.subtotal,
      initial: cart.discount,
    );
    if (result == null || !mounted) return;
    ref.read(cartProvider.notifier).setDiscount(result.discount);
    _showDiscountToast(result.discount);
  }

  void _showDiscountToast(Discount? discount) {
    _showToast(
      SaleToastData(
        message: discount == null ? 'Réduction retirée' : 'Réduction appliquée',
        kind: SaleToastKind.success,
      ),
    );
  }

  /// Retire une unité depuis le stepper d'une ligne du catalogue ; à 1, la
  /// ligne quitte le panier (avec « Annuler »).
  void _decreaseProduct(Product product) {
    final quantity = ref.read(cartProvider.notifier).quantityOf(product.id);
    if (quantity <= 1) {
      _removeCartItem(product.id);
    } else {
      ref.read(cartProvider.notifier).updateQuantity(product.id, quantity - 1);
    }
  }

  /// Recherche sans résultat : crée le produit sans quitter la vente. Un texte
  /// tout en chiffres est un code-barres, sinon un nom.
  Future<void> _createFromSearch(String query) async {
    final isBarcode = RegExp(r'^\d{6,}$').hasMatch(query);
    await context.push(
      Routes.productNew,
      extra: isBarcode ? query : ProductNamePrefill(query),
    );
  }

  Future<void> _showCart() async {
    final checkout = await showSaleCartSheet(
      context,
      onEditItem: _editCartItem,
      onEditItemDiscount: _editItemDiscount,
      onEditDiscount: _editCartDiscount,
    );
    if (checkout && mounted) await _checkout();
  }

  // ---------------------------------------------------------------------------
  // Encaissement
  // ---------------------------------------------------------------------------

  /// Ouvre l'écran Paiement ; une fois la vente enregistrée (panier déjà
  /// vidé), affiche la confirmation.
  Future<void> _checkout() async {
    FocusScope.of(context).unfocus();
    if (_query.isNotEmpty) _clearSearch();
    final completed = await showSalePaymentPage(context);
    if (completed == null || !mounted) return;
    await showSaleConfirmationSheet(
      context,
      sale: completed.sale,
      items: completed.items,
      change: completed.change,
    );
  }

  /// Caisse fermée : on l'ouvre sans perdre le panier, puis on encaisse.
  Future<void> _openCashSession() async {
    final opened = await showOpenCashSessionSheet(context);
    if (opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Caisse ouverte. Vous pouvez encaisser.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Garde les contrôleurs auto-dispose en vie tant que la caisse est
    // affichée — ils sont utilisés via ref.read pendant des awaits, et le
    // brouillon de paiement survit à un aller-retour panier ↔ paiement.
    ref.watch(scanControllerProvider);
    ref.watch(checkoutProvider);
    final cs = Theme.of(context).colorScheme;
    final cart = ref.watch(cartProvider);
    final cartQuantities = {
      for (final item in cart.items) item.productId: item.quantity,
    };
    final session = ref.watch(activeCashSessionProvider);
    // Tant que l'état est inconnu, pas d'alerte : la règle reste vérifiée à
    // l'enregistrement.
    final isCashClosed = session.hasValue && session.value == null;
    final categories = ref.watch(categoriesProvider).value ?? const [];
    // Catégorie supprimée entre-temps : le filtre retombe sur « Tous ».
    final categoryId = categories.any((c) => c.id == _categoryId)
        ? _categoryId
        : null;

    final keyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;
    final isSearchFocused = _searchFocus.hasFocus;
    final isSearching = _query.isNotEmpty;
    // Pendant une recherche au clavier, les résultats prennent toute la place.
    final showCheckout = !(keyboardOpen && isSearchFocused);
    final divider = BorderSide(color: cs.outlineVariant);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: AppSpacing.md,
        title: const Text('Vendre'),
        actions: [
          const OfflineStatusIndicator(),
          IconButton(
            tooltip: 'Imprimante',
            icon: const Icon(Icons.print_outlined),
            onPressed: () => context.push(Routes.bluetoothSetup),
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: Column(
        children: [
          const SyncStatusIndicator(
            offlineTitle: 'Vous pouvez vendre normalement',
            offlineMessage: 'Les ventes seront envoyées au retour du réseau.',
          ),
          if (isCashClosed) const _CashClosedBanner(),
          DecoratedBox(
            decoration: BoxDecoration(
              color: cs.surface,
              border: Border(bottom: divider),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    AppSpacing.sm,
                    AppSpacing.md,
                    AppSpacing.sm,
                  ),
                  child: SaleSearchBar(
                    controller: _searchController,
                    focusNode: _searchFocus,
                    onChanged: _onSearchChanged,
                    onScan: _openScanner,
                  ),
                ),
                if (!isSearching && categories.isNotEmpty)
                  _CategoryChips(
                    categories: categories,
                    selectedId: categoryId,
                    onSelected: (id) => setState(() => _categoryId = id),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: isSearching
                      ? ProductSearchResults(
                          query: _query,
                          cartQuantities: cartQuantities,
                          onAdd: _addProduct,
                          onDecrease: _decreaseProduct,
                          onOpen: _openProduct,
                          onCreate: _createFromSearch,
                        )
                      : CustomScrollView(
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          slivers: [
                            ProductBrowser(
                              products: ref.watch(stockProductsProvider),
                              categoryId: categoryId,
                              cartQuantities: cartQuantities,
                              onAdd: _addProduct,
                              onDecrease: _decreaseProduct,
                              onOpen: _openProduct,
                              onRetry: () =>
                                  ref.invalidate(stockProductsProvider),
                              onAddProduct: () =>
                                  context.push(Routes.productNew),
                              // Scanner de la caisse : un code inconnu propose
                              // « Créer ».
                              onScanProduct: _openScanner,
                              onImportProducts: () =>
                                  context.push(Routes.productImport),
                            ),
                          ],
                        ),
                ),
                // Retour d'ajout juste au-dessus de la barre : il ne masque
                // pas le produit suivant.
                Positioned(
                  left: AppSpacing.md,
                  right: AppSpacing.md,
                  bottom: AppSpacing.sm,
                  child: SaleToast(data: _toast, onDismiss: _dismissToast),
                ),
              ],
            ),
          ),
          if (showCheckout)
            SaleCheckoutBar(
              isCashClosed: isCashClosed,
              onShowCart: _showCart,
              onCheckout: _checkout,
              onOpenCash: _openCashSession,
            ),
        ],
      ),
    );
  }
}

/// Bandeau fixe « Caisse fermée » : annoncé avant d'encaisser, panier gardé.
class _CashClosedBanner extends StatelessWidget {
  const _CashClosedBanner();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Semantics(
      liveRegion: true,
      child: Container(
        width: double.infinity,
        color: cs.tertiaryContainer,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm + 4,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.lock_outline, color: cs.onTertiaryContainer),
            const SizedBox(width: AppSpacing.sm + 2),
            Expanded(
              child: Text.rich(
                const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Caisse fermée\n',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    TextSpan(
                      text: 'Ouvrez-la pour encaisser. Votre panier est gardé.',
                    ),
                  ],
                ),
                style: AppTypography.bodyMedium.copyWith(
                  color: cs.onTertiaryContainer,
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Filtre de catégories de la caisse : « Tous » puis les catégories du
/// catalogue, sur une ligne défilante.
class _CategoryChips extends StatelessWidget {
  const _CategoryChips({
    required this.categories,
    required this.selectedId,
    required this.onSelected,
  });

  final List<Category> categories;
  final String? selectedId;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        0,
        AppSpacing.md,
        AppSpacing.sm + 4,
      ),
      child: Row(
        children: [
          ChoiceChip(
            label: const Text('Tous'),
            selected: selectedId == null,
            onSelected: (_) => onSelected(null),
          ),
          for (final category in categories) ...[
            const SizedBox(width: AppSpacing.sm),
            ChoiceChip(
              label: Text(category.name),
              selected: selectedId == category.id,
              onSelected: (selected) =>
                  onSelected(selected ? category.id : null),
            ),
          ],
        ],
      ),
    );
  }
}
