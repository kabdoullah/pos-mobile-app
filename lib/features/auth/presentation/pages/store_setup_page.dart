import '../../../../core/utils/phone_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../../../../core/network/error_mapper.dart';
import '../../../../core/responsive/responsive.dart';
// ✨ [Design system] import app_colors.dart supprimé — AppColors.textSecondary → cs.onSurfaceVariant
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../providers/auth_providers.dart';
import '../../providers/store_provider.dart';
import '../widgets/registration_stepper.dart';
import '../../domain/entities/store.dart';

/// Page de création/configuration de la boutique.
///
/// L'utilisateur saisit le nom de la boutique, l'adresse, le NCC (identifiant
/// fiscal, optionnel) et le statut TVA. Intervient après la première connexion,
/// avant d'accéder à l'app. Utilisable en mode création (après l'inscription)
/// ou en mode édition (depuis les paramètres).
class StoreSetupPage extends ConsumerStatefulWidget {
  /// Crée une page de configuration de la boutique.
  const StoreSetupPage({this.isEditMode = false, super.key});

  /// Si true, la page est en mode édition (depuis les paramètres) et se ferme
  /// au lieu de router.
  final bool isEditMode;

  @override
  ConsumerState<StoreSetupPage> createState() => _StoreSetupPageState();
}

class _StoreSetupPageState extends ConsumerState<StoreSetupPage> {
  static final _logger = Logger();

  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _nccController;
  final _phoneController = TextEditingController();
  String? _phoneError;

  String? _nameError;
  bool _isSubjectToVat = true;
  bool _isLoading = false;

