import 'package:flutter/material.dart';

class GameScreenTemplate extends StatelessWidget {
  final String title;
  final Color appBarColor;
  final Widget body;

  const GameScreenTemplate({
    super.key,
    required this.title,
    required this.appBarColor,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double appBarFontSize = screenSize.width > 600 ? 38 : 28;
    final double iconSize = screenSize.width > 600 ? 38 : 28;
    final double toolbarHeight = screenSize.width > 600 ? 80 : 60;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
          size: iconSize,
        ),
        toolbarHeight: toolbarHeight,
        backgroundColor: appBarColor,
        centerTitle: true,
        title: Text(
          title,
          style: TextStyle(
            fontSize: appBarFontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/content_background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: body,
      ),
    );
  }
}