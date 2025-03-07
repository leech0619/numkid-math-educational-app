import 'package:flutter/material.dart';

class ExerciseButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const ExerciseButton({
    Key? key,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(title),
    );
  }
}