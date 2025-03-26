import 'package:flutter/material.dart';
import '../Widgets/HangmanWidgets/GameOverScreen.dart';
import '../Widgets/HangmanWidgets/Keyboard.dart';
import '../Widgets/HangmanWidgets/LivesDisplay.dart';
import '../Widgets/HangmanWidgets/WordDisplay.dart';
import '../appLogic/HangmanLogic.dart';

class HangmanGame extends StatefulWidget {
  @override
  _HangmanGameState createState() => _HangmanGameState();
}

class _HangmanGameState extends State<HangmanGame> {
  final HangmanLogic _game = HangmanLogic();

  void _guessLetter(String letter) {
    setState(() {
      _game.guessLetter(letter);
    });
  }

  void _resetGame() {
    setState(() {
      _game.resetGame();
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
                LivesDisplay(lives: _game.lives),
                WordDisplay(wordGuessed: _game.wordGuessed),
                SizedBox(height: 40),
                Keyboard(onLetterPressed: _guessLetter,
                    guessedLetters: _game.wordGuessed,
                    lives: _game.lives),
              ],
            ),
          ),
          if (_game.isGameOver)
            GameOverScreen(isWinner: _game.isWinner,
                wordToGuess: _game.wordToGuess,
                onRestart: _resetGame),
        ],
      ),
    );
  }
}
