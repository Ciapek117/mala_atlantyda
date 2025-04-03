import 'package:flutter/material.dart';
import 'package:mala_atlantyda/pages/CodeUnlockPage.dart';
import 'package:mala_atlantyda/pages/GrandLubiczPage.dart';
import 'package:mala_atlantyda/pages/MatchingGame.dart';
import 'package:mala_atlantyda/pages/MistralPage.dart';
import 'package:mala_atlantyda/pages/ParkLinowyPage.dart';
import 'package:mala_atlantyda/pages/map_page.dart';

import 'package:mala_atlantyda/pages/JigsawPuzzlePage.dart';
import 'package:mala_atlantyda/pages/HangmanGame.dart';
import 'package:mala_atlantyda/pages/MemoryGame.dart';
import 'package:mala_atlantyda/pages/PongGame.dart';
import 'package:mala_atlantyda/pages/LatarniaMorskaPage.dart';

import '../pages/HiddenObjectGame.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UserPage(),
    );
  }
}

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  static const String targetWord = "SZTORMOWY SZLAK";
  late List<bool> isQuestionClicked;
  final List<String> questions = [
    "Zejście Plaża (Puzzle)",
    "Dworzec (Wisielec)",
    "Lokalna organizacja turystyczna (Memory)",
    "Ratusz (Dopasuj miasta do km)",
    "Osir (Pong)",
    "Latarnia Morska (Pytanie)",
    "Grand Lubicz (Pytanie)",
    "Park Linowy (Zagadka)",
    "Chomczyńscy (Kod)",
    "Seekenmoor (Znajdźki)",
    "Mistral (Pytania)"
  ];

  final List<Widget> gamePages = [
    PuzzleApp(),
    HangmanGame(),
    MemoryGameScreen(),
    MatchingGamePage(),
    PongGame(),
    LatarniaMorskaPage(),
    GrandlubiczPage(),
    ParkLinowyPage(),
    CodeUnlockScreen(),
    HiddenObjectGame(),
    MistralPage()
  ];

  @override
  void initState() {
    super.initState();
    isQuestionClicked = List.generate(questions.length, (index) => false);
  }
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

  void _navigateToGame(int index) {
    Navigator.pop(context);
    if (index < gamePages.length) {
      Future.delayed(const Duration(milliseconds: 10), () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => gamePages[index]),
        );
        _addLetter(index);
      });
    } else {
      _addLetter(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0c4767),
      appBar: AppBar(
        title: const Text(
          "Odkryj Hasło",
          style: TextStyle(color: Color(0xFFEFA00B), fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF0a344a),
        iconTheme: const IconThemeData(color: Color(0xFFEFA00B)),
      ),
      drawer: _buildDrawer(),
      body: _buildBody(),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: const Color(0xFF0a344a),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            height: 150.0,
            color: const Color(0xFF0a344a),
            child: const Center(
              child: Text(
                "Wybierz zadanie",
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: questions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(questions[index]),
                  tileColor: isQuestionClicked[index] ? const Color(0Xff566E3D) : const Color(0xFF75AEEB),
                  textColor: Colors.white,
                  onTap: () => _navigateToGame(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "HASŁO:",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Color(0xFFEFA00B),
            ),
          ),
          ..._getDisplayedWord().map(
                (line) => Text(
              line,
              textAlign: TextAlign.center,
              style: const TextStyle(
                letterSpacing: 3,
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Color(0xFFAFCBFF),
              ),
            ),
          ).toList(),
          const SizedBox(height: 50),
          SizedBox(
            height: 500,
            child: const MapPage(),
          ),
        ],
      ),
    );
  }
}
