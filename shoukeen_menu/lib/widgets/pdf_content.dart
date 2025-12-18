import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../models/menu_type.dart';

class PdfContent extends StatelessWidget {
  final MenuType menuType;

  const PdfContent({super.key, required this.menuType});

  @override
  Widget build(BuildContext context) {
    if (menuType == MenuType.home) {
      return const Center(
        child: Text(
          "Shoukeen\nPremium Indian Lounge",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 26,
          ),
        ),
      );
    }

    final pdfPath = _getPdfPath(menuType);

    return SfPdfViewer.asset(
      pdfPath,
      key: ValueKey(pdfPath), // 🔥 forces reload
      canShowScrollHead: false,
      canShowScrollStatus: false,
    );
  }

  String _getPdfPath(MenuType type) {
    switch (type) {
      case MenuType.food:
        return 'assets/pdfs/food_menu.pdf';
      case MenuType.liquor:
        return 'assets/pdfs/liquor_menu.pdf';
      case MenuType.sheesha:
        return 'assets/pdfs/sheesha_menu.pdf';
      case MenuType.home:
        return '';
    }
  }
}
