import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/network/error_mapper.dart';
import '../../../../core/widgets/index.dart';
import '../../../cash_register/domain/repositories/cash_register_repository.dart';
import '../../../cash_register/presentation/pages/open_cash_session_page.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/sale.dart';
import '../providers/cart_provider.dart';
import '../providers/checkout_provider.dart';
import '../providers/sales_providers.dart';
import '../widgets/cart_item_tile.dart';
import '../widgets/discount_sheet.dart';
import '../widgets/payment_method_selector.dart';
import '../widgets/quantity_sheet.dart';
import '../widgets/sale_payment_section.dart';

/// Marges des sur-titres de l'écran.
const _overlinePadding = EdgeInsets.fromLTRB(
  AppSpacing.md,
  AppSpacing.md + AppSpacing.xs,
  AppSpacing.md,
  AppSpacing.sm,
);

/// Écran Encaisser : articles (modifiables en place), remise sur le total,
/// total, paiement, puis la monnaie à rendre et « Valider la vente » fixés en
/// bas.
///
/// Se ferme avec la vente enregistrée ([CompletedSale]) : l'écran Vendre
/// affiche alors la confirmation.
class SaleCheckoutPage extends ConsumerStatefulWidget {
  /// Crée l'écran Encaisser.
  const SaleCheckoutPage({super.key});

  @override
  ConsumerState<SaleCheckoutPage> createState() => _SaleCheckoutPageState();
}

class _SaleCheckoutPageState extends ConsumerState<SaleCheckoutPage> {
  /// Ligne dépliée (édition en place), par id de produit.
  String? _expandedId;

  /// « Mobile money » choisi, opérateur pas encore choisi : le brouillon reste
  /// en espèces mais la validation est bloquée.
  bool _isPickingOperator = false;

  // ---------------------------------------------------------------------------
  // Articles
  // ---------------------------------------------------------------------------

  void _setQuantity(CartItem item, int quantity) {
    if (quantity <= 0) {
      _remove(item);
      return;
    }
    ref.read(cartProvider.notifier).updateQuantity(item.productId, quantity);
  }

