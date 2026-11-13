import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';

/// Un segment de [SegmentedControl].
typedef Segment<T> = ({T value, String label});

/// Contrôle segmenté v2 (remplace `SegmentedButton`) : piste en creux r8,
/// segment actif en surface avec un filet. Ni coche ni contour Material.
class SegmentedControl<T> extends StatelessWidget {
  /// Crée un contrôle segmenté.
  const SegmentedControl({
    required this.segments,
    required this.selected,
    required this.onChanged,
    super.key,
  });

  /// Segments, de gauche à droite (largeurs égales).
  final List<Segment<T>> segments;

  /// Valeur sélectionnée ; `null` = aucun segment actif.
  final T? selected;

  /// Appelé au choix d'un segment.
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceSunken,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Row(
          children: [
            for (final (i, segment) in segments.indexed) ...[
              if (i > 0) const SizedBox(width: 3),
              Expanded(
                child: _SegmentButton(
                  label: segment.label,
                  isSelected: segment.value == selected,
                  onTap: () => onChanged(segment.value),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  const _SegmentButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final radius = BorderRadius.circular(6);
    return Semantics(
      button: true,
      selected: isSelected,
      child: Material(
        color: isSelected ? colors.surface : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: isSelected ? BorderSide(color: colors.border) : BorderSide.none,
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 42),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyStrong.copyWith(
                    fontSize: 15,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? colors.textPrimary
                        : colors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
