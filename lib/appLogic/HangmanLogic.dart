import 'dart:math';

class HangmanLogic {
  final Set<String> wordsToGuess = {"SYRENKA", "STATEK", "ATLANTYDA", "MUSZELKA"};
  late String wordToGuess;
  late List<String> wordGuessed;
  late int lives;
  bool isGameOver = false;
  bool isWinner = false;

  HangmanLogic() {
    _initializeGame();
  }

  void _initializeGame() {
    var rnd = Random();
    wordToGuess = wordsToGuess.elementAt(rnd.nextInt(wordsToGuess.length));
    wordGuessed = List.generate(wordToGuess.length, (_) => "*");
    lives = wordToGuess.length;
    isGameOver = false;
    isWinner = false;
  }

  void guessLetter(String letter) {
    if (isGameOver) return;
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
  }

  void resetGame() {
    _initializeGame();
  }
}