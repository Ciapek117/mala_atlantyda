import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';

import 'package:mala_atlantyda/Widgets/AnimatedScreen.dart';
import './UserPage.dart';
import '../Widgets/CustomTextField.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('❌ Dostęp do lokalizacji został odrzucony.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('❌ Dostęp do lokalizacji został trwale odrzucony.');
      return;
    }

    print('✅ Uprawnienia lokalizacji przyznane.');
  }

  Future<void> login(String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: "grupa1@gmail.com", // Tutaj wpisujesz stały email
        password: password, // Hasło wprowadzone przez użytkownika
      );
      print("✅ Zalogowano: ${userCredential.user!.email}");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => UserPage()));
    } catch (e) {
      print("❌ Błąd logowania: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/tlo.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Transform.scale(
                scale: 1.8,
                child: Image.asset("images/trojzab.png", fit: BoxFit.cover),
              ),
            ),
            Positioned.fill(
              child: Transform.scale(
                scale: 1.0,
                child: Image.asset(
                    "images/mala_atlantyda.png", fit: BoxFit.cover),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: 60),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 230,
                      child: CustomTextField(
                          hint: "Enter Password",
                          label: "Password",
                          isPassword: true,
                          color: Color(0xFFADE8F4)
                      ),
                    ),
                    SizedBox(height: 5),
                    SizedBox(
                      width: 230,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff00bbc2),
                        ),
                        child: Text(
                          "Zaloguj się",
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.white,
                              fontSize: 20
                          ),
                        ),
                        onPressed: () => login("6TVB9L"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
