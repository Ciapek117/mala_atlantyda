import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
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
  List<LatLng> currentTaskLocations = [];
  GoogleMapController? _mapController;

  bool _hasPendingCameraMove = false; // 🔧 nowa flaga

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
    HiddenObjectScreen(),
    MistralPage(),
    RebusGame()
  ];

  final List<LatLng> taskLocations = [
    LatLng(54.46356746843195, 17.013808329119247),
    LatLng(54.46356746843195, 17.013808329119247),
    LatLng(54.5970, 18.8055),
    LatLng(54.4654254459461, 17.011524815426004),
    LatLng(54.6002, 18.8121),
    LatLng(54.6011, 18.8105),
    LatLng(54.6020, 18.8145),
    LatLng(54.47158802598502, 16.981100295406417),
    LatLng(54.47158802598502, 16.981100295406417),
    LatLng(54.47158802598502, 16.981100295406417),
    LatLng(54.6075, 18.8200),
    LatLng(54.6085, 18.8210),
  ];

  final List<LatLng> taskLocations2 = List.generate(
    12,
        (_) => LatLng(54.46356746843195, 17.013808329119247),
  );

  final List<LatLng> taskLocations3 = List.generate(
    12,
        (_) => LatLng(54.47158802598502, 16.981100295406417),
  );

  int currentLetterIndex = 0;

  @override
  void initState() {
    super.initState();
    isQuestionClicked = List.generate(questions.length, (_) => false);
    isTaskNearby = List.generate(questions.length, (_) => false);
    currentTaskLocations = taskLocations;

    _checkPermissionAndInitLocation(); // zmodyfikowana metoda

    Timer.periodic(const Duration(seconds: 10), (_) => _checkUserProximity());
  }

  Future<void> _checkUserProximity() async {
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _userPosition = LatLng(position.latitude, position.longitude);
      for (int i = 0; i < currentTaskLocations.length; i++) {
        double distance = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          currentTaskLocations[i].latitude,
          currentTaskLocations[i].longitude,
        );
        isTaskNearby[i] = distance < 100;
      }
    });
  }

  Future<void> _checkPermissionAndInitLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _userPosition = LatLng(position.latitude, position.longitude);
      });

      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(_userPosition!, 17),
        );
      } else {
        _hasPendingCameraMove = true; // 🔧 zapamiętaj że trzeba przesunąć
      }

      _checkUserProximity();
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;

    if (_hasPendingCameraMove && _userPosition != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(_userPosition!, 17),
      );
      _hasPendingCameraMove = false; // 🔧 już przesunięte
    }
  }



  void onTaskCompleted(int index) {
    if (!isQuestionClicked[index] &&
        currentLetterIndex < targetWord.replaceAll(' ', '').length) {
      setState(() {
        isQuestionClicked[index] = true;
        String letter = targetWord.replaceAll(' ', '')[currentLetterIndex];
        currentLetterIndex++;

        if (letter == 'S' && currentLetterIndex < targetWord.replaceAll(' ', '').length) {
          currentLetterIndex++;
        }
      });
    }
  }

  void _navigateToGame(int index) {
    Navigator.pop(context);
    if (index < gamePages.length) {
      Future.delayed(const Duration(milliseconds: 10), () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => gamePages[index]),
        ).then((result) {
          if (result == true) {
            onTaskCompleted(index);
          }
        });
      });
    }
  }

  void _changeTaskLocations(int choice) {
    setState(() {
      if (choice == 1) {
        currentTaskLocations = taskLocations;
      } else if (choice == 2) {
        currentTaskLocations = taskLocations2;
      } else if (choice == 3) {
        currentTaskLocations = taskLocations3;
      }
      _checkUserProximity();

      AwesomeDialog(
        context: context,
        dialogType: DialogType.infoReverse,
        animType: AnimType.scale,
        title: 'Info!',
        desc: 'Zmieniono lokalizacje. Sprawdź zadania!',
        btnOkText: 'skibidi',
        btnOkOnPress: () {},
      ).show();
    });
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
      backgroundColor: const Color(0xFF0c4767),
      appBar: AppBar(
        title: const Text(
          "Odkryj Hasło",
          style: TextStyle(
            color: Color(0xFFEFA00B),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF0a344a).withOpacity(0.80),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFEFA00B)),
      ),
      extendBodyBehindAppBar: true,
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
                    LatLng target = currentTaskLocations[index];
                    _mapController?.animateCamera(
                      CameraUpdate.newLatLngZoom(target, 17),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: const [
                            Icon(Icons.error, color: Colors.white),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Podejdź bliżej tego miejsca, aby odblokować to zadanie.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 3),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(10)),
                        ),
                        behavior: SnackBarBehavior.floating,
                        margin: const EdgeInsets.all(20),
                      ),
                    );

                    Navigator.pop(context);
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
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'images/memory_tlo.png',
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: Container(
            color: Colors.black.withOpacity(0.4),
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 100),
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
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFAFCBFF),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => _changeTaskLocations(1),
                    child: const Text("oryginalne"),
                  ),
                  const SizedBox(width: 7),
                  ElevatedButton(
                    onPressed: () => _changeTaskLocations(2),
                    child: const Text("dom Alana"),
                  ),
                  const SizedBox(width: 7),
                  ElevatedButton(
                    onPressed: () => _changeTaskLocations(3),
                    child: const Text("dom Martyny"),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              SizedBox(
                height: 500,
                child: MapPage(
                  taskLocations: currentTaskLocations,
                  taskNames: questions,
                  onMapCreated: _onMapCreated,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}