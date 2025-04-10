import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';

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
import '../pages/CelebrationPage.dart';
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
  bool _hasPendingCameraMove = false;
  bool isOriginalLocations = true;
  bool showFirstAnimation = false;
  bool showSecondAnimation = false;
  bool darkenScreen = false;

  final List<String> questions = [
    "Zejście Plaża",
    "Dworzec",
    "Lokalna organizacja turystyczna",
    "Ratusz",
    "Osir",
    "Latarnia Morska",
    "Grand Lubicz",
    "Park Linowy",
    "Chomczyńscy",
    "Seekenmoor",
    "Mistral",
    "Bunkry Bluchera"
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
    LatLng(54.591213630954016, 16.888239854634985),
    // Zejście Plaża
    LatLng(54.5790769205611, 16.86176516965411),
    // Dworzec
    LatLng(54.582995048803596, 16.858182354634433),
    // Lokalna organizacja turystyczna
    LatLng(54.583563811001504, 16.86075809696267),
    // Ratusz
    LatLng(54.5813159732441, 16.873311283470326),
    // Osir
    LatLng(54.58802419058503, 16.85461349696294),
    // Latarnia Morska
    LatLng(54.58430823844433, 16.869021398814247),
    // Grand Lubicz
    LatLng(54.58747161136326, 16.870804296962895),
    // Park Linowy
    LatLng(54.58849080853478, 16.859105763374107),
    // Chomczyńscy
    LatLng(54.578803537815986, 16.842657483470127),
    // Seekenmoor
    LatLng(54.584789643699764, 16.85729832647877),
    // Mistral
    LatLng(54.586012002242, 16.849496477696533),
    // Bunkry Bluchera
  ];

  List<LatLng> taskLocations2 = [];

  //final List<LatLng> taskLocations3 = List.generate(
  //12,
  // (_) => LatLng(54.457912086191264, 16.995241472212303),
  //);

  int currentLetterIndex = 0;

  @override
  void initState() {
    super.initState();
    setUserLocations();
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

  Future<LatLng> getUserLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return LatLng(position.latitude, position.longitude);
  }

  Future<void> setUserLocations() async {
    LatLng userLocation = await getUserLocation();
    setState(() {
      taskLocations2 = List.generate(12, (_) => userLocation);
    });
  }


  Future<void> _checkPermissionAndInitLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
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
        currentLetterIndex < targetWord
            .replaceAll(' ', '')
            .length) {
      setState(() {
        isQuestionClicked[index] = true;
        String letter = targetWord.replaceAll(' ', '')[currentLetterIndex];
        currentLetterIndex++;

        if (letter == 'S' && currentLetterIndex < targetWord
            .replaceAll(' ', '')
            .length) {
          currentLetterIndex++;
        }
      });
    }

    if (isQuestionClicked.every((element) => element == true)) {
      showCelebrationAnimation();
    }
  }

  void showCelebrationAnimation() async {
    // Show celebration animation
    setState(() {
      showFirstAnimation = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        showFirstAnimation = false;
        darkenScreen = true;
      });

      Future.delayed(const Duration(milliseconds: 300), () {
        setState(() {
          showSecondAnimation = true;
        });
      });
    });
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
        isOriginalLocations = true;
      } else if (choice == 2) {
        currentTaskLocations = taskLocations2;
        isOriginalLocations = false;
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
        title: Text(
          "Odkryj Hasło",
          style: TextStyle(
            color: showSecondAnimation ? Colors.transparent : Color(0xFFEFA00B),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: showSecondAnimation ? Colors.transparent : Color(0xFF0a344a).withOpacity(0.80),
        elevation: 0,
        iconTheme: showSecondAnimation ? null : IconThemeData(color: Color(0xFFEFA00B)),
        actions: [
          // Jeżeli showSecondAnimation jest false, wyświetlamy przycisk przełącznika
          if (!showSecondAnimation) ...[
            const Text("Tryb:", style: TextStyle(color: Color(0xFFEFA00B))),
            Switch(
              value: isOriginalLocations,
              activeColor: const Color(0xFFEFA00B),
              onChanged: (bool value) {
                setState(() {
                  isOriginalLocations = value;
                  currentTaskLocations = isOriginalLocations ? taskLocations : taskLocations2;
                  _checkUserProximity();
                });
              },
            ),
          ],
          const SizedBox(width: 8),
        ],
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
                          borderRadius: BorderRadius.all(Radius.circular(10)),
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

        Positioned.fill(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A2E).withOpacity(0.50),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "HASŁO:",
                          style: TextStyle(
                            fontSize: 44,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2,
                            color: Color(0xFFEFA00B),
                            shadows: [
                              Shadow(
                                blurRadius: 8,
                                color: Color(0xFFEF9B0F),
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        ..._getDisplayedWord().map(
                              (line) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: SizedBox(
                              width: double.infinity, // Ensures consistent width
                              child: Text(
                                line,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 40, // Ensures consistency
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFAFCBFF),
                                  letterSpacing: -1,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 4,
                                      color: Color(0xFF6CA0FF),
                                      offset: Offset(0, 0),
                                    ),
                                    Shadow(
                                      blurRadius: 8,
                                      color: Color(0xFF6CA0FF),
                                      offset: Offset(0, 0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),

                  ),
                ],
              ),
              const SizedBox(height: 70),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.42,
                child: MapPage(
                  taskLocations: currentTaskLocations,
                  taskNames: questions,
                  onMapCreated: _onMapCreated,
                ),
              ),
            ],
          ),
        ),

        // Dark overlay when switching to second animation
        if (darkenScreen && !showFirstAnimation)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),

        if (showSecondAnimation) ...[
          // Ciemne tło
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                color: Colors.black.withOpacity(0.8),
              ),
            ),
          ),

          // Wyśrodkowana animacja o estetycznym rozmiarze
          Positioned.fill(
            child: IgnorePointer(
              child: Center(
                child: Lottie.asset(
                  'assets/dancing.json',
                  width: 250, // możesz zmienić rozmiar wg uznania
                  height: 250,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // Tekst "Gratulacje!" poniżej animacji
          Positioned.fill(
            child: IgnorePointer(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 300), // odstęp od animacji
                  Text(
                    'Gratulacje!',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFAFCBFF),
                      shadows: [
                        Shadow(
                          blurRadius: 16,
                          color: Colors.black87,
                          offset: Offset(3, 3),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

            ),
          ),
        ]
        ,
        // First animation (should be on top)
        if (showFirstAnimation)
          Positioned.fill(
            child: IgnorePointer(
              child: Stack(
                children: [
                  // Animacja na pełnym ekranie
                  Lottie.asset(
                    'assets/celebration.json',
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
