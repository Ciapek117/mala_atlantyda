import 'dart:ffi';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

class QuestionPage extends StatefulWidget {
  final String question;
  final String correctAnswer;
  final double? fontSize;

  QuestionPage({required this.question, required this.correctAnswer, required this.fontSize});

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  final TextEditingController _controller = TextEditingController();

  void checkAnswer() {
    if (_controller.text.trim().toLowerCase() == widget.correctAnswer.toLowerCase()) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.scale,
        title: 'Gratulacje!',
        desc: 'Udało się poprawnie odpowiedzieć na pytanie!',
        btnOkText: 'Powrót',
        btnOkOnPress: () {
          //Navigator.maybePop(context);
          Navigator.pop(context,true);
        },
      ).show();
    } else {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.scale,
        title: 'Niestety!',
        desc: 'Odpowiedź była błędna. Spróbuj ponownie!',
        btnOkText: 'Jeszcze raz!',
        btnOkOnPress: () {
          //Navigator.maybePop(context);
          Navigator.pop(context);
        },
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Obraz tła
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
          // Warstwa z treścią
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.question,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: widget.fontSize, fontWeight: FontWeight.bold, color: Color(0xFFADE8F4)),
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
                  onPressed: checkAnswer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0c4767), // Ciemny niebieski
                    foregroundColor: Colors.white, // Biały tekst
                  ),
                  child: Text("Sprawdź"),
                ),
              ],
            ),
          ),
        ],
      ),
    );

  }
}
