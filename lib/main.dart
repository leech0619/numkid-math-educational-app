import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app/screen/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of application.
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = GoogleFonts.andikaTextTheme();

    final ThemeData theme = ThemeData(
      textTheme: textTheme,
      primarySwatch: Colors.blue,
    );

    return MaterialApp(
      scrollBehavior: const MaterialScrollBehavior().copyWith(scrollbars: false),
      debugShowCheckedModeBanner: false,
      title: 'NumKid',
      theme: theme,
      home: HomeScreen(),
    );
  }
}


