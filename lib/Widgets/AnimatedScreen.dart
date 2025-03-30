import 'package:flutter/material.dart';
import 'package:mala_atlantyda/Widgets/animations/fadeRoute.dart';
import 'package:mala_atlantyda/Widgets/animations/mixRoute.dart';

import '../auth/UserPage.dart';
import 'animations/slideRoute.dart';

class AnimatedScreen extends StatefulWidget {
  @override
  _AnimatedScreenState createState() => _AnimatedScreenState();
}

class _AnimatedScreenState extends State<AnimatedScreen> {
  bool _showTrident = false;
  bool _showUI = false;
  bool _isLoggedIn = false;
  bool _tridentGoesUp = false; // Nowa flaga dla trójzęba

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 1000), () {
      setState(() {
        _showTrident = true;
      });
    });

    Future.delayed(Duration(milliseconds: 2500), () {
      setState(() {
        _showUI = true;
      });
    });
  }

  PageRouteBuilder fadeRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration: Duration(milliseconds: 1000), // Czas trwania animacji
    );
  }

  void _login() {
    setState(() {
      _isLoggedIn = true; // Ukrywa UI
    });

    // Po 0.5 sekundy trójząb zaczyna lecieć do góry
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _tridentGoesUp = true;
      });
    });

    // Po 1.5 sekundy (po zakończeniu animacji) przejście do UserPage
    Future.delayed(Duration(milliseconds: 1500), () {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.of(context).pushReplacement(fadeRoute(UserPage()));
        }
      });
    });
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
            // Trójząb - animacja z dołu na środek, potem do góry po zalogowaniu
            AnimatedPositioned(
              duration: Duration(seconds: 1),
              curve: Curves.easeOut,
              bottom: _tridentGoesUp
                  ? MediaQuery.of(context).size.height // Przesuwa trójząb do góry
                  : (_showTrident ? MediaQuery.of(context).size.height / 2 - 200 : -200),
              left: 0,
              right: 0,
              child: Transform.scale(
                scale: 1.8,
                child: Image.asset("images/trojzab.png", fit: BoxFit.cover),
              ),
            ),

            // Mała Atlantyda - zawsze widoczna
            Positioned.fill(
              child: Transform.scale(
                scale: 1.0,
                child: Image.asset("images/mala_atlantyda.png", fit: BoxFit.cover),
              ),
            ),

            // UI - TextField i przycisk, które szybko znikają po zalogowaniu
            Center(
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 500), // UI szybciej znika
                opacity: _isLoggedIn ? 0.0 : (_showUI ? 1.0 : 0.0),
                child: Padding(
                  padding: EdgeInsets.only(top: 60),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 230,
                        child: TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "Enter Password",
                            labelText: "Password",
                            labelStyle: TextStyle(color: Color(0xFFADE8F4)),
                          ),
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
                              fontSize: 20,
                            ),
                          ),
                          onPressed: _login, // Uruchamia animację po kliknięciu
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
