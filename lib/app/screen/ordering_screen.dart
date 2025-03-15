import 'dart:math';
import 'package:flutter/material.dart';
import 'package:reorderables/reorderables.dart'; // Import the reorderables package
import 'game_screen_template.dart'; // Import the GameScreenTemplate
import 'package:collection/collection.dart'; // Import the collection package
import '../widgets/correct_dialog.dart'; // Import the CorrectDialog

class OrderingScreen extends StatefulWidget {
  const OrderingScreen({super.key});

  @override
  _OrderingScreenState createState() => _OrderingScreenState();
}

class _OrderingScreenState extends State<OrderingScreen> {
  late List<int> _numbers;
  late List<int> _originalNumbers;
  late bool _isAscending;

  @override
  void initState() {
    super.initState();
    _generateRandomNumbers();
  }

  void _generateRandomNumbers() {
    final random = Random();
    _numbers = List.generate(6, (_) => random.nextInt(100) + 1);
    _originalNumbers = List.from(_numbers);
    _numbers.shuffle();
    _isAscending = random.nextBool(); // Randomly set _isAscending to true or false
  }

  void _checkOrder() {
    List<int> sortedNumbers = List.from(_originalNumbers);
    if (!_isAscending) {
      sortedNumbers.sort((a, b) => b.compareTo(a));
    } else {
      sortedNumbers.sort((a, b) => a.compareTo(b));
    }

    if (ListEquality().equals(_numbers, sortedNumbers)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CorrectDialog(
            title: 'CORRECT!',
            content: 'You have arranged the numbers correctly.',
            dialogBackgroundColor: Colors.orange,
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
    } else {
      String hint = _generateHint(sortedNumbers);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Incorrect order. Hint: $hint')),
      );
    }
  }

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
      title: 'Ordering Numbers',
      appBarColor: Colors.orange,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 20), // Add some space below the AppBar
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            color: Colors.white.withOpacity(0.8),
            child: Text(
              'Arrange the numbers in ${_isAscending ? 'ascending' : 'descending'} order.',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: ReorderableWrap(
              needsLongPressDraggable: false,
              spacing: 10.0,
              runSpacing: 10.0,
              padding: EdgeInsets.all(20),
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
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: _checkOrder,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                textStyle: TextStyle(fontSize: 20),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: Text('Check Order'),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildNumberWidgets() {
    List<Widget> widgets = [];
    for (int i = 0; i < _numbers.length; i++) {
      widgets.add(_buildNumberWidget(_numbers[i]));
      if (i < _numbers.length - 1) {
        widgets.add(_buildArrowWidget());
      }
    }
    return widgets;
  }

  Widget _buildNumberWidget(int number) {
    return Container(
      key: ValueKey(number),
      width: 80,
      height: 80,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.orangeAccent,
        border: Border.all(color: Colors.orange, width: 3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          '$number',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildArrowWidget() {
    return Icon(
      _isAscending ? Icons.arrow_forward : Icons.arrow_back,
      color: Colors.orange,
      size: 30,
    );
  }
}