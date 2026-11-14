import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/index.dart';
import '../../../cash_register/presentation/providers/cash_register_providers.dart';
import '../../../cash_register/presentation/pages/open_cash_session_page.dart';
import '../../../catalog/domain/entities/product.dart';
import '../../../catalog/presentation/providers/category_providers.dart';
import '../../../inventory/presentation/providers/inventory_providers.dart';
import '../providers/cart_provider.dart';
import '../providers/checkout_provider.dart';
import '../providers/sales_providers.dart';
import '../widgets/product_browser.dart';
import '../widgets/product_search_results.dart';
import '../widgets/quantity_sheet.dart';
import '../widgets/sale_cart_bar.dart';
import '../widgets/sale_confirmation_sheet.dart';
import '../widgets/sale_search_bar.dart';
import '../widgets/sale_toast.dart';
import 'sale_scanner_page.dart';

/// Écran Vendre (onglet) : recherche et « Scanner » en haut, catégories en
/// onglets, puis le catalogue où toucher une ligne ajoute une unité. La barre
/// du bas mène à l'écran Encaisser ; la confirmation de vente s'affiche ici
/// au retour, et l'écran est aussitôt prêt pour la vente suivante.
///
/// La page reste montée quand on change d'onglet : le panier est conservé.
class NewSalePage extends ConsumerStatefulWidget {
  /// Crée l'écran Vendre.
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
  void dispose() {
    _searchDebounce?.cancel();
    _toastTimer?.cancel();
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
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

  void _showStockExceeded(Product product) {
    final stock = product.currentStock;
    _showToast(
      SaleToastData(
        message: stock == null
            ? 'Stock insuffisant'
            : 'Stock insuffisant · disponible : $stock',
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

  /// Ajoute [quantity] unités : le trait « au panier » et le stepper de la
  /// ligne suffisent comme retour. Après un ajout depuis la recherche, retour
  /// immédiat au catalogue.
  void _addProduct(Product product, {int quantity = 1}) {
    final added = ref
        .read(cartProvider.notifier)
        .addItem(product, quantity: quantity);
    if (!added) {
      unawaited(HapticFeedback.heavyImpact());
      _showStockExceeded(product);
      return;
    }
    unawaited(HapticFeedback.selectionClick());
    if (_query.isNotEmpty) _clearSearch();
  }

  void _decrease(Product product) {
    final quantity = ref.read(cartProvider.notifier).quantityOf(product.id);
    if (quantity <= 1) {
      _removeCartItem(product.id);
    } else {
      ref.read(cartProvider.notifier).updateQuantity(product.id, quantity - 1);
    }
  }

  /// Retire une ligne sans confirmation et propose de l'annuler : un geste
  /// involontaire ne coûte pas la ligne.
  void _removeCartItem(String productId) {
    final items = ref.read(cartProvider).items;
    final index = items.indexWhere((item) => item.productId == productId);
    if (index < 0) return;
    final item = items[index];
    ref.read(cartProvider.notifier).removeItem(productId);
    _showToast(
      SaleToastData(
        message: '${item.productName} retiré du panier',
        kind: SaleToastKind.success,
        actionLabel: 'Annuler',
        showDismiss: false,
        onAction: () =>
            ref.read(cartProvider.notifier).restoreItem(item, index),
      ),
      duration: const Duration(seconds: 4),
    );
  }

  /// Saisie détaillée de la quantité (appui long, chiffre du stepper).
  Future<void> _editQuantity(Product product) async {
    final stock = product.currentStock;
    final inCart = ref.read(cartProvider.notifier).quantityOf(product.id);
    if (inCart == 0 && stock != null && stock <= 0) {
      _showStockExceeded(product);
      return;
    }
    final result = await showQuantitySheet(
      context,
      productName: product.name,
      unitPrice: product.sellingPrice,
      stock: stock,
      initialQuantity: inCart == 0 ? 1 : inCart,
      maxQuantity: stock,
      confirmLabel: inCart == 0
          ? 'Ajouter au panier'
          : 'Mettre à jour le panier',
    );
    if (!mounted) return;
    if (result case QuantityChosen(:final quantity)) {
      if (inCart == 0) {
        _addProduct(product, quantity: quantity);
      } else {
        ref.read(cartProvider.notifier).updateQuantity(product.id, quantity);
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Scanner, encaissement, caisse
  // ---------------------------------------------------------------------------

  Future<void> _openScanner() async {
    _clearSearch();
    final exit = await context.push<SaleScannerExit>(Routes.saleScanner);
    if (!mounted) return;
    switch (exit) {
      case SaleScannerExit.checkout:
        await _openCheckout();
      case SaleScannerExit.manualEntry:
        _searchFocus.requestFocus();
      case null:
        break;
    }
  }

  Future<void> _openCheckout() async {
    _searchFocus.unfocus();
    final completed = await context.push<CompletedSale>(Routes.saleCheckout);
    if (completed == null || !mounted) return;
    await showSaleConfirmationSheet(
      context,
      sale: completed.sale,
      items: completed.items,
      change: completed.change,
    );
  }

  Future<void> _openCashSession() async {
    final opened = await showOpenCashSession(context);
    if (opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Caisse ouverte. Vous pouvez encaisser.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Garde le brouillon de paiement (auto-dispose) pendant tout le parcours
    // de vente : l'écran Encaisser s'empile au-dessus de celui-ci.
    ref.watch(checkoutProvider);
    final cart = ref.watch(cartProvider);
    final session = ref.watch(activeCashSessionProvider);
    // Tant que l'état est inconnu, la caisse est supposée ouverte : pas de
    // bandeau qui clignote au démarrage.
    final isRegisterClosed = session.hasValue && session.value == null;
    final categories = ref.watch(categoriesProvider).value ?? const [];
    // Catégorie supprimée entre-temps : le filtre retombe sur « Tous ».
    final categoryId = categories.any((c) => c.id == _categoryId)
        ? _categoryId
        : null;
    final isSearching = _query.isNotEmpty;
    final keyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;
    final cartQuantities = {
      for (final item in cart.items) item.productId: item.quantity,
    };

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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              0,
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
            UnderlineTabs<String?>(
              tabs: [
                (value: null, label: 'Tous'),
                for (final category in categories)
                  (value: category.id, label: category.name),
              ],
              selected: categoryId,
              onSelected: (id) => setState(() => _categoryId = id),
            ),
          if (isRegisterClosed) const _RegisterClosedNote(),
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: isSearching
                      ? ProductSearchResults(
                          query: _query,
                          onAdd: _addProduct,
                          onDecrease: _decrease,
                          onEditQuantity: _editQuantity,
                          onScan: _openScanner,
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
                              onDecrease: _decrease,
                              onEditQuantity: _editQuantity,
                              onRetry: () =>
                                  ref.invalidate(stockProductsProvider),
                              onAddProduct: () =>
                                  context.push(Routes.productNew),
                            ),
                          ],
                        ),
                ),
                Positioned(
                  left: AppSpacing.md,
                  right: AppSpacing.md,
                  bottom: AppSpacing.sm,
                  child: SaleToast(data: _toast, onDismiss: _dismissToast),
                ),
              ],
            ),
          ),
          // Pendant une saisie au clavier, les résultats prennent la place.
          if (!keyboardOpen)
            SaleCartBar(
              units: cart.unitCount,
              total: cart.total,
              isRegisterClosed: isRegisterClosed,
              onCheckout: _openCheckout,
              onOpenRegister: _openCashSession,
            ),
        ],
      ),
    );
  }
}

/// Bandeau « Caisse fermée », annoncé avant d'encaisser.
class _RegisterClosedNote extends StatelessWidget {
  const _RegisterClosedNote();

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(bottom: BorderSide(color: colors.border)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm + AppSpacing.xs,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 7),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.warning,
                  shape: BoxShape.circle,
                ),
                child: const SizedBox.square(dimension: 8),
              ),
            ),
            const SizedBox(width: AppSpacing.sm + 2),
            Expanded(
              child: Text.rich(
                const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Caisse fermée. ',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    TextSpan(
                      text:
                          'Ouvrez-la pour pouvoir encaisser. Votre panier '
                          'est gardé.',
                    ),
                  ],
                ),
                style: AppTypography.body.copyWith(fontSize: 15, height: 1.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
