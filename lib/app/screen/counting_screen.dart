import 'package:flutter/material.dart';
import 'package:numkid/app/screen/home_screen.dart';
import 'topic_screen_template.dart'; // Import the TopicScreenTemplate

class CountingScreen extends StatelessWidget {
  const CountingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TopicScreenTemplate(
      title: 'Counting',
      appBarColor: Colors.green, // Pass the color for the app bar
      exercises: [
        {
          'title': 'Exercise 1',
          'onPressed': () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
        },
        {
          'title': 'Exercise 2',
          'onPressed': () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
        },
        // Add more exercises as needed
      ],
    );
  }
}