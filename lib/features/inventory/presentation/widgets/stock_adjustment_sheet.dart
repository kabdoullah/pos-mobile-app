import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/network/error_mapper.dart';
import '../../../../core/utils/whole_number_input.dart';
import '../../../../core/widgets/index.dart';
import '../providers/inventory_providers.dart';

/// Ouvre la feuille d'ajustement de stock d'un produit.
Future<void> showStockAdjustmentSheet(BuildContext context, String productId) {
  return showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => StockAdjustmentSheet(productId: productId),
  );
}

/// Feuille d'ajustement de stock manuel (réception, casse, correction
/// d'inventaire) : sens, quantité au stepper, stock obtenu en direct, motif.
/// Le bouton dit ce qu'il fait (« Ajouter 10 au stock »).
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

  /// Quantité maximale saisissable (6 chiffres).
  static const _maxQuantity = 999999;

  final _quantityController = TextEditingController(text: '1');
  final _noteController = TextEditingController();
  bool _isEntry = true;
  String? _reason;
  String? _quantityError;
  bool _isLoading = false;

  @override
  void dispose() {
    _quantityController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  int? get _quantity => parseWholeQuantity(_quantityController.text.trim());

  void _step(int delta) {
    final next = ((_quantity ?? 0) + delta).clamp(1, _maxQuantity);
    _quantityController.text = '$next';
    setState(() => _quantityError = null);
  }

  /// Motif envoyé : le motif choisi, puis la précision éventuelle.
  String? get _note {
    final parts = [
      ?_reason,
      if (_noteController.text.trim().isNotEmpty) _noteController.text.trim(),
    ];
    return parts.isEmpty ? null : parts.join(' · ');
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
      await ref
          .read(stockAdjustmentProvider.notifier)
          .submit(
            productId: widget.productId,
            quantityDelta: _isEntry ? quantity : -quantity,
            note: _note,
          );
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Stock ajusté')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorToFrench(e))));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final product = ref.watch(stockProductProvider(widget.productId)).value;
    final current = product?.currentStock;
    final quantity = _quantity;
    final valid = quantity != null && quantity > 0;
    final result = current == null || !valid
        ? null
        : current + (_isEntry ? quantity : -quantity);
    final submitLabel = !valid
        ? (_isEntry ? 'Ajouter au stock' : 'Retirer du stock')
        : _isEntry
        ? 'Ajouter $quantity au stock'
        : 'Retirer $quantity du stock';

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXl),
        ),
      ),
      child: SafeArea(
        top: false,
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
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: AppSpacing.sm,
                  children: [
                    const Text(
                      'Ajuster le stock',
                      style: AppTypography.appBarTitle,
                    ),
                    if (product != null)
                      Text(
                        product.name,
                        style: AppTypography.bodyMedium.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                SegmentedButton<bool>(
                  showSelectedIcon: false,
                  segments: const [
                    ButtonSegment(
                      value: true,
                      label: Text('Entrée'),
                      icon: Icon(Icons.add_circle_outline),
                    ),
                    ButtonSegment(
                      value: false,
                      label: Text('Sortie'),
                      icon: Icon(Icons.remove_circle_outline),
                    ),
                  ],
                  selected: {_isEntry},
                  onSelectionChanged: (selection) => setState(() {
                    _isEntry = selection.single;
                    _reason = null;
                  }),
                ),
                const SizedBox(height: AppSpacing.md),
                const Text('Quantité', style: AppTypography.labelLarge),
                const SizedBox(height: AppSpacing.sm),
                _BigStepper(
                  controller: _quantityController,
                  hasError: _quantityError != null,
                  onChanged: () => setState(() => _quantityError = null),
                  onDecrease: (quantity ?? 0) > 1 ? () => _step(-1) : null,
                  onIncrease: () => _step(1),
                ),
                if (_quantityError != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    _quantityError!,
                    style: AppTypography.errorText.copyWith(color: cs.error),
                  ),
                ],
                if (current != null && result != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  _ResultBox(current: current, result: result),
                ],
                const SizedBox(height: AppSpacing.md),
                const Text('Motif', style: AppTypography.labelLarge),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    for (final reason
                        in _isEntry ? _entryReasons : _exitReasons)
                      ChoiceChip(
                        label: Text(reason),
                        selected: _reason == reason,
                        onSelected: (selected) =>
                            setState(() => _reason = selected ? reason : null),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: 'Préciser (facultatif)',
                  controller: _noteController,
                  maxLines: 2,
                ),
                const SizedBox(height: AppSpacing.md),
                PrimaryButton(
                  label: submitLabel,
                  onPressed: _isLoading ? null : _submit,
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Stepper pleine largeur : − / quantité modifiable au clavier / +.
class _BigStepper extends StatelessWidget {
  const _BigStepper({
    required this.controller,
    required this.hasError,
    required this.onChanged,
    required this.onDecrease,
    required this.onIncrease,
  });

  final TextEditingController controller;
  final bool hasError;
  final VoidCallback onChanged;
  final VoidCallback? onDecrease;
  final VoidCallback onIncrease;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: hasError ? cs.error : cs.primary, width: 2),
      ),
      child: Row(
        children: [
          _StepButton(
            icon: Icons.remove,
            tooltip: 'Moins',
            onPressed: onDecrease,
          ),
          Expanded(
            child: TextField(
              controller: controller,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              // Virgule gardée visible pour être refusée, jamais recollée aux
              // chiffres (« 2,5 » ≠ 25).
              inputFormatters: wholeNumberInputFormatters(maxLength: 6),
              onChanged: (_) => onChanged(),
              style: AppTypography.amountDisplay.copyWith(
                color: cs.onSurface,
                fontFeatures: AppTypography.tabularFigures,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                filled: false,
                isCollapsed: true,
              ),
            ),
          ),
          _StepButton(icon: Icons.add, tooltip: 'Plus', onPressed: onIncrease),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      icon: Icon(icon),
      style: IconButton.styleFrom(
        fixedSize: const Size.square(56),
        backgroundColor: cs.primaryContainer,
        foregroundColor: cs.onPrimaryContainer,
        disabledBackgroundColor: cs.surfaceContainerHigh,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

/// « Nouveau stock 60 → 70 » : le résultat se lit avant de valider. Un stock
/// qui deviendrait négatif est signalé en couleur d'erreur.
class _ResultBox extends StatelessWidget {
  const _ResultBox({required this.current, required this.result});

  final int current;
  final int result;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final semantic = Theme.of(context).extension<AppSemanticColors>()!;
    final negative = result < 0;
    final (background, foreground) = negative
        ? (cs.errorContainer, cs.onErrorContainer)
        : (semantic.successContainer, semantic.onSuccessContainer);
    return Semantics(
      liveRegion: true,
      label: 'Nouveau stock : $result',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm + 6,
          vertical: AppSpacing.sm + 4,
        ),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                negative ? 'Stock négatif' : 'Nouveau stock',
                style: AppTypography.labelLarge.copyWith(color: foreground),
              ),
            ),
            Text(
              '$current → $result',
              style: AppTypography.titleMedium.copyWith(
                color: foreground,
                fontWeight: FontWeight.w700,
                fontFeatures: AppTypography.tabularFigures,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
