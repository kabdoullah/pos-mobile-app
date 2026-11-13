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
import '../../domain/entities/cash_session.dart';
import '../../domain/entities/cash_summary.dart';
import '../../domain/repositories/cash_register_repository.dart';
import '../cash_register_messages.dart';
import '../providers/cash_register_providers.dart';
import '../widgets/cash_notice_banner.dart';
import '../widgets/discrepancy_badge.dart';

/// Clôture de la caisse : récapitulatif, montant compté, état (équilibrée,
/// excédent, déficit), commentaire obligatoire en cas d'écart, puis
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

class _CloseFormState extends ConsumerState<_CloseForm> {
  final _noteController = TextEditingController();
  Decimal? _counted;
  String? _countedError;
  String? _noteError;
  String? _formError;
  bool _isLoading = false;

  /// Écart en cours de saisie, null tant que rien n'est compté.
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

  Future<void> _submit() async {
    final counted = _counted;
    final discrepancy = _discrepancy;
    setState(() {
      _countedError = counted == null ? 'Saisissez le montant compté.' : null;
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
          .close(countedAmount: counted, note: _noteController.text);
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
          case CashRegisterException.invalidAmount:
            _countedError = message;
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
    final colors = AppColors.of(context);
    final summary = widget.summary;
    final discrepancy = _discrepancy;
    final counted = _counted;
    final formError = _formError;
    final movementsNet = summary.cashIn - summary.cashOut - summary.cashRefunds;
    final mobile = summary.mobileMoneySales;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(
              top: AppSpacing.sm,
              bottom: AppSpacing.lg,
            ),
            children: [
              if (summary.rejectedCashRefunds > Decimal.zero)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: CashNoticeBanner(
                    level: CashNoticeLevel.warning,
                    title: 'Retour refusé',
                    message:
                        '${formatFcfa(summary.rejectedCashRefunds)} rendus '
                        'non comptés dans le solde.',
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: AmountInput(
                  label: 'Espèces comptées dans le tiroir',
                  hint: '0',
                  value: counted,
                  errorText: _countedError,
                  large: true,
                  onChanged: (value) => setState(() {
                    _counted = value;
                    _countedError = null;
                    if (!_noteRequired) _noteError = null;
                  }),
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
                        showDivider: false,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              // L'état se met à jour pendant la saisie et s'annonce aux
              // lecteurs d'écran.
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Semantics(
                  liveRegion: true,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: discrepancy == null
                        ? Text(
                            "Saisissez le montant pour voir l'écart.",
                            style: AppTypography.body.copyWith(
                              color: colors.textSecondary,
                            ),
                          )
                        : DiscrepancyBadge(discrepancy: discrepancy),
                  ),
                ),
              ),
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
