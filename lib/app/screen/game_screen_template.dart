import 'package:flutter/material.dart';

class GameScreenTemplate extends StatelessWidget {
  final String title; // Title of the screen
  final Color appBarColor; // Color of the AppBar
  final Widget body; // Body of the screen
  final bool showBackButton; // Determines if the back button should be shown

  const GameScreenTemplate({
    super.key,
    required this.title,
    required this.appBarColor,
    required this.body,
    this.showBackButton = true, // Show back button only in topic mode
  });

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double appBarFontSize =
        screenSize.width > 600 ? 38 : 28; // Font size for AppBar title
    final double iconSize =
        screenSize.width > 600 ? 38 : 28; // Size of icons in AppBar
    final double toolbarHeight =
        screenSize.width > 600 ? 80 : 60; // Height of the AppBar

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading:
            showBackButton, // Show or hide the back button
        iconTheme: IconThemeData(
          color: Colors.white, // Color of the AppBar icons
          size: iconSize, // Size of the AppBar icons
        ),
        toolbarHeight: toolbarHeight, // Height of the AppBar
        backgroundColor: appBarColor, // Background color of the AppBar
        centerTitle: true, // Center the title in the AppBar
        title: Text(
          title, // Title text
          style: TextStyle(
            fontSize: appBarFontSize, // Font size of the title
            fontWeight: FontWeight.bold, // Font weight of the title
            color: Colors.white, // Color of the title text
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/content_background.jpg',
            ), // Background image for the body
            fit:
                BoxFit
                    .cover, // Fit the background image to cover the entire body
          ),
        ),
        child: body, // The main content of the screen
      ),
    );
  }
}
