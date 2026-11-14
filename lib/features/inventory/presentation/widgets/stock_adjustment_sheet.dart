import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/error_mapper.dart';
import '../../../../core/utils/whole_number_input.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../providers/inventory_providers.dart';

/// Ouvre la feuille d'ajustement de stock d'un produit.
Future<void> showStockAdjustmentSheet(BuildContext context, String productId) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => StockAdjustmentSheet(productId: productId),
  );
}

/// Feuille « Ajuster le stock » : sens (Entrée / Sortie), quantité, nouveau
/// stock visible avant de valider, motif (réception, casse, correction…).
class StockAdjustmentSheet extends ConsumerStatefulWidget {
  /// Crée une [StockAdjustmentSheet].
  const StockAdjustmentSheet({required this.productId, super.key});

  /// Produit concerné par cet ajustement.
  final String productId;

  @override
  ConsumerState<StockAdjustmentSheet> createState() =>
      _StockAdjustmentSheetState();
}

class _StockAdjustmentSheetState extends ConsumerState<StockAdjustmentSheet> {
  /// Motifs courants pour une entrée de stock.
  static const List<String> _entryReasons = [
    'Réception fournisseur',
    'Retour client',
    'Correction inventaire',
  ];

  /// Motifs courants pour une sortie de stock.
  static const List<String> _exitReasons = [
    'Casse',
    'Périmé',
    'Vol',
    'Correction inventaire',
  ];

  late TextEditingController _quantityController;
  late TextEditingController _noteController;
  bool _isEntry = true;
  String? _quantityError;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController();
    _noteController = TextEditingController();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final text = _quantityController.text.trim();
    final quantity = parseWholeQuantity(text);
    if (quantity == null || quantity <= 0) {
      setState(
        () => _quantityError = hasDecimalSeparator(text)
            ? wholeQuantityError
            : 'Entrez une quantité valide',
      );
      return;
    }
    setState(() {
      _quantityError = null;
      _isLoading = true;
    });

    try {
      final note = _noteController.text.trim();
      await ref
          .read(stockAdjustmentProvider.notifier)
          .submit(
            productId: widget.productId,
            quantityDelta: _isEntry ? quantity : -quantity,
            note: note.isEmpty ? null : note,
          );
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Stock ajusté avec succès')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorToFrench(e))));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Quantité saisie, `null` si vide ou invalide.
  int? get _quantity {
    final value = parseWholeQuantity(_quantityController.text.trim());
    return value == null || value <= 0 ? null : value;
  }

  void _setQuantity(int quantity) {
    final text = '$quantity';
    _quantityController.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
    setState(() => _quantityError = null);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final product = ref.watch(stockProductProvider(widget.productId)).value;
    final stock = product?.currentStock;
    final quantity = _quantity;
    final newStock = stock == null || quantity == null
        ? null
        : stock + (_isEntry ? quantity : -quantity);
    final reasons = _isEntry ? _entryReasons : _exitReasons;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.md,
          right: AppSpacing.md,
          top: AppSpacing.lg,
          bottom: AppSpacing.md + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Ajuster le stock', style: AppTypography.sectionTitle),
              if (product != null)
                Text(
                  stock == null
                      ? product.name
                      : '${product.name} · $stock en stock',
                  style: AppTypography.bodySmall.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              const SizedBox(height: AppSpacing.md),
              SegmentedControl<bool>(
                segments: const [
                  (value: true, label: 'Entrée'),
                  (value: false, label: 'Sortie'),
                ],
                selected: _isEntry,
                onChanged: (isEntry) => setState(() {
                  if (isEntry == _isEntry) return;
                  _isEntry = isEntry;
                  // Les motifs dépendent du sens.
                  if (!reasonsFor(isEntry).contains(_noteController.text)) {
                    _noteController.clear();
                  }
                }),
              ),
              const SizedBox(height: AppSpacing.md),
              const Text('Quantité', style: AppTypography.bodyStrong),
              const SizedBox(height: AppSpacing.xs + 2),
              Align(
                alignment: Alignment.centerLeft,
                child: QuantityStepper(
                  quantity: quantity ?? 0,
                  large: true,
                  onDecrease: quantity != null && quantity > 1
                      ? () => _setQuantity(quantity - 1)
                      : null,
                  onIncrease: () => _setQuantity((quantity ?? 0) + 1),
                  field: Semantics(
                    label: 'Quantité',
                    child: TextField(
                      onTapOutside: (_) =>
                          FocusManager.instance.primaryFocus?.unfocus(),
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: AppTypography.figureLarge,
                      // Virgule gardée visible pour être refusée, jamais
                      // recollée aux chiffres (« 2,5 » ≠ 25).
                      inputFormatters: wholeNumberInputFormatters(maxLength: 6),
                      onChanged: (_) => setState(() => _quantityError = null),
                      // Le cadre du stepper suffit : ni fond ni contour.
                      decoration: const InputDecoration(
                        isDense: true,
                        hintText: '0',
                        filled: false,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: AppSpacing.sm,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (_quantityError != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  _quantityError!,
                  style: AppTypography.errorText.copyWith(color: colors.error),
                ),
              ],
              if (stock != null)
                DefinitionRow(
                  label: 'Nouveau stock',
                  value: newStock == null ? '$stock' : '$stock → $newStock',
                  color: newStock != null && newStock < 0 ? colors.error : null,
                ),
              const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
              const Text('Motif', style: AppTypography.bodyStrong),
              const SizedBox(height: AppSpacing.xs + 2),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  for (final reason in reasons)
                    QuickChoiceButton(
                      label: reason,
                      isSelected: _noteController.text == reason,
                      onTap: () => setState(() {
                        _noteController.text = _noteController.text == reason
                            ? ''
                            : reason;
                      }),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
              AppTextField(
                label: 'Préciser (facultatif)',
                controller: _noteController,
                maxLines: 2,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: AppSpacing.md),
              PrimaryButton(
                label: quantity == null
                    ? "Valider l'ajustement"
                    : _isEntry
                    ? 'Ajouter $quantity au stock'
                    : 'Retirer $quantity du stock',
                onPressed: _isLoading ? null : _submit,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Motifs proposés pour une entrée ([isEntry]) ou une sortie.
  static List<String> reasonsFor(bool isEntry) =>
      isEntry ? _entryReasons : _exitReasons;
}
