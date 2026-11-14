import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/index.dart';
import '../../../sales/presentation/widgets/amount_input.dart';
import '../../domain/entities/cash_count.dart';
import '../../domain/entities/cash_session.dart';
import '../../domain/entities/cash_summary.dart';
import '../../domain/repositories/cash_register_repository.dart';
import '../cash_register_messages.dart';
import '../providers/cash_register_providers.dart';
import '../widgets/cash_count_form.dart';
import '../widgets/cash_notice_banner.dart';
import '../widgets/discrepancy_badge.dart';

/// Clôture de la caisse en deux étapes : comptage (billets et pièces, ou
/// total seulement) sans le solde attendu, puis récapitulatif avec l'écart
/// (équilibrée, excédent, déficit), commentaire obligatoire en cas d'écart et
/// confirmation.
class CloseCashSessionPage extends ConsumerWidget {
  /// Crée l'écran de clôture.
  const CloseCashSessionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = ref.watch(activeCashSessionProvider);
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Clôturer la caisse'),
      ),
      body: active.when(
        loading: () => const _CloseSkeleton(),
        error: (_, _) => EmptyState(
          icon: Icons.error_outline,
          title: 'Caisse indisponible',
          message: 'Impossible de lire la caisse sur ce téléphone.',
          actionLabel: 'Réessayer',
          onAction: () => ref.invalidate(activeCashSessionProvider),
        ),
        data: (session) {
          if (session == null) {
            return EmptyState(
              icon: Icons.point_of_sale_outlined,
              title: 'Aucune caisse ouverte',
              message: "Il n'y a pas de caisse à clôturer sur ce téléphone.",
              actionLabel: 'Retour',
              onAction: () => context.pop(),
            );
          }
          final summary = ref.watch(cashSummaryProvider(session.id));
          return summary.when(
            loading: () => const _CloseSkeleton(),
            error: (e, _) => EmptyState(
              icon: Icons.error_outline,
              title: 'Récapitulatif indisponible',
              message: cashRegisterErrorMessage(e),
              actionLabel: 'Réessayer',
              onAction: () => ref.invalidate(cashSummaryProvider(session.id)),
            ),
            data: (summary) => _CloseForm(session: session, summary: summary),
          );
        },
      ),
    );
  }
}

class _CloseForm extends ConsumerStatefulWidget {
  const _CloseForm({required this.session, required this.summary});

  final CashSession session;
  final CashSummary summary;

  @override
  ConsumerState<_CloseForm> createState() => _CloseFormState();
}

/// Deux étapes : 1. compter le tiroir « à l'aveugle » (le solde théorique
/// n'est pas affiché, pour ne pas ajuster le comptage) ; 2. récapitulatif,
/// écart et commentaire. Le solde théorique n'est jamais modifié.
class _CloseFormState extends ConsumerState<_CloseForm> {
  final _noteController = TextEditingController();
  CashCount _count = CashCount.empty();

  /// Montant saisi en mode « Total seulement ».
  Decimal? _typedAmount;

  /// Mode de comptage figé en passant au récapitulatif.
  bool _countedByDenomination = true;
  bool _showSummary = false;
  String? _countedError;
  String? _noteError;
  String? _formError;
  bool _isLoading = false;

  /// Montant compté retenu au récapitulatif, null tant que rien n'est saisi.
  Decimal? get _counted => _countedByDenomination ? _count.total : _typedAmount;

  /// Écart en cours, null tant que rien n'est compté.
  Decimal? get _discrepancy {
    final counted = _counted;
    return counted == null ? null : counted - widget.summary.expectedAmount;
  }

