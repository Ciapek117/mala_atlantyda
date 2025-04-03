import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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

  void _onTap(TapUpDetails details) {
    Offset position = details.localPosition;
    if (kDebugMode) {
      print('Tapped at: ${position.dx}, ${position.dy}');
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
                  image: AssetImage('images/lasek2.jpg'), //mozesz dodac inne image jak chcesz. na razie bedzie ten
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Przedmioty do znalezienia:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  ...objectsToFind.map((obj) {
                    return Text(
                      obj,
                      style: TextStyle(
                        color: foundObjects.contains(obj) ? Colors.greenAccent : Colors.white70,
                        fontSize: 16,
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                'Podpowiedź',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}