import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/arcade_controller.dart';
import '../utils/audio_service.dart';

/// Arcade screen for displaying the arcade mode UI.
class ArcadeScreen extends StatefulWidget {
  const ArcadeScreen({Key? key}) : super(key: key);

  @override
  State<ArcadeScreen> createState() => _ArcadeScreenState();
}

class _ArcadeScreenState extends State<ArcadeScreen>
    with SingleTickerProviderStateMixin {
  final AudioService _audioService = AudioService(); // Audio service instance
  late AnimationController _animationController; // Animation controller

  @override
  void initState() {
    super.initState();
    // Load the highest score when the screen is opened
    final arcadeController = Provider.of<ArcadeController>(
      context,
      listen: false,
    );
    arcadeController.loadHighestScore();
    _audioService.playArcadeMusic();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    // Revert to background music when the screen is closed
    _audioService.playBackgroundMusic();
    _animationController.dispose();
    super.dispose();
  }

  /// Starts arcade mode by navigating to a random game.
  void _startArcadeMode(BuildContext context) {
    final arcadeController = Provider.of<ArcadeController>(
      context,
      listen: false,
    );

    // Use the ArcadeController to select a random game
    final selectedGame = arcadeController.selectRandomGame(
      context,
      () => _startArcadeMode(context), // Callback for correct answer
    );

    // Navigate to the selected game screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => ChangeNotifierProvider(
              create: (_) => selectedGame['controller'] as ChangeNotifier,
              child: selectedGame['screen'] as Widget,
            ),
      ),
    ).then((_) {
      // Reset arcade mode when returning to this screen
      _audioService.playArcadeMusic();
    });
  }

  @override
  Widget build(BuildContext context) {
    final arcadeController = Provider.of<ArcadeController>(context);

    // Get screen size for responsive UI
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;

    // Define responsive sizes
    final double titleFontSize = screenWidth > 600 ? 50 : 32;
    final double buttonFontSize = screenWidth > 600 ? 24 : 20;
    final double buttonPaddingVertical = screenWidth > 600 ? 20 : 15;
    final double buttonPaddingHorizontal = screenWidth > 600 ? 60 : 50;
    final double spacing = screenWidth > 600 ? 40 : 30;

    return Scaffold(
      body: Stack(
        children: [
          // Background Image with Gradient Overlay
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/arcade_background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black54, Colors.black87],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          // Main Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Title
                ScaleTransition(
                  scale: Tween(
                    begin: 1.0,
                    end: 1.2,
                  ).animate(_animationController),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: ShaderMask(
                      shaderCallback:
                          (bounds) => const LinearGradient(
                            colors: [Colors.yellow, Colors.orange],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds),
                      child: Text(
                        'Are you ready for the challenges?',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.bebasNeue(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.black,
                              offset: Offset(2.0, 2.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: spacing),
                // Highest Score Display
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.yellow.withValues(alpha: 0.5),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Text(
                    'Highest Score: ${arcadeController.highestScore}',
                    style: GoogleFonts.robotoMono(
                      fontSize: buttonFontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: spacing),
                // Start Button
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: buttonPaddingVertical,
                      horizontal: buttonPaddingHorizontal,
                    ),
                    backgroundColor: Colors.yellow,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 10,
                    shadowColor: Colors.yellowAccent,
                  ),
                  onPressed: () => _startArcadeMode(context),
                  icon: const Icon(
                    Icons.play_arrow,
                    color: Colors.black,
                    size: 28,
                  ),
                  label: Text(
                    'Start',
                    style: TextStyle(
                      fontSize: buttonFontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: spacing),
                // Back Button
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: buttonPaddingVertical,
                      horizontal: buttonPaddingHorizontal,
                    ),
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    side: const BorderSide(color: Colors.yellow, width: 3),
                    elevation: 10,
                    shadowColor: Colors.yellowAccent,
                  ),
                  onPressed: () {
                    Navigator.of(
                      context,
                    ).pop(); // Navigate back to the home screen
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.yellow,
                    size: 28,
                  ),
                  label: Text(
                    'Back',
                    style: TextStyle(
                      fontSize: buttonFontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.yellow,
                    ),
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
