import 'package:decimal/decimal.dart';
import 'package:drift/drift.dart' as drift;

import '../../database/app_database.dart';

/// Code de refus d'une clôture : le serveur a recalculé un solde différent de
/// celui de l'appareil et exige un commentaire qui n'a pas été envoyé. La
/// session reste ouverte côté serveur ; la clôture peut être renvoyée avec un
/// commentaire.
const cashClosingNoteRequiredCode = 'closing_note_required';

/// Code de refus d'un mouvement ou d'une clôture dont la session a vu son
/// ouverture refusée par le serveur : rien n'est envoyé.
const cashSessionOpenRejectedCode = 'session_open_rejected';

/// Reporte sur la session locale [sessionId] le résultat de la clôture
/// serveur : solde théorique figé [expected], écart [discrepancy] (laissé tel
/// quel s'il est null) et [serverRecalculated]. Le montant compté, le
/// commentaire et la date de clôture locaux ne changent pas.
///
/// Update seul : une session inconnue de l'appareil n'est jamais insérée. Les
/// montants sont normalisés par `Decimal.parse` (« 25000.00 » → « 25000 »),
/// comme ceux écrits par l'appareil.
Future<void> applyCashServerClosure(
  AppDatabase db,
  String sessionId, {
  required String expected,
  required String? discrepancy,
  required bool serverRecalculated,
}) async {
  await (db.update(
    db.cashSessions,
  )..where((s) => s.id.equals(sessionId))).write(
    CashSessionsCompanion(
      expectedAmount: drift.Value(Decimal.parse(expected).toString()),
      discrepancyAmount: discrepancy == null
          ? const drift.Value.absent()
          : drift.Value(Decimal.parse(discrepancy).toString()),
      serverRecalculated: drift.Value(serverRecalculated),
    ),
  );
}
