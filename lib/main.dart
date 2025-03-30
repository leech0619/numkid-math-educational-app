import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'app/utils/app_providers.dart';
import 'app/screen/home_screen.dart';
import 'app/utils/audio_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]); // Lock the orientation to portrait mode

  // Start the background music
  AudioService().playBackgroundMusic();

  runApp(
    MultiProvider(
      providers: appProviders, // Use the providers from app_providers.dart
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(
      this,
    ); // Add observer for app lifecycle events
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(
      this,
    ); // Remove observer when the widget is disposed
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Handle app lifecycle changes
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      // Pause the background music when the app is paused or closed
      AudioService().pauseBackgroundMusic();
    } else if (state == AppLifecycleState.resumed) {
      // Resume the background music when the app is resumed
      AudioService().resumeBackgroundMusic();
    }
  }

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
      home: const HomeScreen(), // Set the home screen of the app
    );
  }
}
