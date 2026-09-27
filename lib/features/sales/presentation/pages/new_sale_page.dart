import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/network/error_mapper.dart';
import '../../../../core/providers/connectivity_provider.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/sync/sync_orchestrator.dart';
import '../../../../core/widgets/index.dart';
import '../../../auth/providers/store_provider.dart';
import '../../../catalog/domain/entities/product.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/discount.dart';
import '../../domain/entities/sale.dart';
import '../providers/cart_provider.dart';
import '../providers/checkout_provider.dart';
import '../providers/sales_providers.dart';
import '../providers/scan_provider.dart';
import '../widgets/discount_sheet.dart';
import '../widgets/product_search_results.dart';
import '../widgets/quantity_sheet.dart';
import '../widgets/sale_cart.dart';
import '../widgets/sale_checkout_panel.dart';
import '../widgets/sale_confirmation_sheet.dart';
import '../widgets/sale_scanner_panel.dart';
import '../widgets/sale_search_bar.dart';
import '../widgets/sale_toast.dart';

/// Écran de caisse (onglet Caisse) : scan/recherche, panier, paiement et
/// encaissement sur un seul écran. La confirmation s'affiche en bottom sheet,
/// puis la caisse est immédiatement prête pour la vente suivante.
///
/// La page reste montée quand on change d'onglet : le panier est conservé.
class NewSalePage extends ConsumerStatefulWidget {
  /// Crée l'écran de caisse.
  const NewSalePage({super.key});

  @override
  ConsumerState<NewSalePage> createState() => _NewSalePageState();
}

class _NewSalePageState extends ConsumerState<NewSalePage> {
  late final MobileScannerController _scanner;
  bool _isPermissionGranted = false;
  bool _isCheckingPermission = true;
  bool _isScannerOpen = true;
  bool _isCameraPaused = false;
  bool _isTorchOn = false;

  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();
  Timer? _searchDebounce;
  String _query = '';

