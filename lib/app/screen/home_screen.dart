import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:numkid/app/screen/comparing_screen.dart';
import 'package:numkid/app/screen/composing_screen.dart';
import 'package:numkid/app/screen/ordering_screen.dart';
import 'package:numkid/app/screen/arcade_screen.dart';
import '../widgets/topic_button.dart';
import 'counting_screen.dart';
import '../controller/comparing_controller.dart';
import '../controller/composing_controller.dart';
import '../controller/ordering_controller.dart';
import '../controller/counting_controller.dart';
import '../controller/arcade_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // List of topics with their respective titles, icons, colors, screens, and controllers
  final List<Map<String, dynamic>> topics = [
    {
      'title': 'Counting',
      'icon': Icons.looks_one_outlined,
      'color': Colors.green,
      'screen': CountingScreen(),
      'controller': CountingController(),
    },
    {
      'title': 'Comparing',
      'icon': Icons.looks_two_outlined,
      'color': Colors.red,
      'screen': ComparingScreen(),
      'controller': ComparingController(),
    },
    {
      'title': 'Ordering',
      'icon': Icons.looks_3_outlined,
      'color': Colors.orange,
      'screen': OrderingScreen(),
      'controller': OrderingController(),
    },
    {
      'title': 'Composing',
      'icon': Icons.looks_4_outlined,
      'color': Colors.purple,
      'screen': ComposingScreen(),
      'controller': ComposingController(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Background image for the content area
          Positioned.fill(
            top: screenSize.height * 0.1,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/content_background.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Column(
            children: [
              // Banner at the top of the screen
              ClipPath(
                clipper: BannerClipper(),
                child: Container(
                  width: double.infinity,
                  height: screenSize.height * 0.3,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/banner_background.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'NumKid',
                      style: TextStyle(
                        fontSize: screenSize.width * 0.14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2.0,
                        foreground:
                            Paint()
                              ..shader = LinearGradient(
                                colors: [
                                  Colors.blue.shade300,
                                  Colors.blue.shade400,
                                  Colors.blue.shade500,
                                  Colors.blue.shade600,
                                ],
                              ).createShader(
                                Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
              // Grid of topic buttons
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: screenSize.width > 600 ? 3 : 2,
                      crossAxisSpacing: 25,
                      mainAxisSpacing: 25,
                      childAspectRatio: 1,
                    ),
                    itemCount: topics.length,
                    itemBuilder: (context, index) {
                      return TopicButton(
                        title: topics[index]['title'],
                        icon: topics[index]['icon'],
                        color: topics[index]['color'],
                        textStyle: textTheme.titleLarge,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => Builder(
                                    builder:
                                        (newContext) => ChangeNotifierProvider(
                                          create:
                                              (_) =>
                                                  topics[index]['controller']
                                                      as ChangeNotifier,
                                          child: topics[index]['screen'],
                                        ),
                                  ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              // Arcade Mode Button (outside Expanded)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 45,
                    ),
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    side: const BorderSide(color: Colors.yellow, width: 3),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => ChangeNotifierProvider(
                              create: (_) => ArcadeController(),
                              child: const ArcadeScreen(),
                            ),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.videogame_asset,
                        color: Colors.yellow,
                        size: 30,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Arcade Mode',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.yellow,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Footer with developer information
              Container(
                decoration: BoxDecoration(
                  color: Colors.lightBlueAccent.shade100,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Developed by Chorng Huah. All rights reserved.',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 5),
            ],
          ),
        ],
      ),
    );
  }
}

// Custom clipper for the banner at the top of the screen
class BannerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0, size.height - 50);

    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 50,
    );

    path.lineTo(size.width, 0);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
