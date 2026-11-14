import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../../domain/entities/cash_labels.dart';
import '../../domain/entities/cash_movement.dart';
import '../../domain/entities/cash_session.dart';
import '../cash_register_messages.dart';

/// Ligne d'un mouvement d'espèces (liste à plat) : sens · motif, heure et
/// commentaire, montant signé. Un mouvement refusé par le serveur est barré
/// et marqué « Refusé » : il n'entre pas dans le solde.
class CashMovementTile extends StatelessWidget {
  /// Crée la ligne du [movement].
  const CashMovementTile({required this.movement, super.key});

  /// Mouvement affiché.
  final CashMovement movement;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final isIn = movement.type == CashMovementType.cashIn;
    final isRejected = movement.syncStatus == CashSyncStatus.rejected;
    final meta = AppTypography.bodySmall.copyWith(color: colors.textSecondary);
    final reason = cashMovementReasonLabel(movement.reason);
    final note = movement.note;
    final details = [
      DateFormat('HH:mm', 'fr_FR').format(movement.createdAt.toLocal()),
      if (note != null && note.isNotEmpty) note,
    ].join(' · ');
    final rejectionCode = movement.rejectionCode;
    final typeLabel = isIn ? 'Entrée' : 'Sortie';
    final semanticsLabel = [
      typeLabel,
      reason,
      formatFcfa(movement.amount),
      if (isRejected) 'refusé par le serveur, non compté',
      if (movement.syncStatus == CashSyncStatus.pending)
        'en attente de synchro',
    ].join(', ');

    return Semantics(
      container: true,
      label: semanticsLabel,
      excludeSemantics: true,
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
                    Text(
                      '$typeLabel · $reason',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodyStrong.copyWith(
                        color: isRejected ? colors.textSecondary : null,
                      ),
                    ),
                    Text(details, style: meta),
                    if (isRejected)
                      StatusIndicator(
                        label: rejectionCode == null
                            ? 'Refusé par le serveur'
                            : 'Refusé par le serveur · '
                                  '${cashRegisterMessage(rejectionCode)}',
                        tone: StatusTone.error,
                      )
                    else if (movement.syncStatus == CashSyncStatus.pending)
                      const StatusIndicator(
                        label: 'En attente de synchro',
                        tone: StatusTone.warning,
                      ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                '${isIn ? '+' : '−'} ${formatFcfa(movement.amount)}',
                style: AppTypography.bodyStrong.copyWith(
                  color: isRejected ? colors.textSecondary : null,
                  decoration: isRejected ? TextDecoration.lineThrough : null,
                  fontFeatures: AppTypography.tabularFigures,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
