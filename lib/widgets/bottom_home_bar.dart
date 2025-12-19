import 'package:flutter/material.dart';

class BottomHomeBar extends StatelessWidget {
  final VoidCallback onHome;

  const BottomHomeBar({
    super.key,
    required this.onHome,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: Colors.black,
      child: Center(
        child: GestureDetector(
          onTap: onHome,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white70, width: 1.5),
            ),
            child: const Icon(
              Icons.home,
              color: Colors.white,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }
}
