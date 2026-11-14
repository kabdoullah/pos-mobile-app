import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../../domain/entities/cash_count.dart';
import '../../domain/entities/cash_movement.dart';
import '../../domain/entities/cash_session.dart';
import '../../domain/entities/cash_session_detail.dart';
import '../../domain/entities/cash_summary.dart';
import '../../domain/repositories/cash_register_repository.dart';
import '../cash_register_messages.dart';
import '../providers/cash_register_providers.dart';
import '../widgets/cash_movement_tile.dart';
import '../widgets/cash_count_details.dart';
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
    final localSession = local.value;
    // Le serveur n'est interrogé que s'il peut compléter l'affichage : session
    // d'un autre téléphone, ou session locale entièrement synchronisée (en
    // attente ou refusée, il ne connaît pas encore la clôture).
    final needsServer =
        !(local.isLoading && !local.hasValue) &&
        (localSession == null ||
            localSession.syncStatus == CashSyncStatus.synced);
    final remote = needsServer
        ? ref.watch(remoteCashSessionDetailProvider(sessionId))
        : const AsyncValue<CashSessionDetail?>.data(null);
    void retry() {
      ref
        ..invalidate(localCashSessionProvider(sessionId))
        ..invalidate(remoteCashSessionDetailProvider(sessionId));
    }

    final Widget body;
    if (local.isLoading && !local.hasValue) {
      body = const _DetailSkeleton();
    } else if (localSession != null) {
      body = _LocalSessionBody(
        session: localSession,
        serverDetail: remote.value,
      );
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
                openingCount: detail.openingCount,
                closingCount: detail.closingCount,
              ),
      );
    }

    final openedAt = (localSession ?? remote.value?.session)?.openedAt;
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(
          openedAt == null
              ? 'Session de caisse'
              : 'Session du '
                    '${DateFormat('d MMM', 'fr_FR').format(openedAt.toLocal())}',
        ),
      ),
      body: body,
    );
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
    // Comptages : ceux de l'appareil, sinon ceux du serveur (session
    // restaurée).
    final openingCount =
        ref
            .watch(
              localCashCountProvider(session.id, CashCountOperation.opening),
            )
            .value ??
        serverDetail?.openingCount;
    final closingCount =
        ref
            .watch(
              localCashCountProvider(session.id, CashCountOperation.closing),
            )
            .value ??
        serverDetail?.closingCount;
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
        loading: () => const Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: SkeletonBox(height: 280),
        ),
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
          title: 'Retour refusé',
          message:
              '${formatFcfa(rejectedRefunds)} rendus non comptés dans le '
              'solde.',
        ),
    ];

    return _SessionBody(
      session: session,
      summary: summary,
      notices: notices,
      movements: serverDetail?.movements ?? localMovements.value,
      movementsError: serverDetail == null && localMovements.hasError,
      openingCount: openingCount,
      closingCount: closingCount,
    );
  }
}

/// Mise en page commune : avertissements en tête, statut, chiffres,
/// comptage d'ouverture, clôture et son comptage, mouvements.
class _SessionBody extends StatelessWidget {
  const _SessionBody({
    required this.session,
    required this.summary,
    required this.notices,
    required this.movements,
    this.movementsError = false,
    this.openingCount,
    this.closingCount,
  });

  final CashSession session;
  final Widget summary;
  final List<Widget> notices;

  /// Billetterie d'ouverture et de clôture ; null en « Total seulement ».
  final CashCount? openingCount;
  final CashCount? closingCount;

  /// Mouvements ; null pendant le chargement.
  final List<CashMovement>? movements;
  final bool movementsError;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final movements = this.movements;
    final isClosed = session.status == CashSessionStatus.closed;
    final (syncLabel, syncTone) = switch (session) {
      CashSession(rejectionCode: _?) => ('Refusée', StatusTone.error),
      CashSession(syncStatus: CashSyncStatus.pending) => (
        'En attente de synchro',
        StatusTone.warning,
      ),
      _ => ('Synchronisée', StatusTone.success),
    };
    return ListView(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      children: [
        ...notices,
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.md,
          ),
          child: Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.xs,
            children: [
              StatusIndicator(
                label: isClosed ? 'Clôturée' : 'En cours',
                tone: isClosed ? StatusTone.success : StatusTone.neutral,
              ),
              StatusIndicator(label: syncLabel, tone: syncTone),
            ],
          ),
        ),
        summary,
        if (openingCount case final count?)
          CashCountDetails(
            title:
                "Comptage d'ouverture · "
                '${DateFormat.Hm('fr_FR').format(session.openedAt.toLocal())}',
            count: count,
            collapsible: true,
          ),
        if (isClosed) _Closing(session: session),
        if (closingCount case final count?)
          CashCountDetails(
            title: switch (session.closedAt) {
              final closedAt? =>
                'Comptage de clôture · '
                    '${DateFormat.Hm('fr_FR').format(closedAt.toLocal())}',
              null => 'Comptage de clôture',
            },
            count: count,
          ),
        const OverlineHeader('Mouvements'),
        if (movementsError)
          const CashNoticeBanner(
            level: CashNoticeLevel.error,
            message: 'Impossible de lire les mouvements.',
          )
        else if (movements == null)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: SkeletonBox(height: 120),
          )
        else if (movements.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Text(
              "Aucune entrée ni sortie d'espèces.",
              style: AppTypography.body.copyWith(color: colors.textSecondary),
            ),
          )
        else
          FlatList(
            children: [
              for (final movement in movements)
                CashMovementTile(movement: movement),
            ],
          ),
      ],
    );
  }
}

/// Résultat de la clôture : heure, montant compté, écart et commentaire.
class _Closing extends StatelessWidget {
  const _Closing({required this.session});

  final CashSession session;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final counted = session.countedAmount;
    final discrepancy = session.discrepancyAmount;
    final closedAt = session.closedAt;
    final note = session.closingNote;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OverlineHeader(
          closedAt == null
              ? 'Clôture'
              : 'Clôture · ${DateFormat.Hm('fr_FR').format(closedAt.toLocal())}',
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (counted != null)
                DefinitionRow(label: 'Compté', value: formatFcfa(counted)),
              if (discrepancy != null)
                DefinitionRow(
                  label: discrepancyRowLabel(discrepancy),
                  value: signedDiscrepancy(discrepancy),
                  color: discrepancyTone(discrepancy).colorIn(context),
                  semanticsLabel: discrepancyLabel(discrepancy),
                  showDivider: note != null && note.isNotEmpty,
                ),
              if (note != null && note.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.sm + 3,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Commentaire',
                        style: AppTypography.body.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                      Text(note, style: AppTypography.body),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
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
        SkeletonBox(width: 160, height: 16),
        SizedBox(height: AppSpacing.sm),
        SkeletonBox(width: 220, height: 32),
        SizedBox(height: AppSpacing.lg),
        SkeletonBox(height: 200),
      ],
    );
  }
}
