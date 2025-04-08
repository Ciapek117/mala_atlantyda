import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
            style: GoogleFonts.poppins(
              color: Color(0xFFefa00b),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            )));
  }
}
