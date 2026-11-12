import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/index.dart';
import '../../domain/entities/cash_movement.dart';
import '../../domain/entities/cash_session.dart';
import '../cash_register_messages.dart';
import '../providers/cash_register_providers.dart';
import '../widgets/cash_movement_sheet.dart';
import '../widgets/cash_movement_tile.dart';
import '../widgets/cash_notice_banner.dart';
import '../widgets/cash_summary_card.dart';
import '../widgets/open_cash_session_sheet.dart';

/// Nombre de mouvements affichés sur l'écran de la caisse active.
const _recentMovementCount = 10;

/// Ma caisse : solde théorique du tiroir en direct, mobile money à part et
/// mouvements du jour ; ou invitation à ouvrir la caisse. Les actions restent
/// fixées en bas de l'écran.
class CashRegisterPage extends ConsumerWidget {
  /// Crée l'écran de la caisse.
  const CashRegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = ref.watch(activeCashSessionProvider);
    final List<Widget>? bottomActions = switch (active) {
      AsyncData(value: null) => [
        PrimaryButton(
          label: 'Ouvrir la caisse',
          icon: Icons.lock_open_outlined,
          onPressed: () => showOpenCashSessionSheet(context),
        ),
      ],
      AsyncError() => null,
      // Pendant la lecture : mêmes boutons, inactifs, pour que l'écran ne
      // saute pas.
      _ => _activeActions(context, enabled: active.value != null),
    };
    return AppScaffold(
      title: 'Ma caisse',
      actions: [
        TextButton(
          onPressed: () => context.push(Routes.cashHistory),
          child: const Text('Sessions'),
        ),
        const SizedBox(width: AppSpacing.xs),
      ],
      bottomActions: bottomActions,
      body: active.when(
        loading: () => const _CashSkeleton(),
        error: (_, _) => EmptyState(
          icon: Icons.error_outline,
          tone: EmptyStateTone.error,
          title: 'Caisse indisponible',
          message: 'Impossible de lire la caisse sur ce téléphone.',
          actionLabel: 'Réessayer',
          onAction: () => ref.invalidate(activeCashSessionProvider),
        ),
        data: (session) => session == null
            ? const _ClosedCash()
            : _ActiveCash(session: session),
      ),
    );
  }

  List<Widget> _activeActions(
    BuildContext context, {
    required bool enabled,
  }) => [
    Row(
      children: [
        Expanded(
          child: SecondaryButton(
            label: 'Entrée',
            icon: Icons.south_west,
            onPressed: enabled
                ? () => showCashMovementSheet(context, CashMovementType.cashIn)
                : null,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: SecondaryButton(
            label: 'Sortie',
            icon: Icons.north_east,
            onPressed: enabled
                ? () => showCashMovementSheet(context, CashMovementType.cashOut)
                : null,
          ),
        ),
      ],
    ),
    PrimaryButton(
      label: 'Clôturer la caisse',
      icon: Icons.lock_outline,
      onPressed: enabled ? () => context.push(Routes.cashClose) : null,
    ),
  ];
}

/// Aucune caisse ouverte : une phrase, l'action en bas ; et rappel d'une
/// clôture refusée par le serveur s'il y en a une.
class _ClosedCash extends ConsumerWidget {
  const _ClosedCash();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final latest = ref
        .watch(localCashSessionHistoryProvider)
        .value
        ?.where((s) => s.status == CashSessionStatus.closed)
        .firstOrNull;
    final rejectionCode = latest?.rejectionCode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (latest != null && rejectionCode != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.md,
              0,
            ),
            child: CashNoticeBanner(
              level: CashNoticeLevel.error,
              title: 'Dernière clôture refusée par le serveur',
              message: cashRegisterMessage(rejectionCode),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: const Size(0, AppSpacing.buttonHeightSm),
                  ),
                  onPressed: () => context.push(
                    Routes.cashSessionDetail.replaceFirst(':id', latest.id),
                  ),
                  child: const Text('Voir la session'),
                ),
              ),
            ),
          ),
        const Expanded(
          child: EmptyState(
            icon: Icons.lock_outline,
            tone: EmptyStateTone.warning,
            title: 'Caisse fermée',
            message:
                'Ouvrez la caisse pour commencer à vendre. Comptez d\'abord '
                'les espèces du tiroir.',
          ),
        ),
      ],
    );
  }
}

