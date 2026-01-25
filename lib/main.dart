import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

// Pages
import 'pages/main_menu_page.dart';

// Services
import 'services/language_service.dart';

void main() {
  runApp(const EroticDiceApp());
}

/// Main application widget
class EroticDiceApp extends StatefulWidget {
  const EroticDiceApp({super.key});

  @override
  State<EroticDiceApp> createState() => _EroticDiceAppState();
  
  // Static method to update locale from anywhere in the widget tree
  static void setLocale(BuildContext context, Locale newLocale) {
    _EroticDiceAppState? state = context.findAncestorStateOfType<_EroticDiceAppState>();
    state?.setLocale(newLocale);
  }
}

class _EroticDiceAppState extends State<EroticDiceApp> {
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final locale = await LanguageService.getStoredLocale();
    if (locale != null && mounted) {
      setState(() {
        _locale = locale;
      });
    }
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
    LanguageService.setLocale(locale);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Erotic Dice',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es'),
        Locale('en'),
        Locale('fr'),
        Locale('de'),
        Locale('it'),
        Locale('pt'),
      ],
      locale: _locale,
      localeResolutionCallback: (locale, supportedLocales) {
        // If we have a stored locale, use it
        if (_locale != null) {
          return _locale;
        }
        
        // Check if the device's locale is supported
        if (locale != null) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode) {
              return supportedLocale;
            }
          }
        }
        
        // Return Spanish as default
        return const Locale('es');
      },
      theme: ThemeData(
        primarySwatch: Colors.pink,
        useMaterial3: true,
      ),
      home: const MainMenuPage(),
    );
  }
}
