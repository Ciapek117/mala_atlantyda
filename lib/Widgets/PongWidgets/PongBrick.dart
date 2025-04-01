import 'package:flutter/material.dart';

class PongBrick extends StatelessWidget {
  final double x;
  final double y;
  final brickWidth;

  PongBrick({required this.x, required this.y, this.brickWidth = 0.4});

  @override
  Widget build(BuildContext context) {
    return Container(alignment: Alignment((2 * x + brickWidth) / (2 - brickWidth), y),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          color: Color(0xFFEFA00B),
          height: 20,
          width: MediaQuery.of(context).size.width / 5,
        ),
      ),
    );
  }
}
