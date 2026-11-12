import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../../domain/entities/cart_item.dart';
import '../providers/cart_provider.dart';
import 'cart_item_tile.dart';
import 'sale_toast.dart';

/// Ouvre le panier en bottom sheet (depuis « N articles » de la barre
/// d'encaissement). Retourne `true` si le vendeur a choisi « Encaisser ».
///
/// Les feuilles de quantité et de remise restent ouvertes par la page (qui
/// met la caméra en pause) : elle les passe en callbacks.
Future<bool> showSaleCartSheet(
  BuildContext context, {
  required ValueChanged<CartItem> onEditItem,
  required ValueChanged<CartItem> onEditItemDiscount,
  required VoidCallback onEditDiscount,
}) async {
  final checkout = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    builder: (_) => SaleCartSheet(
      onEditItem: onEditItem,
      onEditItemDiscount: onEditItemDiscount,
      onEditDiscount: onEditDiscount,
    ),
  );
  return checkout ?? false;
}

/// Panier : lignes avec stepper et remise, remise sur le total, total en
/// 34 sp et « Encaisser ».
class SaleCartSheet extends ConsumerStatefulWidget {
  /// Crée le panier.
  const SaleCartSheet({
    required this.onEditItem,
    required this.onEditItemDiscount,
    required this.onEditDiscount,
    super.key,
  });

  /// Ouvre le choix de quantité d'une ligne.
  final ValueChanged<CartItem> onEditItem;

  /// Ouvre la remise d'une ligne.
  final ValueChanged<CartItem> onEditItemDiscount;

  /// Ouvre la remise sur le total.
  final VoidCallback onEditDiscount;

  @override
  ConsumerState<SaleCartSheet> createState() => _SaleCartSheetState();
}

class _SaleCartSheetState extends ConsumerState<SaleCartSheet> {
  SaleToastData? _toast;
  Timer? _toastTimer;

  @override
  void dispose() {
    _toastTimer?.cancel();
    super.dispose();
  }

  void _dismissToast() {
    _toastTimer?.cancel();
    if (mounted && _toast != null) setState(() => _toast = null);
  }

  /// Retire une ligne sans confirmation et propose de l'annuler.
  void _remove(String productId) {
    final items = ref.read(cartProvider).items;
    final index = items.indexWhere((item) => item.productId == productId);
    if (index < 0) return;
    final item = items[index];
    ref.read(cartProvider.notifier).removeItem(productId);
    _toastTimer?.cancel();
    setState(
      () => _toast = SaleToastData(
        message: '${item.productName} retiré',
        kind: SaleToastKind.success,
        actionLabel: 'Annuler',
        showDismiss: false,
        onAction: () =>
            ref.read(cartProvider.notifier).restoreItem(item, index),
      ),
    );
    _toastTimer = Timer(const Duration(seconds: 4), _dismissToast);
  }

  Future<void> _clear() async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Vider le panier ?',
      message: 'Tous les articles seront supprimés.',
      confirmLabel: 'Vider',
      isDangerous: true,
    );
    if (!confirmed || !mounted) return;
    ref.read(cartProvider.notifier).clear();
    Navigator.of(context).pop(false);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final cart = ref.watch(cartProvider);
    final notifier = ref.read(cartProvider.notifier);
    final units = cart.unitCount;
    final maxHeight = MediaQuery.sizeOf(context).height * 0.85;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: SafeArea(
        top: false,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                0,
                AppSpacing.md,
                AppSpacing.md,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Panier · ${_articles(units)}',
                          style: AppTypography.titleMedium,
                        ),
                      ),
                      if (!cart.isEmpty)
                        TextButton.icon(
                          onPressed: _clear,
                          icon: const Icon(Icons.delete_outline),
                          label: const Text('Vider'),
                          style: TextButton.styleFrom(
                            foregroundColor: cs.error,
                          ),
                        ),
                    ],
                  ),
                  if (cart.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.lg,
                      ),
                      child: Text(
                        'Le panier est vide.',
                        textAlign: TextAlign.center,
                        style: AppTypography.bodyMedium.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    )
                  else
                    Flexible(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: cart.items.length,
                        separatorBuilder: (_, _) => Divider(
                          height: 1,
                          thickness: 1,
                          color: cs.outlineVariant,
                        ),
                        itemBuilder: (context, index) {
                          final item = cart.items[index];
                          return CartItemTile(
                            key: ValueKey(item.productId),
                            item: item,
                            onQuantityChanged: (quantity) => quantity <= 0
                                ? _remove(item.productId)
                                : notifier.updateQuantity(
                                    item.productId,
                                    quantity,
                                  ),
                            onRemove: () => _remove(item.productId),
                            onTap: () => widget.onEditItem(item),
                            onDiscount: () => widget.onEditItemDiscount(item),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: AppSpacing.sm),
                  if (cart.discount == null)
                    SecondaryButton(
                      label: 'Remise sur le total',
                      icon: Icons.local_offer_outlined,
                      onPressed: cart.isEmpty ? null : widget.onEditDiscount,
                    )
                  else ...[
                    _SummaryRow(
                      label: 'Sous-total',
                      value: formatFcfa(cart.subtotal),
                    ),
                    _SummaryRow(
                      label: 'Remise sur le total',
                      value: '−${formatFcfa(cart.discountAmount)}',
                      onTap: widget.onEditDiscount,
                    ),
                  ],
                  const SizedBox(height: 14),
                  const _DashedDivider(),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      const Text('Total', style: AppTypography.bodyLarge),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: AmountDisplay(
                            amount: cart.total,
                            size: AmountSize.hero,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  PrimaryButton(
                    label: 'Encaisser ${formatFcfa(cart.total)}',
                    onPressed: cart.isEmpty
                        ? null
                        : () => Navigator.of(context).pop(true),
                  ),
                ],
              ),
            ),
            Positioned(
              left: AppSpacing.md,
              right: AppSpacing.md,
              bottom: 96,
              child: SaleToast(data: _toast, onDismiss: _dismissToast),
            ),
          ],
        ),
      ),
    );
  }
}

String _articles(int units) =>
    units <= 1 ? '$units article' : '$units articles';

/// Ligne sous-total / remise ; [onTap] la rend modifiable (cible 48 dp).
class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value, this.onTap});

  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final style = AppTypography.bodyMedium.copyWith(
      color: cs.onSurfaceVariant,
      fontFeatures: AppTypography.tabularFigures,
    );
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: onTap == null ? 32 : 48),
        child: Row(
          children: [
            Text(label, style: style),
            if (onTap != null) ...[
              const SizedBox(width: AppSpacing.xs),
              Icon(Icons.edit_outlined, size: 18, color: cs.primary),
            ],
            const Spacer(),
            Text(value, style: style),
          ],
        ),
      ),
    );
  }
}

/// Filet en tirets avant le total, comme sur un ticket.
class _DashedDivider extends StatelessWidget {
  const _DashedDivider();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 1),
      painter: _DashPainter(Theme.of(context).colorScheme.outline),
    );
  }
}

class _DashPainter extends CustomPainter {
  _DashPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    const dash = 5.0;
    const gap = 4.0;
    for (var x = 0.0; x < size.width; x += dash + gap) {
      canvas.drawLine(Offset(x, 0), Offset(x + dash, 0), paint);
    }
  }

  @override
  bool shouldRepaint(_DashPainter oldDelegate) => oldDelegate.color != color;
}
