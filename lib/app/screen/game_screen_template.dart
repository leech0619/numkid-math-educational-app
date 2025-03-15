import 'package:flutter/material.dart';

class GameScreenTemplate extends StatelessWidget {
  final String title;
  final Color appBarColor;
  final Widget body;

  const GameScreenTemplate({
    Key? key,
    required this.title,
    required this.appBarColor,
    required this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
          size: 38,
        ),
        toolbarHeight: 80,
        backgroundColor: appBarColor,
        centerTitle: true,
        title: Text(
          title,
          style: TextStyle(
            fontSize: 38,
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