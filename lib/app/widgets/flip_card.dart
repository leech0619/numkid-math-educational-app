import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';

class FlipCardWidget extends StatelessWidget {
  final FlipCardController controller; // Controller for the flip card
  final Widget front; // Front widget of the flip card
  final Widget back; // Back widget of the flip card

  const FlipCardWidget({
    super.key,
    required this.controller,
    required this.front,
    required this.back,
  });

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double cardHeight =
        screenSize.height * 0.33; // Height of the flip card
    final double cardWidth = screenSize.width * 0.4; // Width of the flip card

    return FlipCard(
      rotateSide: RotateSide.bottom, // Set the side to rotate from
      onTapFlipping: true, // Enable flipping on tap
      axis: FlipAxis.horizontal, // Set the flip axis to horizontal
      controller: controller, // Set the flip card controller
      frontWidget: Center(
        child: Container(
          alignment: Alignment.center,
          height: cardHeight,
          width: cardWidth,
          child: front, // Set the front widget of the flip card
        ),
      ),
      backWidget: Center(
        child: Container(
          alignment: Alignment.center,
          height: cardHeight,
          width: cardWidth,
          child: back, // Set the back widget of the flip card
        ),
      ),
    );
  }
}
