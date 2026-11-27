import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/router/main_shell.dart';
import '../../../../core/sync/sync_orchestrator.dart';
import '../../../../core/sync/sync_providers.dart';
import '../../../../core/widgets/index.dart';
import '../../../auth/providers/store_provider.dart';
import '../../../cash_register/domain/entities/cash_session.dart';
import '../../../cash_register/presentation/cash_session_labels.dart';
import '../../../cash_register/presentation/providers/cash_register_providers.dart';
import '../../../cash_register/presentation/pages/open_cash_session_page.dart';
import '../../../onboarding/presentation/providers/welcome_provider.dart';
import '../providers/home_providers.dart';
import '../widgets/account_email_banner.dart';
import '../widgets/first_steps_section.dart';
import '../widgets/low_stock_section.dart';
import '../widgets/recent_sales_section.dart';
import '../widgets/today_summary.dart';

/// Accueil. Caisse fermée ou journée sans vente : l'état de la caisse et son
/// action en tête, puis les chiffres. Caisse ouverte avec des ventes : le
/// chiffre d'affaires en tête et la caisse en bloc compact dessous. Puis les
/// alertes de stock et les dernières ventes, en listes plates. La vente se fait depuis
/// l'onglet « Vendre » : pas de bouton en double ici.
class HomePage extends ConsumerWidget {
  /// Crée l'accueil.
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Juste après l'inscription : « boutique prête » puis tutoriel, une fois
    // (WelcomePage efface le drapeau avant de se fermer).
    ref.listen(welcomePendingProvider, (previous, next) {
      if (next.value == true && previous?.value != true) {
        unawaited(context.push(Routes.welcome));
      }
    });
    final colors = AppColors.of(context);
    final storeName = ref.watch(storeConfigProvider).value?.name;
    final dateLabel = DateFormat(
      'EEEE d MMMM',
      'fr_FR',
    ).format(ref.watch(todayProvider));

    void goTo(ShellBranch branch) =>
        StatefulNavigationShell.of(context).goBranch(branch.index);

    final guided = watchFirstStepsVisible(ref);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: AppSpacing.md,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              storeName == null || storeName.isEmpty ? 'Accueil' : storeName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              toBeginningOfSentenceCase(dateLabel, 'fr_FR'),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.metaRegular.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: AppSpacing.md),
            child: OfflineStatusIndicator(),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SyncFailedAlert(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: AppSpacing.lg),
              children: [
                const FirstStepsSection(),
                // Le chiffre d'affaires mène toujours l'écran ; la caisse suit,
                // en bandeau compact.
                TodaySummary(leading: !guided),
                const Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    AppSpacing.md,
                    AppSpacing.md,
                    0,
                  ),
                  child: _CashBox(),
                ),
                const AccountEmailBanner(),
                LowStockSection(onSeeStock: () => goTo(ShellBranch.inventory)),
                RecentSalesSection(
                  onSeeAll: () => goTo(ShellBranch.salesHistory),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Bandeau caisse sous le chiffre d'affaires : ouverte (statut et espèces
/// sur une ligne, entrée / sortie et clôture en liens) ou fermée (dernier
/// comptage, bouton d'ouverture).
class _CashBox extends ConsumerWidget {
  const _CashBox();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final meta = AppTypography.metaRegular.copyWith(
      color: colors.textSecondary,
      fontFeatures: AppTypography.tabularFigures,
    );
    final session = ref.watch(activeCashSessionProvider);
    final open = session.value;

    final Widget content;
    if (!session.hasValue && !session.hasError) {
      content = const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SkeletonBox(width: 120, height: 16),
          SkeletonBox(width: 96, height: 20),
        ],
      );
    } else if (session.hasError) {
      content = const StatusIndicator(
        label: 'Caisse indisponible',
        tone: StatusTone.error,
      );
    } else if (open == null) {
      content = _ClosedContent(meta: meta);
    } else {
      content = _OpenContent(session: open, meta: meta);
    }

    // Tout le bandeau ouvre « Ma caisse » (solde détaillé, historique des
    // sessions) ; les liens d'action gardent leur propre cible.
    return AppCard(
      onTap: () => context.push(Routes.cashRegister),
      padding: 0,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.sm + AppSpacing.xs,
          AppSpacing.xs,
          AppSpacing.xs,
        ),
        child: content,
      ),
    );
  }
}

class _OpenContent extends ConsumerWidget {
  const _OpenContent({required this.session, required this.meta});

  final CashSession session;
  final TextStyle meta;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(cashSummaryProvider(session.id));
    final values = summary.value;
    final expected = values?.expectedAmount;
    final mobile = values?.mobileMoneySales ?? Decimal.zero;
    final noActivity =
        values != null &&
        values.cashSalesCount == 0 &&
        mobile == Decimal.zero &&
        values.cashIn == Decimal.zero &&
        values.cashOut == Decimal.zero;
    final today = ref.watch(todayProvider);
    final since = sessionOpenedSinceLabel(session.openedAt, today);
    // Caisse oubliée la veille : on le dit, et la clôture passe devant.
    final stale = isOpenedBeforeToday(session.openedAt, today);

