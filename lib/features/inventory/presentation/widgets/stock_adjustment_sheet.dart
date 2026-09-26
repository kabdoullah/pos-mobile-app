import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/error_mapper.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../providers/inventory_providers.dart';

/// Bottom sheet pour enregistrer un ajustement de stock manuel (réception,
/// casse, correction d'inventaire) sur un produit donné.
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
    final quantity = int.tryParse(_quantityController.text.trim());
    if (quantity == null || quantity <= 0) {
      setState(() => _quantityError = 'Entrez une quantité valide');
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

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final semantic = Theme.of(context).extension<AppSemanticColors>()!;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            top: AppSpacing.lg,
            bottom: AppSpacing.lg + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: AppSpacing.md),
                    decoration: BoxDecoration(
                      color: cs.outlineVariant,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const Text(
                  'Ajuster le stock',
                  style: AppTypography.titleMedium,
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: _DirectionOption(
                        label: 'Entrée',
                        icon: Icons.add_circle_outline,
                        color: semantic.success,
                        selected: _isEntry,
                        onTap: () => setState(() => _isEntry = true),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _DirectionOption(
                        label: 'Sortie',
                        icon: Icons.remove_circle_outline,
                        color: cs.error,
                        selected: !_isEntry,
                        onTap: () => setState(() => _isEntry = false),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  label: 'Quantité',
                  hint: 'ex: 10',
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  errorText: _quantityError,
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Motif rapide',
                  style: AppTypography.labelMedium.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    for (final reason
                        in _isEntry ? _entryReasons : _exitReasons)
                      ChoiceChip(
                        label: Text(reason),
                        selected: _noteController.text == reason,
                        onSelected: (selected) => setState(() {
                          _noteController.text = selected ? reason : '';
                        }),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: 'Motif (optionnel)',
                  hint: 'Ou précisez...',
                  controller: _noteController,
                  maxLines: 2,
                ),
                const SizedBox(height: AppSpacing.xl),
                PrimaryButton(
                  label: 'Valider l\'ajustement',
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

class _DirectionOption extends StatelessWidget {
  const _DirectionOption({
    required this.label,
    required this.icon,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.12) : null,
          border: Border.all(
            color: selected
                ? color
                : Theme.of(context).colorScheme.outlineVariant,
          ),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: selected
                  ? color
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              label,
              style: AppTypography.labelMedium.copyWith(
                color: selected
                    ? color
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
