import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LivesDisplay extends StatelessWidget {
  final int lives;

  LivesDisplay({required this.lives});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: GoogleFonts.poppins(
          textStyle: TextStyle(
            fontSize: 30,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        children: [
          TextSpan(text: "Życia: $lives "),
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Image.asset(
              'images/mcHeart.png',
              width: 30,
              height: 30,
            ),
          ),
        ],
      ),
    );
  }
}