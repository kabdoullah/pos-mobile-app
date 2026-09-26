import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';

/// Indicateur de progression du PIN à 4 points.
///
/// Chaque point se remplit (couleur principale) au fil de la saisie des
/// chiffres.
class PinDots extends StatelessWidget {
  /// Crée un indicateur de points du PIN.
  const PinDots({super.key, required this.filledCount, this.length = 4});

  /// Nombre de points remplis (chiffres saisis).
  final int filledCount;

  /// Nombre total de points (longueur du PIN).
  final int length;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(length, (i) {
        final filled = i < filledCount;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: filled ? cs.primary : Colors.transparent,
              border: Border.all(
                color: filled ? cs.primary : cs.outline,
                width: 2,
              ),
            ),
          ),
        );
      }),
    );
  }
}

/// Pavé numérique PIN personnalisé — grille 3×4, pas de clavier système.
///
/// Disposition :
/// ```
/// 1  2  3
/// 4  5  6
/// 7  8  9
/// _  0  ⌫
/// ```
class PinNumpad extends StatelessWidget {
  /// Crée un pavé numérique PIN.
  const PinNumpad({
    super.key,
    required this.onDigit,
    required this.onBackspace,
    this.enabled = true,
  });

  /// Appelé avec le chiffre (en chaîne) quand une touche numérique est tapée.
  final void Function(String digit) onDigit;

  /// Appelé quand la touche retour arrière est tapée.
  final VoidCallback onBackspace;

  /// Indique si les touches sont actives (désactivées pendant les opérations
  /// asynchrones).
  final bool enabled;

  static const List<List<String?>> _layout = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
    [null, '0', 'backspace'],
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: _layout.map((row) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: Row(
            children: row.map((key) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xs,
                  ),
                  child: _buildKey(context, key),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildKey(BuildContext context, String? key) {
    if (key == null) return const SizedBox.shrink();

    final cs = Theme.of(context).colorScheme;

    if (key == 'backspace') {
      return _NumpadKey(
        onTap: enabled ? onBackspace : null,
        child: Icon(Icons.backspace_outlined, color: cs.onSurface, size: 22),
      );
    }

    return _NumpadKey(
      onTap: enabled ? () => onDigit(key) : null,
      child: Text(
        key,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: cs.onSurface,
        ),
      ),
    );
  }
}

class _NumpadKey extends StatelessWidget {
  const _NumpadKey({required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: cs.surface,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      elevation: 1.5,
      shadowColor: cs.shadow,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        onTap: onTap,
        child: SizedBox(height: 64, child: Center(child: child)),
      ),
    );
  }
}
