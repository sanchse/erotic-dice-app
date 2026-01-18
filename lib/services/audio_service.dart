import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

/// Service for handling audio playback
class AudioService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  /// Play dice roll sound
  Future<void> playDiceRollSound() async {
    try {
      await _audioPlayer.play(AssetSource('sounds/dice_roll.mp3'));
    } catch (e) {
      debugPrint('Error playing dice roll sound: $e');
      try {
        await HapticFeedback.mediumImpact();
      } catch (hapticError) {
        debugPrint('Error with haptic feedback: $hapticError');
      }
    }
  }

  /// Play countdown finished sound
  Future<void> playCountdownFinishedSound() async {
    try {
      await _audioPlayer.play(AssetSource('sounds/countdown.mp3'));
    } catch (e) {
      debugPrint('Error playing countdown finished sound: $e');
      try {
        await HapticFeedback.heavyImpact();
      } catch (hapticError) {
        debugPrint('Error with haptic feedback: $hapticError');
      }
    }
  }

  /// Dispose audio player
  void dispose() {
    _audioPlayer.dispose();
  }
}
