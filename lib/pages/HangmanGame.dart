import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class HangmanGame extends StatefulWidget {
  @override
  _HangmanGameState createState() => _HangmanGameState();
}

class _HangmanGameState extends State<HangmanGame> {
  Set<String> wordsToGuess = {"FLUTTER","KOPALNIA", "CZLOWIEK"};
  late List<String> wordGuessed;
  int lives = 1;
  bool isGameOver = false;
  bool isWinner = false;
  String wordToGuessByUser = "";

  @override
  void initState() {
    super.initState();


    var rnd = Random();

    int rndIndex = rnd.nextInt(wordsToGuess.length);
    wordToGuessByUser = wordsToGuess.elementAt(rndIndex);
    lives = wordToGuessByUser.length;
    wordGuessed = List.generate(wordToGuessByUser.length, (index) => "*");
  }

  void guessLetter(String letter) {
    if (isGameOver) return;

    setState(() {
      bool found = false;
      for (int i = 0; i < wordToGuessByUser.length; i++) {
        if (wordToGuessByUser[i] == letter) {
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
      var rnd = Random();
      int rndIndex = rnd.nextInt(wordsToGuess.length);
      wordToGuessByUser = wordsToGuess.elementAt(rndIndex);
      wordGuessed = List.generate(wordToGuessByUser.length, (index) => "*");
      lives = wordToGuessByUser.length;
      isGameOver = false;
      isWinner = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0c4767),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
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
                ),

                SizedBox(height: 20),
                Text(
                  wordGuessed.join(" "),
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Color(0xFfefa00b)),
                  ),
                ),
                SizedBox(height: 40),
                Wrap(
                  spacing: 12.0,
                  runSpacing: 10.0,
                  children: 'AĄBCĆDEĘFGHIJKLŁMNŃOÓPQRSŚTUVWXYZŻŹ'.split('').map((letter) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF0075c4),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            color: Colors.white, // Change this to any color you want
                            width: 2, // Border thickness
                          ),
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
                      isWinner ? "🎉 Gratulacje! Odgadłeś hasło! 🎉" : "💀 Przegrałeś! Hasło to: $wordToGuessByUser",
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
                      onPressed: isWinner ? ()=> Navigator.of(context).pop() : resetGame,
                      child: isWinner ? Text("Powrót", style: TextStyle(fontSize: 18)) : Text("Zagraj ponownie", style: TextStyle(fontSize: 18)),
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
