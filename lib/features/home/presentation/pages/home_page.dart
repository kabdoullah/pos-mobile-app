import 'package:clock/clock.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/router/main_shell.dart';
import '../../../../core/widgets/index.dart';
import '../../../auth/providers/store_provider.dart';
import '../../../cash_register/domain/entities/cash_movement.dart';
import '../../../cash_register/domain/entities/cash_session.dart';
import '../../../cash_register/domain/entities/cash_summary.dart';
import '../../../cash_register/presentation/providers/cash_register_providers.dart';
import '../../../cash_register/presentation/widgets/cash_movement_sheet.dart';
import '../../../cash_register/presentation/widgets/open_cash_session_sheet.dart';
import '../providers/home_providers.dart';
import '../widgets/account_email_banner.dart';
import '../widgets/low_stock_section.dart';

/// Accueil : répond à « comment va ma journée ? ». La caisse passe en tête
/// (ouverte ou fermée, espèces du tiroir, mobile money à part), puis les
/// ventes du jour et les alertes de stock.
///
/// L'action principale, fixée en bas, suit l'état de la caisse : « Nouvelle
/// vente » si elle est ouverte, « Ouvrir la caisse » sinon.
class HomePage extends ConsumerWidget {
  /// Crée l'accueil.
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final storeName = ref.watch(storeConfigProvider).value?.name;
    final session = ref.watch(activeCashSessionProvider);
    final dateLabel = DateFormat(
      'EEEE d MMMM',
      'fr_FR',
    ).format(ref.watch(todayProvider));
    final hPad = responsiveValue(
      context,
      small: AppSpacing.md,
      medium: AppSpacing.lg,
    );

    void goTo(ShellBranch branch) =>
        StatefulNavigationShell.of(context).goBranch(branch.index);

    // Pendant la lecture de la caisse, l'action reste visible mais inactive :
    // on ne sait pas encore s'il faut vendre ou ouvrir.
    final isCashClosed = session.hasValue && session.value == null;
    final Widget mainAction = isCashClosed
        ? PrimaryButton(
            label: 'Ouvrir la caisse',
            icon: Icons.lock_open_outlined,
            onPressed: () => showOpenCashSessionSheet(context),
          )
        : PrimaryButton(
            label: 'Nouvelle vente',
            icon: Icons.point_of_sale,
            onPressed: session.hasValue ? () => goTo(ShellBranch.sale) : null,
          );

    return AppScaffold(
      title: storeName == null || storeName.isEmpty ? 'Accueil' : storeName,
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: AppSpacing.md),
          child: OfflineStatusIndicator(),
        ),
      ],
      bottomActions: [mainAction],
      body: ListView(
        padding: EdgeInsets.fromLTRB(hPad, AppSpacing.xs, hPad, AppSpacing.md),
        children: [
          Text(
            'Bonjour · $dateLabel',
            style: AppTypography.bodyMedium.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _CashCard(onOpenRegister: () => context.push(Routes.cashRegister)),
          const SizedBox(height: AppSpacing.md),
          const AccountEmailBanner(),
          _TodaySalesCard(onTap: () => goTo(ShellBranch.salesHistory)),
          const SizedBox(height: AppSpacing.lg),
          LowStockSection(onSeeStock: () => goTo(ShellBranch.inventory)),
        ],
      ),
    );
  }
}

/// Carte « Ma caisse » : état, espèces dans le tiroir, mobile money à part,
/// et les deux gestes du jour (mouvement d'espèces, clôture). Caisse fermée :
/// la consigne du matin et le montant de la dernière clôture.
///
/// Le haut de la carte ouvre l'écran Ma caisse.
class _CashCard extends ConsumerWidget {
  const _CashCard({required this.onOpenRegister});

  final VoidCallback onOpenRegister;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(activeCashSessionProvider);
    final active = session.value;

    if (session.isLoading && !session.hasValue) return const _CashSkeleton();

