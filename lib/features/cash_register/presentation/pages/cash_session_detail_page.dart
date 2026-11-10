import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../../domain/entities/cash_movement.dart';
import '../../domain/entities/cash_session.dart';
import '../../domain/entities/cash_session_detail.dart';
import '../../domain/entities/cash_summary.dart';
import '../../domain/repositories/cash_register_repository.dart';
import '../cash_register_messages.dart';
import '../providers/cash_register_providers.dart';
import '../widgets/cash_movement_tile.dart';
import '../widgets/cash_notice_banner.dart';
import '../widgets/cash_summary_card.dart';
import '../widgets/discrepancy_badge.dart';

/// Détail d'une session de caisse : chiffres, avertissements (recalcul
/// serveur, opérations après clôture, retour refusé, refus de clôture) et
/// mouvements.
///
/// Une session de ce téléphone s'affiche d'après l'appareil, enrichie en
/// ligne par le serveur une fois synchronisée. Une session d'un autre
/// téléphone ne se lit qu'en ligne.
class CashSessionDetailPage extends ConsumerWidget {
  /// Crée le détail de la session [sessionId].
  const CashSessionDetailPage({required this.sessionId, super.key});

  /// Identifiant de la session.
  final String sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final local = ref.watch(localCashSessionProvider(sessionId));
    final remote = ref.watch(remoteCashSessionDetailProvider(sessionId));
    void retry() {
      ref
        ..invalidate(localCashSessionProvider(sessionId))
        ..invalidate(remoteCashSessionDetailProvider(sessionId));
    }

    final Widget body;
    if (local.isLoading && !local.hasValue) {
      body = const _DetailSkeleton();
    } else if (local.value case final session?) {
      // Session de ce téléphone : le serveur ne complète les chiffres qu'une
      // fois tout synchronisé (sinon il ne connaît pas encore la clôture).
      final serverDetail = session.syncStatus == CashSyncStatus.synced
          ? remote.value
          : null;
      body = _LocalSessionBody(session: session, serverDetail: serverDetail);
    } else {
      body = remote.when(
        loading: () => const _DetailSkeleton(),
        error: (_, _) => EmptyState(
          icon: Icons.cloud_off_outlined,
          title: 'Session indisponible',
          message: 'Vérifiez votre connexion puis réessayez.',
          actionLabel: 'Réessayer',
          onAction: retry,
        ),
        data: (detail) => detail == null
            ? EmptyState(
                icon: Icons.cloud_off_outlined,
                title: 'Session introuvable hors ligne',
                message:
                    "Cette session vient d'un autre téléphone. Connectez-vous "
                    'à Internet pour la consulter.',
                actionLabel: 'Réessayer',
                onAction: retry,
              )
            : _SessionBody(
                session: detail.session,
                summary: CashSummaryCard.fromServer(
                  detail.summary,
                  expectedAmount: detail.session.expectedAmount,
                  expectedLabel: _expectedLabel(detail.session),
                  caption: _openedCaption(detail.session),
                ),
                notices: _serverNotices(detail),
                movements: detail.movements,
              ),
      );
    }

    return AppScaffold(title: 'Session de caisse', body: body);
  }
}

String _expectedLabel(CashSession session) =>
    session.status == CashSessionStatus.closed
    ? 'Solde théorique à la clôture'
    : 'Solde théorique';

String _openedCaption(CashSession session) => DateFormat(
  "'Ouverte le' d MMM yyyy 'à' HH:mm",
  'fr_FR',
).format(session.openedAt.toLocal());

/// Avertissements tirés du serveur : recalcul et opérations arrivées après
/// la clôture.
List<Widget> _serverNotices(CashSessionDetail detail) {
  final session = detail.session;
  final summary = detail.summary;
  if (session.status != CashSessionStatus.closed) return const [];
  final expected = session.expectedAmount ?? summary.expectedAmount;
  final shown = session.clientExpectedAmount;
  final lateImpact = summary.lateImpact;
  return [
    if (summary.serverRecalculated)
      CashNoticeBanner(
        message: shown == null
            ? 'Montant recalculé par le serveur : ${formatFcfa(expected)}'
            : 'Montant recalculé par le serveur : ${formatFcfa(expected)} '
                  '(affiché : ${formatFcfa(shown)})',
      ),
    if (lateImpact != Decimal.zero)
      CashNoticeBanner(
        level: CashNoticeLevel.warning,
        message:
            'Opérations arrivées après clôture : '
            '${lateImpact > Decimal.zero ? '+' : ''}${formatFcfa(lateImpact)}',
      ),
  ];
}

