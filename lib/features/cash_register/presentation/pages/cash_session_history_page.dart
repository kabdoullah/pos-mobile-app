import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/providers/connectivity_provider.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/index.dart';
import '../../domain/entities/cash_session.dart';
import '../providers/cash_register_providers.dart';
import '../widgets/cash_notice_banner.dart';
import '../widgets/discrepancy_badge.dart';

/// « Sessions de caisse » : liste à plat du serveur en ligne (tous les
/// téléphones, paginée), sessions de ce téléphone hors ligne.
class CashSessionHistoryPage extends ConsumerWidget {
  /// Crée l'historique.
  const CashSessionHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final online = ref.watch(isOnlineProvider);
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Sessions de caisse'),
      ),
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
              padding: const EdgeInsets.only(
                top: AppSpacing.sm,
                bottom: AppSpacing.md,
              ),
              children: [
                _SessionList(sessions: sessions),
                const SizedBox(height: AppSpacing.sm),
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
        const CashNoticeBanner(
          title: 'Hors ligne',
          message:
              'Sessions de ce téléphone uniquement. Le détail des mouvements '
              's’affichera au retour du réseau.',
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
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
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
    return FlatList(
      children: [
        for (final session in sessions) _SessionTile(session: session),
      ],
    );
  }
}

/// Une session : jour, horaires et montant (fond ou compté), puis le statut
/// en point + mot (En cours, Refusée, En attente de synchro, Équilibrée,
/// Excédent, Écart).
class _SessionTile extends StatelessWidget {
  const _SessionTile({required this.session});

  final CashSession session;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final time = DateFormat.Hm('fr_FR');
    final openedAt = session.openedAt.toLocal();
    final closedAt = session.closedAt?.toLocal();
    final counted = session.countedAmount;
    final isOpen = session.status == CashSessionStatus.open;
    final day = toBeginningOfSentenceCase(
      DateFormat('EEEE d MMMM', 'fr_FR').format(openedAt),
      'fr_FR',
    );
    final details = isOpen || closedAt == null
        ? 'Ouverte à ${time.format(openedAt)} · fond '
              '${formatAmount(session.openingAmount)}'
        : '${time.format(openedAt)} → ${time.format(closedAt)}'
              '${counted == null ? '' : ' · compté ${formatAmount(counted)}'}';
    return InkWell(
      onTap: () => context.push(
        Routes.cashSessionDetail.replaceFirst(':id', session.id),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 60),
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
                    Text(day, style: AppTypography.bodyStrong),
                    Text(
                      details,
                      style: AppTypography.bodySmall.copyWith(
                        color: colors.textSecondary,
                        fontFeatures: AppTypography.tabularFigures,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              _SessionStatus(session: session),
            ],
          ),
        ),
      ),
    );
  }
}

/// Statut d'une session dans la liste.
class _SessionStatus extends StatelessWidget {
  const _SessionStatus({required this.session});

  final CashSession session;

  @override
  Widget build(BuildContext context) {
    final discrepancy = session.discrepancyAmount;
    final (label, tone) = switch (session) {
      CashSession(status: CashSessionStatus.open) => (
        'En cours',
        StatusTone.success,
      ),
      CashSession(rejectionCode: _?) => ('Refusée', StatusTone.error),
      CashSession(syncStatus: CashSyncStatus.pending) => (
        'En attente de synchro',
        StatusTone.warning,
      ),
      _ when discrepancy == null => ('Clôturée', StatusTone.neutral),
      _ when discrepancy == Decimal.zero => ('Équilibrée', StatusTone.success),
      _ when discrepancy > Decimal.zero => (
        'Excédent ${signedDiscrepancy(discrepancy)}',
        StatusTone.warning,
      ),
      _ => ('Écart ${signedDiscrepancy(discrepancy)}', StatusTone.error),
    };
    return StatusIndicator(label: label, tone: tone);
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
          SkeletonBox(height: 56),
          SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}
