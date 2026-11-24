import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/utils/phone_formatter.dart';
import '../../../../core/utils/whatsapp_link.dart';
import '../../../../core/widgets/index.dart';
import '../../../auth/providers/seller_profile_provider.dart';
import '../../../auth/providers/store_provider.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/sale.dart';
import '../receipt_text.dart';

/// Ouvre une application externe ; `false` si aucune ne sait ouvrir [uri].
typedef ExternalLauncher = Future<bool> Function(Uri uri);

Future<bool> _launchExternal(Uri uri) async {
  try {
    return await launchUrl(uri, mode: LaunchMode.externalApplication);
  } on Exception {
    return false;
  }
}

/// Ouvre la feuille d'envoi du reçu de [sale] par WhatsApp.
Future<void> showWhatsAppReceiptSheet(
  BuildContext context, {
  required Sale sale,
  List<CartItem>? items,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => WhatsAppReceiptSheet(sale: sale, items: items),
  );
}

/// Envoi du reçu en texte par WhatsApp. Fonctionne hors ligne et avant la
/// synchronisation (reçu provisoire) : WhatsApp garde le message en attente.
///
/// Numéro du client facultatif : rempli, WhatsApp s'ouvre sur ce numéro (le
/// client n'a pas besoin d'être dans les contacts) ; vide, WhatsApp propose
/// de choisir le contact.
class WhatsAppReceiptSheet extends ConsumerStatefulWidget {
  /// Crée la feuille ; [launcher] est remplaçable en test.
  const WhatsAppReceiptSheet({
    required this.sale,
    this.items,
    this.launcher = _launchExternal,
    super.key,
  });

  /// Vente dont le reçu est envoyé.
  final Sale sale;

  /// Articles vendus ; null s'ils ne sont pas disponibles.
  final List<CartItem>? items;

  /// Ouvre le lien WhatsApp.
  final ExternalLauncher launcher;

  @override
  ConsumerState<WhatsAppReceiptSheet> createState() =>
      _WhatsAppReceiptSheetState();
}

class _WhatsAppReceiptSheetState extends ConsumerState<WhatsAppReceiptSheet> {
  final _phoneController = TextEditingController();
  String? _phoneError;
  String? _error;
  bool _opening = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final phone = _phoneController.text.trim();
    // Seuls les mobiles (01, 05, 07) ont WhatsApp.
    if (phone.isNotEmpty && !isValidMobilePhoneCi(phone)) {
      setState(
        () => _phoneError = 'Numéro mobile invalide (ex. 07 00 00 00 00).',
      );
      return;
    }
    setState(() {
      _phoneError = null;
      _error = null;
      _opening = true;
    });

    final store = await ref.read(storeConfigProvider.future);
    String? sellerName;
    try {
      sellerName = await ref.read(sellerProfileProvider.future);
    } on Exception {
      // Nom du vendeur inconnu : ligne absente du reçu.
    }
    if (store == null) {
      _fail('Boutique non configurée : reçu indisponible.');
      return;
    }

    final text = buildReceiptText(
      store: store,
      sale: widget.sale,
      items: widget.items,
      sellerName: sellerName,
    );
    final e164 = phone.isEmpty ? null : toE164Ci(phone);
    final webUri = e164 == null
        ? whatsAppShareUri(text)
        : whatsAppUri(e164, text: text)!;

    // L'application d'abord (pas de choix « Ouvrir avec »), wa.me en secours.
    final opened =
        await widget.launcher(whatsAppAppUri(text, phone: e164)) ||
        await widget.launcher(webUri);
    if (!mounted) return;
    if (opened) {
      Navigator.of(context).pop();
    } else {
      _fail('Impossible d’ouvrir WhatsApp sur ce téléphone.');
    }
  }

  void _fail(String message) {
    if (!mounted) return;
    setState(() {
      _opening = false;
      _error = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final error = _error;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Envoyer le reçu par WhatsApp',
                style: AppTypography.sectionTitle,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Laissez vide pour choisir le contact dans WhatsApp.',
                style: AppTypography.bodySmall.copyWith(
                  color: colors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Numéro du client',
                hint: '07 00 00 00 00',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: const [SpacedPhoneFormatter()],
                errorText: _phoneError,
                prefixIcon: Icons.phone_outlined,
                textInputAction: TextInputAction.send,
                autofocus: true,
                onSubmitted: (_) => _send(),
              ),
              if (error != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  error,
                  style: AppTypography.meta.copyWith(color: colors.error),
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              PrimaryButton(
                label: 'Ouvrir WhatsApp',
                height: AppSpacing.buttonHeight,
                isLoading: _opening,
                loadingLabel: 'Ouverture…',
                onPressed: _opening ? null : _send,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
