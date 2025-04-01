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
  @override
  _CodeUnlockScreenState createState() => _CodeUnlockScreenState();
}

class _CodeUnlockScreenState extends State<CodeUnlockScreen> {
  List<int> numbers = [0, 0, 0, 0];
  final List<int> correctCode = [1, 9, 6, 3];
  bool isUnlocked = false;

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

  void _checkCode(BuildContext context) {
    if (_isCodeCorrect()) {
      setState(() {
        isUnlocked = true;
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Gratulacje!"),
          content: Text("Kod poprawny! Odblokowano dostęp."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text("OK"),
            )
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Błąd"),
          content: Text("Kod niepoprawny. Spróbuj ponownie."),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("OK"))],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            isUnlocked ? "images/done_code_tlo.png" : "images/code_tlo.png",
            fit: BoxFit.cover,
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
                          color: Color(0xFFAFCBFF),
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
                ElevatedButton(
                  onPressed: () => _checkCode(context),
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
