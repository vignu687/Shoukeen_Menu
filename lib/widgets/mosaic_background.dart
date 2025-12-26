import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class MosaicBackground extends StatefulWidget {
  final List<String> images;

  const MosaicBackground({
    super.key,
    required this.images,
  });

  @override
  State<MosaicBackground> createState() => _MosaicBackgroundState();
}

class _MosaicBackgroundState extends State<MosaicBackground> {
  final Random _random = Random();
  Timer? _timer;

  late List<String> _currentImages;

  @override
  void initState() {
    super.initState();

    _currentImages = _pickImages(3);

    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      setState(() {
        _currentImages = _pickImages(3);
      });
    });
  }

  List<String> _pickImages(int count) {
    return List.generate(
      count,
          (_) => widget.images[_random.nextInt(widget.images.length)],
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;

    // ================= LANDSCAPE =================
    if (orientation == Orientation.landscape) {
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 900),
        child: Image.asset(
          _currentImages.first,
          key: ValueKey(_currentImages.first),
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }

    // ================= PORTRAIT =================
    return Column(
      children: List.generate(3, (index) {
        return Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 900),
            child: Image.asset(
              _currentImages[index],
              key: ValueKey(_currentImages[index]),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        );
      }),
    );
  }
}
