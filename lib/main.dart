import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import './auth/LoginUser.dart';

import './pages/JigsawPuzzlePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Inicjalizacja Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PuzzleApp(), //LoginScreen()
    );
  }
}