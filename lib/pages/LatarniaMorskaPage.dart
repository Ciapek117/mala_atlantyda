import 'package:flutter/material.dart';
import '../Widgets/QuestionPageWidget.dart';

void main() {
  runApp(LatarniaMorskaPage());
}

class LatarniaMorskaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: QuestionPage(
        question: "Jakie imię i nazwisko w Latarni Morskiej ma najwięcej literek?",
        correctAnswer: "władysław zawrotniak",
      ),
    );
  }
}
