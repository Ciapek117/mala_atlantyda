import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import '../Widgets/PongWidgets/PongBoard.dart';
import '../appLogic/PongLogic.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class PongGame extends StatefulWidget {
  @override
  State<PongGame> createState() => _PongGameState();
}

class _PongGameState extends State<PongGame> {
  late PongLogic gameLogic;

  void _showGameInfoDialog() {
      AwesomeDialog(
        dismissOnTouchOutside: false,
        context: context,
        dialogType: DialogType.infoReverse,
        animType: AnimType.scale,
        title: "Witaj w Pong!",
        desc: "Odbij piłkę jak najwięcej razy. Jeśli zdobędziesz ${gameLogic.winScore} punktów – wygrywasz!",
        btnOkText: "OK",
        btnOkOnPress: () {
          gameLogic.startCountdown();
        },
      ).show();
  }

  void _showWinDialog() {
    AwesomeDialog(
      dismissOnTouchOutside: false,
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.bottomSlide,
      title: "Gratulacje!",
      desc: "Zdobyłeś ${gameLogic.winScore} punktów!",
      btnOkText: "OK",
      btnOkOnPress: () {
        Navigator.pop(context,true);
        Navigator.maybePop(context,true);
      },
    ).show();
  }

  @override
  void initState() {
    super.initState();
    gameLogic = PongLogic(onGameStateChanged: () => setState(() {}), onWin: _showWinDialog);
    Future.delayed(Duration.zero, () => _showGameInfoDialog());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      home: Scaffold(
        backgroundColor: Color(0xFF0c4767),
        body: PongBoard(gameLogic: gameLogic),
      ),
    );
  }
}
