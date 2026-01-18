import 'dart:math';

/// Dice model representing a customizable dice with options
class Dice {
  String title;
  final List<String> options;
  static final Random _random = Random();

  Dice({required this.title, required this.options});

  /// Roll the dice and return a random option
  String roll() {
    // Create a list of 6 options, filling empty slots with "?"
    final fullOptions = List<String>.generate(6, (index) {
      return index < options.length ? options[index] : '?';
    });
    return fullOptions[_random.nextInt(fullOptions.length)];
  }

  /// Get all 6 options including question marks for empty slots
  List<String> get fullOptions {
    return List<String>.generate(6, (index) {
      return index < options.length ? options[index] : '?';
    });
  }
}
