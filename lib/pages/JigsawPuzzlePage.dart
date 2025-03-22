import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:async';
import 'dart:math';

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Puzzle Game")),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
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
          ElevatedButton(
            onPressed: _initializeTiles,
            child: Text("Shuffle"),
          ),
        ],
      ),
    );
  }

  Widget _buildTile(int index) {
    if (image == null) return Container(color: Colors.grey, width: 100, height: 100);

    int tileIndex = tileOrder[index];
    Rect sourceRect = tilePositions[tileIndex]!;

    return Draggable<int>(
      data: index,
      child: DragTarget<int>(
        onAccept: (fromIndex) {
          _onTileDragged(fromIndex, index);
        },
        builder: (context, candidateData, rejectedData) {
          return CustomPaint(
            size: Size(100, 100),
            painter: PuzzleTilePainter(image!, sourceRect),
          );
        },
      ),
      feedback: CustomPaint(
        size: Size(100, 100),
        painter: PuzzleTilePainter(image!, sourceRect),
      ),
      childWhenDragging: Container(
        color: Colors.grey,
        width: 100,
        height: 100,
      ),
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
    return false;
  }
}
