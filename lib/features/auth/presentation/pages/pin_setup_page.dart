import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../providers/auth_providers.dart';
import '../widgets/auth_layout.dart';
import '../widgets/pin_numpad.dart';
import '../widgets/registration_stepper.dart';

/// Écran de création du PIN — saisie puis confirmation, pavé numérique
/// personnalisé.
///
/// Étape 0 : l'utilisateur saisit un nouveau PIN (les PIN trop simples sont
/// refusés). Étape 1 : il le confirme ; s'ils correspondent, [Auth.setupPin]
/// est appelé et le routeur ouvre l'accueil.
///
/// Dans le parcours d'inscription, le retour (flèche ou bouton système) ramène
/// à l'étape boutique ; ailleurs (connexion sur un nouvel appareil), pas
/// d'indicateur d'étapes ni de retour.
class PinSetupPage extends ConsumerStatefulWidget {
  /// Crée une page de création du PIN.
  const PinSetupPage({super.key});

  @override
  ConsumerState<PinSetupPage> createState() => _PinSetupPageState();
}

class _PinSetupPageState extends ConsumerState<PinSetupPage> {
  String _pin = '';
  String _firstPin = '';

  /// 0 = création, 1 = confirmation.
  int _step = 0;
  String? _errorTitle;
  String? _errorDetail;

  /// Échec de [Auth.setupPin] affiché jusqu'à la saisie suivante (l'erreur
  /// reste dans authProvider : l'effacer renverrait à la connexion).
  bool _showSetupError = false;

  /// Parcours d'inscription. Mémorisé : une erreur de [Auth.setupPin] ne doit
  /// pas faire disparaître l'indicateur d'étapes ni le retour.
  bool _inRegistration = false;

  static final _logger = Logger();

  static const _trivialPins = {
    '0123',
    '1234',
    '2345',
    '3456',
    '4567',
    '5678',
    '6789',
    '9876',
    '8765',
    '7654',
    '6543',
    '5432',
    '4321',
  };

  bool _isTrivialPin(String pin) {
    if (pin.isNotEmpty && pin.split('').every((c) => c == pin[0])) return true;
    return _trivialPins.contains(pin);
  }

  void _setError(String? title, [String? detail]) {
    _errorTitle = title;
    _errorDetail = detail;
  }

  void _onDigit(String digit) {
    if (_pin.length >= 4) return;
    setState(() {
      _pin += digit;
      _setError(null);
      _showSetupError = false;
    });
    if (_pin.length == 4) unawaited(_onPinComplete());
  }

  void _onBackspace() {
    if (_pin.isEmpty) return;
    setState(() => _pin = _pin.substring(0, _pin.length - 1));
  }

  Future<void> _onPinComplete() async {
    if (_step == 0) {
      setState(() {
        if (_isTrivialPin(_pin)) {
          _setError(
            'Choisissez un PIN plus sécurisé.',
            'Évitez les suites ou répétitions simples (1234, 0000…).',
          );
        } else {
          _firstPin = _pin;
          _step = 1;
        }
        _pin = '';
      });
      return;
    }

    if (_pin != _firstPin) {
      // On recommence depuis le début : l'erreur peut venir du premier PIN.
      setState(() {
        _setError('Les deux PIN ne correspondent pas.', 'Recommencez.');
        _pin = '';
        _firstPin = '';
        _step = 0;
      });
      return;
    }

    _logger.i('PIN validation passed, calling setupPin()');
    await ref.read(authProvider.notifier).setupPin(_firstPin);
    // Succès : le routeur ouvre l'accueil. Échec : message via authProvider.
    if (mounted && ref.read(authProvider).hasError) {
      setState(() {
        _pin = '';
        _showSetupError = true;
      });
    }
  }

  /// Retour : de la confirmation à la saisie, puis de la saisie à l'étape
  /// boutique (inscription uniquement).
  void _goBack() {
    if (_step == 1) {
      setState(() {
        _step = 0;
        _pin = '';
        _firstPin = '';
        _setError(null);
      });
    } else if (_inRegistration) {
      ref.read(authProvider.notifier).returnToStoreSetup();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authValue = ref.watch(authProvider);
    if (authValue.value case AuthPinSetupRequired(
      canReturnToStoreSetup: true,
    )) {
      _inRegistration = true;
    }
    final isLoading = authValue.isLoading;
    final systemError = _showSetupError ? authValue.error?.toString() : null;
    final cs = Theme.of(context).colorScheme;
    final canGoBack = _step == 1 || _inRegistration;

    final (title, detail) = switch ((isLoading, systemError)) {
      (true, _) => ('Enregistrement du PIN…', null),
      (_, final String e) => ('Le PIN n\'a pas pu être enregistré.', e),
      _ => (_errorTitle, _errorDetail),
    };

    return PopScope(
      canPop: !canGoBack,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && !isLoading) _goBack();
      },
      child: AuthScaffold(
        scrollable: false,
        resizeToAvoidBottomInset: false,
        child: FillOrScroll(
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                height: AppSpacing.iconButtonSize,
                child: Row(
                  children: [
                    if (canGoBack)
                      IconButton(
                        onPressed: isLoading ? null : _goBack,
                        tooltip: _step == 1
                            ? 'Modifier le PIN'
                            : 'Retour à la boutique',
                        icon: const Icon(Icons.arrow_back),
                      ),
                  ],
                ),
              ),
              if (_inRegistration) ...[
                const RegistrationStepper(currentStep: 3),
                const SizedBox(height: AppSpacing.md),
              ],
              const Spacer(),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: AuthHeader(
                  key: ValueKey(_step),
                  title: _step == 0
                      ? 'Sécurisez votre caisse'
                      : 'Confirmez votre PIN',
                  subtitle: _step == 0
                      ? 'Votre PIN vous permettra de déverrouiller rapidement '
                            'l\'application sur cet appareil.'
                      : 'Saisissez à nouveau les 4 chiffres.',
                  centered: true,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                _step == 0 ? 'Créez un PIN à 4 chiffres' : 'Confirmez le PIN',
                style: AppTypography.labelMedium.copyWith(color: cs.onSurface),
              ),
              const SizedBox(height: AppSpacing.md),
              PinDots(filledCount: _pin.length),
              const SizedBox(height: AppSpacing.sm),
              PinMessage(title: title, detail: detail, isError: !isLoading),
              const Spacer(),
              PinNumpad(
                onDigit: _onDigit,
                onBackspace: _onBackspace,
                enabled: !isLoading,
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ExcludeSemantics(
                    child: Icon(
                      Icons.lock_outline,
                      size: 14,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Flexible(
                    child: Text(
                      'Le PIN est enregistré de manière sécurisée sur cet '
                      'appareil.',
                      textAlign: TextAlign.center,
                      style: AppTypography.captionText.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}
