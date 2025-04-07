import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

import '../Widgets/FlipCard.dart';

void main() {
  runApp(MemoryGame());
}

class MemoryGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MemoryGameScreen(),
    );
  }
}

class MemoryGameScreen extends StatefulWidget {
  @override
  _MemoryGameScreenState createState() => _MemoryGameScreenState();
}

class _MemoryGameScreenState extends State<MemoryGameScreen> {
  List<String> images = [
    "images/bunkier.jpg",
    "images/kladka.jpg",
    "images/latarnia.jpg",
    "images/lawka.jpg",
    "images/syrenka.jpg",
    "images/ustka.jpg",
  ];
  List<String> gameGrid = [];
  List<bool> cardFlipped = [];
  int? firstIndex;
  int? secondIndex;
  bool waiting = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, _showWelcomeDialog);
    _initializeGame();
  }



  void _initializeGame() {
    List<String> pairs = [...images, ...images];
    pairs.shuffle(Random());
    gameGrid = List.from(pairs);
    cardFlipped = List.generate(12, (index) => false);
    firstIndex = null;
    secondIndex = null;
    waiting = false;
  }

  void _showWelcomeDialog() {
    AwesomeDialog(
      dismissOnTouchOutside: false,
      context: context,
      dialogType: DialogType.infoReverse,
      animType: AnimType.scale,
      title: 'Witaj w grze Memory!',
      desc: 'Znajdź wszystkie pary, żeby odkryć kolejną literkę!',
      btnOkText: 'Zaczynamy!',
      btnOkOnPress: () {},
    ).show();
  }

  void _flipCard(int index) {
    if (waiting || cardFlipped[index]) return;
    setState(() {
      if (firstIndex == null) {
        firstIndex = index;
      } else if (secondIndex == null) {
        secondIndex = index;
        waiting = true;
        Future.delayed(Duration(seconds: 1), _checkMatch);
      }
    });
  }

  void _checkMatch() {
    setState(() {
      if (gameGrid[firstIndex!] == gameGrid[secondIndex!]) {
        cardFlipped[firstIndex!] = true;
        cardFlipped[secondIndex!] = true;
      }
      firstIndex = null;
      secondIndex = null;
      waiting = false;

      if (cardFlipped.every((flipped) => flipped)) {
        _showWinDialog();
      }
    });
  }

  void _showWinDialog() {
    AwesomeDialog(
      dismissOnTouchOutside: false,
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.scale,
      title: 'Gratulacje!',
      desc: 'Ułożono wszystkie pary!',
      btnOkText: 'Powrót!',
      btnOkOnPress: () => {
       Navigator.pop(context,true)
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0c4767),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'images/memory_tlo.png', // Ścieżka do obrazu w katalogu assets
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.2),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 100,),
              Text("Memory!", style: TextStyle(color: Color(0xFFEFA00B),fontSize: 50,
                  fontWeight: FontWeight.bold),),
              SizedBox(height: 50,),
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: gameGrid.length,
                  itemBuilder: (context, index) {
                    return FlipCard(
                      flipped: cardFlipped[index] || index == firstIndex || index == secondIndex,
                      onTap: () => _flipCard(index),
                      front: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          gameGrid[index],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                      back: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF0075C4),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Icon(Icons.question_mark, size: 32, color: Colors.white),
                      ),
                    );

                  },
                ),
              ),
            ],
          ),

        ],
      )
    );
  }
}
