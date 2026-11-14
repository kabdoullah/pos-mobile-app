import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../../../sales/presentation/widgets/amount_input.dart';
import '../../domain/entities/cash_count.dart';
import '../../domain/entities/denomination.dart';
import '../../domain/repositories/cash_register_repository.dart';
import '../cash_register_messages.dart';
import '../providers/cash_register_providers.dart';
import '../widgets/cash_count_form.dart';

/// Ouvre l'écran « Ouvrir la caisse » par-dessus la navigation. Renvoie
/// `true` si une session a été ouverte.
///
/// [title] et [message] remplacent l'en-tête quand l'ouverture interrompt
/// une action (encaisser, rembourser) : on dit pourquoi la caisse est
/// demandée et que rien n'a été enregistré.
Future<bool> showOpenCashSession(
  BuildContext context, {
  String? title,
  String? message,
}) async {
  final opened = await Navigator.of(context, rootNavigator: true).push<bool>(
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => OpenCashSessionPage(title: title, message: message),
    ),
  );
  return opened ?? false;
}

/// Ouverture de caisse : comptage billets et pièces (le fond de caisse est
/// leur somme) ou total seulement, selon le mode mémorisé, puis commentaire
/// facultatif.
class OpenCashSessionPage extends ConsumerStatefulWidget {
  /// Crée l'écran d'ouverture.
  const OpenCashSessionPage({this.title, this.message, super.key});

  /// Titre contextuel, « Ouvrir la caisse » par défaut.
  final String? title;

  /// Explication contextuelle, consigne de comptage par défaut.
  final String? message;

  @override
  ConsumerState<OpenCashSessionPage> createState() =>
      _OpenCashSessionPageState();
}

class _OpenCashSessionPageState extends ConsumerState<OpenCashSessionPage> {
  final _noteController = TextEditingController();
  CashCount _count = CashCount.empty();
  Decimal? _amount;
  String? _amountError;
  String? _noteError;
  String? _formError;
  bool _isLoading = false;

