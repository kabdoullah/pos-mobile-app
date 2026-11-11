import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../providers/connectivity_provider.dart';
import '../sync/sync_orchestrator.dart';
import '../sync/sync_providers.dart';

/// Pastille compacte d'état réseau/synchro pour l'AppBar (icône + mot) :
/// « À jour », « Envoi… », « N en attente », « Hors ligne », « Non envoyé ».
///
/// Seul indicateur permanent : le bandeau `SyncStatusIndicator` n'apparaît
/// qu'en cas d'anomalie. Purement informative, la vente reste possible dans
/// tous les états.
class OfflineStatusIndicator extends ConsumerWidget {
  /// Crée la pastille d'état réseau.
  const OfflineStatusIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final semantic = Theme.of(context).extension<AppSemanticColors>()!;
    // Tant que l'état réseau est inconnu, on suppose en ligne (pas d'alerte
    // parasite à l'ouverture).
    final isOnline = ref.watch(isOnlineProvider).value ?? true;
    final syncStatus = ref.watch(syncOrchestratorProvider);
    final pendingCount = ref.watch(pendingSyncCountProvider).value ?? 0;

    final neutral = (cs.surfaceContainerLow, cs.onSurface, true);
    final (icon, label, (background, foreground, bordered)) = switch ((
      isOnline,
      syncStatus,
    )) {
      (false, _) => (Icons.cloud_off_outlined, 'Hors ligne', neutral),
      (true, SyncStatusSyncing()) => (null, 'Envoi…', neutral),
      (true, SyncStatusError()) => (
        Icons.sync_problem_outlined,
        'Non envoyé',
        (cs.errorContainer, cs.onErrorContainer, false),
      ),
      _ when pendingCount > 0 => (
        Icons.cloud_upload_outlined,
        '$pendingCount en attente',
        neutral,
      ),
      _ => (
        Icons.check_circle_outline,
        'À jour',
        (semantic.successContainer, semantic.onSuccessContainer, false),
      ),
    };

    return Semantics(
      label: 'État de la synchronisation : $label',
      excludeSemantics: true,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 150),
        child: Container(
          key: ValueKey(label),
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md - 4),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            border: bordered ? Border.all(color: cs.outline) : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon == null)
                SizedBox.square(
                  dimension: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: foreground,
                  ),
                )
              else
                Icon(icon, size: 18, color: foreground),
              const SizedBox(width: 6),
              Text(
                label,
                maxLines: 1,
                style: AppTypography.labelMedium.copyWith(color: foreground),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
