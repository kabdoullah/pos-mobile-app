import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../../domain/repositories/printer_repository.dart';
import '../../providers/printing_di_providers.dart';
import '../providers/printer_provider.dart';

/// Page d'appairage et de connexion à une imprimante thermique Bluetooth.
///
/// La page explique que les imprimantes doivent d'abord être appairées dans les
/// paramètres système Android, puis liste les appareils appairés pour les
/// sélectionner et s'y connecter.
class BluetoothSetupPage extends ConsumerStatefulWidget {
  /// Crée une [BluetoothSetupPage].
  const BluetoothSetupPage({super.key});

  @override
  ConsumerState<BluetoothSetupPage> createState() => _BluetoothSetupPageState();
}

class _BluetoothSetupPageState extends ConsumerState<BluetoothSetupPage> {
  bool _hasPermission = false;
  bool _checkingPermission = true;
  List<BluetoothInfo> _pairedDevices = [];
  bool _isLoading = false;
  // ✨ track quel MAC est en cours de connexion — évite le spinner global sur tous les devices
  String? _connectingMac;

  /// Dernier appareil dont la connexion a échoué (raison et « Réessayer »
  /// affichées sur sa ligne).
  String? _failedMac;
  bool _testing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkPermissions());
  }

  // BLUETOOTH_CONNECT n'existe que sur Android 12+ : sur iOS, permission_handler
  // la renvoie « refusée définitivement » sans jamais afficher la demande
  // système. iOS passe par l'autorisation CoreBluetooth.
  Permission get _bluetoothPermission =>
      Platform.isIOS ? Permission.bluetooth : Permission.bluetoothConnect;

  Future<void> _checkPermissions() async {
    final status = await _bluetoothPermission.status;
    final hasPermission = status.isGranted;

    if (mounted) {
      setState(() {
        _hasPermission = hasPermission;
        _checkingPermission = false;
      });
    }

    if (hasPermission) {
      await _loadDevices();
    }
  }

  Future<void> _requestPermission() async {
    final result = await _bluetoothPermission.request();
    if (result.isGranted) {
      if (mounted) setState(() => _hasPermission = true);
      await _loadDevices();
    } else if (result.isDenied) {
      if (mounted) setState(() => _checkingPermission = false);
    } else if (result.isPermanentlyDenied) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Permission refusée. Ouvre les paramètres de l\'app.',
            ),
            duration: Duration(seconds: 3),
          ),
        );
        await AppSettings.openAppSettings();
      }
    }
  }

  Future<void> _loadDevices() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);
    try {
      // Note : BluetoothInfo.macAdress contient une faute de frappe (un seul «
      // d ») dans print_bluetooth_thermal v1.2.x
      final devices = await ref
          .read(printerRepositoryProvider)
          .getPairedDevices();
      if (mounted) setState(() => _pairedDevices = devices);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Impossible de lister les imprimantes. Vérifiez que le '
              'Bluetooth est activé.',
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _connectToDevice(BluetoothInfo device) async {
    if (ref.read(printerProvider) is PrinterConnecting) return;

    // ✨ mémoriser le MAC pour afficher le spinner uniquement sur cette carte
    setState(() {
      _connectingMac = device.macAdress;
      _failedMac = null;
    });

    // Note : BluetoothInfo.macAdress (un seul « d »)
    await ref
        .read(printerProvider.notifier)
        .connect(device.macAdress, device.name);

    if (!mounted) return;
    setState(() => _connectingMac = null);

    final newState = ref.read(printerProvider);
    if (newState is PrinterConnected) {
      // On reste sur l'écran : « Imprimer un test » est juste là.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Imprimante connectée'),
          duration: Duration(seconds: 2),
        ),
      );
    } else if (newState is PrinterError) {
      setState(() => _failedMac = device.macAdress);
    }
  }

  Future<void> _printTest() async {
    setState(() => _testing = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(printerProvider.notifier).printTest();
      messenger.showSnackBar(
        const SnackBar(content: Text('Ticket de test imprimé')),
      );
    } on PrintException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.userMessage)));
    } finally {
      if (mounted) setState(() => _testing = false);
    }
  }

  Future<void> _forget(String name) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Oublier $name ?',
      message:
          'Vous devrez choisir à nouveau une imprimante pour imprimer vos '
          'reçus.',
      confirmLabel: 'Oublier',
      isDangerous: true,
    );
    if (!confirmed || !mounted) return;
    await ref.read(printerProvider.notifier).forget();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final printerState = ref.watch(printerProvider);
    final (savedMac, savedName) = switch (printerState) {
      PrinterConnected(:final mac, :final name) => (mac, name),
      PrinterDisconnected(:final savedMac, :final savedName) => (
        savedMac,
        savedName,
      ),
      PrinterError(:final savedMac) => (savedMac, null),
      PrinterConnecting() => (null, null),
    };
    final savedListed = _pairedDevices.any((d) => d.macAdress == savedMac);
    final canRefresh = !_checkingPermission && _hasPermission;
    final meta = AppTypography.body.copyWith(color: colors.textSecondary);

    final List<Widget> content;
    if (_checkingPermission) {
      content = const [
        SizedBox(height: AppSpacing.xl),
        Center(child: AppLoadingIndicator()),
      ];
    } else if (!_hasPermission) {
      content = [
        _Message(
          title: 'Accès Bluetooth refusé',
          message:
              'Ma Caisse a besoin du Bluetooth pour parler à '
              'l’imprimante.',
          actionLabel: 'Autoriser le Bluetooth',
          onAction: _requestPermission,
        ),
      ];
    } else if (_pairedDevices.isEmpty && savedName == null) {
      content = [
        _Message(
          title: 'Aucune imprimante appairée',
          message: Platform.isIOS
              ? 'Allumez l’imprimante Bluetooth et placez-la près du '
                    'téléphone, puis actualisez.'
              : 'Allumez l’imprimante, puis appairez-la dans les réglages '
                    'Bluetooth du téléphone. Revenez ensuite ici.',
          actionLabel: 'Ouvrir les réglages Bluetooth',
          onAction: () =>
              AppSettings.openAppSettings(type: AppSettingsType.bluetooth),
          secondaryLabel: 'Actualiser',
          onSecondary: _loadDevices,
        ),
      ];
    } else {
      content = [
        if (_isLoading) const LinearProgressIndicator(minHeight: 2),
        const OverlineHeader('Imprimantes appairées au téléphone'),
        FlatList(
          children: [
            // Imprimante enregistrée mais absente de la liste (iOS, appairage
            // retiré) : on peut encore la tester ou l'oublier.
            if (savedName != null && !savedListed)
              _PrinterRow(
                name: savedName,
                status: const StatusIndicator(
                  label: 'Enregistrée',
                  tone: StatusTone.neutral,
                ),
                actions: [_testButton(), _forgetButton(savedName)],
              ),
            for (final device in _pairedDevices)
              _deviceRow(device, printerState, savedMac),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.md,
            0,
          ),
          child: Text(
            'Une nouvelle imprimante doit d’abord être appairée dans les '
            'réglages Bluetooth du téléphone.',
            style: meta,
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: TextButton(
              onPressed: () =>
                  AppSettings.openAppSettings(type: AppSettingsType.bluetooth),
              child: const Text('Ouvrir les réglages Bluetooth'),
            ),
          ),
        ),
      ];
    }

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Imprimante'),
        actions: [
          if (canRefresh)
            TextButton(
              onPressed: _isLoading ? null : _loadDevices,
              child: const Text('Actualiser'),
            ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: AppSpacing.lg),
        children: content,
      ),
    );
  }

  Widget _deviceRow(
    BluetoothInfo device,
    PrinterState printerState,
    String? savedMac,
  ) {
    final mac = device.macAdress;
    final isConnected =
        printerState is PrinterConnected && printerState.mac == mac;
    final isConnecting = _connectingMac == mac;
    final anyConnecting = printerState is PrinterConnecting;
    final failed = _failedMac == mac;
    final colors = AppColors.of(context);

    final Widget status;
    if (isConnected) {
      status = const StatusIndicator(
        label: 'Connectée',
        tone: StatusTone.success,
      );
    } else if (failed) {
      status = const StatusIndicator(
        label: 'Connexion échouée',
        tone: StatusTone.error,
      );
    } else {
      status = Text(
        mac == savedMac
            ? 'Enregistrée · non connectée'
            : 'Appairée · non connectée',
        style: AppTypography.bodySmall.copyWith(color: colors.textSecondary),
      );
    }

    return _PrinterRow(
      name: device.name,
      status: status,
      hint: failed
          ? 'Vérifiez qu’elle est allumée, chargée et à moins de quelques '
                'mètres.'
          : null,
      actions: isConnected
          ? [_testButton(), _forgetButton(device.name)]
          : [
              SecondaryButton(
                label: failed ? 'Réessayer' : 'Connecter',
                isLoading: isConnecting,
                onPressed: anyConnecting
                    ? null
                    : () => _connectToDevice(device),
              ),
              if (mac == savedMac) _forgetButton(device.name),
            ],
    );
  }

  Widget _testButton() => SecondaryButton(
    label: 'Imprimer un test',
    isLoading: _testing,
    onPressed: _testing ? null : _printTest,
  );

  Widget _forgetButton(String name) => TextButton(
    onPressed: _testing ? null : () => _forget(name),
    child: const Text('Oublier'),
  );
}

