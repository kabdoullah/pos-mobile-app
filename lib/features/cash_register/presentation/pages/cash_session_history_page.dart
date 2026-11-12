import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/providers/connectivity_provider.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/index.dart';
import '../../domain/entities/cash_session.dart';
import '../providers/cash_register_providers.dart';
import '../widgets/cash_notice_banner.dart';
import '../widgets/discrepancy_badge.dart';

/// Historique des sessions de caisse : liste du serveur en ligne (tous les
/// téléphones, paginée), sessions de ce téléphone hors ligne.
class CashSessionHistoryPage extends ConsumerWidget {
  /// Crée l'historique.
  const CashSessionHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final online = ref.watch(isOnlineProvider);
    return AppScaffold(
      title: 'Sessions de caisse',
      body: online.when(
        loading: () => const _HistorySkeleton(),
        // Connectivité inconnue : on montre ce qui est sur le téléphone.
        error: (_, _) => const _LocalHistory(),
        data: (isOnline) =>
            isOnline ? const _RemoteHistory() : const _LocalHistory(),
      ),
    );
  }
}

/// Sessions de la boutique lues sur le serveur, page par page.
class _RemoteHistory extends ConsumerWidget {
  const _RemoteHistory();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(cashSessionHistoryProvider);
    final notifier = ref.read(cashSessionHistoryProvider.notifier);
    return RefreshIndicator(
      onRefresh: notifier.refresh,
      child: history.when(
        loading: () => const _HistorySkeleton(),
        error: (_, _) => _FullHeight(
          child: EmptyState(
            icon: Icons.cloud_off_outlined,
            title: "Impossible de charger l'historique",
            message: 'Vérifiez votre connexion puis réessayez.',
            actionLabel: 'Réessayer',
            onAction: notifier.refresh,
          ),
        ),
        data: (sessions) {
          if (sessions.isEmpty) {
            return const _FullHeight(child: _EmptyHistory());
          }
          return NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollEndNotification) {
                final metrics = notification.metrics;
                if (metrics.pixels >= metrics.maxScrollExtent - 300) {
                  unawaited(notifier.loadMore());
                }
              }
              return false;
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                _SessionList(sessions: sessions),
                const SizedBox(height: AppSpacing.md),
                // Bouton en plus du défilement : une première page courte ne
                // déclenche aucun défilement.
                if (notifier.hasMore)
                  Center(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        minimumSize: const Size(0, AppSpacing.buttonHeightSm),
                      ),
                      onPressed: notifier.loadMore,
                      child: Text(
                        notifier.loadMoreFailed
                            ? 'Échec du chargement · Réessayer'
                            : 'Voir les sessions plus anciennes',
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Sessions enregistrées sur ce téléphone (hors ligne).
class _LocalHistory extends ConsumerWidget {
  const _LocalHistory();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final local = ref.watch(localCashSessionHistoryProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.md,
            0,
          ),
          child: CashNoticeBanner(
            message: 'Hors ligne : sessions de ce téléphone uniquement',
          ),
        ),
        Expanded(
          child: local.when(
            loading: () => const _HistorySkeleton(),
            error: (_, _) => EmptyState(
              icon: Icons.error_outline,
              title: "Impossible de lire l'historique",
              message: 'Les sessions de ce téléphone sont illisibles.',
              actionLabel: 'Réessayer',
              onAction: () => ref.invalidate(localCashSessionHistoryProvider),
            ),
            data: (sessions) => sessions.isEmpty
                ? const _EmptyHistory()
                : ListView(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    children: [_SessionList(sessions: sessions)],
                  ),
          ),
        ),
      ],
    );
  }
}

class _SessionList extends StatelessWidget {
  const _SessionList({required this.sessions});

  final List<CashSession> sessions;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (i, session) in sessions.indexed) ...[
          if (i > 0) const SizedBox(height: AppSpacing.sm + 4),
          _SessionTile(session: session),
        ],
      ],
    );
  }
}

