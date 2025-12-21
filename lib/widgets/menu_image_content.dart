import 'package:flutter/material.dart';
import '../models/menu_type.dart';

class MenuImageContent extends StatelessWidget {
  final MenuType menuType;

  const MenuImageContent({super.key, required this.menuType});

  List<String> _getImages() {
    switch (menuType) {
      case MenuType.food:
        return const [
          'assets/images/food/food_menu_1.png',
          'assets/images/food/food_menu_2.png',
          'assets/images/food/food_menu_3.png',
        ];

      case MenuType.liquor:
        return const [
          'assets/images/liquor/liquor_menu_1.png',
          'assets/images/liquor/liquor_menu_2.png',
          'assets/images/liquor/liquor_menu_3.png',
        ];

      case MenuType.sheesha:
        return const [
          'assets/images/sheesha/sheesha_menu_1.png',
          'assets/images/sheesha/sheesha_menu_2.png',
        ];

      case MenuType.home:
        return const [];
    }
  }

  @override
  Widget build(BuildContext context) {
    if (menuType == MenuType.home) {
      // return const Center(
      //   child: Text(
      //     // 'Shoukeen\nPremium Indian Lounge',
      //     textAlign: TextAlign.center,
      //     style: TextStyle(
      //       color: Colors.white70,
      //       fontSize: 26,
      //     ),
      //   ),
      // );
    }

    final images = _getImages();

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: images.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: InteractiveViewer(
            minScale: 1,
            maxScale: 3,
            child: Image.asset(
              images[index],
              fit: BoxFit.fitWidth,
            ),
          ),
        );
      },
    );
  }
}
