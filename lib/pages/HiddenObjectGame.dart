import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(HiddenObjectGame());
}

class HiddenObjectGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: HiddenObjectScreen(),
    );
  }
}

class HiddenObjectScreen extends StatefulWidget {
  @override
  _HiddenObjectScreenState createState() => _HiddenObjectScreenState();
}

class _HiddenObjectScreenState extends State<HiddenObjectScreen> {
  final List<String> objectsToFind = ['List woźnicy', 'Latarnia', 'Zniszczony płaszcz'];
  final List<String> foundObjects = [];
  final Random random = Random();
  final int totalCircles = 10;
  late List<Map<String, dynamic>> circles = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, _showInfoDialog);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _generateCircles();
  }

  void _generateCircles() {
    if (circles.isNotEmpty) return;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    circles = [];
    while (circles.length < totalCircles) {
      Offset newPosition = Offset(
        random.nextDouble() * (screenWidth * 0.7) + screenWidth * 0.15,
        random.nextDouble() * (screenHeight * 0.6) + screenHeight * 0.2,
      );

      bool isFarEnough = circles.every((circle) {
        return (newPosition - circle['position']).distance > screenWidth * 0.1;
      });

      if (isFarEnough) {
        circles.add({
          'position': newPosition,
          'size': screenWidth * 0.15,
          'clicks': 0,
          'visible': true,
          'rotation': random.nextDouble() * 2 * pi,
          'image': 'images/lisc.png',
          'type': 'none',
          'found': false
        });
      }
    }

    Set<int> usedIndices = {};

    while (usedIndices.length < objectsToFind.length) {
      usedIndices.add(random.nextInt(circles.length));
    }

    int i = 0;
    for (int index in usedIndices) {
      circles[index]['type'] = objectsToFind[i];
      i++;
    }


    setState(() {});
  }



  void _onCircleTap(Map<String, dynamic> circle) {
    if(circle['found'] == true) return;

    final screenWidth = MediaQuery.of(context).size.width;

    setState(() {
      double oldSize = circle['size'];
      circle['clicks']++;

      if (circle['clicks'] == 1) {
        circle['size'] = 40.0;
      } else if (circle['clicks'] == 2) {
        circle['size'] = 30.0;
      } else if (circle['clicks'] == 3) {
        circle['visible'] = false;


        if (circle['type'] == 'List woźnicy' || circle['type'] == 'Latarnia' ||
            circle['type'] == 'Zniszczony płaszcz') {
          circle['visible'] = true;
          circle['size'] = screenWidth * 0.17;
          circle['clicks'] = 3;
          circle['rotation'] = 0.0;

          switch (circle['type']) {
            case 'List woźnicy':
              circle['image'] = 'images/list.png';
              break;
            case 'Latarnia':
              circle['image'] = 'images/latarnia.png';
              break;
            case 'Zniszczony płaszcz':
              circle['image'] = 'images/plaszcz.png';
              break;
          }
        }

        circle['found'] = true;
        if (!foundObjects.contains(circle['type']) && objectsToFind.contains(circle['type'])) {
          foundObjects.add(circle['type']);
          if(foundObjects.length == objectsToFind.length){
            _showWinDialog();
      }
        }




        double sizeChange = (oldSize - circle['size']) / 2;

        circle['position'] = Offset(
          circle['position'].dx + sizeChange - 10,
          circle['position'].dy + sizeChange - 10,
        );
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
      desc: 'Udało się znaleźć wszystkie potrzebne przedmioty!',
      btnOkText: 'Powrót',
      btnOkOnPress: () {
        Navigator.pop(context, true); // wraca do ekranu głównego
      },
    ).show();
  }


  void _showInfoDialog(){
    AwesomeDialog(
      dismissOnTouchOutside: false,
      context: context,
      dialogType: DialogType.infoReverse,
      animType: AnimType.scale,
      title: 'Witaj w poszukiwaczu!',
      desc: 'W liściach zostały ukryte 3 przedmioty. Znajdź je klikając w liście!',
      btnOkText: 'Zaczynamy!',
      btnOkOnPress: () {},
    ).show();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/lasek3.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            right: 20,
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blueGrey.withOpacity(0.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Przedmioty do znalezienia:',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  ...objectsToFind.map((objToFind) {
                    bool isFound = foundObjects.contains(objToFind);
                    return Row(
                      children: [
                        Text(
                          isFound ? '✅ $objToFind' : objToFind,
                          style: GoogleFonts.poppins(
                            color: isFound ? Colors.greenAccent : Colors.amber,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  }).toList(),

                ],
              ),
            ),
          ),
          ...circles.asMap().entries.map((entry) {
            int index = entry.key;
            var circle = entry.value;
            if (!circle['visible']) return SizedBox.shrink();
            return AnimatedPositioned(
              key: ValueKey(index),
              duration: Duration(milliseconds: 200),
              left: circle['position'].dx - circle['size'] / 2,
              top: circle['position'].dy - circle['size'] / 2,
              child: GestureDetector(
                onTap: () => _onCircleTap(circle),
                child: Transform.rotate(
                  angle: circle['rotation'],
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    width: circle['size'],
                    height: circle['size'],
                    child: Image.asset(
                      circle['image'],
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