  /// Retire une ligne sans confirmation et propose de l'annuler.
  void _remove(CartItem item) {
    final items = ref.read(cartProvider).items;
    final index = items.indexWhere((i) => i.productId == item.productId);
    if (index < 0) return;
    ref.read(cartProvider.notifier).removeItem(item.productId);
    setState(() => _expandedId = null);
    final messenger = ScaffoldMessenger.of(context)..hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text('${item.productName} retiré du panier'),
        action: SnackBarAction(
          label: 'Annuler',
          onPressed: () =>
              ref.read(cartProvider.notifier).restoreItem(items[index], index),
        ),
      ),
    );
  }

  Future<void> _editQuantity(CartItem item) async {
    final result = await showQuantitySheet(
      context,
      productName: item.productName,
      unitPrice: item.unitPrice,
      stock: item.availableStock,
      initialQuantity: item.quantity,
      maxQuantity: item.availableStock,
      confirmLabel: 'Mettre à jour le panier',
      discount: item.discount,
    );
    if (result case QuantityChosen(:final quantity) when mounted) {
      _setQuantity(item, quantity);
    }
  }

  Future<void> _editItemDiscount(CartItem item) async {
    final result = await showDiscountSheet(
      context,
      title: 'Remise · ${item.productName}',
      gross: item.grossTotal,
      initial: item.discount,
    );
    if (result == null || !mounted) return;
    ref
        .read(cartProvider.notifier)
        .setItemDiscount(item.productId, result.discount);
  }

  Future<void> _editCartDiscount() async {
    final cart = ref.read(cartProvider);
    final result = await showDiscountSheet(
      context,
      title: 'Remise sur le total',
      gross: cart.subtotal,
      initial: cart.discount,
    );
    if (result == null || !mounted) return;
    ref.read(cartProvider.notifier).setDiscount(result.discount);
  }

  Future<void> _clearCart() async {
    final units = ref.read(cartProvider).unitCount;
    final confirmed = await showConfirmDialog(
      context,
      title: 'Vider le panier ?',
      message:
          '${units == 1 ? 'L’article sera retiré' : 'Les $units articles '
                    'seront retirés'}. Le stock n’est pas modifié.',
      confirmLabel: 'Vider le panier',
      isDangerous: true,
    );
    if (!confirmed || !mounted) return;
    ref.read(cartProvider.notifier).clear();
    context.pop();
  }

  // ---------------------------------------------------------------------------
  // Paiement
  // ---------------------------------------------------------------------------

  void _selectMode(PaymentMode mode) {
    final notifier = ref.read(checkoutProvider.notifier);
    setState(() => _isPickingOperator = mode == PaymentMode.mobileMoney);
    notifier.selectMethod(switch (mode) {
      PaymentMode.mixed => PaymentMethod.mixed,
      // Mobile money : espèces en attendant l'opérateur (validation bloquée).
      PaymentMode.cash || PaymentMode.mobileMoney => PaymentMethod.cash,
    });
  }

  void _selectOperator(PaymentMethod method) {
    setState(() => _isPickingOperator = false);
    ref.read(checkoutProvider.notifier).selectMethod(method);
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    try {
      final completed = await ref
          .read(saleSubmissionProvider.notifier)
          .submit();
      if (completed == null || !mounted) return;
      unawaited(HapticFeedback.heavyImpact());
      context.pop(completed);
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

  /// Caisse fermée à la validation : rien n'a été enregistré, panier et
  /// paiement sont gardés. Le commerçant ouvre la caisse puis valide de
  /// nouveau lui-même.
  Future<void> _openCashSession() async {
    final opened = await showOpenCashSession(
      context,
      title: 'Ouvrez la caisse pour encaisser',
      message:
          'La vente n’a pas été enregistrée. Votre panier est gardé : comptez '
          'le tiroir, ouvrez la caisse, puis validez de nouveau.',
    );
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
    final checkout = ref.watch(checkoutProvider);
    final cart = ref.watch(cartProvider);
    final isSubmitting = ref.watch(saleSubmissionProvider);
    final colors = AppColors.of(context);
    final total = cart.total;

    // Paiement mixte : la part mobile money suit le total quand le panier
    // change (ligne modifiée, remise).
    ref.listen(cartProvider.select((c) => c.total), (_, next) {
      final draft = ref.read(checkoutProvider);
      if (draft.method == PaymentMethod.mixed && draft.cashReceived != null) {
        ref
            .read(checkoutProvider.notifier)
            .splitMixed(draft.cashReceived, next);
      }
    });

    final mode = _isPickingOperator
        ? PaymentMode.mobileMoney
        : PaymentMode.of(checkout.method);
    final canValidate =
        !cart.isEmpty && !_isPickingOperator && checkout.canSubmitFor(total);

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Encaisser'),
        actions: [
          if (!cart.isEmpty)
            TextButton(
              onPressed: _clearCart,
              style: TextButton.styleFrom(
                foregroundColor: colors.textSecondary,
              ),
              child: const Text('Vider'),
            ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: cart.isEmpty
          ? EmptyState(
              icon: Icons.shopping_basket_outlined,
              title: 'Panier vide',
              message: 'Touchez un produit ou scannez-le pour commencer.',
              actionLabel: 'Retour au catalogue',
              onAction: () => context.pop(),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ListView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                    children: [
                      OverlineHeader(
                        'Articles · ${cart.unitCount}',
                        trailing: 'Touchez une ligne pour la modifier',
                        padding: _overlinePadding,
                      ),
                      FlatList(
                        children: [
                          for (final item in cart.items)
                            CartItemTile(
                              key: ValueKey(item.productId),
                              item: item,
                              isExpanded: _expandedId == item.productId,
                              onTap: () => setState(
                                () =>
                                    _expandedId = _expandedId == item.productId
                                    ? null
                                    : item.productId,
                              ),
                              onQuantityChanged: (q) => _setQuantity(item, q),
                              onEditQuantity: () => _editQuantity(item),
                              onEditDiscount: () => _editItemDiscount(item),
                              onRemove: () => _remove(item),
                            ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                        ),
                        child: _Totals(
                          subtotal: cart.subtotal,
                          discountAmount: cart.discountAmount,
                          hasDiscount: cart.discount != null,
                          total: total,
                          onEditDiscount: _editCartDiscount,
                        ),
                      ),
                      const OverlineHeader(
                        'Paiement',
                        padding: _overlinePadding,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                        ),
                        child: SalePaymentSection(
                          total: total,
                          checkout: checkout,
                          mode: mode,
                          onModeChanged: _selectMode,
                          onOperatorSelected: _selectOperator,
                          onCashChanged: ref
                              .read(checkoutProvider.notifier)
                              .setCashReceived,
                          onMixedCashChanged: (cash) => ref
                              .read(checkoutProvider.notifier)
                              .splitMixed(cash, total),
                        ),
                      ),
                    ],
                  ),
                ),
                _ValidateBar(
                  summary: _summaryFor(checkout, total),
                  isSubmitting: isSubmitting,
                  onValidate: canValidate ? _submit : null,
                ),
              ],
            ),
    );
  }

  /// Ce que la barre fixe annonce, selon le paiement.
  _Summary _summaryFor(CheckoutState checkout, Decimal total) {
    if (_isPickingOperator) {
      return const _Summary(label: 'Choisissez l’opérateur mobile money');
    }
    switch (checkout.method) {
      case PaymentMethod.cash:
        final received = checkout.cashReceived;
        if (received != null && received < total) {
          return _Summary(
            label: 'Il manque',
            amount: total - received,
            tone: StatusTone.error,
          );
        }
        return _Summary(
          label: 'À rendre au client',
          amount: checkout.changeFor(total),
        );
      case PaymentMethod.orangeMoney || PaymentMethod.mtn || PaymentMethod.wave:
        return _Summary(
          label: 'À recevoir · ${paymentMethodLabel(checkout.method)}',
          amount: total,
        );
      case PaymentMethod.mixed:
        final remaining = checkout.remainingFor(total);
        final cash = checkout.cashReceived;
        if (remaining == Decimal.zero && cash != null) {
          return _Summary(
            label:
                'Espèces ${formatAmount(cash)} · Mobile money '
                '${formatAmount(checkout.mobileMoney ?? Decimal.zero)}',
            status: const StatusIndicator(
              label: 'Complet',
              tone: StatusTone.success,
            ),
          );
        }
        if (remaining < Decimal.zero) {
          return _Summary(
            label: 'Dépasse le total de',
            amount: -remaining,
            tone: StatusTone.error,
          );
        }
        return _Summary(
          label: 'Reste à payer',
          amount: remaining,
          tone: StatusTone.warning,
        );
    }
  }
}

