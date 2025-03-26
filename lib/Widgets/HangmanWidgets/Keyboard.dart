import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Keyboard extends StatelessWidget {
  final Function(String) onLetterPressed;
  final List<String> guessedLetters;
  final int lives;

  const Keyboard({super.key, required this.onLetterPressed, required this.guessedLetters, required this.lives});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12.0,
      runSpacing: 10.0,
      children: 'AĄBCĆDEĘFGHIJKLŁMNŃOÓPQRSŚTUVWXYZŻŹ'.split('').map((letter) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF0075c4),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: Colors.white, width: 2),
            ),
          ),
          onPressed: (lives > 0 && !guessedLetters.contains(letter)) ? () => onLetterPressed(letter) : null,
          child: Text(
            letter,
            style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        );
      }).toList(),
    );
  }
}