import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'status_indicator.dart';

import '../providers/connectivity_provider.dart';
import '../sync/sync_orchestrator.dart';
import '../sync/sync_providers.dart';

/// Pastille compacte d'état réseau/synchro pour les en-têtes (caisse,
/// accueil).
///
/// N'apparaît que s'il y a quelque chose à signaler : hors ligne, ventes en
/// attente ou en échec. Tout envoyé, rien ne s'affiche (l'heure de la
/// dernière synchro reste dans Paramètres) : un « À jour » répété en haut de
/// chaque onglet n'apprenait rien et chargeait l'en-tête.
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

    final state = switch ((isOnline, syncStatus)) {
      (false, _) => ('Hors ligne', StatusTone.warning),
      _ when pendingCount == 0 => null,
      (true, SyncStatusSyncing()) => ('Synchro…', StatusTone.neutral),
      (true, SyncStatusError()) => ('Non envoyé', StatusTone.error),
      _ => ('$pendingCount en attente', StatusTone.neutral),
    };

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 150),
      child: switch (state) {
        null => const SizedBox.shrink(),
        (final label, final tone) => Semantics(
          key: ValueKey(label),
          label: 'Synchronisation : $label',
          excludeSemantics: true,
          child: StatusIndicator(label: label, tone: tone),
        ),
      },
    );
  }
}
