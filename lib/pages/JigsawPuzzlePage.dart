import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:async';
import 'dart:math';

import '../auth/UserPage.dart';

void main() {
  runApp(PuzzleApp());
}

class PuzzleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PuzzleScreen(),
    );
  }
}

class PuzzleScreen extends StatefulWidget {
  @override
  _PuzzleScreenState createState() => _PuzzleScreenState();
}

class _PuzzleScreenState extends State<PuzzleScreen> {
  final int gridSize = 3;
  List<int> tileOrder = [];
  late Map<int, Rect> tilePositions;
  ui.Image? image;

  @override
  void initState() {
    super.initState();
    _loadImage("images/puzle_plaza.jpg");
    _initializeTiles();
  }

  Future<void> _loadImage(String assetPath) async {
    final imageProvider = AssetImage(assetPath);
    final completer = Completer<ui.Image>();
    final config = ImageConfiguration();
    imageProvider.resolve(config).addListener(
      ImageStreamListener((info, _) => completer.complete(info.image)),
    );
    image = await completer.future;
    _generateTilePositions();
    setState(() {});
  }

  void _initializeTiles() {
    tileOrder = List.generate(gridSize * gridSize, (index) => index);
    tileOrder.shuffle(Random());
    setState(() {});
  }

  void _generateTilePositions() {
    if (image == null) return;
    final tileWidth = image!.width / gridSize;
    final tileHeight = image!.height / gridSize;

    tilePositions = {
      for (int i = 0; i < gridSize * gridSize; i++)
        i: Rect.fromLTWH(
          (i % gridSize) * tileWidth,
          (i ~/ gridSize) * tileHeight,
          tileWidth,
          tileHeight,
        )
    };
  }

  void _onTileDragged(int fromIndex, int toIndex) {
    setState(() {
      int temp = tileOrder[fromIndex];
      tileOrder[fromIndex] = tileOrder[toIndex];
      tileOrder[toIndex] = temp;
    });

    if (_isPuzzleSolved()) {
      _showWinDialog();
    }
  }

  bool _isPuzzleSolved() {
    for (int i = 0; i < tileOrder.length; i++) {
      if (tileOrder[i] != i) {
        return false;
      }
    }
    return true;
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF0c4767),
        title: Text("Gratulacje!", style: TextStyle(color: Color(0xFFEFA00B)),),
        content: Text("Ułożyłeś puzzle poprawnie!", style: TextStyle(color: Color(0xFFEFA00B))),
        actions: [
          Container(
            decoration: BoxDecoration(
            border: Border.all(color: Color(0xFFA3822A), width: 3), // Obramowanie
          ),
            child: Image(image: AssetImage("images/puzle_plaza.jpg"),),
          ),

          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text("OK", style: TextStyle(color: Color(0xFFEFA00B))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0c4767),
      appBar: AppBar(
        title: Text(
          "Odkryj Hasło",
          style: TextStyle(color: Color(0xFF0c4767), fontWeight: FontWeight.bold,),
        ),
        backgroundColor: Color(0xFF0c4767),
        iconTheme: IconThemeData(color: Color(0xFFEFA00B)),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Text("Ułóż Puzle!", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Color(0xFFEFA00B))),
          SizedBox(height: 10),
          Container(
            margin: EdgeInsets.all(8.0),
            padding: EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 4),
            ),
            child: AspectRatio(
              aspectRatio: 1,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridSize,
                ),
                itemCount: tileOrder.length,
                itemBuilder: (context, index) {
                  return _buildTile(index);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTile(int index) {
    if (image == null) return Container(color: Colors.grey, width: 100, height: 100);

    int tileIndex = tileOrder[index];
    Rect sourceRect = tilePositions[tileIndex]!;

    return DragTarget<int>(
      onWillAccept: (fromIndex) => true,
      onAccept: (fromIndex) {
        _onTileDragged(fromIndex, index);
      },
      builder: (context, candidateData, rejectedData) {
        return Draggable<int>(
          data: index,
          feedback: Opacity(
            opacity: 0.7,
            child: CustomPaint(
              size: Size(100, 100),
              painter: PuzzleTilePainter(image!, sourceRect),
            ),
          ),
          childWhenDragging: Container(
            color: Colors.grey,
            width: 100,
            height: 100,
          ),
          child: CustomPaint(
            size: Size(100, 100),
            painter: PuzzleTilePainter(image!, sourceRect),
          ),
        );
      },
    );
  }
}

class PuzzleTilePainter extends CustomPainter {
  final ui.Image image;
  final Rect sourceRect;

  PuzzleTilePainter(this.image, this.sourceRect);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    canvas.drawImageRect(
      image,
      sourceRect,
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}