    final Widget content;
    final String semanticsLabel;
    final List<Widget> actions;
    if (active == null) {
      semanticsLabel = session.hasError
          ? 'Caisse indisponible'
          : 'Caisse fermée. Voir Ma caisse';
      content = _ClosedCashContent(unavailable: session.hasError);
      actions = const [];
    } else {
      final summary = ref.watch(cashSummaryProvider(active.id));
      final value = summary.value;
      semanticsLabel = value != null
          ? 'Caisse ouverte, espèces dans le tiroir '
                '${formatFcfa(value.expectedAmount)}'
          : summary.hasError
          ? 'Caisse ouverte, solde indisponible'
          : 'Caisse ouverte';
      content = _OpenCashContent(
        session: active,
        summary: value,
        unavailable: value == null && summary.hasError,
      );
      actions = [
        Expanded(
          child: SecondaryButton(
            label: 'Entrée / sortie',
            onPressed: () =>
                showCashMovementSheet(context, CashMovementType.cashOut),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: SecondaryButton(
            label: 'Clôturer',
            onPressed: () => context.push(Routes.cashClose),
          ),
        ),
      ];
    }

    final cs = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(AppSpacing.radiusLg);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: radius,
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Material(
        type: MaterialType.transparency,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // excludeSemantics retire l'action de l'InkWell : on la redonne
            // ici, sinon les lecteurs d'écran annoncent un bouton inactif.
            Semantics(
              button: true,
              label: semanticsLabel,
              onTap: onOpenRegister,
              excludeSemantics: true,
              child: InkWell(
                onTap: onOpenRegister,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    AppSpacing.md,
                    AppSpacing.md,
                    actions.isEmpty ? AppSpacing.md : AppSpacing.sm,
                  ),
                  child: content,
                ),
              ),
            ),
            if (actions.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.xs,
                  AppSpacing.md,
                  AppSpacing.md,
                ),
                child: Row(children: actions),
              ),
          ],
        ),
      ),
    );
  }
}

class _OpenCashContent extends StatelessWidget {
  const _OpenCashContent({
    required this.session,
    required this.summary,
    required this.unavailable,
  });

