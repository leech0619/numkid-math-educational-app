import 'package:flutter/material.dart';

class TopicButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final TextStyle? textStyle;
  final VoidCallback onPressed;

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
    final double iconSize = screenSize.width > 600 ? 80 : 60;
    final double fontSize =
        screenSize.width > 600
            ? 30
            : screenSize.width > 400
            ? 25
            : 18;
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 10,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: iconSize, color: Colors.white),
          SizedBox(height: 15),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
