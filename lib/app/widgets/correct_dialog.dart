import 'package:flutter/material.dart';

class CorrectDialog extends StatelessWidget {
  final String title;
  final String content;
  final Color BackgroundColor;
  final VoidCallback onNewGame;
  final VoidCallback onHome;

  const CorrectDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.BackgroundColor,
    required this.onNewGame,
    required this.onHome,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: BackgroundColor,
      title: Container(
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      content: Text(
        content,
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      actions: [
        TextButton(
          onPressed: onNewGame,
          style: TextButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            textStyle: TextStyle(fontSize: 20),
          ),
          child: Text('New Game'),
        ),
        TextButton(
          onPressed: onHome,
          style: TextButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            textStyle: TextStyle(fontSize: 20),
          ),
          child: Text('Home'),
        ),
      ],
    );
  }
}
