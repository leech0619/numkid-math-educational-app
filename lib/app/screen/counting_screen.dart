import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'game_screen_template.dart';
import '../widgets/choice_button.dart';
import '../widgets/flip_card.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import '../widgets/correct_dialog.dart';

class CountingScreen extends StatefulWidget {
  const CountingScreen({super.key});

  @override
  _CountingScreenState createState() => _CountingScreenState();
}

class _CountingScreenState extends State<CountingScreen> {
  final FlipCardController _controller = FlipCardController();
  late List<int> _options;
  late int _question;
  late List<bool> _correctAnswers;

  @override
  void initState() {
    super.initState();
    _generateRandomNumbers();
  }

  // Generates random numbers for the options and selects a random question
  void _generateRandomNumbers() {
    final random = Random();
    final Set<int> uniqueNumbers = {};
    while (uniqueNumbers.length < 4) {
      uniqueNumbers.add(random.nextInt(20) + 1);
    }
    _options = uniqueNumbers.toList();
    _question = _options[random.nextInt(4)];
    _correctAnswers = List.filled(4, false);
  }

  // Handles button press events and checks if the selected option is correct
  void _handleButtonPress(BuildContext context, int option, int index) {
    if (option == _question) {
      setState(() {
        _correctAnswers[index] = true;
      });
      Future.delayed(Duration(seconds: 1), () {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CorrectDialog(
              title: 'CORRECT!',
              content: 'The answer is ${_options[index]}.',
              dialogBackgroundColor: Colors.green,
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
      setState(() {
        _options[index] = -1;
      });
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          _options[index] = option;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double fontSize = screenSize.width > 600 ? 30 : 20;

    return GameScreenTemplate(
      title: 'Counting',
      appBarColor: Colors.green,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          // Flip card displaying the question
          FlipCardWidget(
            controller: _controller,
            front: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 3),
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage('assets/numbers/$_question.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            back: Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
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
            padding: EdgeInsets.symmetric(horizontal: 10),
            color: Colors.white.withValues(alpha: 0.8),
            child: Text(
              'The number of tigers is ___.\n(Hint: Click on the image)',
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          // Grid of choice buttons
          Expanded(
            child: GridView.count(
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: screenSize.width > 600 ? 3 : 2,
              crossAxisSpacing: 40,
              mainAxisSpacing: 20,
              padding: EdgeInsets.all(50),
              children: List.generate(_options.length, (index) {
                final option = _options[index];
                return ChoiceButton(
                  title:
                      _correctAnswers[index]
                          ? '✓'
                          : (option == -1 ? '❌' : option.toString()),
                  color:
                      _correctAnswers[index]
                          ? Colors.lightGreenAccent
                          : (option == -1 ? Colors.grey : Colors.green),
                  onPressed: () => _handleButtonPress(context, option, index),
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
