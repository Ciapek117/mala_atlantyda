import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class HangmanGame extends StatefulWidget {
  @override
  _HangmanGameState createState() => _HangmanGameState();
}

class _HangmanGameState extends State<HangmanGame> {
  final String wordToGuess = "FLUTTER";
  late List<String> wordGuessed;
  int lives = 6;
  bool isGameOver = false;
  bool isWinner = false;

  @override
  void initState() {
    super.initState();
    wordGuessed = List.generate(wordToGuess.length, (index) => "*");
  }

  void guessLetter(String letter) {
    if (isGameOver) return;

    setState(() {
      bool found = false;
      for (int i = 0; i < wordToGuess.length; i++) {
        if (wordToGuess[i] == letter) {
          wordGuessed[i] = letter;
          found = true;
        }
      }
      if (!found) {
        lives--;
      }
      if (!wordGuessed.contains("*")) {
        isGameOver = true;
        isWinner = true;
      } else if (lives <= 0) {
        isGameOver = true;
        isWinner = false;
      }
    });
  }

  void resetGame() {
    setState(() {
      wordGuessed = List.generate(wordToGuess.length, (index) => "*");
      lives = 6;
      isGameOver = false;
      isWinner = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Życia: $lives",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  wordGuessed.join(" "),
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.amberAccent),
                  ),
                ),
                SizedBox(height: 30),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('').map((letter) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.tealAccent[700],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: (lives > 0 && !wordGuessed.contains(letter)) ? () => guessLetter(letter) : null,
                      child: Text(
                        letter,
                        style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          if (isGameOver)
            Positioned.fill(
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
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: resetGame,
                      child: Text("Zagraj ponownie", style: TextStyle(fontSize: 18)),
                    )
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
