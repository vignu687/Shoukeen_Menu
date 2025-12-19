import 'dart:async';
import 'package:flutter/material.dart';
import '../models/menu_type.dart';
import '../widgets/side_menu.dart';
import '../widgets/menu_image_content.dart';
import '../widgets/bottom_home_bar.dart';

class ShoukeenScreen extends StatefulWidget {
  const ShoukeenScreen({super.key});

  @override
  State<ShoukeenScreen> createState() => _ShoukeenScreenState();
}

class _ShoukeenScreenState extends State<ShoukeenScreen>
    with SingleTickerProviderStateMixin {
  MenuType currentMenu = MenuType.home;
  bool showMenu = true;
  Timer? hideTimer;

  late AnimationController _gradientController;
  late Animation<Color?> _topColor;
  late Animation<Color?> _bottomColor;

  @override
  void initState() {
    super.initState();

    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);

    _topColor = ColorTween(
      begin: Colors.black,
      end: const Color(0xFF2C2206), // dark gold
    ).animate(_gradientController);

    _bottomColor = ColorTween(
      begin: const Color(0xFF7A6116),
      end: const Color(0xFFB89B3E), // warm gold
    ).animate(_gradientController);
  }

  @override
  void dispose() {
    _gradientController.dispose();
    hideTimer?.cancel();
    super.dispose();
  }

  void onMenuSelected(MenuType menu) {
    hideTimer?.cancel();

    setState(() {
      currentMenu = menu;
      showMenu = true;
    });

    if (menu != MenuType.home) {
      hideTimer = Timer(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() => showMenu = false);
        }
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
        child: AnimatedBuilder(
          animation: _gradientController,
          builder: (context, _) {
            return Stack(
              children: [
                // ===== ANIMATED BACKGROUND GRADIENT =====
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        _topColor.value ?? Colors.black,
                        _bottomColor.value ?? const Color(0xFF7A6116),
                      ],
                    ),
                  ),
                ),

                // ===== MENU CONTENT (PNG BASED) =====
                Positioned.fill(
                  left: showMenu ? 60 : 0,
                  child: MenuImageContent(menuType: currentMenu),
                ),

                // ===== SIDE MENU =====
                SideMenu(
                  visible: showMenu,
                  selectedMenu: currentMenu,
                  onSelect: onMenuSelected,
                ),
              ],
            );
          },
        ),
      ),

      // ===== BOTTOM HOME BAR =====
      bottomNavigationBar: BottomHomeBar(
        onHome: () => onMenuSelected(MenuType.home),
      ),
    );
  }
}
