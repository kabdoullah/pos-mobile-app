import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/error_mapper.dart';
import '../../../core/router/app_router.dart';
import '../../printing/domain/repositories/printer_repository.dart';
import '../../printing/presentation/providers/printer_provider.dart';
import '../../sales/domain/entities/sale.dart';
import '../domain/entities/returnable_line.dart';
import '../domain/entities/sale_return.dart';

/// Imprime le reçu d'un retour et signale le résultat (mêmes cas d'échec que
/// le reçu de vente : imprimante non configurée, injoignable, envoi raté).
Future<void> printReturnReceipt(
  BuildContext context,
  WidgetRef ref, {
  required Sale sale,
  required SaleReturn saleReturn,
  required List<ReturnableLine> lines,
}) async {
  final names = {for (final l in lines) l.saleItemId: l.productName};
  final messenger = ScaffoldMessenger.of(context);
  final errorColor = Theme.of(context).colorScheme.error;
  try {
    await ref
        .read(printerProvider.notifier)
        .printReturn(
          sale: sale,
          saleReturn: saleReturn,
          lines: [
            for (final line in saleReturn.lines)
              (
                productName: names[line.saleItemId] ?? 'Article',
                quantity: line.quantity,
                refundAmount: line.refundAmount,
              ),
          ],
        );
    messenger.showSnackBar(
      const SnackBar(
        content: Text('Reçu de retour imprimé'),
        duration: Duration(seconds: 2),
      ),
    );
  } on PrintException catch (e) {
    if (e.reason == PrintFailureReason.noPrinterConfigured) {
      messenger.showSnackBar(
        SnackBar(
          content: const Text('Aucune imprimante configurée'),
          action: SnackBarAction(
            label: 'Configurer',
            onPressed: () {
              if (context.mounted) {
                unawaited(context.push(Routes.bluetoothSetup));
              }
            },
          ),
        ),
      );
    } else {
      messenger.showSnackBar(
        SnackBar(content: Text(e.userMessage), backgroundColor: errorColor),
      );
    }
  } catch (e) {
    messenger.showSnackBar(
      SnackBar(content: Text(errorToFrench(e)), backgroundColor: errorColor),
    );
  }
}
