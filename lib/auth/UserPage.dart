import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:mala_atlantyda/pages/CodeUnlockPage.dart';
import 'package:mala_atlantyda/pages/GrandLubiczPage.dart';
import 'package:mala_atlantyda/pages/MatchingGame.dart';
import 'package:mala_atlantyda/pages/MistralPage.dart';
import 'package:mala_atlantyda/pages/ParkLinowyPage.dart';
import 'package:mala_atlantyda/pages/RebusPage.dart';
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
  late List<bool> isTaskNearby;
  LatLng? _userPosition;

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
    "Mistral (Pytania)",
    "Bunkry Bluchera (Rebus)"
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
    MistralPage(),
    RebusGame()
  ];

  final List<LatLng> taskLocations = [
    LatLng(54.46356746843195, 17.013808329119247),
    LatLng(54.5957, 18.8083),
    LatLng(54.5970, 18.8055),
    LatLng(54.5985, 18.8092),
    LatLng(54.6002, 18.8121),
    LatLng(54.6011, 18.8105),
    LatLng(54.6020, 18.8145),
    LatLng(54.6040, 18.8170),
    LatLng(54.6055, 18.8185),
    LatLng(54.47158802598502, 16.981100295406417),
    LatLng(54.6075, 18.8200),
    LatLng(54.6085, 18.8210),
  ];

  int currentLetterIndex = 0;

  @override
  void initState() {
    super.initState();
    isQuestionClicked = List.generate(questions.length, (_) => false);
    isTaskNearby = List.generate(questions.length, (_) => false);
    _checkUserProximity();
    Timer.periodic(const Duration(seconds: 10), (_) => _checkUserProximity());
  }

  Future<void> _checkUserProximity() async {
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _userPosition = LatLng(position.latitude, position.longitude);
      for (int i = 0; i < taskLocations.length; i++) {
        double distance = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          taskLocations[i].latitude,
          taskLocations[i].longitude,
        );
        isTaskNearby[i] = distance < 100;
      }
    });
  }

  void _addLetter(int index) {
    if (!isQuestionClicked[index] && currentLetterIndex < targetWord.replaceAll(' ', '').length) {
      setState(() {
        isQuestionClicked[index] = true;
        currentLetterIndex++;
        String letter = targetWord.replaceAll(' ', '')[currentLetterIndex - 1];
        if (letter == 'S' && index < isQuestionClicked.length) {
          currentLetterIndex++;
        }
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
                  tileColor: isQuestionClicked[index]
                      ? const Color(0Xff566E3D)
                      : isTaskNearby[index]
                      ? const Color(0xFF75AEEB)
                      : Colors.grey.shade700,
                  textColor: Colors.white,
                  onTap: isTaskNearby[index]
                      ? () => _navigateToGame(index)
                      : () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Podejdź bliżej miejsca, aby odblokować to zadanie.'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
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
                letterSpacing: 1,
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
