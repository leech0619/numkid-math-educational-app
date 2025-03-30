import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screen/comparing_screen.dart';
import '../screen/composing_screen.dart';
import '../screen/counting_screen.dart';
import '../screen/ordering_screen.dart';
import '../controller/comparing_controller.dart';
import '../controller/composing_controller.dart';
import '../controller/counting_controller.dart';
import '../controller/ordering_controller.dart';

/// Manages the arcade mode logic and state.
class ArcadeController extends ChangeNotifier {
  int score = 0; // Current score in arcade mode
  int highestScore = 0; // Highest score achieved in arcade mode

  /// Constructor to initialize the controller and load the highest score.
  ArcadeController() {
    loadHighestScore();
  }

  /// Loads the highest score from persistent storage.
  Future<void> loadHighestScore() async {
    final prefs = await SharedPreferences.getInstance();
    highestScore = prefs.getInt('highestScore') ?? 0;
    notifyListeners(); // Notify listeners to update the UI
  }

  /// Saves the highest score to persistent storage.
  Future<void> saveHighestScore() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('highestScore', highestScore);
  }

  /// Increases the current score by 1.
  void increaseScore() {
    score++;
    notifyListeners(); // Notify listeners to update the UI
  }

  /// Resets the current score to 0.
  void resetScore() {
    score = 0;
    notifyListeners(); // Notify listeners to update the UI
  }

  /// Updates the highest score if the current score is greater.
  void updateHighestScore() {
    if (score > highestScore) {
      highestScore = score;
      saveHighestScore(); // Save the new highest score
    }
  }

  /// Selects a random game and its associated controller for arcade mode.
  /// Returns a map containing the selected screen and controller.
  Map<String, dynamic> selectRandomGame(
    BuildContext context,
    VoidCallback onCorrect,
  ) {
    final List<Map<String, dynamic>> games = [
      {
        'screen': CountingScreen(isArcadeMode: true, onCorrect: onCorrect),
        'controller': CountingController(),
      },
      {
        'screen': ComparingScreen(isArcadeMode: true, onCorrect: onCorrect),
        'controller': ComparingController(),
      },
      {
        'screen': OrderingScreen(isArcadeMode: true, onCorrect: onCorrect),
        'controller': OrderingController(),
      },
      {
        'screen': ComposingScreen(isArcadeMode: true, onCorrect: onCorrect),
        'controller': ComposingController(),
      },
    ];

    final random = Random();
    return games[random.nextInt(games.length)]; // Return a random game
  }
}
