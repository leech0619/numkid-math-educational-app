import 'package:flutter/material.dart';

class CorrectDialog extends StatelessWidget {
  final String title; // Title of the dialog
  final String content; // Content message of the dialog
  final Color dialogBackgroundColor; // Background color of the dialog
  final VoidCallback onNewGame; // Callback function for the "New Game" button
  final VoidCallback onHome; // Callback function for the "Home" button

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
    final double titleFontSize =
        screenSize.width > 600 ? 30 : 24; // Font size for the title
    final double contentFontSize =
        screenSize.width > 600 ? 24 : 20; // Font size for the content
    final double buttonFontSize =
        screenSize.width > 600 ? 24 : 20; // Font size for the buttons

    return AlertDialog(
      backgroundColor:
          dialogBackgroundColor, // Set the background color of the dialog
      title: Text(
        title, // Set the title of the dialog
        style: TextStyle(
          color: Colors.white, // Set the text color to white
          fontSize: titleFontSize, // Set the font size
          fontWeight: FontWeight.bold, // Set the font weight to bold
        ),
      ),
      content: Text(
        content, // Set the content message of the dialog
        style: TextStyle(
          color: Colors.white,
          fontSize: contentFontSize,
        ), // Set the text color and font size
      ),
      actions: [
        TextButton(
          onPressed:
              onNewGame, // Set the callback function for the "New Game" button
          style: TextButton.styleFrom(
            backgroundColor:
                Colors.blue, // Set the background color of the button
            foregroundColor: Colors.white, // Set the text color to white
            textStyle: TextStyle(fontSize: buttonFontSize), // Set the font size
          ),
          child: Text('New Game'), // Set the text of the button
        ),
        TextButton(
          onPressed: onHome, // Set the callback function for the "Home" button
          style: TextButton.styleFrom(
            backgroundColor:
                Colors.blue, // Set the background color of the button
            foregroundColor: Colors.white, // Set the text color to white
            textStyle: TextStyle(fontSize: buttonFontSize), // Set the font size
          ),
          child: Text('Home'), // Set the text of the button
        ),
      ],
    );
  }
}