  /// Champ commentaire affiché (replié par défaut : facultatif).
  bool _showNote = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit(bool byDenomination) async {
    final amount = byDenomination ? _count.total : _amount;
    if (amount == null) {
      setState(() => _amountError = 'Saisissez le fond de caisse.');
      return;
    }
    setState(() {
      _amountError = null;
      _noteError = null;
      _formError = null;
      _isLoading = true;
    });
    try {
      await ref
          .read(cashRegisterControllerProvider.notifier)
          .open(
            openingAmount: amount,
            count: byDenomination ? _count : null,
            note: _noteController.text,
          );
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      // Erreur de saisie sous son champ ; refus (caisse déjà ouverte, réseau)
      // au-dessus du bouton.
      final message = cashRegisterErrorMessage(e);
      final code = e is CashRegisterException ? e.code : null;
      setState(() {
        switch (code) {
          case CashRegisterException.invalidAmount when !byDenomination:
            _amountError = message;
          case CashRegisterException.noteTooLong:
            _noteError = message;
          default:
            _formError = message;
        }
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _setAmount(Decimal? value) => setState(() {
    _amount = value;
    _amountError = null;
  });

  /// « Samedi 14 novembre · matin » : jour du comptage et moment.
  static String _countMoment(DateTime now) {
    final day = DateFormat('EEEE d MMMM', 'fr_FR').format(now);
    final moment = now.hour < 12
        ? 'matin'
        : now.hour < 18
        ? 'après-midi'
        : 'soir';
    return '${day[0].toUpperCase()}${day.substring(1)} · $moment';
  }

  /// Comptage de la dernière clôture ramené aux coupures proposées.
  static CashCount _resumable(CashCount last) {
    var count = CashCount.empty();
    for (final d in fcfaDenominations) {
      count = count.withQuantity(d, last.quantityOf(d));
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final byDenomination =
        ref.watch(cashCountByDenominationProvider).value ?? true;
    final formError = _formError;
    final amount = byDenomination ? _count.total : _amount;
    final lastCount = ref.watch(lastClosingCountProvider).value;
    final resumable = lastCount == null ? null : _resumable(lastCount);
    // « Comme hier soir » (mode total) : le montant compté à la dernière
    // clôture.
    final lastCounted = lastClosedSession(
      ref.watch(localCashSessionHistoryProvider).value,
    )?.countedAmount;
    final breakdown = countBreakdown(_count);

    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        title: Text(widget.title ?? 'Ouvrir la caisse'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: AppSpacing.lg),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    AppSpacing.xs,
                    AppSpacing.md,
                    AppSpacing.md,
                  ),
                  // Raison de l'ouverture si elle interrompt une action,
                  // sinon le moment du comptage (« Samedi 14 novembre ·
                  // matin »).
                  child: Text(
                    widget.message ?? _countMoment(DateTime.now()),
                    style: widget.message == null
                        ? AppTypography.meta.copyWith(
                            fontSize: 15,
                            color: colors.textSecondary,
                          )
                        : AppTypography.body.copyWith(
                            color: colors.textSecondary,
                          ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  child: CashCountModeSelector(
                    byDenomination: byDenomination,
                    onChanged: (value) => ref
                        .read(cashCountByDenominationProvider.notifier)
                        .set(value),
                  ),
                ),
                if (byDenomination) ...[
                  if (resumable != null &&
                      resumable.total > Decimal.zero &&
                      resumable != _count)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.sm,
                        AppSpacing.sm,
                        AppSpacing.md,
                        0,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: () => setState(() => _count = resumable),
                          icon: const Icon(Icons.history, size: 20),
                          label: Text(
                            'Reprendre le dernier comptage · '
                            '${formatFcfa(resumable.total)}',
                          ),
                        ),
                      ),
                    ),
                  CashCountForm(
                    count: _count,
                    onChanged: (count) => setState(() => _count = count),
                  ),
                ] else
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      AppSpacing.md,
                      AppSpacing.md,
                      0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AmountInput(
                          label: 'Fond de caisse',
                          hint: '0',
                          value: _amount,
                          errorText: _amountError,
                          large: true,
                          onChanged: _setAmount,
                        ),
                        const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
                        Wrap(
                          spacing: AppSpacing.sm,
                          runSpacing: AppSpacing.sm,
                          children: [
                            if (lastCounted != null &&
                                lastCounted > Decimal.zero)
                              QuickChoiceButton(
                                label:
                                    'Comme à la dernière clôture · '
                                    '${formatAmount(lastCounted)}',
                                isSelected: _amount == lastCounted,
                                onTap: () => _setAmount(lastCounted),
                              ),
                            QuickChoiceButton(
                              label: '0',
                              isSelected: _amount == Decimal.zero,
                              onTap: () => _setAmount(Decimal.zero),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Le mode choisi est gardé pour la prochaine '
                          'ouverture ou clôture.',
                          style: AppTypography.meta.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    AppSpacing.md,
                    AppSpacing.md,
                    0,
                  ),
                  child: _showNote
                      ? AppTextField(
                          label: 'Commentaire (facultatif)',
                          controller: _noteController,
                          errorText: _noteError,
                          maxLines: 2,
                          maxLength: CashRegisterException.maxNoteLength,
                        )
                      : Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            onPressed: () => setState(() => _showNote = true),
                            icon: const Icon(Icons.add, size: 20),
                            label: const Text('Ajouter un commentaire'),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: AppSpacing.sm,
                              ),
                            ),
                          ),
                        ),
                ),
                if (formError != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      AppSpacing.sm,
                      AppSpacing.md,
                      0,
                    ),
                    child: Text(
                      formError,
                      style: AppTypography.errorText.copyWith(
                        color: colors.error,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          CashCountTotalBar(
            showTotal: byDenomination,
            label: byDenomination && breakdown.isNotEmpty
                ? 'Fond de caisse · $breakdown'
                : 'Fond de caisse',
            amount: amount,
            action: PrimaryButton(
              label: amount == null
                  ? 'Ouvrir la caisse'
                  : 'Ouvrir avec ${formatFcfa(amount)}',
              isLoading: _isLoading,
              onPressed: _isLoading ? null : () => _submit(byDenomination),
            ),
          ),
        ],
      ),
    );
  }
}