/// Ligne d'une imprimante : nom, état, conseil éventuel, actions.
class _PrinterRow extends StatelessWidget {
  const _PrinterRow({
    required this.name,
    required this.status,
    required this.actions,
    this.hint,
  });

  final String name;
  final Widget status;
  final List<Widget> actions;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final hint = this.hint;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(name, style: AppTypography.bodyStrong),
          const SizedBox(height: 2),
          status,
          if (hint != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              hint,
              style: AppTypography.bodySmall.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              for (final (i, action) in actions.indexed) ...[
                if (i > 0) const SizedBox(width: AppSpacing.sm),
                if (action is TextButton) action else Expanded(child: action),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// État sans liste (permission, aucune imprimante) : titre, explication,
/// action principale et action secondaire éventuelle.
class _Message extends StatelessWidget {
  const _Message({
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
    this.secondaryLabel,
    this.onSecondary,
  });

  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final secondaryLabel = this.secondaryLabel;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.xl,
        AppSpacing.md,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: AppTypography.bodyStrong.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            message,
            style: AppTypography.body.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.md),
          PrimaryButton(label: actionLabel, onPressed: onAction),
          if (secondaryLabel != null)
            TextButton(onPressed: onSecondary, child: Text(secondaryLabel)),
        ],
      ),
    );
  }
}
