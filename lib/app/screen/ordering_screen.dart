import 'dart:math';
import 'package:flutter/material.dart';
import 'package:reorderables/reorderables.dart';
import 'game_screen_template.dart';
import 'package:collection/collection.dart';
import '../widgets/correct_dialog.dart';

class OrderingScreen extends StatefulWidget {
  const OrderingScreen({super.key});

  @override
  _OrderingScreenState createState() => _OrderingScreenState();
}

class _OrderingScreenState extends State<OrderingScreen> {
  late List<int> _numbers; // List of numbers to be ordered
  late List<int> _originalNumbers; // Original list of numbers
  late bool _isAscending; // Boolean to determine if the order is ascending
  String _resultMessage = ''; // Result message to display
  Color _resultMessageColor = Colors.transparent; // Color of the result message
  String _buttonText = 'Check Order'; // Text of the check order button
  Color _buttonColor = Colors.orange; // Color of the check order button

  @override
  void initState() {
    super.initState();
    _generateRandomNumbers(); // Generate random numbers when the screen is initialized
  }

  // Generates a list of random numbers and shuffles them
  void _generateRandomNumbers() {
    final random = Random();
    final Set<int> uniqueNumbers = {};
    while (uniqueNumbers.length < 9) {
      uniqueNumbers.add(random.nextInt(100) + 1);
    }
    _numbers = uniqueNumbers.toList();
    _originalNumbers = List.from(_numbers);
    _numbers.shuffle();
    _isAscending = random.nextBool();
  }

  // Checks if the numbers are in the correct order
  void _checkOrder() {
    List<int> sortedNumbers = List.from(_originalNumbers);
    if (!_isAscending) {
      sortedNumbers.sort((a, b) => b.compareTo(a));
    } else {
      sortedNumbers.sort((a, b) => a.compareTo(b));
    }

    if (ListEquality().equals(_numbers, sortedNumbers)) {
      setState(() {
        _resultMessage = 'Correct!';
        _resultMessageColor = Colors.green;
        _buttonText = '✓';
        _buttonColor = Colors.lightGreenAccent;
      });
      Future.delayed(Duration(seconds: 1), () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return CorrectDialog(
              title: 'CORRECT!',
              content: 'You have arranged the numbers correctly.',
              dialogBackgroundColor: Colors.orange,
              onNewGame: () {
                Navigator.of(context).pop();
                setState(() {
                  _generateRandomNumbers();
                  _resultMessage = '';
                  _resultMessageColor = Colors.transparent;
                  _buttonText = 'Check Order';
                  _buttonColor = Colors.orange;
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
      String hint = _generateHint(sortedNumbers);
      setState(() {
        _resultMessage = 'Hint: $hint';
        _resultMessageColor = Colors.red;
        _buttonText = '❌';
        _buttonColor = Colors.grey;
      });
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          _buttonText = 'Check Order';
          _buttonColor = Colors.orange;
        });
      });
    }
  }

  // Generates a hint message to help the user
  String _generateHint(List<int> sortedNumbers) {
    for (int i = 0; i < _numbers.length - 1; i++) {
      if (_isAscending) {
        if (_numbers[i] > _numbers[i + 1]) {
          return '${_numbers[i]} should be before ${_numbers[i + 1]}';
        }
      } else {
        if (_numbers[i] < _numbers[i + 1]) {
          return '${_numbers[i]} should be after ${_numbers[i + 1]}';
        }
      }
    }
    return 'Check the order again.';
  }

  @override
  Widget build(BuildContext context) {
    return GameScreenTemplate(
      title: 'Ordering',
      appBarColor: Colors.orange,
      body: LayoutBuilder(
        builder: (context, constraints) {
          double spacing = constraints.maxWidth > 600 ? 20.0 : 10.0;
          double runSpacing = constraints.maxWidth > 600 ? 30.0 : 20.0;
          double padding = constraints.maxWidth > 600 ? 60.0 : 30.0;
          double buttonWidth = constraints.maxWidth > 600 ? 300.0 : 200.0;
          double buttonHeight = constraints.maxWidth > 600 ? 80.0 : 60.0;
          double fontSize =
              constraints.maxWidth > 600
                  ? 30
                  : constraints.maxWidth > 400
                  ? 25
                  : 20;
          double resultFontSize =
              constraints.maxWidth > 600
                  ? 30
                  : constraints.maxWidth > 400
                  ? 25
                  : 20;

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: padding),
                color: Colors.white.withValues(alpha: 0.8),
                child: Text(
                  'Arrange the numbers in ${_isAscending ? 'ascending' : 'descending'} order.',
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                  ),
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
                  children: _buildNumberWidgets(),
                  onReorder: (int oldIndex, int newIndex) {
                    setState(() {
                      if (newIndex > oldIndex) {
                        newIndex -= 1;
                      }
                      final int item = _numbers.removeAt(oldIndex);
                      _numbers.insert(newIndex, item);
                    });
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(30),
                child: SizedBox(
                  width: buttonWidth,
                  height: buttonHeight,
                  child: ElevatedButton(
                    onPressed: _checkOrder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _buttonColor,
                      foregroundColor: Colors.white,
                      textStyle: TextStyle(fontSize: 20),
                    ),
                    child: Text(_buttonText),
                  ),
                ),
              ),
              Visibility(
                visible: _resultMessage.isNotEmpty,
                child: Container(
                  color: Colors.white.withValues(alpha: 0.8),
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.center,
                  child: Text(
                    _resultMessage,
                    style: TextStyle(
                      fontSize: resultFontSize,
                      fontWeight: FontWeight.bold,
                      color: _resultMessageColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Builds the list of number widgets
  List<Widget> _buildNumberWidgets() {
    return _numbers.map((number) => _buildNumberWidget(number)).toList();
  }

  // Builds a single number widget
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
