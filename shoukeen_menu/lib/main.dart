import 'package:flutter/material.dart';
import 'screens/shoukeen_screen.dart';

void main() {
  runApp(const ShoukeenMenuApp());
}

class ShoukeenMenuApp extends StatelessWidget {
  const ShoukeenMenuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ShoukeenScreen(),
    );
  }
}
