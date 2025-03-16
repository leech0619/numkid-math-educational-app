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
    final Size screenSize = MediaQuery.of(context).size;
    final double titleFontSize = screenSize.width > 600 ? 30 : 24;
    final double contentFontSize = screenSize.width > 600 ? 24 : 20;
    final double buttonFontSize = screenSize.width > 600 ? 24 : 20;

    return AlertDialog(
      backgroundColor: dialogBackgroundColor,
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: titleFontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        content,
        style: TextStyle(color: Colors.white, fontSize: contentFontSize),
      ),
      actions: [
        TextButton(
          onPressed: onNewGame,
          style: TextButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            textStyle: TextStyle(fontSize: buttonFontSize),
          ),
          child: Text('New Game'),
        ),
        TextButton(
          onPressed: onHome,
          style: TextButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            textStyle: TextStyle(fontSize: buttonFontSize),
          ),
          child: Text('Home'),
        ),
      ],
    );
  }
}