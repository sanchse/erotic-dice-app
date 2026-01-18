import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/dice.dart';

/// Service for handling persistent storage
class StorageService {
  static const String _configKey = 'dice_configuration';

  /// Save dice configuration
  Future<void> saveDiceConfiguration(List<Dice> diceList, int numberOfDice) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final configMap = {
        'numberOfDice': numberOfDice,
        'diceList': diceList.map((dice) => {
          'title': dice.title,
          'options': dice.options,
        }).toList(),
      };
      
      final jsonString = json.encode(configMap);
      await prefs.setString(_configKey, jsonString);
    } catch (e) {
      throw Exception('Error saving configuration: $e');
    }
  }

  /// Load dice configuration
  Future<Map<String, dynamic>?> loadDiceConfiguration() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_configKey);
      
      if (jsonString != null) {
        return json.decode(jsonString) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      throw Exception('Error loading configuration: $e');
    }
  }
}
