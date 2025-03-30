import 'package:flutter/material.dart';

/// Displays a dialog showing the player's score and a button to return home.
class ScoreDialog extends StatelessWidget {
  final String title; // Title of the dialog
  final int score; // The player's score
  final VoidCallback onHome; // Callback for the "Home" button

  const ScoreDialog({
    Key? key,
    required this.title,
    required this.score,
    required this.onHome,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double titleFontSize =
        screenSize.width > 600 ? 36 : 28; // Responsive title font size
    final double contentFontSize =
        screenSize.width > 600 ? 28 : 22; // Responsive content font size
    final double buttonFontSize =
        screenSize.width > 600 ? 24 : 20; // Responsive button font size

    return AlertDialog(
      backgroundColor: Colors.black, // Black background for arcade style
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // Rounded corners
        side: const BorderSide(color: Colors.yellow, width: 3), // Yellow border
      ),
      title: Center(
        child: Text(
          title, // Dialog title
          style: TextStyle(
            color: Colors.yellow, // Yellow text color
            fontSize: titleFontSize,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                blurRadius: 10.0,
                color: Colors.orange,
                offset: Offset(2.0, 2.0),
              ),
            ],
          ),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Score: $score', // Display the player's score
            style: TextStyle(
              color: Colors.white,
              fontSize: contentFontSize,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  blurRadius: 5.0,
                  color: Colors.blue,
                  offset: Offset(1.0, 1.0),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Return to home screen!', // Instruction text
            style: TextStyle(
              color: Colors.greenAccent,
              fontSize: contentFontSize - 4,
              fontWeight: FontWeight.w600,
              shadows: [
                Shadow(
                  blurRadius: 5.0,
                  color: Colors.green,
                  offset: Offset(1.0, 1.0),
                ),
              ],
            ),
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        // Home Button
        ElevatedButton(
          onPressed: onHome, // Navigate to home screen
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, // Blue button background
            foregroundColor: Colors.white, // White text
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 10,
            shadowColor: Colors.blueAccent,
          ),
          child: Text(
            'Home', // Button text
            style: TextStyle(
              fontSize: buttonFontSize,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  blurRadius: 5.0,
                  color: Colors.white,
                  offset: Offset(1.0, 1.0),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
