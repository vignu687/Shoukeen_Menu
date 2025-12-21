import 'package:flutter/material.dart';
import 'package:shoukeen_menu/screens/shoukeen_screen.dart';
// import 'screens/splash_screen.dart';
import 'utils/route_observer.dart';

void main() {
  runApp(const ShoukeenMenuApp());
}

class ShoukeenMenuApp extends StatelessWidget {
  const ShoukeenMenuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorObservers: [routeObserver],
      home: const ShoukeenScreen(),
    );
  }
}
