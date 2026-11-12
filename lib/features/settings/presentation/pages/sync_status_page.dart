import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/providers/connectivity_provider.dart';
import '../../../../core/sync/sync_orchestrator.dart';
import '../../../../core/sync/sync_providers.dart';
import '../../../../core/widgets/index.dart';

/// Synchronisation : ce qui attend sur ce téléphone, ce qui a échoué, le
/// dernier envoi réussi, et une action « Envoyer maintenant ». Rassure
/// d'abord : rien n'est perdu tant que c'est sur le téléphone.
class SyncStatusPage extends ConsumerWidget {
  /// Crée la page.
  const SyncStatusPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final semantic = Theme.of(context).extension<AppSemanticColors>()!;
    final muted = AppTypography.bodyMedium.copyWith(color: cs.onSurfaceVariant);
    final status = ref.watch(syncOrchestratorProvider);
    final pending = ref.watch(pendingSyncCountProvider).value ?? 0;
    final isOnline = ref.watch(isOnlineProvider).value ?? true;
    final lastSyncAt = switch (status) {
      SyncStatusIdle(:final lastSyncAt) => lastSyncAt,
      SyncStatusError(:final lastSyncAt) => lastSyncAt,
      SyncStatusSyncing() => null,
    };
    final isSyncing = status is SyncStatusSyncing;

    return AppScaffold(
      title: 'Synchronisation',
      // Le bandeau hors ligne redirait ce que la page explique déjà.
      showOfflineBanner: false,
      bottomActions: [
        PrimaryButton(
          label: 'Envoyer maintenant',
          icon: Icons.cloud_upload_outlined,
          isLoading: isSyncing,
          loadingLabel: 'Envoi en cours…',
          onPressed: isOnline && !isSyncing
              ? () => ref.read(syncOrchestratorProvider.notifier).syncNow()
              : null,
        ),
      ],
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("En attente d'envoi", style: muted),
                Text(
                  pending == 0
                      ? 'Tout est envoyé'
                      : pending == 1
                      ? '1 modification'
                      : '$pending modifications',
                  style: AppTypography.amountDisplay.copyWith(
                    color: cs.onSurface,
                  ),
                ),
                Text(
                  pending == 0
                      ? 'Ventes, retours, produits et caisse sont à jour sur '
                            'le serveur.'
                      : 'Gardées sur ce téléphone, rien n’est perdu.',
                  style: muted,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm + 4),
          if (!isOnline)
            _Notice(
              background: cs.surfaceContainerLow,
              foreground: cs.onSurface,
              border: cs.outlineVariant,
              title: 'Pas de réseau',
              message:
                  'Ventes et caisse fonctionnent. L’envoi reprendra tout seul '
                  'au retour de la connexion.',
            )
          else if (status case SyncStatusError(:final failedAt))
            _Notice(
              background: cs.errorContainer,
              foreground: cs.onErrorContainer,
              title: failedAt == null
                  ? 'Envoi échoué'
                  : 'Envoi échoué à ${DateFormat.Hm('fr_FR').format(failedAt)}',
              message:
                  'Nouvel essai automatique dans quelques minutes, ou '
                  'touchez « Envoyer maintenant ».',
            ),
          if (!isOnline || status is SyncStatusError)
            const SizedBox(height: AppSpacing.sm + 4),
          AppListGroup(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm + 4,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dernier envoi réussi',
                            style: AppTypography.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            lastSyncAt == null
                                ? 'Pas encore depuis l’ouverture de l’app'
                                : _dayAndTime(lastSyncAt),
                            style: AppTypography.bodySmall.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (lastSyncAt != null)
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: semantic.successContainer,
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusSm,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: 3,
                          ),
                          child: Text(
                            'OK',
                            style: AppTypography.labelMedium.copyWith(
                              color: semantic.onSuccessContainer,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// « Aujourd'hui · 11:35 » ou « 10 nov. · 11:35 ».
  static String _dayAndTime(DateTime at) {
    final now = DateTime.now();
    final time = DateFormat.Hm('fr_FR').format(at);
    final isToday =
        at.year == now.year && at.month == now.month && at.day == now.day;
    return isToday
        ? "Aujourd'hui · $time"
        : '${DateFormat('d MMM', 'fr_FR').format(at)} · $time';
  }
}

/// Encadré d'information (hors ligne, échec d'envoi).
class _Notice extends StatelessWidget {
  const _Notice({
    required this.background,
    required this.foreground,
    required this.title,
    required this.message,
    this.border,
  });

  final Color background;
  final Color foreground;
  final Color? border;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final style = AppTypography.bodyMedium.copyWith(color: foreground);
    final border = this.border;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: border == null ? null : Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: style.copyWith(fontWeight: FontWeight.w700)),
          Text(message, style: style),
        ],
      ),
    );
  }
}
