import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';

/// Indicateur de progression du PIN à 4 points.
///
/// Chaque point se remplit (couleur principale) au fil de la saisie des
/// chiffres. Le nombre de chiffres saisis est annoncé aux lecteurs d'écran.
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
    return Semantics(
      label:
          '$filledCount chiffre${filledCount > 1 ? 's' : ''} saisi'
          '${filledCount > 1 ? 's' : ''} sur $length',
      excludeSemantics: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(length, (i) {
          final filled = i < filledCount;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm + 2),
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
      ),
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
///
/// Les chiffres du clavier physique (tablette, émulateur) sont aussi acceptés.
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

  /// Indique si les touches sont actives (désactivées pendant la vérification
  /// et le blocage). Le pavé reste affiché pour éviter un saut de mise en page.
  final bool enabled;

  static const List<List<String?>> _layout = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
    [null, '0', 'backspace'],
  ];

  KeyEventResult _onKeyEvent(FocusNode _, KeyEvent event) {
    if (!enabled || event is! KeyDownEvent) return KeyEventResult.ignored;
    if (event.logicalKey == LogicalKeyboardKey.backspace) {
      onBackspace();
      return KeyEventResult.handled;
    }
    final char = event.character;
    if (char != null && RegExp(r'^[0-9]$').hasMatch(char)) {
      onDigit(char);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      onKeyEvent: _onKeyEvent,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 150),
        opacity: enabled ? 1 : 0.4,
        child: Column(
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
        ),
      ),
    );
  }

  Widget _buildKey(BuildContext context, String? key) {
    if (key == null) return const SizedBox.shrink();

    final cs = Theme.of(context).colorScheme;

    if (key == 'backspace') {
      return _NumpadKey(
        semanticLabel: 'Effacer',
        onTap: enabled ? onBackspace : null,
        child: Icon(Icons.backspace_outlined, color: cs.onSurface, size: 22),
      );
    }

    return _NumpadKey(
      semanticLabel: key,
      onTap: enabled ? () => onDigit(key) : null,
      child: Text(
        key,
        style: AppTypography.titleLarge.copyWith(color: cs.onSurface),
      ),
    );
  }
}

class _NumpadKey extends StatelessWidget {
  const _NumpadKey({
    required this.child,
    required this.semanticLabel,
    this.onTap,
  });

  final Widget child;
  final String semanticLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final onTap = this.onTap;
    return Semantics(
      button: true,
      enabled: onTap != null,
      label: semanticLabel,
      excludeSemantics: true,
      child: Material(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          onTap: onTap == null
              ? null
              : () {
                  unawaited(HapticFeedback.selectionClick());
                  onTap();
                },
          child: SizedBox(height: 64, child: Center(child: child)),
        ),
      ),
    );
  }
}

/// Ligne de message sous les points du PIN (erreur, tentatives restantes,
/// blocage). Hauteur réservée pour éviter un saut de mise en page ; annoncée
/// par les lecteurs d'écran.
class PinMessage extends StatelessWidget {
  /// Crée une ligne de message.
  const PinMessage({this.title, this.detail, this.isError = true, super.key});

  /// Titre en gras (« PIN incorrect »), ou null.
  final String? title;

  /// Détail (« Il vous reste 3 tentatives. »), ou null.
  final String? detail;

  /// Couleur d'erreur (sinon couleur neutre).
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final color = isError ? cs.error : cs.onSurfaceVariant;
    final title = this.title;
    final detail = this.detail;
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 48),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: title == null && detail == null
            ? const SizedBox(key: ValueKey('empty'))
            : Semantics(
                key: ValueKey('$title|$detail'),
                liveRegion: true,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (title != null)
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: AppTypography.labelMedium.copyWith(color: color),
                      ),
                    if (detail != null)
                      Text(
                        detail,
                        textAlign: TextAlign.center,
                        style: AppTypography.bodySmall.copyWith(color: color),
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}