  /// Passe à true une fois le formulaire en mode édition pré-rempli depuis la
  /// boutique existante.
  /// Évite d'écraser les modifications de l'utilisateur si le provider réémet.
  bool _prefilled = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _addressController = TextEditingController();
    _nccController = TextEditingController();
  }

  /// Pré-remplit le formulaire depuis la boutique dès que ses données sont
  /// disponibles.
  ///
  /// Gère la course asynchrone où `storeConfigProvider` est encore en
  /// chargement au premier build : appelé à la fois depuis le `ref.read`
  /// initial et depuis un `ref.listen`, pour qu'une valeur arrivée en retard
  /// remplisse quand même les champs.
  void _prefillFrom(AsyncValue<Store?> async) {
    if (_prefilled) return;
    final store = async.asData?.value;
    if (store == null) return;
    _prefilled = true;
    _nameController.text = store.name;
    _addressController.text = store.address ?? '';
    _nccController.text = store.ncc ?? '';
    final phone = store.phone;
    // E.164 (+225XXXXXXXXXX) → saisie locale espacée (07 00 00 00 00).
    if (phone != null && phone.startsWith('+225')) {
      _phoneController.text = const SpacedPhoneFormatter()
          .formatEditUpdate(
            TextEditingValue.empty,
            TextEditingValue(text: phone.substring(4)),
          )
          .text;
    }
    // Reporte le setState hors de la phase de build (ceci peut s'exécuter
    // pendant le build).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _isSubjectToVat = store.isSubjectToVat);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _nccController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  bool _validateForm() {
    _nameError = null;
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      _nameError = 'Nom de la boutique requis';
    }

    final phone = _phoneController.text.trim();
    _phoneError = phone.isEmpty || isValidLocalPhoneCi(phone)
        ? null
        : 'Numéro à 10 chiffres, ex. 07 00 00 00 00';

    setState(() {});
    return _nameError == null && _phoneError == null;
  }

  Future<void> _saveStore() async {
    if (!_validateForm()) return;

    setState(() => _isLoading = true);

    try {
      // Réglages hors de ce formulaire (Paramètres → Reçus) : conservés.
      final current = ref.read(storeConfigProvider).value;
      final phone = _phoneController.text.trim();
      final store = Store(
        name: _nameController.text.trim(),
        address: _addressController.text.trim().isEmpty
            ? null
            : _addressController.text.trim(),
        ncc: _nccController.text.trim().isEmpty
            ? null
            : _nccController.text.trim(),
        isSubjectToVat: _isSubjectToVat,
        receiptFooterText: current?.receiptFooterText,
        logoVersion: current?.logoVersion,
        phone: phone.isEmpty ? null : toE164Ci(phone),
      );

      await ref.read(storeConfigProvider.notifier).save(store);

      // On abandonne si le widget a été démonté pendant l'enregistrement.
      if (!mounted) {
        _logger.w('Widget not mounted after save');
        return;
      }

      setState(() => _isLoading = false);

      if (widget.isEditMode) {
        // Le mode édition est ouvert via showModalBottomSheet (Navigator
        // racine), pas via go_router — on ferme le Navigator Flutter, pas le
        // routeur.
        Navigator.of(context).pop();
      } else {
        _logger.i('Calling proceedToPinSetup()');
        await ref.read(authProvider.notifier).proceedToPinSetup();
        _logger.i('proceedToPinSetup() completed');
      }
    } catch (e) {
      if (mounted) {
        _logger.e('Error saving store configuration - $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              errorToFrench(e),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onError,
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Mode édition : pré-remplissage depuis la boutique existante, en gérant le
    // cas où le provider est encore en chargement au premier build (le listen
    // récupère les valeurs tardives).
    if (widget.isEditMode && !_prefilled) {
      ref.listen<AsyncValue<Store?>>(storeConfigProvider, (_, next) {
        _prefillFrom(next);
      });
      _prefillFrom(ref.read(storeConfigProvider));
    }

    // ✨ [Qualité] colorScheme centralisé — supprime les Theme.of(context) inline répétés
    final cs = Theme.of(context).colorScheme;
    final spacing = responsiveValue(
      context,
      small: AppSpacing.md,
      medium: AppSpacing.lg,
    );

    return Scaffold(
      // Le mode édition est poussé en dialogue plein écran depuis les
      // paramètres — on lui donne un moyen de fermer. Le mode création est
      // atteint via le routeur et n'a pas d'action retour (étape d'onboarding),
      // il garde donc seulement son en-tête dans le corps.
      appBar: widget.isEditMode
          ? AppBar(
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.close),
                // ✨ [A11y] tooltip — obligatoire sur tous les IconButton (WCAG 2.4.6)
                tooltip: 'Fermer',
                onPressed: () => Navigator.of(context).pop(),
              ),
            )
          : null,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!widget.isEditMode)
              Padding(
                padding: EdgeInsets.fromLTRB(
                  spacing,
                  spacing,
                  spacing,
                  AppSpacing.lg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const RegistrationStepper(currentStep: 2),
                    const SizedBox(height: AppSpacing.lg),
                    // ✨ [Design system] explicit cs.onSurface — cohérence avec register_page.dart
                    Text(
                      'Votre boutique',
                      style: AppTypography.titleLarge.copyWith(
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    // ✨ [Design system] cs.onSurfaceVariant remplace
                    // AppColors.textSecondary — compatible mode sombre
                    Text(
                      'Configurez votre point de vente pour vos reçus et rapports.',
                      style: AppTypography.bodyMedium.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              )
            else
              Padding(
                padding: EdgeInsets.fromLTRB(
                  spacing,
                  spacing,
                  spacing,
                  AppSpacing.lg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ✨ [Design system] explicit cs.onSurface — cohérence inter-pages
                    Text(
                      'Modifier ma boutique',
                      style: AppTypography.titleLarge.copyWith(
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Informations de votre commerce',
                      style: AppTypography.bodyMedium.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(spacing, 0, spacing, spacing),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppTextField(
                      label: 'Nom de la boutique',
                      hint: 'ex: Ma boutique',
                      controller: _nameController,
                      errorText: _nameError,
                      prefixIcon: Icons.storefront_outlined,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppTextField(
                      label: 'Adresse (optionnel)',
                      hint: 'ex: 123 rue du Commerce',
                      controller: _addressController,
                      prefixIcon: Icons.location_on_outlined,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppTextField(
                      label: 'NCC (optionnel)',
                      hint: 'Numéro de contribuable',
                      controller: _nccController,
                      prefixIcon: Icons.badge_outlined,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppTextField(
                      label: 'Téléphone (optionnel, imprimé sur les reçus)',
                      hint: '07 00 00 00 00',
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      inputFormatters: const [SpacedPhoneFormatter()],
                      errorText: _phoneError,
                      prefixIcon: Icons.phone_outlined,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Padding(
                      padding: const EdgeInsets.only(left: AppSpacing.md),
                      child: Row(
                        children: [
                          // ✨ [A11y] ExcludeSemantics — icône décorative, le texte suffit
                          ExcludeSemantics(
                            child: Icon(
                              Icons.help_outline,
                              size: 16,
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Expanded(
                            // ✨ [Design system] cs.onSurfaceVariant explicite — visuel subordonné
                            child: Text(
                              'Numéro attribué par les autorités fiscales pour la facturation',
                              style: AppTypography.captionText.copyWith(
                                color: cs.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: cs.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusMd,
                        ),
                      ),
                      // ✨ [A11y] MergeSemantics — associe "Assujetti à la TVA" au Switch
                      //    pour que VoiceOver/TalkBack lise un seul élément cohérent
                      child: MergeSemantics(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Assujetti à la TVA',
                                    style: AppTypography.labelMedium,
                                  ),
                                  SizedBox(height: AppSpacing.xs),
                                  Text(
                                    'Votre boutique facture avec TVA',
                                    style: AppTypography.captionText,
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: _isSubjectToVat,
                              onChanged: (value) {
                                setState(() => _isSubjectToVat = value);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    PrimaryButton(
                      label: 'Enregistrer ma boutique',
                      onPressed: _isLoading ? null : _saveStore,
                      isLoading: _isLoading,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
