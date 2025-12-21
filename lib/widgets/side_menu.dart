import 'dart:ui';

import 'package:flutter/material.dart';
import '../models/menu_type.dart';

class SideMenu extends StatefulWidget {
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
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> with SingleTickerProviderStateMixin {
  MenuType? _hovered;
  MenuType? _focused;

  static const double _collapsedWidth = 64;
  static const double _labelMaxWidth = 96;
  static const double _itemHeight = 62;
  static const double _itemSpacing = 8;
  static const double _topPadding = 10;

  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 360));
    if (widget.visible) _ctrl.value = 1.0;
  }

  @override
  void didUpdateWidget(covariant SideMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visible) {
      _ctrl.forward();
    } else {
      _ctrl.reverse();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  int? get _selectedIndex {
    return widget.selectedMenu.index;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final topBottomPadding = isLandscape ? 50.0 : 200.0;
    
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
      left: widget.visible ? 6 : -(_collapsedWidth + 16),
      top: topBottomPadding,
      bottom: topBottomPadding,
      child: MouseRegion(
        onEnter: (_) => _ctrl.forward(),
        onExit: (_) {
          if (!widget.visible) _ctrl.reverse();
        },
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (context, _) {
            final width = lerpDouble(_collapsedWidth, _collapsedWidth + _labelMaxWidth, _ctrl.value)!;
            return Container(
              width: width,
              margin: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(18)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: _topPadding),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black.withOpacity(0.56), Colors.black.withOpacity(0.26)],
                      ),
                      border: Border.all(color: Colors.white.withOpacity(0.04)),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.6), blurRadius: 24, offset: const Offset(0, 10)),
                      ],
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final totalItemsHeight = 4 * _itemHeight + 3 * _itemSpacing;
                        final start = (constraints.maxHeight - totalItemsHeight) / 2;

                        return Stack(
                          children: [
                            Positioned(
                              top: start,
                              left: 0,
                              right: 0,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _buildItem(0, Icons.home, 'Home', MenuType.home),
                                  const SizedBox(height: _itemSpacing),
                                  _buildItem(1, Icons.restaurant, 'Food', MenuType.food),
                                  const SizedBox(height: _itemSpacing),
                                  _buildItem(2, Icons.local_bar, 'Liquor', MenuType.liquor),
                                  const SizedBox(height: _itemSpacing),
                                  _buildItem(3, Icons.smoking_rooms, 'Sheesha', MenuType.sheesha),
                                ],
                              ),
                            ),

                            if (_selectedIndex != null) ...[
                              AnimatedPositioned(
                                duration: const Duration(milliseconds: 280),
                                curve: Curves.easeOutCubic,
                                left: 8,
                                top: start + _selectedIndex! * (_itemHeight + _itemSpacing) + (_itemHeight - 44) / 2,
                                child: Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: RadialGradient(
                                      colors: [const Color(0xFFB89B3E).withOpacity(0.18), Colors.transparent],
                                      radius: 0.9,
                                    ),
                                  ),
                                ),
                              ),

                              AnimatedPositioned(
                                duration: const Duration(milliseconds: 260),
                                curve: Curves.easeOutCubic,
                                left: 6,
                                top: start + _selectedIndex! * (_itemHeight + _itemSpacing) + (_itemHeight - 28) / 2,
                                child: Container(
                                  width: 4,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFB89B3E),
                                    borderRadius: BorderRadius.circular(4),
                                    boxShadow: [
                                      BoxShadow(color: const Color(0xFFB89B3E).withOpacity(0.18), blurRadius: 10),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildItem(int index, IconData icon, String label, MenuType type) {
    final isActive = widget.selectedMenu == type;
    final isHover = _hovered == type;
    final isFocus = _focused == type;

    return Tooltip(
      message: label,
      child: FocusableActionDetector(
        onShowFocusHighlight: (focused) => setState(() => _focused = focused ? type : null),
        child: MouseRegion(
          onEnter: (_) => setState(() => _hovered = type),
          onExit: (_) => setState(() => _hovered = null),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => widget.onSelect(type),
              borderRadius: BorderRadius.circular(12),
              splashColor: Colors.white12,
              highlightColor: Colors.white10,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                width: double.infinity,
                height: _itemHeight,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: isActive
                      ? Colors.white.withOpacity(0.04)
                      : (isHover ? Colors.white.withOpacity(0.02) : Colors.transparent),
                  borderRadius: BorderRadius.circular(12),
                  border: isFocus ? Border.all(color: Colors.white24) : null,
                ),
                child: Row(
                  children: [
                    AnimatedScale(
                      duration: const Duration(milliseconds: 180),
                      scale: isHover || isActive ? 1.08 : 1.0,
                      child: Icon(icon, color: isActive ? const Color(0xFFB89B3E) : Colors.white70, size: 28),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      fit: FlexFit.loose,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: (_ctrl.value > 0.25 || isHover || isActive) ? _labelMaxWidth : 0,
                        curve: Curves.easeOutCubic,
                        constraints: BoxConstraints(maxWidth: _labelMaxWidth),
                        child: Opacity(
                          opacity: (_ctrl.value > 0.25 || isHover || isActive) ? 1 : 0,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(label, overflow: TextOverflow.ellipsis, style: TextStyle(color: isActive ? Colors.white : Colors.white70, fontWeight: isActive ? FontWeight.w700 : FontWeight.w500)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
