import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

class QuestionPage extends StatefulWidget {
  final String question;
  final String correctAnswer;
  final String? correctAnswer2; // teraz opcjonalne
  final double? fontSize;

  QuestionPage({
    required this.question,
    required this.correctAnswer,
    this.correctAnswer2, // opcjonalnie
    this.fontSize,
  });

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  final TextEditingController _controller = TextEditingController();

  void checkAnswer() {
    String userInput = _controller.text.trim().toLowerCase();
    String correct1 = widget.correctAnswer.toLowerCase();
    String? correct2 = widget.correctAnswer2?.toLowerCase();

    bool isCorrect = userInput == correct1 || (correct2 != null && userInput == correct2);

    if (isCorrect) {
      AwesomeDialog(
        dismissOnTouchOutside: false,
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.scale,
        title: 'Gratulacje!',
        desc: 'Udało się poprawnie odpowiedzieć na pytanie!',
        btnOkText: 'Powrót',
        btnOkOnPress: () {
          Navigator.pop(context, true);
        },
      ).show();
    } else {
      AwesomeDialog(
        dismissOnTouchOutside: false,
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.scale,
        title: 'Niestety!',
        desc: 'Odpowiedź była błędna. Spróbuj ponownie!',
        btnOkText: 'Jeszcze raz!',
        btnOkOnPress: () {
        },
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'images/question_tlo.png',
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.4),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    widget.question,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: widget.fontSize ?? 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFADE8F4),
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
                    onPressed: checkAnswer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF0c4767),
                      foregroundColor: Colors.white,
                    ),
                    child: Text("Sprawdź"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
