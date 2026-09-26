import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  @override
  State<AmountInput> createState() => _AmountInputState();
}

class _AmountInputState extends State<AmountInput> {
  late final _controller = TextEditingController(text: _textOf(widget.value));

  static String _textOf(Decimal? value) => value?.toString() ?? '';

  @override
  void didUpdateWidget(AmountInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (Decimal.tryParse(_controller.text) != widget.value) {
      _controller.text = _textOf(widget.value);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        errorText: widget.errorText,
        suffixText: 'FCFA',
        isDense: true,
      ),
      onChanged: (text) => widget.onChanged(Decimal.tryParse(text)),
    );
  }
}
