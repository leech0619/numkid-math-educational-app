import 'package:flutter/material.dart';

class TopicButton extends StatelessWidget {
  final String title; // Title of the button
  final IconData icon; // Icon to be displayed on the button
  final Color color; // Background color of the button
  final TextStyle? textStyle; // Text style for the button title
  final VoidCallback onPressed; // Callback function when the button is pressed

  const TopicButton({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    this.textStyle,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double iconSize =
        screenSize.width > 600 ? 80 : 60; // Icon size based on screen width
    final double fontSize =
        screenSize.width > 600
            ? 26
            : screenSize.width > 400
            ? 22
            : 18; // Font size based on screen width

    return ElevatedButton(
      onPressed: onPressed, // Set the callback function for button press
      style: ElevatedButton.styleFrom(
        backgroundColor: color, // Set the background color of the button
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ), // Set the shape and border radius of the button
        elevation: 10, // Set the elevation of the button
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: iconSize,
            color: Colors.white,
          ), // Set the icon of the button
          SizedBox(height: 15), // Add spacing between the icon and the title
          Text(
            title, // Set the title of the button
            style: TextStyle(
              color: Colors.white, // Set the text color to white
              fontSize: fontSize, // Set the font size
              fontWeight: FontWeight.bold, // Set the font weight to bold
            ),
          ),
        ],
      ),
    );
  }
}
