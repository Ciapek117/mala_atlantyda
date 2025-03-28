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

  @override
  void initState() {
    super.initState();
    userMatches = {for (var city in cityDistances.keys) city: null};
    shuffleDistances();
  }

  void shuffleDistances() {
    setState(() {
      shuffledDistances = cityDistances.values.toList()..shuffle(Random());
    });
  }

  void checkWinCondition() {
    // Sprawdzenie, czy wszystkie miasta zostały poprawnie dopasowane
    if (userMatches.entries.every((entry) => cityDistances[entry.key] == entry.value)) {
      // Wywołanie alertu po wygranej
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Gratulacje!"),
            content: Text("Wszystkie dopasowania są poprawne!"),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  // Zamknięcie dialogu po kliknięciu OK
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0c4767),
      body: Column(
        children: [
          SizedBox(height: 100),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Dopasuj miasta do odległości", style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Color(0xFFEFA00B))),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Miasta do przenoszenia
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: userMatches.keys.where((city) => userMatches[city] == null || userMatches[city] != cityDistances[city]).map((city) {
                    return Draggable<String>(
                      data: city,
                      feedback: Material(
                        child: Container(
                          padding: EdgeInsets.all(8),
                          color: Color(0xFF0075C4),
                          child: Text(city, style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      childWhenDragging: Container(),
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        padding: EdgeInsets.all(8),
                        color: Colors.blue,
                        child: Text(city, style: TextStyle(color: Colors.white)),
                      ),
                    );
                  }).toList(),
                ),

                // Miejsca na odległości
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: shuffledDistances.map((distance) {
                    return DragTarget<String>(
                      onWillAccept: (city) => true, // Zawsze akceptuj miasto
                      onAccept: (city) {
                        setState(() {
                          // Sprawdzamy, czy miasto jest już przypisane
                          String? previousCity = userMatches.entries
                              .firstWhere((entry) => entry.value == distance, orElse: () => MapEntry("", null))
                              .key;

                          // Jeśli było przypisane inne miasto, usuwamy je
                          if (previousCity != null && previousCity.isNotEmpty) {
                            userMatches[previousCity] = null; // Usuwamy poprzednie miasto
                          }

                          // Przypisujemy nowe miasto
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
                          margin: EdgeInsets.symmetric(vertical: 8),
                          padding: EdgeInsets.all(8),
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
              ],
            ),
          ),
          SizedBox(height: 200),
        ],
      ),
    );
  }
}