/// Session de ce téléphone : chiffres locaux, ou du serveur s'il les a.
class _LocalSessionBody extends ConsumerWidget {
  const _LocalSessionBody({required this.session, this.serverDetail});

  final CashSession session;
  final CashSessionDetail? serverDetail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localSummary = ref.watch(cashSummaryProvider(session.id));
    final localMovements = ref.watch(cashMovementsProvider(session.id));
    final serverDetail = this.serverDetail;
    final frozenExpected = session.expectedAmount;
    final rejectedRefunds = localSummary.value?.rejectedCashRefunds;
    final rejectionCode = session.rejectionCode;

    final Widget summary;
    if (serverDetail != null) {
      summary = CashSummaryCard.fromServer(
        serverDetail.summary,
        expectedAmount: frozenExpected,
        expectedLabel: _expectedLabel(session),
        caption: _openedCaption(session),
      );
    } else {
      summary = localSummary.when(
        loading: () => const SkeletonBox(height: 280),
        error: (e, _) => CashNoticeBanner(
          level: CashNoticeLevel.error,
          message: cashRegisterErrorMessage(e),
        ),
        data: (CashSummary s) => CashSummaryCard.fromSummary(
          s,
          expectedAmount: frozenExpected,
          expectedLabel: _expectedLabel(session),
          caption: _openedCaption(session),
        ),
      );
    }

    final notices = <Widget>[
      if (rejectionCode == CashRegisterException.closingNoteRequired)
        _ClosingNoteRequiredBanner(sessionId: session.id)
      else if (rejectionCode != null)
        CashNoticeBanner(
          level: CashNoticeLevel.error,
          title: 'Refusé par le serveur',
          message: cashRegisterMessage(rejectionCode),
        )
      else if (session.status == CashSessionStatus.closed &&
          session.syncStatus == CashSyncStatus.pending)
        const CashNoticeBanner(
          message:
              'Clôture en attente de synchronisation : les chiffres du '
              'serveur arriveront au retour de la connexion.',
        ),
      if (serverDetail != null)
        ..._serverNotices(serverDetail)
      else if (session.serverRecalculated && frozenExpected != null)
        CashNoticeBanner(
          message: session.clientExpectedAmount == null
              ? 'Montant recalculé par le serveur : '
                    '${formatFcfa(frozenExpected)}'
              : 'Montant recalculé par le serveur : '
                    '${formatFcfa(frozenExpected)} '
                    '(affiché : ${formatFcfa(session.clientExpectedAmount!)})',
        ),
      if (rejectedRefunds != null && rejectedRefunds > Decimal.zero)
        CashNoticeBanner(
          level: CashNoticeLevel.warning,
          message:
              'Retour refusé : ${formatFcfa(rejectedRefunds)} rendus non '
              'comptés',
        ),
    ];

    return _SessionBody(
      session: session,
      summary: summary,
      notices: notices,
      movements: serverDetail?.movements ?? localMovements.value,
      movementsError: serverDetail == null && localMovements.hasError,
    );
  }
}

/// Mise en page commune : avertissements, chiffres, clôture, mouvements.
class _SessionBody extends StatelessWidget {
  const _SessionBody({
    required this.session,
    required this.summary,
    required this.notices,
    required this.movements,
    this.movementsError = false,
  });

  final CashSession session;
  final Widget summary;
  final List<Widget> notices;

