import 'package:intl/intl.dart';

/// Vrai si la caisse ouverte à [openedAt] l'a été avant [today] (minuit
/// local) : elle n'a pas été clôturée la veille.
bool isOpenedBeforeToday(DateTime openedAt, DateTime today) =>
    openedAt.toLocal().isBefore(today);

/// « depuis 14:29 » le jour même, « depuis hier 14:29 » la veille,
/// « depuis le 24 nov. 14:29 » avant. Sans la date, une caisse oubliée la
/// veille se lit comme ouverte dans la journée.
String sessionOpenedSinceLabel(DateTime openedAt, DateTime today) {
  final local = openedAt.toLocal();
  final time = DateFormat.Hm('fr_FR').format(local);
  if (!local.isBefore(today)) return 'depuis $time';
  final yesterday = DateTime(today.year, today.month, today.day - 1);
  if (!local.isBefore(yesterday)) return 'depuis hier $time';
  return 'depuis le ${DateFormat('d MMM', 'fr_FR').format(local)} $time';
}
