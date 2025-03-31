import 'package:flutter/material.dart';
import 'package:mala_atlantyda/Widgets/animations/fadeRoute.dart';
import 'package:mala_atlantyda/Widgets/animations/mixRoute.dart';
import 'package:mala_atlantyda/Widgets/animations/slideRoute.dart';
import '../auth/UserPage.dart';

class AnimatedScreen extends StatefulWidget {
  @override
  _AnimatedScreenState createState() => _AnimatedScreenState();
}

class _AnimatedScreenState extends State<AnimatedScreen> {
  bool _showTrident = false;
  bool _showUI = false;
  bool _isLoggedIn = false;
  bool _tridentGoesUp = false;

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

  void _login() {
    setState(() {
      _isLoggedIn = true;
    });

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _tridentGoesUp = true;
      });
    });

    Future.delayed(Duration(milliseconds: 1500), () {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.of(context).pushReplacement(mixRoute(UserPage()));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

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
            AnimatedPositioned(
              duration: Duration(seconds: 1),
              curve: Curves.easeOut,
              bottom: _tridentGoesUp
                  ? screenHeight + 100
                  : (_showTrident ? screenHeight / 2 - 230 : -600),
              left: 0,
              right: 0,
              child: Transform.scale(
                scale: 2.7,
                child: Image.asset("images/trojzab.png", fit: BoxFit.cover),
              ),
            ),

            Positioned.fill(
              child: Transform.scale(
                scale: 1.0,
                child: Image.asset("images/mala_atlantyda.png", fit: BoxFit.cover),
              ),
            ),

            Center(
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 500),
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
                          onPressed: _login,
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