/// Caisse ouverte : solde théorique et sa formule, mobile money, mouvements
/// du jour.
class _ActiveCash extends ConsumerWidget {
  const _ActiveCash({required this.session});

  final CashSession session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final muted = AppTypography.bodyMedium.copyWith(color: cs.onSurfaceVariant);
    final summary = ref.watch(cashSummaryProvider(session.id));
    final movements = ref.watch(cashMovementsProvider(session.id));
    final openedAt = DateFormat.Hm('fr_FR').format(session.openedAt.toLocal());

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.xs,
        AppSpacing.md,
        AppSpacing.lg,
      ),
      children: [
        summary.when(
          loading: () => const _SummarySkeleton(),
          error: (e, _) => CashNoticeBanner(
            level: CashNoticeLevel.error,
            message: cashRegisterErrorMessage(e),
          ),
          data: (summary) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CashSummaryCard.fromSummary(
                summary,
                expectedLabel: 'Solde théorique du tiroir',
                showMobileMoney: false,
                header: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.xs,
                  children: [
                    const StatusPill(
                      label: 'Ouverte',
                      icon: Icons.lock_open_outlined,
                      tone: StatusPillTone.success,
                    ),
                    Text('depuis $openedAt', style: muted),
                  ],
                ),
              ),
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
              _MobileMoneyCard(amount: summary.mobileMoneySales),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        movements.when(
          loading: () => const SkeletonBox(height: 120),
          error: (e, _) => CashNoticeBanner(
            level: CashNoticeLevel.error,
            message: cashRegisterErrorMessage(e),
          ),
          data: (movements) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SectionHeader(
                title: 'Mouvements du jour',
                count: movements.isEmpty ? null : movements.length,
              ),
              if (movements.isEmpty)
                Text(
                  "Aucune entrée ni sortie d'espèces pour l'instant.",
                  style: muted,
                )
              else
                AppListGroup(
                  children: [
                    for (final movement in movements.take(_recentMovementCount))
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                        ),
                        child: CashMovementTile(movement: movement),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Mobile money encaissé depuis l'ouverture : hors tiroir, il n'entre pas
/// dans le solde à compter.
class _MobileMoneyCard extends StatelessWidget {
  const _MobileMoneyCard({required this.amount});

  final Decimal amount;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text('Mobile money', style: AppTypography.labelLarge),
              ),
              Text(
                formatFcfa(amount),
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  fontFeatures: AppTypography.tabularFigures,
                ),
              ),
            ],
          ),
          Text(
            'Hors tiroir : ne se compte pas à la clôture.',
            style: AppTypography.bodySmall.copyWith(color: cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _SummarySkeleton extends StatelessWidget {
  const _SummarySkeleton();

  @override
  Widget build(BuildContext context) {
    return const AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonBox(width: 120, height: 32, radius: AppSpacing.radiusFull),
          SizedBox(height: AppSpacing.sm),
          SkeletonBox(width: 180, height: 18),
          SizedBox(height: AppSpacing.sm),
          SkeletonBox(width: 240, height: 38),
          SizedBox(height: AppSpacing.sm),
          SkeletonBox(height: 18),
          SizedBox(height: AppSpacing.sm),
          SkeletonBox(height: 18),
          SizedBox(height: AppSpacing.sm),
          SkeletonBox(height: 18),
        ],
      ),
    );
  }
}

/// Squelette de l'écran pendant la lecture de la caisse.
class _CashSkeleton extends StatelessWidget {
  const _CashSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: const [
        _SummarySkeleton(),
        SizedBox(height: AppSpacing.md),
        SkeletonBox(height: 56, radius: AppSpacing.radiusLg),
      ],
    );
  }
}
