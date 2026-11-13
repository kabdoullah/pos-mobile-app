import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/index.dart';
import '../../../catalog/domain/entities/product.dart';
import '../../../catalog/presentation/pages/barcode_scanner_page.dart';
import '../providers/cart_provider.dart';
import '../providers/scan_provider.dart';
import '../widgets/sale_scanner_panel.dart';
import '../widgets/sale_toast.dart';

/// Sortie du scanner vers l'écran Vendre.
enum SaleScannerExit {
  /// Ouvrir l'écran Encaisser.
  checkout,

  /// Caméra refusée : saisir le code dans la recherche.
  manualEntry,
}

/// Scanner de vente plein écran : scan en continu (vibration + toast à chaque
/// article), liste des articles scannés et « Encaisser » sans revenir au
/// catalogue. Le panier est le même que celui de l'écran Vendre.
class SaleScannerPage extends ConsumerStatefulWidget {
  /// Crée le scanner de vente.
  const SaleScannerPage({super.key});

  @override
  ConsumerState<SaleScannerPage> createState() => _SaleScannerPageState();
}

class _SaleScannerPageState extends ConsumerState<SaleScannerPage> {
  late final MobileScannerController _scanner;
  bool _isPermissionGranted = false;
  bool _isCheckingPermission = true;
  bool _isCameraPaused = false;
  bool _isTorchOn = false;

  SaleToastData? _toast;
  Timer? _toastTimer;

  @override
  void initState() {
    super.initState();
    _scanner = createRetailScannerController();
    unawaited(_checkPermission());
  }

  @override
  void dispose() {
    _toastTimer?.cancel();
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

  Future<void> _toggleTorch() async {
    await _scanner.toggleTorch();
    if (!mounted) return;
    setState(() => _isTorchOn = !_isTorchOn);
  }

  /// Démonte la caméra pendant [action] (page empilée) : pas de scan en
  /// arrière-plan, caméra libérée.
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
            message: 'Code $code introuvable',
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
            : 'Stock insuffisant · disponible : $stock',
        kind: SaleToastKind.error,
      ),
      duration: const Duration(milliseconds: 2500),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Garde le contrôleur auto-dispose en vie : utilisé via ref.read pendant
    // des awaits.
    ref.watch(scanControllerProvider);
    final cart = ref.watch(cartProvider);
    final colors = AppColors.of(context);
    final units = cart.unitCount;
    // Dernier scanné en tête.
    final items = cart.items.reversed.toList();

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Scanner'),
        actions: [
          if (_isPermissionGranted)
            TextButton.icon(
              onPressed: _toggleTorch,
              icon: Icon(
                _isTorchOn ? Icons.flashlight_off : Icons.flashlight_on,
                size: 20,
              ),
              label: Text(_isTorchOn ? 'Éteindre' : 'Lampe'),
            ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SaleScannerPanel(
            controller: _scanner,
            isActive: !_isCameraPaused,
            isPermissionGranted: _isPermissionGranted,
            isCheckingPermission: _isCheckingPermission,
            onDetect: _onBarcodeDetected,
            onOpenAppSettings: openAppSettings,
            onManualEntry: () => context.pop(SaleScannerExit.manualEntry),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.md + AppSpacing.xs,
              AppSpacing.md,
              AppSpacing.sm,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Expanded(
                  child: Text(
                    'SCANNÉS',
                    style: AppTypography.overline.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ),
                Text(
                  units == 1 ? '1 article' : '$units articles',
                  style: AppTypography.bodySmall.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: items.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          child: Text(
                            'Les articles scannés s’ajoutent ici.',
                            textAlign: TextAlign.center,
                            style: AppTypography.body.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final item = items[index];
                            return _ScannedRow(
                              name: item.productName,
                              price: formatFcfa(item.unitPrice),
                              quantity: item.quantity,
                            );
                          },
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
          DecoratedBox(
            decoration: BoxDecoration(
              color: colors.surface,
              border: Border(top: BorderSide(color: colors.border)),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm + AppSpacing.xs,
                ),
                child: PrimaryButton(
                  label: cart.isEmpty
                      ? 'Encaisser'
                      : 'Encaisser · ${formatFcfa(cart.total)}',
                  onPressed: cart.isEmpty
                      ? null
                      : () => context.pop(SaleScannerExit.checkout),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Article scanné : nom, prix unitaire et quantité.
class _ScannedRow extends StatelessWidget {
  const _ScannedRow({
    required this.name,
    required this.price,
    required this.quantity,
  });

  final String name;
  final String price;
  final int quantity;

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
          vertical: AppSpacing.sm,
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 40),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodyStrong,
                    ),
                    Text(
                      price,
                      style: AppTypography.bodySmall.copyWith(
                        color: colors.textSecondary,
                        fontFeatures: AppTypography.tabularFigures,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '× $quantity',
                style: AppTypography.bodyStrong.copyWith(
                  fontFeatures: AppTypography.tabularFigures,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
