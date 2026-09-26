import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../app/theme/app_typography.dart';

/// Variantes de taille de l'affichage de montant.
enum AmountSize {
  /// Petit texte (14 sp), pour les lignes d'articles.
  small,

  /// Texte moyen (18 sp), pour les sous-totaux.
  medium,

  /// Grand texte (28 sp), pour les montants totaux.
  large,

  /// Texte héro (32 sp et plus), pour les totaux mis en avant (panier, reçu).
  hero,
}

/// Affichage formaté d'un montant en FCFA.
///
/// Affiche les montants avec séparateurs de milliers (ex. « 12 500 FCFA »). «
/// FCFA » est affiché plus petit que le nombre pour la hiérarchie visuelle.
class AmountDisplay extends StatelessWidget {
  /// Crée un affichage de montant.
  const AmountDisplay({
    required this.amount,
    this.size = AmountSize.medium,
    this.color,
    super.key,
  });

  /// Montant à afficher (en FCFA).
  final Decimal amount;

  /// Variante de taille de l'affichage.
  final AmountSize size;

  /// Couleur de texte optionnelle (remplace celle par défaut).
  final Color? color;

  TextStyle _getTextStyle() {
    return switch (size) {
      AmountSize.small => AppTypography.bodySmall,
      AmountSize.medium => AppTypography.bodyLarge,
      AmountSize.large => AppTypography.amountLarge,
      AmountSize.hero => AppTypography.amountDisplay,
    };
  }

  String _formatAmount() {
    final formatter = NumberFormat('#,##0', 'fr_FR');
    return formatter.format(amount.toDouble());
  }

  @override
  Widget build(BuildContext context) {
    // RichText ne propage pas DefaultTextStyle — couleur explicite obligatoire.
    final defaultColor = color ?? Theme.of(context).colorScheme.onSurface;
    final textStyle = _getTextStyle().copyWith(color: defaultColor);
    final formattedAmount = _formatAmount();

    return RichText(
      // ✨ centre les lignes entre elles quand le montant passe à la ligne
      // (ex: carte résumé 3 colonnes) — RichText aligne à gauche par défaut
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(text: formattedAmount, style: textStyle),
          TextSpan(
            text: ' FCFA',
            style: textStyle.copyWith(
              fontSize: (textStyle.fontSize ?? 16) * 0.75,
            ),
          ),
        ],
      ),
    );
  }
}
