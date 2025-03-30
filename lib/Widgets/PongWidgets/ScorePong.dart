import 'package:flutter/material.dart';

class ScorePong extends StatelessWidget {
  final score;

  ScorePong({this.score});

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: 40,
        left: 0,
        right: 0,
        child: Text(
            "Punkty: $score",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFFefa00b),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            )));
  }
}
