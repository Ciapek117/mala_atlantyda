import 'package:flutter/material.dart';

import '../Widgets/QuestionPageWidget.dart';

class ParkLinowyPage extends StatelessWidget {
  const ParkLinowyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return QuestionPage(
      question: """W parku linowym są trzy odcinki trasy:
        •	Pierwszy odcinek ma 80 metrów.
      •	Drugi odcinek jest o 40 metrów krótszy od pierwszego.
      •	Trzeci odcinek ma dwa razy większą długość niż drugi.

      Jaka jest całkowita długość trasy?""",
      correctAnswer: "200",

      fontSize: 26,
    );
  }
}
