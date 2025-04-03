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
  final Random random = Random();
  final int totalCircles = 10;
  late List<Map<String, dynamic>> circles;

  @override
  void initState() {
    super.initState();
    _generateCircles();
  }

  void _generateCircles() {
    circles = [];
    while (circles.length < totalCircles) {
      Offset newPosition = Offset(
        random.nextDouble() * (350 - 150) + 150,
        random.nextDouble() * (600 - 200) + 200,
      );

      bool isFarEnough = circles.every((circle) {
        return (newPosition - circle['position']).distance > 50.0;
      });

      if (isFarEnough) {
        circles.add({
          'position': newPosition,
          'size': 50.0,
          'clicks': 0,
          'visible': true,
        });
      }
    }
  }


  void _onCircleTap(Map<String, dynamic> circle) {
    setState(() {
      double oldSize = circle['size']; // Store previous size
      circle['clicks']++;

      if (circle['clicks'] == 1) {
        circle['size'] = 40.0;
      } else if (circle['clicks'] == 2) {
        circle['size'] = 30.0;
      } else if (circle['clicks'] == 3) {
        circle['visible'] = false;
      }

      double sizeChange = (oldSize - circle['size']) / 2; // Center the animation

      circle['position'] = Offset(
        circle['position'].dx + sizeChange - 10,
        circle['position'].dy + sizeChange - 10,
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The background remains clickable if needed, but now each circle handles its own tap.
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
                        fontWeight: FontWeight.bold,
                      ),
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
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  width: circle['size'],
                  height: circle['size'],
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    color: Colors.white.withOpacity(0.5),
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
