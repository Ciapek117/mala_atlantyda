import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MaterialApp(
    home: MatchingGamePage(),
  ));
}

class MatchingGamePage extends StatefulWidget {
  @override
  _MatchingGamePageState createState() => _MatchingGamePageState();
}

class _MatchingGamePageState extends State<MatchingGamePage> {
  final Map<String, int> cityDistances = {
    "Bojarka": 1358,
    "Homecourt": 113,
    "Kapplen": 669,
    "Bielsko Biała": 756,
    "Palanga": 558,
    "Słupsk": 20,
  };

  Map<String, int?> userMatches = {};
  List<int> shuffledDistances = [];
  List<String> matchedCities = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, _showWelcomeDialog);
    userMatches = {for (var city in cityDistances.keys) city: null};
    shuffleDistances();
  }

  void _showWelcomeDialog(){
    AwesomeDialog(
      dismissOnTouchOutside: false,
      context: context,
      dialogType: DialogType.infoReverse,
      animType: AnimType.scale,
      title: 'Witaj w dopasywaniu do pary!',
      desc: 'Dopasuj odpowiednie odległości do każdego z miast!',
      btnOkText: 'Zaczynamy!',
      btnOkOnPress: () {},
    ).show();
  }

  void shuffleDistances() {
    setState(() {
      shuffledDistances = cityDistances.values.toList()..shuffle(Random());
    });
  }

  void checkWinCondition() {
    setState(() {
      matchedCities = userMatches.entries
          .where((entry) => cityDistances[entry.key] == entry.value)
          .map((entry) => entry.key)
          .toList();
    });

    if (userMatches.entries.every((entry) => cityDistances[entry.key] == entry.value)) {
      AwesomeDialog(
        dismissOnTouchOutside: false,
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.scale,
        title: 'Gratulacje!',
        desc: 'Udało się wszystko dopasować!',
        btnOkText: 'Powrót',
        btnOkOnPress: () {
          Navigator.pop(context,true);
          Navigator.maybePop(context,true);
        },
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0c4767),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'images/matching_tlo.png', // Ścieżka do obrazu w katalogu assets
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 100),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Dopasuj miasta do odległości",
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Color(0xFFEFA00B)),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8, // Zmniejszona szerokość
                            height: MediaQuery.of(context).size.height * 0.23, // Zmniejszona wysokość
                            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.015), // Mniejszy padding
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xFFAFCBFF), width: MediaQuery.of(context).size.width * 0.004), // Cieńsze obramowanie
                              borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.025), // Mniejsze zaokrąglenie rogów
                            ),
                            child: Wrap(
                              spacing: MediaQuery.of(context).size.width * 0.06,
                              runSpacing: MediaQuery.of(context).size.height * 0.015,
                              children: userMatches.keys.map((city) {
                                bool isMatched = matchedCities.contains(city);
                                return Container(
                                  width: MediaQuery.of(context).size.width * 0.35,
                                  height: MediaQuery.of(context).size.height * 0.06,
                                  alignment: Alignment.center,
                                  child: isMatched
                                      ? Container()
                                      : Draggable<String>(
                                    data: city,
                                    feedback: Material(
                                      child: Container(
                                        width: MediaQuery.of(context).size.width * 0.35,
                                        height: MediaQuery.of(context).size.height * 0.06,
                                        color: Color(0xFF0075C4),
                                        alignment: Alignment.center,
                                        child: Text(city, style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.width * 0.035)),
                                      ),
                                    ),
                                    childWhenDragging: Container(
                                      width: MediaQuery.of(context).size.width * 0.35,
                                      height: MediaQuery.of(context).size.height * 0.06,
                                      alignment: Alignment.center,
                                      color: Colors.blue.withOpacity(0.5),
                                      child: Text(city, style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.width * 0.035)),
                                    ),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width * 0.35,
                                      height: MediaQuery.of(context).size.height * 0.06,
                                      alignment: Alignment.center,
                                      color: Color(0xFF0075C4),
                                      child: Text(city, style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.width * 0.035)),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),

                          SizedBox(height: 50),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8, // Zmniejszona szerokość
                            height: MediaQuery.of(context).size.height * 0.22, // Zmniejszona wysokość
                            padding: EdgeInsets.all(7), // Dodanie paddingu 5
                            decoration: BoxDecoration(// Dodanie czarnego tła
                              border: Border.all(color: Color(0xFFAFCBFF), width: 2), // Dodanie obramowania
                              borderRadius: BorderRadius.circular(10), // Zaokrąglenie rogów
                            ),
                            child: Wrap(
                              spacing: 20,
                              runSpacing: 10,
                              children: shuffledDistances.map((distance) {
                                return DragTarget<String>(
                                  onWillAccept: (city) => true,
                                  onAccept: (city) {
                                    setState(() {
                                      String? previousCity = userMatches.entries
                                          .firstWhere((entry) => entry.value == distance, orElse: () => MapEntry("", null))
                                          .key;
                                      if (previousCity != null && previousCity.isNotEmpty) {
                                        userMatches[previousCity] = null;
                                      }
                                      userMatches[city] = distance;
                                      checkWinCondition();
                                    });
                                  },
                                  builder: (context, candidateData, rejectedData) {
                                    String? matchedCity = userMatches.entries
                                        .firstWhere((entry) => entry.value == distance, orElse: () => MapEntry("", null))
                                        .key;
                                    bool isCorrect = matchedCity.isNotEmpty && userMatches[matchedCity] == cityDistances[matchedCity];
                                    Color boxColor = isCorrect ? Colors.green : (matchedCity.isNotEmpty ? Color(0xFFEA5B60) : Color(0xFFAFCBFF));
                                    return Container(
                                      width: MediaQuery.of(context).size.width * 0.35,
                                      height: MediaQuery.of(context).size.height * 0.06,
                                      alignment: Alignment.center,
                                      color: boxColor,
                                      child: Text(
                                        matchedCity.isNotEmpty ? "$matchedCity - $distance km" : "$distance km",
                                        style: TextStyle(color: Color(0xFF273B09)),
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
                            ),
                          ),


                        ],
                      );
                    },
                  ),
                ),
                SizedBox(height: 50),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
