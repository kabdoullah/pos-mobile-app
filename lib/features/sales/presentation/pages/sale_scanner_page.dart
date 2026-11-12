import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../../../catalog/presentation/pages/barcode_scanner_page.dart';
import '../providers/cart_provider.dart';
import '../providers/scan_provider.dart';
import '../widgets/sale_scanner_panel.dart';
import '../widgets/sale_toast.dart';

/// Ouvre le scanner plein écran au-dessus de la navigation. Renvoie le
/// code-barres d'un produit inconnu à créer (« Créer » sur le toast), sinon
/// `null`.
Future<String?> showSaleScannerPage(BuildContext context) {
  return Navigator.of(context, rootNavigator: true).push<String>(
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => const SaleScannerPage(),
    ),
  );
}

/// Article scanné pendant cette ouverture du scanner.
class _Scanned {
  _Scanned({required this.productId, required this.name, required this.price});

  final String productId;
  final String name;
  final Decimal price;
  int count = 1;
}

/// Scanner en continu : chaque scan réussi vibre, s'annonce (« Céleste
/// ajouté ») et s'ajoute à la liste des derniers articles ; le bouton du bas
/// rappelle le panier (« Terminer · 4 articles · 3 025 FCFA »).
class SaleScannerPage extends ConsumerStatefulWidget {
  /// Crée le scanner.
  const SaleScannerPage({super.key});

  @override
  ConsumerState<SaleScannerPage> createState() => _SaleScannerPageState();
}

class _SaleScannerPageState extends ConsumerState<SaleScannerPage>
    with WidgetsBindingObserver {
  late final MobileScannerController _controller =
      createRetailScannerController();
  bool _isCheckingPermission = true;
  bool _isPermissionGranted = false;
  bool _isTorchOn = false;
  bool _isInForeground = true;

  /// Derniers articles scannés, le plus récent en tête.
  final List<_Scanned> _scanned = [];

  SaleToastData? _toast;
  Timer? _toastTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    unawaited(_checkPermission());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _toastTimer?.cancel();
    unawaited(_controller.dispose());
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Caméra libérée quand l'app passe en arrière-plan.
    final foreground = state == AppLifecycleState.resumed;
    if (foreground != _isInForeground) {
      setState(() => _isInForeground = foreground);
    }
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
    await _controller.toggleTorch();
    if (!mounted) return;
    setState(() => _isTorchOn = !_isTorchOn);
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    final raw = capture.barcodes.firstOrNull?.rawValue;
    if (raw == null) return;
    final code = raw.trim().replaceAll(RegExp(r'[\x00-\x1F\x7F]'), '');
    if (code.isEmpty) return;

    final outcome = await ref.read(scanControllerProvider.notifier).scan(code);
    if (!mounted) return;
    final product = outcome.product;

    switch (outcome.result) {
      case ScanResult.cooldown:
        return;
      case ScanResult.added || ScanResult.quantityIncremented:
        unawaited(HapticFeedback.mediumImpact());
        if (product != null) {
          setState(() {
            final index = _scanned.indexWhere((s) => s.productId == product.id);
            if (index >= 0) {
              final item = _scanned.removeAt(index)..count += 1;
              _scanned.insert(0, item);
            } else {
              _scanned.insert(
                0,
                _Scanned(
                  productId: product.id,
                  name: product.name,
                  price: product.sellingPrice,
                ),
              );
            }
          });
        }
        _showToast(
          SaleToastData(
            message: '${product?.name ?? 'Produit'} ajouté',
            kind: SaleToastKind.success,
            showDismiss: false,
          ),
        );
      case ScanResult.stockExceeded:
        unawaited(HapticFeedback.heavyImpact());
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
      case ScanResult.notFound:
        _showToast(
          SaleToastData(
            message: 'Produit introuvable',
            kind: SaleToastKind.info,
            actionLabel: 'Créer',
            // La création se fait depuis la vente : le scanner se ferme en
            // rendant le code à pré-remplir.
            onAction: () => Navigator.of(context).pop(code),
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

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final cart = ref.watch(cartProvider);
    final units = cart.unitCount;
    final finishLabel = units == 0
        ? 'Terminer'
        : 'Terminer · ${units == 1 ? '1 article' : '$units articles'} · '
              '${formatFcfa(cart.total)}';
    // Le scanner occupe le haut de l'écran, sans dépasser la moitié.
    final cameraHeight = (MediaQuery.sizeOf(context).height * 0.4).clamp(
      200.0,
      320.0,
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Fermer le scanner',
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Scanner'),
        actions: [
          if (_isPermissionGranted)
            TextButton.icon(
              onPressed: _toggleTorch,
              icon: Icon(
                _isTorchOn ? Icons.flashlight_off : Icons.flashlight_on,
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
            controller: _controller,
            isActive: _isInForeground,
            isPermissionGranted: _isPermissionGranted,
            isCheckingPermission: _isCheckingPermission,
            isTorchOn: _isTorchOn,
            onDetect: _onDetect,
            onToggleTorch: _toggleTorch,
            onOpenAppSettings: openAppSettings,
            height: cameraHeight,
            borderRadius: 0,
            showTorchButton: false,
            hint: 'Placez le code-barres dans le cadre',
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm + 6,
              AppSpacing.md,
              AppSpacing.sm,
            ),
            child: Text(
              'Derniers articles scannés',
              style: AppTypography.labelLarge.copyWith(color: cs.onSurface),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: _scanned.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                          ),
                          child: Text(
                            'Chaque code lu ajoute un article au panier.',
                            style: AppTypography.bodyMedium.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        )
                      : ListView.separated(
                          itemCount: _scanned.length,
                          separatorBuilder: (_, _) =>
                              Divider(height: 1, color: cs.outlineVariant),
                          itemBuilder: (context, index) => _ScannedRow(
                            item: _scanned[index],
                            isLatest: index == 0,
                          ),
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
          BottomActionBar(
            children: [
              PrimaryButton(
                label: finishLabel,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Un article scanné : nom, prix et nombre de lectures ; le dernier est mis
/// en avant.
class _ScannedRow extends StatelessWidget {
  const _ScannedRow({required this.item, required this.isLatest});

  final _Scanned item;
  final bool isLatest;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final foreground = isLatest ? cs.onPrimaryContainer : cs.onSurface;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      color: isLatest ? cs.primaryContainer : cs.surface,
      constraints: const BoxConstraints(minHeight: 64),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodyMedium.copyWith(
                    color: foreground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  formatFcfa(item.price),
                  style: AppTypography.bodyMedium.copyWith(
                    color: isLatest ? cs.onPrimaryContainer : cs.primary,
                    fontFeatures: AppTypography.tabularFigures,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '× ${item.count}',
            style: AppTypography.bodyMedium.copyWith(
              color: foreground,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
