import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/network/error_mapper.dart';
import '../../../../core/utils/phone_formatter.dart';
import '../../../../core/widgets/index.dart';
import '../../domain/entities/store.dart';
import '../../providers/store_provider.dart';
import '../providers/auth_providers.dart';
import '../widgets/auth_layout.dart';
import '../widgets/registration_stepper.dart';

/// Page de création/configuration de la boutique.
///
/// Mode création : étape 2 de l'inscription (atteinte via le routeur, y compris
/// au relancement si l'app a été fermée à cette étape). Mode édition : ouverte
/// depuis les paramètres, se ferme après l'enregistrement.
///
/// Les informations fiscales (NCC, TVA) sont repliées par défaut : la plupart
/// des petits commerces n'en ont pas besoin pour démarrer.
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

  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _nccController = TextEditingController();
  final _phoneController = TextEditingController();

  String? _nameError;
  String? _phoneError;
  String? _saveError;
  bool _isSubjectToVat = false;
  bool _showFiscal = false;
  bool _isLoading = false;

  /// Passe à true une fois le formulaire pré-rempli depuis la boutique
  /// existante. Évite d'écraser les modifications de l'utilisateur si le
  /// provider réémet.
  bool _prefilled = false;

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
      if (!mounted) return;
      setState(() {
        _isSubjectToVat = store.isSubjectToVat;
        _showFiscal = store.isSubjectToVat || (store.ncc ?? '').isNotEmpty;
      });
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
    final phone = _phoneController.text.trim();
    setState(() {
      _nameError = _nameController.text.trim().isEmpty
          ? 'Donnez un nom à votre boutique.'
          : null;
      _phoneError = phone.isEmpty || isValidLocalPhoneCi(phone)
          ? null
          : 'Numéro à 10 chiffres, ex. 07 00 00 00 00.';
    });
    return _nameError == null && _phoneError == null;
  }

  String? _trimmedOrNull(TextEditingController c) {
    final text = c.text.trim();
    return text.isEmpty ? null : text;
  }

  Future<void> _saveStore() async {
    if (_isLoading || !_validateForm()) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
      _saveError = null;
    });

    try {
      // Réglages hors de ce formulaire (Paramètres → Reçus) : conservés.
      final current = ref.read(storeConfigProvider).value;
      final phone = _trimmedOrNull(_phoneController);
      final store = Store(
        name: _nameController.text.trim(),
        address: _trimmedOrNull(_addressController),
        ncc: _trimmedOrNull(_nccController),
        isSubjectToVat: _isSubjectToVat,
        receiptFooterText: current?.receiptFooterText,
        logoVersion: current?.logoVersion,
        phone: phone == null ? null : toE164Ci(phone),
      );

      await ref.read(storeConfigProvider.notifier).save(store);
      if (!mounted) return;

      if (widget.isEditMode) {
        // Le mode édition est poussé par le Navigator Flutter (paramètres),
        // pas par go_router.
        Navigator.of(context).pop();
      } else {
        // Le routeur passe à l'étape PIN.
        await ref.read(authProvider.notifier).proceedToPinSetup();
      }
    } catch (e) {
      _logger.e('Error saving store configuration - $e');
      if (mounted) setState(() => _saveError = errorToFrench(e));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Pré-remplissage : en édition, et au retour depuis l'étape PIN (la
    // boutique est déjà enregistrée). Pas à la première visite : le serveur
    // a créé une boutique « Ma boutique » par défaut qu'il faut renommer.
    final isRevisit =
        !widget.isEditMode &&
        switch (ref.watch(authProvider).value) {
          AuthStoreSetupRequired(:final isRevisit) => isRevisit,
          _ => false,
        };
    if ((widget.isEditMode || isRevisit) && !_prefilled) {
      ref.listen<AsyncValue<Store?>>(storeConfigProvider, (_, next) {
        _prefillFrom(next);
      });
      _prefillFrom(ref.read(storeConfigProvider));
    }

    final form = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.isEditMode)
          const AuthHeader(
            title: 'Modifier ma boutique',
            subtitle: 'Ces informations apparaissent sur vos reçus.',
          )
        else ...[
          const RegistrationStepper(currentStep: 2),
          const SizedBox(height: AppSpacing.lg),
          const AuthHeader(
            title: 'Configurez votre boutique',
            subtitle:
                'Ces informations permettront de personnaliser votre espace '
                'de gestion et vos reçus.',
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          child: _saveError != null
              ? Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                  child: AuthBanner(
                    title: 'Enregistrement impossible',
                    message: _saveError!,
                  ),
                )
              : const SizedBox(width: double.infinity),
        ),
        const _SectionTitle('Informations de la boutique'),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'Nom de la boutique',
          hint: 'ex. Boutique Awa',
          controller: _nameController,
          errorText: _nameError,
          prefixIcon: Icons.storefront_outlined,
          textInputAction: TextInputAction.next,
          onChanged: (_) {
            if (_nameError != null) setState(() => _nameError = null);
          },
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'Adresse (facultatif)',
          hint: 'ex. Marché de Cocody',
          controller: _addressController,
          prefixIcon: Icons.location_on_outlined,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'Téléphone (facultatif)',
          hint: '07 00 00 00 00',
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          inputFormatters: const [SpacedPhoneFormatter()],
          errorText: _phoneError,
          prefixIcon: Icons.phone_outlined,
          onChanged: (_) {
            if (_phoneError != null) setState(() => _phoneError = null);
          },
          helper: const _FieldHelp('Imprimé sur vos reçus.'),
        ),
        const SizedBox(height: AppSpacing.xl),
        const _SectionTitle('Informations fiscales'),
        const SizedBox(height: AppSpacing.sm),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.topCenter,
          child: _showFiscal ? _buildFiscalFields() : _buildFiscalToggle(),
        ),
        const SizedBox(height: AppSpacing.xl),
        PrimaryButton(
          label: widget.isEditMode ? 'Enregistrer ma boutique' : 'Continuer',
          loadingLabel: 'Enregistrement…',
          onPressed: _saveStore,
          isLoading: _isLoading,
        ),
      ],
    );

    if (widget.isEditMode) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close),
            tooltip: 'Fermer',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: form,
          ),
        ),
      );
    }
    return AuthScaffold(child: form);
  }

  /// État replié : une seule ligne, pour ne pas donner l'impression d'un
  /// formulaire fiscal.
  Widget _buildFiscalToggle() {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Facultatif. Utile si votre boutique a un numéro de contribuable '
          'ou facture la TVA.',
          style: AppTypography.bodySmall.copyWith(color: cs.onSurfaceVariant),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () => setState(() => _showFiscal = true),
            icon: const Icon(Icons.add),
            label: const Text('Ajouter mes informations fiscales'),
          ),
        ),
      ],
    );
  }

  Widget _buildFiscalFields() {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          label: 'NCC (facultatif)',
          hint: 'Numéro de compte contribuable',
          controller: _nccController,
          prefixIcon: Icons.badge_outlined,
          helper: const _FieldHelp(
            'Attribué par la DGI, imprimé sur vos reçus.',
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Material(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          clipBehavior: Clip.antiAlias,
          child: SwitchListTile(
            value: _isSubjectToVat,
            onChanged: (value) => setState(() => _isSubjectToVat = value),
            title: Text(
              'Assujetti à la TVA',
              style: AppTypography.labelMedium.copyWith(color: cs.onSurface),
            ),
            subtitle: Text(
              'Votre boutique facture avec TVA.',
              style: AppTypography.captionText.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: Text(
        title,
        style: AppTypography.titleMedium.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}

class _FieldHelp extends StatelessWidget {
  const _FieldHelp(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTypography.captionText.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}
