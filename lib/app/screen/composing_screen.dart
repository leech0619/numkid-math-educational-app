import 'dart:math';
import 'package:flutter/material.dart';
import 'game_screen_template.dart';
import '../widgets/choice_button.dart';
import '../widgets/correct_dialog.dart';

class ComposingScreen extends StatefulWidget {
  const ComposingScreen({super.key});

  @override
  _ComposingScreenState createState() => _ComposingScreenState();
}

class _ComposingScreenState extends State<ComposingScreen> {
  late int targetNumber;
  late List<int> choices;
  List<int> selectedNumbers = [];
  late List<bool?> _correctAnswers;
  String _hintMessage = '';

  @override
  void initState() {
    super.initState();
    generateNewProblem();
  }

  // Generates a new problem with a target number and choices
  void generateNewProblem() {
    final random = Random();
    targetNumber = random.nextInt(100); // Random target number between 0 and 99

    // Generate two numbers that add up to the target number
    int num1 = random.nextInt(targetNumber + 1);
    int num2 = targetNumber - num1;

    // Ensure there are at least 6 unique numbers in the choices
    Set<int> uniqueNumbers = {num1, num2};
    while (uniqueNumbers.length < 6) {
      uniqueNumbers.add(random.nextInt(100));
    }
    choices = uniqueNumbers.toList()..shuffle();

    selectedNumbers.clear();
    _correctAnswers = List.filled(6, null);
    _hintMessage = '';
  }

  // Checks if the selected numbers add up to the target number
  void checkAnswer() {
    if (selectedNumbers.length == 2) {
      final sum = selectedNumbers[0] + selectedNumbers[1];
      final isCorrect = sum == targetNumber;
      showDialog(
        barrierDismissible: false,
        context: context,
        builder:
            (context) => CorrectDialog(
              title: isCorrect ? 'CORRECT!' : 'Try Again!',
              content:
                  isCorrect
                      ? 'You found the correct pair!'
                      : 'The sum of ${selectedNumbers[0]} and ${selectedNumbers[1]} is not $targetNumber.',
              dialogBackgroundColor: isCorrect ? Colors.green : Colors.red,
              onNewGame: () {
                Navigator.of(context).pop();
                setState(() {
                  generateNewProblem();
                });
              },
              onHome: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
      );
    }
  }

  // Handles button press events and updates the state accordingly
  void _handleButtonPress(BuildContext context, int number, int index) {
    if (selectedNumbers.contains(number)) {
      setState(() {
        selectedNumbers.remove(number);
      });
    } else {
      if (selectedNumbers.length < 2) {
        setState(() {
          selectedNumbers.add(number);
        });
      }
      if (selectedNumbers.length == 2) {
        final sum = selectedNumbers[0] + selectedNumbers[1];
        if (sum == targetNumber) {
          setState(() {
            _correctAnswers[choices.indexOf(selectedNumbers[0])] = true;
            _correctAnswers[choices.indexOf(selectedNumbers[1])] = true;
            _hintMessage = 'CORRECT!';
          });
          Future.delayed(Duration(seconds: 1), () {
            checkAnswer();
          });
        } else {
          setState(() {
            _correctAnswers[choices.indexOf(selectedNumbers[0])] = false;
            _correctAnswers[choices.indexOf(selectedNumbers[1])] = false;
            _hintMessage =
                'The sum of ${selectedNumbers[0]} and ${selectedNumbers[1]} is not $targetNumber.';
          });
          Future.delayed(Duration(seconds: 1), () {
            setState(() {
              _correctAnswers[choices.indexOf(selectedNumbers[0])] = null;
              _correctAnswers[choices.indexOf(selectedNumbers[1])] = null;
              selectedNumbers.clear();
            });
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;
        double fontSize =
            screenWidth > 600
                ? 30
                : screenWidth > 400
                ? 25
                : 20;
        double spacing = screenWidth > 600 ? 40 : 30;

        return GameScreenTemplate(
          title: 'Composing',
          appBarColor: Colors.purple,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: spacing),
              Container(
                padding: EdgeInsets.symmetric(horizontal: spacing),
                color: Colors.white.withValues(alpha: 0.8),
                child: Text(
                  'Select two numbers that add up to the target number.',
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: spacing),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.purpleAccent,
                ),
                child: Text(
                  'Target Number: $targetNumber',
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
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: screenWidth > 600 ? 4 : 3,
                crossAxisSpacing: spacing,
                mainAxisSpacing: spacing,
                padding: EdgeInsets.all(spacing),
                children: List.generate(choices.length, (index) {
                  final number = choices[index];
                  final isSelected = selectedNumbers.contains(number);
                  return ChoiceButton(
                    title:
                        _correctAnswers[index] == true
                            ? '✓'
                            : (_correctAnswers[index] == false
                                ? '❌'
                                : number.toString()),
                    color:
                        _correctAnswers[index] == true
                            ? Colors.lightGreenAccent
                            : (_correctAnswers[index] == false
                                ? Colors.grey
                                : (isSelected ? Colors.purple : Colors.grey)),
                    onPressed: () => _handleButtonPress(context, number, index),
                    textStyle: TextStyle(fontSize: fontSize),
                  );
                }),
              ),
              // Hint message for the user
              if (_hintMessage.isNotEmpty)
                Container(
                  color: Colors.white.withValues(alpha: 0.8),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Text(
                    _hintMessage,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color:
                          _hintMessage == 'CORRECT!'
                              ? Colors.green
                              : Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