  SaleToastData? _toast;
  Timer? _toastTimer;

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _scanner = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
      torchEnabled: false,
      // Les codes-barres du catalogue sont en EAN-13/EAN-8. Restreindre les
      // formats évite que ML Kit lise un EAN-13 mal cadré comme un symbole
      // UPC-A/Code128 parasite (somme de contrôle valide mais faux).
      formats: const [BarcodeFormat.ean13, BarcodeFormat.ean8],
    );
    // La caméra se replie pendant la saisie d'une recherche.
    _searchFocus.addListener(() => setState(() {}));
    unawaited(_checkPermission());
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _toastTimer?.cancel();
    _searchController.dispose();
    _searchFocus.dispose();
    unawaited(_scanner.dispose());
    super.dispose();
  }

  Future<void> _checkPermission() async {
    final status = await Permission.camera.request();
    if (!mounted) return;
    setState(() {
      _isPermissionGranted = status.isGranted;
      _isCheckingPermission = false;
    });
  }

  // ---------------------------------------------------------------------------
  // Caméra
  // ---------------------------------------------------------------------------

  void _toggleScanner() {
    setState(() {
      _isScannerOpen = !_isScannerOpen;
      if (!_isScannerOpen) _isTorchOn = false;
    });
    if (_isScannerOpen) _searchFocus.unfocus();
  }

  Future<void> _toggleTorch() async {
    await _scanner.toggleTorch();
    if (!mounted) return;
    setState(() => _isTorchOn = !_isTorchOn);
  }

  /// Démonte la caméra pendant [action] (feuille, page empilée) : pas de scan
  /// en arrière-plan, caméra libérée.
  Future<T?> _withCameraPaused<T>(Future<T?> Function() action) async {
    setState(() {
      _isCameraPaused = true;
      _isTorchOn = false;
    });
    try {
      return await action();
    } finally {
      if (mounted) setState(() => _isCameraPaused = false);
    }
  }

  Future<void> _onBarcodeDetected(BarcodeCapture capture) async {
    final rawValue = capture.barcodes.firstOrNull?.rawValue;
    if (rawValue == null || !mounted) return;
    // Normalise avant le scan et avant de passer au formulaire produit.
    final code = rawValue.trim().replaceAll(RegExp(r'[\x00-\x1F\x7F]'), '');
    if (code.isEmpty) return;

    final outcome = await ref.read(scanControllerProvider.notifier).scan(code);
    if (!mounted) return;

    switch (outcome.result) {
      case ScanResult.cooldown:
        return;
      case ScanResult.added:
      case ScanResult.quantityIncremented:
        unawaited(HapticFeedback.mediumImpact());
        _showToast(
          SaleToastData(
            message: '${outcome.product?.name ?? 'Produit'} ajouté',
            kind: SaleToastKind.success,
          ),
        );
      case ScanResult.stockExceeded:
        unawaited(HapticFeedback.heavyImpact());
        _showStockExceeded(outcome.product);
      case ScanResult.notFound:
        _showToast(
          SaleToastData(
            message: 'Produit introuvable',
            kind: SaleToastKind.info,
            actionLabel: 'Créer',
            onAction: () => _withCameraPaused(
              () => context.push(Routes.productNew, extra: code),
            ),
          ),
          duration: const Duration(seconds: 5),
        );
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
    // Retour immédiat au panier après un ajout depuis la recherche.
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

  Future<void> _openProduct(Product product) async {
    final stock = product.currentStock;
    final inCart = ref.read(cartProvider.notifier).quantityOf(product.id);
    final remaining = stock == null ? null : stock - inCart;
    if (remaining != null && remaining <= 0) {
      _showStockExceeded(product);
      return;
    }
    final result = await _withCameraPaused(
      () => showQuantitySheet(
        context,
        productName: product.name,
        unitPrice: product.sellingPrice,
        stock: stock,
        maxQuantity: remaining,
        confirmLabel: 'Ajouter',
      ),
    );
    if (result case QuantityChosen(:final quantity) when mounted) {
      _addProduct(product, quantity: quantity);
    }
  }

  /// Ligne du panier : quantité, puis réduction si demandée — la caméra
  /// reste en pause pendant les deux feuilles.
  Future<void> _editCartItem(CartItem item) async {
    await _withCameraPaused(() async {
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
      if (!mounted) return null;
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
      return null;
    });
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
    final result = await _withCameraPaused(
      () => showDiscountSheet(
        context,
        title: 'Remise sur la vente',
        gross: cart.subtotal,
        initial: cart.discount,
      ),
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

  Future<void> _clearCart() async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Vider le panier ?',
      message: 'Tous les articles seront supprimés.',
      confirmLabel: 'Vider',
      isDangerous: true,
    );
    if (confirmed) ref.read(cartProvider.notifier).clear();
  }

  // ---------------------------------------------------------------------------
  // Encaissement
  // ---------------------------------------------------------------------------

  Future<void> _submit() async {
    final cart = ref.read(cartProvider);
    final checkout = ref.read(checkoutProvider);
    final total = cart.total;
    if (_isSubmitting || cart.isEmpty || !checkout.canSubmitFor(total)) return;

    FocusScope.of(context).unfocus();
    setState(() => _isSubmitting = true);

    try {
      // Copie des articles AVANT le vidage du panier (impression du ticket).
      final items = List<CartItem>.of(cart.items);
      final isMixed = checkout.method == PaymentMethod.mixed;
      final change = checkout.changeFor(total);

      final sale = await ref.read(
        submitSaleProvider(
          totalAmount: total,
          // TVA non appliquée au MVP (pas de taux par produit).
          vatAmount: Decimal.zero,
          paymentMethod: checkout.method,
          cashAmount: isMixed ? checkout.cashReceived : null,
          mobileMoneyAmount: isMixed ? checkout.mobileMoney : null,
        ).future,
      );

      // Vider ici — submitSaleProvider (auto-dispose) peut être disposé
      // pendant l'await, rendant ref.mounted false et sautant le vidage.
      ref.read(cartProvider.notifier).clear();
      ref.read(checkoutProvider.notifier).reset();

      // Synchro immédiate si en ligne : le serveur attribue le numéro de reçu
      // en quelques secondes au lieu d'attendre le prochain cycle périodique.
      if (ref.read(isOnlineProvider).value ?? false) {
        unawaited(ref.read(syncOrchestratorProvider.notifier).syncNow());
      }
      unawaited(HapticFeedback.heavyImpact());

      if (!mounted) return;
      setState(() => _isSubmitting = false);
      await _withCameraPaused(
        () => showSaleConfirmationSheet(
          context,
          sale: sale,
          items: items,
          change: change,
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorToFrench(e))));
      }
    } finally {
      if (mounted && _isSubmitting) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Garde les contrôleurs auto-dispose en vie tant que la caisse est
    // affichée — ils sont utilisés via ref.read pendant des awaits.
    ref.watch(scanControllerProvider);
    ref.watch(checkoutProvider);
    final cart = ref.watch(cartProvider);
    final storeName = ref.watch(storeConfigProvider).value?.name;

    // Onglet masqué (IndexedStack de la shell) : TickerMode est désactivé.
    // La caméra est alors démontée, sinon elle tournerait en arrière-plan.
    final isTabVisible = TickerMode.valuesOf(context).enabled;
    final keyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;
    final isSearchFocused = _searchFocus.hasFocus;
    final showCamera =
        _isScannerOpen && !keyboardOpen && !isSearchFocused && _query.isEmpty;
    // Pendant une recherche au clavier, les résultats prennent toute la place.
    final showCheckout = !(keyboardOpen && isSearchFocused);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Nouvelle vente'),
            if (storeName != null && storeName.isNotEmpty)
              Text(
                storeName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.captionText.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
        actions: [
          const OfflineStatusIndicator(),
          IconButton(
            tooltip: 'Imprimante',
            icon: const Icon(Icons.print_outlined),
            onPressed: () =>
                _withCameraPaused(() => context.push(Routes.bluetoothSetup)),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.xs,
                AppSpacing.md,
                AppSpacing.sm,
              ),
              child: SaleSearchBar(
                controller: _searchController,
                focusNode: _searchFocus,
                onChanged: _onSearchChanged,
                isScannerOpen: _isScannerOpen,
                onToggleScanner: _toggleScanner,
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              child: showCamera
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.md,
                        0,
                        AppSpacing.md,
                        AppSpacing.sm,
                      ),
                      child: SaleScannerPanel(
                        controller: _scanner,
                        isActive: !_isCameraPaused && isTabVisible,
                        isPermissionGranted: _isPermissionGranted,
                        isCheckingPermission: _isCheckingPermission,
                        isTorchOn: _isTorchOn,
                        onDetect: _onBarcodeDetected,
                        onToggleTorch: _toggleTorch,
                        onOpenAppSettings: openAppSettings,
                      ),
                    )
                  : const SizedBox(width: double.infinity),
            ),
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: _query.isNotEmpty
                        ? ProductSearchResults(
                            query: _query,
                            onQuickAdd: _addProduct,
                            onOpen: _openProduct,
                          )
                        : SaleCart(
                            items: cart.items,
                            onQuantityChanged: ref
                                .read(cartProvider.notifier)
                                .updateQuantity,
                            onRemove: ref
                                .read(cartProvider.notifier)
                                .removeItem,
                            onItemTap: _editCartItem,
                            onClear: _clearCart,
                          ),
                  ),
                  Positioned(
                    top: AppSpacing.xs,
                    left: AppSpacing.md,
                    right: AppSpacing.md,
                    child: SaleToast(data: _toast, onDismiss: _dismissToast),
                  ),
                ],
              ),
            ),
            if (showCheckout)
              ConstrainedBox(
                // Clavier ouvert sur un montant : le panneau défile au lieu
                // de déborder.
                constraints: BoxConstraints(
                  maxHeight: constraints.maxHeight * 0.75,
                ),
                child: SingleChildScrollView(
                  clipBehavior: Clip.none,
                  child: SaleCheckoutPanel(
                    onSubmit: _submit,
                    onEditDiscount: _editCartDiscount,
                    isSubmitting: _isSubmitting,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
