import 'package:flutter/material.dart';

class PongBall extends StatelessWidget {
  final x;
  final y;

  PongBall({this.x, this.y});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(x, y),
      child: Container(
        decoration:  BoxDecoration(shape: BoxShape.circle, color: Colors.purple),
        width: 20,
        height: 20,
      ),
    );
  }
}

/*
      child: Container(
        child: Positioned.fill(
          child: Transform.scale(
            scale: 2.0,
            child: Image.asset(
                "images/trojzab.png"),
          ),
        ),
        ),
        );

*/