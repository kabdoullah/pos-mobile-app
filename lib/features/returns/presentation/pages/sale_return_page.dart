import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/network/error_mapper.dart';
import '../../../../core/widgets/index.dart';
import '../../../cash_register/domain/repositories/cash_register_repository.dart';
import '../../../cash_register/presentation/widgets/open_cash_session_sheet.dart';
import '../../../sales/domain/entities/sale.dart';
import '../../domain/entities/return_labels.dart';
import '../../domain/entities/returnable_line.dart';
import '../../domain/entities/sale_return.dart';
import '../providers/returns_providers.dart';
import '../widgets/return_confirmation_sheet.dart';
import '../widgets/return_success_view.dart';
import '../../../catalog/presentation/widgets/product_thumbnail.dart';
import '../../../../app/theme/app_colors.dart';

/// Retour d'articles d'une vente, en deux étapes : quoi et combien, puis
/// l'état de chaque article (et son effet sur le stock), le motif et le
/// remboursement ; enfin récapitulatif et confirmation. Une vente ne se
/// modifie jamais : le retour crée son propre reçu.
class SaleReturnPage extends ConsumerWidget {
  /// Crée une [SaleReturnPage].
  const SaleReturnPage({required this.sale, super.key});

  /// Vente d'origine.
  final Sale sale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(returnDraftProvider(sale));
    final linesAsync = ref.watch(returnableLinesProvider(sale));
    final saved = draft.saved;

    if (saved != null) {
      return AppScaffold(
        title: 'Retour enregistré',
        body: ReturnSuccessView(
          sale: sale,
          saved: saved,
          lines: linesAsync.value ?? const [],
          onDone: () => Navigator.of(context).pop(),
        ),
      );
    }

    return AppScaffold(
      title: 'Retour · vente n° ${sale.receiptNumber}',
      body: linesAsync.when(
        loading: () => ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: const [
            SkeletonBox(height: 96),
            SizedBox(height: AppSpacing.sm),
            SkeletonBox(height: 96),
          ],
        ),
        error: (e, _) => EmptyState(
          icon: Icons.error_outline,
          title: 'Vente introuvable',
          message: errorToFrench(e),
        ),
        data: (lines) {
          if (lines.isEmpty) {
            return const EmptyState(
              icon: Icons.receipt_long_outlined,
              title: 'Articles indisponibles',
              message:
                  'Le détail de cette vente n’est pas encore sur cet '
                  'appareil. Synchronisez puis réessayez.',
            );
          }
          if (!lines.any((l) => l.returnableQuantity > 0)) {
            return const EmptyState(
              icon: Icons.assignment_turned_in_outlined,
              title: 'Tout a déjà été retourné',
              message: 'Aucun article de cette vente ne peut plus être rendu.',
            );
          }
          return _ReturnForm(sale: sale, lines: lines, draft: draft);
        },
      ),
    );
  }
}

class _ReturnForm extends ConsumerStatefulWidget {
  const _ReturnForm({
    required this.sale,
    required this.lines,
    required this.draft,
  });

  final Sale sale;
  final List<ReturnableLine> lines;
  final ReturnDraftState draft;

  @override
  ConsumerState<_ReturnForm> createState() => _ReturnFormState();
}

class _ReturnFormState extends ConsumerState<_ReturnForm> {
  // Verrou d'envoi : empêche un second enregistrement pendant le premier.
  bool _saving = false;

  /// Étape affichée : 1 = articles et quantités, 2 = état et remboursement.
  int _step = 1;

  ReturnDraft get _draft => ref.read(returnDraftProvider(widget.sale).notifier);

  Future<void> _continue() async {
    final draft = widget.draft;
    final reason = draft.reason;
    if (reason == null) return;
    final confirmed = await showReturnConfirmationSheet(
      context,
      selections: draft.selections(widget.lines),
      reason: reason,
      note: draft.note,
      refundMethod: draft.refundMethod,
      total: draft.refundTotal(widget.lines),
    );
    if (!confirmed || !mounted) return;

    setState(() => _saving = true);
    var cashRegisterClosed = false;
    try {
      final saved = await ref
          .read(saleReturnSubmissionProvider.notifier)
          .submit(sale: widget.sale, lines: widget.lines, draft: draft);
      if (mounted) _draft.markSaved(saved);
    } catch (e) {
      if (e is CashRegisterException &&
          e.code == CashRegisterException.noOpenSession) {
        cashRegisterClosed = true;
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Retour non enregistré : ${errorToFrench(e)}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
    if (cashRegisterClosed && mounted) await _openCashSession();
  }

  /// Remboursement en espèces caisse fermée : rien n'est enregistré et la
  /// saisie est conservée. Le commerçant ouvre la caisse puis valide de
  /// nouveau lui-même.
  Future<void> _openCashSession() async {
    final opened = await showOpenCashSessionSheet(context);
    if (opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Caisse ouverte. Validez de nouveau le retour.'),
        ),
      );
    }
  }

