import 'package:flutter/material.dart';

class ChoiceButton extends StatelessWidget {
  final String title; // Title of the button
  final Color color; // Background color of the button
  final TextStyle? textStyle; // Text style for the button title
  final VoidCallback onPressed; // Callback function when the button is pressed

  const ChoiceButton({
    super.key,
    required this.title,
    required this.color,
    this.textStyle,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double fontSize =
        screenSize.width > 600
            ? 45
            : screenSize.width > 400
            ? 30
            : 22; // Font size based on screen width

    return ElevatedButton(
      onPressed: onPressed, // Set the callback function for button press
      style: ElevatedButton.styleFrom(
        backgroundColor: color, // Set the background color of the button
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ), // Set the shape and border radius of the button
        elevation: 10, // Set the elevation of the button
        padding: EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 20,
        ), // Set the padding inside the button
      ),
      child: Center(
        child: Text(
          title, // Set the title of the button
          style: TextStyle(
            color: Colors.white, // Set the text color to white
            fontSize: fontSize, // Set the font size
            fontWeight: FontWeight.bold, // Set the font weight to bold
          ),
        ),
      ),
    );
  }
}
