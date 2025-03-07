import 'package:flutter/material.dart';
import '../widgets/exercise_button.dart'; // Import the ExerciseButton

class TopicScreenTemplate extends StatelessWidget {
  final String title;
  final Color appBarColor;
  final List<Map<String, dynamic>> exercises;

  const TopicScreenTemplate({
    Key? key,
    required this.title,
    required this.appBarColor,
    required this.exercises,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(70),
            bottomRight: Radius.circular(70),
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white, size: 55),
        backgroundColor: appBarColor,
        centerTitle: true,
        toolbarHeight: 140.0,
        title: Text(
          title,
          style: textTheme.titleLarge?.copyWith(
            fontSize: 50,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/content_background.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: exercises.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ExerciseButton(
                          title: exercises[index]['title'],
                          onPressed: exercises[index]['onPressed'],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
