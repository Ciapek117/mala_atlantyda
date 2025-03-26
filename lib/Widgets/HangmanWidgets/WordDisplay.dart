import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WordDisplay extends StatelessWidget {
  final List<String> wordGuessed;

  WordDisplay({required this.wordGuessed});

  @override
  Widget build(BuildContext context) {
    return Text(
      wordGuessed.join(" "),
      style: GoogleFonts.poppins(
        textStyle: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Color(0xFFefa00b)),
      ),
    );
  }
}
