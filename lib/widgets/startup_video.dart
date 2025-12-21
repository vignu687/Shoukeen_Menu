import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class StartupVideo extends StatefulWidget {
  final Widget child;
  final String assetPath;
  final Duration maxDuration;

  const StartupVideo({super.key, required this.child, required this.assetPath, this.maxDuration = const Duration(seconds: 6)});

  @override
  State<StartupVideo> createState() => _StartupVideoState();
}

class _StartupVideoState extends State<StartupVideo> {
  VideoPlayerController? _controller;
  bool _visible = true;
  bool _initializing = true;
  bool _buffering = true;

  @override
  void initState() {
    super.initState();
    try {
      final c = VideoPlayerController.asset(widget.assetPath);
      _controller = c;
      _controller!.setLooping(false);

      _controller!.initialize().then((_) {
        if (!mounted) return;
        setState(() {
          _initializing = false;
        });
        // start playback after a tiny delay to allow first frame
        Future.delayed(const Duration(milliseconds: 120), () {
          if (mounted && _controller != null) _controller!.play();
        });
      }).catchError((e) {
        // if platform implementation missing or init fails, skip video
        if (mounted) setState(() => _visible = false);
      });

      _controller!.addListener(() {
        final controller = _controller;
        if (controller == null || !controller.value.isInitialized) return;
        final val = controller.value;
        final isBuffering = val.isBuffering;
        if (isBuffering != _buffering) {
          setState(() => _buffering = isBuffering);
        }
        if (val.position >= val.duration) {
          if (mounted) setState(() => _visible = false);
        }
      });
    } catch (e) {
      // plugin not available on this platform or other init error
      _controller = null;
      _visible = false;
    }

    // safety timeout
    Timer(widget.maxDuration, () {
      if (mounted && _visible) setState(() => _visible = false);
    });
  }

  @override
  void dispose() {
    try {
      if (_controller != null) {
        try {
          _controller!.removeListener(() {});
        } catch (_) {}
        try {
          _controller!.dispose();
        } catch (_) {}
      }
    } catch (_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_visible)
          Positioned.fill(
            child: AnimatedOpacity(
              opacity: _visible ? 1 : 0,
              duration: const Duration(milliseconds: 500),
              child: ColoredBox(
                color: Colors.black,
                child: Stack(
                  children: [
                    Center(
                      child: _initializing || _controller == null || !_controller!.value.isInitialized
                          ? const SizedBox.shrink()
                          : AspectRatio(
                              aspectRatio: _controller!.value.aspectRatio,
                              child: VideoPlayer(_controller!),
                            ),
                    ),

                    // buffering indicator
                    if (_initializing || _buffering)
                      const Center(
                        child: CircularProgressIndicator(color: Colors.white70),
                      ),

                    // skip button
                    Positioned(
                      right: 18,
                      top: 34,
                      child: SafeArea(
                        child: TextButton(
                          style: TextButton.styleFrom(foregroundColor: Colors.white70, backgroundColor: Colors.black38),
                          onPressed: () {
                            // stop and hide
                            if (_controller != null) {
                              try {
                                _controller!.pause();
                              } catch (_) {}
                            }
                            setState(() => _visible = false);
                          },
                          child: const Text('Skip'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
