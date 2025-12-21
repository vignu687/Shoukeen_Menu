// import 'package:flutter/material.dart';
// import '../models/menu_type.dart';
//
// class MenuContent extends StatelessWidget {
//   final MenuType menuType;
//
//   const MenuContent({super.key, required this.menuType});
//
//   @override
//   Widget build(BuildContext context) {
//     switch (menuType) {
//       case MenuType.home:
//         return _buildHome();
//       case MenuType.food:
//         return _buildPlaceholder('Food Menu');
//       case MenuType.drinks:
//         return _buildPlaceholder('Drinks Menu');
//       case MenuType.dessert:
//         return _buildPlaceholder('Dessert Menu');
//       default:
//         return _buildPlaceholder('Menu');
//     }
//   }
//
//   Widget _buildHome() {
//     return const Center(
//       child: Text(
//         'SHOUKEEN',
//         style: TextStyle(
//           fontSize: 42,
//           fontWeight: FontWeight.bold,
//           color: Colors.white,
//           letterSpacing: 3,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPlaceholder(String title) {
//     return Center(
//       child: Text(
//         title,
//         style: const TextStyle(
//           fontSize: 28,
//           color: Colors.white70,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//     );
//   }
// }
