import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/composing_controller.dart';
import '../controller/arcade_controller.dart';
import '../widgets/choice_button.dart';
import '../widgets/correct_dialog.dart';
import '../widgets/score_dialog.dart';
import 'game_screen_template.dart';

class ComposingScreen extends StatefulWidget {
  final bool isArcadeMode; // Determines if the screen is in arcade mode
  final VoidCallback? onCorrect; // Callback for arcade mode navigation

  const ComposingScreen({super.key, this.isArcadeMode = false, this.onCorrect});

  @override
  _ComposingScreenState createState() => _ComposingScreenState();
}

class _ComposingScreenState extends State<ComposingScreen> {
  @override
  void initState() {
    super.initState();

    // Reset the state when the screen is first opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Provider.of<ComposingController>(
        context,
        listen: false,
      );
      controller.resetGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ComposingController>(context);
    final arcadeController = Provider.of<ArcadeController>(context);
    final Size screenSize = MediaQuery.of(context).size;
    final double fontSize = screenSize.width > 600 ? 30 : 20;
    final double spacing = screenSize.width > 600 ? 40 : 30;

    return GameScreenTemplate(
      title:
          widget.isArcadeMode
              ? 'Score: ${arcadeController.score}' // Display current score in arcade mode
              : 'Composing', // Default title for topic mode
      appBarColor: Colors.purple,
      showBackButton:
          !widget.isArcadeMode, // Show back button only in topic mode
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: spacing),
          Container(
            padding: EdgeInsets.symmetric(horizontal: spacing),
            color: Colors.white.withValues(alpha: 0.5),
            child: Text(
              'Select two numbers that add up to the target number.',
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: spacing),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.purpleAccent,
            ),
            child: Text(
              'Target Number: ${controller.targetNumber}',
              style: TextStyle(
                fontSize: fontSize,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: spacing),
          // Grid of choice buttons
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: screenSize.width > 600 ? 4 : 3,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            padding: EdgeInsets.all(spacing),
            children: List.generate(controller.choices.length, (index) {
              final number = controller.choices[index];
              final isSelected = controller.selectedNumbers.contains(number);
              return ChoiceButton(
                title:
                    controller.correctAnswers[index] == true
                        ? '✓'
                        : (controller.correctAnswers[index] == false
                            ? '❌'
                            : number.toString()),
                color:
                    controller.correctAnswers[index] == true
                        ? Colors.lightGreenAccent
                        : (controller.correctAnswers[index] == false
                            ? Colors.grey
                            : (isSelected ? Colors.purple : Colors.grey)),
                onPressed: () {
                  controller.handleButtonPress(number);
                  if (controller.selectedNumbers.length == 2) {
                    controller.checkAnswer(
                      () {
                        // Correct answer logic
                        if (widget.isArcadeMode) {
                          arcadeController
                              .increaseScore(); // Increment the score
                          // Arcade mode: Navigate to a new random game
                          if (widget.onCorrect != null) {
                            widget.onCorrect!();
                          }
                        } else {
                          // Topic mode: Show the correct dialog
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return CorrectDialog(
                                title: 'CORRECT!',
                                content: 'You found the correct pair!',
                                dialogBackgroundColor: Colors.green,
                                onNewGame: () {
                                  Navigator.of(context).pop();
                                  controller.generateNewProblem();
                                },
                                onHome: () {
                                  Navigator.of(
                                    context,
                                  ).popUntil((route) => route.isFirst);
                                },
                              );
                            },
                          );
                        }
                      },
                      () {
                        // Wrong answer logic
                        if (widget.isArcadeMode) {
                          arcadeController
                              .updateHighestScore(); // Update the highest score

                          // Arcade mode: Show the ScoreDialog
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return ScoreDialog(
                                title: 'Game Over!',
                                score: arcadeController.score,
                                onHome: () {
                                  Navigator.of(
                                    context,
                                  ).popUntil((route) => route.isFirst);
                                  arcadeController
                                      .resetScore(); // Reset the score after game over
                                },
                              );
                            },
                          );
                        }
                      },
                    );
                  }
                },
                textStyle: TextStyle(fontSize: fontSize),
              );
            }),
          ),
          // Hint message for the user
          if (controller.hintMessage.isNotEmpty)
            Container(
              color: Colors.white.withValues(alpha: 0.5),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Text(
                controller.hintMessage,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color:
                      controller.hintMessage == 'CORRECT!'
                          ? Colors.green
                          : Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}
