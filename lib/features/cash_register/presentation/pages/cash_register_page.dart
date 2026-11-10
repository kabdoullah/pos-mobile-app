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

/// Caisse : solde théorique et mouvements de la session ouverte, ou
/// invitation à ouvrir la caisse.
class CashRegisterPage extends ConsumerWidget {
  /// Crée l'écran de la caisse.
  const CashRegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = ref.watch(activeCashSessionProvider);
    return AppScaffold(
      title: 'Caisse',
      actions: [
        IconButton(
          tooltip: 'Historique des caisses',
          icon: const Icon(Icons.history),
          onPressed: () => context.push(Routes.cashHistory),
        ),
      ],
      body: active.when(
        loading: () => const _CashSkeleton(),
        error: (_, _) => EmptyState(
          icon: Icons.error_outline,
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
}

/// Aucune caisse ouverte : invitation à ouvrir, et rappel d'une clôture
/// refusée par le serveur s'il y en a une.
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
        Expanded(
          child: EmptyState(
            icon: Icons.point_of_sale_outlined,
            title: 'Caisse fermée',
            message:
                'Comptez les espèces du tiroir puis ouvrez la caisse pour '
                'suivre le solde de la journée.',
            actionLabel: 'Ouvrir la caisse',
            onAction: () => showOpenCashSessionSheet(context),
          ),
        ),
      ],
    );
  }
}

/// Caisse ouverte : solde théorique, formule, actions et derniers
/// mouvements.
class _ActiveCash extends ConsumerWidget {
  const _ActiveCash({required this.session});

  final CashSession session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final summary = ref.watch(cashSummaryProvider(session.id));
    final movements = ref.watch(cashMovementsProvider(session.id));
    final openedAt = DateFormat(
      "'Ouverte le' d MMM 'à' HH:mm",
      'fr_FR',
    ).format(session.openedAt.toLocal());

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.xl,
      ),
      children: [
        summary.when(
          loading: () => const SkeletonBox(height: 280),
          error: (e, _) => CashNoticeBanner(
            level: CashNoticeLevel.error,
            message: cashRegisterErrorMessage(e),
          ),
          data: (summary) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CashSummaryCard.fromSummary(summary, caption: openedAt),
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
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: _MovementButton(
                label: 'Entrée',
                icon: Icons.south_west,
                onPressed: () =>
                    showCashMovementSheet(context, CashMovementType.cashIn),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _MovementButton(
                label: 'Sortie',
                icon: Icons.north_east,
                onPressed: () =>
                    showCashMovementSheet(context, CashMovementType.cashOut),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        PrimaryButton(
          label: 'Clôturer la caisse',
          icon: Icons.lock_outline,
          onPressed: () => context.push(Routes.cashClose),
        ),
        const SizedBox(height: AppSpacing.lg),
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
                title: 'Derniers mouvements',
                count: movements.isEmpty ? null : movements.length,
              ),
              if (movements.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  child: Text(
                    "Aucune entrée ni sortie d'espèces pour l'instant.",
                    style: AppTypography.bodyMedium.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                )
              else
                AppListGroup(
                  dividerIndent: AppSpacing.md + 36 + AppSpacing.md,
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

class _MovementButton extends StatelessWidget {
  const _MovementButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(AppSpacing.buttonHeightSm),
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
        SkeletonBox(height: 280),
        SizedBox(height: AppSpacing.md),
        SkeletonBox(height: AppSpacing.buttonHeightSm),
        SizedBox(height: AppSpacing.sm),
        SkeletonBox(height: AppSpacing.buttonHeight),
      ],
    );
  }
}
