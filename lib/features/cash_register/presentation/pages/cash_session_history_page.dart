import 'dart:async';

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
      title: 'Historique des caisses',
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
    return AppListGroup(
      children: [
        for (final session in sessions) _SessionTile(session: session),
      ],
    );
  }
}

/// Une session : dates, statut et écart de clôture.
class _SessionTile extends StatelessWidget {
  const _SessionTile({required this.session});

  final CashSession session;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final muted = AppTypography.bodySmall.copyWith(color: cs.onSurfaceVariant);
    final dateFormat = DateFormat('d MMM yyyy à HH:mm', 'fr_FR');
    final closedAt = session.closedAt;
    final discrepancy = session.discrepancyAmount;
    final isOpen = session.status == CashSessionStatus.open;
    final subtitle = isOpen
        ? 'En cours'
        : closedAt == null
        ? 'Clôturée'
        : 'Clôturée le ${dateFormat.format(closedAt.toLocal())}';
    return InkWell(
      onTap: () => context.push(
        Routes.cashSessionDetail.replaceFirst(':id', session.id),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: AppSpacing.buttonHeight),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ouverte le ${dateFormat.format(session.openedAt.toLocal())}',
                      style: AppTypography.titleMedium,
                    ),
                    Text(subtitle, style: muted),
                    if (session.rejectionCode != null)
                      Text(
                        'Refusée par le serveur',
                        style: AppTypography.bodySmall.copyWith(
                          color: cs.error,
                        ),
                      )
                    else if (session.syncStatus == CashSyncStatus.pending)
                      Text('En attente de synchro', style: muted),
                    if (!isOpen && discrepancy != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      DiscrepancyBadge(discrepancy: discrepancy),
                    ],
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
            ],
          ),
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
          SkeletonBox(height: 72),
          SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}
