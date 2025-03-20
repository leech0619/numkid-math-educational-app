import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'game_screen_template.dart'; // Import the GameScreenTemplate
import '../widgets/choice_button.dart'; // Import the ChoiceButton
import '../widgets/flip_card.dart'; // Import the FlipCardWidget
import 'package:flutter_flip_card/flutter_flip_card.dart'; // Import the flutter_flip_card package
import '../widgets/correct_dialog.dart'; // Import the CorrectDialog

class ComparingScreen extends StatefulWidget {
  const ComparingScreen({super.key});

  @override
  _ComparingScreenState createState() => _ComparingScreenState();
}

class _ComparingScreenState extends State<ComparingScreen> {
  final FlipCardController _controller1 = FlipCardController();
  final FlipCardController _controller2 = FlipCardController();
  late int _question1;
  late int _question2;
  late List<String> _buttonStates;

  @override
  void initState() {
    super.initState();
    _generateRandomNumbers();
  }

  void _generateRandomNumbers() {
    final random = Random();
    _question1 = random.nextInt(20) + 1;
    _question2 = random.nextInt(20) + 1;
    _buttonStates = List.filled(3, ''); // Initialize button states
  }

  void _handleButtonPress(BuildContext context, String option, int index) {
    bool isCorrect = false;
    String comparison = '';
    if (option == 'Greater than' && _question1 > _question2) {
      isCorrect = true;
      comparison = 'greater than';
    } else if (option == 'Less than' && _question1 < _question2) {
      isCorrect = true;
      comparison = 'less than';
    } else if (option == 'Equal To' && _question1 == _question2) {
      isCorrect = true;
      comparison = 'equal to';
    }

    if (isCorrect) {
      // Correct answer
      setState(() {
        _buttonStates[index] = '✓';
      });
      Future.delayed(Duration(seconds: 1), () {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CorrectDialog(
              title: 'CORRECT!',
              content: '$_question1 is $comparison $_question2.',
              dialogBackgroundColor: Colors.red,
              onNewGame: () {
                Navigator.of(context).pop();
                setState(() {
                  _generateRandomNumbers();
                });
              },
              onHome: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            );
          },
        );
      });
    } else {
      // Incorrect answer
      HapticFeedback.vibrate();
      setState(() {
        _buttonStates[index] = '❌'; // Indicate incorrect answer
      });
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          _buttonStates[index] = ''; // Revert back to original state
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double fontSize = screenSize.width > 600 ? 30 : 20;
    final double flipFont = screenSize.width > 600 ? 40 : 30;
    final double buttonWidth = screenSize.width > 600 ? 320 : 280;
    final double buttonHeight = screenSize.width > 600 ? 90 : 70;

    return GameScreenTemplate(
      title: 'Comparing',
      appBarColor: Colors.red,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 20), // Add some space below the AppBar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FlipCardWidget(
                controller: _controller1,
                front: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    color: Colors.redAccent[100],
                    border: Border.all(color: Colors.red, width: 3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      '$_question1',
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
                      image: AssetImage('assets/numbers/$_question1.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              FlipCardWidget(
                controller: _controller2,
                front: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    color: Colors.redAccent[100],
                    border: Border.all(color: Colors.red, width: 3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      '$_question2',
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
                      image: AssetImage('assets/numbers/$_question2.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            color: Colors.white.withValues(alpha: 0.8),
            child: Text(
              '$_question1 is ______ $_question2\n(Hint: Click on the image)',
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: buttonWidth,
                  height: buttonHeight,
                  child: ChoiceButton(
                    title:
                        _buttonStates[0] == ''
                            ? 'Greater than'
                            : _buttonStates[0],
                    color:
                        _buttonStates[0] == '✓'
                            ? Colors.lightGreenAccent
                            : (_buttonStates[0] == '❌'
                                ? Colors.grey
                                : Colors.red),
                    onPressed:
                        () => _handleButtonPress(context, 'Greater than', 0),
                    textStyle: TextStyle(fontSize: fontSize),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: buttonWidth,
                  height: buttonHeight,
                  child: ChoiceButton(
                    title:
                        _buttonStates[1] == '' ? 'Less than' : _buttonStates[1],
                    color:
                        _buttonStates[1] == '✓'
                            ? Colors.lightGreenAccent
                            : (_buttonStates[1] == '❌'
                                ? Colors.grey
                                : Colors.red),
                    onPressed:
                        () => _handleButtonPress(context, 'Less than', 1),
                    textStyle: TextStyle(fontSize: fontSize),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: buttonWidth,
                  height: buttonHeight,
                  child: ChoiceButton(
                    title:
                        _buttonStates[2] == '' ? 'Equal To' : _buttonStates[2],
                    color:
                        _buttonStates[2] == '✓'
                            ? Colors.lightGreenAccent
                            : (_buttonStates[2] == '❌'
                                ? Colors.grey
                                : Colors.red),
                    onPressed: () => _handleButtonPress(context, 'Equal To', 2),
                    textStyle: TextStyle(fontSize: fontSize),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
