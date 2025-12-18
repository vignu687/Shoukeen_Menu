import 'package:flutter/material.dart';

class BottomHomeBar extends StatelessWidget {
  final VoidCallback onHome;

  const BottomHomeBar({super.key, required this.onHome});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: Color(0xFF1A0F1E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: IconButton(
        icon: const Icon(Icons.home, color: Colors.white),
        onPressed: onHome,
      ),
    );
  }
}
