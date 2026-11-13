import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
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

/// « Ma caisse » : solde du tiroir et son calcul, mouvements du jour, puis
/// Entrée / Sortie / Clôturer fixés en bas ; ou invitation à ouvrir la caisse.
/// Une anomalie du serveur (clôture refusée, retour refusé) s'affiche en tête.
class CashRegisterPage extends ConsumerWidget {
  /// Crée l'écran de la caisse.
  const CashRegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = ref.watch(activeCashSessionProvider);
    final session = active.value;
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Ma caisse'),
        actions: [
          TextButton(
            onPressed: () => context.push(Routes.cashHistory),
            child: const Text('Sessions'),
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _RejectedCloseAlert(),
          Expanded(
            child: active.when(
              loading: () => const _CashSkeleton(),
              error: (_, _) => EmptyState(
                icon: Icons.error_outline,
                title: 'Caisse indisponible',
                message: 'Impossible de lire la caisse sur ce téléphone.',
                actionLabel: 'Réessayer',
                onAction: () => ref.invalidate(activeCashSessionProvider),
              ),
              data: (session) => session == null
                  ? EmptyState(
                      icon: Icons.point_of_sale_outlined,
                      title: 'Caisse fermée',
                      message:
                          'Comptez les espèces du tiroir puis ouvrez la caisse '
                          'pour suivre le solde de la journée.',
                      actionLabel: 'Ouvrir la caisse',
                      onAction: () => showOpenCashSessionSheet(context),
                    )
                  : _ActiveCash(session: session),
            ),
          ),
          if (session != null) const _ActionsBar(),
        ],
      ),
    );
  }
}

/// Dernière clôture refusée par le serveur : bandeau en tête, avec l'action
/// qui règle le problème.
class _RejectedCloseAlert extends ConsumerWidget {
  const _RejectedCloseAlert();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final latest = ref
        .watch(localCashSessionHistoryProvider)
        .value
        ?.where((s) => s.status == CashSessionStatus.closed)
        .firstOrNull;
    final rejectionCode = latest?.rejectionCode;
    if (latest == null || rejectionCode == null) {
      return const SizedBox.shrink();
    }
    return CashNoticeBanner(
      level: CashNoticeLevel.error,
      title: 'Dernière clôture refusée par le serveur',
      message: cashRegisterMessage(rejectionCode),
      child: Align(
        alignment: Alignment.centerLeft,
        child: TextButton(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.of(context).onErrorSubtle,
            textStyle: AppTypography.labelLarge.copyWith(
              decoration: TextDecoration.underline,
            ),
          ),
          onPressed: () => context.push(
            Routes.cashSessionDetail.replaceFirst(':id', latest.id),
          ),
          child: const Text('Voir la session'),
        ),
      ),
    );
  }
}

/// Caisse ouverte : solde, calcul, mouvements du jour.
class _ActiveCash extends ConsumerWidget {
  const _ActiveCash({required this.session});

  final CashSession session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final summary = ref.watch(cashSummaryProvider(session.id));
    final movements = ref.watch(cashMovementsProvider(session.id));
    final since = DateFormat.Hm('fr_FR').format(session.openedAt.toLocal());

    return ListView(
      padding: const EdgeInsets.only(top: AppSpacing.sm, bottom: AppSpacing.lg),
      children: [
        summary.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: SkeletonBox(height: 280),
          ),
          error: (e, _) => CashNoticeBanner(
            level: CashNoticeLevel.error,
            message: cashRegisterErrorMessage(e),
          ),
          data: (summary) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (summary.rejectedCashRefunds > Decimal.zero)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: CashNoticeBanner(
                    level: CashNoticeLevel.warning,
                    title: 'Retour refusé',
                    message:
                        '${formatFcfa(summary.rejectedCashRefunds)} rendus non '
                        'comptés dans le solde.',
                  ),
                ),
              CashSummaryCard.fromSummary(
                summary,
                expectedLabel: 'Solde théorique du tiroir',
                status: StatusIndicator(
                  label: 'Ouverte depuis $since',
                  tone: StatusTone.success,
                ),
              ),
            ],
          ),
        ),
        const OverlineHeader('Mouvements du jour'),
        movements.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: SkeletonBox(height: 120),
          ),
          error: (e, _) => CashNoticeBanner(
            level: CashNoticeLevel.error,
            message: cashRegisterErrorMessage(e),
          ),
          data: (movements) => movements.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  child: Text(
                    "Aucune entrée ni sortie d'espèces pour l'instant.",
                    style: AppTypography.body.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                )
              : FlatList(
                  children: [
                    for (final movement in movements.take(_recentMovementCount))
                      CashMovementTile(movement: movement),
                  ],
                ),
        ),
      ],
    );
  }
}

/// Barre fixe : Entrée, Sortie, puis « Clôturer la caisse ».
class _ActionsBar extends StatelessWidget {
  const _ActionsBar();

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return DecoratedBox(
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
                children: [
                  Expanded(
                    child: SecondaryButton(
                      label: 'Entrée',
                      icon: Icons.south,
                      onPressed: () => showCashMovementSheet(
                        context,
                        CashMovementType.cashIn,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: SecondaryButton(
                      label: 'Sortie',
                      icon: Icons.north,
                      onPressed: () => showCashMovementSheet(
                        context,
                        CashMovementType.cashOut,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              PrimaryButton(
                label: 'Clôturer la caisse',
                onPressed: () => context.push(Routes.cashClose),
              ),
            ],
          ),
        ),
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
        SkeletonBox(width: 160, height: 16),
        SizedBox(height: AppSpacing.sm),
        SkeletonBox(width: 220, height: 32),
        SizedBox(height: AppSpacing.lg),
        SkeletonBox(height: 200),
      ],
    );
  }
}
