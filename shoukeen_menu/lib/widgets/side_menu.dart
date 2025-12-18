import 'package:flutter/material.dart';
import '../models/menu_type.dart';

class SideMenu extends StatelessWidget {
  final bool visible;
  final MenuType selectedMenu;
  final Function(MenuType) onSelect;

  const SideMenu({
    super.key,
    required this.visible,
    required this.selectedMenu,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 250),
      left: visible ? 0 : -60,
      top: 0,
      bottom: 70,
      child: Container(
        width: 60,
        color: Colors.black.withOpacity(0.4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _item("Food", MenuType.food),
            _item("Liquor", MenuType.liquor),
            _item("Sheesha", MenuType.sheesha),
          ],
        ),
      ),
    );
  }

  Widget _item(String title, MenuType type) {
    final bool isActive = selectedMenu == type;

    return GestureDetector(
      onTap: () => onSelect(type),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: RotatedBox(
          quarterTurns: -1,
          child: Text(
            title,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.white70,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
