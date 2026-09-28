import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/index.dart';
import '../../domain/entities/sale.dart';
import '../providers/cart_provider.dart';
import '../providers/checkout_provider.dart';
import 'cash_payment_panel.dart';
import 'mixed_payment_panel.dart';
import 'payment_method_selector.dart';

/// Section « Paiement » sous le panier : moyen de paiement, puis espèces
/// reçues ou répartition d'un paiement mixte. Masquée tant que le panier est
/// vide ; le total et le bouton d'encaissement restent dans
/// `SaleCheckoutPanel`.
class SalePaymentSection extends ConsumerWidget {
  /// Crée la section de paiement.
  const SalePaymentSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    if (cart.isEmpty) return const SizedBox.shrink();
    final checkout = ref.watch(checkoutProvider);
    final notifier = ref.read(checkoutProvider.notifier);
    final total = cart.total;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SectionHeader(title: 'Paiement'),
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
    );
  }
}
