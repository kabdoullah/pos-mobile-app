/// Environnement de déploiement de l'application.
enum AppFlavor {
  /// Développement local — API staging, logs verbeux, banner debug.
  dev,

  /// Production — API prod, pas de banner debug.
  prod,
}

/// Configuration globale de l'application.
///
/// Initialisée via [AppConfig.setup] dans le point d'entrée (main_*.dart)
/// avant tout appel à [runApp].
class AppConfig {
  AppConfig._();

  static late final AppFlavor _flavor;
  static late final String _apiUrl;

  /// Initialise la configuration. À appeler une seule fois avant [runApp].
  static void setup({required AppFlavor flavor, required String apiUrl}) {
    _flavor = flavor;
    _apiUrl = apiUrl;
  }

  /// Environnement actif.
  static AppFlavor get flavor => _flavor;

  /// URL de base de l'API.
  static String get apiUrl => _apiUrl;

  /// Vrai si l'app tourne en mode développement.
  static bool get isDev => _flavor == AppFlavor.dev;

  /// Timeout de connexion TCP en secondes. La passerelle Render accepte la
  /// connexion tout de suite, même serveur en veille : inutile d'attendre plus.
  static const int httpConnectTimeoutSeconds = 30;

  /// Timeout de réception HTTP en secondes, identique en dev et en prod : tant
  /// que l'API est sur Render (offre gratuite), la première requête après une
  /// veille attend le réveil du serveur (~50 s, parfois plus).
  static const int httpReceiveTimeoutSeconds = 90;

  /// Nombre max de tentatives de PIN avant blocage temporaire.
  static const int maxPinAttempts = 5;

  /// Durée du blocage après échec de PIN, en minutes.
  static const int pinLockoutMinutes = 5;

  /// Durée d'inactivité (aucun toucher, app au premier plan ou en
  /// arrière-plan) après laquelle la session se verrouille et redemande le
  /// PIN, en minutes.
  static const int sessionLockMinutes = 5;

  /// Largeur du papier d'imprimante thermique en millimètres.
  static const int receiptPaperWidthMm = 58;

  /// Limite de produits par boutique au MVP.
  static const int maxProductsPerStore = 5000;

  /// Identifiant de l'app sur le Play Store (flavor prod), ouvert par le
  /// dialogue de mise à jour obligatoire, y compris depuis le flavor dev.
  static const String playStoreAppId = 'ci.pos.macaisse';

  /// Politique de confidentialité publiée (GitHub Pages).
  static const String privacyPolicyUrl =
      'https://kabdoullah.github.io/pos-mobile/privacy-policy';
}
