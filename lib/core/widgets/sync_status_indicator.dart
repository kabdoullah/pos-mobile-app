import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../providers/connectivity_provider.dart';
import '../sync/sync_orchestrator.dart';
import '../sync/sync_providers.dart';

/// Bandeau d'anomalie de synchro, sous l'AppBar. Rien quand tout va bien :
/// l'état courant est porté par la pastille `OfflineStatusIndicator`.
///
/// - Hors ligne : ton neutre, rassurant — tout ce qui est local fonctionne.
/// - Envoi échoué : rassurer d'abord (rien n'est perdu), puis « Réessayer ».
class SyncStatusIndicator extends ConsumerWidget {
  /// Crée le bandeau d'anomalie.
  const SyncStatusIndicator({
    this.offlineTitle = 'Pas de réseau',
    this.offlineMessage = 'Ventes et caisse fonctionnent.',
    super.key,
  });

  /// Titre du bandeau hors ligne.
  final String offlineTitle;

  /// Phrase rassurante du bandeau hors ligne, avant le nombre d'envois en
  /// attente.
  final String offlineMessage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    // État réseau inconnu : pas d'alerte parasite à l'ouverture.
    final isOnline = ref.watch(isOnlineProvider).value ?? true;
    final syncStatus = ref.watch(syncOrchestratorProvider);
    final pendingCount = ref.watch(pendingSyncCountProvider).value ?? 0;

    if (!isOnline) {
      final pending = switch (pendingCount) {
        0 => '',
        1 => ' 1 modification en attente d’envoi.',
        _ => ' $pendingCount modifications en attente d’envoi.',
      };
      return _Banner(
        icon: Icons.cloud_off_outlined,
        title: offlineTitle,
        message: '$offlineMessage$pending',
        background: cs.surfaceContainerLow,
        foreground: cs.onSurface,
        divider: cs.outlineVariant,
      );
    }
    if (syncStatus is SyncStatusError) {
      return _Banner(
        icon: Icons.sync_problem_outlined,
        title: switch (pendingCount) {
          0 => 'Envoi échoué',
          1 => '1 modification non envoyée',
          _ => '$pendingCount modifications non envoyées',
        },
        message: 'Elles sont gardées sur ce téléphone.',
        background: cs.errorContainer,
        foreground: cs.onErrorContainer,
        actionLabel: 'Réessayer',
        onAction: () =>
            unawaited(ref.read(syncOrchestratorProvider.notifier).syncNow()),
      );
    }
    return const SizedBox.shrink();
  }
}

class _Banner extends StatelessWidget {
  const _Banner({
    required this.icon,
    required this.title,
    required this.message,
    required this.background,
    required this.foreground,
    this.divider,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final Color background;
  final Color foreground;
  final Color? divider;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final style = AppTypography.bodyMedium.copyWith(
      color: foreground,
      height: 1.35,
    );
    final divider = this.divider;
    return Semantics(
      liveRegion: true,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: background,
          border: divider == null
              ? null
              : Border(bottom: BorderSide(color: divider)),
        ),
        padding: EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.sm + 2,
          onAction == null ? AppSpacing.md : AppSpacing.xs,
          AppSpacing.sm + 2,
        ),
        child: Row(
          children: [
            Icon(icon, color: foreground),
            const SizedBox(width: AppSpacing.sm + 2),
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '$title\n',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    TextSpan(text: message),
                  ],
                ),
                style: style,
              ),
            ),
            if (onAction != null)
              TextButton(
                onPressed: onAction,
                style: TextButton.styleFrom(
                  foregroundColor: foreground,
                  textStyle: AppTypography.labelLarge.copyWith(
                    decoration: TextDecoration.underline,
                  ),
                ),
                child: Text(actionLabel ?? 'Réessayer'),
              ),
          ],
        ),
      ),
    );
  }
}
