import 'package:flutter/material.dart';

class ChoiceButton extends StatelessWidget {
  final String title;
  final Color color;
  final TextStyle? textStyle;
  final VoidCallback onPressed;

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
            : 22;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 10,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
