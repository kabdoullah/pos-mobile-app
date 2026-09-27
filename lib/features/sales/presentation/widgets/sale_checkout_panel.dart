import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../../domain/entities/sale.dart';
import '../providers/cart_provider.dart';
import '../providers/checkout_provider.dart';
import 'cash_payment_panel.dart';
import 'mixed_payment_panel.dart';
import 'payment_method_selector.dart';

/// Zone fixe en bas de la caisse : total, moyen de paiement et bouton
/// d'encaissement, toujours accessibles au pouce.
class SaleCheckoutPanel extends ConsumerWidget {
  /// Crée le panneau d'encaissement.
  const SaleCheckoutPanel({
    required this.onSubmit,
    required this.onEditDiscount,
    required this.isSubmitting,
    super.key,
  });

  /// Enregistre la vente.
  final VoidCallback onSubmit;

  /// Ouvre la saisie de la remise globale.
  final VoidCallback onEditDiscount;

  /// Enregistrement en cours.
  final bool isSubmitting;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final cart = ref.watch(cartProvider);
    final checkout = ref.watch(checkoutProvider);
    final notifier = ref.read(checkoutProvider.notifier);
    final total = cart.total;
    final units = cart.unitCount;
    final canSubmit = !cart.isEmpty && checkout.canSubmitFor(total);

    final ctaLabel = switch (checkout.method) {
      PaymentMethod.cash ||
      PaymentMethod.mixed => 'Encaisser ${formatFcfa(total)}',
      _ => 'Confirmer · ${formatFcfa(total)}',
    };

    return Material(
      color: cs.surfaceContainerLow,
      elevation: 8,
      shadowColor: cs.shadow.withValues(alpha: 0.3),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.sm,
            AppSpacing.md,
            AppSpacing.md,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (cart.discount != null) ...[
                _SummaryRow(
                  label: 'Sous-total',
                  value: formatFcfa(cart.subtotal),
                ),
                _SummaryRow(
                  label: 'Remise',
                  value: '−${formatFcfa(cart.discountAmount)}',
                  onTap: onEditDiscount,
                ),
                const SizedBox(height: AppSpacing.xs),
              ],
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    units <= 1 ? '$units article' : '$units articles',
                    style: AppTypography.bodySmall.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                  if (!cart.isEmpty && cart.discount == null)
                    TextButton.icon(
                      onPressed: onEditDiscount,
                      icon: const Icon(Icons.local_offer_outlined, size: 18),
                      label: const Text('Remise'),
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                  const Spacer(),
                  Text(
                    'Total ',
                    style: AppTypography.labelMedium.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                  AmountDisplay(amount: total, size: AmountSize.large),
                ],
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOutCubic,
                alignment: Alignment.topCenter,
                child: cart.isEmpty
                    ? const SizedBox(width: double.infinity)
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: AppSpacing.sm),
                          PaymentMethodSelector(
                            selected: checkout.method,
                            onSelected: notifier.selectMethod,
                          ),
                          ...switch (checkout.method) {
                            PaymentMethod.cash => [
                              const SizedBox(height: AppSpacing.md),
                              CashPaymentPanel(
                                total: total,
                                checkout: checkout,
                                onCashChanged: notifier.setCashReceived,
                              ),
                            ],
                            PaymentMethod.mixed => [
                              const SizedBox(height: AppSpacing.md),
                              MixedPaymentPanel(
                                total: total,
                                checkout: checkout,
                                onCashChanged: notifier.setCashReceived,
                                onMobileMoneyChanged: notifier.setMobileMoney,
                              ),
                            ],
                            _ => const <Widget>[],
                          },
                        ],
                      ),
              ),
              const SizedBox(height: AppSpacing.md),
              PrimaryButton(
                label: ctaLabel,
                icon: Icons.point_of_sale,
                isLoading: isSubmitting,
                onPressed: canSubmit ? onSubmit : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Ligne sous-total / remise au-dessus du total ; [onTap] rend la ligne
/// modifiable.
class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value, this.onTap});

  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final style = AppTypography.bodySmall.copyWith(color: cs.onSurfaceVariant);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            Text(label, style: style),
            if (onTap != null) ...[
              const SizedBox(width: AppSpacing.xs),
              Icon(Icons.edit_outlined, size: 14, color: cs.onSurfaceVariant),
            ],
            const Spacer(),
            Text(value, style: style),
          ],
        ),
      ),
    );
  }
}
