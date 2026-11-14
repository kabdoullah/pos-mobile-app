import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/network/error_mapper.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/barcode_utils.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/index.dart';
import '../../providers/catalog_di_providers.dart';
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

class _ProductFormPageState extends ConsumerState<ProductFormPage> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _purchasePriceController;
  late TextEditingController _barcodeController;
  late TextEditingController _stockController;
  late TextEditingController _minStockController;
  String? _nameError;
  String? _priceError;
  String? _purchasePriceError;
  String? _stockError;
  String? _minStockError;
  String? _barcodeError;
  bool _isLoading = false;
  bool _prefilled = false;

  /// Stock déjà suivi à l'ouverture (modification) : il ne se change plus
  /// ici mais par « Ajuster » (mouvement tracé).
  bool _stockTracked = false;
  static final _logger = Logger();

  // Code-barres (normalisé) dont vient le nom affiché, tant que l'utilisateur
  // n'a pas retouché ce nom ; null sinon. Un nom suggéré peut être remplacé
  // par un nouveau scan, un nom saisi jamais.
  String? _nameSuggestedFor;
  bool get _nameSuggested => _nameSuggestedFor != null;
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
    final initialBarcode = widget.initialBarcode;
    if (widget.productId == null && initialBarcode != null) {
      unawaited(_suggestName(initialBarcode));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _purchasePriceController.dispose();
    _barcodeController.dispose();
    _stockController.dispose();
    _minStockController.dispose();
    super.dispose();
  }

  Future<void> _openScanner() async {
    final code = await context.push<String>(Routes.barcodeScanner);
    if (code != null && mounted) {
      _barcodeController.text = code;
      await _suggestName(code);
    }
  }

  /// Le nom peut être (re)rempli : vide, ou encore tel que suggéré.
  bool get _nameReplaceable =>
      _nameController.text.trim().isEmpty || _nameSuggested;

  /// Pré-remplit le nom depuis le référentiel embarqué (création seulement).
  ///
  /// Ne remplace jamais un nom saisi, même pendant la recherche, et ignore une
  /// réponse arrivée alors que le champ code-barres a changé entre-temps.
  Future<void> _suggestName(String barcode) async {
    if (widget.productId != null || !_nameReplaceable) return;
    final code = normalizeBarcode(barcode);
    String? name;
    if (code != null) {
      try {
        name = await ref
            .read(barcodeReferenceRepositoryProvider)
            .suggestName(code);
      } catch (e, st) {
        // Suggestion facultative : la saisie manuelle reste possible.
        _logger.w(
          'Référentiel de codes-barres illisible',
          error: e,
          stackTrace: st,
        );
      }
    }
    if (!mounted ||
        normalizeBarcode(_barcodeController.text) != code ||
        !_nameReplaceable) {
      return;
    }
    if (name != null) {
      setState(() {
        _nameController.text = name!;
        _nameSuggestedFor = code;
        _nameError = null;
      });
    } else {
      _dropSuggestedName();
    }
  }

  /// Retire un nom suggéré qui ne correspond plus au code-barres affiché.
  void _dropSuggestedName() {
    if (!_nameSuggested) return;
    setState(() {
      _nameController.clear();
      _nameSuggestedFor = null;
    });
  }

  void _onBarcodeEdited(String text) {
    if (_nameSuggested && normalizeBarcode(text) != _nameSuggestedFor) {
      _dropSuggestedName();
    }
  }

  bool _validate() {
    String? nameError;
    String? priceError;
    String? purchasePriceError;
    String? stockError;
    String? minStockError;
    String? barcodeError;

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

    // Sans ce contrôle, normalizeBarcode écarterait le code en silence et le
    // produit serait introuvable au scan.
    final barcodeText = _barcodeController.text.trim();
    if (barcodeText.isNotEmpty && normalizeBarcode(barcodeText) == null) {
      barcodeError = '6 à 50 lettres ou chiffres, sans espace ni tiret';
    }

    setState(() {
      _nameError = nameError;
      _priceError = priceError;
      _purchasePriceError = purchasePriceError;
      _stockError = stockError;
      _minStockError = minStockError;
      _barcodeError = barcodeError;
    });

    return nameError == null &&
        priceError == null &&
        purchasePriceError == null &&
        stockError == null &&
        minStockError == null &&
        barcodeError == null;
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
        // Mode édition. Stock suivi : il ne se change que par « Ajuster » ;
        // on renvoie le stock actuel relu, jamais celui affiché à
        // l'ouverture (des ventes ont pu le modifier entre-temps).
        final currentStock = _stockTracked
            ? (await ref
                      .read(catalogRepositoryProvider)
                      .getProduct(widget.productId!))
                  ?.currentStock
            : stock;
        await ref
            .read(productEditorProvider.notifier)
            .update(
              id: widget.productId!,
              name: name,
              sellingPrice: price,
              purchasePrice: purchasePrice,
              barcode: barcode.isEmpty ? null : barcode,
              currentStock: currentStock,
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
      title: 'Supprimer « ${_nameController.text.trim()} » ?',
      message:
          'Il ne sera plus proposé en caisse ni dans le stock. Ses ventes '
          'passées restent dans l’historique.',
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
            _stockTracked = true;
          }
          if (product.minStock != null) {
            _minStockController.text = product.minStock!.toString();
          }
          _categoryId = product.categoryId;
          _initialCategoryId = product.categoryId;
        }
      });
    }

    final colors = AppColors.of(context);
    final spacing = responsiveValue(
      context,
      small: AppSpacing.md,
      medium: AppSpacing.lg,
    );
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(isEditMode ? 'Modifier le produit' : 'Nouveau produit'),
        actions: [
          if (isEditMode)
            TextButton(
              onPressed: () => context.push(
                Routes.productStockHistory.replaceFirst(
                  ':id',
                  widget.productId!,
                ),
              ),
              child: const Text('Historique'),
            ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.fromLTRB(
                spacing,
                AppSpacing.sm,
                spacing,
                spacing,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: AppTextField(
                          label: 'Code-barres',
                          hint: 'Facultatif',
                          controller: _barcodeController,
                          errorText: _barcodeError,
                          onChanged: _onBarcodeEdited,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Semantics(
                          label: 'Scanner un code-barres',
                          button: true,
                          excludeSemantics: true,
                          child: TextButton.icon(
                            onPressed: _openScanner,
                            icon: const Icon(Icons.qr_code_scanner, size: 20),
                            label: const Text('Scanner'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    label: 'Nom du produit',
                    hint: 'ex. : Riz blanc',
                    controller: _nameController,
                    errorText: _nameError,
                    onChanged: (_) {
                      if (_nameSuggested) {
                        setState(() => _nameSuggestedFor = null);
                      }
                    },
                    helper: _nameSuggested ? const _SuggestedNameHint() : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  CategoryPicker(
                    value: _categoryId,
                    onChanged: (id) => setState(() => _categoryId = id),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: AppTextField(
                          label: "Prix d'achat",
                          hint: 'Facultatif',
                          suffixText: 'FCFA',
                          controller: _purchasePriceController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          errorText: _purchasePriceError,
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm + AppSpacing.xs),
                      Expanded(
                        child: AppTextField(
                          label: 'Prix de vente',
                          hint: '0',
                          suffixText: 'FCFA',
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
                  _EstimatedMargin(
                    sellingText: _priceController.text,
                    purchaseText: _purchasePriceController.text,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: AppTextField(
                          label: _stockTracked
                              ? 'Stock actuel'
                              : 'Stock initial',
                          hint: 'Facultatif',
                          controller: _stockController,
                          keyboardType: TextInputType.number,
                          errorText: _stockError,
                          readOnly: _stockTracked,
                          helper: _stockTracked
                              ? Text(
                                  'Se modifie par « Ajuster ».',
                                  style: AppTypography.bodySmall.copyWith(
                                    color: colors.textSecondary,
                                  ),
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm + AppSpacing.xs),
                      Expanded(
                        child: AppTextField(
                          label: "Seuil d'alerte",
                          hint: 'ex. : 5',
                          controller: _minStockController,
                          keyboardType: TextInputType.number,
                          errorText: _minStockError,
                        ),
                      ),
                    ],
                  ),
                  if (isEditMode) ...[
                    const SizedBox(height: AppSpacing.md),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: _isLoading ? null : _delete,
                        style: TextButton.styleFrom(
                          foregroundColor: colors.error,
                          padding: EdgeInsets.zero,
                        ),
                        child: const Text('Supprimer le produit'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              color: colors.surface,
              border: Border(top: BorderSide(color: colors.border)),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm + AppSpacing.xs,
                ),
                child: PrimaryButton(
                  label: isEditMode
                      ? 'Enregistrer les modifications'
                      : 'Enregistrer le produit',
                  onPressed: _isLoading ? null : _submit,
                  isLoading: _isLoading,
                ),
              ),
            ),
          ),
        ],
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
    final colors = AppColors.of(context);
    final isLoss = margin < Decimal.zero;
    final rate = selling == Decimal.zero
        ? null
        : (margin * Decimal.fromInt(100) / selling).round();
    final amount = margin > Decimal.zero
        ? '+ ${formatFcfa(margin)}'
        : margin < Decimal.zero
        ? '− ${formatFcfa(margin.abs())}'
        : formatFcfa(margin);

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: Text(
        isLoss
            ? 'Marge estimée : $amount par unité · vente à perte'
            : 'Marge estimée : $amount par unité'
                  '${rate == null ? '' : ' ($rate %)'}',
        style: AppTypography.meta.copyWith(
          color: isLoss ? colors.error : colors.success,
          fontFeatures: AppTypography.tabularFigures,
        ),
      ),
    );
  }
}

/// Signale un nom venu du référentiel de codes-barres : souvent abrégé, à
/// relire avant d'enregistrer.
class _SuggestedNameHint extends StatelessWidget {
  const _SuggestedNameHint();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    // Annoncé par le lecteur d'écran : le nom se remplit sans action directe.
    return Semantics(
      liveRegion: true,
      child: Row(
        children: [
          ExcludeSemantics(
            child: Icon(
              Icons.auto_awesome_outlined,
              size: 16,
              color: cs.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              'Nom suggéré d\'après le code-barres. Vérifiez-le.',
              style: AppTypography.bodySmall.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
