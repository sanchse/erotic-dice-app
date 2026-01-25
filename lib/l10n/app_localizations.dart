import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('pt')
  ];

  /// Title of the application
  ///
  /// In es, this message translates to:
  /// **'Dados Eróticos'**
  String get appTitle;

  /// Main menu page title
  ///
  /// In es, this message translates to:
  /// **'Dados Eróticos'**
  String get mainMenuTitle;

  /// Main menu page subtitle
  ///
  /// In es, this message translates to:
  /// **'Elige tu modo de juego'**
  String get mainMenuSubtitle;

  /// Erotic dice card title
  ///
  /// In es, this message translates to:
  /// **'Dados Eróticos'**
  String get eroticDiceTitle;

  /// Erotic dice card subtitle
  ///
  /// In es, this message translates to:
  /// **'Lanza los dados y disfruta'**
  String get eroticDiceSubtitle;

  /// Kamasutra dice card title
  ///
  /// In es, this message translates to:
  /// **'Dados Kamasutra'**
  String get kamasutraDiceTitle;

  /// Kamasutra dice card subtitle
  ///
  /// In es, this message translates to:
  /// **'Descubre nuevas posiciones'**
  String get kamasutraDiceSubtitle;

  /// Roll dice button
  ///
  /// In es, this message translates to:
  /// **'Lanzar Dados'**
  String get rollDice;

  /// Rolling dice status
  ///
  /// In es, this message translates to:
  /// **'Lanzando...'**
  String get rolling;

  /// Result label
  ///
  /// In es, this message translates to:
  /// **'¡Resultado!'**
  String get result;

  /// Configuration menu option
  ///
  /// In es, this message translates to:
  /// **'Configuración'**
  String get configuration;

  /// Dice configuration page title
  ///
  /// In es, this message translates to:
  /// **'Configuración de Dados'**
  String get diceConfiguration;

  /// Number of dice selector label
  ///
  /// In es, this message translates to:
  /// **'Número de Dados'**
  String get numberOfDice;

  /// Restore defaults option
  ///
  /// In es, this message translates to:
  /// **'Restaurar Valores Predeterminados'**
  String get restoreDefaults;

  /// Confirmation message for restoring defaults
  ///
  /// In es, this message translates to:
  /// **'Esto restaurará todos los títulos y opciones de los dados a sus valores predeterminados. ¿Estás seguro?'**
  String get restoreDefaultsConfirmation;

  /// Restore button in confirmation dialog
  ///
  /// In es, this message translates to:
  /// **'Restaurar'**
  String get restore;

  /// Apply changes button
  ///
  /// In es, this message translates to:
  /// **'Aplicar Cambios'**
  String get applyChanges;

  /// Cancel button
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// Save button
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get save;

  /// Close button
  ///
  /// In es, this message translates to:
  /// **'Cerrar'**
  String get close;

  /// Edit options button
  ///
  /// In es, this message translates to:
  /// **'Editar Opciones'**
  String get editOptions;

  /// Edit options dialog title
  ///
  /// In es, this message translates to:
  /// **'Editar Opciones para {diceName}'**
  String editOptionsFor(String diceName);

  /// Instructions for editing options
  ///
  /// In es, this message translates to:
  /// **'Ingresa cada opción en una nueva línea (máximo 6 opciones):'**
  String get enterEachOption;

  /// Missing options explanation
  ///
  /// In es, this message translates to:
  /// **'Las opciones faltantes se mostrarán como \"?\" en el dado.'**
  String get missingOptionsWillShow;

  /// Success message for saving options
  ///
  /// In es, this message translates to:
  /// **'Opciones guardadas exitosamente'**
  String get optionsSavedSuccessfully;

  /// Add option button
  ///
  /// In es, this message translates to:
  /// **'Agregar Opción'**
  String get addOption;

  /// Add option dialog title
  ///
  /// In es, this message translates to:
  /// **'Agregar Opción a {diceName}'**
  String addOptionTo(String diceName);

  /// New option placeholder
  ///
  /// In es, this message translates to:
  /// **'Nueva opción'**
  String get newOption;

  /// Success message for adding option
  ///
  /// In es, this message translates to:
  /// **'Opción \"{optionName}\" agregada exitosamente'**
  String optionAddedSuccessfully(String optionName);

  /// Error message for duplicate option
  ///
  /// In es, this message translates to:
  /// **'Esta opción ya existe'**
  String get thisOptionAlreadyExists;

  /// Success message for applying configuration
  ///
  /// In es, this message translates to:
  /// **'Configuración aplicada exitosamente'**
  String get configurationAppliedSuccessfully;

  /// Success message for restoring defaults
  ///
  /// In es, this message translates to:
  /// **'Dados restaurados a la configuración predeterminada'**
  String get dicesRestoredToDefault;

  /// Countdown timer label
  ///
  /// In es, this message translates to:
  /// **'Contador Regresivo'**
  String get countdownTimer;

  /// Countdown paused label
  ///
  /// In es, this message translates to:
  /// **'Contador Pausado'**
  String get countdownPaused;

  /// Pause button
  ///
  /// In es, this message translates to:
  /// **'Pausar'**
  String get pause;

  /// Resume button
  ///
  /// In es, this message translates to:
  /// **'Reanudar'**
  String get resume;

  /// Time detected label
  ///
  /// In es, this message translates to:
  /// **'Tiempo Detectado'**
  String get timeDetected;

  /// Result with time
  ///
  /// In es, this message translates to:
  /// **'Resultado: {time}'**
  String resultWithTime(String time);

  /// Ready to start counter question
  ///
  /// In es, this message translates to:
  /// **'¿Listo para comenzar el contador?'**
  String get readyToStartCounter;

  /// Start button
  ///
  /// In es, this message translates to:
  /// **'Iniciar'**
  String get start;

  /// Time finished alert title
  ///
  /// In es, this message translates to:
  /// **'¡Tiempo Terminado!'**
  String get timeFinished;

  /// Countdown reached zero message
  ///
  /// In es, this message translates to:
  /// **'El contador regresivo ha llegado a cero.'**
  String get countdownReachedZero;

  /// Custom time dialog title
  ///
  /// In es, this message translates to:
  /// **'Tiempo Personalizado'**
  String get customTime;

  /// Seconds label
  ///
  /// In es, this message translates to:
  /// **'Segundos'**
  String get seconds;

  /// Enter time hint
  ///
  /// In es, this message translates to:
  /// **'Ingresa el tiempo en segundos'**
  String get enterTimeInSeconds;

  /// Confirm button
  ///
  /// In es, this message translates to:
  /// **'Confirmar'**
  String get confirm;

  /// Kamasutra page title
  ///
  /// In es, this message translates to:
  /// **'Dados Kamasutra'**
  String get kamasutraTitle;

  /// Kamasutra page subtitle
  ///
  /// In es, this message translates to:
  /// **'Descubre nuevas posiciones con cada lanzamiento'**
  String get discoverNewPositions;

  /// Discovering position message
  ///
  /// In es, this message translates to:
  /// **'¡Descubriendo tu posición!'**
  String get discoveringPosition;

  /// Preparing surprise message
  ///
  /// In es, this message translates to:
  /// **'Preparándote una sorpresa...'**
  String get preparingSurprise;

  /// Launch dice to discover message
  ///
  /// In es, this message translates to:
  /// **'¡Lanza el dado para descubrir\\nuna nueva posición!'**
  String get launchDiceToDiscover;

  /// Image not available message
  ///
  /// In es, this message translates to:
  /// **'Imagen no disponible'**
  String get imageNotAvailable;

  /// Debug persistence dialog title
  ///
  /// In es, this message translates to:
  /// **'Debug Persistencia'**
  String get debugPersistence;

  /// Saved configuration label
  ///
  /// In es, this message translates to:
  /// **'Configuración guardada:'**
  String get savedConfiguration;

  /// No saved configuration message
  ///
  /// In es, this message translates to:
  /// **'No hay configuración guardada'**
  String get noSavedConfiguration;

  /// Current configuration label
  ///
  /// In es, this message translates to:
  /// **'Configuración actual:'**
  String get currentConfiguration;

  /// Save now button
  ///
  /// In es, this message translates to:
  /// **'Guardar Ahora'**
  String get saveNow;

  /// Configuration saved manually message
  ///
  /// In es, this message translates to:
  /// **'Configuración guardada manualmente'**
  String get configurationSavedManually;

  /// Dice label with number
  ///
  /// In es, this message translates to:
  /// **'Dado {number}'**
  String dice(int number);

  /// Number of dice display
  ///
  /// In es, this message translates to:
  /// **'Número de dados: {count}'**
  String numberOfDiceColon(int count);

  /// Loading configuration message
  ///
  /// In es, this message translates to:
  /// **'Cargando tu configuración de dados...'**
  String get loadingYourDiceConfiguration;

  /// Settings menu option
  ///
  /// In es, this message translates to:
  /// **'Ajustes'**
  String get settings;

  /// Language label
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get language;

  /// Select language dialog title
  ///
  /// In es, this message translates to:
  /// **'Seleccionar Idioma'**
  String get selectLanguage;

  /// Spanish language name
  ///
  /// In es, this message translates to:
  /// **'Español'**
  String get spanish;

  /// English language name
  ///
  /// In es, this message translates to:
  /// **'English'**
  String get english;

  /// French language name
  ///
  /// In es, this message translates to:
  /// **'Français'**
  String get french;

  /// German language name
  ///
  /// In es, this message translates to:
  /// **'Deutsch'**
  String get german;

  /// Italian language name
  ///
  /// In es, this message translates to:
  /// **'Italiano'**
  String get italian;

  /// Portuguese language name
  ///
  /// In es, this message translates to:
  /// **'Português'**
  String get portuguese;

  /// Default title for first dice (Action)
  ///
  /// In es, this message translates to:
  /// **'Acción'**
  String get defaultDice1Title;

  /// Default title for second dice (Body Part)
  ///
  /// In es, this message translates to:
  /// **'Parte del Cuerpo'**
  String get defaultDice2Title;

  /// Default title for third dice (Time)
  ///
  /// In es, this message translates to:
  /// **'Tiempo'**
  String get defaultDice3Title;

  /// Action option: Kiss
  ///
  /// In es, this message translates to:
  /// **'Besar'**
  String get actionKiss;

  /// Action option: Lick
  ///
  /// In es, this message translates to:
  /// **'Lamer'**
  String get actionLick;

  /// Action option: Massage
  ///
  /// In es, this message translates to:
  /// **'Masajear'**
  String get actionMassage;

  /// Action option: Touch
  ///
  /// In es, this message translates to:
  /// **'Tocar'**
  String get actionTouch;

  /// Action option: Caress
  ///
  /// In es, this message translates to:
  /// **'Acariciar'**
  String get actionCaress;

  /// Action option: Nibble
  ///
  /// In es, this message translates to:
  /// **'Mordisquear'**
  String get actionNibble;

  /// Body part option: Neck
  ///
  /// In es, this message translates to:
  /// **'Cuello'**
  String get bodyPartNeck;

  /// Body part option: Back
  ///
  /// In es, this message translates to:
  /// **'Espalda'**
  String get bodyPartBack;

  /// Body part option: Genitals
  ///
  /// In es, this message translates to:
  /// **'Genitales'**
  String get bodyPartGenitals;

  /// Body part option: Nipples
  ///
  /// In es, this message translates to:
  /// **'Pezones'**
  String get bodyPartNipples;

  /// Body part option: Butt
  ///
  /// In es, this message translates to:
  /// **'Culo'**
  String get bodyPartButt;

  /// Body part option: Lips
  ///
  /// In es, this message translates to:
  /// **'Labios'**
  String get bodyPartLips;

  /// Time option: 30 seconds
  ///
  /// In es, this message translates to:
  /// **'30 seg'**
  String get time30Sec;

  /// Time option: 1 minute
  ///
  /// In es, this message translates to:
  /// **'1 min'**
  String get time1Min;

  /// Time option: 2 minutes
  ///
  /// In es, this message translates to:
  /// **'2 min'**
  String get time2Min;

  /// Time option: 3 minutes
  ///
  /// In es, this message translates to:
  /// **'3 min'**
  String get time3Min;

  /// Time option: 5 minutes
  ///
  /// In es, this message translates to:
  /// **'5 min'**
  String get time5Min;

  /// Kamasutra position: Missionary
  ///
  /// In es, this message translates to:
  /// **'Misionero'**
  String get positionMissionary;

  /// Missionary position description
  ///
  /// In es, this message translates to:
  /// **'Posición clásica cara a cara, él encima'**
  String get positionMissionaryDesc;

  /// Kamasutra position: Doggy Style
  ///
  /// In es, this message translates to:
  /// **'Perrito'**
  String get positionDoggy;

  /// Doggy Style position description
  ///
  /// In es, this message translates to:
  /// **'Posición desde atrás'**
  String get positionDoggyDesc;

  /// Kamasutra position: Cowgirl
  ///
  /// In es, this message translates to:
  /// **'Vaquera'**
  String get positionCowgirl;

  /// Cowgirl position description
  ///
  /// In es, this message translates to:
  /// **'Ella arriba'**
  String get positionCowgirlDesc;

  /// Kamasutra position: Reverse Cowgirl
  ///
  /// In es, this message translates to:
  /// **'Vaquera Invertida'**
  String get positionReverseCowgirl;

  /// Reverse Cowgirl position description
  ///
  /// In es, this message translates to:
  /// **'Ella arriba mirando hacia los pies'**
  String get positionReverseCowgirlDesc;

  /// Kamasutra position: Stand and Carry
  ///
  /// In es, this message translates to:
  /// **'De pie y cargando'**
  String get positionStandAndCarry;

  /// Stand and Carry position description
  ///
  /// In es, this message translates to:
  /// **'Él de pie sosteniéndola'**
  String get positionStandAndCarryDesc;

  /// Kamasutra position: Bodyguard
  ///
  /// In es, this message translates to:
  /// **'Guardaespaldas'**
  String get positionBodyguard;

  /// Bodyguard position description
  ///
  /// In es, this message translates to:
  /// **'Él detrás abrazándola'**
  String get positionBodyguardDesc;

  /// Kamasutra position: 69
  ///
  /// In es, this message translates to:
  /// **'69'**
  String get position69;

  /// 69 position description
  ///
  /// In es, this message translates to:
  /// **'Ambos disfrutando oralmente'**
  String get position69Desc;

  /// Kamasutra position: Kneeling Blow Job
  ///
  /// In es, this message translates to:
  /// **'Arrodillada'**
  String get positionKneelingBlowJob;

  /// Kneeling Blow Job position description
  ///
  /// In es, this message translates to:
  /// **'Él de pie, ella arrodillada frente a él realizando sexo oral'**
  String get positionKneelingBlowJobDesc;

  /// Kamasutra position: Prone
  ///
  /// In es, this message translates to:
  /// **'Boca Abajo'**
  String get positionProne;

  /// Prone position description
  ///
  /// In es, this message translates to:
  /// **'Ella boca abajo, él encima'**
  String get positionProneDesc;

  /// Kamasutra position: Anvil
  ///
  /// In es, this message translates to:
  /// **'Yunque'**
  String get positionAnvil;

  /// Anvil position description
  ///
  /// In es, this message translates to:
  /// **'Ella con piernas muy elevadas, él encima'**
  String get positionAnvilDesc;

  /// Kamasutra position: Zeus
  ///
  /// In es, this message translates to:
  /// **'Zeus'**
  String get positionZeus;

  /// Zeus position description
  ///
  /// In es, this message translates to:
  /// **'Ella de rodilla realizando sexo oral mientras él está de pie sujetando la cabeza'**
  String get positionZeusDesc;

  /// Kamasutra position: Hungry
  ///
  /// In es, this message translates to:
  /// **'Hambriento'**
  String get positionHungry;

  /// Hungry position description
  ///
  /// In es, this message translates to:
  /// **'Ella tumbada y él entre sus piernas realizando sexo oral'**
  String get positionHungryDesc;

  /// Kamasutra position: Dancer
  ///
  /// In es, this message translates to:
  /// **'Bailarines'**
  String get positionDancer;

  /// Dancer position description
  ///
  /// In es, this message translates to:
  /// **'Él de pie, ella de pie frente a él con una pierna elevada alrededor de su cintura'**
  String get positionDancerDesc;

  /// Kamasutra position: Side Missionary
  ///
  /// In es, this message translates to:
  /// **'Misionero de Lado'**
  String get positionManMissionary;

  /// Side Missionary position description
  ///
  /// In es, this message translates to:
  /// **'Ambos acostados de lado, él detrás de ella'**
  String get positionManMissionaryDesc;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'de',
        'en',
        'es',
        'fr',
        'it',
        'pt'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
