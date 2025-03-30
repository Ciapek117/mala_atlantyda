import 'package:flutter/material.dart';

PageRouteBuilder slideRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0); // Start na dole ekranu
      const end = Offset.zero; // Kończy w normalnym miejscu
      const curve = Curves.easeOut; // Łagodna animacja

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
    transitionDuration: Duration(milliseconds: 1000), // Czas przejścia
  );
}
