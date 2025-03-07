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
          Icon(icon, size: 60, color: Colors.white),
          SizedBox(height: 15),
          Text(
            title,
            style: textStyle?.copyWith(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}