import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/arcade_controller.dart';
import '../controller/counting_controller.dart';
import '../widgets/choice_button.dart';
import '../widgets/flip_card.dart';
import '../widgets/correct_dialog.dart';
import '../widgets/score_dialog.dart';
import 'game_screen_template.dart';

class CountingScreen extends StatefulWidget {
  final bool isArcadeMode; // Determines if the screen is in arcade mode
  final VoidCallback? onCorrect; // Callback for arcade mode navigation

  const CountingScreen({super.key, this.isArcadeMode = false, this.onCorrect});

  @override
  _CountingScreenState createState() => _CountingScreenState();
}

class _CountingScreenState extends State<CountingScreen> {
  @override
  void initState() {
    super.initState();

    // Reset the state when the screen is first opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Provider.of<CountingController>(
        context,
        listen: false,
      );
      controller.resetGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<CountingController>(context);
    final arcadeController = Provider.of<ArcadeController>(context);

    final Size screenSize = MediaQuery.of(context).size;
    final double fontSize = screenSize.width > 600 ? 30 : 20;

    return GameScreenTemplate(
      title:
          widget.isArcadeMode
              ? 'Score: ${arcadeController.score}' // Display current score in arcade mode
              : 'Counting', // Default title for topic mode
      appBarColor: Colors.green,
      showBackButton:
          !widget.isArcadeMode, // Show back button only in topic mode
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          // Flip card displaying the question
          FlipCardWidget(
            controller: controller.flipCardController,
            front: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 3),
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage(
                    'assets/numbers/${controller.question}.png',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            back: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: Colors.lightGreenAccent,
                border: Border.all(color: Colors.green, width: 3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  'Count the tigers!',
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          // Hint message for the user
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            color: Colors.white.withValues(alpha: 0.5),
            child: Text(
              'The number of tigers is ___.\n(Hint: Click on the image)',
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          // Grid of choice buttons
          Expanded(
            child: GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: screenSize.width > 600 ? 3 : 2,
              crossAxisSpacing: 40,
              mainAxisSpacing: 20,
              padding: const EdgeInsets.all(50),
              children: List.generate(controller.options.length, (index) {
                final option = controller.options[index];
                return ChoiceButton(
                  title:
                      controller.correctAnswers[index]
                          ? '✓'
                          : (option == -1 ? '❌' : option.toString()),
                  color:
                      controller.correctAnswers[index]
                          ? Colors.lightGreenAccent
                          : (option == -1 ? Colors.grey : Colors.green),
                  onPressed: () {
                    controller.handleButtonPress(
                      context,
                      option,
                      index,
                      () {
                        // Correct answer logic
                        if (widget.isArcadeMode) {
                          arcadeController
                              .increaseScore(); // Increment the score
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
                                    'The answer is ${controller.question}.',
                                dialogBackgroundColor: Colors.green,
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
                      widget.isArcadeMode,
                    );
                  },
                  textStyle: TextStyle(fontSize: fontSize),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