  /// Choisit l'état d'un article ; le motif, s'il n'est pas encore choisi,
  /// est pré-rempli d'après l'état (modifiable).
  void _setCondition(String saleItemId, ItemCondition condition) {
    _draft.setCondition(saleItemId, condition);
    if (widget.draft.reason != null) return;
    final reason = switch (condition) {
      ItemCondition.damaged => ReturnReason.damaged,
      ItemCondition.defective => ReturnReason.defective,
      _ => null,
    };
    if (reason != null) _draft.setReason(reason);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final muted = AppTypography.bodyMedium.copyWith(color: cs.onSurfaceVariant);
    final draft = widget.draft;
    final total = draft.refundTotal(widget.lines);
    final selections = draft.selections(widget.lines);
    final hasItems = selections.isNotEmpty;
    final missing = _step == 1
        ? (hasItems ? null : 'Choisissez au moins un article')
        : draft.reason == null
        ? 'Choisissez le motif'
        : draft.needsNote
        ? 'Précisez le motif'
        : null;

    final Widget content = _step == 1
        ? ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              Text('Étape 1 sur 2 · Que rapporte le client ?', style: muted),
              const SizedBox(height: AppSpacing.sm),
              AppListGroup(
                children: [
                  for (final line in widget.lines)
                    _SelectLine(
                      line: line,
                      quantity: draft.quantityOf(line.saleItemId),
                      onQuantity: (q) => _draft.setQuantity(line.saleItemId, q),
                    ),
                ],
              ),
            ],
          )
        : ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              Text('Étape 2 sur 2 · État et remboursement', style: muted),
              const SizedBox(height: AppSpacing.sm),
              for (final selection in selections)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _ConditionCard(
                    line: selection.line,
                    quantity: selection.quantity,
                    condition: selection.condition,
                    onCondition: (c) =>
                        _setCondition(selection.line.saleItemId, c),
                  ),
                ),
              const SizedBox(height: AppSpacing.sm),
              const Text('Motif', style: AppTypography.labelLarge),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  for (final reason in ReturnReason.values)
                    ChoiceChip(
                      label: Text(reason.label),
                      selected: draft.reason == reason,
                      onSelected: (_) => _draft.setReason(reason),
                    ),
                ],
              ),
              if (draft.reason == ReturnReason.other) ...[
                const SizedBox(height: AppSpacing.sm),
                AppTextField(
                  label: 'Précisez le motif',
                  errorText: draft.needsNote ? 'Commentaire obligatoire' : null,
                  onChanged: _draft.setNote,
                  maxLength: 500,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              const Text('Remboursement', style: AppTypography.labelLarge),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  for (final method in RefundMethod.values)
                    ChoiceChip(
                      label: Text(method.label),
                      selected: draft.refundMethod == method,
                      onSelected: (_) => _draft.setRefundMethod(method),
                    ),
                ],
              ),
              if (widget.sale.paymentMethod == PaymentMethod.mixed)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.xs),
                  child: Text(
                    'Vente payée en mixte : choisissez comment vous '
                    'remboursez le client.',
                    style: AppTypography.bodySmall.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ),
              const SizedBox(height: AppSpacing.md),
              _RefundBox(method: draft.refundMethod, total: total),
            ],
          );

    // Retour système à l'étape 2 : revenir à l'étape 1, pas quitter l'écran.
    return PopScope(
      canPop: _step == 1,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) setState(() => _step = 1);
      },
      child: Column(
        children: [
          Expanded(child: content),
          BottomActionBar(
            children: [
              if (_step == 1)
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'À rembourser',
                        style: AppTypography.bodyMedium,
                      ),
                    ),
                    Text(
                      formatFcfa(total),
                      style: AppTypography.amountLarge.copyWith(
                        color: cs.onSurface,
                        fontFeatures: AppTypography.tabularFigures,
                      ),
                    ),
                  ],
                ),
              if (missing != null)
                Text(
                  missing,
                  style: AppTypography.bodySmall.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
              if (_step == 1)
                PrimaryButton(
                  label: 'Continuer',
                  onPressed: hasItems ? () => setState(() => _step = 2) : null,
                )
              else
                PrimaryButton(
                  label: 'Confirmer le remboursement',
                  isLoading: _saving,
                  loadingLabel: 'Enregistrement…',
                  onPressed: missing == null && !_saving ? _continue : null,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Étape 1 : article à cocher ; une fois coché, la quantité rendue et son
/// montant.
class _SelectLine extends StatelessWidget {
  const _SelectLine({
    required this.line,
    required this.quantity,
    required this.onQuantity,
  });

  final ReturnableLine line;
  final int quantity;
  final ValueChanged<int> onQuantity;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final muted = AppTypography.bodySmall.copyWith(color: cs.onSurfaceVariant);
    final returnable = line.returnableQuantity;
    final selected = quantity > 0;
    final enabled = returnable > 0;

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: enabled ? () => onQuantity(selected ? 0 : 1) : null,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.sm,
            AppSpacing.sm,
            AppSpacing.md,
            AppSpacing.sm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: selected,
                    onChanged: enabled
                        ? (checked) => onQuantity((checked ?? false) ? 1 : 0)
                        : null,
                    semanticLabel: 'Retourner ${line.productName}',
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          line.productName,
                          style: AppTypography.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          enabled
                              ? 'Vendu ${line.soldQuantity} · retournable '
                                    '$returnable'
                              : 'Déjà entièrement retourné',
                          style: muted,
                        ),
                        if (line.discountAmount > Decimal.zero)
                          Text(
                            '${line.soldQuantity} × '
                            '${formatAmount(line.unitPrice)} · réduction '
                            '−${formatAmount(line.discountAmount)}',
                            style: muted,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              if (selected)
                Padding(
                  padding: const EdgeInsets.only(
                    left: 48 + AppSpacing.xs,
                    top: AppSpacing.xs,
                  ),
                  child: Row(
                    children: [
                      QuantityStepper(
                        quantity: quantity,
                        onDecrease: quantity > 1
                            ? () => onQuantity(quantity - 1)
                            : null,
                        onIncrease: quantity < returnable
                            ? () => onQuantity(quantity + 1)
                            : null,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              formatFcfa(line.refundFor(quantity)),
                              style: AppTypography.bodyMedium.copyWith(
                                fontWeight: FontWeight.w700,
                                fontFeatures: AppTypography.tabularFigures,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Étape 2 : état d'un article rendu et son effet sur le stock, en clair.
class _ConditionCard extends StatelessWidget {
  const _ConditionCard({
    required this.line,
    required this.quantity,
    required this.condition,
    required this.onCondition,
  });

  final ReturnableLine line;
  final int quantity;
  final ItemCondition condition;
  final ValueChanged<ItemCondition> onCondition;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final semantic = Theme.of(context).extension<AppSemanticColors>()!;
    final (background, foreground) = condition.restocks
        ? (semantic.successContainer, semantic.onSuccessContainer)
        : (cs.tertiaryContainer, cs.onTertiaryContainer);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ProductThumbnailById(productId: line.productId),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  '${line.productName} × $quantity',
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                formatFcfa(line.refundFor(quantity)),
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  fontFeatures: AppTypography.tabularFigures,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          const Text("État de l'article", style: AppTypography.labelLarge),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final c in ItemCondition.values)
                ChoiceChip(
                  label: Text(c.label),
                  selected: condition == c,
                  onSelected: (_) => onCondition(c),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: 3,
            ),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Text(
              condition.restocks
                  ? 'Sera remis en stock'
                  : 'Ne sera pas remis en stock',
              style: AppTypography.labelMedium.copyWith(
                color: foreground,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// « Rendez au client, en espèces : 2 000 FCFA » : ce qu'il faut faire, en
/// grand.
class _RefundBox extends StatelessWidget {
  const _RefundBox({required this.method, required this.total});

  final RefundMethod method;
  final Decimal total;

  @override
  Widget build(BuildContext context) {
    final semantic = Theme.of(context).extension<AppSemanticColors>()!;
    final color = semantic.onSuccessContainer;
    final isCash = method == RefundMethod.cash;
    return Semantics(
      container: true,
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: semantic.successContainer,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isCash
                  ? 'Rendez au client, en espèces'
                  : 'Rendez au client, par ${method.label}',
              style: AppTypography.labelLarge.copyWith(color: color),
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                formatFcfa(total),
                style: AppTypography.amountDisplay.copyWith(
                  color: color,
                  fontFeatures: AppTypography.tabularFigures,
                ),
              ),
            ),
            Text(
              isCash ? 'Sort du tiroir de la caisse.' : 'Hors tiroir.',
              style: AppTypography.bodySmall.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
