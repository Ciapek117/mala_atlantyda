import 'package:flutter/material.dart';
import 'package:mala_atlantyda/pages/MatchingGame.dart';
import 'package:mala_atlantyda/pages/map_page.dart';

import '../pages/JigsawPuzzlePage.dart';
import 'package:mala_atlantyda/pages/HangmanGame.dart';
import '../pages/MemoryGame.dart';
import '../pages/MemoryGame.dart';
import '../pages/PongGame.dart';

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
  final List<String> questions = List.generate(14, (index) => "Zadanie ${index + 1}")
    ..[0] = "Zejście Plaża (Puzzle)"
    ..[1] = "Dworzec (Wisielec)"
    ..[2] = "Lokalna organizacja turystyczna (Memory)"
    ..[3] = "Ratusz (Dopasuj miasta do km)"
    ..[4] = "Osir (Pong)";
  final String targetWord = "SZTORMOWY SZLAK";
  List<bool> isQuestionClicked = List.generate(14, (index) => false);
  int currentLetterIndex = 0;

  void _addLetter(int index) {
    if (!isQuestionClicked[index] && currentLetterIndex < targetWord.replaceAll(' ', '').length) {
      setState(() {
        isQuestionClicked[index] = true;
        currentLetterIndex++;
      });
    }
  }

  List<String> _getDisplayedWord() {
    List<String> words = targetWord.split(' ');
    List<String> revealedWords = [];

    int revealedCount = 0;

    for (var word in words) {
      String revealedWord = "";
      for (int i = 0; i < word.length; i++) {
        if (revealedCount < currentLetterIndex) {
          revealedWord += word[i];
          revealedCount++;
        } else {
          revealedWord += "_ ";
        }
      }
      revealedWords.add(revealedWord);
    }

    return revealedWords;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0c4767),
      appBar: AppBar(
        title: Text(
          "Odkryj Hasło",
          style: TextStyle(color: Color(0xFFEFA00B), fontWeight: FontWeight.bold,),
        ),
        backgroundColor: Color(0xFF0a344a),
        iconTheme: IconThemeData(color: Color(0xFFEFA00B)),
      ),
      drawer: Drawer(
        backgroundColor: Color(0xFF0a344a),
        child: Column(
          children: [
            SizedBox(height: 20),
            // Mniejszy header
            Container(
              height: 150.0, // Wysokość zmniejszona
              color: Color(0xFF0a344a),
              child: SizedBox(
                child: Center(
                  child: Text(
                    "Wybierz zadanie",
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(questions[index]),
                    tileColor: isQuestionClicked[index] ? Color(0Xff566E3D) : Color(0xFF75AEEB),
                    textColor: Colors.white,
                    onTap: () {
                      Navigator.pop(context); // Zamknij drawer przed nawigacją
                      if (index == 0) {
                        Future.delayed(Duration(milliseconds: 10), () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PuzzleApp()),
                          );
                          _addLetter(index);

                        });
                      } else if(index == 1){
                        Future.delayed(Duration(milliseconds: 10), () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HangmanGame()),
                          );

                          _addLetter(index);
                        });
                      } else if(index == 2){
                        Future.delayed(Duration(milliseconds: 10), () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MemoryGameScreen()),
                          );

                          _addLetter(index);
                        });
                      } else if(index == 3){
                        Future.delayed(Duration(milliseconds: 10), () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MatchingGamePage()),
                          );

                          _addLetter(index);
                        });
                      } else if(index == 4){
                        Future.delayed(Duration(milliseconds: 10), () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PongGame()),
                          );

                          _addLetter(index);
                        });
                      }
                      else {
                        _addLetter(index);
                      }
                    },


                  );

                },
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Wyśrodkowanie w pionie
          children: [
            Text("HASŁO: ", style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Color(0xFFEFA00B),
            ),),
            ..._getDisplayedWord().map((line) {
              return Text(
                line,
                textAlign: TextAlign.center,
                style: TextStyle(
                  letterSpacing: 3,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFAFCBFF),
                ),
              );
            }).toList(),
            SizedBox(height: 50),
            Container(
              child: SizedBox(
                height: 500,
                child: MapPage(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
