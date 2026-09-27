import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../providers/connectivity_provider.dart';
import '../sync/sync_orchestrator.dart';
import '../sync/sync_providers.dart';

/// Pastille compacte d'état réseau/synchro pour les en-têtes (caisse,
/// accueil).
///
/// Purement informative : la vente reste possible dans tous les états.
class OfflineStatusIndicator extends ConsumerWidget {
  /// Crée la pastille d'état réseau.
  const OfflineStatusIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    // Tant que l'état réseau est inconnu, on suppose en ligne (pas d'alerte
    // parasite à l'ouverture).
    final isOnline = ref.watch(isOnlineProvider).value ?? true;
    final syncStatus = ref.watch(syncOrchestratorProvider);
    final pendingCount = ref.watch(pendingSyncCountProvider).value ?? 0;

    final (icon, label, color) = switch ((isOnline, syncStatus)) {
      (false, _) => (Icons.cloud_off_outlined, 'Hors ligne', cs.tertiary),
      (true, SyncStatusSyncing()) => (null, 'Synchro…', cs.primary),
      (true, SyncStatusError()) => (
        Icons.sync_problem_outlined,
        'Non synchronisé',
        cs.error,
      ),
      _ when pendingCount > 0 => (
        Icons.cloud_upload_outlined,
        '$pendingCount en attente',
        cs.onSurfaceVariant,
      ),
      _ => (Icons.cloud_done_outlined, 'En ligne', cs.onSurfaceVariant),
    };

    return Semantics(
      label: 'État réseau : $label',
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 150),
        child: Row(
          key: ValueKey(label),
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon == null)
              SizedBox.square(
                dimension: 14,
                child: CircularProgressIndicator(strokeWidth: 2, color: color),
              )
            else
              Icon(icon, size: 16, color: color),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: AppTypography.captionText.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
