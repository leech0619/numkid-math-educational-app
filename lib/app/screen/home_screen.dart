import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/topic_button.dart';

import 'counting_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Define topics for the app
  final List<Map<String, dynamic>> topics = [
    {
      'title': 'Counting',
      'icon': Icons.looks_one_outlined,
      'color': Colors.green,
      'screen': CountingScreen(),
    },
    {
      'title': 'Comparing',
      'icon': Icons.looks_two_outlined,
      'color': Colors.red,
      'screen': HomeScreen(),
    },
    {
      'title': 'Ordering',
      'icon': Icons.looks_3_outlined,
      'color': Colors.orange,
      'screen': HomeScreen(),
    },
    {
      'title': 'Composing',
      'icon': Icons.looks_4_outlined,
      'color': Colors.purple,
      'screen': HomeScreen(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Extract theme data
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    return Scaffold(
      body: Stack(
        children: [
          // Background Image for Content
          Positioned.fill(
            top: 250, // Match the banner height
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/content_background.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Main Content
          Column(
            children: [
              // Banner Section with Custom Shape
              ClipPath(
                clipper: BannerClipper(),
                child: Container(
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/banner_background.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'NumKid',
                      style: textTheme.displayLarge?.copyWith(
                        fontSize: 64,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2.0, // Add some spacing between letters
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

              // Topics Grid
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 25,
                      mainAxisSpacing: 25,
                      childAspectRatio: 1, // Square buttons
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
                              builder: (context) => topics[index]['screen'],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Custom Clipper for Banner Shape
class BannerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // Start from top left
    path.lineTo(0, size.height - 50);

    // Create a curved bottom edge
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 50,
    );

    // Line to top right
    path.lineTo(size.width, 0);

    // Close the path
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
