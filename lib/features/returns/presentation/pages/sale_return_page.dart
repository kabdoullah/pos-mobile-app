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
import '../../../../app/theme/app_colors.dart';

/// Retour d'articles d'une vente, en 2 étapes : ce que rapporte le client
/// (quantités), puis l'état de chaque article, le motif et le remboursement ;
/// enfin récapitulatif et confirmation.
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
        title: 'Retour · vente n° ${sale.receiptNumber}',
        body: ReturnSuccessView(
          sale: sale,
          saved: saved,
          lines: linesAsync.value ?? const [],
          onDone: () => Navigator.of(context).pop(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text('Retour · vente n° ${sale.receiptNumber}'),
      ),
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
            return EmptyState(
              icon: Icons.assignment_turned_in_outlined,
              title: 'Tous les articles ont déjà été retournés',
              message: 'Il n’y a plus rien à rembourser sur cette vente.',
              actionLabel: 'Voir la vente',
              onAction: () => Navigator.of(context).pop(),
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

  /// Étape affichée : 1 = quantités, 2 = état, motif et remboursement. La
  /// saisie vit dans le brouillon : revenir à l'étape 1 ne perd rien.
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
    final opened = await showOpenCashSessionSheet(
      context,
      title: 'Ouvrez la caisse pour rembourser',
      message:
          'Un remboursement en espèces sort du tiroir : la caisse doit être '
          'ouverte. Le retour n’est pas encore enregistré.',
    );
    if (opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Caisse ouverte. Validez de nouveau le retour.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final draft = widget.draft;
    final total = draft.refundTotal(widget.lines);
    final selections = draft.selections(widget.lines);
    final hasItems = selections.isNotEmpty;
    final missing = !hasItems
        ? 'Choisissez au moins un article'
        : _step == 1
        ? null
        : draft.reason == null
        ? 'Choisissez le motif'
        : draft.needsNote
        ? 'Précisez le motif'
        : null;

    final step1 = [
      const OverlineHeader(
        'Que rapporte le client ?',
        trailing: 'Étape 1 sur 2',
      ),
      FlatList(
        children: [
          for (final line in widget.lines)
            _QuantityCard(
              line: line,
              quantity: draft.quantityOf(line.saleItemId),
              onQuantity: (q) => _draft.setQuantity(line.saleItemId, q),
            ),
        ],
      ),
    ];

    final step2 = [
      const OverlineHeader('État et remboursement', trailing: 'Étape 2 sur 2'),
      const OverlineHeader('Que faire de l’article ?'),
      FlatList(
        children: [
          for (final s in selections)
            _ConditionCard(
              line: s.line,
              quantity: s.quantity,
              condition: draft.conditionOf(s.line.saleItemId),
              onCondition: (c) => _draft.setCondition(s.line.saleItemId, c),
            ),
        ],
      ),
      const OverlineHeader('Motif'),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final reason in ReturnReason.values)
                  QuickChoiceButton(
                    label: reason.label,
                    isSelected: draft.reason == reason,
                    onTap: () => _draft.setReason(reason),
                  ),
              ],
            ),
            if (draft.reason == ReturnReason.other) ...[
              const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
              AppTextField(
                label: 'Précisez le motif (obligatoire)',
                hint: 'Ex. : flacon ouvert',
                errorText: draft.needsNote ? 'Commentaire obligatoire' : null,
                onChanged: _draft.setNote,
                maxLength: 500,
                textCapitalization: TextCapitalization.sentences,
              ),
            ],
          ],
        ),
      ),
      const OverlineHeader('Remboursement'),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final method in RefundMethod.values)
                  QuickChoiceButton(
                    label: method.label,
                    isSelected: draft.refundMethod == method,
                    onTap: () => _draft.setRefundMethod(method),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs + 2),
              child: Text(
                widget.sale.paymentMethod == PaymentMethod.mixed
                    ? 'Vente payée en mixte : choisissez comment vous '
                          'remboursez le client.'
                    : draft.refundMethod == RefundMethod.cash
                    ? 'Un remboursement en espèces sort du tiroir de '
                          'caisse.'
                    : 'Remboursez le client depuis votre téléphone.',
                style: AppTypography.bodySmall.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    ];

    return PopScope(
      // Retour à l'étape 2 : on revient aux quantités, saisie gardée.
      canPop: _step == 1,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) setState(() => _step = 1);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              key: ValueKey(_step),
              padding: const EdgeInsets.only(bottom: AppSpacing.lg),
              children: _step == 1 ? step1 : step2,
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Expanded(
                          child: Text(
                            'À rembourser',
                            style: AppTypography.body.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                        ),
                        Text(
                          formatFcfa(total),
                          style: AppTypography.figureLarge,
                        ),
                      ],
                    ),
                    if (missing != null)
                      Text(
                        missing,
                        style: AppTypography.bodySmall.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    const SizedBox(height: AppSpacing.sm),
                    PrimaryButton(
                      label: 'Continuer',
                      isLoading: _saving,
                      loadingLabel: 'Enregistrement…',
                      onPressed: missing != null || _saving
                          ? null
                          : _step == 1
                          ? () => setState(() => _step = 2)
                          : _continue,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Étape 1 : article de la vente (ligne à plat) — vendu / déjà rendu /
/// retournable, quantité à rendre et montant.
class _QuantityCard extends StatelessWidget {
  const _QuantityCard({
    required this.line,
    required this.quantity,
    required this.onQuantity,
  });

  final ReturnableLine line;
  final int quantity;
  final ValueChanged<int> onQuantity;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final meta = AppTypography.bodySmall.copyWith(
      color: colors.textSecondary,
      fontFeatures: AppTypography.tabularFigures,
    );
    final returnable = line.returnableQuantity;
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm + AppSpacing.xs,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(line.productName, style: AppTypography.bodyStrong),
              Text(
                '${line.soldQuantity} × ${formatFcfa(line.unitPrice)}'
                '${line.discountAmount > Decimal.zero ? ' · réduction −${formatAmount(line.discountAmount)}' : ''}',
                style: meta,
              ),
              Text(
                'Vendu ${line.soldQuantity} · déjà rendu '
                '${line.returnedQuantity} · retournable $returnable',
                style: meta,
              ),
              const SizedBox(height: AppSpacing.sm),
              if (returnable == 0)
                const StatusIndicator(
                  label: 'Déjà entièrement retourné',
                  tone: StatusTone.neutral,
                )
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
                      Text(
                        formatFcfa(line.refundFor(quantity)),
                        style: AppTypography.bodyStrong.copyWith(
                          fontFeatures: AppTypography.tabularFigures,
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
        // Article choisi : trait gauche couleur action.
        if (quantity > 0)
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: SizedBox(width: 3, child: ColoredBox(color: colors.action)),
          ),
      ],
    );
  }
}

/// Étape 2 : article rendu — « Nom × q · montant », son état et l'effet sur
/// le stock.
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
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm + AppSpacing.xs,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '${line.productName} × $quantity · '
            '${formatFcfa(line.refundFor(quantity))}',
            style: AppTypography.bodyStrong.copyWith(
              fontFeatures: AppTypography.tabularFigures,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final c in ItemCondition.values)
                QuickChoiceButton(
                  label: c.label,
                  isSelected: condition == c,
                  onTap: () => onCondition(c),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          StatusIndicator(
            label: condition.restocks
                ? 'Sera remis en stock'
                : 'Ne sera pas remis en stock',
            tone: condition.restocks ? StatusTone.success : StatusTone.neutral,
          ),
        ],
      ),
    );
  }
}
