import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UserPage(),
    );
  }
}

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final List<String> questions = List.generate(14, (index) => "Pytanie ${index + 1}");
  final String targetWord = "SZTORMOWY SZLAK";
  List<bool> isQuestionClicked = List.generate(14, (index) => false); // Lista do śledzenia kliknięć
  int currentLetterIndex = 0; // Indeks aktualnie odkrywanej literki

  // Funkcja do odkrywania literki
  void _addLetter(int index) {
    if (!isQuestionClicked[index] && currentLetterIndex < targetWord.length) {
      setState(() {
        // Oznacz pytanie jako kliknięte
        isQuestionClicked[index] = true;

        // Przesuń indeks, aby pominąć spacje
        while (currentLetterIndex < targetWord.length && targetWord[currentLetterIndex] == ' ') {
          currentLetterIndex++;
        }

        // Jeśli nie przekroczono długości hasła, odkryj literkę
        if (currentLetterIndex < targetWord.length) {
          currentLetterIndex++;
        }
      });
    }
  }

  // Funkcja do wyświetlania hasła
  String _getDisplayedWord() {
    String displayedWord = "";
    int revealedCount = 0;

    for (int i = 0; i < targetWord.length; i++) {
      if (targetWord[i] == ' ') {
        revealedCount++;
        displayedWord += ' '; // Spacje są zawsze widoczne
      } else if (revealedCount < currentLetterIndex && targetWord[i] != ' ') {
        displayedWord += targetWord[i]; // Odkryte literki
        revealedCount++;
      } else {
        displayedWord += "_"; // Nieodkryte literki
      }
    }

    return displayedWord;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Column(
        children: [
          SizedBox(height: 50,),
          // Lista pytań
          Container(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: questions.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () => _addLetter(index), // Przekazujemy indeks pytania
                    child: Text(questions[index], style: TextStyle(color: Colors.white),),
                    style: ElevatedButton.styleFrom(
                      textStyle: TextStyle(color: Colors.white),
                      backgroundColor: isQuestionClicked[index] ? Colors.blueAccent : Colors.lightBlueAccent, // Zmiana koloru po kliknięciu
                    ),
                  ),
                );
              },
            ),
          ),
          Spacer(), //TODO MIEJSCE NA MAPE
          // Wyświetlanie hasła z podziałem na linie
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 8.0, // Odstęp między literkami
              runSpacing: 8.0, // Odstęp między liniami
              children: _getDisplayedWord().split('').map((letter) {
                return Text(
                  letter,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: letter == '_' ? Colors.black : Colors.white, // Kolor dla nieodkrytych liter
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}