import 'package:flutter/material.dart';
import '../../appLogic/PongLogic.dart';
import 'PongBall.dart';
import 'PongBrick.dart';
import 'ScorePong.dart';


class PongBoard extends StatelessWidget {
  final PongLogic gameLogic;

  const PongBoard({Key? key, required this.gameLogic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'images/pong_tlo.png', // Ścieżka do obrazu w katalogu assets
            fit: BoxFit.cover,
          ),
        ),
        if (gameLogic.countdown > 0)
          Center(
            child: Text(
              "${gameLogic.countdown}",
              style: TextStyle(fontSize: 50, color: Color(0xFFefa00b), fontWeight: FontWeight.bold),
            ),
          ),

        PongBrick(x: gameLogic.paddleX, y: 0.85, brickWidth: gameLogic.paddleWidth),
        PongBall(x: gameLogic.ballX, y: gameLogic.ballY),
        ScorePong(score: gameLogic.score),

        GestureDetector(
          onHorizontalDragUpdate: (details) =>
              gameLogic.movePaddle(details.localPosition.dx, MediaQuery.of(context).size.width),
        ),
      ],
    );
  }
}
