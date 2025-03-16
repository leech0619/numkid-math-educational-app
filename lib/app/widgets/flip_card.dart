import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';

class FlipCardWidget extends StatelessWidget {
  final FlipCardController controller;
  final Widget front;
  final Widget back;

  const FlipCardWidget({
    super.key,
    required this.controller,
    required this.front,
    required this.back,
  });

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double cardHeight = screenSize.height * 0.33;
    final double cardWidth = screenSize.width * 0.4;

    return FlipCard(
      rotateSide: RotateSide.bottom,
      onTapFlipping: true, // When enabled, the card will flip automatically when touched.
      axis: FlipAxis.horizontal,
      controller: controller,
      frontWidget: Center(
        child: Container(
          alignment: Alignment.center,
          height: cardHeight,
          width: cardWidth,
          child: front,
        ),
      ),
      backWidget: Center(
        child: Container(
          alignment: Alignment.center,
          height: cardHeight,
          width: cardWidth,
          child: back,
        ),
      ),
    );
  }
}