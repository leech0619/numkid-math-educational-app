import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:vibration/vibration.dart';
import '../utils/audio_service.dart';

/// Manages the logic and state for the Counting game.
class CountingController extends ChangeNotifier {
  final FlipCardController flipCardController =
      FlipCardController(); // Flip card controller
  late List<int> options; // List of options for the user to choose from
  late int question; // The correct answer (number of tigers)
  late List<bool> correctAnswers; // Tracks correct/incorrect states for options

  final AudioService _audioService = AudioService(); // Audio service instance

  /// Initializes the controller with random numbers.
  CountingController() {
    _generateRandomNumbers();
  }

  /// Generates random numbers for the options and selects a random question.
  void _generateRandomNumbers() {
    final random = Random();
    final Set<int> uniqueNumbers = {};
    while (uniqueNumbers.length < 4) {
      uniqueNumbers.add(
        random.nextInt(20) + 1,
      ); // Random numbers between 1 and 20
    }
    options = uniqueNumbers.toList();
    question = options[random.nextInt(4)]; // Randomly select the correct answer
    correctAnswers = List.filled(4, false); // Initialize correct answers
    notifyListeners(); // Notify UI to update
  }

  /// Handles button press and checks if the selected option is correct.
  void handleButtonPress(
    BuildContext context,
    int option,
    int index,
    VoidCallback onCorrect,
    VoidCallback onWrong,
    bool isArcadeMode, // Arcade mode flag
  ) async {
    if (option == question) {
      correctAnswers[index] = true; // Mark as correct
      notifyListeners(); // Update UI

      await _audioService.playSoundEffect(); // Play correct sound
      Future.delayed(
        Duration(seconds: 1),
        onCorrect,
      ); // Trigger correct callback
    } else {
      options[index] = -1; // Mark as incorrect
      notifyListeners(); // Update UI

      if (await Vibration.hasVibrator()) {
        Vibration.vibrate(duration: 500); // Vibrate for incorrect answer
      }

      if (isArcadeMode) {
        Future.delayed(Duration(seconds: 1), onWrong); // Trigger wrong callback
      } else {
        Future.delayed(Duration(seconds: 1), () {
          options[index] = option; // Reset the option
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
