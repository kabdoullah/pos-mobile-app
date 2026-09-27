import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/network/error_mapper.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../core/router/app_router.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/index.dart';
import '../providers/catalog_providers.dart';
import '../providers/category_providers.dart';
import '../widgets/category_picker.dart';

/// Page de création ou de modification d'un produit.
class ProductFormPage extends ConsumerStatefulWidget {
  /// Crée une [ProductFormPage].
  const ProductFormPage({super.key, this.productId, this.initialBarcode});

  /// ID du produit en mode édition, null en mode création.
  final String? productId;

  /// Code-barres pré-rempli quand on arrive d'une recherche par scan
  /// infructueuse.
  final String? initialBarcode;

  @override
  ConsumerState<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends ConsumerState<ProductFormPage>
    with TickerProviderStateMixin {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _purchasePriceController;
  late TextEditingController _barcodeController;
  late TextEditingController _stockController;
  late TextEditingController _minStockController;
  late AnimationController _formAnimationController;
  String? _nameError;
  String? _priceError;
  String? _purchasePriceError;
  String? _stockError;
  String? _minStockError;
  bool _isLoading = false;
  bool _prefilled = false;
  String? _categoryId;
  String? _initialCategoryId;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _priceController = TextEditingController();
    _purchasePriceController = TextEditingController();
    _barcodeController = TextEditingController(
      text: widget.initialBarcode ?? '',
    );
    _stockController = TextEditingController();
    _minStockController = TextEditingController();
    _formAnimationController = AnimationController(
      // Entrée courte : le formulaire doit être utilisable tout de suite.
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    unawaited(_formAnimationController.forward());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _purchasePriceController.dispose();
    _barcodeController.dispose();
    _stockController.dispose();
    _minStockController.dispose();
    _formAnimationController.dispose();
    super.dispose();
  }

  Future<void> _openScanner() async {
    final code = await context.push<String>(Routes.barcodeScanner);
    if (code != null && mounted) {
      _barcodeController.text = code;
    }
  }

  bool _validate() {
    String? nameError;
    String? priceError;
    String? purchasePriceError;
    String? stockError;
    String? minStockError;

    if (_nameController.text.trim().isEmpty) {
      nameError = 'Le nom est obligatoire';
    }

    final sellingPrice = Decimal.tryParse(_priceController.text.trim());
    if (_priceController.text.trim().isEmpty) {
      priceError = 'Le prix de vente est obligatoire';
    } else if (sellingPrice == null || sellingPrice < Decimal.zero) {
      priceError = 'Entrez un montant valide';
    }

    // Prix d'achat optionnel ; vendre à perte reste permis (ADR-0009).
    final purchaseText = _purchasePriceController.text.trim();
    final purchasePrice = Decimal.tryParse(purchaseText);
    if (purchaseText.isNotEmpty &&
        (purchasePrice == null || purchasePrice < Decimal.zero)) {
      purchasePriceError = 'Entrez un montant valide';
    }

    final stockText = _stockController.text.trim();
    if (stockText.isNotEmpty && int.tryParse(stockText) == null) {
      stockError = 'Entrez un nombre entier valide';
    }

    final minStockText = _minStockController.text.trim();
    if (minStockText.isNotEmpty && int.tryParse(minStockText) == null) {
      minStockError = 'Entrez un nombre entier valide';
    }

    setState(() {
      _nameError = nameError;
      _priceError = priceError;
      _purchasePriceError = purchasePriceError;
      _stockError = stockError;
      _minStockError = minStockError;
    });

    return nameError == null &&
        priceError == null &&
        purchasePriceError == null &&
        stockError == null &&
        minStockError == null;
  }

  Future<void> _submit() async {
    if (!_validate()) return;

    setState(() => _isLoading = true);

    try {
      final name = _nameController.text.trim();
      final price = _priceController.text.trim();
      final purchaseText = _purchasePriceController.text.trim();
      final purchasePrice = purchaseText.isEmpty ? null : purchaseText;
      final barcode = _barcodeController.text.trim();
      final stock = _stockController.text.trim().isEmpty
          ? null
          : int.tryParse(_stockController.text.trim());
      final minStock = _minStockController.text.trim().isEmpty
          ? null
          : int.tryParse(_minStockController.text.trim());

      if (widget.productId == null) {
        // Mode création
        await ref
            .read(productEditorProvider.notifier)
            .create(
              name: name,
              sellingPrice: price,
              purchasePrice: purchasePrice,
              barcode: barcode.isEmpty ? null : barcode,
              currentStock: stock,
              minStock: minStock,
              categoryId: _categoryId,
            );
      } else {
        // Mode édition
        await ref
            .read(productEditorProvider.notifier)
            .update(
              id: widget.productId!,
              name: name,
              sellingPrice: price,
              purchasePrice: purchasePrice,
              barcode: barcode.isEmpty ? null : barcode,
              currentStock: stock,
              minStock: minStock,
            );
        if (_categoryId != _initialCategoryId) {
          await ref
              .read(categoryEditorProvider.notifier)
              .setProductCategory(widget.productId!, _categoryId);
        }
      }

      if (mounted) {
        context.pop();
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

  Future<void> _delete() async {
    if (widget.productId == null) return;

    final confirmed = await showConfirmDialog(
      context,
      title: 'Supprimer le produit',
      message: 'Êtes-vous sûr? Cette action ne peut pas être annulée.',
      confirmLabel: 'Supprimer',
      isDangerous: true,
    );

    if (!confirmed) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(productEditorProvider.notifier).delete(widget.productId!);
      if (mounted) {
        context.pop();
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
    final isEditMode = widget.productId != null;
    final productAsync = isEditMode
        ? ref.watch(productProvider(widget.productId!))
        : null;

    // Charge les données du formulaire en mode édition — une seule fois, quels
    // que soient les rebuilds suivants.
    if (productAsync != null && !_prefilled) {
      productAsync.whenData((product) {
        if (product != null) {
          _prefilled = true;
          _nameController.text = product.name;
          _priceController.text = product.sellingPrice.toString();
          _purchasePriceController.text =
              product.purchasePrice?.toString() ?? '';
          if (product.barcode != null) {
            _barcodeController.text = product.barcode!;
          }
          if (product.currentStock != null) {
            _stockController.text = product.currentStock!.toString();
          }
          if (product.minStock != null) {
            _minStockController.text = product.minStock!.toString();
          }
          _categoryId = product.categoryId;
          _initialCategoryId = product.categoryId;
        }
      });
    }

    final spacing = responsiveValue(
      context,
      small: AppSpacing.md,
      medium: AppSpacing.lg,
    );
    // ✨ AppBar M3 standard — backgroundColor et elevation gérés par le theme
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(isEditMode ? 'Modifier le produit' : 'Nouveau produit'),
        actions: isEditMode
            ? [
                IconButton(
                  icon: const Icon(Icons.history),
                  tooltip: 'Historique du stock',
                  onPressed: () => context.push(
                    Routes.productStockHistory.replaceFirst(
                      ':id',
                      widget.productId!,
                    ),
                  ),
                ),
              ]
            : null,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: spacing,
            right: spacing,
            top: spacing,
            bottom: spacing + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _AnimatedFormField(
                animation: _formAnimationController,
                delay: 0.0,
                child: AppTextField(
                  label: 'Nom du produit',
                  hint: 'ex: Riz blanc',
                  controller: _nameController,
                  errorText: _nameError,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              _AnimatedFormField(
                animation: _formAnimationController,
                delay: 0.1,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: "Prix d'achat (FCFA)",
                        hint: 'Optionnel',
                        controller: _purchasePriceController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        errorText: _purchasePriceError,
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: AppTextField(
                        label: 'Prix de vente (FCFA)',
                        hint: '0',
                        controller: _priceController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        errorText: _priceError,
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                  ],
                ),
              ),
              _EstimatedMargin(
                sellingText: _priceController.text,
                purchaseText: _purchasePriceController.text,
              ),
              const SizedBox(height: AppSpacing.lg),
              CategoryPicker(
                value: _categoryId,
                onChanged: (id) => setState(() => _categoryId = id),
              ),
              const SizedBox(height: AppSpacing.lg),
              _AnimatedFormField(
                animation: _formAnimationController,
                delay: 0.2,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: 'Code-barres',
                        hint: 'Optionnel',
                        controller: _barcodeController,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    // ✨ IconButton M3 — remplace Material+InkWell custom (20 lignes → 8)
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.md),
                      child: IconButton(
                        onPressed: _openScanner,
                        icon: const Icon(Icons.qr_code_2, size: 28),
                        tooltip: 'Scanner un code-barres',
                        style: IconButton.styleFrom(
                          backgroundColor: cs.primaryContainer,
                          foregroundColor: cs.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              _AnimatedFormField(
                animation: _formAnimationController,
                delay: 0.3,
                child: AppTextField(
                  label: 'Stock initial',
                  hint: 'Optionnel',
                  controller: _stockController,
                  keyboardType: TextInputType.number,
                  errorText: _stockError,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              _AnimatedFormField(
                animation: _formAnimationController,
                delay: 0.4,
                child: AppTextField(
                  label: 'Seuil d\'alerte stock bas',
                  hint: 'Optionnel — ex: 5',
                  controller: _minStockController,
                  keyboardType: TextInputType.number,
                  errorText: _minStockError,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              _AnimatedFormField(
                animation: _formAnimationController,
                delay: 0.5,
                child: PrimaryButton(
                  label: isEditMode ? 'Modifier' : 'Enregistrer',
                  onPressed: _isLoading ? null : _submit,
                  isLoading: _isLoading,
                ),
              ),
              if (isEditMode) ...[
                const SizedBox(height: AppSpacing.md),
                _AnimatedFormField(
                  animation: _formAnimationController,
                  delay: 0.6,
                  // ✨ cs.error — cs déjà défini en build(), SizedBox fixe supprimé
                  child: OutlinedButton.icon(
                    onPressed: _isLoading ? null : _delete,
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Supprimer'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: cs.error,
                      side: BorderSide(color: cs.error),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusMd,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Marge estimée, recalculée à chaque frappe ; masquée tant que l'un des deux
/// prix est vide ou invalide. Donnée interne au commerçant.
class _EstimatedMargin extends StatelessWidget {
  const _EstimatedMargin({
    required this.sellingText,
    required this.purchaseText,
  });

  final String sellingText;
  final String purchaseText;

  @override
  Widget build(BuildContext context) {
    final selling = Decimal.tryParse(sellingText.trim());
    final purchase = Decimal.tryParse(purchaseText.trim());
    if (selling == null || purchase == null) return const SizedBox.shrink();

    final margin = selling - purchase;
    final semantic = Theme.of(context).extension<AppSemanticColors>()!;
    final cs = Theme.of(context).colorScheme;
    final isLoss = margin < Decimal.zero;
    final color = isLoss ? cs.error : semantic.success;
    final sign = margin > Decimal.zero ? '+' : '';

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: Row(
        children: [
          Text(
            'Marge estimée',
            style: AppTypography.bodySmall.copyWith(color: cs.onSurfaceVariant),
          ),
          const Spacer(),
          Text(
            isLoss
                ? '${formatFcfa(margin)} · vente à perte'
                : '$sign${formatFcfa(margin)}',
            style: AppTypography.labelMedium.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

/// Enveloppe privée de champ de formulaire animé — apparaît en fondu et
/// glissement au chargement.
class _AnimatedFormField extends StatelessWidget {
  const _AnimatedFormField({
    required this.animation,
    required this.delay,
    required this.child,
  });

  final AnimationController animation;
  final double delay;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // ✨ une seule CurvedAnimation partagée — évite de créer le même objet deux fois
    final curved = CurvedAnimation(
      parent: animation,
      curve: Interval(delay, delay + 0.4, curve: Curves.easeOut),
    );

    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(curved),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.3),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  }
}
