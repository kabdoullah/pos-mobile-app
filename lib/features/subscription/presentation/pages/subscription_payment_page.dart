import 'dart:io';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/utils/phone_formatter.dart';
import '../../../../core/widgets/index.dart';
import '../../domain/entities/subscription.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../providers/subscription_providers.dart';

final _day = DateFormat('EEEE d MMMM', 'fr_FR');

/// Paiement d'une formule par Wave, en quatre temps : combien, à quel
/// numéro, comment, puis la demande de validation (ADR-0017).
///
/// Aucun paiement automatique : le commerçant envoie l'argent depuis son
/// application Wave, puis l'équipe vérifie avant d'activer la formule.
class SubscriptionPaymentPage extends ConsumerStatefulWidget {
  /// Crée la page pour la formule [plan].
  const SubscriptionPaymentPage({required this.plan, super.key});

  /// Formule à payer.
  final PlanId plan;

  @override
  ConsumerState<SubscriptionPaymentPage> createState() =>
      _SubscriptionPaymentPageState();
}

class _SubscriptionPaymentPageState
    extends ConsumerState<SubscriptionPaymentPage> {
  final _phone = TextEditingController();
  final _reference = TextEditingController();
  late DateTime _paidOn = clock.now();
  File? _proof;
  String? _phoneError;
  bool _sent = false;

  @override
  void initState() {
    super.initState();
    // Un envoi précédent (succès ou erreur) ne doit pas s'afficher ici.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) ref.read(paymentRequestSubmissionProvider.notifier).reset();
    });
  }

  @override
  void dispose() {
    _phone.dispose();
    _reference.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = clock.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _paidOn,
      firstDate: now.subtract(const Duration(days: 31)),
      lastDate: now,
    );
    if (picked != null) setState(() => _paidOn = picked);
  }

  Future<void> _pickProof() async {
    final choice = await showImageSourceSheet(
      context,
      title: 'Capture du paiement Wave',
      canRemove: _proof != null,
    );
    if (!mounted || choice == null) return;
    setState(() => _proof = choice is File ? choice : null);
  }

  Future<void> _submit(PlanOffer offer) async {
    final phone = isValidMobilePhoneCi(_phone.text)
        ? toE164Ci(_phone.text)
        : null;
    if (phone == null) {
      setState(
        () => _phoneError =
            'Numéro Wave à 10 chiffres, commençant par 01, 05 ou 07.',
      );
      return;
    }
    setState(() => _phoneError = null);
    final reference = _reference.text.trim();
    final ok = await ref
        .read(paymentRequestSubmissionProvider.notifier)
        .submit(
          PaymentRequestDraft(
            plan: offer.plan,
            amountFcfa: offer.price.toBigInt().toInt(),
            senderPhone: phone,
            paidOn: _paidOn,
            waveReference: reference.isEmpty ? null : reference,
            proofPath: _proof?.path,
          ),
        );
    if (ok && mounted) setState(() => _sent = true);
  }

  @override
  Widget build(BuildContext context) {
    final catalog = ref.watch(subscriptionCatalogProvider);
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text('Payer ${widget.plan.label}'),
      ),
      body: switch (catalog) {
        AsyncData(:final value) => _content(value),
        AsyncError(:final error) => Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Text(subscriptionErrorMessage(error)),
        ),
        _ => const Center(child: AppLoadingIndicator()),
      },
    );
  }

  Widget _content(SubscriptionCatalog catalog) {
    final offer = catalog.offer(widget.plan);
    final receiver = catalog.payment.receiverPhone;
    if (offer == null || receiver == null || !catalog.payment.available) {
      return const Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Text('La souscription par Wave n’est pas encore ouverte.'),
      );
    }
    if (_sent) return _SentView(offer: offer);

    final colors = AppColors.of(context);
    final submission = ref.watch(paymentRequestSubmissionProvider);
    final meta = AppTypography.body.copyWith(color: colors.textSecondary);
    final error = submission.error;
    final steps = [
      'Ouvrez votre application Wave.',
      'Choisissez « Envoyer » et saisissez le numéro ci-dessus.',
      'Envoyez exactement ${formatFcfa(offer.price)}.',
      'Notez la référence de la transaction et faites une capture '
          'd’écran du reçu.',
      'Revenez ici et envoyez votre demande ci-dessous.',
    ];

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        // 1. Combien payer.
        AppCard(
          elevated: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Montant à envoyer', style: meta),
              AmountDisplay(amount: offer.price, size: AmountSize.hero),
              Text(
                'Formule ${offer.name} · ${offer.durationMonths} mois',
                style: AppTypography.body,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        // 2. À quel numéro.
        const OverlineHeader('Numéro Wave de Ma Caisse'),
        const SizedBox(height: AppSpacing.sm),
        _ReceiverRow(phone: receiver, name: catalog.payment.receiverName),
        const SizedBox(height: AppSpacing.lg),
        // 3. Comment payer.
        const OverlineHeader('Comment payer'),
        const SizedBox(height: AppSpacing.sm),
        for (final (index, step) in steps.indexed)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: Text('${index + 1}. $step', style: AppTypography.body),
          ),
        const SizedBox(height: AppSpacing.lg),
        // 4. Demande de validation.
        const OverlineHeader('Votre demande de validation'),
        const SizedBox(height: AppSpacing.sm),
        AppTextField(
          label: 'Numéro Wave utilisé pour payer',
          hint: '07 00 00 00 00',
          controller: _phone,
          keyboardType: TextInputType.phone,
          errorText: _phoneError,
          // 10 chiffres, espaces de lecture compris (« 07 00 00 00 00 »).
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp('[0-9 ]')),
            LengthLimitingTextInputFormatter(14),
          ],
          onChanged: (_) {
            if (_phoneError != null) setState(() => _phoneError = null);
          },
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'Référence de la transaction (facultatif)',
          controller: _reference,
          maxLength: 64,
          textCapitalization: TextCapitalization.characters,
        ),
        const SizedBox(height: AppSpacing.sm),
        DefinitionRow(label: 'Date du paiement', value: _day.format(_paidOn)),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: _pickDate,
            child: const Text('Changer la date'),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                _proof == null
                    ? 'Capture du reçu Wave (facultatif)'
                    : 'Capture ajoutée',
                style: AppTypography.body,
              ),
            ),
            TextButton(
              onPressed: _pickProof,
              child: Text(_proof == null ? 'Ajouter' : 'Changer'),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Votre formule sera activée après vérification du paiement par '
          'notre équipe. Vous verrez la confirmation dans « Mon abonnement ».',
          style: meta,
        ),
        if (error != null) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            subscriptionErrorMessage(error),
            style: AppTypography.body.copyWith(color: colors.error),
          ),
        ],
        const SizedBox(height: AppSpacing.md),
        PrimaryButton(
          label: 'Envoyer ma demande',
          isLoading: submission.isLoading,
          loadingLabel: 'Envoi…',
          onPressed: submission.isLoading ? null : () => _submit(offer),
        ),
      ],
    );
  }
}

class _ReceiverRow extends StatelessWidget {
  const _ReceiverRow({required this.phone, this.name});

  final String phone;
  final String? name;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final name = this.name;
    final display = phone.startsWith('+225')
        ? formatPhoneCiDisplay(phone)
        : phone;
    return AppCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(display, style: AppTypography.figureSmall),
                if (name != null)
                  Text(
                    name,
                    style: AppTypography.body.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: display));
              if (!context.mounted) return;
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Numéro copié')));
            },
            icon: const Icon(Icons.copy, size: 18),
            label: const Text('Copier'),
          ),
        ],
      ),
    );
  }
}

class _SentView extends StatelessWidget {
  const _SentView({required this.offer});

  final PlanOffer offer;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpacing.xl),
          Icon(Icons.hourglass_top, size: 48, color: colors.warning),
          const SizedBox(height: AppSpacing.md),
          const Text(
            'Demande envoyée',
            style: AppTypography.screenTitle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Nous vérifions votre paiement de ${formatFcfa(offer.price)}. '
            'La formule ${offer.name} sera activée dès la vérification. '
            'Vous pouvez continuer à vendre normalement.',
            style: AppTypography.body.copyWith(color: colors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton(
            label: 'Terminé',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
