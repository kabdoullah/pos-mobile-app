import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'status_indicator.dart';

import '../providers/connectivity_provider.dart';
import '../sync/sync_orchestrator.dart';
import '../sync/sync_providers.dart';

/// Pastille compacte d'état réseau/synchro pour les en-têtes (caisse,
/// accueil).
///
/// Purement informative : la vente reste possible dans tous les états.
class OfflineStatusIndicator extends ConsumerWidget {
  /// Crée l'état de synchro.
  const OfflineStatusIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Tant que l'état réseau est inconnu, on suppose en ligne (pas d'alerte
    // parasite à l'ouverture).
    final isOnline = ref.watch(isOnlineProvider).value ?? true;
    final syncStatus = ref.watch(syncOrchestratorProvider);
    final pendingCount = ref.watch(pendingSyncCountProvider).value ?? 0;

    final (label, tone) = switch ((isOnline, syncStatus)) {
      (false, _) => ('Hors ligne', StatusTone.warning),
      (true, SyncStatusSyncing()) => ('Synchro…', StatusTone.neutral),
      (true, SyncStatusError()) when pendingCount > 0 => (
        'Non envoyé',
        StatusTone.error,
      ),
      _ when pendingCount > 0 => (
        '$pendingCount en attente',
        StatusTone.neutral,
      ),
      _ => ('À jour', StatusTone.success),
    };

    return Semantics(
      label: 'Synchronisation : $label',
      excludeSemantics: true,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 150),
        child: StatusIndicator(key: ValueKey(label), label: label, tone: tone),
      ),
    );
  }
}
