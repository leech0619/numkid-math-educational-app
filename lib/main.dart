import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app/screen/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]); // Lock the orientation to portrait mode
  runApp(const MyApp()); // Run the MyApp widget
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme =
        GoogleFonts.andikaTextTheme(); // Use Google Fonts for text theme

    final ThemeData theme = ThemeData(
      textTheme: textTheme, // Set the text theme
      primarySwatch: Colors.blue, // Set the primary color swatch
    );

    return MaterialApp(
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        scrollbars: false,
      ), // Disable scrollbars
      debugShowCheckedModeBanner: false, // Disable the debug banner
      title: 'NumKid', // Set the title of the app
      theme: theme, // Set the theme of the app
      home: HomeScreen(), // Set the home screen of the app
    );
  }
}
