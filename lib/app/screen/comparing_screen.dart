import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/comparing_controller.dart';
import '../controller/arcade_controller.dart';
import '../widgets/choice_button.dart';
import '../widgets/flip_card.dart';
import '../widgets/correct_dialog.dart';
import '../widgets/score_dialog.dart';
import 'game_screen_template.dart';

class ComparingScreen extends StatefulWidget {
  final bool isArcadeMode; // Determines if the screen is in arcade mode
  final VoidCallback? onCorrect; // Callback for arcade mode navigation

  const ComparingScreen({super.key, this.isArcadeMode = false, this.onCorrect});

  @override
  _ComparingScreenState createState() => _ComparingScreenState();
}

class _ComparingScreenState extends State<ComparingScreen> {
  @override
  void initState() {
    super.initState();

    // Reset the state when the screen is first opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Provider.of<ComparingController>(
        context,
        listen: false,
      );
      controller.resetGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ComparingController>(context);
    final arcadeController = Provider.of<ArcadeController>(context);
    final Size screenSize = MediaQuery.of(context).size;
    final double fontSize = screenSize.width > 600 ? 30 : 20;
    final double flipFont = screenSize.width > 600 ? 40 : 30;
    final double buttonWidth = screenSize.width > 600 ? 320 : 280;
    final double buttonHeight = screenSize.width > 600 ? 90 : 70;

    return GameScreenTemplate(
      title:
          widget.isArcadeMode
              ? 'Score: ${arcadeController.score}' // Display current score in arcade mode
              : 'Comparing', // Default title for topic mode
      appBarColor: Colors.red,
      showBackButton:
          !widget.isArcadeMode, // Show back button only in topic mode
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // First flip card displaying the first question number
              FlipCardWidget(
                controller: controller.controller1,
                front: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    color: Colors.redAccent[100],
                    border: Border.all(color: Colors.red, width: 3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      '${controller.question1}',
                      style: TextStyle(
                        fontSize: flipFont,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                back: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red, width: 3),
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/numbers/${controller.question1}.png',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              // Second flip card displaying the second question number
              FlipCardWidget(
                controller: controller.controller2,
                front: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    color: Colors.redAccent[100],
                    border: Border.all(color: Colors.red, width: 3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      '${controller.question2}',
                      style: TextStyle(
                        fontSize: flipFont,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                back: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red, width: 3),
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/numbers/${controller.question2}.png',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          // Hint message for the user
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            color: Colors.white.withValues(alpha: 0.5),
            child: Text(
              '${controller.question1} is ______ ${controller.question2}\n(Hint: Click on the image)',
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          // Buttons for user to select the comparison option
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                final titles = ['Greater than', 'Less than', 'Equal To'];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: SizedBox(
                    width: buttonWidth,
                    height: buttonHeight,
                    child: ChoiceButton(
                      title:
                          controller.buttonStates[index] == ''
                              ? titles[index]
                              : controller.buttonStates[index],
                      color:
                          controller.buttonStates[index] == '✓'
                              ? Colors.lightGreenAccent
                              : (controller.buttonStates[index] == '❌'
                                  ? Colors.grey
                                  : Colors.red),
                      onPressed: () {
                        controller.handleButtonPress(
                          context,
                          titles[index],
                          index,
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
                                    content:
                                        '${controller.question1} is ${titles[index]} ${controller.question2}.',
                                    dialogBackgroundColor: Colors.red,
                                    onNewGame: () {
                                      Navigator.of(context).pop();
                                      controller.resetGame();
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
                                          .resetScore(); // Reset the score after navigating home
                                    },
                                  );
                                },
                              );
                            }
                          },
                          widget.isArcadeMode, // Pass arcade mode flag
                        );
                      },
                      textStyle: TextStyle(fontSize: fontSize),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
