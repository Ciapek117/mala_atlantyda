import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './UserPage.dart';

import '../Widgets/CustomTextField.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> login(String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: "grupa1@gmail.com", // Tutaj wpisujesz stały email
        password: password, // Hasło wprowadzone przez użytkownika
      );
      print("✅ Zalogowano: ${userCredential.user!.email}");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserPage()));
    } catch (e) {
      print("❌ Błąd logowania: $e");
    }
  }


  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF0c4767),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            Image.asset('images/logoM_A.png', fit: BoxFit.cover, height: 300,),
            Text(
              "Wpisz hasło grupy",
              style: GoogleFonts.kanit(
                textStyle: const TextStyle(
                  color: Color(0xFF0c4767),
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 20),
            CustomTextField(
              hint: "Enter Password",
              label: "Password",
              //controller: _password,
              isPassword: true,
              color: Color(0xFFADE8F4)
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: (Text("Zaloguj się")),
              onPressed: () => login("6TVB9L"),
            ),
            const SizedBox(height: 5),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const SizedBox(height: 30),
              /*
              const Text("Don't have an account yet? ", style: TextStyle(color: Colors.white),),

              InkWell(
                //onTap: () => goToSignup(context),
                child:
                const Text("Signup", style: TextStyle(color: Color(0xFFD2AF43))),
              )
              */
            ]),
            const Spacer()
          ],
        ),
      ),
    );
  }}
