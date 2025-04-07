import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RebusGame(),
    );
  }
}

class RebusGame extends StatefulWidget {
  @override
  _RebusGameState createState() => _RebusGameState();
}

class _RebusGameState extends State<RebusGame> {
  final List<Map<String, String>> rebuses = [
    {"image": "images/rebus.png", "answer": "ustka"},
    {"image": "images/grunwald.png", "answer": "bitwa pod grunwaldem"},
    {"image": "images/chrzest.png", "answer": "chrzest polski"},
  ];

  late Map<String, String> currentRebus;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    final random = Random();
    setState(() {
      currentRebus = rebuses[random.nextInt(rebuses.length)];
      _controller.clear();
    });
  }

  void _showResultDialog(String message, String title, bool correct) {
    AwesomeDialog(
      dismissOnTouchOutside: false,
      context: context,
      dialogType: correct ? DialogType.success : DialogType.error,
      animType: AnimType.scale,
      title: title,
      desc: message,
      btnOkText: correct ? 'Powrót' : 'Spróbuj ponownie',
      btnOkOnPress: () {
        if(correct) {
          Navigator.pop(context, true);
          Navigator.maybePop(context, true);
        }

      },
    ).show();
  }


  void _checkAnswer() {
    if (_controller.text.trim().toLowerCase() == currentRebus["answer"]!.toLowerCase()) {
      _showResultDialog("Poprawna odpowiedź!", "Gratulacje", true);
    } else {
      _showResultDialog("Spróbuj ponownie!", "Błędna odpowiedź", false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Tło
          Positioned.fill(
            child: Image.asset(
              'images/question_tlo.png', // Ścieżka do obrazu w katalogu assets
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.4),
            ),
          ),

          // Zawartość aplikacji
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 400,
                    height: 200,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    child: Image.asset(
                      currentRebus["image"]!,
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    style: TextStyle(color: Colors.white),
                    controller: _controller,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.black.withOpacity(0.5),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      hintText: "Wpisz odpowiedź",
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _checkAnswer,
                    child: Text("Sprawdź"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}