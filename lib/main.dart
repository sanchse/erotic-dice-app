import 'package:flutter/material.dart';

// Pages
import 'pages/main_menu_page.dart';

void main() {
  runApp(const EroticDiceApp());
}

/// Main application widget
class EroticDiceApp extends StatelessWidget {
  const EroticDiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dados Eróticos',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        useMaterial3: true,
      ),
      home: const MainMenuPage(),
    );
  }
}
