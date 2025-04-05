import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class GameOverScreen extends StatelessWidget {
  final bool isWinner;
  final String wordToGuess;
  final VoidCallback onRestart;

  GameOverScreen({required this.isWinner, required this.wordToGuess, required this.onRestart});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isWinner
                ? Lottie.asset('assets/winner.json', width: 200, height: 200)
                : Lottie.asset('assets/lose.json', width: 200, height: 200),
            SizedBox(height: 20),
            Text(
              isWinner ? "🎉 Gratulacje! Odgadłeś hasło! 🎉" : "💀 Przegrałeś! Hasło to: $wordToGuess",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                textStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF0c4767),
                foregroundColor: Colors.white,
              ),
              onPressed: isWinner ? () => Navigator.pop(context, true) : onRestart,
              child: Text(
                isWinner ? "Powrót" : "Zagraj ponownie",
                style: TextStyle(fontSize: 18),
              ),
            )
          ],
        ),
      ),
    );
  }
}