  /// Mouvements ; null pendant le chargement.
  final List<CashMovement>? movements;
  final bool movementsError;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final movements = this.movements;
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.xl,
      ),
      children: [
        for (final notice in notices) ...[
          notice,
          const SizedBox(height: AppSpacing.sm),
        ],
        if (notices.isNotEmpty) const SizedBox(height: AppSpacing.sm),
        summary,
        if (session.status == CashSessionStatus.closed) ...[
          const SizedBox(height: AppSpacing.md),
          _ClosingCard(session: session),
        ],
        const SizedBox(height: AppSpacing.lg),
        SectionHeader(
          title: 'Mouvements',
          count: movements == null || movements.isEmpty
              ? null
              : movements.length,
        ),
        if (movementsError)
          const CashNoticeBanner(
            level: CashNoticeLevel.error,
            message: 'Impossible de lire les mouvements.',
          )
        else if (movements == null)
          const SkeletonBox(height: 120)
        else if (movements.isEmpty)
          Text(
            "Aucune entrée ni sortie d'espèces.",
            style: AppTypography.bodyMedium.copyWith(
              color: cs.onSurfaceVariant,
            ),
          )
        else
          AppListGroup(
            dividerIndent: AppSpacing.md + 36 + AppSpacing.md,
            children: [
              for (final movement in movements)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  child: CashMovementTile(movement: movement),
                ),
            ],
          ),
      ],
    );
  }
}

/// Résultat de la clôture : montant compté, écart, date et commentaire.
class _ClosingCard extends StatelessWidget {
  const _ClosingCard({required this.session});

  final CashSession session;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final muted = AppTypography.bodyMedium.copyWith(color: cs.onSurfaceVariant);
    final counted = session.countedAmount;
    final discrepancy = session.discrepancyAmount;
    final closedAt = session.closedAt;
    final note = session.closingNote;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Clôture', style: AppTypography.titleMedium),
          if (closedAt != null)
            Text(
              DateFormat(
                "'Le' d MMM yyyy 'à' HH:mm",
                'fr_FR',
              ).format(closedAt.toLocal()),
              style: muted,
            ),
          if (counted != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Semantics(
              container: true,
              label: 'Montant compté : ${formatFcfa(counted)}',
              excludeSemantics: true,
              child: Row(
                children: [
                  Expanded(child: Text('Montant compté', style: muted)),
                  AmountDisplay(amount: counted),
                ],
              ),
            ),
          ],
          if (discrepancy != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: Alignment.centerLeft,
              child: DiscrepancyBadge(discrepancy: discrepancy),
            ),
          ],
          if (note != null && note.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text('Commentaire : $note', style: muted),
          ],
        ],
      ),
    );
  }
}

/// Clôture refusée faute de commentaire : le serveur a recalculé un autre
/// solde. Le commerçant saisit un commentaire et renvoie la clôture.
class _ClosingNoteRequiredBanner extends ConsumerStatefulWidget {
  const _ClosingNoteRequiredBanner({required this.sessionId});

  final String sessionId;

  @override
  ConsumerState<_ClosingNoteRequiredBanner> createState() =>
      _ClosingNoteRequiredBannerState();
}

class _ClosingNoteRequiredBannerState
    extends ConsumerState<_ClosingNoteRequiredBanner> {
  final _controller = TextEditingController();
  String? _error;
  bool _isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _resubmit() async {
    final note = _controller.text.trim();
    if (note.isEmpty) {
      setState(() => _error = "Expliquez l'écart avant de renvoyer.");
      return;
    }
    final messenger = ScaffoldMessenger.of(context);
    setState(() {
      _error = null;
      _isLoading = true;
    });
    try {
      await ref
          .read(cashRegisterControllerProvider.notifier)
          .resubmitCloseWithNote(widget.sessionId, note);
      messenger.showSnackBar(
        const SnackBar(content: Text('Clôture renvoyée avec le commentaire')),
      );
    } catch (e) {
      if (mounted) setState(() => _error = cashRegisterErrorMessage(e));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CashNoticeBanner(
      level: CashNoticeLevel.error,
      title: 'Le serveur exige un commentaire pour cet écart',
      message:
          'Le solde recalculé par le serveur diffère de celui du téléphone. '
          'Expliquez l’écart pour terminer la clôture.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            label: 'Commentaire (obligatoire)',
            controller: _controller,
            errorText: _error,
            maxLines: 3,
            maxLength: CashRegisterException.maxNoteLength,
            onChanged: (_) {
              if (_error != null) setState(() => _error = null);
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          PrimaryButton(
            label: 'Renvoyer la clôture',
            icon: Icons.send_outlined,
            isLoading: _isLoading,
            onPressed: _isLoading ? null : _resubmit,
          ),
        ],
      ),
    );
  }
}

class _DetailSkeleton extends StatelessWidget {
  const _DetailSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: const [
        SkeletonBox(height: 280),
        SizedBox(height: AppSpacing.md),
        SkeletonBox(height: 120),
      ],
    );
  }
}
