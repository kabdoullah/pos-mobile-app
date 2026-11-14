import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/index.dart';

/// État de la caisse à la clôture : écart (compté moins théorique) nul,
/// positif ou négatif.
enum DiscrepancyKind {
  /// Écart nul.
  balanced,

  /// Plus d'espèces que prévu.
  surplus,

  /// Moins d'espèces que prévu.
  deficit;

  /// État correspondant à l'écart [discrepancy].
  static DiscrepancyKind of(Decimal discrepancy) => discrepancy == Decimal.zero
      ? balanced
      : discrepancy > Decimal.zero
      ? surplus
      : deficit;
}

/// Libellé français de l'écart : « Caisse équilibrée », « Excédent de X » ou
/// « Déficit de X » (X en valeur absolue, en FCFA).
String discrepancyLabel(Decimal discrepancy) =>
    switch (DiscrepancyKind.of(discrepancy)) {
      DiscrepancyKind.balanced => 'Caisse équilibrée',
      DiscrepancyKind.surplus => 'Excédent de ${formatFcfa(discrepancy)}',
      DiscrepancyKind.deficit => 'Déficit de ${formatFcfa(discrepancy.abs())}',
    };

/// Montant signé de l'écart : « + 300 FCFA », « − 1 175 FCFA » ou « 0 FCFA ».
String signedDiscrepancy(Decimal discrepancy) =>
    switch (DiscrepancyKind.of(discrepancy)) {
      DiscrepancyKind.balanced => formatFcfa(Decimal.zero),
      DiscrepancyKind.surplus => '+ ${formatFcfa(discrepancy)}',
      DiscrepancyKind.deficit => '− ${formatFcfa(discrepancy.abs())}',
    };

/// Libellé de la ligne d'écart d'un récapitulatif : « Écart · déficit »,
/// « Écart · excédent » ou « Écart ».
String discrepancyRowLabel(Decimal discrepancy) =>
    switch (DiscrepancyKind.of(discrepancy)) {
      DiscrepancyKind.balanced => 'Écart',
      DiscrepancyKind.surplus => 'Écart · excédent',
      DiscrepancyKind.deficit => 'Écart · déficit',
    };

/// Tonalité de l'écart : succès si équilibrée, alerte pour un excédent,
/// erreur pour un déficit.
StatusTone discrepancyTone(Decimal discrepancy) =>
    switch (DiscrepancyKind.of(discrepancy)) {
      DiscrepancyKind.balanced => StatusTone.success,
      DiscrepancyKind.surplus => StatusTone.warning,
      DiscrepancyKind.deficit => StatusTone.error,
    };

/// État de la caisse (point + mot, v2) : équilibrée, excédent ou déficit.
class DiscrepancyBadge extends StatelessWidget {
  /// Crée l'indicateur pour l'écart [discrepancy].
  const DiscrepancyBadge({required this.discrepancy, super.key});

  /// Écart : montant compté moins solde théorique.
  final Decimal discrepancy;

  @override
  Widget build(BuildContext context) {
    final label = discrepancyLabel(discrepancy);
    return Semantics(
      container: true,
      label: label,
      excludeSemantics: true,
      child: StatusIndicator(
        label: label,
        tone: discrepancyTone(discrepancy),
        emphasized: true,
      ),
    );
  }
}
