import 'dart:async';

import 'package:flutter/material.dart';

import '../Widgets/PongWidgets/CoverScreenPong.dart';
import '../Widgets/PongWidgets/PongBall.dart';
import '../Widgets/PongWidgets/PongBrick.dart';
import '../Widgets/PongWidgets/ScorePong.dart';

class PongGame extends StatefulWidget {
  @override
  State<PongGame> createState() => _PongGameState();
}

enum direction { UP, DOWN, LEFT, RIGHT}

class _PongGameState extends State<PongGame> {

  //ball vars
  double ballX = 0;
  double ballY = 0;
  var ballYDirection = direction.DOWN;
  var ballXDirection = direction.LEFT;

  //game vars
  bool gameHasStarted = false;
  bool gameOverDialogShown = false;
  double paddleX = -0.2;
  double paddleWidth = 0.4;
  int score = 0;
  final int winScore = 3;

  void startGame(){
    if (gameHasStarted) return;

    gameHasStarted = true;
    gameOverDialogShown = false;
    Timer.periodic(Duration(milliseconds: 1), (timer) {
      updateDirection();
      moveBall();
      if(isPlayerDead()){
        timer.cancel();
        //_showDialog();
      }
    });
  }


  bool isPlayerDead(){
    if(ballY >= 1){
      gameHasStarted = false;
      gameOverDialogShown = true;
      //_showLoseDialog();
      return true;
    }

    return false;
  }

  void resetGame(){
    Navigator.maybePop(context);
    setState(() {
      gameHasStarted = false;
      ballX = 0;
      ballY = 0;
      paddleX = -0.2;
      score = 0;
      gameOverDialogShown = false;
    });
  }

  void updateDirection(){
    setState(() {
      if(ballY >= 0.8 && paddleX + paddleWidth >= ballX && paddleX <= ballX){
        ballYDirection = direction.UP;
        score++;

        if(score >= winScore && !gameOverDialogShown){
          gameHasStarted = false;
          gameOverDialogShown = true;
          _showWinDialog();
        }
      }
      else if(ballY <= -0.8){
        ballYDirection = direction.DOWN;
      }

      if(ballX >= 1){
        ballXDirection = direction.LEFT;
      }
      else if(ballX <= -1){
        ballXDirection = direction.RIGHT;
      }

    });
  }

  void moveBall(){
    if(!gameHasStarted) return;

    setState(() {
      if(ballYDirection == direction.DOWN){
        ballY += 0.001;
      }
      else if(ballYDirection == direction.UP){
        ballY -= 0.001;
      }

      if(ballXDirection == direction.LEFT){
        ballX -= 0.001;
      }
      else if(ballXDirection == direction.RIGHT){
        ballX += 0.001;
      }

    });
  }

  void movePaddle(DragUpdateDetails details) {
    double newPaddleX = (details.localPosition.dx / MediaQuery.of(context).size.width) * 2 - 1;

    if ((newPaddleX - paddleX).abs() > 0.01) { // Minimalna zmiana, aby uniknąć zbędnych aktualizacji
      setState(() {
        paddleX = newPaddleX;
      });
    }
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text("Gratulacje!"),
        content: Text("Zdobyłeś 15 punktów!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              resetGame(); // Reset gry po zamknięciu okna dialogowego
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: movePaddle,
      onTap: startGame,
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        body: Center(
          child: Stack(
            children: [
              CoverScreenPong(gameHasStarted: gameHasStarted),

              PongBrick(x: paddleX, y: 0.85, brickWidth: paddleWidth),

              PongBall(
                x: ballX,
                y: ballY
              ),

              ScorePong(score: score)
            ],
          ),

        ),
      ),
    );
  }
}