/// Contenu de la barre fixe : libellé, puis montant héros ou statut.
class _Summary {
  const _Summary({required this.label, this.amount, this.tone, this.status});

  final String label;
  final Decimal? amount;
  final StatusTone? tone;
  final Widget? status;
}

/// Remise sur le total (lien, ou sous-total et remise modifiable), puis le
/// total.
class _Totals extends StatelessWidget {
  const _Totals({
    required this.subtotal,
    required this.discountAmount,
    required this.hasDiscount,
    required this.total,
    required this.onEditDiscount,
  });

  final Decimal subtotal;
  final Decimal discountAmount;
  final bool hasDiscount;
  final Decimal total;
  final VoidCallback onEditDiscount;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final meta = AppTypography.body.copyWith(
      color: colors.textSecondary,
      fontFeatures: AppTypography.tabularFigures,
    );
    final value = AppTypography.bodyStrong.copyWith(
      fontFeatures: AppTypography.tabularFigures,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!hasDiscount)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: onEditDiscount,
              icon: const Icon(Icons.local_offer_outlined, size: 20),
              label: const Text('Remise sur le total'),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              ),
            ),
          )
        else ...[
          const SizedBox(height: AppSpacing.sm),
          _DefinitionRow(
            label: Text('Sous-total', style: meta),
            value: Text(formatFcfa(subtotal), style: value),
          ),
          InkWell(
            onTap: onEditDiscount,
            child: _DefinitionRow(
              label: Row(
                children: [
                  Text('Remise sur le total', style: meta),
                  const SizedBox(width: AppSpacing.xs),
                  Icon(Icons.edit_outlined, size: 16, color: colors.action),
                ],
              ),
              value: Text('−${formatFcfa(discountAmount)}', style: value),
            ),
          ),
        ],
        DecoratedBox(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: colors.border)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm + 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                const Expanded(
                  child: Text('Total', style: AppTypography.bodyStrong),
                ),
                Text(formatFcfa(total), style: AppTypography.figureLarge),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Ligne libellé / valeur d'un récapitulatif.
class _DefinitionRow extends StatelessWidget {
  const _DefinitionRow({required this.label, required this.value});

  final Widget label;
  final Widget value;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: AppSpacing.minTapTarget),
      child: Row(
        children: [
          Expanded(child: label),
          const SizedBox(width: AppSpacing.sm),
          value,
        ],
      ),
    );
  }
}

/// Barre fixe : monnaie (ou ce qui manque) en chiffre héros, puis « Valider
/// la vente ».
class _ValidateBar extends StatelessWidget {
  const _ValidateBar({
    required this.summary,
    required this.isSubmitting,
    required this.onValidate,
  });

  final _Summary summary;
  final bool isSubmitting;
  final VoidCallback? onValidate;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final amount = summary.amount;
    final status = summary.status;
    final tone = summary.tone;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.sm + AppSpacing.xs,
            AppSpacing.md,
            AppSpacing.sm + AppSpacing.xs,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      summary.label,
                      style: AppTypography.body.copyWith(
                        fontSize: 15,
                        color: colors.textSecondary,
                        fontFeatures: AppTypography.tabularFigures,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  if (amount != null)
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerRight,
                        child: Text(
                          formatFcfa(amount),
                          style: AppTypography.figureHero.copyWith(
                            color: tone?.colorIn(context) ?? colors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ?status,
                ],
              ),
              const SizedBox(height: AppSpacing.sm + 2),
              PrimaryButton(
                label: 'Valider la vente',
                height: AppSpacing.buttonHeight,
                isLoading: isSubmitting,
                onPressed: onValidate,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
