import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/network/error_mapper.dart';
import '../../../../core/widgets/index.dart';
import '../../../cash_register/domain/repositories/cash_register_repository.dart';
import '../../../cash_register/presentation/widgets/open_cash_session_sheet.dart';
import '../../domain/entities/sale.dart';
import '../providers/cart_provider.dart';
import '../providers/checkout_provider.dart';
import '../providers/sales_providers.dart';
import '../widgets/cash_payment_panel.dart';
import '../widgets/mixed_payment_panel.dart';
import '../widgets/payment_method_selector.dart';

/// Ouvre l'écran Paiement en plein écran, au-dessus de la barre de
/// navigation. Retourne la vente enregistrée, ou `null` si le vendeur revient
/// au panier.
Future<CompletedSale?> showSalePaymentPage(BuildContext context) {
  return Navigator.of(context, rootNavigator: true).push(
    MaterialPageRoute<CompletedSale>(builder: (_) => const SalePaymentPage()),
  );
}

/// Écran Paiement : montant à payer, moyen de paiement, montant reçu et
/// monnaie à rendre, puis « Valider la vente » en bas — même libellé quel
/// que soit le moyen.
///
/// Le brouillon (`checkoutProvider`) est celui de la caisse : revenir au
/// panier ne perd rien.
class SalePaymentPage extends ConsumerStatefulWidget {
  /// Crée l'écran Paiement.
  const SalePaymentPage({super.key});

  @override
  ConsumerState<SalePaymentPage> createState() => _SalePaymentPageState();
}

class _SalePaymentPageState extends ConsumerState<SalePaymentPage> {
  Future<void> _validate() async {
    FocusScope.of(context).unfocus();
    try {
      final completed = await ref
          .read(saleSubmissionProvider.notifier)
          .submit();
      if (completed == null || !mounted) return;
      unawaited(HapticFeedback.heavyImpact());
      Navigator.of(context).pop(completed);
    } catch (e) {
      if (!mounted) return;
      if (e is CashRegisterException &&
          e.code == CashRegisterException.noOpenSession) {
        await _openCashSession();
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorToFrench(e))));
    }
  }

  /// Caisse fermée entre-temps : rien n'a été enregistré, panier et paiement
  /// sont conservés. Le vendeur ouvre la caisse puis valide de nouveau.
  Future<void> _openCashSession() async {
    final opened = await showOpenCashSessionSheet(context);
    if (opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Caisse ouverte. Validez de nouveau la vente.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final cart = ref.watch(cartProvider);
    final checkout = ref.watch(checkoutProvider);
    final notifier = ref.read(checkoutProvider.notifier);
    final isSubmitting = ref.watch(saleSubmissionProvider);
    final total = cart.total;
    final canSubmit = !cart.isEmpty && checkout.canSubmitFor(total);

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Paiement'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.sm + 4,
                AppSpacing.md,
                AppSpacing.md,
              ),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'À payer',
                        style: AppTypography.bodyLarge.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerRight,
                        child: AmountDisplay(
                          amount: total,
                          size: AmountSize.hero,
                        ),
                      ),
                    ),
                  ],
                ),
                if (cart.discount != null)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Remise de ${formatFcfa(cart.discountAmount)} incluse',
                      style: AppTypography.bodyMedium.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ),
                const SizedBox(height: AppSpacing.md),
                PaymentMethodSelector(
                  selected: checkout.method,
                  onSelected: notifier.selectMethod,
                ),
                const SizedBox(height: AppSpacing.md),
                switch (checkout.method) {
                  PaymentMethod.cash => CashPaymentPanel(
                    total: total,
                    checkout: checkout,
                    onCashChanged: notifier.setCashReceived,
                  ),
                  PaymentMethod.mixed => MixedPaymentPanel(
                    total: total,
                    checkout: checkout,
                    onCashChanged: (cash) =>
                        notifier.setMixedCash(cash, total: total),
                  ),
                  _ => MobileMoneyCheckHint(
                    amount: total > Decimal.zero ? total : Decimal.zero,
                  ),
                },
              ],
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              color: cs.surface,
              border: Border(top: BorderSide(color: cs.outlineVariant)),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.sm + 4,
                  AppSpacing.md,
                  AppSpacing.sm + 4,
                ),
                child: PrimaryButton(
                  label: 'Valider la vente',
                  loadingLabel: 'Enregistrement…',
                  isLoading: isSubmitting,
                  onPressed: canSubmit ? _validate : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
