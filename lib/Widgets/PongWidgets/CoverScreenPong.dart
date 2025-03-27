import 'package:flutter/material.dart';

class CoverScreenPong extends StatelessWidget {
  final bool gameHasStarted;

  CoverScreenPong({required this.gameHasStarted});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(0, -0.2),
      child: Text(gameHasStarted ? '' : 'Tap to play', style: TextStyle(color: Colors.white, fontSize: 30, letterSpacing: 4)),
    );
  }
}
