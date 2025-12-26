import 'dart:async';
import 'package:flutter/material.dart';

import '../models/menu_type.dart';
import '../widgets/side_menu.dart';
import '../widgets/menu_image_content.dart';
import '../widgets/startup_video.dart';
import '../widgets/mosaic_background.dart';
import '../utils/route_observer.dart';

class ShoukeenScreen extends StatefulWidget {
  const ShoukeenScreen({super.key});

  @override
  State<ShoukeenScreen> createState() => _ShoukeenScreenState();
}

class _ShoukeenScreenState extends State<ShoukeenScreen> with RouteAware {
  MenuType currentMenu = MenuType.home;
  bool showMenu = true;
  Timer? hideTimer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    hideTimer?.cancel();
    routeObserver.unsubscribe(this);
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
        if (mounted) setState(() => showMenu = false);
      });
    }
  }

  void toggleMenuVisibility() {
    setState(() => showMenu = !showMenu);
  }

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold(
      body: GestureDetector(
        onDoubleTap: toggleMenuVisibility,
        child: Stack(
          children: [
            // 🔥 MOSAIC BACKGROUND (FULL SCREEN)
            MosaicBackground(
              images: const [
                'assets/images/logo/bg1.jpeg',
                'assets/images/logo/bg2.jpeg',
                'assets/images/logo/bg3.jpeg',
                'assets/images/logo/bg4.jpeg',
              ],
            ),

            // MENU CONTENT
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              left: showMenu ? 64 : 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: MenuImageContent(menuType: currentMenu),
            ),

            // SIDE MENU
            SideMenu(
              visible: showMenu,
              selectedMenu: currentMenu,
              onSelect: onMenuSelected,
            ),
          ],
        ),
      ),
    );

    // 🎬 STARTUP VIDEO (PLAYS ONCE)
    return StartupVideo(
      assetPath: 'assets/images/video/video.mp4',
      maxDuration: const Duration(seconds: 15),
      child: scaffold,
    );
  }
}
