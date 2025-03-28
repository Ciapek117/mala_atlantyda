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
        context: context,
        dialogType: DialogType.info,
        animType: AnimType.scale,
        title: "Witaj w Pong!",
        desc: "Odbij piłkę jak najwięcej razy. Jeśli zdobędziesz 15 punktów – wygrywasz!",
        btnOkText: "OK",
        btnOkOnPress: () {
          gameLogic.startCountdown();
        },
      ).show();
  }

  void _showWinDialog() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.bottomSlide,
      title: "Gratulacje!",
      desc: "Zdobyłeś 15 punktów!",
      btnOkText: "OK",
      btnOkOnPress: () {
        Navigator.pop(context);
        Navigator.maybePop(context);
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
      navigatorKey: navigatorKey,
      home: Scaffold(
        backgroundColor: Colors.grey[900],
        body: PongBoard(gameLogic: gameLogic),
      ),
    );
  }
}
