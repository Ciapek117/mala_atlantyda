import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

import '../pages/PongGame.dart';

enum Direction { UP, DOWN, LEFT, RIGHT }

class PongLogic {
  double ballX = 0;
  double ballY = -0.5;
  var ballYDirection = Direction.DOWN;
  var ballXDirection = Direction.LEFT;

  bool gameHasStarted = false;
  bool gameOverDialogShown = false;
  double paddleX = -0.2;
  double paddleWidth = 0.4;
  int score = 0;
  final int winScore = 5;
  int countdown = 3;

  final Function onGameStateChanged;
  final Function onWin;

  PongLogic({required this.onGameStateChanged, required this.onWin});

  void startCountdown() {
    countdown = 3;
    gameHasStarted = false;

    Timer.periodic(Duration(seconds: 1), (timer) {
      if (countdown > 1) {
        countdown--;
      } else {
        countdown = 0;
        timer.cancel();
        startGame();
      }
      onGameStateChanged();
    });
  }

  void startGame() {
    if (gameHasStarted) return;
    gameHasStarted = true;
    gameOverDialogShown = false;

    Timer.periodic(Duration(milliseconds: 1), (timer) {
      updateDirection();
      moveBall();
      if (isPlayerDead()) {
        timer.cancel();
        _showLoseDialog();
      } else if (score >= winScore) {
        timer.cancel();
        onWin();
      }
      onGameStateChanged();
    });
  }

  bool isPlayerDead() {
    return ballY >= 1;
  }

  void resetGame() {
    gameHasStarted = false;
    ballX = 0;
    ballY = -0.5;
    paddleX = -0.2;
    score = 0;
    gameOverDialogShown = false;
    countdown = 3;  // Resetujemy odliczanie!
    onGameStateChanged();
  }

  void updateDirection() {
    if (ballY >= 0.8 && paddleX + paddleWidth >= ballX && paddleX <= ballX) {
      ballYDirection = Direction.UP;
      score++;
      if (score >= winScore && !gameOverDialogShown) {
        gameOverDialogShown = true;
      }
    } else if (ballY <= -0.8) {
      ballYDirection = Direction.DOWN;
    }

    if (ballX >= 1) {
      ballXDirection = Direction.LEFT;
    } else if (ballX <= -1) {
      ballXDirection = Direction.RIGHT;
    }
  }

  void moveBall() {
    if (!gameHasStarted) return;
    if (ballYDirection == Direction.DOWN) {
      ballY += 0.003;
    } else if (ballYDirection == Direction.UP) {
      ballY -= 0.003;
    }
    if (ballXDirection == Direction.LEFT) {
      ballX -= 0.003;
    } else if (ballXDirection == Direction.RIGHT) {
      ballX += 0.003;
    }
  }

  void movePaddle(double newPosition, double screenWidth) {
    double newPaddleX = (newPosition / screenWidth) * 2 - 1;
    if ((newPaddleX - paddleX).abs() > 0.01) {
      paddleX = newPaddleX;
      onGameStateChanged();
    }
  }

  void _showLoseDialog() {
    gameHasStarted = false;
    gameOverDialogShown = true;

    BuildContext? context = navigatorKey.currentContext;

    if (context != null) {
      AwesomeDialog(
        dismissOnTouchOutside: false,
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.topSlide,
        title: "Przegrana!",
        desc: "Piłka spadła... Spróbuj ponownie!",
        btnOkText: "Zagraj ponownie",
        btnOkOnPress: () {
          resetGame();
          startCountdown(); // Restart gry z odliczaniem
        },
      ).show();
    }
  }



}
