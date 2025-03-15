import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';

class FlipCardWidget extends StatelessWidget {
  final FlipCardController controller;
  final Widget front;
  final Widget back;

  const FlipCardWidget({
    Key? key,
    required this.controller,
    required this.front,
    required this.back,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlipCard(
      rotateSide: RotateSide.bottom,
      onTapFlipping: true, // When enabled, the card will flip automatically when touched.
      axis: FlipAxis.horizontal,
      controller: controller,
      frontWidget: Center(
        child: Container(
          height: 300,
          width: 180,
          child: front,
        ),
      ),
      backWidget: Center(
        child: Container(
          alignment: Alignment.center,
          height: 300,
          width: 180,
          child: back,
        ),
      ),
    );
  }
}