    Widget amount(TextStyle style) {
      if (expected != null) {
        return Text(
          formatFcfa(expected),
          style: style.copyWith(
            color: expected < Decimal.zero ? AppColors.of(context).error : null,
          ),
        );
      }
      if (summary.hasError) return Text('Solde indisponible', style: meta);
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: SkeletonBox(width: 120, height: 20),
      );
    }

    final link = TextButton.styleFrom(
      minimumSize: const Size(0, AppSpacing.buttonHeightSm),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
    );
    final detail = mobile > Decimal.zero
        ? 'Mobile money hors tiroir : ${formatFcfa(mobile)}'
        : noActivity
        ? 'Fond de caisse, aucune vente'
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: AppSpacing.sm),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: StatusIndicator(
                  label: stale ? 'Caisse non clôturée' : 'Caisse ouverte',
                  tone: stale ? StatusTone.warning : StatusTone.success,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Semantics(
                label: 'Espèces dans le tiroir',
                child: amount(AppTypography.figureSmall),
              ),
            ],
          ),
        ),
        const SizedBox(height: 2),
        Padding(
          padding: const EdgeInsets.only(right: AppSpacing.sm),
          child: Text(
            detail == null
                ? 'Espèces dans le tiroir, $since'
                : 'Espèces dans le tiroir, $since. $detail',
            style: meta,
          ),
        ),
        // Liens et non boutons : le bandeau reste discret sous le chiffre
        // d'affaires. La clôture passe devant quand la caisse date de la veille.
        Wrap(
          alignment: WrapAlignment.end,
          children: [
            TextButton(
              onPressed: () =>
                  context.push(stale ? Routes.cashClose : Routes.cashRegister),
              style: link,
              child: Text(stale ? 'Clôturer la caisse' : 'Entrée / sortie'),
            ),
            TextButton(
              onPressed: () =>
                  context.push(stale ? Routes.cashRegister : Routes.cashClose),
              style: link,
              child: Text(stale ? 'Entrée / sortie' : 'Clôturer'),
            ),
          ],
        ),
      ],
    );
  }
}

class _ClosedContent extends ConsumerWidget {
  const _ClosedContent({required this.meta});

  final TextStyle meta;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(localCashSessionHistoryProvider).value;
    final last = lastClosedSession(history);
    final counted = last?.countedAmount;
    // Premiers pas affichés : ils portent l'action (produit, puis caisse) ;
    // le bloc ne montre que l'état, pour ne pas la doubler.
    final guided = watchFirstStepsVisible(ref);
    // Marge droite et basse : le bandeau laisse sa place aux liens.
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm, bottom: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const StatusIndicator(
                label: 'Caisse fermée',
                tone: StatusTone.neutral,
              ),
              const SizedBox(width: AppSpacing.sm),
              if (last != null)
                Expanded(
                  child: Text(
                    'clôturée ${closureLabel(last.closedAt!)}',
                    textAlign: TextAlign.end,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: meta,
                  ),
                ),
            ],
          ),
          if (counted != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Expanded(child: Text('Dernier comptage', style: meta)),
                Text(formatFcfa(counted), style: AppTypography.figureSmall),
              ],
            ),
          ],
          if (!guided) ...[
            const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
            PrimaryButton(
              label: 'Ouvrir la caisse',
              onPressed: () => showOpenCashSession(context),
            ),
          ],
        ],
      ),
    );
  }
}

/// « aujourd'hui à 19:30 », « hier à 19:30 » ou « le 3 novembre à 19:30 ».
String closureLabel(DateTime closedAt, {DateTime? now}) {
  final local = closedAt.toLocal();
  final today = now ?? DateTime.now();
  final day = DateTime(local.year, local.month, local.day);
  final days = DateTime(
    today.year,
    today.month,
    today.day,
  ).difference(day).inDays;
  final time = DateFormat.Hm('fr_FR').format(local);
  return switch (days) {
    0 => 'aujourd’hui à $time',
    1 => 'hier à $time',
    _ => 'le ${DateFormat('d MMMM', 'fr_FR').format(local)} à $time',
  };
}

/// Message bloquant (seul aplat de couleur) : des envois ont échoué ; ils
/// sont gardés sur le téléphone.
class _SyncFailedAlert extends ConsumerWidget {
  const _SyncFailedAlert();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(syncOrchestratorProvider);
    final pending = ref.watch(pendingSyncCountProvider).value ?? 0;
    if (status is! SyncStatusError || pending == 0) {
      return const SizedBox.shrink();
    }
    final colors = AppColors.of(context);
    final style = AppTypography.body.copyWith(
      height: 1.4,
      color: colors.onErrorSubtle,
    );
    return ColoredBox(
      color: colors.errorSubtle,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.xs + 2,
          AppSpacing.xs + 2,
          AppSpacing.xs + 2,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: pending == 1
                          ? '1 envoi en échec. '
                          : '$pending envois en échec. ',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const TextSpan(text: 'Ils sont gardés sur ce téléphone.'),
                  ],
                ),
                style: style,
              ),
            ),
            TextButton(
              onPressed: () => unawaited(
                ref.read(syncOrchestratorProvider.notifier).syncNow(),
              ),
              style: TextButton.styleFrom(
                foregroundColor: colors.onErrorSubtle,
                textStyle: AppTypography.label.copyWith(
                  decoration: TextDecoration.underline,
                ),
              ),
              child: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }
}
