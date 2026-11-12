import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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

/// Clôture de la caisse : espèces comptées en grand, solde théorique, écart
/// calculé en direct (équilibrée, excédent, déficit), commentaire obligatoire
/// en cas d'écart, puis confirmation avec le détail de la formule.
class CloseCashSessionPage extends ConsumerWidget {
  /// Crée l'écran de clôture.
  const CloseCashSessionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = ref.watch(activeCashSessionProvider);
    return AppScaffold(
      title: 'Clôturer la caisse',
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

  String _confirmMessage(Decimal counted, Decimal discrepancy) {
    final s = widget.summary;
    return [
      'Fond de caisse : ${formatFcfa(s.openingAmount)}',
      'Ventes espèces : ${formatFcfa(s.cashSales)}',
      'Entrées : ${formatFcfa(s.cashIn)}',
      'Sorties : ${formatFcfa(s.cashOut)}',
      'Remboursements : ${formatFcfa(s.cashRefunds)}',
      'Solde théorique : ${formatFcfa(s.expectedAmount)}',
      'Montant compté : ${formatFcfa(counted)}',
      'Écart : ${discrepancyLabel(discrepancy)}',
      '',
      'Une caisse clôturée ne peut plus être modifiée.',
    ].join('\n');
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

    final confirmed = await showConfirmDialog(
      context,
      title: 'Clôturer la caisse ?',
      message: _confirmMessage(counted, discrepancy),
      confirmLabel: 'Clôturer',
    );
    if (!confirmed || !mounted) return;

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
    final cs = Theme.of(context).colorScheme;
    final muted = AppTypography.bodyMedium.copyWith(color: cs.onSurfaceVariant);
    final summary = widget.summary;
    final counted = _counted;
    final discrepancy = _discrepancy;
    final formError = _formError;
    final expectedNegative = summary.expectedAmount < Decimal.zero;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              AppSpacing.lg,
            ),
            children: [
              AmountInput(
                label: 'Espèces comptées dans le tiroir',
                hint: '0',
                large: true,
                value: counted,
                errorText: _countedError,
                onChanged: (value) => setState(() {
                  _counted = value;
                  _countedError = null;
                  if (!_noteRequired) _noteError = null;
                }),
              ),
              const SizedBox(height: AppSpacing.md),
              AppListGroup(
                children: [
                  _AmountRow(
                    label: 'Solde théorique',
                    value: formatFcfa(summary.expectedAmount),
                    color: expectedNegative ? cs.error : null,
                  ),
                  _AmountRow(
                    label: 'Compté',
                    value: counted == null ? '—' : formatFcfa(counted),
                  ),
                ],
              ),
              if (expectedNegative) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Solde négatif : vérifiez les sorties et les '
                  'remboursements.',
                  style: AppTypography.bodyMedium.copyWith(color: cs.error),
                ),
              ],
              if (summary.rejectedCashRefunds > Decimal.zero) ...[
                const SizedBox(height: AppSpacing.sm),
                CashNoticeBanner(
                  level: CashNoticeLevel.warning,
                  message:
                      'Retour refusé : '
                      '${formatFcfa(summary.rejectedCashRefunds)} rendus non '
                      'comptés',
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              // L'écart se met à jour pendant la saisie et s'annonce aux
              // lecteurs d'écran.
              Semantics(
                liveRegion: true,
                child: discrepancy == null
                    ? Text(
                        "Saisissez le montant pour voir l'écart.",
                        style: muted,
                      )
                    : _DiscrepancyBox(discrepancy: discrepancy),
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: _noteRequired
                    ? "Expliquez l'écart (obligatoire)"
                    : 'Commentaire (facultatif)',
                hint: _noteRequired ? 'Ex. : monnaie rendue en trop' : null,
                controller: _noteController,
                errorText: _noteError,
                maxLines: 3,
                maxLength: CashRegisterException.maxNoteLength,
                onChanged: (_) {
                  if (_noteError != null) setState(() => _noteError = null);
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                summary.mobileMoneySales > Decimal.zero
                    ? 'Mobile money (hors tiroir) : '
                          '${formatFcfa(summary.mobileMoneySales)} · le '
                          'résultat final est confirmé par le serveur.'
                    : 'Le résultat final est confirmé par le serveur.',
                style: AppTypography.bodySmall.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
              if (formError != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  formError,
                  style: AppTypography.errorText.copyWith(color: cs.error),
                ),
              ],
            ],
          ),
        ),
        BottomActionBar(
          children: [
            PrimaryButton(
              label: 'Clôturer la caisse',
              icon: Icons.lock_outline,
              isLoading: _isLoading,
              onPressed: _isLoading ? null : _submit,
            ),
          ],
        ),
      ],
    );
  }
}

/// Ligne « libellé … montant » d'un groupe.
class _AmountRow extends StatelessWidget {
  const _AmountRow({required this.label, required this.value, this.color});

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Semantics(
      container: true,
      label: '$label : $value',
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm + 2,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTypography.bodyMedium.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
            ),
            Text(
              value,
              style: AppTypography.bodyMedium.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
                fontFeatures: AppTypography.tabularFigures,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Écart en grand, sur la couleur de son état : équilibrée, excédent ou
/// déficit.
class _DiscrepancyBox extends StatelessWidget {
  const _DiscrepancyBox({required this.discrepancy});

  final Decimal discrepancy;

  @override
  Widget build(BuildContext context) {
    final colors = discrepancyColors(context, discrepancy);
    final kind = DiscrepancyKind.of(discrepancy);
    final title = switch (kind) {
      DiscrepancyKind.balanced => 'Caisse équilibrée',
      DiscrepancyKind.surplus => 'Excédent',
      DiscrepancyKind.deficit => 'Déficit',
    };
    final sign = switch (kind) {
      DiscrepancyKind.balanced => '',
      DiscrepancyKind.surplus => '+ ',
      DiscrepancyKind.deficit => '− ',
    };
    return Semantics(
      container: true,
      label: discrepancyLabel(discrepancy),
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm + 6,
          vertical: AppSpacing.sm + 4,
        ),
        decoration: BoxDecoration(
          color: colors.background,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: AppTypography.labelLarge.copyWith(
                  color: colors.foreground,
                ),
              ),
            ),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: Text(
                  '$sign${formatFcfa(discrepancy.abs())}',
                  style: AppTypography.amountLarge.copyWith(
                    color: colors.foreground,
                    fontFeatures: AppTypography.tabularFigures,
                  ),
                ),
              ),
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
