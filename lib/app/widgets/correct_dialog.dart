import 'package:flutter/material.dart';

class CorrectDialog extends StatelessWidget {
  final String title;
  final String content;
  final Color dialogBackgroundColor;
  final VoidCallback onNewGame;
  final VoidCallback onHome;

  const CorrectDialog({
    super.key,
    required this.title,
    required this.content,
    required this.dialogBackgroundColor,
    required this.onNewGame,
    required this.onHome,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: dialogBackgroundColor,
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 30,
          fontWeight: FontWeight.bold,
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
