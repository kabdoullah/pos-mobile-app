import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../../domain/entities/sale.dart';
import '../providers/cart_provider.dart';
import '../providers/checkout_provider.dart';

/// Zone fixe en bas de la caisse : nombre d'articles (accès au panier),
/// remise, total et bouton d'encaissement, toujours accessibles au pouce.
///
/// Le moyen de paiement et les espèces reçues sont dans `SalePaymentSection`,
/// sous le panier.
class SaleCheckoutPanel extends ConsumerWidget {
  /// Crée le panneau d'encaissement.
  const SaleCheckoutPanel({
    required this.onSubmit,
    required this.onEditDiscount,
    required this.isSubmitting,
    required this.onShowCart,
    super.key,
  });

  /// Enregistre la vente.
  final VoidCallback onSubmit;

  /// Ouvre la saisie de la remise globale.
  final VoidCallback onEditDiscount;

  /// Enregistrement en cours.
  final bool isSubmitting;

  /// Fait défiler la page jusqu'au panier.
  final VoidCallback onShowCart;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final cart = ref.watch(cartProvider);
    final checkout = ref.watch(checkoutProvider);
    final total = cart.total;
    final units = cart.unitCount;
    final canSubmit = !cart.isEmpty && checkout.canSubmitFor(total);
    // Le champ espèces peut être hors écran (plus bas dans le défilement) :
    // on rappelle ici pourquoi l'encaissement est bloqué.
    final remaining = checkout.remainingFor(total);
    final blocker = cart.isEmpty || canSubmit
        ? null
        : checkout.method != PaymentMethod.mixed
        ? checkout.cashErrorFor(total)
        : remaining > Decimal.zero
        ? 'Reste à payer : ${formatFcfa(remaining)}'
        : 'Dépasse le total de ${formatFcfa(-remaining)}';

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
                  Flexible(
                    child: _CartCountButton(
                      units: units,
                      onPressed: onShowCart,
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
                  // Gros montant + bouton Remise sur écran étroit : le total
                  // se réduit au lieu de déborder.
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          children: [
                            Text(
                              'Total ',
                              style: AppTypography.labelMedium.copyWith(
                                color: cs.onSurfaceVariant,
                              ),
                            ),
                            AmountDisplay(
                              amount: total,
                              size: AmountSize.large,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (blocker != null)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.xs),
                  child: Text(
                    blocker,
                    textAlign: TextAlign.end,
                    style: AppTypography.bodySmall.copyWith(color: cs.error),
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

/// Nombre d'articles ; appuyer fait défiler jusqu'au panier.
class _CartCountButton extends StatelessWidget {
  const _CartCountButton({required this.units, required this.onPressed});

  final int units;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final label = units <= 1 ? '$units article' : '$units articles';
    if (units == 0) {
      return Text(
        label,
        style: AppTypography.bodySmall.copyWith(color: cs.onSurfaceVariant),
      );
    }
    return TextButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.expand_more, size: 18),
      iconAlignment: IconAlignment.end,
      label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
      style: TextButton.styleFrom(
        visualDensity: VisualDensity.compact,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      ),
    );
  }
}
