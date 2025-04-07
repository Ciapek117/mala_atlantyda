import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(CodeUnlockApp());
}

class CodeUnlockApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CodeUnlockScreen(),
    );
  }
}

class CodeUnlockScreen extends StatefulWidget {
  final VoidCallback? onTaskCompleted;

  const CodeUnlockScreen({Key? key, this.onTaskCompleted}) : super(key: key);

  @override
  _CodeUnlockScreenState createState() => _CodeUnlockScreenState();
}


class _CodeUnlockScreenState extends State<CodeUnlockScreen> {
  List<int> numbers = [0, 0, 0, 0];
  final List<int> correctCode = [1, 9, 6, 3];
  bool isUnlocked = false;
  List<Color> colors = List.filled(4, Color(0xFFAFCBFF));
  bool isDialogShown = false;
  int attempts = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () => _showWelcomeDialog());
  }

  void _increment(int index) {
    setState(() {
      if (numbers[index] < 9) {
        numbers[index]++;
      } else {
        numbers[index] = 0;
      }
    });
  }

  void _decrement(int index) {
    setState(() {
      if (numbers[index] > 0) {
        numbers[index]--;
      } else {
        numbers[index] = 9;
      }
    });
  }

  bool _isCodeCorrect() {
    return List.generate(numbers.length, (index) => numbers[index] == correctCode[index]).every((e) => e);
  }

  void _checkCode() {
    setState(() {
      attempts++;
      PromtDialog(attempts);

      for (int i = 0; i < numbers.length; i++) {
        if (numbers[i] == correctCode[i]) {
          colors[i] = Colors.green;

          if (_isCodeCorrect() && !isDialogShown) {
            isDialogShown = true;
            isUnlocked = true;

            widget.onTaskCompleted?.call();

            Future.delayed(Duration(seconds: 2), () {
              _showWinDialog();
            });
          }
        } else if (correctCode.contains(numbers[i])) {
          colors[i] = Colors.orange;
        } else {
          colors[i] = Color(0xFFAFCBFF);
        }
      }
    });
  }

  void PromtDialog(int attemptValue){
    if(attemptValue == 3){
      AwesomeDialog(
        dismissOnTouchOutside: false,
        context: context,
        dialogType: DialogType.infoReverse,
        animType: AnimType.scale,
        title: "Podpowiedź pierwsza!",
        desc: "tresc podpowiedzi 1",
        btnOkOnPress: (){}
      ).show();
    } else if(attemptValue == 5){
      AwesomeDialog(
          dismissOnTouchOutside: false,
        context: context,
        dialogType: DialogType.infoReverse,
        animType: AnimType.scale,
        title: "Podpowiedź druga!",
        desc: "tresc podpowiedzi 2",
        btnOkOnPress: (){}
      ).show();
    } else if(attemptValue == 7){
      AwesomeDialog(
          dismissOnTouchOutside: false,
        context: context,
        dialogType: DialogType.infoReverse,
        animType: AnimType.scale,
        title: "Podpowiedź trzecia!",
        desc: "tresc podpowiedzi 3",
        btnOkOnPress: (){}
      ).show();
    }
  }


  void _showWelcomeDialog(){
    AwesomeDialog(
      dismissOnTouchOutside: false,
      context: context,
      dialogType: DialogType.infoReverse,
      animType: AnimType.scale,
      title: 'Witaj w zgadywaniu kodu!',
      desc: 'Spróbuj odgadnąć poprawny kod związany z miejscem, w którym się znajdujesz!',
      btnOkText: 'Zaczynamy!',
      btnOkOnPress: () {},
    ).show();
  }

  void _showWinDialog() {
    AwesomeDialog(
      dismissOnTouchOutside: false,
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.scale,
      title: 'Gratulacje!',
      desc: 'Udało się wszystko dopasować!',
      btnOkText: 'Powrót',
      btnOkOnPress: () {
        Navigator.pop(context, true);
      },
    ).show();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedSwitcher(
            duration: Duration(seconds: 1),
            transitionBuilder: (child, animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: Container(
              key: ValueKey(isUnlocked),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    isUnlocked ? "images/done_code_tlo.png" : "images/code_tlo.png",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              children: [
                SizedBox(height: 145),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (index) {
                    return Column(
                      children: [
                        IconButton(
                          icon: Image.asset("images/arrow_up.png", color: Color(0xFFAFCBFF), width: 40, height: 50),
                          onPressed: () => _increment(index),
                        ),
                        Container(
                          width: 45,
                          height: 60,
                          color: colors[index],
                          alignment: Alignment.center,
                          child: Text(
                            numbers[index].toString(),
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                          icon: Image.asset("images/arrow_down.png", color: Color(0xFFAFCBFF), width: 40, height: 50),
                          onPressed: () => _decrement(index),
                        ),
                      ],
                    );
                  }),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _checkCode,
                  child: Text("Sprawdź kod"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}