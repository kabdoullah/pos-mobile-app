import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/fcfa_amount_input.dart';
import '../../../../core/widgets/index.dart';

/// Champ de saisie d'un montant FCFA (entier, clavier numérique).
///
/// La valeur fait foi côté appelant ([value]) : un raccourci qui la modifie
/// met le texte à jour.
class AmountInput extends StatefulWidget {
  /// Crée un champ de montant.
  const AmountInput({
    required this.label,
    required this.value,
    required this.onChanged,
    this.hint,
    this.errorText,
    this.large = false,
    super.key,
  });

  /// Libellé du champ.
  final String label;

  /// Montant courant (`null` = champ vide).
  final Decimal? value;

  /// Nouveau montant saisi (`null` si le champ est vidé).
  final ValueChanged<Decimal?> onChanged;

  /// Texte indicatif affiché quand le champ est vide.
  final String? hint;

  /// Erreur affichée sous le champ.
  final String? errorText;

  /// Montant mis en avant (34 sp).
  final bool large;

  @override
  State<AmountInput> createState() => _AmountInputState();
}

class _AmountInputState extends State<AmountInput> {
  late final _controller = TextEditingController(text: _textOf(widget.value));

  /// Vrai si la saisie contient une virgule ou un point (montant refusé).
  bool _hasSeparator = false;

  static String _textOf(Decimal? value) => value?.toString() ?? '';

  @override
  void didUpdateWidget(AmountInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Une saisie refusée (virgule) vaut `null` chez l'appelant : ne pas
    // l'effacer, sinon le commerçant ne voit plus ce qu'il a tapé.
    final keepRefused = _hasSeparator && widget.value == null;
    if (!keepRefused && parseFcfaAmount(_controller.text) != widget.value) {
      _controller.text = _textOf(widget.value);
      _hasSeparator = false;
    }
  }

  void _onTextChanged(String text) {
    final hasSeparator = hasDecimalSeparator(text);
    if (hasSeparator != _hasSeparator) {
      setState(() => _hasSeparator = hasSeparator);
    }
    widget.onChanged(parseFcfaAmount(text));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: widget.label,
      hint: widget.hint,
      // Le refus de la virgule prime : c'est la cause de la saisie invalide.
      errorText: _hasSeparator ? fcfaWholeAmountError : widget.errorText,
      suffixText: 'FCFA',
      large: widget.large,
      controller: _controller,
      keyboardType: TextInputType.number,
      inputFormatters: fcfaAmountInputFormatters,
      textInputAction: TextInputAction.done,
      onChanged: _onTextChanged,
    );
  }
}
