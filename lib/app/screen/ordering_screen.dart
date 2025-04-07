import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reorderables/reorderables.dart';
import '../controller/arcade_controller.dart';
import '../controller/ordering_controller.dart';
import '../widgets/correct_dialog.dart';
import '../widgets/score_dialog.dart';
import 'game_screen_template.dart';

class OrderingScreen extends StatefulWidget {
  final bool isArcadeMode; // Determines if the screen is in arcade mode
  final VoidCallback? onCorrect; // Callback for arcade mode navigation

  const OrderingScreen({super.key, this.isArcadeMode = false, this.onCorrect});

  @override
  _OrderingScreenState createState() => _OrderingScreenState();
}

class _OrderingScreenState extends State<OrderingScreen> {
  @override
  void initState() {
    super.initState();

    // Reset the state when the screen is first opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Provider.of<OrderingController>(
        context,
        listen: false,
      );
      controller.resetGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<OrderingController>(context);
    final arcadeController = Provider.of<ArcadeController>(context);

    final Size screenSize = MediaQuery.of(context).size;

    double spacing = screenSize.width > 600 ? 20.0 : 10.0;
    double runSpacing = screenSize.width > 600 ? 30.0 : 20.0;
    double padding = screenSize.width > 600 ? 60.0 : 30.0;
    double buttonWidth = screenSize.width > 600 ? 300.0 : 200.0;
    double buttonHeight = screenSize.width > 600 ? 80.0 : 60.0;
    double fontSize =
        screenSize.width > 600
            ? 30
            : screenSize.width > 400
            ? 25
            : 20;

    return GameScreenTemplate(
      title:
          widget.isArcadeMode
              ? 'Score: ${arcadeController.score}' // Display current score in arcade mode
              : 'Comparing', // Default title for topic mode
      appBarColor: Colors.orange,
      showBackButton:
          !widget.isArcadeMode, // Show back button only in topic mode
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.symmetric(horizontal: padding),
            color: Colors.white.withValues(alpha: 0.5),
            child: Text(
              'Arrange the numbers in ${controller.isAscending ? 'ascending' : 'descending'} order.',
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: ReorderableWrap(
              maxMainAxisCount: 3,
              alignment: WrapAlignment.center,
              needsLongPressDraggable: false,
              spacing: spacing,
              runSpacing: runSpacing,
              padding: EdgeInsets.fromLTRB(padding, 40, padding, 30),
              onReorder: controller.reorderNumbers,
              children:
                  controller.numbers
                      .map((number) => _buildNumberWidget(number))
                      .toList(),
            ),
          ),
          Container(
            padding: EdgeInsets.all(30),
            child: SizedBox(
              width: buttonWidth,
              height: buttonHeight,
              child: ElevatedButton(
                onPressed: () {
                  controller.checkOrder(
                    () {
                      // Correct answer logic
                      if (widget.isArcadeMode) {
                        arcadeController.increaseScore(); // Increment the score
                        if (widget.onCorrect != null) {
                          widget.onCorrect!();
                        }
                      } else {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return CorrectDialog(
                              title: 'CORRECT!',
                              content:
                                  'You have arranged the numbers correctly.',
                              dialogBackgroundColor: Colors.orange,
                              onNewGame: () {
                                Navigator.of(context).pop();
                                controller.generateRandomNumbers();
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
                                    .resetScore(); // Reset the score after navigating home
                              },
                            );
                          },
                        );
                      }
                    },
                    widget.isArcadeMode,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: controller.buttonColor,
                  foregroundColor: Colors.white,
                  textStyle: TextStyle(fontSize: 20),
                ),
                child: Text(controller.buttonText),
              ),
            ),
          ),
          Visibility(
            visible: controller.resultMessage.isNotEmpty,
            child: Container(
              color: Colors.white.withValues(alpha: 0.5),
              padding: EdgeInsets.all(10),
              alignment: Alignment.center,
              child: Text(
                controller.resultMessage,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: controller.resultMessageColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberWidget(int number) {
    return Container(
      key: ValueKey(number),
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.orangeAccent,
        border: Border.all(color: Colors.orange, width: 3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          '$number',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