  bool get _noteRequired {
    final gap = _discrepancy;
    return gap != null && gap != Decimal.zero;
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _continue(bool byDenomination) {
    if (!byDenomination && _typedAmount == null) {
      setState(() => _countedError = 'Saisissez le montant compté.');
      return;
    }
    setState(() {
      _countedByDenomination = byDenomination;
      _countedError = null;
      _formError = null;
      if (!_noteRequired) _noteError = null;
      _showSummary = true;
    });
  }

  Future<void> _submit() async {
    final counted = _counted;
    final discrepancy = _discrepancy;
    setState(() {
      _noteError = _noteRequired && _noteController.text.trim().isEmpty
          ? "Expliquez l'écart avant de clôturer."
          : null;
      _formError = null;
    });
    if (counted == null || discrepancy == null || _noteError != null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => _ConfirmCloseDialog(
        expected: widget.summary.expectedAmount,
        counted: counted,
        discrepancy: discrepancy,
      ),
    );
    if (!(confirmed ?? false) || !mounted) return;

    // Capturés avant l'écriture : la session clôturée disparaît de la caisse
    // active et ce formulaire peut être démonté avant la fin de l'await.
    final router = GoRouter.of(context);
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _isLoading = true);
    try {
      final closed = await ref
          .read(cashRegisterControllerProvider.notifier)
          .close(
            countedAmount: counted,
            count: _countedByDenomination ? _count : null,
            note: _noteController.text,
          );
      messenger.showSnackBar(const SnackBar(content: Text('Caisse clôturée')));
      unawaited(
        router.pushReplacement(
          Routes.cashSessionDetail.replaceFirst(':id', closed.id),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      final message = cashRegisterErrorMessage(e);
      final code = e is CashRegisterException ? e.code : null;
      setState(() {
        switch (code) {
          case CashRegisterException.noteRequired ||
              CashRegisterException.noteTooLong:
            _noteError = code == CashRegisterException.noteRequired
                ? "Le solde a changé : expliquez l'écart avant de clôturer."
                : message;
          default:
            _formError = message;
        }
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Retour système au récapitulatif : revenir au comptage, pas quitter.
    return PopScope(
      canPop: !_showSummary,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) setState(() => _showSummary = false);
      },
      child: _showSummary ? _buildSummary(context) : _buildCount(context),
    );
  }

  Widget _stepLabel(BuildContext context, String text) => Padding(
    padding: const EdgeInsets.fromLTRB(
      AppSpacing.md,
      AppSpacing.xs,
      AppSpacing.md,
      0,
    ),
    child: Text(
      text,
      style: AppTypography.meta.copyWith(
        color: AppColors.of(context).textSecondary,
      ),
    ),
  );

  /// Étape 1 : comptage, sans le solde attendu.
  Widget _buildCount(BuildContext context) {
    final colors = AppColors.of(context);
    final byDenomination =
        ref.watch(cashCountByDenominationProvider).value ?? true;
    final amount = byDenomination ? _count.total : _typedAmount;
    final breakdown = countBreakdown(_count);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(bottom: AppSpacing.lg),
            children: [
              _stepLabel(context, 'Étape 1 sur 2'),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.xs,
                  AppSpacing.md,
                  AppSpacing.md,
                ),
                child: Text(
                  byDenomination
                      ? 'Comptez le tiroir coupure par coupure. Le solde '
                            "attendu s'affiche ensuite."
                      : 'Comptez les espèces du tiroir et saisissez le '
                            "total. Le solde attendu s'affiche ensuite.",
                  style: AppTypography.body.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: CashCountModeSelector(
                  byDenomination: byDenomination,
                  onChanged: (value) => ref
                      .read(cashCountByDenominationProvider.notifier)
                      .set(value),
                ),
              ),
              if (byDenomination)
                CashCountForm(
                  count: _count,
                  onChanged: (count) => setState(() => _count = count),
                )
              else
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    AppSpacing.md,
                    AppSpacing.md,
                    0,
                  ),
                  child: AmountInput(
                    label: 'Espèces comptées dans le tiroir',
                    hint: '0',
                    value: _typedAmount,
                    errorText: _countedError,
                    large: true,
                    onChanged: (value) => setState(() {
                      _typedAmount = value;
                      _countedError = null;
                    }),
                  ),
                ),
            ],
          ),
        ),
        CashCountTotalBar(
          label: byDenomination && breakdown.isNotEmpty
              ? 'Total compté · $breakdown'
              : 'Total compté',
          amount: amount,
          action: PrimaryButton(
            label: 'Continuer',
            onPressed: () => _continue(byDenomination),
          ),
        ),
      ],
    );
  }

  /// Étape 2 : récapitulatif, écart révélé, commentaire, clôture.
  Widget _buildSummary(BuildContext context) {
    final colors = AppColors.of(context);
    final summary = widget.summary;
    final discrepancy = _discrepancy;
    final counted = _counted;
    final formError = _formError;
    final movementsNet = summary.cashIn - summary.cashOut - summary.cashRefunds;
    final mobile = summary.mobileMoneySales;
    final breakdown = _countedByDenomination ? countBreakdown(_count) : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(bottom: AppSpacing.lg),
            children: [
              _stepLabel(context, 'Étape 2 sur 2'),
              if (summary.rejectedCashRefunds > Decimal.zero)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.sm),
                  child: CashNoticeBanner(
                    level: CashNoticeLevel.warning,
                    title: 'Retour refusé',
                    message:
                        '${formatFcfa(summary.rejectedCashRefunds)} rendus '
                        'non comptés dans le solde.',
                  ),
                ),
              // Rappel du comptage, modifiable.
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.sm,
                  AppSpacing.sm,
                  0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Comptage · ${formatFcfa(counted ?? Decimal.zero)}',
                            style: AppTypography.bodyStrong.copyWith(
                              fontFeatures: AppTypography.tabularFigures,
                            ),
                          ),
                          if (breakdown.isNotEmpty)
                            Text(
                              breakdown,
                              style: AppTypography.meta.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () => setState(() => _showSummary = false),
                      child: const Text('Modifier'),
                    ),
                  ],
                ),
              ),
              const OverlineHeader('Récapitulatif'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DefinitionRow(
                      label: 'Fond de caisse',
                      value: formatFcfa(summary.openingAmount),
                    ),
                    DefinitionRow(
                      label: 'Ventes en espèces',
                      value: '+ ${formatFcfa(summary.cashSales)}',
                    ),
                    DefinitionRow(
                      label: 'Entrées, sorties, remboursements',
                      value: movementsNet < Decimal.zero
                          ? '− ${formatFcfa(movementsNet.abs())}'
                          : '+ ${formatFcfa(movementsNet)}',
                    ),
                    DefinitionRow(
                      label: 'Solde théorique',
                      value: formatFcfa(summary.expectedAmount),
                      emphasized: true,
                      // Solde négatif affiché tel quel, en couleur d'erreur.
                      color: summary.expectedAmount < Decimal.zero
                          ? colors.error
                          : null,
                    ),
                    if (counted != null && discrepancy != null) ...[
                      DefinitionRow(
                        label: 'Compté',
                        value: formatFcfa(counted),
                        emphasized: true,
                      ),
                      DefinitionRow(
                        label: discrepancyRowLabel(discrepancy),
                        value: signedDiscrepancy(discrepancy),
                        color: discrepancyTone(discrepancy).colorIn(context),
                        semanticsLabel: discrepancyLabel(discrepancy),
                        showDivider: false,
                      ),
                    ],
                  ],
                ),
              ),
              if (discrepancy != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  child: Semantics(
                    liveRegion: true,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: DiscrepancyBadge(discrepancy: discrepancy),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: AppTextField(
                  label: _noteRequired
                      ? "Expliquez l'écart (obligatoire)"
                      : 'Commentaire (facultatif)',
                  hint: 'Ex. : monnaie rendue en trop',
                  controller: _noteController,
                  errorText: _noteError,
                  maxLines: 3,
                  maxLength: CashRegisterException.maxNoteLength,
                  onChanged: (_) {
                    if (_noteError != null) setState(() => _noteError = null);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.sm,
                  AppSpacing.md,
                  0,
                ),
                child: Text(
                  [
                    if (mobile > Decimal.zero)
                      'Mobile money hors tiroir : ${formatFcfa(mobile)}.',
                    'Les montants finaux sont confirmés par le serveur.',
                  ].join(' '),
                  style: AppTypography.bodySmall.copyWith(
                    color: colors.textSecondary,
                    fontFeatures: AppTypography.tabularFigures,
                  ),
                ),
              ),
              if (formError != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    AppSpacing.sm,
                    AppSpacing.md,
                    0,
                  ),
                  child: Text(
                    formError,
                    style: AppTypography.errorText.copyWith(
                      color: colors.error,
                    ),
                  ),
                ),
            ],
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
              child: PrimaryButton(
                label: 'Clôturer la caisse',
                isLoading: _isLoading,
                onPressed: _isLoading ? null : _submit,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Confirmation avant l'action définitive : solde théorique, compté, écart.
class _ConfirmCloseDialog extends StatelessWidget {
  const _ConfirmCloseDialog({
    required this.expected,
    required this.counted,
    required this.discrepancy,
  });

  final Decimal expected;
  final Decimal counted;
  final Decimal discrepancy;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return AlertDialog(
      title: Text('Clôturer avec ${formatFcfa(counted)} ?'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DefinitionRow(
              label: 'Solde théorique',
              value: formatFcfa(expected),
            ),
            DefinitionRow(label: 'Compté', value: formatFcfa(counted)),
            DefinitionRow(
              label: discrepancyRowLabel(discrepancy),
              value: signedDiscrepancy(discrepancy),
              color: discrepancyTone(discrepancy).colorIn(context),
              showDivider: false,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'La caisse sera fermée jusqu’à la prochaine ouverture.',
              style: AppTypography.body.copyWith(color: colors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.md),
            PrimaryButton(
              label: 'Clôturer la caisse',
              onPressed: () => Navigator.of(context).pop(true),
            ),
            const SizedBox(height: AppSpacing.xs),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Revenir'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CloseSkeleton extends StatelessWidget {
  const _CloseSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: const [
        SkeletonBox(height: 280),
        SizedBox(height: AppSpacing.lg),
        SkeletonBox(height: AppSpacing.inputHeight),
        SizedBox(height: AppSpacing.md),
        SkeletonBox(height: AppSpacing.inputHeight),
      ],
    );
  }
}
