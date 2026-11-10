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

/// Ligne d'un mouvement d'espèces : sens, motif, heure, commentaire et
/// montant signé. Un mouvement refusé par le serveur est grisé et marqué
/// « Refusé par le serveur » : il n'entre pas dans le solde.
class CashMovementTile extends StatelessWidget {
  /// Crée la ligne du [movement].
  const CashMovementTile({required this.movement, super.key});

  /// Mouvement affiché.
  final CashMovement movement;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final semantic = Theme.of(context).extension<AppSemanticColors>()!;
    final isIn = movement.type == CashMovementType.cashIn;
    final isRejected = movement.syncStatus == CashSyncStatus.rejected;
    final color = isRejected
        ? cs.onSurfaceVariant
        : isIn
        ? semantic.success
        : cs.error;
    final muted = AppTypography.bodySmall.copyWith(color: cs.onSurfaceVariant);
    final reason = cashMovementReasonLabel(movement.reason);
    final note = movement.note;
    final details = [
      DateFormat('d MMM à HH:mm', 'fr_FR').format(movement.createdAt.toLocal()),
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
        constraints: const BoxConstraints(minHeight: AppSpacing.buttonHeight),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Row(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  child: Icon(
                    isIn ? Icons.south_west : Icons.north_east,
                    size: 20,
                    color: color,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$typeLabel · $reason',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.titleMedium,
                    ),
                    Text(details, style: muted),
                    if (isRejected)
                      Text(
                        rejectionCode == null
                            ? 'Refusé par le serveur'
                            : 'Refusé par le serveur · '
                                  '${cashRegisterMessage(rejectionCode)}',
                        style: AppTypography.bodySmall.copyWith(
                          color: cs.error,
                        ),
                      )
                    else if (movement.syncStatus == CashSyncStatus.pending)
                      Text('En attente de synchro', style: muted),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isIn ? '+ ' : '− ',
                    style: AppTypography.bodyLarge.copyWith(color: color),
                  ),
                  AmountDisplay(amount: movement.amount, color: color),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
