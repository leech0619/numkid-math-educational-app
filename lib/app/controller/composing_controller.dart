import 'dart:math';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import '../utils/audio_service.dart';

/// Manages the logic and state for the Composing game.
class ComposingController extends ChangeNotifier {
  late int targetNumber; // Target number to achieve
  late List<int> choices; // List of number choices
  List<int> selectedNumbers = []; // Selected numbers by the user
  late List<bool?> correctAnswers; // Tracks correct/incorrect states
  String hintMessage = ''; // Hint message for the user

  final AudioService _audioService = AudioService(); // Audio service instance

  /// Initializes the controller with a new problem.
  ComposingController() {
    generateNewProblem();
  }

  /// Generates a new problem with a target number and choices.
  void generateNewProblem() {
    final random = Random();
    targetNumber = random.nextInt(100); // Random target number (0-99)

    // Generate two numbers that add up to the target number
    int num1 = random.nextInt(targetNumber + 1);
    int num2 = targetNumber - num1;

    // Ensure at least 6 unique numbers in the choices
    Set<int> uniqueNumbers = {num1, num2};
    while (uniqueNumbers.length < 6) {
      uniqueNumbers.add(random.nextInt(100));
    }
    choices = uniqueNumbers.toList()..shuffle();

    selectedNumbers.clear();
    correctAnswers = List.filled(6, null);
    hintMessage = '';
    notifyListeners(); // Notify UI to update
  }

  /// Checks if the selected numbers add up to the target number.
  void checkAnswer(VoidCallback onCorrect, VoidCallback onIncorrect) async {
    if (selectedNumbers.length == 2) {
      final sum = selectedNumbers[0] + selectedNumbers[1];
      final isCorrect = sum == targetNumber;

      if (isCorrect) {
        correctAnswers[choices.indexOf(selectedNumbers[0])] = true;
        correctAnswers[choices.indexOf(selectedNumbers[1])] = true;
        hintMessage = 'CORRECT!';
        notifyListeners();

        await _audioService.playSoundEffect(); // Play correct sound
        Future.delayed(
          Duration(seconds: 1),
          onCorrect,
        ); // Trigger correct feedback
      } else {
        correctAnswers[choices.indexOf(selectedNumbers[0])] = false;
        correctAnswers[choices.indexOf(selectedNumbers[1])] = false;
        hintMessage =
            'The sum of ${selectedNumbers[0]} and ${selectedNumbers[1]} is not $targetNumber.';
        notifyListeners();

        if (await Vibration.hasVibrator()) {
          Vibration.vibrate(duration: 500); // Vibrate for incorrect answer
        }

        Future.delayed(Duration(seconds: 1), () {
          correctAnswers[choices.indexOf(selectedNumbers[0])] = null;
          correctAnswers[choices.indexOf(selectedNumbers[1])] = null;
          selectedNumbers.clear();
          notifyListeners();
          onIncorrect(); // Trigger incorrect feedback
        });
      }
    }
  }

  /// Handles button press events and updates the state.
  void handleButtonPress(int number) {
    if (selectedNumbers.contains(number)) {
      selectedNumbers.remove(number); // Deselect the number
    } else if (selectedNumbers.length < 2) {
      selectedNumbers.add(number); // Select the number
    }
    notifyListeners(); // Notify UI to update
  }

  /// Resets the game state with a new problem.
  void resetGame() {
    generateNewProblem();
  }
}
