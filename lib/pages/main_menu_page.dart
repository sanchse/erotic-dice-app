import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../l10n/app_localizations.dart';
import 'dice_roller_page.dart';
import 'kamasutra_page.dart';
import '../main.dart';

/// Main menu to choose between different dice types
class MainMenuPage extends StatelessWidget {
  const MainMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.mainMenuTitle),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            tooltip: l10n.language,
            onPressed: () => _showLanguageDialog(context),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.pink.shade50,
              Colors.white,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              const Icon(
                Icons.casino,
                size: 80,
                color: Colors.pink,
              ),
              const SizedBox(height: 24),
              Text(
                l10n.mainMenuSubtitle,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              _buildMenuCard(
                context,
                title: l10n.eroticDiceTitle,
                subtitle: l10n.eroticDiceSubtitle,
                imagePath: 'assets/kamasutra/default.svg',
                color: Colors.blue,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DiceRollerPage()),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildMenuCard(
                context,
                title: l10n.kamasutraDiceTitle,
                subtitle: l10n.kamasutraDiceSubtitle,
                imagePath: 'assets/kamasutra/logo.svg',
                color: Colors.red,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const KamasutraPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = Localizations.localeOf(context);
    
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.language, color: Colors.blue),
              const SizedBox(width: 12),
              Text(l10n.selectLanguage),
            ],
          ),
          contentPadding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          content: ClipRRect(
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(4)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildLanguageOption(
                  context: dialogContext,
                  flag: '🇪🇸',
                  language: l10n.spanish,
                  languageNative: 'Español',
                  isSelected: currentLocale.languageCode == 'es',
                  isFirst: true,
                  onTap: () {
                    EroticDiceApp.setLocale(context, const Locale('es'));
                    Navigator.pop(dialogContext);
                  },
                ),
                Divider(height: 1, color: Colors.grey.shade300),
                _buildLanguageOption(
                  context: dialogContext,
                  flag: '🇬🇧',
                  language: l10n.english,
                  languageNative: 'English',
                  isSelected: currentLocale.languageCode == 'en',
                  onTap: () {
                    EroticDiceApp.setLocale(context, const Locale('en'));
                    Navigator.pop(dialogContext);
                  },
                ),
                Divider(height: 1, color: Colors.grey.shade300),
                _buildLanguageOption(
                  context: dialogContext,
                  flag: '🇫🇷',
                  language: l10n.french,
                  languageNative: 'Français',
                  isSelected: currentLocale.languageCode == 'fr',
                  onTap: () {
                    EroticDiceApp.setLocale(context, const Locale('fr'));
                    Navigator.pop(dialogContext);
                  },
                ),
                Divider(height: 1, color: Colors.grey.shade300),
                _buildLanguageOption(
                  context: dialogContext,
                  flag: '🇩🇪',
                  language: l10n.german,
                  languageNative: 'Deutsch',
                  isSelected: currentLocale.languageCode == 'de',
                  onTap: () {
                    EroticDiceApp.setLocale(context, const Locale('de'));
                    Navigator.pop(dialogContext);
                  },
                ),
                Divider(height: 1, color: Colors.grey.shade300),
                _buildLanguageOption(
                  context: dialogContext,
                  flag: '🇮🇹',
                  language: l10n.italian,
                  languageNative: 'Italiano',
                  isSelected: currentLocale.languageCode == 'it',
                  onTap: () {
                    EroticDiceApp.setLocale(context, const Locale('it'));
                    Navigator.pop(dialogContext);
                  },
                ),
                Divider(height: 1, color: Colors.grey.shade300),
                _buildLanguageOption(
                  context: dialogContext,
                  flag: '🇵🇹',
                  language: l10n.portuguese,
                  languageNative: 'Português',
                  isSelected: currentLocale.languageCode == 'pt',
                  isLast: true,
                  onTap: () {
                    EroticDiceApp.setLocale(context, const Locale('pt'));
                    Navigator.pop(dialogContext);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption({
    required BuildContext context,
    required String flag,
    required String language,
    required String languageNative,
    required bool isSelected,
    bool isFirst = false,
    bool isLast = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.vertical(
        top: isFirst ? const Radius.circular(4) : Radius.zero,
        bottom: isLast ? const Radius.circular(4) : Radius.zero,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : null,
        ),
        child: Row(
          children: [
            Text(
              flag,
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    languageNative,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? Colors.blue.shade700 : Colors.black87,
                    ),
                  ),
                  if (languageNative != language)
                    Text(
                      language,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: Colors.blue.shade700, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String imagePath,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 8,
      shadowColor: color.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withValues(alpha: 0.1),
                color.withValues(alpha: 0.05),
              ],
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SvgPicture.asset(
                  imagePath,
                  width: 32,
                  height: 32,
                  colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
