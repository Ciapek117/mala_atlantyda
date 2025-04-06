import 'package:flutter/material.dart';
import '../Widgets/QuestionPageWidget.dart';

void main() {
  runApp(GrandlubiczPage());
}

class GrandlubiczPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return QuestionPage(
      question: "Ile okienek znajduje się w trójkącie na dachu Grand Lubicza?",
      correctAnswer: "100",
      fontSize: 26,
    );
  }
}
