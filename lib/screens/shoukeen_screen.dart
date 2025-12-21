import 'dart:async';
import 'package:flutter/material.dart';
import '../models/menu_type.dart';
import '../widgets/side_menu.dart';
import '../widgets/menu_image_content.dart';
import '../widgets/bottom_home_bar.dart';
import '../widgets/startup_video.dart';
import '../utils/route_observer.dart';

class ShoukeenScreen extends StatefulWidget {
  const ShoukeenScreen({super.key});

  @override
  State<ShoukeenScreen> createState() => _ShoukeenScreenState();
}

class _ShoukeenScreenState extends State<ShoukeenScreen>
    with SingleTickerProviderStateMixin, RouteAware {
  MenuType currentMenu = MenuType.home;
  bool showMenu = true;
  Timer? hideTimer;
  double _bgOverlayOpacity = 0.0;

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPush() {
    // screen was pushed
  }

  @override
  void didPopNext() {
    // returned to this screen
  }

  void onMenuSelected(MenuType menu) {
    hideTimer?.cancel();

    setState(() {
      currentMenu = menu;
      showMenu = true;
      // flash overlay to smooth the transition between menus
      _bgOverlayOpacity = 0.12;
    });

    // fade overlay back out shortly after
    Future.delayed(const Duration(milliseconds: 220), () {
      if (mounted) setState(() => _bgOverlayOpacity = 0.0);
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
    final scaffold = Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onDoubleTap: toggleMenuVisibility,
        child: AnimatedBuilder(
          animation: _gradientController,
          builder: (context, _) {
            return Stack(
              children: [
                // ===== BACKGROUND IMAGE =====
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/logo/entry.jpeg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // ===== ANIMATED BACKGROUND GRADIENT =====
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        (_topColor.value ?? Colors.black).withOpacity(0.3),
                        (_bottomColor.value ?? const Color(0xFF7A6116)).withOpacity(0.3),
                      ],
                    ),
                  ),
                ),

                // ===== MENU CONTENT (PNG BASED) =====
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  left: showMenu ? 64 : 0,
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: MenuImageContent(menuType: currentMenu),
                ),

                // subtle overlay when menu changes to soften transition
                Positioned.fill(
                  child: IgnorePointer(
                    ignoring: true,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: _bgOverlayOpacity,
                      child: Container(
                        color: Colors.black,
                      ),
                    ),
                  ),
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

    return StartupVideo(assetPath: 'assets/images/video/video.mp4', maxDuration: const Duration(seconds: 15), child: scaffold);
  }
}
