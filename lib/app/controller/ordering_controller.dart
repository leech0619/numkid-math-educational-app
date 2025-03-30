import 'dart:math';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:vibration/vibration.dart'; // Vibration package
import '../utils/audio_service.dart'; // Audio service for sound effects

/// Manages the logic and state for the Ordering game.
class OrderingController extends ChangeNotifier {
  late List<int> numbers; // List of numbers to be ordered
  late List<int> originalNumbers; // Original list of numbers
  late bool isAscending; // Determines if the order is ascending
  String resultMessage = ''; // Message to display the result
  Color resultMessageColor = Colors.transparent; // Color of the result message
  String buttonText = 'Check Order'; // Text for the check order button
  Color buttonColor = Colors.orange; // Color of the check order button

  final AudioService _audioService = AudioService(); // Audio service instance

  /// Initializes the controller with random numbers.
  OrderingController() {
    generateRandomNumbers();
  }

  /// Generates a list of random numbers and shuffles them.
  void generateRandomNumbers() {
    final random = Random();
    final Set<int> uniqueNumbers = {};
    while (uniqueNumbers.length < 9) {
      uniqueNumbers.add(
        random.nextInt(100) + 1,
      ); // Random numbers between 1 and 100
    }
    numbers = uniqueNumbers.toList();
    originalNumbers = List.from(numbers);
    numbers.shuffle(); // Shuffle the numbers
    isAscending =
        random.nextBool(); // Randomly set ascending or descending order
    resetState();
  }

  /// Resets the state of the game.
  void resetState() {
    resultMessage = '';
    resultMessageColor = Colors.transparent;
    buttonText = 'Check Order';
    buttonColor = Colors.orange;
    notifyListeners(); // Notify UI to update
  }

  /// Checks if the numbers are in the correct order.
  void checkOrder(
    VoidCallback onCorrect,
    VoidCallback onIncorrect,
    bool isArcadeMode, // Arcade mode flag
  ) async {
    List<int> sortedNumbers = List.from(originalNumbers);
    if (!isAscending) {
      sortedNumbers.sort((a, b) => b.compareTo(a)); // Sort in descending order
    } else {
      sortedNumbers.sort((a, b) => a.compareTo(b)); // Sort in ascending order
    }

    if (ListEquality().equals(numbers, sortedNumbers)) {
      resultMessage = 'Correct!';
      resultMessageColor = Colors.green;
      buttonText = '✓';
      buttonColor = Colors.lightGreenAccent;
      notifyListeners();

      await _audioService.playSoundEffect(); // Play correct sound
      Future.delayed(
        Duration(seconds: 1),
        onCorrect,
      ); // Trigger correct callback
    } else {
      resultMessage = 'Hint: ${generateHint(sortedNumbers)}';
      resultMessageColor = Colors.red;
      buttonText = '❌';
      buttonColor = Colors.grey;
      notifyListeners();

      if (await Vibration.hasVibrator()) {
        Vibration.vibrate(duration: 500); // Vibrate for incorrect answer
      }

      if (isArcadeMode) {
        Future.delayed(
          Duration(seconds: 1),
          onIncorrect,
        ); // Trigger wrong callback
      } else {
        Future.delayed(Duration(seconds: 1), () {
          buttonText = 'Check Order';
          buttonColor = Colors.orange;
          notifyListeners();
        });
      }
    }
  }

  /// Generates a hint message to help the user.
  String generateHint(List<int> sortedNumbers) {
    for (int i = 0; i < numbers.length - 1; i++) {
      if (isAscending) {
        if (numbers[i] > numbers[i + 1]) {
          return '${numbers[i]} should be before ${numbers[i + 1]}';
        }
      } else {
        if (numbers[i] < numbers[i + 1]) {
          return '${numbers[i]} should be after ${numbers[i + 1]}';
        }
      }
    }
    return 'Check the order again.';
  }

  /// Handles reordering of numbers.
  void reorderNumbers(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final int item = numbers.removeAt(oldIndex);
    numbers.insert(newIndex, item); // Insert the item at the new index
    notifyListeners(); // Notify UI to update
  }

  /// Resets the game state with new random numbers.
  void resetGame() {
    generateRandomNumbers();
  }
}
