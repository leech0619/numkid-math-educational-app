import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:vibration/vibration.dart'; 
import '../utils/audio_service.dart';

/// Manages the logic and state for the Comparing game.
class ComparingController extends ChangeNotifier {
  final FlipCardController controller1 =
      FlipCardController(); // First flip card controller
  final FlipCardController controller2 =
      FlipCardController(); // Second flip card controller
  late int question1; // First random number
  late int question2; // Second random number
  late List<String> buttonStates; // Button states (✓, ❌, or '')

  final AudioService _audioService = AudioService(); // Audio service instance

  /// Initializes the controller with random numbers.
  ComparingController() {
    _generateRandomNumbers();
  }

  /// Generates random numbers for the questions.
  void _generateRandomNumbers() {
    final random = Random();
    question1 = random.nextInt(20) + 1; // Random number between 1 and 20
    question2 = random.nextInt(20) + 1; // Random number between 1 and 20
    buttonStates = List.filled(3, ''); // Reset button states
    notifyListeners(); // Notify UI to update
  }

  /// Handles button press and checks if the selected option is correct.
  void handleButtonPress(
    BuildContext context,
    String option,
    int index,
    VoidCallback onCorrect,
    VoidCallback onWrong,
    bool isArcadeMode, // Arcade mode flag
  ) async {
    bool isCorrect = false;

    // Check if the selected option is correct
    if (option == 'Greater than' && question1 > question2) {
      isCorrect = true;
    } else if (option == 'Less than' && question1 < question2) {
      isCorrect = true;
    } else if (option == 'Equal To' && question1 == question2) {
      isCorrect = true;
    }

    if (isCorrect) {
      buttonStates[index] = '✓'; // Mark as correct
      notifyListeners(); // Update UI
      await _audioService.playSoundEffect(); // Play correct sound
      Future.delayed(
        Duration(seconds: 1),
        onCorrect,
      ); // Trigger correct callback
    } else {
      buttonStates[index] = '❌'; // Mark as incorrect
      notifyListeners(); // Update UI

      // Vibrate for wrong answers
      if (await Vibration.hasVibrator()) {
        Vibration.vibrate(duration: 500);
      }

      if (isArcadeMode) {
        Future.delayed(Duration(seconds: 1), onWrong); // Trigger wrong callback
      } else {
        // Reset button state after a delay in topic mode
        Future.delayed(Duration(seconds: 1), () {
          buttonStates[index] = '';
          notifyListeners(); // Update UI
        });
      }
    }
  }

  /// Resets the game with new random numbers.
  void resetGame() {
    _generateRandomNumbers();
  }
}
