import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/theme_mode_provider.dart';
import '../../../../core/config.dart';
import '../../../../core/network/error_mapper.dart';
import '../../../../core/providers/connectivity_provider.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/sync/sync_orchestrator.dart';
import '../../../../core/sync/sync_providers.dart';
import '../../../../core/utils/phone_formatter.dart';
import '../../../../core/widgets/index.dart';
import '../../../auth/presentation/pages/store_setup_page.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../auth/providers/store_provider.dart';
import '../../../cash_register/presentation/cash_logout_guard.dart';
import '../../../printing/presentation/providers/printer_provider.dart';
import '../../../sales/domain/entities/payment_method_label.dart';
import '../../../sales/providers/sales_di_providers.dart';
import '../../../auth/providers/seller_profile_provider.dart';
import '../widgets/account_email_tile.dart';
import '../widgets/delete_account_sheet.dart';
import '../widgets/receipt_settings_sheet.dart';
import '../widgets/seller_name_sheet.dart';
import '../widgets/settings_section.dart';

/// Paramètres, par sections : commerce, caisse, application, compte.
class SettingsPage extends ConsumerStatefulWidget {
  /// Crée la page des paramètres.
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  // Protection contre le double tap sur les actions asynchrones.
  bool _exporting = false;

  void _showMessage(String message, {bool isError = false}) {
    final cs = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: isError ? cs.error : null,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final store = ref.watch(storeConfigProvider).value;
    final auth = ref.watch(authProvider).value;
    final phone = auth is AuthAuthenticated ? auth.user.phoneNumber : null;
    final sellerName = ref.watch(sellerProfileProvider).value;
    final storeAddress = store?.address;
    final footer = store?.receiptFooterText;

    final printer = ref.watch(printerProvider);
    return AppScaffold(
      title: 'Paramètres',
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: AppSpacing.md),
          child: OfflineStatusIndicator(),
        ),
      ],
      body: ListView(
        padding: const EdgeInsets.only(bottom: AppSpacing.xl),
        children: [
          SettingsSection(
            title: 'Commerce',
            children: [
              SettingsTile(
                icon: Icons.storefront_outlined,
                title: store == null ? 'Configurer ma boutique' : 'Mon magasin',
                subtitle: Text(
                  store == null
                      ? 'Nom et adresse du commerce'
                      : [
                          store.name,
                          if (storeAddress != null && storeAddress.isNotEmpty)
                            storeAddress,
                        ].join(' · '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                showChevron: true,
                onTap: () => Navigator.of(context).push<void>(
                  MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (_) => const StoreSetupPage(isEditMode: true),
                  ),
                ),
              ),
              if (store != null)
                SettingsTile(
                  icon: Icons.receipt_long_outlined,
                  title: 'Reçus',
                  subtitle: Text(
                    footer == null || footer.isEmpty
                        ? 'Personnaliser le pied de page'
                        : footer,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  showChevron: true,
                  onTap: () => showReceiptSettingsSheet(context, store),
                ),
            ],
          ),
          SettingsSection(
            title: 'Caisse',
            children: [
              SettingsTile(
                icon: Icons.print_outlined,
                title: 'Imprimante',
                // Ce qui demande une action est signalé, pas seulement écrit.
                subtitle: switch (printer) {
                  PrinterDisconnected(savedName: null) => const Align(
                    alignment: Alignment.centerLeft,
                    child: _ActionBadge(label: 'À configurer'),
                  ),
                  PrinterError() => const Align(
                    alignment: Alignment.centerLeft,
                    child: _ActionBadge(
                      label: 'Erreur · touchez pour vérifier',
                    ),
                  ),
                  _ => Text(_printerLabel(printer)),
                },
                showChevron: true,
                onTap: () => context.push(Routes.bluetoothSetup),
              ),
            ],
          ),
          SettingsSection(
            title: 'Application',
            children: [
              SettingsTile(
                icon: Icons.cloud_sync_outlined,
                title: 'Synchronisation',
                subtitle: Text(_syncLabel()),
                showChevron: true,
                onTap: () => context.push(Routes.syncStatus),
              ),
              const _AppearanceTile(),
              SettingsTile(
                icon: Icons.file_download_outlined,
                title: 'Exporter les ventes',
                subtitle: const Text('Fichier CSV à partager'),
                busy: _exporting,
                onTap: _exportCsv,
              ),
              SettingsTile(
                icon: Icons.help_outline,
                title: 'Revoir le tutoriel',
                subtitle: const Text('Visite guidée de l’application'),
                showChevron: true,
                onTap: () => context.push(Routes.tutorial),
              ),
              SettingsTile(
                icon: Icons.privacy_tip_outlined,
                title: 'Politique de confidentialité',
                trailing: const Icon(Icons.open_in_new, size: 18),
                onTap: () => _openUrl(AppConfig.privacyPolicyUrl),
              ),
            ],
          ),
          SettingsSection(
            title: 'Compte',
            children: [
              if (phone != null)
                SettingsTile(
                  icon: Icons.person_outline,
                  title: 'Mon compte',
                  subtitle: Text(
                    [
                      formatPhoneCiDisplay(phone),
                      sellerName == null || sellerName.isEmpty
                          ? 'Nom du vendeur à définir'
                          : 'Vendeur : $sellerName',
                    ].join(' · '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  showChevron: true,
                  onTap: () => showSellerNameSheet(context, sellerName),
                ),
              if (phone != null) const AccountEmailTile(),
              SettingsTile(
                icon: Icons.logout_outlined,
                title: 'Se déconnecter',
                destructive: true,
                onTap: _confirmLogout,
              ),
              SettingsTile(
                icon: Icons.delete_forever_outlined,
                title: 'Supprimer mon compte',
                subtitle: const Text('Compte, boutique et ventes effacés'),
                destructive: true,
                onTap: _confirmDeleteAccount,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _printerLabel(PrinterState state) => switch (state) {
    PrinterConnected(:final name) => 'Connectée : $name',
    PrinterConnecting() => 'Connexion…',
    PrinterDisconnected(savedName: final name?) => name,
    PrinterDisconnected() => 'À configurer',
    PrinterError() => 'Erreur · touchez pour vérifier',
  };

  /// État de synchro en mots simples (jamais de jargon technique).
  String _syncLabel() {
    final isOnline = ref.watch(isOnlineProvider).value ?? true;
    final status = ref.watch(syncOrchestratorProvider);
    final pending = ref.watch(pendingSyncCountProvider).value ?? 0;
    if (!isOnline) {
      return pending == 0
          ? 'Hors ligne · tout est envoyé'
          : 'Hors ligne · $pending en attente d’envoi';
    }
    return switch (status) {
      SyncStatusSyncing() => 'Envoi en cours…',
      SyncStatusError() => 'Envoi échoué · voir le détail',
      SyncStatusIdle() when pending > 0 =>
        // La file mêle ventes, retours, produits et caisse : terme neutre,
        // comme la pastille de synchro.
        pending == 1
            ? '1 modification en attente'
            : '$pending modifications en attente',
      SyncStatusIdle(lastSyncAt: final at?) =>
        'Tout est envoyé · ${DateFormat.Hm('fr_FR').format(at)}',
      SyncStatusIdle() => 'Tout est envoyé',
    };
  }

  Future<void> _confirmLogout() async {
    // Caisse ouverte ou opérations de caisse non envoyées : elles seraient
    // perdues au changement de compte.
    final blockReason = await cashLogoutBlockReason(ref);
    if (!mounted) return;
    if (blockReason != null) {
      await _showLogoutBlocked(blockReason);
      return;
    }
    final pending = ref.read(pendingSyncCountProvider).value ?? 0;
    final confirmed = await showConfirmDialog(
      context,
      title: 'Se déconnecter ?',
      // Si un autre compte se connecte ensuite, la synchro efface les données
      // locales de l'ancien compte (y compris les ventes non envoyées).
      message: pending == 0
          ? 'Vous devrez saisir votre numéro et votre mot de passe pour vous '
                'reconnecter.'
          : pending == 1
          ? '1 modification pas encore synchronisée. Synchronisez avant de '
                'vous déconnecter : si un autre compte se connecte sur ce '
                'téléphone, elle sera effacée.'
          : '$pending modifications pas encore synchronisées. Synchronisez '
                'avant de vous déconnecter : si un autre compte se connecte '
                'sur ce téléphone, elles seront effacées.',
      confirmLabel: 'Se déconnecter',
      isDangerous: true,
    );
    if (confirmed && mounted) {
      unawaited(ref.read(authProvider.notifier).logout());
    }
  }

  /// Déconnexion refusée : la règle est expliquée et l'action utile
  /// proposée (clôturer la caisse ouverte).
  Future<void> _showLogoutBlocked(String reason) async {
    final cs = Theme.of(context).colorScheme;
    final isOpen = reason == cashLogoutOpenSessionMessage;
    final closeCash = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: CircleAvatar(
          radius: 36,
          backgroundColor: cs.tertiaryContainer,
          child: Icon(
            Icons.lock_outline,
            size: 36,
            color: cs.onTertiaryContainer,
          ),
        ),
        title: Text(
          isOpen ? 'Clôturez d’abord la caisse' : 'Déconnexion impossible',
          textAlign: TextAlign.center,
        ),
        content: Text(reason, textAlign: TextAlign.center),
        actionsOverflowDirection: VerticalDirection.down,
        actionsOverflowButtonSpacing: AppSpacing.sm,
        actions: [
          if (isOpen) ...[
            PrimaryButton(
              label: 'Clôturer la caisse',
              onPressed: () => Navigator.of(context).pop(true),
            ),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Annuler'),
              ),
            ),
          ] else
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Compris'),
            ),
        ],
      ),
    );
    if ((closeCash ?? false) && mounted) {
      unawaited(context.push(Routes.cashClose));
    }
  }

  Future<void> _confirmDeleteAccount() async {
    if (!(ref.read(isOnlineProvider).value ?? false)) {
      _showMessage('Connexion requise pour supprimer votre compte.');
      return;
    }
    final pending = ref.read(pendingSyncCountProvider).value ?? 0;
    final confirmed = await showConfirmDialog(
      context,
      title: 'Supprimer votre compte ?',
      message:
          'Votre compte, votre boutique, votre catalogue et tout l’historique '
          'des ventes et retours seront effacés définitivement, sur ce '
          'téléphone et sur le serveur.'
          '${pending > 0 ? ' Les modifications non synchronisées seront perdues.' : ''}'
          ' Pensez à exporter vos ventes avant.',
      confirmLabel: 'Continuer',
      isDangerous: true,
    );
    if (confirmed && mounted) await showDeleteAccountSheet(context);
  }

  Future<void> _openUrl(String url) async {
    final opened = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
    if (!opened && mounted) _showMessage('Impossible d’ouvrir la page.');
  }

  Future<void> _exportCsv() async {
    setState(() => _exporting = true);
    try {
      final dir = await getTemporaryDirectory();
      final filename =
          'ventes_${DateFormat('yyyyMMdd').format(DateTime.now())}.csv';
      final file = File('${dir.path}/$filename');
      final sink = file.openWrite();

      sink.writeln('Date,Reçu N°,Total (FCFA),TVA (FCFA),Mode de paiement');

      // Pagination par tranches de 200 pour éviter de saturer la mémoire sur
      // les appareils d'entrée de gamme.
      const chunkSize = 200;
      String? cursor;
      while (true) {
        final chunk = await ref
            .read(salesRepositoryProvider)
            .getSales(limit: chunkSize, cursor: cursor);

        for (final sale in chunk) {
          sink.writeln(
            [
              sale.createdAt.toIso8601String(),
              sale.receiptNumber,
              sale.totalAmount,
              sale.vatAmount,
              sale.paymentMethod.label,
            ].join(','),
          );
        }

        if (chunk.length < chunkSize) break;
        cursor = chunk.last.createdAt.toIso8601String();
      }

      await sink.close();

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path, mimeType: 'text/csv')],
          subject: 'Export ventes POS',
        ),
      );
    } catch (e) {
      if (mounted) {
        _showMessage('Export impossible : ${errorToFrench(e)}', isError: true);
      }
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }
}

/// Badge d'action attendue (« À configurer »).
class _ActionBadge extends StatelessWidget {
  const _ActionBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(top: 2),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: cs.tertiaryContainer,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Text(
        label,
        style: AppTypography.labelMedium.copyWith(
          color: cs.onTertiaryContainer,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// Apparence en toutes lettres : Clair, Système, Sombre.
class _AppearanceTile extends ConsumerWidget {
  const _AppearanceTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm + 4,
        AppSpacing.md,
        AppSpacing.sm + 4,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.palette_outlined, color: cs.onSurfaceVariant),
              const SizedBox(width: AppSpacing.md),
              Text('Apparence', style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          SegmentedButton<ThemeMode>(
            segments: const [
              ButtonSegment(value: ThemeMode.light, label: Text('Clair')),
              ButtonSegment(value: ThemeMode.system, label: Text('Système')),
              ButtonSegment(value: ThemeMode.dark, label: Text('Sombre')),
            ],
            selected: {ref.watch(themeModeProvider)},
            onSelectionChanged: (modes) =>
                ref.read(themeModeProvider.notifier).setMode(modes.first),
            showSelectedIcon: false,
          ),
        ],
      ),
    );
  }
}
