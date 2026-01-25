import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService {
  static const String _languageKey = 'app_language';
  
  // Get stored locale or return null to use system default
  static Future<Locale?> getStoredLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_languageKey);
    
    if (languageCode != null) {
      return Locale(languageCode);
    }
    
    return null; // Use system default
  }
  
  // Save user's language preference
  static Future<void> setLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, locale.languageCode);
  }
  
  // Check if a language is supported
  static bool isSupported(Locale locale) {
    return ['es', 'en'].contains(locale.languageCode);
  }
}
