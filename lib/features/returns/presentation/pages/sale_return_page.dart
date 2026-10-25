import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/network/error_mapper.dart';
import '../../../../core/widgets/index.dart';
import '../../../sales/domain/entities/sale.dart';
import '../../domain/entities/return_labels.dart';
import '../../domain/entities/returnable_line.dart';
import '../../domain/entities/sale_return.dart';
import '../providers/returns_providers.dart';
import '../widgets/return_confirmation_sheet.dart';
import '../widgets/return_success_view.dart';
import '../../../catalog/presentation/widgets/product_thumbnail.dart';

/// Retour d'articles d'une vente : quantités et état par article, motif,
/// moyen de remboursement, puis récapitulatif et confirmation.
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
      title: 'Retour · vente #${sale.receiptNumber}',
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
    try {
      final saved = await ref
          .read(saleReturnSubmissionProvider.notifier)
          .submit(sale: widget.sale, lines: widget.lines, draft: draft);
      if (mounted) _draft.markSaved(saved);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Retour non enregistré : ${errorToFrench(e)}'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final draft = widget.draft;
    final total = draft.refundTotal(widget.lines);
    final hasItems = draft.selections(widget.lines).isNotEmpty;
    final missing = !hasItems
        ? 'Choisissez au moins un article'
        : draft.reason == null
        ? 'Choisissez le motif'
        : draft.needsNote
        ? 'Précisez le motif'
        : null;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              const SectionHeader(title: 'Articles'),
              for (final line in widget.lines)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _LineCard(
                    line: line,
                    quantity: draft.quantityOf(line.saleItemId),
                    condition: draft.conditionOf(line.saleItemId),
                    onQuantity: (q) => _draft.setQuantity(line.saleItemId, q),
                    onCondition: (c) => _draft.setCondition(line.saleItemId, c),
                  ),
                ),
              const SizedBox(height: AppSpacing.sm),
              const SectionHeader(title: 'Motif'),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.xs,
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
              const SectionHeader(title: 'Remboursement'),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.xs,
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
            ],
          ),
        ),
        // Même panneau que l'encaissement de la caisse : seule surface élevée,
        // le montant à rembourser reste l'objet principal.
        Material(
          color: cs.surface,
          elevation: 8,
          shadowColor: cs.primary.withValues(alpha: 0.35),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppSpacing.radiusLg),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'À rembourser',
                          style: AppTypography.titleMedium,
                        ),
                      ),
                      AmountDisplay(amount: total, size: AmountSize.large),
                    ],
                  ),
                  if (missing != null)
                    Text(
                      missing,
                      style: AppTypography.bodySmall.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  const SizedBox(height: AppSpacing.sm),
                  PrimaryButton(
                    label: 'Continuer',
                    isLoading: _saving,
                    loadingLabel: 'Enregistrement…',
                    onPressed: missing == null && !_saving ? _continue : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Article de la vente : quantités vendue / rendue / retournable, prix figé,
/// sélection de la quantité et de l'état, montant remboursable.
class _LineCard extends StatelessWidget {
  const _LineCard({
    required this.line,
    required this.quantity,
    required this.condition,
    required this.onQuantity,
    required this.onCondition,
  });

  final ReturnableLine line;
  final int quantity;
  final ItemCondition condition;
  final ValueChanged<int> onQuantity;
  final ValueChanged<ItemCondition> onCondition;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final muted = AppTypography.bodySmall.copyWith(color: cs.onSurfaceVariant);
    final returnable = line.returnableQuantity;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProductThumbnailById(productId: line.productId),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(line.productName, style: AppTypography.bodyLarge),
                    Text(
                      '${line.soldQuantity} × ${formatAmount(line.unitPrice)}'
                      '${line.discountAmount > Decimal.zero ? ' · réduction −${formatAmount(line.discountAmount)}' : ''}',
                      style: muted,
                    ),
                    Text(
                      'Vendu ${line.soldQuantity} · déjà rendu '
                      '${line.returnedQuantity} · retournable $returnable',
                      style: muted,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          if (returnable == 0)
            Text('Déjà entièrement retourné', style: muted)
          else
            Row(
              children: [
                QuantityStepper(
                  quantity: quantity,
                  onDecrease: quantity > 0
                      ? () => onQuantity(quantity - 1)
                      : null,
                  onIncrease: quantity < returnable
                      ? () => onQuantity(quantity + 1)
                      : null,
                ),
                const Spacer(),
                if (quantity > 0)
                  AmountDisplay(amount: line.refundFor(quantity)),
              ],
            ),
          if (quantity > 0) ...[
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                for (final c in ItemCondition.values)
                  ChoiceChip(
                    label: Text(c.label),
                    selected: condition == c,
                    onSelected: (_) => onCondition(c),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              condition.restocks
                  ? 'Sera remis en stock'
                  : 'Ne sera pas remis en stock',
              style: muted,
            ),
          ],
        ],
      ),
    );
  }
}
