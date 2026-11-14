import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';

/// Indicateur de progression du PIN à 4 points.
///
/// Chaque point se remplit (couleur principale) au fil de la saisie des
/// chiffres. Le nombre de chiffres saisis est annoncé aux lecteurs d'écran.
class PinDots extends StatelessWidget {
  /// Crée un indicateur de points du PIN.
  const PinDots({
    super.key,
    required this.filledCount,
    this.length = 4,
    this.isError = false,
  });

  /// Nombre de points remplis (chiffres saisis).
  final int filledCount;

  /// Nombre total de points (longueur du PIN).
  final int length;

  /// Saisie refusée : contours en couleur d'erreur.
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
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
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: filled ? colors.textPrimary : Colors.transparent,
                border: Border.all(
                  color: isError
                      ? colors.error
                      : filled
                      ? colors.textPrimary
                      : colors.borderStrong,
                  width: 1.5,
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
    final colors = AppColors.of(context);

    if (key == 'backspace') {
      return _NumpadKey(
        semanticLabel: 'Effacer',
        plain: true,
        onTap: enabled ? onBackspace : null,
        // Grande police : l'icône et le libellé se réduisent au lieu de
        // déborder de la touche.
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.backspace_outlined,
                color: colors.textSecondary,
                size: 22,
              ),
              Text(
                'Effacer',
                style: AppTypography.bodySmall.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return _NumpadKey(
      semanticLabel: key,
      onTap: enabled ? () => onDigit(key) : null,
      child: Text(
        key,
        style: AppTypography.figureLarge.copyWith(
          fontWeight: FontWeight.w500,
          color: colors.textPrimary,
        ),
      ),
    );
  }
}

class _NumpadKey extends StatelessWidget {
  const _NumpadKey({
    required this.child,
    required this.semanticLabel,
    this.onTap,
    this.plain = false,
  });

  final Widget child;
  final String semanticLabel;
  final VoidCallback? onTap;

  /// Touche de fonction : sans fond ni filet.
  final bool plain;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final onTap = this.onTap;
    final radius = BorderRadius.circular(AppSpacing.radiusSm);
    final handleTap = onTap == null
        ? null
        : () {
            unawaited(HapticFeedback.selectionClick());
            onTap();
          };
    return Semantics(
      button: true,
      enabled: onTap != null,
      label: semanticLabel,
      // L'action vit sur ce nœud : `excludeSemantics` masque celle de
      // l'InkWell, et TalkBack ne pourrait sinon pas activer la touche.
      onTap: handleTap,
      excludeSemantics: true,
      child: Material(
        color: plain ? Colors.transparent : colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: plain ? BorderSide.none : BorderSide(color: colors.border),
        ),
        child: InkWell(
          borderRadius: radius,
          onTap: handleTap,
          child: SizedBox(height: 56, child: Center(child: child)),
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
