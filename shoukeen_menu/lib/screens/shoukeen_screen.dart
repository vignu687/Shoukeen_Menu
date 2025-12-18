import 'dart:async';
import 'package:flutter/material.dart';
import '../models/menu_type.dart';
import '../widgets/side_menu.dart';
import '../widgets/pdf_content.dart';
import '../widgets/bottom_home_bar.dart';

class ShoukeenScreen extends StatefulWidget {
  const ShoukeenScreen({super.key});

  @override
  State<ShoukeenScreen> createState() => _ShoukeenScreenState();
}

class _ShoukeenScreenState extends State<ShoukeenScreen> {
  MenuType currentMenu = MenuType.home;
  bool showMenu = true;
  Timer? hideTimer;

  void onMenuSelected(MenuType menu) {
    hideTimer?.cancel();

    setState(() {
      currentMenu = menu;
      showMenu = true;
    });

    if (menu != MenuType.home) {
      hideTimer = Timer(const Duration(seconds: 3), () {
        if (mounted) setState(() => showMenu = false);
      });
    }
  }

  void toggleMenuVisibility() {
    setState(() => showMenu = !showMenu);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onDoubleTap: toggleMenuVisibility,
        child: Stack(
          children: [
            // Background
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black,
                    Color(0xFF7A6116),
                  ],
                ),
              ),
            ),

            // Content
            Positioned.fill(
              left: showMenu ? 60 : 0,
              child: PdfContent(menuType: currentMenu),
            ),

            // Side Menu
            SideMenu(
              visible: showMenu,
              selectedMenu: currentMenu,
              onSelect: onMenuSelected,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomHomeBar(
        onHome: () => onMenuSelected(MenuType.home),
      ),
    );
  }
}
