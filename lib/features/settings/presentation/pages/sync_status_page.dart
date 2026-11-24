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

/// Synchronisation : ce qui attend sur ce téléphone, l'éventuel échec, le
/// dernier envoi réussi, et « Envoyer maintenant ». Rassure d'abord : rien
/// n'est perdu tant que c'est sur le téléphone.
///
/// Statuts en point + mot (`StatusIndicator`), jamais d'encadré teinté (v2).
class SyncStatusPage extends ConsumerWidget {
  /// Crée la page.
  const SyncStatusPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final secondary = AppTypography.body.copyWith(color: colors.textSecondary);
    final status = ref.watch(syncOrchestratorProvider);
    final pending = ref.watch(pendingSyncCountProvider).value ?? 0;
    final isOnline = ref.watch(isOnlineProvider).value ?? true;
    final isSyncing = status is SyncStatusSyncing;
    final lastSyncAt = switch (status) {
      SyncStatusIdle(:final lastSyncAt) => lastSyncAt,
      SyncStatusError(:final lastSyncAt) => lastSyncAt,
      SyncStatusSyncing() => null,
    };

    return AppScaffold(
      title: 'Synchronisation',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("En attente d'envoi", style: secondary),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        pending == 0
                            ? 'Tout est envoyé'
                            : pending == 1
                            ? '1 modification'
                            : '$pending modifications',
                        style: AppTypography.figureHero,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        pending == 0
                            ? 'Ventes, retours, produits et caisse sont à '
                                  'jour sur le serveur.'
                            : 'Gardées sur ce téléphone, rien n’est perdu.',
                        style: secondary,
                      ),
                    ],
                  ),
                ),
                if (!isOnline) ...[
                  const SizedBox(height: AppSpacing.md),
                  const _Notice(
                    label: 'Pas de réseau',
                    tone: StatusTone.neutral,
                    message:
                        'Ventes et caisse fonctionnent. L’envoi reprendra '
                        'tout seul au retour de la connexion.',
                  ),
                ] else if (status case SyncStatusError(:final failedAt)) ...[
                  const SizedBox(height: AppSpacing.md),
                  _Notice(
                    label: failedAt == null
                        ? 'Envoi échoué'
                        : 'Envoi échoué à '
                              '${DateFormat.Hm('fr_FR').format(failedAt)}',
                    tone: StatusTone.error,
                    message:
                        'Nouvel essai automatique dans quelques minutes, ou '
                        'touchez « Envoyer maintenant ».',
                  ),
                ],
                const SizedBox(height: AppSpacing.md),
                DefinitionRow(
                  label: 'Dernier envoi réussi',
                  value: lastSyncAt == null
                      ? 'Pas encore depuis l’ouverture de l’app'
                      : _dayAndTime(lastSyncAt),
                  showDivider: false,
                ),
              ],
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              color: colors.surface,
              border: Border(top: BorderSide(color: colors.border)),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm + AppSpacing.xs,
                ),
                child: PrimaryButton(
                  label: 'Envoyer maintenant',
                  height: AppSpacing.buttonHeight,
                  isLoading: isSyncing,
                  loadingLabel: 'Envoi en cours…',
                  onPressed: isOnline && !isSyncing
                      ? () => ref
                            .read(syncOrchestratorProvider.notifier)
                            .syncNow()
                      : null,
                ),
              ),
            ),
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

/// Statut (point + mot) suivi d'une explication.
class _Notice extends StatelessWidget {
  const _Notice({
    required this.label,
    required this.tone,
    required this.message,
  });

  final String label;
  final StatusTone tone;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StatusIndicator(label: label, tone: tone, emphasized: true),
        const SizedBox(height: AppSpacing.xs),
        Text(
          message,
          style: AppTypography.body.copyWith(
            color: AppColors.of(context).textSecondary,
          ),
        ),
      ],
    );
  }
}
