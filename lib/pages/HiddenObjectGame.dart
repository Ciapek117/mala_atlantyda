import 'dart:math';
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
  final List<String> objectsToFind = ['List woźnicy', 'Latarnia', 'Błędne ogniki'];
  final Set<String> foundObjects = {};
  final Random random = Random();
  late Offset circlePosition;
  double circleSize = 50;
  int clicks = 0;
  bool isVisible = true;
  double messageOpacity =0.0;

  @override
  void initState() {
    super.initState();
    _generateCircle();
  }

  void _generateCircle() {
    // Losowanie pozycji w określonym przedziale
    double x = random.nextDouble() * (400 - 100) + 100; // Od 100 do 400
    double y = random.nextDouble() * (600 - 200) + 200; // Od 200 do 600
    circlePosition = Offset(x, y);
  }

  void _onTap(TapUpDetails details) {
    if (!isVisible) return; // Jeśli kółko zniknęło, nie reaguj

    Offset position = details.localPosition;
    double dx = position.dx - circlePosition.dx;
    double dy = position.dy - circlePosition.dy;

    if (dx * dx + dy * dy <= (circleSize / 2) * (circleSize / 2)) {
      setState(() {
        clicks++;
        if (clicks == 1) {
          circleSize = 40;
        } else if (clicks == 2) {
          circleSize = 30;
        } else if (clicks == 3) {
          setState(() {
            isVisible = false;
          });
        }

        // Przesunięcie kółka, aby zmniejszało się do środka
        circlePosition = Offset(
          circlePosition.dx + (50 - circleSize) / 2,
          circlePosition.dy + (50 - circleSize) / 2,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onTapUp: _onTap,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/lasek3.jpg'),
                  fit: BoxFit.cover,
                ),
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
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  ...objectsToFind.map((objToFind) {
                    return Text(
                      objToFind,
                      style: GoogleFonts.poppins(
                          color: Colors.amber,
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),

          if (isVisible)
            AnimatedPositioned(
              duration: Duration(milliseconds: 200),
              left: circlePosition.dx - circleSize / 2,
              top: circlePosition.dy - circleSize / 2,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    clicks++;
                    if (clicks == 1) circleSize = 40;
                    else if (clicks == 2) circleSize = 30;
                    else if (clicks == 3) isVisible = false;
                  });
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  width: circleSize,
                  height: circleSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