  final CashSession session;
  final CashSummary? summary;
  final bool unavailable;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final muted = AppTypography.bodyMedium.copyWith(color: cs.onSurfaceVariant);
    final summary = this.summary;
    final openedAt = DateFormat.Hm('fr_FR').format(session.openedAt.toLocal());
    // Rien n'a bougé depuis l'ouverture : le montant est le fond de caisse.
    final untouched =
        summary != null &&
        summary.cashSales == Decimal.zero &&
        summary.cashIn == Decimal.zero &&
        summary.cashOut == Decimal.zero &&
        summary.cashRefunds == Decimal.zero;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.xs,
          children: [
            const StatusPill(
              label: 'Caisse ouverte',
              icon: Icons.lock_open_outlined,
              tone: StatusPillTone.success,
            ),
            Text('depuis $openedAt', style: muted),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Text('Espèces dans le tiroir', style: muted),
        if (summary != null)
          _BigAmount(
            amount: summary.expectedAmount,
            style: AppTypography.amountDisplay,
          )
        else if (unavailable)
          const Text('Solde indisponible', style: AppTypography.titleMedium)
        else
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: SkeletonBox(width: 180, height: 32),
          ),
        if (untouched) Text('Fond de caisse du matin', style: muted),
        if (summary != null && summary.mobileMoneySales > Decimal.zero) ...[
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Expanded(child: Text('Mobile money (hors tiroir)', style: muted)),
              Text(
                formatFcfa(summary.mobileMoneySales),
                style: AppTypography.labelLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  fontFeatures: AppTypography.tabularFigures,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _ClosedCashContent extends ConsumerWidget {
  const _ClosedCashContent({required this.unavailable});

  final bool unavailable;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    if (unavailable) {
      return Text(
        'Impossible de lire la caisse sur ce téléphone.',
        style: AppTypography.bodyMedium.copyWith(color: cs.onSurfaceVariant),
      );
    }
    final lastClosed = ref
        .watch(localCashSessionHistoryProvider)
        .value
        ?.where((s) => s.status == CashSessionStatus.closed)
        .firstOrNull;
    final closedAt = lastClosed?.closedAt;
    final counted = lastClosed?.countedAmount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const StatusPill(
          label: 'Caisse fermée',
          icon: Icons.lock_outline,
          tone: StatusPillTone.warning,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Comptez les espèces du tiroir, puis ouvrez la caisse pour '
          'commencer à vendre.',
          style: AppTypography.bodyMedium.copyWith(height: 1.4),
        ),
        if (closedAt != null && counted != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Clôturée ${closedDayLabel(closedAt.toLocal(), clock.now())} '
            'avec ${formatFcfa(counted)}',
            style: AppTypography.bodyMedium.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}

/// « aujourd'hui à 19:30 », « hier à 19:30 » ou « le 7 nov. à 19:30 ».
@visibleForTesting
String closedDayLabel(DateTime closedAt, DateTime now) {
  final day = DateTime(closedAt.year, closedAt.month, closedAt.day);
  final today = DateTime(now.year, now.month, now.day);
  final time = DateFormat.Hm('fr_FR').format(closedAt);
  return switch (today.difference(day).inDays) {
    0 => "aujourd'hui à $time",
    1 => 'hier à $time',
    _ => 'le ${DateFormat('d MMM', 'fr_FR').format(closedAt)} à $time',
  };
}

/// Carte « Ventes du jour » : montant et nombre de ventes ; avant la
/// première vente, une phrase plutôt que des zéros.
class _TodaySalesCard extends ConsumerWidget {
  const _TodaySalesCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final muted = AppTypography.bodyMedium.copyWith(color: cs.onSurfaceVariant);
    final summary = ref.watch(dailySummaryProvider);

    return summary.when(
      // Données locales (drift) : le squelette n'est visible qu'un instant.
      loading: () =>
          const SkeletonBox(height: 104, radius: AppSpacing.radiusLg),
      error: (_, _) => AppCard(
        child: Row(
          children: [
            Icon(Icons.error_outline, color: cs.error),
            const SizedBox(width: AppSpacing.sm),
            const Expanded(
              child: Text(
                'Impossible de charger les ventes du jour.',
                style: AppTypography.bodyMedium,
              ),
            ),
            TextButton(
              onPressed: () => ref.invalidate(dailySummaryProvider),
              child: const Text('Réessayer'),
            ),
          ],
        ),
      ),
      data: (stats) {
        if (stats.saleCount == 0) {
          return AppCard(
            padding: AppSpacing.lg,
            child: Column(
              children: [
                Icon(Icons.receipt_long_outlined, size: 40, color: cs.primary),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  "Aucune vente aujourd'hui",
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Votre première vente apparaîtra ici.',
                  style: muted,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }
        final lastSale = ref.watch(lastSaleTodayProvider).value;
        final count = stats.saleCount == 1
            ? '1 vente'
            : '${stats.saleCount} ventes';
        final last = lastSale == null
            ? ''
            : ' · dernière à '
                  '${DateFormat.Hm('fr_FR').format(lastSale.createdAt.toLocal())}';
        return AppCard(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Ventes du jour', style: muted),
              _BigAmount(
                amount: stats.totalAmount,
                style: AppTypography.amountLarge,
              ),
              Text('$count$last', style: muted),
              if (stats.refundTotal > Decimal.zero)
                Text(
                  'net de ${formatFcfa(stats.refundTotal)} remboursés',
                  style: muted,
                ),
            ],
          ),
        );
      },
    );
  }
}

/// Montant mis en avant ; un montant négatif s'affiche en couleur d'erreur.
class _BigAmount extends StatelessWidget {
  const _BigAmount({required this.amount, required this.style});

  final Decimal amount;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Text(
        formatFcfa(amount),
        maxLines: 1,
        style: style.copyWith(
          color: amount < Decimal.zero ? cs.error : cs.onSurface,
          fontFeatures: AppTypography.tabularFigures,
        ),
      ),
    );
  }
}

/// Squelette de la carte caisse pendant la lecture.
class _CashSkeleton extends StatelessWidget {
  const _CashSkeleton();

  @override
  Widget build(BuildContext context) {
    return const AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonBox(width: 150, height: 32, radius: AppSpacing.radiusFull),
          SizedBox(height: AppSpacing.sm),
          SkeletonBox(width: 140, height: 18),
          SizedBox(height: AppSpacing.sm),
          SkeletonBox(width: 220, height: 38),
          SizedBox(height: AppSpacing.md),
          SkeletonBox(height: AppSpacing.buttonHeightSm),
        ],
      ),
    );
  }
}