/// Une session : jour, état de clôture, heures, fond de caisse et montant
/// compté — l'écart se lit sans ouvrir le détail.
class _SessionTile extends StatelessWidget {
  const _SessionTile({required this.session});

  final CashSession session;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final muted = AppTypography.bodyMedium.copyWith(color: cs.onSurfaceVariant);
    final hour = DateFormat.Hm('fr_FR');
    final openedAt = session.openedAt.toLocal();
    final closedAt = session.closedAt?.toLocal();
    final discrepancy = session.discrepancyAmount;
    final counted = session.countedAmount;
    final isOpen = session.status == CashSessionStatus.open;
    final day = toBeginningOfSentenceCase(
      DateFormat('EEE d MMM', 'fr_FR').format(openedAt),
      'fr_FR',
    );
    final hours = closedAt == null
        ? '${hour.format(openedAt)} → …'
        : '${hour.format(openedAt)} → ${hour.format(closedAt)}';
    final amounts = counted == null
        ? formatAmount(session.openingAmount)
        : '${formatAmount(session.openingAmount)} · ${formatAmount(counted)}';

    return AppCard(
      onTap: () => context.push(
        Routes.cashSessionDetail.replaceFirst(':id', session.id),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  day,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (isOpen)
                _Tag(
                  label: 'En cours',
                  background: cs.primaryContainer,
                  foreground: cs.onPrimaryContainer,
                )
              else if (discrepancy != null)
                _DiscrepancyTag(discrepancy: discrepancy),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(hours, style: muted),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Expanded(
                child: Text(
                  counted == null ? 'Fond' : 'Fond · Compté',
                  style: muted,
                ),
              ),
              Text(
                amounts,
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  fontFeatures: AppTypography.tabularFigures,
                ),
              ),
            ],
          ),
          if (session.rejectionCode != null)
            Text(
              'Refusée par le serveur',
              style: AppTypography.bodyMedium.copyWith(color: cs.error),
            )
          else if (session.syncStatus == CashSyncStatus.pending)
            Text('En attente de synchro', style: muted),
        ],
      ),
    );
  }
}

/// « Équilibrée » ou « Écart − 1 175 » sur la couleur de l'état.
class _DiscrepancyTag extends StatelessWidget {
  const _DiscrepancyTag({required this.discrepancy});

  final Decimal discrepancy;

  @override
  Widget build(BuildContext context) {
    final colors = discrepancyColors(context, discrepancy);
    final label = switch (DiscrepancyKind.of(discrepancy)) {
      DiscrepancyKind.balanced => 'Équilibrée',
      DiscrepancyKind.surplus => 'Écart + ${formatAmount(discrepancy)}',
      DiscrepancyKind.deficit => 'Écart − ${formatAmount(discrepancy.abs())}',
    };
    return Semantics(
      label: discrepancyLabel(discrepancy),
      excludeSemantics: true,
      child: _Tag(
        label: label,
        background: colors.background,
        foreground: colors.foreground,
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({
    required this.label,
    required this.background,
    required this.foreground,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Text(
        label,
        style: AppTypography.labelMedium.copyWith(
          color: foreground,
          fontWeight: FontWeight.w700,
          fontFeatures: AppTypography.tabularFigures,
        ),
      ),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    return const EmptyState(
      icon: Icons.history,
      title: 'Aucune session de caisse',
      message: 'Les caisses ouvertes et clôturées apparaîtront ici.',
    );
  }
}

/// Garde l'état vide ou d'erreur défilable pour « tirer pour rafraîchir ».
class _FullHeight extends StatelessWidget {
  const _FullHeight({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(height: constraints.maxHeight, child: child),
      ),
    );
  }
}

class _HistorySkeleton extends StatelessWidget {
  const _HistorySkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        for (var i = 0; i < 5; i++) ...const [
          SkeletonBox(height: 108, radius: AppSpacing.radiusMd),
          SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}
