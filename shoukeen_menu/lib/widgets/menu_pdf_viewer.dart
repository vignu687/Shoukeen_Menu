import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../models/menu_type.dart';

class MenuPdfViewer extends StatelessWidget {
  final MenuType selectedMenu;

  const MenuPdfViewer({
    super.key,
    required this.selectedMenu,
  });

  String? _pdfPathFor(MenuType type) {
    switch (type) {
      case MenuType.food:
        return 'assets/pdfs/food_menu.pdf';
      case MenuType.liquor:
        return 'assets/pdfs/liquor_menu.pdf';
      case MenuType.sheesha:
        return 'assets/pdfs/sheesha_menu.pdf';
      case MenuType.home:
        return null; // Home = no PDF
    }
  }

  @override
  Widget build(BuildContext context) {
    final pdfPath = _pdfPathFor(selectedMenu);

    if (pdfPath == null) {
      // HOME SCREEN
      return const Center(
        child: Text(
          'Shoukeen Menu',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
      );
    }

    return SfPdfViewer.asset(
      pdfPath,
    );
  }
}
